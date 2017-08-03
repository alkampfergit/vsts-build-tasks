[CmdletBinding()]
param()

# For more information on the VSTS Task SDK:
# https://github.com/Microsoft/vsts-task-lib
Trace-VstsEnteringInvocation $MyInvocation
try {
    # Set the working directory.
    $cwd = Get-VstsInput -Name cwd -Require
    Assert-VstsPath -LiteralPath $cwd -PathType Container
   $var = (Get-ChildItem env:*).GetEnumerator() | Sort-Object Name
   $out = ""
   Foreach ($v in $var) {$out = $out + "`t{0,-28} = {1,-28}`n" -f $v.Name, $v.Value}

   write-output "dump variables on $env:BUILD_ARTIFACTSTAGINGDIRECTORY\test.md"
   $fileName = "$env:BUILD_ARTIFACTSTAGINGDIRECTORY\test.md"
   set-content $fileName $out

    write-output "##vso[task.addattachment type=Distributedtask.Core.Summary;name=Environment Variables;]$fileName"

    # Output the message to the log.
    Write-Host (Get-VstsInput -Name msg)
} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}
