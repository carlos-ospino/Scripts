Import-Module Microsoft.Online.SharePoint.PowerShell
 
#Parameters
$TenantAdminURL = "https://helpharmacol-admin.sharepoint.com"
$CSVFilePath = "C:\Scripts\Sharepoint Online\SiteCollectionAdmin.csv"
 
Try {
    #Connect to Admin Center
    Connect-SPOService -Url $TenantAdminURL
 
    #Get data from the CSV file
    $CSVData = Import-Csv $CSVFilePath
 
    #Iterate through each row in the CSV
    ForEach($Row in $CSVData)
    {
        Try{
            #Add Site collection Admin
            Set-SPOUser -site $Row.SiteURL -LoginName $Row.SiteCollectionAdmin -IsSiteCollectionAdmin $True | Out-Null
            Write-host "Added Site collection Administrator to $($Row.SiteURL)" -f Green
        }
        Catch {
            write-host -f Yellow "`tError Adding Site Collection Admin to $($Row.SiteURL) :" $_.Exception.Message
        }
    }
}
Catch {
    write-host -f Red "`tError:" $_.Exception.Message
}