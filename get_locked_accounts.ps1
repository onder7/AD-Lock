# get_locked_accounts.ps1
param(
    [string]$DomainController,
    [string]$Username,
    [string]$Password
)

$securePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($Username, $securePassword)

# Active Directory mod�l�n� import et
Import-Module ActiveDirectory

try {
    # Belirtilen domain controller'a ba�lan
    $server = $DomainController
    
    # Kilitli hesaplar� sorgula
    $lockedAccounts = Get-ADUser -Filter {Lockedout -eq $true} -Properties SamAccountName, LockedOut -Server $server -Credential $credential |
                      Select-Object -ExpandProperty SamAccountName

    # Sonu�lar� ekrana yazd�r (Python taraf�ndan okunabilir)
    $lockedAccounts | ForEach-Object { Write-Output $_ }
}
catch {
    Write-Error "Hata olu�tu: $_"
    exit 1
}