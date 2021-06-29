#sgExportMigRpt
#As of: 5/3/2021
#Notes: Dynamic file name, Password sent in clear, Needs for each loop to get all lists\libraries,
#Read from a SP List, Update to a SP List?

#SPO Login as Admin Without Prompt

cls

##Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

#break

#Login, Password, Credentials
$login = "P.AUSPORTMIGP.10@ey.com"
$pwd = "QReJ+MMvJ+Vnaba1"
$pwd = ConvertTo-SecureString $pwd -AsPlainText -Force
$credentials = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $login,$pwd

#Connect
Connect-SPOService -url "https://eyus.sharepoint.com/sites/eyimdUSA-0001711-MM" -Credential $credentials

