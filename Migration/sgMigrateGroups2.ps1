## ShareGate Test Script Snippets
## sgMigrateGroups.ps1
## Pre-Install Requirement: ShareGate Must be Installed to the Local Server
## As of: 9/15/2021
## Developer: Tom Molskow, Cognizant

## Site Variables
# SPOP Sites
$spopSite = "https://us.eyonespace.ey.com/Sites/eb3c0602f35f4adf9336638e4bf02d34"
$spopSite1 = "https://us.tdm.ey.net/sites/aea2edb2c272474392bb04b3fe9b8ba4"
$spopSite2 = "https://au.eyonespace.ey.com/sites/bec2c75acc064e7c92802eb4ec130696"

# SPO Sites
$spoSite = "https://eygb.sharepoint.com/sites/eyimdGBR-0001635-MC"

## Groups Variables
$Groups1 = "Owner"
$Groups2 = "Owner,Administrators" # Multiple Groups Seperated by Comma

## Lists Variables
$Lists1 = "Workflows"
$Lists2 = "Workflows,Documents" # Multiple Lists Seperated by Comma


## Login Passwords

# SP Online
$spoUsername = "P.AUSPORTMIGP.10@ey.com" #
#$spoUsername = "P.AUSPORTMIGP.10" #
$spoPassword = "QReJ+MMvJ+Vnaba1" #

# SP On-Premise
#$spopUsername = "ey\P.AUOPRTMIGP.10@ey.com" #
#$spopUsername = "P.AUOPRTMIGP.10@ey.com" #
#$spopUsername = "ey\P.AUOPRTMIGP.10" #
#$spopUsername = "P.AUOPRTMIGP.10" #
#$spopPassword = "cL95H@urF7~Vk3%" #

# DMZ
#$spopUsername = "Z.AUOPRTMIGP.10@ey.com"
$spopUsername = "Z.AUOPRTMIGP.10"
$spopPassword = "xSTQGPNkA62)0I#"


## Connect to SPOP 1 - Pass Crednetials
$spopPasswordSG = ConvertTo-SecureString $spopPassword -AsPlainText -Force
$spopSiteSG = Connect-Site -Url $spopSite -Username $spopUsername -Password $spopPasswordSG 

## Connect to SPOP 2 - Browser
Connect-Site -Url $spopSite -Browser

## Connect to SPOP - UseCredentialsFrom
$connection = Connect-Site -Url $spopSite -Browser
Connect-Site -Url $spopSite1 -UseCredentialsFrom $connection
Connect-Site -Url $spopSite2 -UseCredentialsFrom $connection

## Connect to SPO 1 - Pass Credentials
$spoPasswordSG = ConvertTo-SecureString $spoPassword -AsPlainText -Force
$spoSiteSG = Connect-Site -Url $spoSite -Username $spoUsername -Password $spoPasswordSG

## Connect to SPO 2 - Prompt
$Credentials = Get-Credential
Connect-Site -Url $spoSite -Credential $Credentials

## Connect to SPO 3 - Browser
Connect-Site -Url $spoSite -Browser

## Connect to SPO 4 - W/O SSO
Connect-Site -Url $spoSite -Browser -DisableSSO

### --- Copy Groups --- ###

## Get Groups to Copy
$srcSite = Connect-Site -Url $spoSite -Username $spoUsername -Password $spoPasswordSG # Must First Run Full Connection Code
$dstSite = Connect-Site -Url $spoSite -Username $spopUsername -Password $spopPasswordSG # Must First Run Full Connection Code
$toCopy = Get-Group -Site $srcSite
Copy-Group -Group $toCopy -DestinationSite $dstSite

## Copy All Groups
#$srcSite = Connect-Site -Url $spoSite -Username $spoUsername -Password $spoPasswordSG # Must First Run Full Connection Code
#$dstSite = Connect-Site -Url $spoSite -Username $spopUsername -Password $spopPasswordSG # Must First Run Full Connection Code
#Copy-Group -All -SourceSite $srcSite -DestinationSite $dstSite

## Copy Specific Groups
$dstSite = Connect-Site -Url $spoSite -Username $spoUsername -Password $spoPasswordSG # Must First Run Full Connection Code
$srcSite = Connect-Site -Url $spoSite -Username $spopUsername -Password $spopPasswordSG # Must First Run Full Connection Code
Copy-Group -Name $Groups1 -SourceSite $srcSite -DestinationSite $dstSite

## Copy Groups PreCheck
$srcSite = Connect-Site -Url $spoSite -Username $spoUsername -Password $spoPasswordSG # Must First Run Full Connection Code
$dstSite = Connect-Site -Url $spopSite -Username $spopUsername -Password $spopPasswordSG # Must First Run Full Connection Code 
Copy-Group -All -SourceSite $srcSite -DestinationSite $dstSite -WhatIf

### --- Copy Lists --- ##

## Get Lists to Copy
$srcSite = Connect-Site -Url $spoSite -Username $spoUsername -Password $spoPasswordSG # Must First Run Full Connection Code
$dstSite = Connect-Site -Url $spopSite -Username $spopUsername -Password $spopPasswordSG # Must First Run Full Connection Code 
$toCopy = Get-List -Site $srcSite
Copy-List -List $toCopy -DestinationSite $dstSite

## Copy All Lists
$srcSite = Connect-Site -Url $spoSite -Username $spoUsername -Password $spoPasswordSG # Must First Run Full Connection Code
$dstSite = Connect-Site -Url $spopSite -Username $spopUsername -Password $spopPasswordSG # Must First Run Full Connection Code
Copy-List -All -SourceSite $srcSite -DestinationSite $dstSite

## Copy Some Lists
$srcSite = Connect-Site -Url $spoSite -Username $spoUsername -Password $spoPasswordSG # Must First Run Full Connection Code
$dstSite = Connect-Site -Url $spopSite -Username $spopUsername -Password $spopPasswordSG # Must First Run Full Connection Code
Copy-List -SourceSite $srcSite -Name MyTitle*,MySpecificTitle -DestinationSite $dstSite

## Copy All Lists PreCheck
#$srcSite = Connect-Site -Url $spoSite -Username $spoUsername -Password $spoPasswordSG # Must First Run Full Connection Code
$srcSite = Connect-Site -Url $spoSite -Browser -DisableSSO
$dstSite = Connect-Site -Url $spopSite -Username $spopUsername -Password $spopPasswordSG # Must First Run Full Connection Code
Copy-List -All -SourceSite $srcSite -DestinationSite $dstSite -WhatIf

### --- Reports --- ###

## Export Copy Result with All Columns
$srcSite = Connect-Site -Url $spoSite -Browser -DisableSSO
$dstSite = Connect-Site -Url $spopSite -Username $spopUsername -Password $spopPasswordSG # Must First Run Full Connection Code
$result = Copy-List -All -SourceSite $srcSite -DestinationSite $dstSite
Export-Report $result -Path "C:\Test\Stage\Report\CopyContentReports.xlsx"

## Export Copy Result with Default Columns
$srcSite = Connect-Site -Url $spoSite -Browser -DisableSSO
$dstSite = Connect-Site -Url $spopSite -Username $spopUsername -Password $spopPasswordSG # Must First Run Full Connection Code
$result = Copy-List -All -SourceSite $srcSite -DestinationSite $dstSite
#Export-Report $result -Path "C:\Test\Stage\Report\CopyContentReports.xlsx" -DefaultColumns # Excel File
Export-Report $result -Path "C:\Test\Stage\Report\CopyContentReports.csv" -DefaultColumns # CSV File

## Export Copy Result with session ID as file name
$srcSite = Connect-Site -Url $spoSite -Browser -DisableSSO
$dstSite = Connect-Site -Url $spopSite -Username $spopUsername -Password $spopPasswordSG # Must First Run Full Connection Code
$srcList = Get-List -Name $Lists1 -Site $srcSite
$dstList = Get-List -Name $Lists1 -Site $dstSite
$result = Copy-Content -SourceList $srcList -DestinationList $dstList
Export-Report $result -Path "C:\Test\Stage\Report\"
# Note: By specifying a path with no file name, your report is exported as an Excel spreadsheet with the session ID as the file name. 
# This is ideal when exporting migration reports in a foreach loop.



### --- Test Snippets --- ###




### --- Test Sites --- ###

# https://eygb.sharepoint.com/sites/eyimdGBR-0001635-MC
# https://eyus.sharepoint.com/sites/eyimdUSA-0036388-MM, https://us.eyonespace.ey.com/Sites/eb3c0602f35f4adf9336638e4bf02d34
# https://eyus.sharepoint.com/sites/eyimdUSA-0041706-MM, https://us.tdm.ey.net/sites/aea2edb2c272474392bb04b3fe9b8ba4
# https://eyaustralia.sharepoint.com/sites/eyimdAUS-0020203-MM, https://au.eyonespace.ey.com/sites/bec2c75acc064e7c92802eb4ec130696
# https://eyus.sharepoint.com/sites/eyimdUSA-0039895-MM, https://us.tdm.ey.net/sites/5afc1e13eac141aaa518d70b34a0fbff# https://sites.ey.com/sites/eyimdDNK-0027938-MM, https://eyonespace.ey.com/Sites/fe1527d7f0e7466ea3f11c51beeaa97e
