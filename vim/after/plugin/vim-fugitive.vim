" Fugitive setting for making Gdiff always use vertical split
set diffopt+=vertical

" Fugitive mappings
nnoremap \s :G<cr>
nnoremap \b :Git blame<cr>
nnoremap \l :Git log<cr>
nnoremap \e :Git edit<cr>
nnoremap \d :Git diff<cr>
nnoremap \r :Git read<cr>
nnoremap \x :Git remove!<cr>
nnoremap \w :Git write!<cr>
nnoremap \p :diffput<cr>
nnoremap \g :diffget<cr>

" Used to close Gstatus after selecting a file
nnoremap \leader><CR> $"ayiW:q<CR>:e <c-R>a<CR>
