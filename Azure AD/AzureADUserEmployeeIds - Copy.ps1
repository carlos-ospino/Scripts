#Read user details from the CSV file
$AzureADUsers = Import-CSV "C:\Scripts\AzureADUserEmployeeIds.csv"
$i = 0;
$TotalRows = $AzureADUsers.Count
 
#Array to add add status result
$UpdateResult=@()
 
#Iterate users and set employeeId attribute value one by one
Foreach($UserInfo in $AzureADUsers)
{
$UserId = $UserInfo.'UserPrincipalName'
$EmployeeId = $UserInfo.'EmployeeId'
 
$i++;
Write-Progress -activity "Processing $UserId " -status "$i out of $TotalRows completed"
 
try
{
#Set the employeeId attribute value
Set-AzureADUserExtension -ObjectId $UserId -ExtensionName "employeeId" -ExtensionValue $EmployeeId
$UpdateStatus = "Success"
}
catch
{
$UpdateStatus = "Failed: $_"
}
 
#Add update result status
$UpdateResult += New-Object PSObject -property $([ordered]@{
User = $UserId
Status = $UpdateStatus
})
}
 
#Display the update status result
$UpdateResult | Select User,Status
 
#Export the update status report to CSV file
#$UpdateResult | Export-CSV "C:\Temp\UpdateEmployeeIdStatus.CSV" -NoTypeInformation -Encoding UTF8
