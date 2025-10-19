function Get-FFmpegSummary {
    <#
    .DESCRIPTION
        Gets the FFPROBE stream analyzer data and creates a summary.

    .OUTPUTS
        A PSCustomObject containing the stream information and the summary data.

    .PARAMETER File
        REQUIRED. String. Alias: -f. The fully-qualified file path of an MPEG file.

    .EXAMPLE
        Get-FFmpegFileSummary -FilePath 'C:\myfile.mp4'

    .EXAMPLE
        Get-FFmpegSummary -f 'C:\myfile.mp4'
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)] [Alias('f')] [String] $File
    )

    process {

        try {

            Write-Msg -FunctionCall -IncludeParameters

            $r = Invoke-FFprobeCommand -File $File
            if ( $r.success ) {

                $probeResults = $r.value | ConvertFrom-Json

                [PSCustomObject] $mpegData = @{}

                if ( Test-IsSomething($probeResults.format) ) {
                    $mpegData.Duration = [int][math]::Round($probeResults.format.duration)
                    $mpegData.BitRate  = [int]$probeResults.format.bit_rate
                }

                if ( Test-IsSomething($probeResults.streams) ) {
                    $mpegData.Streams = $probeResults.streams
                    $mpegData | Add-FFmpegStreamSummary
                }

                if ( Test-IsSomething($probeResults.chapters) ) {
                    $mpegData.Chapters = $probeResults.chapters
                    $mpegData | Add-FFmpegChapters
                }

                $result = @{ success = $true; value = $( $mpegData ) }
            }
            else {
                $result = $r
            }
            
        }
        catch {
            Write-Msg -x -o $_
            $r = @{ success = $false; message = $_.Exception.Message; value = $null }
        }

        Write-Msg -FunctionResult -o $result

        return $result

    }

}
