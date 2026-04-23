function Get-Key {
    param (
        [string]$value
    )

    if ($null -eq $value) {
        return $null
    }

    $prefix = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("RG9ja2VyUHJv"))
    $suffix = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("aS10ZWM="))

    $input = $prefix + $value + $suffix
    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    $hash = $sha256.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($input))

    $numArray = New-Object byte[] 8
    $num = 0
    for ($index1 = 0; $index1 -lt 8; $index1++) {
        $numArray[$index1] = $hash[$index1 * 3 + $num * 2 + 1]
        if ($index1 % 2 -eq 1) {
            $num++
        }
    }

    $result = ""
    for ($index2 = 0; $index2 -lt $numArray.Length; $index2++) {
        $result += $numArray[$index2].ToString("x2").ToUpper()
        if ($index2 % 2 -eq 1 -and $index2 -lt 7) {
            $result += "-"
        }
    }

    return $result
}
#$hash = Get-Key -value "Hello world"
#Write-Host $hash
