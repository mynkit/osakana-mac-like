# osakana-mac-like を管理者権限でログオン時に自動起動させるセットアップ
#
# AHKを通常権限で動かすと、管理者権限のウィンドウ（UACから起動した
# ターミナル等）にフォーカスがある間はキーを横取りできず、Cmd+Lが
# 素のWin+Lとして通って画面ロックされてしまう。そのため管理者権限の
# ログオンタスクとして登録する（スタートアップフォルダ方式は廃止）。
#
# 実行方法:
#   powershell -NoProfile -ExecutionPolicy Bypass -File setup-task.ps1
#   （自動で管理者に昇格する。UACが出たら「はい」）

$ErrorActionPreference = "Stop"

$ahkExe = "$env:LOCALAPPDATA\Programs\AutoHotkey\v2\AutoHotkey64.exe"
$script = "$env:USERPROFILE\github\osakana-mac-like\osakana-mac-like.ahk"
$taskName = "osakana-mac-like"

# 管理者でなければ自己昇格
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

# ログオン時・管理者権限・無期限のタスクを登録
$action = New-ScheduledTaskAction -Execute $ahkExe -Argument "`"$script`""
$trigger = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Highest -LogonType Interactive
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -ExecutionTimeLimit (New-TimeSpan -Seconds 0)
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force | Out-Null
Write-Host "タスク '$taskName' を登録しました"

# 旧スタートアップショートカットを削除（二重起動防止）
$lnk = Join-Path ([Environment]::GetFolderPath("Startup")) "osakana-mac-like.lnk"
if (Test-Path $lnk) {
    Remove-Item $lnk -Force
    Write-Host "スタートアップのショートカットを削除しました"
}

# 現在の通常権限インスタンスを止めて、管理者権限で起動し直す
Get-Process AutoHotkey64 -ErrorAction SilentlyContinue | Stop-Process -Force
Start-ScheduledTask -TaskName $taskName
Write-Host "AHKを管理者権限で起動しました。このウィンドウは閉じてOKです"
Start-Sleep -Seconds 5
