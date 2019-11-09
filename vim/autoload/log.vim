" augroup EventLoggin
"   autocmd!
"   autocmd BufNewFile * call s:Log('BufNewFile')
"   autocmd BufReadPre * call s:Log('BufReadPre')
"   autocmd BufRead * call s:Log('BufRead')
"   autocmd BufReadPost * call s:Log('BufReadPost')
"   autocmd BufReadCmd * call s:Log('BufReadCmd')
"   autocmd FileReadPre * call s:Log('FileReadPre')
"   autocmd FileReadPost * call s:Log('FileReadPost')
"   autocmd FileReadCmd * call s:Log('FileReadCmd')
"   autocmd FilterReadPre * call s:Log('FilterReadPre')
"   autocmd FilterReadPost * call s:Log('FilterReadPost')
"   autocmd StdinReadPre * call s:Log('StdinReadPre')
"   autocmd StdinReadPost * call s:Log('StdinReadPost')
"   autocmd BufWrite * call s:Log('BufWrite')
"   autocmd BufWritePre * call s:Log('BufWritePre')
"   autocmd BufWritePost * call s:Log('BufWritePost')
"   autocmd BufWriteCmd * call s:Log('BufWriteCmd')
"   autocmd FileWritePre * call s:Log('FileWritePre')
"   autocmd FileWritePost * call s:Log('FileWritePost')
"   autocmd FileWriteCmd * call s:Log('FileWriteCmd')
"   autocmd FileAppendPre * call s:Log('FileAppendPre')
"   autocmd FileAppendPost * call s:Log('FileAppendPost')
"   autocmd FileAppendCmd * call s:Log('FileAppendCmd')
"   autocmd FilterWritePre * call s:Log('FilterWritePre')
"   autocmd FilterWritePost * call s:Log('FilterWritePost')
"   autocmd BufAdd * call s:Log('BufAdd')
"   autocmd BufCreate * call s:Log('BufCreate')
"   autocmd BufDelete * call s:Log('BufDelete')
"   autocmd BufWipeout * call s:Log('BufWipeout')
"   autocmd BufFilePre * call s:Log('BufFilePre')
"   autocmd BufFilePost * call s:Log('BufFilePost')
"   autocmd BufEnter * call s:Log('BufEnter')
"   autocmd BufLeave * call s:Log('BufLeave')
"   autocmd BufWinEnter * call s:Log('BufWinEnter')
"   autocmd BufWinLeave * call s:Log('BufWinLeave')
"   autocmd BufUnload * call s:Log('BufUnload')
"   autocmd BufHidden * call s:Log('BufHidden')
"   autocmd BufNew * call s:Log('BufNew')
"   autocmd SwapExists * call s:Log('SwapExists')
"   autocmd FileType * call s:Log('FileType')
"   autocmd Syntax * call s:Log('Syntax')
"   autocmd EncodingChanged * call s:Log('EncodingChanged')
"   autocmd TermChanged * call s:Log('TermChanged')
"   autocmd VimEnter * call s:Log('VimEnter')
"   autocmd GUIEnter * call s:Log('GUIEnter')
"   autocmd GUIFailed * call s:Log('GUIFailed')
"   autocmd TermResponse * call s:Log('TermResponse')
"   autocmd QuitPre * call s:Log('QuitPre')
"   autocmd VimLeavePre * call s:Log('VimLeavePre')
"   autocmd VimLeave * call s:Log('VimLeave')
"   autocmd FileChangedShell * call s:Log('FileChangedShell')
"   autocmd FileChangedShellPost * call s:Log('FileChangedShellPost')
"   autocmd FileChangedRO * call s:Log('FileChangedRO')
"   autocmd ShellCmdPost * call s:Log('ShellCmdPost')
"   autocmd ShellFilterPost * call s:Log('ShellFilterPost')
"   autocmd FuncUndefined * call s:Log('FuncUndefined')
"   autocmd SpellFileMissing * call s:Log('SpellFileMissing')
"   autocmd SourcePre * call s:Log('SourcePre')
"   autocmd SourceCmd * call s:Log('SourceCmd')
"   autocmd VimResized * call s:Log('VimResized')
"   autocmd FocusGained * call s:Log('FocusGained')
"   autocmd FocusLost * call s:Log('FocusLost')
"   autocmd CursorHold * call s:Log('CursorHold')
"   autocmd CursorHoldI * call s:Log('CursorHoldI')
"   autocmd CursorMoved * call s:Log('CursorMoved')
"   autocmd CursorMovedI * call s:Log('CursorMovedI')
"   autocmd WinEnter * call s:Log('WinEnter')
"   autocmd WinLeave * call s:Log('WinLeave')
"   autocmd TabEnter * call s:Log('TabEnter')
"   autocmd TabLeave * call s:Log('TabLeave')
"   autocmd CmdwinEnter * call s:Log('CmdwinEnter')
"   autocmd CmdwinLeave * call s:Log('CmdwinLeave')
"   autocmd InsertEnter * call s:Log('InsertEnter')
"   autocmd InsertChange * call s:Log('InsertChange')
"   autocmd InsertLeave * call s:Log('InsertLeave')
"   autocmd InsertCharPre * call s:Log('InsertCharPre')
"   autocmd TextChanged * call s:Log('TextChanged')
"   autocmd TextChangedI * call s:Log('TextChangedI')
"   autocmd ColorScheme * call s:Log('ColorScheme')
"   autocmd RemoteReply * call s:Log('RemoteReply')
"   autocmd QuickFixCmdPre * call s:Log('QuickFixCmdPre')
"   autocmd QuickFixCmdPost * call s:Log('QuickFixCmdPost')
"   autocmd SessionLoadPost * call s:Log('SessionLoadPost')
"   autocmd MenuPopup * call s:Log('MenuPopup')
"   autocmd CompleteDone * call s:Log('CompleteDone')
"   autocmd User * call s:Log('User')
" augroup END
" function! s:Log(eventName) abort
"   silent execute '!echo '.a:eventName.' >> log'
" endfunction
