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

### Google Chrome 専用

| Mac | Windows での動作 |
| --- | --- |
| Cmd+Shift+[ / ] , Cmd+Option+←/→ | タブ切り替え |
| Cmd+Y | 履歴 |
| Cmd+Shift+J | ダウンロード |
| Cmd+Option+I / J / C / U | DevTools / コンソール / 検証 / ソース表示 |
| Cmd+Option+B / Cmd+Shift+B | ブックマークマネージャー / バー表示切替 |
| Cmd+, | 設定を開く |
