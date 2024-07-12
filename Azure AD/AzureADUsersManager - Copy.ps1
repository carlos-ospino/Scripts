#Read user details from the CSV file
$CSVRecords = Import-CSV "C:\Scripts\AzureADUsersManager.csv"
$i = 0;
$TotolRows = $CSVRecords.Count
 
#Array to add the status result
$UpdateResult=@()
 
#Iterate CSVRecords (users) and set manager for users one by one
Foreach($CSVRecord in $CSVRecords)
{
$UserUPN = $CSVRecord.'UserUPN'
$ManagerUPN = $CSVRecord.'ManagerUPN'
 
$i++;
Write-Progress -activity "Processing $UserUPN (Manager-$ManagerUPN)" -status "$i out of $TotolRows users completed"
 
Try
{
 
#Set-AzureADUserManager cmdlet - the RefObjectId parameter requires the manager's ObjectId.
#The below command retrieves the ObjectId using the manager's UPN
$ManagerObj = Get-AzureADUser -ObjectId $ManagerUPN
 
#Set the manager
Set-AzureADUserManager -ObjectId $UserUPN -RefObjectId $ManagerObj.ObjectId
#Set update status
$UpdateStatus = "Success"
}
catch
{
$UpdateStatus = "Failed: $_"
}
 
#Add update status to the result array
$UpdateResult += New-Object PSObject -property $([ordered]@{
UserUPN = $UserUPN
ManagerUPN = $ManagerUPN
Status = $UpdateStatus
})
 
}
 
#Display the update status result 
$UpdateResult | Select UserUPN,ManagerUPN,Status
 
#Export the update status report to a CSV file
#$UpdateResult | Export-CSV "C:\Temp\UpdateManagerStatus.CSV" -NoTypeInformation -Encoding UTF8