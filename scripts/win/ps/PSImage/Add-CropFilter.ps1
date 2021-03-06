#requires -version 2.0
function Add-CropFilter {    
    <#
        .Synopsis
            Adds a Crop Filter to a list of filters, or creates a new filter
        .Description
            Adds a Crop Filter to a list of filters, or creates a new filter
        .Example
            $image = Get-Image .\Try.jpg            
            $image = $image | Set-ImageFilter -filter (Add-CropFilter -Image $image -Left .1 -Right .1 -Top .1 -Bottom .1 -passThru) -passThru                    
            $image.SaveFile("$pwd\Try2.jpg")
        .Parameter image
            Optional.  If set, allows you to specify the crop in terms of a percentage
        .Parameter left
            The number of pixels to crop from the left (if left is greater than 1) or the percentage of space to crop from the left (if image is provided)
        .Parameter top
            The number of pixels to crop from the top (if top is greater than 1) or the percentage of space to crop from the top (if image is provided)
        .Parameter right
            The number of pixels to crop from the right (if right is greater than 1) or the percentage of space to crop from the right (if image is provided)
        .Parameter bottom
            The number of pixels to crop from the bottom (if bottom is greater than 1) or the percentage of space to crop from the bottom (if image is provided)
        .Parameter passthru
            If set, the filter will be returned through the pipeline.  This should be set unless the filter is saved to a variable.
        .Parameter filter
            The filter chain that the rotate filter will be added to.  If no chain exists, then the filter will be created
    #>
    param(
    [Parameter(ValueFromPipeline=$true)]
    [__ComObject]
    $filter,
    
    [__ComObject]
    $image,
        
    [Double]$left,
    [Double]$top,
    [Double]$right,
    [Double]$bottom,
    
    [switch]$passThru                      
    )
    
    process {
        if (-not $filter) {
            $filter = New-Object -ComObject Wia.ImageProcess
        } 
        $index = $filter.Filters.Count + 1
        if (-not $filter.Apply) { return }
        $crop = $filter.FilterInfos.Item("Crop").FilterId                    
        $isPercent = $true
        if ($left -gt 1) { $isPercent = $false }
        if ($top -gt 1) { $isPercent = $false } 
        if ($right -gt 1) { $isPercent = $false } 
        if ($bottom -gt 1) { $isPercent = $false }
        $filter.Filters.Add($crop)
        if ($isPercent -and $image) {
            $filter.Filters.Item($index).Properties.Item("Left") = $image.Width * $left
            $filter.Filters.Item($index).Properties.Item("Top") = $image.Height * $top
            $filter.Filters.Item($index).Properties.Item("Right") = $image.Width * $right
            $filter.Filters.Item($index).Properties.Item("Bottom") = $image.Height * $bottom
        } else {
            $filter.Filters.Item($index).Properties.Item("Left") = $left
            $filter.Filters.Item($index).Properties.Item("Top") = $top
            $filter.Filters.Item($index).Properties.Item("Right") = $right
            $filter.Filters.Item($index).Properties.Item("Bottom") = $bottom                    
        }
        if ($passthru) { return $filter }         
    }
}