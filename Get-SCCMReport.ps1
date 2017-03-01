$username = Read-Host "Enter ID with doamin - example :mgroupnet\umy-extra :"
$password = Read-Host "Password:"
$servers = Get-Content ".\servers.txt"
foreach($server in $servers)
{
$xhttp = $nul
$stream = $nul
$url = 'http://mps1530/SMSReporting_CCM/Report.asp?ReportID=170&MachineName='+$server+'&Vendor=&UpdateClass=&SortRs1Col=8&SortRs1Dir=2'
$destination = "c:\temp\$server.csv"
#Start XML
$xhttp = new-object -com msxml2.xmlhttp
$xhttp.open("Post",$url,$false,$username,$password)
$xhttp.setrequestheader("Content-Type","application/x-www-form-urlencoded")
#this sends the request to perform a CSV export
$xhttp.send("export=yes")
#This line's not needed but I use it to get confirmation
#that the download is queued correctly.  If not OK then
#I know to check the above part of this script
$xhttp.statustext
#Now grab the file in the buffer and save it to disk
$stream = new-object -com ADODB.Stream
$stream.open()
$stream.type = 1
#Connect the buffer to the downloaded file
$stream.write($xhttp.responsebody)
$stream.savetofile($destination,2)
$stream.close()
$stream = $nul
}
--------