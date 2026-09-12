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
| Cmd+Shift+3 | 全画面スクリーンショット（ピクチャ\スクリーンショット に保存） |
| Cmd+Shift+4 | 範囲選択スクリーンショット（クリップボードへ） |

## 実装方式（Win+L 問題）

Win+L は OS 予約のロックショートカットで、`#l::` のような通常の AHK リマップでは横取りできない（ロックが先に発動する）。レジストリの `DisableLockWorkstation`（HKCU/HKLM とも）はこの環境（Windows 11 Home 26200）では無視された。

そのためこのスクリプトは **Winキー自体を OS から隠す方式**を取っている：

- `*LWin::return` / `*RWin::return` で Win キーを抑止（OS には届かない）
- 各ショートカットは「Cmd が物理的に押されているか」（`GetKeyState("LWin","P")`）を `#HotIf` 条件にして個別に定義

この方式の副作用として、**Winキー本来のOSショートカットはすべて無効**になる（スタートメニュー、Win+Space、Win+Shift+S スクリーンショット等）。必要なものはスクリプトの Cmd セクションに個別に追加すること。画面ロック機能自体は正常なままなので、Cmd+Ctrl+Q が `LockWorkStation` API を直接呼ぶ。

### Google Chrome 専用

| Mac | Windows での動作 |
| --- | --- |
| Cmd+Shift+[ / ] , Cmd+Option+←/→ | タブ切り替え |
| Cmd+Y | 履歴 |
| Cmd+Shift+J | ダウンロード |
| Cmd+Option+I / J / C / U | DevTools / コンソール / 検証 / ソース表示 |
| Cmd+Option+B / Cmd+Shift+B | ブックマークマネージャー / バー表示切替 |
| Cmd+, | 設定を開く |
