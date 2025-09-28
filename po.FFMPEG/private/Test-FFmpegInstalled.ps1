function Test-FFmpegInstalled {
    <#
    .DESCRIPTION
        Determines if the FFMPEG binary is installed and available in the system path.

    .OUTPUTS
        Boolean. True if the FFMPEG binary is installed and available in the system path, otherwise false.

    .EXAMPLE
        Test-FFMPEGBinaryExists
    #>
    [OutputType([Bool])]
    [CmdletBinding()]
    param ( )

    process {

        try {

            Write-Msg -FunctionCall

            $test = Invoke-Cmd -c $( 'FFMPEG -version' ) -r 0 -f -s
            if ( $test.Success ) {
                Write-Msg -d -il 1 -m $( 'FFMPEG found. Test successful.' )
                $Script:FFMPEG_INSTALLED = $true
            }
            else {
                Write-Msg -d -il 1 -m $( 'FFMPEG NOT found. Test failed.' )
                Write-Msg -d -il 2 -m $( $test.message )
            }

        }
        catch {
            $errMsg = 'An error occurred while attempting to validate that the FFMPEG binary is installed.'
            Write-Msg -x -m $( "{0} `r`n" -f $errMsg ) -o $_
        }

        Write-Msg -FunctionResult -m $( 'FFMPEG Found: {0}' -f ($Script:FFMPEG_INSTALLED) )

        return $Script:FFMPEG_INSTALLED

    }
}
