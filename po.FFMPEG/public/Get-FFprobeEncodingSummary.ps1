function Get-FFprobeEncodingSummary {
    <#
    .DESCRIPTION
        Builds a summary of MPEG properties for the file (frame size, video codec, audio streams, etc...).

    .OUTPUTS
        A Hashtable containing the properties.

    .PARAMETER File
        REQUIRED. String. Alias: -f. The fully-qualified file path of an MPEG file.

    .EXAMPLE
        Get-FFprobeEncodingSummary -FilePath 'C:\myfile.mp4'

    .EXAMPLE
        Get-FFprobeEncodingSummary -f 'C:\myfile.mp4'
    #>
    [OutputType([Hashtable])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)] [Alias('f')] [String] $File
    )

    process {

        try {

            Write-Msg -FunctionCall -IncludeParameters

            [Hashtable] $es = @{ }
                        $es.Features = @()

            $r = Invoke-FFprobeCommand -File $File
            if ( $r.success ) {
                $v = $r.value | ConvertFrom-JSON
            }
            
            if ( Test-IsSomething($v.format) ) {
                $es.Duration = [int][math]::Round($v.format.duration)
                $es.BitRate  = [int]($v.format.bit_rate)
            }

            if ( Test-IsSomething($v.streams) ) {

                foreach ( $stream in $v.streams ) {
                    $stream | Out-File -LiteralPath $( $File + '.txt' ) -Append
                    if ( Test-IsSomething($stream.codec_name) ) {

                        switch -Wildcard ( $stream.codec_name ) {
                            'bin_data'  { $es.Features += 'chapters' }
                            'mov_text'  { $es.Features += 'subtitles' }
                            'eia_608'   { $es.Features += 'closedCaptions' }
                            'mjpeg'     { $es.Features += 'coverArt' }
                            'png'       { $es.Features += 'coverArt' }
                            'aac'       {
                                            if ( $null -eq $es.AudioFormat ) {
                                                $es.AudioCodecName = $($stream.codec_name)
                                                $es.AudioCodecDesc = $($stream.codec_long_name)
                                                $es.AudioCodecTag  = $($stream.codec_tag_string)
                                                $es.AudioFormat    = $($stream.channel_layout)
                                                $es.AudioChannels  = $([int]$stream.channels)
                                                $es.AudioEncoder   = $($stream.tags.handler_name ?? $stream.tags.encoder)
                                            }
                                            $es.Features += $('{0}:{1}' -f $($stream.codec_name.ToUpper()),
                                                                           $($stream.channel_layout))
                                        }
                            '*ac3'      {
                                            $es.AudioCodecName = $($stream.codec_name)
                                            $es.AudioCodecDesc = $($stream.codec_long_name)
                                            $es.AudioCodecTag  = $($stream.codec_tag_string)
                                            $es.AudioFormat    = $($stream.channel_layout)
                                            $es.AudioChannels  = $([int]$stream.channels)
                                            $es.AudioEncoder   = $($stream.tags.handler_name ?? $stream.tags.encoder)
                                            $es.Features      += $('{0}:{1}' -f $($stream.codec_name.ToUpper()),
                                                                                $($stream.channel_layout))
                                        }
                            'h26*'      {
                                            $es.Features        += $($stream.codec_name)
                                            $es.VideoCodecName   = $($stream.codec_name)
                                            $es.VideoCodecDesc   = $($stream.codec_long_name)
                                            $es.VideoCodecTag    = $($stream.codec_tag_string)
                                            $es.VideoFrameWidth  = $($stream.width)
                                            $es.VideoFrameHeight = $($stream.height)
                                            $es.VideoProfile     = $($stream.profile)
                                            $es.VideoLevel       = $($stream.level)
                                            $es.VideoBFrames     = $($stream.has_b_frames)
                                            $es.VideoColorSpace  = $($stream.color_space)
                                            $es.VideoFrameHeight = $($stream.height)
                                            if ( $stream.display_aspect_ratio ) {
                                                $ratio = $stream.display_aspect_ratio -split ':'
                                                $es.VideoAspectRatio = [Math]::Round(([int]$ratio[0] / [int]$ratio[1]),2)
                                            }
                                            else {
                                                $es.VideoAspectRatio = [Math]::Round(([int]$stream.width / [int]$stream.height),2)
                                            }
                                            $es.VideoEncoder = $($stream.tags.handler_name ?? $stream.tags.encoder)
                                        }
                        }

                    } else {

                        switch ( $stream.codec_type ) {
                            'data'      { $es.Features += 'subtitles' }
                            'subtitle'  { $es.Features += 'closedCaptions' }
                            'audio'     {
                                            $es.AudioCodecName = $('drm')
                                            $es.AudioCodecDesc = $('DRM Encoded Audio Stream')
                                            $es.AudioCodecTag  = $($stream.codec_tag_string)
                                            $es.AudioFormat    = $($stream.channel_layout)
                                            $es.AudioChannels  = $([int]$stream.channels)
                                            $es.AudioEncoder   = $($stream.tags.handler_name ?? $stream.tags.encoder)
                                            $es.Features      += $('AC3:{0}' -f $($stream.channel_layout))
                                        }
                            'video'     {
                                            $es.Features        += $('h264drm')
                                            $es.VideoCodecName   = $('drm')
                                            $es.VideoCodecDesc   = $('DRM Encoded Video Stream')
                                            $es.VideoCodecTag    = $($stream.codec_tag_string)
                                            $es.VideoFrameWidth  = $($stream.width)
                                            $es.VideoFrameHeight = $($stream.height)
                                            $es.VideoProfile     = $($stream.profile)
                                            $es.VideoLevel       = $($stream.level)
                                            $es.VideoBFrames     = $($stream.has_b_frames)
                                            $es.VideoColorSpace  = $($stream.color_space)
                                            $es.VideoFrameHeight = $($stream.height)
                                            if ( $stream.display_aspect_ratio ) {
                                                $ratio = $stream.display_aspect_ratio -split ':'
                                                $es.VideoAspectRatio = [Math]::Round(([int]$ratio[0] / [int]$ratio[1]),2)
                                            }
                                            else {
                                                $es.VideoAspectRatio = [Math]::Round(([int]$stream.width / [int]$stream.height),2)
                                            }
                                            $es.VideoEncoder = $($stream.tags.handler_name ?? $stream.tags.encoder)
                                    }

                        }

                    }

                }
                
            }
            
        }
        catch {
            Write-Msg -x -o $_
            $r = @{ success = $false; message = $_.Exception.Message; value = $null }
        }

        Write-Msg -FunctionResult -o $( $r.success ? $es : $r.message ) -MaxRecursionDepth 5

        return @{ success = $r.success; value = $es; message = $r.message }

    }

}
