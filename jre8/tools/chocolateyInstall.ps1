$script_path = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$common = $(Join-Path $script_path "common.ps1")
. $common

#installs jre8

$params = "$env:chocolateyPackageParameters" # -params '"x64=false;path=c:\\java\\jre"'
$params = (ConvertFrom-StringData $params.Replace(";", "`n")) 

remove-platform-files    
if (check-both($params)) {
    chocolatey-install $true
    chocolatey-install
    out-both($params)
} else {
    out-i586($params)
    chocolatey-install
}  
 
