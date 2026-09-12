# Mac/Linux風の行編集ショートカット (PSReadLine)
Set-PSReadLineKeyHandler -Chord Ctrl+u -Function BackwardDeleteLine   # カーソル位置から行頭まで削除
Set-PSReadLineKeyHandler -Chord Ctrl+k -Function ForwardDeleteLine    # カーソル位置から行末まで削除
