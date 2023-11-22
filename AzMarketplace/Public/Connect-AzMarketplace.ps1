<#
.SYNOPSIS
Uses client credentials for connecting to Azure Marketplace

.EXAMPLE
Connect-AzMarketplace -ClientId "2d7933ea-4fe0-42b2-aa6c-d00bed38e7e0" -TenantId "4t2.no" -ClientSecret "rqj8Q...asokd"

#>
function Connect-AzMarketplace {
    [CmdletBinding()]

    Param
    (
        [Parameter(Mandatory = $true, Position = 0)]
        [String] $ClientId,

        [Parameter(Mandatory = $true, Position = 1)]
        [String] $ClientSecret,

        [Parameter(Mandatory = $true, Position = 2)]
        [String] $TenantId
    )
    
    Process {
        $Script:ClientId = $ClientId
        $Script:ClientSecret = $ClientSecret
        $Script:TenantId = $TenantId

        Update-AzMarketplaceAccessToken
    }
}