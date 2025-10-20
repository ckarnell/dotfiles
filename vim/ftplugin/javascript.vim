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
nnoremap <leader>tdf A // TODO: Fix<Esc>^
nnoremap <leader>gct I// <Esc>A // TODO: Delete<Esc>^

" Open scss file whether or not it exists
" These don't work, autoload isn't loading
" This one doesn't work
" nnoremap ]j :call ft#ftscripts#FrontendGoForwardFile(bufname('%')[1])<cr>
nnoremap ]j :call ft#ftscripts#JsxGoForwardFile()<cr>
" Open test file whether or not it exists
" This one doesn't work
nnoremap [j :call ft#ftscripts#JsxGoBackwardFile()<cr>

" Change a jsx function to a class.
" Depends on the class not being the last white space in the file.
nnoremap <leader>change / function <cr>lcwclass<Esc>elcW extends Component<Esc>/ return<cr>lOrender() {<Esc>jv}kk>}kko<BS>}<Esc>


" Make these useful and close to the intended functionality
nnoremap ]] /^.\& \@!.*{/e<cr>:nohlsearch<cr>
nnoremap [[ ?^.\& \@!.*{?e<cr>:nohlsearch<cr>

" nnoremap [[ :call GoToLastClassOrEnd()<cr>
" nnoremap ]] :call GoToNextClassOrEnd()<cr>
" nnoremap [[
" map [[ ?{<CR>w99[{

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" function! GoToNextClassOrEnd()
"   let l:pattern = '\<class\>'
"   let l:currentLine = line('.')
"   let l:nextLine = search(l:pattern, 'n')
"   if l:nextLine > l:currentLine
"     call search(l:pattern)
"   else
"     execute 'normal G'
"   endif
" endfunction

" function! GoToLastClassOrEnd()
"   let l:pattern = '\<class\>'
"   let l:currentLine = line('.')
"   let l:prevLine = search(l:pattern, 'bn')
"   if l:prevLine < l:currentLine
"     call search(l:pattern, 'b')
"   else
"     execute 'normal gg'
"   endif
" endfunction

function! GoForwardFile()
  let bufNameList = split(bufname('%'), '\.')
  if len(bufNameList) == 3
    exe "e " .  bufNameList[0] . ".jsx"
  elseif len(bufNameList) == 2
    if bufNameList[1] == "jsx"
      exe "e " .  bufNameList[0] . ".scss"
    elseif bufNameList[1] == "scss"
      exe "e " .  bufNameList[0] . ".spec.jsx"
    endif
  else
    echo "This filename seems weird..."
  endif
endfunction

function! GoBackwardFile()
  let bufNameList = split(bufname('%'), '\.')
  if len(bufNameList) == 3
    exe "e " .  bufNameList[0] . ".scss"
  elseif len(bufNameList) == 2
    if bufNameList[1] == "jsx"
      exe "e " .  bufNameList[0] . ".spec.jsx"
    elseif bufNameList[1] == "scss"
      exe "e " .  bufNameList[0] . ".scss"
    endif
  else
    echo "This filename seems weird..."
  endif
endfunction
