
#Load SharePoint CSOM Assemblies
#Add-Type -Path "C:\Microsoft.Online.SharePoint.PowerShell\16.0.8715.1200\Microsoft.SharePoint.Client.dll"
#Add-Type -Path "C:\Microsoft.Online.SharePoint.PowerShell\16.0.8715.1200\Microsoft.SharePoint.Client.Runtime.dll"

Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")

<#
    .SYNOPSIS - Retrieve Web information for specified servers.
    .DESCRIPTION - This script will retrieve Web information from the SharePoint servers specified in the input CSV filename.
    .PARAMETER FarmNamesFilename, .PARAMETER OutputLogFilename, .NOTES   
#>

cls

$dt = Get-Date 

# Input Path
$filePath = "c:\Test"
$inputCSV = $filePath + "SitePermissions_2020-09-25-19-53-30-39.csv" ## I Don't Have the CSV File

# Login Information
$spousername = "P.AUOPRTMIGP.10@ey.com"
$spopassword = "cL95H@urF7~Vk3%"
$sposecurepassword = $spopassword | ConvertTo-SecureString -AsPlainText -Force

# $executingScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

# Generate Date String
$mth = $dt.Month
if($mth -eq 1 -or $mth -eq 2 -or $mth -eq 3 -or $mth -eq 4 -or $mth -eq  5 -or $mth -eq 6 -or $mth -eq 7 -or $mth -eq 8 -or $mth -eq 9)
{
$mth = "0"+$mth;
}
$dte = $dt.Day.ToString()+ '_' + $mth.ToString() + '_' + $dt.Year.ToString() +'_'+ $dt.Hour.ToString() + '_' + $dt.Minute.ToString() + '_' + $dt.Second.ToString();

#$logPath = $executingScriptDirectory +"\Logs\" + "PE_Logs"+ $dte + ".csv"
$logPath = $filePath +"\Logs\" + "PE_Logs"+ $dte + ".csv"


Start-Transcript $logPath

function Dispose-All 
{
    <#  .DESCRIPTION         Disposes of all memory used.,        .EXAMPLE        Dispose-All    #>
	
Get-Variable -exclude Runspace | Where-Object {$_.Value -is [System.IDisposable] -and $_.Value.GetType().Name -ne "SqlBulkCopy"} | 
		Foreach-Object { $_.Value.Dispose() }
}

#--------------------------------------------------------------------------------------------------
# Load SharePoint PowerShell cmdlets, if missing.
#--------------------------------------------------------------------------------------------------
#if (!(Get-PsSnapin | Where-Object {$_.Name -match "Microsoft.SharePoint.PowerShell"}))
#{Add-PsSnapin Microsoft.SharePoint.PowerShell}

#--------------------------------------------------------------------------------------------------
# Main Script
#--------------------------------------------------------------------------------------------------
$startTime = Get-Date

#Output Files
$OutputFilename = $filePath +"\Logs\" +"$((Get-Date).ToString("yyyyMMdd_HHmmss"))_GetPermissionEditTransScript.csv"
$OutputLogFilename = $filePath +"\Logs\" + "$((Get-Date).ToString("yyyyMMdd_HHmmss"))_GetPermissionEditLog.csv" 

#Input File of the Site URLs - Source URL and Target URL
$siteURLSfile = Join-Path $filePath "inputFile_URLS.csv"
$intCntSite = 0
$csvsiteURLs = Import-csv $siteURLSfile 
$cntSites = $csvsiteURLs.Count

#Create an array to capture Logs while executing the script
$oLogDetailsCollection = New-Object System.Collections.ArrayList

#To call a non-generic method Load
Function Invoke-LoadMethod() {
    param(
            [Microsoft.SharePoint.Client.ClientObject]$Object = $(throw "Please provide a Client Object"),
            [string]$PropertyName
        )
   $ctx = $Object.Context
   $load = [Microsoft.SharePoint.Client.ClientContext].GetMethod("Load")
   $type = $Object.GetType()
   $clientLoad = $load.MakeGenericMethod($type)
   
   $Parameter = [System.Linq.Expressions.Expression]::Parameter(($type), $type.Name)
   $Expression = [System.Linq.Expressions.Expression]::Lambda([System.Linq.Expressions.Expression]::Convert([System.Linq.Expressions.Expression]::PropertyOrField($Parameter,$PropertyName),[System.Object] ), $($Parameter))
   $ExpressionArray = [System.Array]::CreateInstance($Expression.GetType(), 1)
   $ExpressionArray.SetValue($Expression, 0)
   $clientLoad.Invoke($ctx,@($Object,$ExpressionArray))
}
  
#Function to Get Webs's Permissions from given URL
Function Get-SPOWebPermission([Microsoft.SharePoint.Client.Web]$web)
{
    #Get all immediate subsites of the site
    $Ctx.Load($web.Webs) 
    $Ctx.executeQuery()
   
    #Call the function to Get Lists of the web
    Write-host -f Yellow "Getting the Permissions of Web "$web.URL"..."
        "Iterating through Permissions of web in the List:"+ $web.URL| Out-File $OutputFilename -Append

    #Check if the Web has unique permissions
    Invoke-LoadMethod -Object $web -PropertyName "HasUniqueRoleAssignments"
    $Ctx.ExecuteQuery()
  
    #Get the Web's Permissions
    If($web.HasUniqueRoleAssignments -eq $true)
    {
        Get-Permissions -Object $web -SiteURL $SiteURL -OutputFilename $OutputFilename -oLogDetailsCollection $oLogDetailsCollection
    }
  
    #Scan Lists with Unique Permissions
    Write-host -f Yellow "`t Getting the Permissions of Lists and Libraries in "$Web.URL"..."
        "Iterating through the Permissions of Lists and Libraries in:"+ $web.URL| Out-File $OutputFilename -Append
    Get-SPOListPermission($web)
   
    #Iterate through each subsite in the current web
    Foreach ($Subweb in $web.Webs)
    {
            #Call the function recursively                           
            Get-SPOWebPermission($SubWeb)
    }
}

#Function to Get Permissions of all lists from the web
Function Get-SPOListPermission([Microsoft.SharePoint.Client.Web]$Web)
{
    #Get All Lists from the web
    $Lists = $Web.Lists
    $Ctx.Load($Lists)
    $Ctx.ExecuteQuery()
  
    #Get all lists from the web  
    ForEach($List in $Lists)
    {
        #Exclude System Lists
        If($List.Hidden -eq $False)
        {
            #Get List Items Permissions
            # Get-SPOListItemsPermission $List 

  
            #Get the Lists with Unique permission
            Invoke-LoadMethod -Object $List -PropertyName "HasUniqueRoleAssignments"
            $Ctx.ExecuteQuery()
  
            If( $List.HasUniqueRoleAssignments -eq $True)
            {
                #Call the function to check permissions
                Get-Permissions -Object $List -SiteURL $SiteURL -OutputFilename $OutputFilename -oLogDetailsCollection $oLogDetailsCollection
            }
        }
    }
}
  
  
#Function to get sharepoint online site permissions
Function Edit-SPOSitePermissionMain($SiteURL,$Credentials,$OutputFilename, $oLogDetailsCollection)
{
   
   Try{    
        
        #Setup the context
        $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
        $Ctx.Credentials = $Credentials
  
        #Get the Web
        $Web = $Ctx.Web
        $Ctx.Load($Web)
        $Ctx.ExecuteQuery()
  
        #Write CSV- TAB Separated File) Header
        "URL `t Object `t Title `t Account `t PermissionType `t Permissions" | out-file $OutputFilename
  
        Write-host -f Yellow "Getting Site Collection Administrators..."
        #Get Site Collection Administrators
        $SiteUsers= $Ctx.Web.SiteUsers
        $Ctx.Load($SiteUsers)
        $Ctx.ExecuteQuery()
        $SiteAdmins = $SiteUsers | Where { $_.IsSiteAdmin -eq $true}
  
        ForEach($Admin in $SiteAdmins)
        {
            #Send the Data to report file
            "$($Web.URL) `t Site Collection `t $($Web.Title)`t $($Admin.Title) `t Site Collection Administrator `t  Site Collection Administrator" | Out-File  $OutputFilename -Append
        }
  
        #Call the function with RootWeb to get site collection permissions
        Get-SPOWebPermission $web 
  
        #Write-host -f Green "Site Permission Report Generated Successfully!"
        }

    Catch{
                     
          $endTime = Get-Date
                        
		  $oLogDetailM = New-Object -Type PSObject -Property @{                                                                    
          SiteURL = ($SiteURL)
          ObjectURL = ($ObjectURL) 
          AccountOrGroup = ( $accName)                        
          Type = "Exception"
          Message = ($_.Exception.Message)
                                    
       } 
       
       $oLogDetailsCollection.Add( $oLogDetailM ) |  Out-null        
       
  }

}


#Function to Get Permissions Applied on a particular Object, such as: Web, List or Item
Function Get-Permissions([Microsoft.SharePoint.Client.SecurableObject]$Object, $SiteURL,$OutputFilename,$oLogDetailsCollection)
{

Try{
       #Determine the type of the object
    Switch($Object.TypedObject.ToString())
    {
        "Microsoft.SharePoint.Client.Web"  { $ObjectType = "Site" ; $ObjectURL = $Object.URL }
       
       Default
        {
            $ObjectType = "List/Library"
            #Get the URL of the List or Library
            $Ctx.Load($Object.RootFolder)
            $Ctx.ExecuteQuery()           
            $ObjectURL = $("{0}{1}" -f $Ctx.Web.Url.Replace($Ctx.Web.ServerRelativeUrl,''), $Object.RootFolder.ServerRelativeUrl)
        }
    }
  
    #Get permissions assigned to the object
    $Ctx.Load($Object.RoleAssignments)
    $Ctx.ExecuteQuery()
  
    Foreach($RoleAssignment in $Object.RoleAssignments)
    {
        $Ctx.Load($RoleAssignment.Member)
        $Ctx.executeQuery()
                  
        #Get the Permissions on the given object
        $Permissions=@()
        $Ctx.Load($RoleAssignment.RoleDefinitionBindings)
        $Ctx.ExecuteQuery()
        $accName= $RoleAssignment.Member.LoginName 
        Edit-SPOSitePermission -Context  $Ctx  -SiteURL $SiteURL   -ObjectType $ObjectType -RoleAssignment $RoleAssignment -ObjectTitle $Object.Title -OutputFilename $OutputFilename -oLogDetailsCollection $oLogDetailsCollection -ObjectURL  $ObjectURL -accName $accName -inputCSV $inputCSV

    }

} Catch {
             
    $endTime = Get-Date
	$oLogDetailGP = New-Object -Type PSObject -Property @{                                                                    
    SiteURL = $SiteURL
    ObjectURL = ($ObjectURL)
    AccountOrGroup = ($accName) 
    Type = "Exception"
    Message = ($_.Exception.Message)
                                    
    }

    $oLogDetailsCollection.Add( $oLogDetailGP ) |  Out-null
    
    }
}


#Function to Edit Permissions 
Function Edit-SPOSitePermission($Context, $SiteURL,$ObjectType,$RoleAssignment,$ObjectTitle,$OutputFilename ,$oLogDetailsCollection, $ObjectURL,$accName,$inputCSV)
{

Try{#$accName= $RoleAssignment.Member.LoginName 
    if(($RoleAssignment.Member.PrincipalType -eq "SharePointGroup") -or ($RoleAssignment.Member.PrincipalType -eq "SecurityGroup") -or ($RoleAssignment.Member.PrincipalType -eq "User"))
         {      $ReadRole = “Read”
                $RnPRole = “Read and Personalize"
                $vRole = “View Only"
                $cRole  = "Contribute"             
                $Inheritance = "Custom"            
                $selColumns = "Type","Name","URL","Inheritance","User/group","Principaltype","Accountname","Permissions","TargetURL","DesURL"	

                $perSource = Import-Csv $inputCSV -Header $selColumns -Delimiter ","

                $cdtn = ( ($_.Permissions -notmatch $ReadRole) -or ($_.Permissions -notmatch $RnPRole) -or ($_.Permissions -notmatch $vRole) )
                $selSPOPer +=  $perSource| Where-Object {( $_.TargetURL -match  $SiteURL) -and ( $_.DesURL -eq ($ObjectURL)) -and ($_.Inheritance -match  $Inheritance) -and ($_.Type -match $ObjectType) -and (($_.Name.replace("&amp;","&") -like $ObjectTitle)-or($_.Name.replace(".","")-like $ObjectTitle.Replace(".","")))-and (($_.AccountName -like $RoleAssignment.Member.LoginName) -or($_.AccountName -match $RoleAssignment.Member.Title)) -and $cdtn}| Select-Object  {$_.Permissions} 
         
         if($selSPOPer.'$_.Permissions' -ne $null)
            {    $selSPOPerArr =$selSPOPer.'$_.Permissions'.Split(";")

                 #Get the Permissions on the given object
                 $Permissions=@()
                 Foreach ($RoleDefinition in $RoleAssignment.RoleDefinitionBindings)                    
                    { $Permissions += $RoleDefinition.Name }               
                                                                                  
            $counter = $selSPOPerArr.Count - 1

          for($i=0;$i -lt $counter ;$i++)  
            { 
            #Get Permission Levels to add and remove
                    $AddPermission = $selSPOPerArr[$i]
                    $DispPermission ="No"
                    $RoleDefToRmvRead = $Ctx.web.RoleDefinitions.GetByName($ReadRole)  
                    $RoleDefToRmvRnP = $Ctx.web.RoleDefinitions.GetByName($RnPRole)  
                    $RoleDefToRmvVO = $Ctx.web.RoleDefinitions.GetByName($vRole) 
                    $RoleDefToRmvCon = $Ctx.web.RoleDefinitions.GetByName($cRole)  
                  
                                    
                    if($AddPermission -ne "Site Collection Administrator")
                    {  
                     if($AddPermission.Length -ne 0){ $RoleDefToAdd = $Ctx.web.RoleDefinitions.GetByName($AddPermission)
                     #Add Permission level to the group
                      if (($RoleAssignment.RoleDefinitionBindings.Name -notcontains $AddPermission ))
                       {
                          $RoleAssignment.RoleDefinitionBindings.Add($RoleDefToAdd)                                                                                        
                          $RoleAssignment.Update()
                           
                       } 
                       }
                       
                       if (($selSPOPerArr -notcontains $ReadRole) -and ($RoleAssignment.RoleDefinitionBindings.Name -contains $ReadRole ))
                       {
                          $RoleAssignment.RoleDefinitionBindings.Remove($RoleDefToRmvRead)                                                                                        
                          $RoleAssignment.Update()
                          $DispPermission = $ReadRole    
                       }
                       elseif(($selSPOPerArr -notcontains $RnPRole) -and ($RoleAssignment.RoleDefinitionBindings.Name -contains $RnPRole ))
                       {  
                          $RoleAssignment.RoleDefinitionBindings.Remove($RoleDefToRmvRnP)                                                                                        
                          $RoleAssignment.Update()
                          $DispPermission = $RnPRole 
                       }
                       elseif( ($selSPOPerArr -notcontains $vRole) -and ($RoleAssignment.RoleDefinitionBindings.Name -contains $vRole ))
                       {  
                          $RoleAssignment.RoleDefinitionBindings.Remove($RoleDefToRmvVO)                                                                                        
                          $RoleAssignment.Update()
                          $DispPermission = $RnPRole 
                        }
                        elseif( ($selSPOPerArr -notcontains $cRole) -and ($RoleAssignment.RoleDefinitionBindings.Name -contains $cRole ))
                       {  
                          $RoleAssignment.RoleDefinitionBindings.Remove($RoleDefToRmvCon)                                                                                        
                          $RoleAssignment.Update()
                          $DispPermission = $RnPRole 
                        }
                       $Ctx.ExecuteQuery()
                       $AddPermission + "Permission Added to the Group!" + $accName | Out-File $OutputFilename   -Append
                       $DispPermission + "Permission Removed from the Group!" + $accName | Out-File $OutputFilename   -Append  
                    } 
                }  
               }
            
             
              }
             }
Catch{
                     
                        $endTime = Get-Date
                        
		                $oLogDetailSPE = New-Object -Type PSObject -Property @{                                                                    
                                    SiteURL = ($SiteURL)
                                    ObjectURL = ($ObjectURL) 
                                    AccountOrGroup = ( $accName)                        
                                    Type = "Exception"
                                    Message = ($_.Exception.Message)
                                    
       } 
       
       $oLogDetailsCollection.Add( $oLogDetailSPE ) |  Out-null       
       
  }
}

  
#Set parameter values

#$ReportFile=".\SitePermissionRpt.csv"
$BatchSize = 500
$accName = $null

$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($spousername, $sposecurepassword)
			
    foreach($site in $csvsiteURLs)
    {
    
      $SiteURL = $site.TargetURL
      $SiteURL = $SiteURL.Trim()
      $SiteURL = $SiteURL.TrimEnd('/')

       Write-Host "Fetching information for Site : " $SiteURL -ForegroundColor DarkGreen
       #Call the function
	    Edit-SPOSitePermissionMain -SiteURL $SiteURL -Credentials $Credentials -OutputFilename $OutputFilename -oLogDetailsCollection $oLogDetailsCollection
        }
        if( $oLogDetailsCollection.Count -gt 0 )
        {$oLogDetailsCollection | Select-Object  SiteURL,ObjectURL,AccountOrGroup,Type,Message   | Export-Csv -path $OutputLogFilename }


$endTime = Get-Date

Write-Host "Script Execution Time : " $startTime " - " $endTime

Write-Host "Script Execution Completed"
Stop-Transcript
