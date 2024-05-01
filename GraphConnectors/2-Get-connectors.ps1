#-------------------------------------------
# 2-Get-connectors.ps1
#-------------------------------------------
# Get all existing connectors with the token
# See more at https://docs.microsoft.com/en-us/graph/connecting-external-content-connectors-api-postman
# atwork.at. Toni Pohl

$result = Invoke-RestMethod `
        -Method GET `
        -Uri "https://graph.microsoft.com/v1.0/external/connections" `
        -ContentType 'application/json' `
        -Headers $script:APIHeader `
        -ErrorAction Stop

# Show the connections
$result.value | ft
