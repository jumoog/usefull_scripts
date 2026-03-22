# ── Configuration ───────────────────────────────────────────────
$hexString   = "<your_hex_string>"
$privateKey  = "private_key.pem"
$password    = "password"
$tempFile    = "encrypted.bin"

# ── Convert hex string to binary file ───────────────────────────
$bytes = [byte[]] ($hexString -split '(..)' | Where-Object { $_ } | ForEach-Object { [Convert]::ToByte($_, 16) })
[IO.File]::WriteAllBytes($tempFile, $bytes)

# ── Decrypt using OpenSSL ────────────────────────────────────────
openssl pkeyutl -decrypt `
  -inkey $privateKey `
  -in $tempFile `
  -passin pass:$password `
  -pkeyopt rsa_padding_mode:oaep `
  -pkeyopt rsa_oaep_md:sha1

# ── Cleanup temp file ────────────────────────────────────────────
Remove-Item $tempFile
