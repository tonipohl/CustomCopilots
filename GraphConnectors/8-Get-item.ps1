#-------------------------------------------
# 8-Get-item.ps1
#-------------------------------------------
# Get a specific item
# https://docs.microsoft.com/en-us/graph/connecting-external-content-connectors-api-postman
# atwork.at. Toni Pohl

# Get an itme by its id
$connector = "M365Conf"
$itemid = "201"
Write-Output $itemid

$result = Invoke-RestMethod `
        -Method GET `
        -Uri "https://graph.microsoft.com/v1.0/external/connections/$connector/items/$itemid" `
        -ContentType 'application/json' `
        -Headers $script:APIHeader `
        -ErrorAction Stop

# Show the result
$result
$result.properties

