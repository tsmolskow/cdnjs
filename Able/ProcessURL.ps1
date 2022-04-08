$fileUrl = "http://atlas-uat.westlake.com"

$destinationfolder = "E:\Scripts\Output"

    function ProcessURL {
        param($fileUrl,$destinationfolder)
        $pathToTry = "http://atlas-uat.westlake.com/ATLAS365Sites"
        $site = New-Object -Type Microsoft.SharePoint.SPSite -ArgumentList $pathToTry
        $web = $site.OpenWeb()  
        $file = $web.GetFile($fileUrl)
        $destinationfolder = $destination + "/" + $folder.Url 
        if (!(Test-Path -path $destinationfolder))
        {
            $dest = New-Item $destinationfolder -type directory 
        }
        #Download file
        $binary = $file.OpenBinary()
        $stream = New-Object System.IO.FileStream($destinationfolder + "/" + $file.Name), Create
        $writer = New-Object System.IO.BinaryWriter($stream)
        $writer.write($binary)
        $writer.Close()
        #Delete file by deleting parent SPListItem
        #$list.Items.DeleteItemById($file.Item.Id)
        $web.Close()
        $site.Close()
    }