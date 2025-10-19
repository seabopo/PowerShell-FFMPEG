function Show-MissingBinaryMessage {
    <#
    .DESCRIPTION
        Displays a message to the user to explaining the module's binary requirements.

    .OUTPUTS
        None.

    .EXAMPLE
        Show-MissingBinaryMessage
    #>
    [OutputType([Void])]
    [CmdletBinding()]
    param ( )

    process {

        try {

            Write-Msg -p -ps -m 'Alerting the user about the module binary requirements ...'

            $msg = @(

                'This PowerShell module requires FFMPEG to be installed.','',

                'FFMPEG is a cross-platform solution to record, convert and stream audio and video.',
                'This tool is an open-source project licensed under the GNU GPL and LGPL licenses and',
                'is available for free on ffmpeg.org ( https://ffmpeg.org/legal.html ).','',

                'On MacOS, the FFMPEG binary can be installed using Homebrew with the',
                'following command: $ brew install ffmpeg','',

                'On Windows, the FFMPEG binary can be installed using Chocolatey with the',
                'following command: $ choco install ffmpeg','',

                'Users of all operating systems can download the latest binary and source versions from the',
                'project site: https://ffmpeg.org/download.html','',

                'When installing FFMPEG using Homebrew or Chocolatey the FFMPEG binary paths',
                'will automatically be added to the operating system PATH environment variable.',
                'If FFMPEG was installed manually you must add the path to the system',
                'PATH environment variable for the module to work.','',

                'Please note that this module is only tested against FFMPEG release version',
                $('"{0}"' -f $FFMPEG_VERSION),'',

                'For additional information see https://github.com/seabopo/PowerShell-FFMPEG',''

            ) -join [System.Environment]::NewLine

            Write-Msg -a -m $msg

        }
        catch {
            $errMsg = "An error occurred while attempting to inform the user of the module's installation requirements."
            Write-Msg -x -m $( "{0} `r`n" -f $errMsg ) -o $_
        }

    }

}
