#Logon Without a Prompt
#May Not Work with On-Prem

#checkSPPNPModuleInstalled
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking

cls

##Config Variable
#$SiteURL = "https://eyus.sharepoint.com/sites/eyimdUSA-0001711-MM"
$SiteURL = "https://us.eyonespace.ey.com/Sites/f8151001268342838b959d7f33ed2e29"

##Setup Credentials to Connect Automatically
$UserName="P.AUSPORTMIGP.10@ey.com"
$Password = "QReJ+MMvJ+Vnaba1"
$SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $UserName, $SecurePassword
 
##Connect to Site collection
Connect-PnPOnline -Url $SiteURL -Credentials $Cred

#Connect
#Connect-SPOService -url "https://eyus.sharepoint.com/sites/eyimdUSA-0001711-MM" -Credential $credentials