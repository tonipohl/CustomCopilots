#-------------------------------------------
# 1-Get-Token-app.ps1
#-------------------------------------------
# Get an authentication token as app
# atwork.at. Toni Pohl

# How can I secure the $secret in PowerShell so that it is not visibel in the code?
# https://stackoverflow.com/questions/46442367/how-can-i-secure-the-secret-in-powershell-so-that-it-is-not-visibel-in-the-code

$tenantId = '<your-tenantid>'
$appId = "<your-appid>"
$secret = Get-Content ".\app-secret.txt"

function Initialize-Authorization {
    param
    (
        [string]
        $ResourceURL = 'https://graph.microsoft.com',
  
        [string]
        [parameter(Mandatory)]
        $tenantId,
      
        [string]
        [Parameter(Mandatory)]
        $secret,
  
        [string]
        [Parameter(Mandatory)]
        $appId
    )

    $Authority = "https://login.microsoftonline.com/$tenantId/oauth2/token"

    [Reflection.Assembly]::LoadWithPartialName("System.Web") | Out-Null
    $EncodedKey = [System.Web.HttpUtility]::UrlEncode($secret)

    $body = "grant_type=client_credentials&client_id=$appId&client_secret=$EncodedKey&resource=$ResourceUrl"

    # Request a Token from the Graph Api
    $authresult = Invoke-RestMethod -Method POST `
        -Uri $Authority `
        -ContentType 'application/x-www-form-urlencoded' `
        -Body $body

    # store the result on the $script object that is only available to the script scope
    $script:APIHeader = @{'Authorization' = "Bearer $($authresult.access_token)" }

    # If needed, for developing purposes, we store the current token locally, e.g. for using in PostMan
    Write-Output $authresult.access_token | Out-File -FilePath ".\token.txt" -Encoding Ascii

    # If needed, check the token content
    # https://jwt.ms/
}

# Get authorization data with the app data
Initialize-Authorization -tenantId $tenantId -secret $secret -appId $appId

$script:APIHeader

# For Azure, check https://docs.microsoft.com/en-us/powershell/azure/authenticate-azureps?view=azps-6.6.0