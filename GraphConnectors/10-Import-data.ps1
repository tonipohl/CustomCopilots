#-------------------------------------------
# 10-Import-data.ps1
#-------------------------------------------
# Import data from a CSV file
# https://docs.microsoft.com/en-us/graph/connecting-external-content-connectors-api-postman#step-9---ingest-items
# atwork.at. Toni Pohl

# The csv file holds some demo data to import.
$connector = "M365Conf"
$allsessions = Import-Csv ".\m365conf.csv" -Delimiter ";" -Encoding UTF8

$i = 1
foreach ($session in $allsessions) {
  # In real world, use a GUID as Id, such as: $itemid = New-Guid
  # Convert "30.11.2021 10:15" to "2021-11-14T22:49:22.3701848Z"
  # $sessionstart = [datetime]::parseexact($session.StartDate, 'dd.MM.yyyy HH:mm', $null).ToString('O')
  # overwrite with the new date format for a nice output
  # Find more about ACL at https://learn.microsoft.com/en-us/graph/connecting-external-content-manage-items
  Write-Output "-- $i. ID $($session.ID) --"
  
  $body = @"
{
  "acl": [
    {
      "type": "everyone",
      "value": "c5f19b2d-0a77-454a-9b43-abf298c3b34e",
      "accessType": "grant"
    }
  ],
  "properties": {
    "id": "$($session.id)",
    "title": "$($session.title)",
    "date": "$($session.date)",
    "speaker": "$($session.speaker)",
    "room": "$($session.room)",
    "audience": "$($session.audience)",
    "type": "$($session.type)",
    "audience": "$($session.audience)",
    "url": "$($session.url)",
    "description": "$($session.description)",
    "format": "$($session.format)",
    "level": "$($session.level)",
    "products": "$($session.products)", 
  },
  "content": {
    "type": "text",
    "value": "The session with Id $($session.id) and title '$($session.title)' takes place on $($session.date) in room '$($session.room)'. 
    The Speaker is $($session.speaker). The session is a $($session.format) session of type type $($session.type) with a level of $($session.level) and is about $($session.products).
    This session is part of the Microsoft 365 Community Conference (M365Conf) [$($connector)] that takes place in Orlando, USA, from April 28th to May 3rd 2024. See the session details here.

    Session Id: $($session.id)
    $($session.title)
    $($session.date)
    $($session.room)
    $($session.speaker)
    $($session.description)"
  }
}
"@

  Invoke-RestMethod `
    -Method Put `
    -Uri "https://graph.microsoft.com/v1.0/external/connections/$connector/items/$($session.ID)" `
    -ContentType 'application/json' `
    -Headers $script:APIHeader `
    -Body $body `
    -ErrorAction Stop -Verbose 

  $i++
}

Write-Output "$($i-1) items imported."
