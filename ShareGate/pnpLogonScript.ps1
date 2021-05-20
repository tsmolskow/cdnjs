#pnpLogonScript

#Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
#Update-Module SharePointPnPPowerShellOnline

cls

$SiteURL="https://eyus.sharepoint.com/sites/eyimdUSA-0001711-MM"
$UserName="P.AUSPORTMIGP.10@ey.com"
$Password = "QReJ+MMvJ+Vnaba1"
 
$SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $UserName, $SecurePassword
 
#Connect to PNP Online
Connect-PnPOnline -Url $SiteURL -Credentials $Cred