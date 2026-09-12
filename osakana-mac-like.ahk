#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================
; おさかなキーボード用 Mac風ショートカット for Windows
;
; キーボードが Cmd として送るキーは Windows では Win キーとして
; 認識されるため、Win+キー を Windows 相当の操作に変換して
; Mac と同じ指の動きで操作できるようにする。
; （# = Winキー, ^ = Ctrl, ! = Alt, + = Shift）
; ============================================================

; --- 編集・クリップボード ---
#c::Send "^c"
#v::Send "^v"
#+v::Send "^+v"        ; 書式なし貼り付け（対応アプリのみ）
#x::Send "^x"
#z::Send "^z"
#+z::Send "^y"         ; やり直し（Redo）
#a::Send "^a"
#s::Send "^s"
#+s::Send "^+s"
#f::Send "^f"
#g::Send "^g"

; --- アプリ・ウィンドウ操作 ---
#q::Send "!{F4}"       ; Cmd+Q → アプリ終了
#w::Send "^w"          ; Cmd+W → タブ/ウィンドウを閉じる
#m::WinMinimize "A"    ; Cmd+M → ウィンドウ最小化
#h::WinMinimize "A"    ; Cmd+H → 隠す（Windowsでは最小化で代用）
#n::Send "^n"
#+n::Send "^+n"
#o::Send "^o"
#p::Send "^p"
#,::Send "^,"          ; Cmd+, → 設定（対応アプリのみ）

; --- ブラウザ系 ---
#t::Send "^t"          ; 新しいタブ
#+t::Send "^+t"        ; 閉じたタブを開き直す
#l::Send "^l"          ; アドレスバー
#r::Send "^r"          ; 再読み込み
#d::Send "^d"          ; ブックマーク
#[::Send "!{Left}"     ; Cmd+[ → 戻る
#]::Send "!{Right}"    ; Cmd+] → 進む
#1::Send "^1"
#2::Send "^2"
#3::Send "^3"
#4::Send "^4"
#5::Send "^5"
#6::Send "^6"
#7::Send "^7"
#8::Send "^8"
#9::Send "^9"

; --- ズーム（ブラウザ等） ---
#=::Send "^{+}"        ; Cmd+= → 拡大
#-::Send "^{-}"        ; Cmd+- → 縮小
#0::Send "^0"          ; Cmd+0 → 等倍

; --- Cmd+Shift系の汎用変換 ---
#+w::Send "^+w"        ; ウィンドウを閉じる
#+r::Send "^+r"        ; ハードリロード
#+g::Send "^+g"        ; 前を検索
#+d::Send "^+d"        ; （Chrome: 全タブをブックマーク）

; --- 書式（テキスト編集アプリ） ---
#b::Send "^b"
#i::Send "^i"
#u::Send "^u"
#k::Send "^k"

; ============================================================
; Google Chrome 専用（MacのChromeとWindowsのChromeで
; ショートカットが異なるものを Mac 側に合わせる）
; ============================================================
#HotIf WinActive("ahk_exe chrome.exe")

; タブ切り替え
#+[::Send "^{PgUp}"        ; Cmd+Shift+[ → 前のタブ
#+]::Send "^{PgDn}"        ; Cmd+Shift+] → 次のタブ
#!Left::Send "^{PgUp}"     ; Cmd+Option+← → 前のタブ
#!Right::Send "^{PgDn}"    ; Cmd+Option+→ → 次のタブ

; 履歴・ダウンロード
#y::Send "^h"              ; Cmd+Y → 履歴
#+j::Send "^j"             ; Cmd+Shift+J → ダウンロード

; ブックマーク
#!b::Send "^+o"            ; Cmd+Option+B → ブックマークマネージャー
#+b::Send "^+b"            ; Cmd+Shift+B → ブックマークバー表示切替

; デベロッパーツール
#!i::Send "^+i"            ; Cmd+Option+I → DevTools
#!j::Send "^+j"            ; Cmd+Option+J → JSコンソール
#!c::Send "^+c"            ; Cmd+Option+C → 要素を検証
#!u::Send "^u"             ; Cmd+Option+U → ページのソース表示

; その他
#+h::Send "!{Home}"        ; Cmd+Shift+H → ホームページを開く
#,:: {                     ; Cmd+, → Chromeの設定を開く
    Send "^t"
    Sleep 150
    SendText "chrome://settings"
    Send "{Enter}"
}

#HotIf

; --- Cmd+Tab → Alt+Tab（Cmdを押している間アプリ切替を維持） ---
#Tab:: {
    if !GetKeyState("Alt")
        Send "{Alt down}"
    Send "{Tab}"
    SetTimer ReleaseAltWhenCmdUp, 50
}
#+Tab:: {
    if !GetKeyState("Alt")
        Send "{Alt down}"
    Send "+{Tab}"
    SetTimer ReleaseAltWhenCmdUp, 50
}
ReleaseAltWhenCmdUp() {
    if GetKeyState("LWin", "P") || GetKeyState("RWin", "P")
        return
    Send "{Alt up}"
    SetTimer , 0
}

; --- Mac風カーソル移動 ---
#Left::Send "{Home}"        ; Cmd+← → 行頭
#Right::Send "{End}"        ; Cmd+→ → 行末
#Up::Send "^{Home}"         ; Cmd+↑ → 文頭
#Down::Send "^{End}"        ; Cmd+↓ → 文末
#+Left::Send "+{Home}"      ; 選択しながら行頭へ
#+Right::Send "+{End}"
#+Up::Send "^+{Home}"
#+Down::Send "^+{End}"

; --- Option(Alt)+矢印 → 単語単位移動 ---
; ※ Alt+← の「戻る」（エクスプローラー等）は使えなくなる。
;    ブラウザの戻る/進むは Cmd+[ / Cmd+] を使うこと。
;    不要ならこのセクションを削除してよい。
!Left::Send "^{Left}"
!Right::Send "^{Right}"
!+Left::Send "^+{Left}"
!+Right::Send "^+{Right}"
!BackSpace::Send "^{BackSpace}"   ; Option+Delete → 単語削除

; --- Cmd+Delete ---
#HotIf WinActive("ahk_class CabinetWClass")   ; エクスプローラーでは
#BackSpace::Send "{Delete}"                   ; ファイルをごみ箱へ
#HotIf
#BackSpace::Send "+{Home}{BackSpace}"         ; テキストでは行頭まで削除
