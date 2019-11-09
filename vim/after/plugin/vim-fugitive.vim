" Fugitive setting for making Gdiff always use vertical split
set diffopt+=vertical

" Fugitive mappings
nnoremap \s :Gstatus<cr>
nnoremap \b :Gblame<cr>
nnoremap \l :Glog<cr>
nnoremap \e :Gedit<cr>
nnoremap \d :Gdiff<cr>
nnoremap \r :Gread<cr>
nnoremap \x :Gremove!<cr>
nnoremap \w :Gwrite!<cr>
nnoremap \p :diffput<cr>
nnoremap \g :diffget<cr>

" Used to close Gstatus after selecting a file
nnoremap \leader><CR> $"ayiW:q<CR>:e <c-R>a<CR>
