" vim-grepper settings
" Search the word under the cursor in the current directory
nnoremap <leader>sd yiw:Grepper -tool ag -query "<c-r>""<cr>:echo "Searching..."<cr>
vnoremap <leader>sd y:Grepper -tool ag -query "<c-r>""<cr>:echo "Searching..."<cr>
" Search open buffers
nnoremap <leader>sob :Grepper -buffers -tool ag -query<space>
" nnoremap <leader>sob yiw:Grepper -buffers -tool ag -query "<c-r>""<cr>:echo "Searching..."<cr>
" Search open buffers for visualized word
vnoremap <leader>sob y:Grepper -buffers -tool ag -query "<c-r>""<cr>:echo "Searching..."<cr>
" vim-grepper operator. Good for aging a text object and seemingly not much else
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)
" Set some pretty customized tools. See the docs for defaults
" UPDATE: Only the first tool ever works despite a lot of effort.
" Vimgrepper seems shitty.
let g:grepper               = {'tools': ['ag', 'git']}
let g:grepper.jump          = 0 " Don't jump to the first result
let g:grepper.next_tool     = ']g'
let g:grepper.simple_prompt = 1
" let g:grepper.quickfix      = 0 " Uses location list
