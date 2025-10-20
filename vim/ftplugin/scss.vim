"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sections:
"    -> Text, tab and indent related
"    -> Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set tabstop=4
set expandtab
set shiftwidth=2
set softtabstop=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Mappings to quickly make TODO comments
nnoremap <leader>dt A // TODO: Delete<Esc>^
nnoremap <leader>gct I// <Esc>A // TODO: Delete<Esc>^
" Delete the next line

" nnoremap ]j :e <c-r>%<c-f>bCspec.jsx<c-c><cr>:e<cr>
" nnoremap [j :e <c-r>%<c-f>bCjsx<c-c><cr>:e<cr>
nnoremap ]j :call ft#ftscripts#ScssGoForwardFile()<cr>
nnoremap [j :call ft#ftscripts#ScssGoBackwardFile()<cr>
" Does this work?
" nnoremap ]j :call ft#ftscripts#FrontendGoForwardFile(bufname('%')[1])<cr>

" nnoremap ]j :call GoForwardFile()<cr>
" nnoremap [j :call GoBackwardFile()<cr>

" function! GoForwardFile()
"   exe "e " .  bufNameList[0] . ".spec.jsx"
" endfunction

" function! GoBackwardFile()
"   exe "e " .  bufNameList[0] . ".jsx"
" endfunction
