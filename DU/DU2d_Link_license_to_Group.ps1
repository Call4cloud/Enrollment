###########################################################################
#        Versie:  1.0 (07-04-2021)
#        Script:  DU.1e
#        Licentie aan groep koppelen
###########################################################################


$body = @{
            addLicenses = @(
                @{
                    skuId = 'cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46'
                 }
                            )
            removeLicenses = @()
          } | ConvertTo-Json -Depth 3

$content = $body
$url = -join ('https://graph.microsoft.com/v1.0/groups/',$ms365licensegroupid,'/assignLicense')
$Data = Invoke-RestMethod -Headers @{Authorization = "Bearer $($accessToken1e)"} -Uri $Url -Body $body -Method Post -ContentType 'application/json'
