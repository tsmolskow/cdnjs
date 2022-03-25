## sqlDBConnAndQuery1.ps1
## Connect to AD_WLK_Users Table and retunrs selected fields
## Exports to CSV  
## Must be Run in the Molskow User Account
## Tom Molskow, Able Solutions
## As Of 3/22/2022

cls

## Set Output File Variables
$Path = "c:\scripts\CSVOutput\"
$dtgDateTime = get-date -uformat %d-%m-%Y-%H.%M.%S
$filePath = $Path + "AD_WLK_Users" + $dtgDateTime + ".csv"

## Set SQL Server and DB Variables
$SQLServer = "HOUDBEDM01T.westlake.wlg.int" #use Server\Instance for named SQL instances!
$SQLDBName = "ATLAS_UAT"

## Set Connection Variables
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
#$SqlConnection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; User ID = 'Westlake\tmolskow'; Password = 'Junction111'" 
$SqlConnection.ConnectionString = “Server = $SQLServer; Database = $SQLDBName; Integrated Security = true; Initial Catalog = master”

## Set SQL CMD Variables
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.Connection = $SqlConnection 
$Query = "SELECT [SamAccountName], [displayName], [GivenName], [Surname], [employeeNumber], [Manager], [objectGUID], [Location], [Mail] FROM [ATLAS_UAT].[dbo].[AD_WLK_Users]"
$SqlCmd.CommandText = $Query

## Set SQL Adapter Variables
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd

## Set DataSet Variables - Fill Data Set - Export to CSV
$DataSet = New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet) 
$DataSet.Tables
$DataSet.Tables[0] | export-csv -LiteralPath $filePath -Delimiter "," -notypeinformation

## Close the Connection
$SqlConnection.Close()

## Start spSetUserProfileDataAdminGInput.ps1
$User = "Westlake\svcspdevfarmadmin"
$PWord = ConvertTo-SecureString -String "cHRbiOO8Wxh2ErH" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord

Start-Process PowerShell -Credential $Credential -ArgumentList "-file C:\Scripts\spSetUserProfileDataAdminGInput.ps1"