" Use :UltiSnipsEdit to edit snippets for the current filetype on the fly
nnoremap <leader>ne :UltiSnipsEdit<cr>
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<c-n>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsDir="~/.vim/UltiSnips"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
