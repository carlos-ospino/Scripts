Import-Csv -Path 'C:\Users\CarlosJavierOspino\OneDrive - carlosospino.com\COEM\9.Proyectos 2023\Zentria\Lotes\lotes7-8.csv' | foreach {  
 $Emailaddress=$_.Emailaddress
 Write-Progress -Activity "Adding $Emailaddress to group… " 
 Add-DistributionGroupMember –Identity MailboxCrossTenantMig@bienestaripssas.onmicrosoft.com -Member $Emailaddress  
 If($?)  
 {  
 Write-Host $Emailaddress Successfully added -ForegroundColor Green 
 }  
 Else  
 {  
 Write-Host $Emailaddress - Error occurred –ForegroundColor Red  
 }  
} 