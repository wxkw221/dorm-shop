# 部署脚本：把最新 index.html 推到 GitHub Pages
# 用法：pwsh -File deploy.ps1 [-Message "说明"]
param([string]$Message = "")
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$tokenFile = 'D:\dpck\.secrets\github.token'
$src = 'D:\dpck\dorm-shop-v1124e\index.html'

if(-not (Test-Path $tokenFile)){ throw "缺少 token 文件：$tokenFile" }
$tok = (Get-Content -LiteralPath $tokenFile -Raw).Trim()
if(-not $tok){ throw "token 文件是空的：$tokenFile" }

Copy-Item -LiteralPath $src -Destination (Join-Path $root 'index.html') -Force
Set-Location $root
git add -A
if(-not $Message){ $Message = "deploy " + (Get-Date -Format 'yyyy-MM-dd HH:mm') }
git -c user.name='deploy' -c user.email='deploy@localhost' commit -m $Message 2>$null
if($LASTEXITCODE -ne 0){ "没有改动，跳过提交" }

$b64 = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("x-access-token:$tok"))
git -c http.extraheader="AUTHORIZATION: basic $b64" push origin HEAD:main
if($LASTEXITCODE -ne 0){ throw "推送失败" }
"部署完成：https://wxkw221.github.io/dorm-shop/"