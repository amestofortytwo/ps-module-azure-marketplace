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
function Send-AzMarketplaceMeteredBillingSingleUsageEvent {
    [CmdletBinding()]
    Param(
        # Unique identifier of the resource against which usage is emitted. 
        [Paramter(Mandatory = $true)]
        [String] $resourceId,

        # How many units were consumed for the date and hour specified in effectiveStartTime, must be greater than 0 or a double integer
        [Paramter(Mandatory = $true)]
        [Double] $quantity,

        # Custom dimension identifier
        [Paramter(Mandatory = $true)]
        [String] $dimension,

        # time in UTC when the usage event occurred, from now and until 24 hours back
        [Paramter(Mandatory = $false)]
        [DateTime] $effectiveStartTime = (Get-Date),

        # id of the plan purchased for the offer
        [Paramter(Mandatory = $true)]
        [String] $planId
    )
    Process {
        try {
            Update-AzMarketplaceAccessToken
            
            $correlationid = [Guid]::NewGuid().ToString()
            $uri = "https://marketplaceapi.microsoft.com/api/usageEvent?api-version=2018-08-31"
            
            Invoke-RestMethod -uri $uri -Headers @{
                "x-ms-correlationid" = $correlationid
                "Authorization"      = "Bearer $($Script:AccessToken)"
            } -Method Post -ContentType "application/json" -Body (@{
                resourceId = $resourceId
                quantity = $quantity
                dimension = $dimension
                effectiveStartTime = $effectiveStartTime.ToString("yyyy-MM-ddTHH:mm:ss")
                planId = $planId
            } | covertto-json)
        }
        catch {
            Write-Error "$correlationid - Caught error when sending single usage event: $($_)"
            return;
        }
    }
}
