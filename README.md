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
| Cmd+Ctrl+Q | 画面ロック |
| Ctrl+Cmd+Shift+3 | 全画面スクリーンショットをクリップボードへ |
| Ctrl+Cmd+Shift+4 | 範囲選択スクリーンショットをクリップボードへ |

## 実装方式（Win+L 問題）

Win+L のロック検知はキーボードフックより低い raw input レイヤーで行われるため、AHK（や PowerToys）でどうリマップ・抑止してもロックだけは素通りする。レジストリの `DisableLockWorkstation`（HKCU/HKLM とも）もこの環境（Windows 11 Home 26200）では無視された。

そのため2段構えにしている：

1. **Scancode Map（カーネルレベル置換・要再起動）**: `setup-task.ps1` が LWin→F13、RWin→F14 のドライバーレベル変換を登録する。OS にとって Win キーは存在しなくなり、Win+L は原理的に発生しない。
2. **AHK**: F13/F14（と置換前の LWin/RWin）を「Cmd が物理的に押されているか」（`CmdDown()`）として `#HotIf` 条件で扱い、各ショートカットを個別に定義。キー自体は `*F13::return` 等で抑止。

`setup-task.ps1` は同時に、AHK を管理者権限のログオンタスクとして登録する（通常権限だと管理者ウィンドウにフォーカスがある間はリマップが効かないため）。

副作用として **Winキー本来のOSショートカットはすべて無効**になる（スタートメニュー、Win+Space、Win+Shift+S 等）。必要なものはスクリプトの Cmd セクションに個別に追加すること。画面ロック機能自体は正常なままで、Cmd+Ctrl+Q が `LockWorkStation` API を直接呼ぶ。

### 復旧機構

ロック画面や UAC のセキュアデスクトップは AHK から見えず、そこでキーを離すと「Cmd 押しっぱなし」誤認で全キーがショートカット化することがある。対策として、①ロック復帰時に自動リセット、②Cmd が15秒以上押しっぱなしなら自動リセット、③**Esc を1.2秒以内に3回**で手動リセット、を備える。発動は `stuck-recovery.log` に記録される。

### Google Chrome 専用

| Mac | Windows での動作 |
| --- | --- |
| Cmd+Shift+[ / ] , Cmd+Option+←/→ | タブ切り替え |
| Cmd+Y | 履歴 |
| Cmd+Shift+J | ダウンロード |
| Cmd+Option+I / J / C / U | DevTools / コンソール / 検証 / ソース表示 |
| Cmd+Option+B / Cmd+Shift+B | ブックマークマネージャー / バー表示切替 |
| Cmd+, | 設定を開く |
