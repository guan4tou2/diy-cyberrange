# 設定變數
$winlogbeatUrl = "https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-8.14.2-windows-x86_64.zip"
$winlogbeatConfigUrl = "https://raw.githubusercontent.com/Cyb3rWard0g/HELK/refs/heads/master/configs/winlogbeat/winlogbeat.yml"
$winlogbeatZip = "winlogbeat.zip"
$winlogbeatDir = "winlogbeat-8.14.2-windows-x86_64"

# 要求使用者輸入 IP
$helkIp = Read-Host "請輸入 HELK 的 IP 位址"

# 驗證 IP 格式
if ($helkIp -notmatch "^([0-9]{1,3}\.){3}[0-9]{1,3}$") {
    Write-Host "IP 位址格式不正確，請重新執行腳本並輸入正確的 IP 位址。" -ForegroundColor Red
    exit
}

# 1. 下載並解壓縮 winlogbeat
Write-Host "下載 winlogbeat 壓縮檔..."
Invoke-WebRequest -Uri $winlogbeatUrl -OutFile $winlogbeatZip

Write-Host "解壓縮 winlogbeat 壓縮檔..."
Expand-Archive -Path $winlogbeatZip -DestinationPath "." -Force

# 2. 下載 winlogbeat.yml
Write-Host "下載 winlogbeat.yml 配置檔案..."
Invoke-WebRequest -Uri $winlogbeatConfigUrl -OutFile "$winlogbeatDir\winlogbeat.yml"

# 3. 替換 winlogbeat.yml 中的 <HELK-IP>
Write-Host "替換 winlogbeat.yml 中的 <HELK-IP>..."
(Get-Content -Path "$winlogbeatDir\winlogbeat.yml") -replace "<HELK-IP>", $helkIp | Set-Content -Path "$winlogbeatDir\winlogbeat.yml"

# 4. 安裝 winlogbeat 作為服務
Write-Host "執行 winlogbeat 安裝腳本..."
Set-Location -Path $winlogbeatDir
.\install-service-winlogbeat.ps1

Write-Host "完成所有步驟！"
