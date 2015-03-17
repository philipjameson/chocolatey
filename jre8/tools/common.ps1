$jre_version = '8u40' 
$uninstall_id = "18040" 
$script_path = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

function use64bit($Forcei586 = $false) {
    if ($Forcei586) {
        return $false
    }
    if (Test-Path (Join-Path $script_path "i586.txt")) {
        return $false
    }
    $is64bitOS = Get-ProcessorBits 64
    return $is64bitOS
}

function has_file($filename) {
    return Test-Path $filename
}

function download-from-oracle($url, $output_filename) {
    if (-not (has_file($output_fileName))) {
        Write-Host  "Downloading jre from $url"

        Get-ChocolateyWebFile 'jre8' $output_fileName $url $url
    }  
}

function download-jre-file($url, $output_filename) {
    $dummy = download-from-oracle $url $output_filename
}

function download-jre($Forcei586 = $false) {
    $arch = get-arch $Forcei586
    $filename = "jre-$jre_version-windows-$arch.exe"
    if ($arch -eq "x64") {
       $bundleId = "104768"
    } else {
       $bundleId = "104766"
    }
    $url = "http://javadl.sun.com/webapps/download/AutoDL?BundleId=$bundleId"
    $output_filename = Join-Path $script_path $filename

    $dummy = download-jre-file $url $output_filename

    return $output_filename
}


function get-arch($Forcei586 = $false) {
    if((use64bit $Forcei586)) {
        return "x64"
    } else {
        return "i586"
    }
}

function chocolatey-install($Forcei586 = $false) {
    $jre_file = download-jre $Forcei586
    $arch = get-arch $Forcei586

    Write-Host "Installing jre $jre_version($arch) to $java_home"
    Install-ChocolateyInstallPackage 'jre8' 'exe' "/s" $jre_file          

    Update-SessionEnvironment
}

function out-i586($params) {
    $jre_platform = Get-EnvironmentVariable 'JRE_PLATFORM' 'MACHINE'
    if ($params.i586 -eq $true -or $params.x64 -eq $false -or 'i586' -eq $jre_platform) {
        Out-File (Join-Path $script_path "i586.txt")
        Install-ChocolateyEnvironmentVariable 'JRE_PLATFORM' 'i586' 'Machine'
    }
}

function check-both($params) {
    $jre_platform = Get-EnvironmentVariable 'JRE_PLATFORM' 'MACHINE' 
    if ((($params.both -eq $true) -and (use64bit)) -or ('both' -eq $jre_platform)) {
        return $true
    }
}

function out-both($params) {
    if (check-both($params)) {
            Out-File (Join-Path $script_path "both.txt")
            Install-ChocolateyEnvironmentVariable 'JRE_PLATFORM' 'both' 'Machine'
    }
}

function remove-platform-files {
    if (Test-Path (Join-Path $script_path "i586.txt")) {
        Remove-Item (Join-Path $script_path "i586.txt")
    }
    if (Test-Path (Join-Path $script_path "both.txt")) {
        Remove-Item (Join-Path $script_path "both.txt")
    }
}