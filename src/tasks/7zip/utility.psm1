function Expand-WithFramework(
    [string] $zipFile,
    [string] $destinationFolder,
    [bool] $deleteOld = $true,
    [bool] $quietMode = $false
)
{
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    if ((Test-Path $destinationFolder) -and $deleteOld)
    {
          Remove-Item $destinationFolder -Recurse -Force
    }
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $destinationFolder)

}

function Expand-With7zip(
    [string] $zipFile,
    [string] $destinationFolder,
    [bool] $deleteOld = $true,
    [bool] $quietMode = $false,
    [string] $sevenZipExe = 'c:\Program Files\7-Zip\7z.exe'
)
{
    if (-not (test-path $sevenZipExe)) 
    {
        throw "$env:ProgramFiles\7-Zip\7z.exe needed"
        Exit 
    } 
    set-alias sz $sevenZipExe 

    $destinationOption = "-o" + $destinationFolder
    sz x $zipFile $destinationOption -y
}

function Compress-With7zip(
    [string] $sourceFolder,
    [string] $destinationFolder,
    [string] $extension = '.7z',
    [string] $sevenZipExe = 'c:\Program Files\7-Zip\7z.exe'
)
{
   
    if (-not (test-path $sevenZipExe)) 
    {
        throw "$env:ProgramFiles\7-Zip\7z.exe needed"
        Exit 
    } 
    set-alias sz $sevenZipExe 

    sz a -mx=9 $destinationFolder $sourceFolder
}
