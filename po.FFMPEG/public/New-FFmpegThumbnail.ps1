function New-FFmpegThumbnail {
    <#
    .DESCRIPTION
        Converts an image from one size or type to another.

    .OUTPUTS
        A [PSCustomObject] indicating success or failure and the path of the new image.

    .PARAMETER inputFile
        REQUIRED. String. Alias: -i. The fully-qualified file path of a JPEG or PNG file.

    .PARAMETER outputFile
        REQUIRED. String. Alias: -o. The fully-qualified file path of the output file.

    .PARAMETER MaxDimension
        REQUIRED. Int. Alias: -m. The maximum size, in pixels, of the largest dimension (width or
        height) of the output image. The image is scaled proportionally so its largest dimension
        matches this value. Default Value: 600

    .EXAMPLE
        New-FFmpegThumbnail -inputFile 'C:\myfile.jpg' -outputFile 'C:\myfile-resized.jpg' -MaxDimension 1000
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [Alias('i')] [String] $inputFile,
        [Parameter(Mandatory)] [Alias('o')] [String] $outputFile,
        [Parameter()]          [Alias('m')] [Int]    $MaxDimension = 600
    )

    process {

        try {

            Write-Msg -FunctionCall -IncludeParameters

            if ( $SCRIPT:FFMPEG_INSTALLED ) {

                if ( Test-Path -LiteralPath $inputFile -ErrorAction Ignore ) {

                    Write-Msg -d -il 1 -m $( 'File Exists: {0}' -f $inputFile )

                    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

                    $c = @(
                            $('ffmpeg -loglevel error -y'),
                            $('-i "{0}"' -f $inputFile),
                            $('-vf "scale=''min({0},iw)'':''min({0},ih)'':force_original_aspect_ratio=decrease"' -f $MaxDimension),
                            $('-update 1 "{0}"' -f $outputFile)
                        ) -Join ' '

                    $r = Invoke-Cmd -c $c -r 0 -x
                    
                    if ( $r.success ) {
                        $result = @{ success = $true; value = $( $r.value ) }
                    }
                    else {
                        $result = @{ success = $false; message = $r.message }
                    }
                    
                }
                else {
                    $result = @{ success = $false; message = $('The specified file was not found: {0}' -f $inputFile) }
                }

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
