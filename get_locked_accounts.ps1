# get_locked_accounts.ps1
param(
    [string]$DomainController,
    [string]$Username,
    [string]$Password
)

$securePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($Username, $securePassword)

# Active Directory modülünü import et
Import-Module ActiveDirectory

try {
    # Belirtilen domain controller'a baðlan
    $server = $DomainController
    
    # Kilitli hesaplarý sorgula
    $lockedAccounts = Get-ADUser -Filter {Lockedout -eq $true} -Properties SamAccountName, LockedOut -Server $server -Credential $credential |
                      Select-Object -ExpandProperty SamAccountName

    # Sonuçlarý ekrana yazdýr (Python tarafýndan okunabilir)
    $lockedAccounts | ForEach-Object { Write-Output $_ }
}
catch {
    Write-Error "Hata oluþtu: $_"
    exit 1
}