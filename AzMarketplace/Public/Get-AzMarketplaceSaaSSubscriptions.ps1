<#
.SYNOPSIS
Retrieves Azure Marketplace subscriptions.

.DESCRIPTION
The Get-AzMarketplaceSubscriptions function is used to retrieve Azure Marketplace subscriptions by making calls to the Azure Marketplace API.

.PARAMETER None
This function does not accept any parameters.

.EXAMPLE
Get-AzMarketplaceSubscriptions
Retrieves all Azure Marketplace subscriptions.

.NOTES
This function requires the AzMarketplace module to be imported.

.LINK
https://docs.microsoft.com/en-us/azure/marketplace/

#>
function Get-AzMarketplaceSaaSSubscriptions {
    [CmdletBinding()]
    Param()
    Process {
        try {
            Update-AzMarketplaceAccessToken
            
            $correlationid = [Guid]::NewGuid().ToString()
            $uri = "https://marketplaceapi.microsoft.com/api/saas/subscriptions?api-version=2018-08-31"
            
            while ($uri) {
                Write-Verbose "$correlationid - Getting subscriptions from fullfillment API: $uri"
                $result = Invoke-RestMethod -uri $uri -Headers @{
                    "x-ms-correlationid" = $correlationid
                    "Authorization"      = "Bearer $($Script:AccessToken)"
                } -Method Get
        
                if ($result.subscriptions) {
                    $result.subscriptions
                }
                $uri = $result."@nextLink"
            }
        }
        catch {
            Write-Error "$correlationid - Caught error when getting subscriptions: $($_)"
            return;
        }
    }
}
