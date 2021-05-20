#Logon Without a Prompt
#

#checkSPPNPModuleInstalled
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking

cls

#Login and Password
$login = "P.AUSPORTMIGP.10@ey.com"
$pwd = "QReJ+MMvJ+Vnaba1"
$pwd = ConvertTo-SecureString $pwd -AsPlainText -Force

#Credentials
$credentials = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $login,$pwd

#Connect
Connect-SPOService -url "https://eyus.sharepoint.com/sites/eyimdUSA-0001711-MM" -Credential $credentials