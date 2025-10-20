function! ft#ftscripts#JsxGoForwardFile()
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

function! ft#ftscripts#JsxGoBackwardFile()
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

function! ft#ftscripts#ScssGoForwardFile()
  " let bufferName = split(bufname('%'), '\.')[0]
  " exe "e " .  bufferName . ".spec.jsx"
  let bufferName = split(bufname('%'), '\.')[0]
  exe "e " .  bufferName . ".jsx"
  let bufNameList = split(bufname('%'), '\.')
  let newBufferName = bufNameList[0] . ".jsx"
  let newBufferName = split(bufname('%'), '\.')[0] . ".jsx"
  if bufNameList[1] != "scss"
    exe "call ft#ftscripts#JsxGoBackwardFile()"
  else
    exe "e " . newBufferName
  endif
endfunction

function! ft#ftscripts#ScssGoBackwardFile()
  let bufferName = split(bufname('%'), '\.')[0]
  exe "e " .  bufferName . ".jsx"
  let bufNameList = split(bufname('%'), '\.')
  let newBufferName = bufNameList[0] . ".jsx"
  let newBufferName = split(bufname('%'), '\.')[0] . ".jsx"
  if bufNameList[1] != "scss"
    exe "call ft#ftscripts#JsxGoBackwardFile()"
  else
    exe "e " . newBufferName
  endif
endfunction
