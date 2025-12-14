# Set the source directory
$SourceDir = "C:\path\to\your\files"

# Set the destination root directory
$DestRoot = "C:\path\to\organized"

# Process all files in the source directory
Get-ChildItem -Path $SourceDir -File | ForEach-Object {
    $file = $_

    # Look for a date pattern YYYY-MM-DD in the filename
    if ($file.Name -match '(\d{4})-(\d{2})-(\d{2})') {
        $year = $matches[1]
        $month = $matches[2]
        $day = $matches[3]

        # Build destination folder path correctly
        $DestPath = Join-Path $DestRoot $year
        $DestPath = Join-Path $DestPath $month
        $DestPath = Join-Path $DestPath $day

        # Create destination folder if it doesn't exist
        if (-not (Test-Path $DestPath)) {
            New-Item -ItemType Directory -Path $DestPath -Force | Out-Null
        }

        # Move the file
        $DestFile = Join-Path $DestPath $file.Name
        Move-Item -Path $file.FullName -Destination $DestFile -Force
        Write-Host "Moved $($file.Name) -> $DestPath"
    }
    else {
        Write-Host "Skipped $($file.Name) (no date found)"
    }
}
