$Users = Get-ADUser -SearchBase "CN=Users,DC=quinten,DC=lan" -Filter { ObjectClass -eq 'user' -and Enabled -eq 'true'}
foreach ($User in $Users) {
    Get-User $User.SamAccountName | Enable-Mailbox -Database "JusticeDB"
    if (Get-Mailbox $User.SamAccountName) {
        Write-Host -ForegroundColor Green "Mailbox for"$User.SamAccountName"was created successfuly."
        } else {
        Wrire-Host -ForegroundColor Red "Mailbox for"$User.SamAccountName"could not be created."
    } 
}