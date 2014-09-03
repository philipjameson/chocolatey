$script_path = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$common = $(Join-Path $script_path "common.ps1")
. $common


function Uninstall-JRE {
    $use64bit = use64bit
    if ($use64bit) {
        $jre = "/qn /x {26A24AE4-039D-4CA4-87B4-2F864" + $uninstall_id + "F0}"   
    } else {
        $jre = "/qn /x {26A24AE4-039D-4CA4-87B4-2F832" + $uninstall_id + "F0}"   
    }
     Start-ChocolateyProcessAsAdmin $jre 'msiexec'
}
try {  
  Uninstall-JRE


  Write-ChocolateySuccess 'jre8'
} catch {
  Write-ChocolateyFailure 'jre8' "$($_.Exception.Message)"
  #throw 
}