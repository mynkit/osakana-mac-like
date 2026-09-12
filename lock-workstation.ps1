# Cmd+Ctrl+Q 用の画面ロックスクリプト
# DisableLockWorkstation=1 の環境で、一時的にロックを有効化してロックし、元に戻す。
# タスクスケジューラに管理者権限タスク "MacLikeLock" として登録して使う。
$key = "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System"
reg add $key /v DisableLockWorkstation /t REG_DWORD /d 0 /f | Out-Null
rundll32.exe user32.dll,LockWorkStation
Start-Sleep -Seconds 2
reg add $key /v DisableLockWorkstation /t REG_DWORD /d 1 /f | Out-Null
