function Invoke-FFmpegCommand {
    <#
    .DESCRIPTION
        Executes an FFmpeg command against a file and returns the results.

        This function can be called by two aliases:
          - Invoke-FFmpegCommand  : runs an ffmpeg command.
          - Invoke-FFprobeCommand : runs an ffprobe command.

    .OUTPUTS
        A string array containing the results of the command.

    .PARAMETER File
        REQUIRED. String. Alias: -f. The fully-qualified file path of an MPEG file.

    .PARAMETER Command
        REQUIRED. String. Alias: -c. The command line that FFmpeg should execute. The default value of
        this parameter is based on which alias is used:
          - Invoke-FFmpegCommand  : 
          - Invoke-FFprobeCommand : -v quiet -print_format json -show_format -show_streams

    .EXAMPLE
        Invoke-FFmpegCommand -File 'C:\myfile.mp4' -Command '--textdata' -SaveToFile

    .EXAMPLE
        Invoke-FFprobeCommand -p 'C:\myfile.mp4' -c '--textdata' -s

    .NOTES
        Results are returned as a string array of console line results.
    #>
    [OutputType([String[]])]
    [Alias('Invoke-FFprobeCommand')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)] [Alias('f')] [String] $File,
        [Parameter()]                            [Alias('c')] [String] $Command
    )

    process {

        Write-Msg -FunctionCall -IncludeParameters
    
        if ( $SCRIPT:FFMPEG_INSTALLED ) {

            if ( $MyInvocation.InvocationName -eq 'Invoke-FFprobeCommand' ) {
                if ( [String]::IsNullOrEmpty($Command) ) {
                    $Command = '-v quiet -print_format json -show_format -show_streams'
                }
                $cmd = $( "FFprobe {0} `"{1}`"" -f $Command, $File )
            }
            else {
                if ([String]::IsNullOrEmpty($Command) ) {
                    $Command = ''
                }
                $cmd = $( "FFmpeg {0} `"{1}`"" -f $Command, $File )
            }

            if ( Test-Path -LiteralPath $File -ErrorAction Ignore ) {

                Write-Msg -d -il 1 -m $( 'File Exists: {0}' -f $File )

                [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
                $r = Invoke-Cmd -c $cmd -r 0 -x

                Write-Msg -d -m 'Command Result: ' -il 1 -o $r
                
                if ( $r.success ) {
                    $result = @{ success = $true; value = $( $r.value ) }
                }
                else {
                    $result = @{ success = $false; message = $r.message }
                }
                
            }
            else {
                $result = @{ success = $false; message = $('The specified file was not found: {0}' -f $File) }
            }
            
        }
        else {
            $result = @{ success = $false; message = 'MPEG data cannot be read. FFmpeg was not found.' }
        }

        Write-Msg -FunctionResult -o $result

        return $result

    }
}
