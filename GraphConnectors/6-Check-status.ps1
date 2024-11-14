#-------------------------------------------
# 6-Check-status.ps1
#-------------------------------------------
# To check connection schema status, execute the following request:
# https://docs.microsoft.com/en-us/graph/connecting-external-content-connectors-api-postman#step-7---register-connection-schema
# atwork.at. Toni Pohl

$result = $null
$connector = "Conference"

$result = Invoke-RestMethod `
        -Method GET `
        -Uri "https://graph.microsoft.com/v1.0/external/connections/$connector/schema" `
        -ContentType 'application/json' `
        -Headers $script:APIHeader `
        -ErrorAction Stop

# Show the result
$connector
$result | fl
$result.properties
