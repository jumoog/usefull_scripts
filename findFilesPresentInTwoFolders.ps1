$folder1 = "C:\Siemens\Automation\WinCC_OA\3.20\"
$folder2 = "C:\WinCC_OA_Proj\GaBI\"

# Get recursive file lists
$files1 = Get-ChildItem -Path $folder1 -Recurse -File
$files2 = Get-ChildItem -Path $folder2 -Recurse -File

# Normalize relative paths
$map1 = $files1 | ForEach-Object {
    $_ | Add-Member -NotePropertyName Relative -NotePropertyValue ($_.FullName.Replace($folder1, "")) -PassThru
}
$map2 = $files2 | ForEach-Object {
    $_ | Add-Member -NotePropertyName Relative -NotePropertyValue ($_.FullName.Replace($folder2, "")) -PassThru
}

# Compare and show files present in BOTH
$common = Compare-Object $map1.Relative $map2.Relative -IncludeEqual -ExcludeDifferent |
          Where-Object { $_.SideIndicator -eq "==" }

$common.InputObject
