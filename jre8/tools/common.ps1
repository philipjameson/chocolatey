$jre_version = '8u25' 
$build = '18'
$uninstall_id = "18025" 
$script_path = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

function use64bit() {
    if (Test-Path (Join-Path $script_path "i586.txt")) {
        return $false
    }
    $is64bitOS = (Get-WmiObject -Class Win32_ComputerSystem).SystemType -match ‘(x64)’
    return $is64bitOS
}

function has_file($filename) {
    return Test-Path $filename
}

function download-from-oracle($url, $output_filename) {
    if (-not (has_file($output_fileName))) {
        Write-Host  "Downloading jre from $url"

        [System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
        $client = New-Object Net.WebClient
        $dummy = $client.Headers.Add('Cookie', 'gpw_e24=http://www.oracle.com; oraclelicense=accept-securebackup-cookie')
        $dummy = $client.DownloadFile($url, $output_filename)
    }  
}

function download-jre-file($url, $output_filename) {
    $dummy = download-from-oracle $url $output_filename
}

function download-jre() {
    $arch = get-arch
    $filename = "jre-$jre_version-windows-$arch.exe"
    $url = "http://download.oracle.com/otn-pub/java/jdk/$jre_version-b$build/$filename"
    $output_filename = Join-Path $script_path $filename

    $dummy = download-jre-file $url $output_filename

    return $output_filename
}


function get-arch() {
    if(use64bit) {
        return "x64"
    } else {
        return "i586"
    }
}

function chocolatey-install() {
    $jre_file = download-jre
    $arch = get-arch

    Write-Host "Installing jre $jre_version($arch) to $java_home"
    Install-ChocolateyInstallPackage 'jre8' 'exe' "/s" $jre_file          

    Write-ChocolateySuccess 'jre8'
}

function out-i586($params) {
    if ($params.i586 -eq $true -or $params.x64 -eq "false") {
        Out-File (Join-Path $script_path "i586.txt")
    }
}