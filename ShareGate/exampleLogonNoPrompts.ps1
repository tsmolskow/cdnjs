#Logon Without a Prompt

cls

#Login and Password
$login = "EYTestAdmin@M365B742352.onmicrosoft.com"
$pwd = "Cognizantadmin123!"
$pwd = ConvertTo-SecureString $pwd -AsPlainText -Force

#Credentials
$credentials = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $login,$pwd

#Connect
Connect-SPOService -url "https://m365b742352-admin.sharepoint.com" -Credential $credentials



