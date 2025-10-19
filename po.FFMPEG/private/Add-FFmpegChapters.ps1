Function Add-FFmpegChapters {
    <#
    .DESCRIPTION
        Adds the chapter list, if one exists.
    
    .OUTPUTS
        None. Updates the existing PSCustomObject instance.

    .PARAMETER MPEGdata
        REQUIRED. MPEGdata. Alias: -d. An PSCustomObject that contains a 'streams' property populated 
        with FFPROBE stream data.

    .EXAMPLE
        Add-FFmpegChapters -MPEGdata $d
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)] [Alias('d')] [PSCustomObject] $MPEGdata
    )

    process {

        Write-Msg -FunctionCall -IncludeParameters
        
        [PSCustomObject[]] $chapters = @()

        foreach ( $c in $MPEGdata.chapters ) {
            $chapters += @{
                id    = $c.id
                start = [math]::Round(($c.start / ($c.time_base -split '/')[-1]),3)
                title = $c.tags.title
            }
        }
        
        $MPEGdata.chapters = $chapters

    }
}
