"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sections:
"    -> Text, tab and indent related
"    -> Editing mappings
"    -> Helper functions
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
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" If you have the name of the variable in your yank buffer, this one pastes it for you.
" Only works if there is no white space in the variable name, obviously.
" Think 'leader debug paste'
nnoremap <leader>dp oconsole.log("<Esc>pgUiwA: " + JSON.stringify(<Esc>pa, null, 2)); // TODO: Delete this debug statement<Esc>0f"l

" If your cursor is over and variable you'd like to debug, this one yanks and pastes it for you.
" Think 'leader debug yank'
nnoremap <leader>dyo yiwoconsole.log("<Esc>pgUiwA: " + JSON.stringify(<Esc>pa, null, 2)); // TODO: Delete this debug statement<Esc>0f"l
vnoremap <leader>dyo diJSON.stringify(<Esc>pa, null, 2)<Esc>0f"l
" Do the same for object keys
nnoremap <leader>dyk yiwoconsole.log("<Esc>pgUiwA: " + Object.keys(<Esc>pa)); // TODO: Delete this debug statement<Esc>0f"l

" Mappings to quickly make TODO comments
nnoremap <leader>tdd A // TODO: Delete<Esc>^
nnoremap <leader>gct I// <Esc>A // TODO: Delete<Esc>^

" Change a jsx function to a class.
" Depends on the class not being the last white space in the file.
nnoremap <leader>change / function <cr>lcwclass<Esc>elcW extends Component<Esc>/ return<cr>lOrender() {<Esc>jv}kk>}kko<BS>}<Esc>
