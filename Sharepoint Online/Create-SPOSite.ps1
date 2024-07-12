#Function to Create Site Collection
Function Create-SPOSite 
{
  param
    (
        [string]$Title  = $(throw "Please Provide the Site Title!"),
        [string]$URL = $(throw "Please Provide the Site URL!"),
        [string]$Owner = $(throw "Please Provide the Site Owner!"),
        [int]$StorageQuota = $(throw "Please Provide the Site Storage Quota!"),
        [int]$ResourceQuota = $(throw "Please Provide the Site Resource Quota!"),
        [string]$Template = $(throw "Please Provide the Site Template!")
    )
 
#Connection parameters 
$AdminURL = "https://grupozentria-admin.sharepoint.com"
 
#Get Credentials to connect
#$Cred= Get-Credential -Message "Enter the Admin Credentials"
#$Credentials = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $Cred.Username, $Cred.Password
  
Try{
    #Connect to Office 365
    #Connect-SPOService -Url $AdminURL -Credential $Credentials
    Connect-SPOService -Url https://grupozentria-admin.sharepoint.com
  
    #Check if the site collection exists already
    $SiteExists = Get-SPOSite -Limit All | where {$_.url -eq $URL}
    #Check if site exists in the recycle bin
    $SiteExistsInRecycleBin = Get-SPODeletedSite | where {$_.url -eq $URL}
 
    If($SiteExists -ne $null)
    {
        write-host "Site $($url) exists already!" -foregroundcolor red
    }
    elseIf($SiteExistsInRecycleBin -ne $null)
    {
        write-host "Site $($url) exists in the recycle bin!" -foregroundcolor red
    }
    else
    {
        #create the site collection
        New-SPOSite -Url $URL -title $Title -Owner $Owner -StorageQuota $StorageQuota -NoWait -ResourceQuota $ResourceQuota -Template $Template
        write-host "Site Collection $($url) Created Successfully!" -foregroundcolor Green
    }
}
catch {
    write-host "Error: $($_.Exception.Message)" -foregroundcolor Red
    }
}
 
#Read from CSV and create site collection
Import-Csv "C:\Temp\Sites\SiteCollections-NoTeams.csv" | Foreach-Object {
   Create-SPOSite -Title $_.SiteTitle -URL $_.SiteURL -Owner $_.SiteOwner -StorageQuota $_.StorageQuota -ResourceQuota $_.ResourceQuota -Template $_.SiteTemplate  }
