function Read-FFmpegFileProperties {
    <#
    .DESCRIPTION
        Returns the FFPROBE stream analyzer data for a file.

    .OUTPUTS
        A Hashtable containing the stream information.

    .PARAMETER File
        REQUIRED. String. Alias: -f. The fully-qualified file path of an MPEG file.

    .EXAMPLE
        Read-FFmpegFileProperties -FilePath 'C:\myfile.mp4' -SaveToFile

    .EXAMPLE
        Read-FFmpegFileProperties -f 'C:\myfile.mp4' -s
    #>
    [OutputType([Hashtable])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)] [Alias('f')] [String] $File
    )

    process {

        try {

            Write-Msg -FunctionCall -IncludeParameters

            $r = Invoke-FFprobeCommand -File $File

            $result = $r | ConvertFrom-JSON
            
        }
        catch {
            Write-Msg -x -o $_
        }

        Write-Msg -FunctionResult -o $result -MaxRecursionDepth 5

        return $result

    }

}
