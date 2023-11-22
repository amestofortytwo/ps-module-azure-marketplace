<#
.SYNOPSIS
Uses client credentials for getting an access token for the Azure Marketplace API. Internal helper method.

.EXAMPLE
Update-AzMarketplaceAccessToken

#>
function Update-AzMarketplaceAccessToken {
    [CmdletBinding()]

    Param()
                    
    Begin {
        
    }
    Process {
        if($Script:AccessTokenExpiresOn -gt (Get-Date)) {
            return
        }
        
        try {
            $_accesstoken = Invoke-RestMethod "https://login.microsoftonline.com/$($Script:TenantId)/oauth2/token" -ContentType "application/x-www-form-urlencoded" -Body "client_id=$($Script:ClientId)&resource=20e940b3-4c77-4b0b-9a53-9e16a1b010a7&grant_type=client_credentials&client_secret=$([System.Web.HttpUtility]::UrlEncode($Script:ClientSecret))" -Method POST
        }
        catch {
            Write-Error "Caught error when getting access token: $($_)"
            return
        }

        if (!$_accesstoken.access_token) {
            Write-Error "Something is wrong with the response from Entra ID (Missing access_token)"
            return;
        }
        else {
            $Script:AccessToken = $_accesstoken.access_token
            $Script:AccessTokenExpiresOn = (Get-Date).AddMinutes(50)
        }
        #endregion
          
    }
    End {

    }
}