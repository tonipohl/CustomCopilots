#-------------------------------------------
# 9-Delete-item.ps1
#-------------------------------------------
# Delete a specific item
# https://docs.microsoft.com/en-us/graph/connecting-external-content-connectors-api-postman
# atwork.at. Toni Pohl

$connector = "Conference"

# Delete the connector:
# DELETE /external/connections/{connectionsId}
# Delete one item
# DELETE /external/connections/{connectionsId}/items/{externalItemId}

$itemid = "201"
Write-Output $itemid

Invoke-RestMethod `
        -Method DELETE `
        -Uri "https://graph.microsoft.com/v1.0/external/connections/$connector/items/$itemid" `
        -ContentType 'application/json' `
        -Headers $script:APIHeader `
        -ErrorAction Stop

<#
# Delete items in a loop...
for ($i = 1; $i -le 200; $i++) {

        Write-Output "../$connector/items/$i"
        $url = "https://graph.microsoft.com/v1.0/external/connections/$connector/items/$i" 

        Invoke-RestMethod `
                -Method DELETE `
                -Uri $url `
                -ContentType 'application/json' `
                -Headers $script:APIHeader 
}
#>
