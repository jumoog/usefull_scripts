# -----------------------------
# CONFIG
# -----------------------------
# gh auth refresh -s read:packages,delete:packages
$User = "jumoog"   # GitHub username

# -----------------------------
# GET ALL PACKAGES
# -----------------------------
$packages = gh api "/users/$User/packages?package_type=container" --paginate |
    ConvertFrom-Json

foreach ($pkg in $packages) {
    $packageName = $pkg.name
    $packageType = $pkg.package_type

    Write-Host "`nProcessing package: $packageName ($packageType)"

    # -----------------------------
    # GET PACKAGE VERSIONS
    # -----------------------------
    $versions = gh api "/users/$User/packages/$packageType/$packageName/versions" --paginate |
        ConvertFrom-Json |
        Sort-Object created_at -Descending

    if ($versions.Count -le 1) {
        Write-Host "  Only one version found, skipping"
        continue
    }

    # Keep the latest version
    $versionsToDelete = $versions | Select-Object -Skip 1

    foreach ($version in $versionsToDelete) {
        Write-Host "  Deleting version ID $($version.id) created $($version.created_at)"
        gh api `
            --method DELETE `
            "/users/$User/packages/$packageType/$packageName/versions/$($version.id)"
    }
}

Write-Host "`nCleanup complete."
