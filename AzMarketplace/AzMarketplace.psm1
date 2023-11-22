# Inspiration: https://github.com/RamblingCookieMonster/PSStackExchange/blob/master/PSStackExchange/PSStackExchange.psm1

New-Variable -Scope Script -Name AccessToken -Value $null
New-Variable -Scope Script -Name AccessTokenExpiresOn -Value $null
New-Variable -Scope Script -Name ClientId -Value $null
New-Variable -Scope Script -Name TenantId -Value $null
New-Variable -Scope Script -Name ClientSecret -Value $null

#Get public and private function definition files.
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue -Exclude "*.test.*" )

#Dot source the files
Foreach($import in @($Public + $Private))
{
    Try
    {
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function $Public.Basename