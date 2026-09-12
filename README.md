# osakana-mac-like

おさかなキーボード（大西配列）を Windows でも Mac と同じ操作感で使うための AutoHotkey v2 スクリプト。

キーボードが Cmd として送るキーは Windows では Win キーとして認識されるため、`Win+キー` を Windows 相当のショートカットに変換する。Google Chrome では Mac 版 Chrome と同じショートカット（タブ切り替え・履歴・DevTools など）になるよう Chrome 専用の変換も入れている。

## セットアップ

1. [AutoHotkey v2](https://www.autohotkey.com/) をインストール
2. `osakana-mac-like.ahk` をダブルクリックで起動
3. 自動起動するには、スタートアップフォルダ（`Win+R` → `shell:startup`）にこのスクリプトへのショートカットを置く

## 主な変換

| Mac | Windows での動作 |
| --- | --- |
| Cmd+C/V/X/Z/A/S/F など | Ctrl+同キー |
| Cmd+Q | Alt+F4 |
| Cmd+Tab | Alt+Tab（Cmd 押下中は切替維持） |
| Cmd+←/→/↑/↓ | 行頭/行末/文頭/文末 |
| Option+←/→ | 単語単位移動 |
| Cmd+Delete | 行頭まで削除（エクスプローラーではごみ箱へ） |
| Cmd+Ctrl+Q | 画面ロック（下記「Win+L の解放」参照） |

## Win+L の解放（Cmd+L をアドレスバー移動にする）

Win+L は OS 予約のロックショートカットで AutoHotkey より先に横取りされるため、レジストリでロックを無効化して AHK に渡るようにしている：

```
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableLockWorkstation /t REG_DWORD /d 1 /f
```

（この環境ではキー作成に管理者権限が必要だった）

これで手動ロックが全て無効になるため、代わりに Cmd+Ctrl+Q で「一時的にロックを有効化→ロック→再無効化」する `lock-workstation.ps1` を管理者権限のスケジュールタスク `MacLikeLock` として登録し、AHK から `schtasks /run` で起動している。タスク登録コマンド（要管理者）：

```
schtasks /create /tn MacLikeLock /tr "powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File C:\Users\miyan\github\osakana-mac-like\lock-workstation.ps1" /sc once /sd 2026/01/01 /st 00:00 /rl highest /f
```

### Google Chrome 専用

| Mac | Windows での動作 |
| --- | --- |
| Cmd+Shift+[ / ] , Cmd+Option+←/→ | タブ切り替え |
| Cmd+Y | 履歴 |
| Cmd+Shift+J | ダウンロード |
| Cmd+Option+I / J / C / U | DevTools / コンソール / 検証 / ソース表示 |
| Cmd+Option+B / Cmd+Shift+B | ブックマークマネージャー / バー表示切替 |
| Cmd+, | 設定を開く |
