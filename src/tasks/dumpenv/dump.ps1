[CmdletBinding()]
param()

# For more information on the VSTS Task SDK:
# https://github.com/Microsoft/vsts-task-lib
Trace-VstsEnteringInvocation $MyInvocation
try {

   $var = (Get-ChildItem env:*).GetEnumerator() | Sort-Object Name
   $out = ""
   Foreach ($v in $var) {$out = $out + "`t{0,-28} = {1,-28}`n" -f $v.Name, $v.Value}

   #$fileName = [System.IO.Path]::GetTempFileName() + ".md";
   $fileName = "$env:BUILD_ARTIFACTSTAGINGDIRECTORY\environment_variables.md"
   Write-Output "--------------------- VARIABLE NAMES ----------------------------"
   Write-Output $out

   Write-Output "Dumping variables on $fileName"
   $out | Out-File -FilePath $fileName -Force

   Write-Output "Attaching report to build with command ##vso[task.addattachment type=Distributedtask.Core.Summary;name=Environment Variables;]$fileName"
   Write-Output "##vso[task.addattachment type=Distributedtask.Core.Summary;name=Environment Variables;]$fileName"
} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}
