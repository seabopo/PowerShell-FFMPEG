Function Add-FFmpegStreamSummary {
    <#
    .DESCRIPTION
        Adds a summary of the data provided by the FFMPEG stream data.
    
    .OUTPUTS
        None. Updates the existing PSCustomObject instance.

    .PARAMETER MPEGdata
        REQUIRED. MPEGdata. Alias: -d. An PSCustomObject that contains a 'streams' property populated 
        with FFPROBE stream data.

    .EXAMPLE
        Add-FFmpegStreamSummary -MPEGdata $d
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)] [Alias('d')] [PSCustomObject] $MPEGdata
    )

    process {

        Write-Msg -FunctionCall -IncludeParameters
        
        $m = $MPEGdata

        $m.DrmProtected = $false
        $m.Features     = [String[]] @()
        $m.Video        = @{ }
        $m.Audio        = @{ }
        $m.Art          = @{ }

        foreach ( $s in $m.streams ) {

            $setAudio = $false
            $encoder  = @(($s.tags.'handler_name')) | Where-Object { $null -ne $_ } |
                        ForEach-Object { 
                            $_ -like "*GPAC*" ? 'GPAC' : ($_ -split ' ')[0]
                        }

            if ( Test-IsSomething($s.codec_name) ) {

                switch -Wildcard ( $s.codec_name ) {
                    'bin_data'  { $m.Features += 'chapters'       }
                    'mov_text'  { $m.Features += $('subtitles({0})' -f $s.tags.language) }
                    'eia_608'   { $m.Features += $('closedCaptions({0})' -f $s.tags.language) }
                    'mjpeg'     { 
                                  $m.Features       += 'coverArt'
                                  $m.Art.Format      = 'jpeg'
                                  $m.Art.Width       = [int]$s.Width
                                  $m.Art.Height      = [int]$s.Height
                                  $m.Art.Ratio       = [math]::Round(([int]$m.Art.Width / [int]$m.Art.Height),2)
                                  $m.Art.Orientation = ([math]::Abs($m.Art.Ratio - 1.0) -le 0.02) ? `
                                                       'Square' : ( $m.Art.Width -gt $m.Art.Height ? 'wide' : 'tall' )
                                }
                    'png'       { 
                                  $m.Features       += 'coverArt'
                                  $m.Art.Format      = 'png'
                                  $m.Art.Width       = [int]$s.Width
                                  $m.Art.Height      = [int]$s.Height
                                  $m.Art.Ratio       = [math]::Round(([int]$m.Art.Width / [int]$m.Art.Height),2)
                                  $m.Art.Orientation = ([math]::Abs($m.Art.Ratio - 1.0) -le 0.02) ? `
                                                       'Square' : ( $m.Art.Width -gt $m.Art.Height ? 'wide' : 'tall' )
                                }
                    'aac'       { if ( $null -eq $m.Audio.Format ) { $setAudio = $true } }
                    '*ac3'      { if ( $null -eq $m.Audio.Format -or $m.Audio.Codec -eq 'aac' ) { $setAudio = $true } }
                    '*ac*'      { 
                                  if ( $setAudio = $true ) {
                                      $m.Audio.Codec      = $($s.codec_name)
                                      $m.Audio.Format     = $($s.channel_layout)
                                      $m.Audio.FormatName = $($s.codec_long_name)
                                      $m.Audio.Channels   = $([int]$s.channels)
                                      $m.Audio.FormatTag  = ($m.Audio.Codec -eq 'ac3') ? 'DD' : `
                                                            (($m.Audio.Codec -eq 'eac3') ? 'DD+' : 'DS')
                                      $m.Audio.Encoder    = ($s.tags.'handler_name' -like "*GPAC*") ? `
                                                            'GPAC' : ($s.tags.'handler_name' -split ' ')[0]
                                      $m.Features        += $('{0}:{1}' -f $($s.codec_name.ToUpper()),
                                                                           $($s.channel_layout))
                                  }
                                }
                    'h26*'      {
                                  $m.Features               += $($s.codec_name)
                                  $m.Video.Codec             = $($s.codec_name)
                                  $m.Video.CodecID           = $($s.codec_tag_string)
                                  $m.Video.ColorSpace        = $($s.color_space)
                                  $m.Video.Profile           = $($s.profile)
                                  $m.Video.Level             = $($s.level)
                                  $m.Video.FrameWidth        = $($s.width)
                                  $m.Video.FrameHeight       = $($s.height)
                                  $m.Video.FrameRate         = [math]::round($($s.r_frame_rate -split '/')[0] / 
                                                                             $($s.r_frame_rate -split '/')[1],3)
                                  $m.Video.AspectRatioString = $($s.display_aspect_ratio)
                                  if ( $s.display_aspect_ratio ) {
                                      $ratio = $s.display_aspect_ratio -split ':'
                                      $m.Video.AspectRatio = [Math]::Round(([int]$ratio[0] / [int]$ratio[1]),2)
                                  }
                                  else {
                                      $m.Video.AspectRatio = [Math]::Round(([int]$s.width / [int]$s.height),2)
                                  }
                                  $m.Video.AspectRatioTag  = ($m.Video.AspectRatio -lt 1.5)  ? 'FS' : `
                                                             (($m.Video.AspectRatio -lt 1.9) ? 'WS' : 'CWS')
                                  $m.Video.Encoder = ($s.tags.'handler_name' -like "*GPAC*") ? `
                                                     'GPAC' : ($s.tags.'handler_name' -split ' ')[0]
                                }
                }

            } else {

                switch ( $s.codec_type ) {
                    'data'      { $m.Features += 'subtitles' }
                    'subtitle'  { $m.Features += 'closedCaptions' }
                    'audio'     {
                                  $m.DrmProtected     = $true
                                  $m.Audio.Codec      = $('audio/drm')
                                  $m.Audio.Format     = $($s.channel_layout)
                                  $m.Audio.FormatTag  = ($m.Audio.Channels -eq 6) ? 'DD' : 'DS'
                                  $m.Audio.Channels   = $([int]$s.channels)
                                  $m.Features        += $('audio/drm:{0}' -f $($s.channel_layout))
                                  if ( $null -ne $encoder ) { $m.Audio.Encoders += $encoder }

                                }
                    'video'     {
                                  $m.DrmProtected      = $true
                                  $m.Video.Codec       = $('video/drm')
                                  $m.Video.FrameWidth  = $($s.width)
                                  $m.Video.FrameHeight = $($s.height)
                                  $m.Features         += $('video/drm')
                                  if ( $s.display_aspect_ratio ) {
                                      $ratio = $s.display_aspect_ratio -split ':'
                                      $m.Video.AspectRatio = [Math]::Round(([int]$ratio[0] / [int]$ratio[1]),2)
                                  }
                                  else {
                                      $m.Video.AspectRatio = [Math]::Round(([int]$s.width / [int]$s.height),2)
                                  }
                                  $m.Video.AspectRatioTag  = ($m.Video.AspectRatio -lt 1.5)  ? 'FS' : `
                                                             (($m.Video.AspectRatio -lt 1.9) ? 'WS' : 'CWS')
                                  if ( $null -ne $encoder ) { $m.Video.Encoders += $encoder }
                                }

                }

            }
            
        }

        $m.features = $m.features | Sort-Object -Unique

    }
}
