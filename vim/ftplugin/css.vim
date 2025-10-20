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
nnoremap <leader>ot othis is a test for scss<esc>

" Open a test file whether or not it exists
nnoremap ]j :e <c-r>%<c-f>bCspec.jsx<c-c><cr>:e<cr>
" Open a component file whether or not it exists
nnoremap [j :e <c-r>%<c-f>bCjsx<c-c><cr>:e<cr>
