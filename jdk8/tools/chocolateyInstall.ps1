$script_path = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$common = $(Join-Path $script_path "common.ps1")
. $common
 
#installs jdk8
try {
    $params = "$env:chocolateyPackageParameters" # -params '"x64=false;path=c:\\java\\jdk"'
    $params = (ConvertFrom-StringData $params.Replace(";", "`n")) 
     
    if (check-both($params)) {
        chocolatey-install $true
        chocolatey-install
        out-both($params)
    } else {
        out-i586($params)
        chocolatey-install
    }   
    set-path
} catch {
    if ($_.Exception.InnerException) {
        $msg = $_.Exception.InnerException.Message
    } else {
        $msg = $_.Exception.Message
    }
    throw 
}  