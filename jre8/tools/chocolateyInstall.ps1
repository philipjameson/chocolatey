$script_path = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$common = $(Join-Path $script_path "common.ps1")
. $common

#installs jre8
try {
    $params = "$env:chocolateyPackageParameters" # -params '"x64=false;path=c:\\java\\jre"'
    $params = (ConvertFrom-StringData $params.Replace(";", "`n")) 
    
    chocolatey-install  
} catch {
    if ($_.Exception.InnerException) {
        $msg = $_.Exception.InnerException.Message
    } else {
        $msg = $_.Exception.Message
    }
    
    Write-ChocolateyFailure 'jre8' "$msg"
    throw 
}  
