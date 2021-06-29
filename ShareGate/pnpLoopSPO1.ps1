#pnpLoopSPO1

cls

Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking

$login = "EYTestAdmin@M365B742352.onmicrosoft.com"
$pwd = "Cognizantadmin123!"
$pwd = ConvertTo-SecureString $pwd -AsPlainText -Force

$credentials = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $login,$pwd

Connect-SPOService -Url https://m365b742352-admin.sharepoint.com -credential EYTestAdmin@M365B742352.onmicrosoft.com 

#Load SharePoint CSOM Assemblies
#Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
#Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

#Import ShareGate Modules
Import-Module Sharegate	

#Variables for Processing
$SiteUrl = "https://m365b742352.sharepoint.com/MigrateSubsite"
$UserName="EYTestAdmin@M365B742352.onmicrosoft.com"
$Password ="Cognizantadmin123!"
  
#Setup Credentials to connect
$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($UserName,(ConvertTo-SecureString $Password -AsPlainText -Force))
 
Try { 
    #Set up the context
    $Context = New-Object Microsoft.SharePoint.Client.ClientContext($SiteUrl) 
    $Context.Credentials = $credentials
 
    #sharepoint online powershell get all lists
    $Lists = $Context.web.Lists
    $Context.Load($Lists)
    $Context.ExecuteQuery()
 
    #Iterate through each list in a site   
    ForEach($List in $Lists)
    {
        #Get the List Name
        Write-host $List.Title
    }
}
catch {
    write-host "Error: $($_.Exception.Message)" -foregroundcolor Red
}
© 2021 GitHub, Inc.