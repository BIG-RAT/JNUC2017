# ignore self signed certs
function Ignore-SelfSignedCerts
{
    try
    {
        Write-Host "Adding TrustAllCertsPolicy type." -ForegroundColor White
        Add-Type -TypeDefinition  @"
        using System.Net;
        using System.Security.Cryptography.X509Certificates;
        public class TrustAllCertsPolicy : ICertificatePolicy
        {
             public bool CheckValidationResult(
             ServicePoint srvPoint, X509Certificate certificate,
             WebRequest request, int certificateProblem)
             {
                 return true;
            }
        }
"@
        Write-Host "TrustAllCertsPolicy type added." -ForegroundColor White
      }
    catch
    {
        Write-Host $_ -ForegroundColor "Yellow"
    }
    [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
}
Ignore-SelfSignedCerts

Clear-Host
$creds = Get-Credential
$deptEndpoint = "https://manage.lab.private:8443/JSSResource/departments/id/0"

$departments = get-aduser -filter * -property department | Select-Object -ExpandProperty department | Sort-Object -Unique
foreach($dept in $departments) {
    $deptXml = "<department><name>$dept</name></department>"

    try {
        $response = Invoke-RestMethod -Method POST -Uri $deptEndpoint -Credential $creds -Body $deptXml -ContentType 'application/xml'
        Start-Sleep -m 1000
    } catch {
        Write-Host "error adding $dept"
        Write-Host ""
    }
}
