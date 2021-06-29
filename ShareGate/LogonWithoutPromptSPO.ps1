#Logon Without a Prompt
#Does Not Work with SP On-Prem Sites, SPO Only

#checkSPPNPModuleInstalled
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking

cls

##Config Variable
#$SiteURL = "https://eyus.sharepoint.com/sites/eyimdUSA-0001711-MM"
#$SiteURL = "https://sites.ey.com/sites/eyimdDNK-0027938-MM"
#$SiteURL = "https://eyus.sharepoint.com/sites/eyimdUSA-0036388-MM"
#$SiteURL = "https://eyus.sharepoint.com/sites/eyimdUSA-0036662-MM"
#$SiteURL = "https://eyus.sharepoint.com/sites/eyimdUSA-0039895-MM"
$SiteURL = "https://eyus.sharepoint.com/sites/eyimdUSA-0041706-MM"

##Setup Credentials to Connect Automatically
$UserName="P.AUSPORTMIGP.10@ey.com"
$Password = "QReJ+MMvJ+Vnaba1"
$SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $UserName, $SecurePassword
 
##Connect to Site collection
Connect-PnPOnline -Url $SiteURL -Credentials $Cred

#Connect
#Connect-SPOService -url "https://eyus.sharepoint.com/sites/eyimdUSA-0001711-MM" -Credential $credentials