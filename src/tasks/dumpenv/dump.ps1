[CmdletBinding()]
param()

# For more information on the VSTS Task SDK:
# https://github.com/Microsoft/vsts-task-lib
Trace-VstsEnteringInvocation $MyInvocation
try {

   $var = (Get-ChildItem env:*).GetEnumerator() | Sort-Object Name
   $out = ""
   Foreach ($v in $var) {$out = $out + "`t{0,-28} = {1,-28}`n" -f $v.Name, $v.Value}

   $fileName = [System.IO.Path]::GetTempFileName();
   Write-Output "dump variables on $fileName"
   Set-Content $fileName $out

   Write-Output "##vso[task.addattachment type=Distributedtask.Core.Summary;name=Environment Variables;]$fileName"

   # Output the message to the log.
   Write-Output (Get-VstsInput -Name msg)
} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}
