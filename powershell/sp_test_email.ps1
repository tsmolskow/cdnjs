$server = hostname
$sd = new-object System.collections.specialized.stringdictionary
$sd.add("to","webmaster@blackhillscorp.com")
$sd.add("from","$server@localhost")
$sd.add("Subject","Test message from $server")
$web = get-spweb "https://connect.bhcorp.ad"
$body = "Test is a test message from $server through sharepoint services."

[Microsoft.SharePoint.Utilities.SPUtility]::SendEmail($web,$sd,$body)
