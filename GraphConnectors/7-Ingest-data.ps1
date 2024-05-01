#-------------------------------------------
# 7-Ingest-data.ps1
#-------------------------------------------
# Create a new item
# https://docs.microsoft.com/en-us/graph/connecting-external-content-connectors-api-postman#step-9---ingest-items
# atwork.at. Toni Pohl

# 2022-12-067T11:04:00Z
$now = Get-Date -Format O
Write-Output $now

$connector = "M365conf"

# In real world, use a GUID as Id. This here is just to simplify the Id to make it more readable.
# $itemid = New-Guid
# $itemid = Get-Date -Format "HHmmss"
$itemid = "201"
Write-Output $itemid

$body = @"
{
  "acl": [
    {
      "type": "everyone",
      "value": "<some-groupid>",
      "accessType": "grant"
    }
  ],
  "properties": {
    "id": "$itemid",
    "title": "The Age of Copilots",
    "date": "$now",
    "speaker": "Jeff Teper",
    "room": "Keynote Room",
    "audience": "All",
    "type": "KEYNOTE",
    "url": "https://m365conf.com/#!/sessions",
    "description": "Join Jeff Teper, along with other leaders, to see how new innovation in Microsoft Copilot, combined with the familiarity and scale of Microsoft 365, will unlock productivity and transform business processes for everyone across all functions and every industry in this new era of AI.",
    "format": "KEYNOTE",
    "level": "100",
    "products": "Azure, Microsoft 365"
  },
  "content": {
    "type": "text",
    "value": "The Age of Copilots. Join Jeff Teper, along with other leaders, to see how new innovation in Microsoft Copilot, combined with the familiarity and scale of Microsoft 365, will unlock productivity and transform business processes for everyone across all functions and every industry in this new era of AI."
  }
}
"@

$result = Invoke-RestMethod `
        -Method PUT `
        -Uri "https://graph.microsoft.com/v1.0/external/connections/$connector/items/$itemid" `
        -ContentType 'application/json' `
        -Headers $script:APIHeader `
        -Body $body `
        -ErrorAction Stop

# Show the result
$result

