function Read-FFmpegFileProperties {
    <#
    .DESCRIPTION
        Returns the FFPROBE stream analyzer data for a file.

    .OUTPUTS
        A Hashtable containing the stream information.

    .PARAMETER File
        REQUIRED. String. Alias: -f. The fully-qualified file path of an MPEG file.

    .EXAMPLE
        Read-FFmpegFileProperties -FilePath 'C:\myfile.mp4'

    .EXAMPLE
        Read-FFmpegFileProperties -f 'C:\myfile.mp4'
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
                $r.value = $r.value | ConvertFrom-JSON
            }
            
        }
        catch {
            Write-Msg -x -o $_
            $r = @{ success = $false; message = $_.Exception.Message; value = $null }
        }

        Write-Msg -FunctionResult -o $( $r.success ? $r.value : $r.message ) -MaxRecursionDepth 5

        return $r

    }

}
