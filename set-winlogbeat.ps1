$ProgressPreference = 'SilentlyContinue'

# Set variables
$winlogbeatUrl = "https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-8.14.2-windows-x86_64.zip"
$winlogbeatConfigUrl = "https://raw.githubusercontent.com/Cyb3rWard0g/HELK/refs/heads/master/configs/winlogbeat/winlogbeat.yml"
$winlogbeatZip = "winlogbeat.zip"
$winlogbeatDir = "winlogbeat-8.14.2-windows-x86_64"

# Prompt the user to input HELK IP
$helkIp = Read-Host "Please enter the IP address of the HELK server"

# Validate IP format
if ($helkIp -notmatch "^([0-9]{1,3}\.){3}[0-9]{1,3}$") {
    Write-Host "Invalid IP address format. Please rerun the script and enter a valid IPv4 address." -ForegroundColor Red
    exit
}

# 1. Download and extract Winlogbeat
Write-Host "Downloading Winlogbeat zip file..."
Invoke-WebRequest -Uri $winlogbeatUrl -OutFile $winlogbeatZip

Write-Host "Extracting Winlogbeat zip file..."
Expand-Archive -Path $winlogbeatZip -DestinationPath "." -Force

# 2. Download winlogbeat.yml
Write-Host "Downloading winlogbeat.yml configuration file..."
Invoke-WebRequest -Uri $winlogbeatConfigUrl -OutFile "$winlogbeatDir\winlogbeat.yml"

# 3. Replace <HELK-IP> in winlogbeat.yml
Write-Host "Replacing <HELK-IP> in winlogbeat.yml..."
(Get-Content -Path "$winlogbeatDir\winlogbeat.yml") -replace "<HELK-IP>", $helkIp | Set-Content -Path "$winlogbeatDir\winlogbeat.yml"

# 4. Install Winlogbeat as a service
Write-Host "Installing Winlogbeat as a service..."
Set-Location -Path $winlogbeatDir
.\install-service-winlogbeat.ps1

Write-Host "All steps completed successfully!"
