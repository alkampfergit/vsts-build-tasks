[CmdletBinding(DefaultParameterSetName = 'None')]
param(
    [Parameter(Mandatory=$true)][string] $compress,
    [Parameter(Mandatory=$true)][string] $source,
    [Parameter(Mandatory=$true)][string] $destination,
    [Parameter(Mandatory=$false)][string] $sevenZipExe = ".\7z\7za.exe"
)

if(Get-Module -name utility) 
{
    Remove-Module utility
}

$runningDirectory = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

if(-not(Get-Module -name utility)) 
{
    Import-Module -Name ".\utility"
}

if (-not (test-path $sevenZipExe)) 
{
    Write-Output "7zip not present, download from web location"
    Invoke-WebRequest -Uri "http://www.7-zip.org/a/7za920.zip" -OutFile "$runningDirectory\7zip.zip"
    Write-Output "Unzipping $runningDirectory\7zip.zip to directory $runningDirectory\7z"
    Expand-WithFramework -zipFile "$runningDirectory\7zip.zip" -destinationFolder "$runningDirectory\7z" -quietMode $true 
} 
set-alias sz $sevenZipExe 

if ($compress -eq "true") 
{
    Write-Output "Commandline: 7za a -mx=9 $destination $source"
    sz a -mx=9 $destination $source
}
else
{
    $destinationOption = "-o" + $destination
    Write-Output "Commandline: 7za x $source $destination -y"
    sz x $source $destinationOption -y
}



   


