#-------------------------------------------
# 5-Register-schema-events.ps1
#-------------------------------------------
# Register a schema for the data source
# https://docs.microsoft.com/en-us/graph/connecting-external-content-connectors-api-postman#step-7---register-connection-schema
# atwork.at. Toni Pohl

$connector = "M365conf"

# id,title,date,speaker,room,audience,type
# id	title	date	speaker	room	type	url	description	format	audience	level	products

$body = @'
{ 
  "baseType": "microsoft.graph.externalItem", 
  "properties": [ 
    {
      "name": "id",
      "type": "string",
      "isSearchable": true,
      "isRetrievable": true,
      "isQueryable": true,
      "aliases": ["identifier"]
    },
    {
      "name": "title",
      "type": "string",
      "isSearchable": true,
      "isRetrievable": true,
      "isQueryable": true,
      "isRefinable": false,
      "aliases": ["Session", "Name", "Topic"]
    },
    {
      "name": "date",
      "Type": "string", 
      "isSearchable": false, 
      "isQueryable": true, 
      "isRetrievable": true, 
      "isRefinable": true, 
      "aliases": ["Time"]
    },
    {
      "name": "speaker",
      "Type": "String", 
      "isSearchable": true, 
      "isQueryable": true, 
      "isRetrievable": true,
      "isRefinable": false, 
      "aliases": ["Person", "Expert", "Specialist"]
    },
    {
      "name": "room",
      "Type": "String", 
      "isSearchable": true, 
      "isQueryable": true, 
      "isRefinable": false, 
      "isRetrievable": true,
      "aliases": ["Location", "Place"]
    },
    {
      "name": "audience",
      "Type": "String", 
      "isSearchable": true, 
      "isQueryable": true, 
      "isRetrievable": true,
      "isRefinable": false,
      "aliases": ["TargetGroup", "TargetAudience"]
    },
    {
      "name": "type",
      "Type": "String", 
      "isSearchable": true, 
      "isQueryable": true, 
      "isRetrievable": true,
      "isRefinable": false,
      "aliases": ["Category", "Kind"]
    },
    {
      "name": "url",
      "Type": "String", 
      "isSearchable": true, 
      "isQueryable": true, 
      "isRetrievable": true,
      "isRefinable": false
    },
    {
      "name": "description",
      "Type": "String", 
      "isSearchable": true, 
      "isQueryable": true, 
      "isRetrievable": true,
      "isRefinable": false,
      "aliases": ["Note", "Details"]
    },
    {
      "name": "format",
      "Type": "String", 
      "isSearchable": true, 
      "isQueryable": true, 
      "isRetrievable": true,
      "isRefinable": false
    },
    {
      "name": "level",
      "Type": "String", 
      "isSearchable": true, 
      "isQueryable": true, 
      "isRetrievable": true,
      "isRefinable": false
    },
    {
      "name": "products",
      "Type": "String", 
      "isSearchable": true, 
      "isQueryable": true, 
      "isRetrievable": true,
      "isRefinable": false
    }
  ] 
  }
'@

Invoke-RestMethod `
  -Method POST `
  -Uri "https://graph.microsoft.com/v1.0/external/connections/$connector/schema" `
  -ContentType 'application/json' `
  -Headers $script:APIHeader `
  -Body $body `
  -ErrorAction Stop

