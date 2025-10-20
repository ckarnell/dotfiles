" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sections:
"    -> VIM user interface
"    -> Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Make the 81st column stand out if it's non-empty
" Turns out this is extremely annoying
" highlight ColorColumn ctermbg=magenta
" call matchadd('ColorColumn', '\%81v', 100)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Debug test
nmap <leader>dt oimport pytest; pytest.set_trace() # TODO: Delete<Esc>

" If you have the name of the variable in your yank buffer, this one pastes it for you.
" Only works if there is no white space in the variable name, obviously.
" Think 'leader debug paste'
nmap <leader>dp oprint("<Esc>pgUiwA: " + str(<Esc>pa)) # TODO: Delete this debug statment<Esc>0f"l

" If your cursor is over and variable you'd like to debug, this one yanks and pastes it for you.
" Think 'leader debug yank'
nmap <leader>dy yiwoprint("<Esc>pgUiwA: " + str(<Esc>pa)); # TODO: Delete this debug statement<Esc>0f"l

" Debug remote
nmap <leader>dr oimport remote_pdb; remote_pdb.set_trace('0.0.0.0', ) # TODO: Delete<Esc>F)i

" Just comment "TODO: Delete" at the end of a line.
" Think 'to do: delete'
nnoremap <leader>tdd A # TODO: Delete<Esc>^
" More TODO notes:
nnoremap <leader>tdf A # TODO: Fix<Esc>^

abbrev pdbt import pytest; pytest.set_trace() # TODO: Delete
abbrev pdbr import remote_pdb; remote_pdb.set_trace('0.0.0.0', 7444) # TODO: Delete

set tabstop=8
set expandtab
set shiftwidth=4
set softtabstop=4
