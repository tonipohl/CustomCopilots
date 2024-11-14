#-------------------------------------------
# 3-Create-connector.ps1
#-------------------------------------------
# Get all existing connectors with the token
# See more at https://docs.microsoft.com/en-us/graph/connecting-external-content-connectors-api-postman
# atwork.at. Toni Pohl

# Note: We use this variable in the following scripts
$connector = "Conference"

$body = @"
{
    "id": "$connector",
    "name": "$connector",
    "description": "External data from the $connector event. It includes sessions, speakers, rooms and more.",
}
"@

Invoke-RestMethod `
    -Method POST `
    -Uri "https://graph.microsoft.com/v1.0/external/connections" `
    -ContentType 'application/json' `
    -Headers $script:APIHeader `
    -Body $body `
    -ErrorAction Stop
