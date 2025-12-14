Get-ChildItem -Path "C:\Path\" -Filter *.exe -Recurse |
    Select-Object Name, FullName |
    ForEach-Object {
        New-NetFirewallRule -DisplayName "Block $($_.Name) Inbound" -Direction Inbound -Program "$($_.FullName)" -Action Block
        New-NetFirewallRule -DisplayName "Block $($_.Name) Outbound" -Direction Outbound -Program "$($_.FullName)" -Action Block
    }
