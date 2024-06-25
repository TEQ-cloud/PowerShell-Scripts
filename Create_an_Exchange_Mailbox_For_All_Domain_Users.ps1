# Powershell script created to create a mailbox for all users inside an Active Ditectory or any other Active Directory folder or OU.
# Created by Quinten de Haard (TEQcloud)

# First step is to make a variable that contains all entities witch are of the type 'user' and are enabled within the default Users folder of the domain in Active Directory.
# You also could use any other folder or OU within your domain.
# In this example I've used 'domain.com' as the domain of the Active Dierctory.
 $Users = Get-ADUser -SearchBase "CN=Users,DC=domain,DC=com" -Filter { ObjectClass -eq 'user' -and Enabled -eq 'true' }

# Now that we have all the enities we want we can make statement that will execute commands for all entities inside the variable.
foreach ($User in $Users) {

    # The cmdlet we want to exexute for all entities is to create a mailbox based on the 'SamAccountName' of the user.
    Get-User $User.SamAccountName | Enable-Mailbox -Database "ExchangeDB"

    # After the mailbox should have been created, we check that by searching for an existing mailbox for that user.
    if (Get-Mailbox $User.SamAccountName) {

        # If the mailbox for the user exists the script will show that the mailbox was created successfully. If not, it will say it didn't.
        Write-Host -ForegroundColor Green "Mailbox for"$User.SamAccountName"was created successfully."
        } else {
        Wrire-Host -ForegroundColor Red "Mailbox for"$User.SamAccountName"could not be created."
    } 
}

# Note that you will get an error if the mailbox allready exists because it cannot add existing mailboxes.
# Currently I'm planning on refining the script so it won't do that, but for now this is a functional sollution.
