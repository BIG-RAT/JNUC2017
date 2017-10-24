
$creds = Get-Credential
$xml = Invoke-RestMethod -Method GET -Header @{"Accept"="application/xml"} -Uri https://manage.lab.private:8443/JSSResource/osxconfigurationprofiles  -SkipCertificateCheck -Credential $creds
foreach($name in $xml.os_x_configuration_profiles.os_x_configuration_profile.name) {
    Write-Host $name
}