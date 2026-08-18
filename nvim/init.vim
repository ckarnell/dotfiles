" Neovim entry point.
"
" There is deliberately no Neovim-specific configuration here beyond what
" Neovim structurally requires. The real config is the shared ~/dotfiles/vimrc,
" which both Vim and Neovim source, so there is exactly one file to edit.
"
" What Neovim requires that Vim does not:
"   - ~/.vim is NOT on Neovim's runtimepath, so the shared runtime dir has to
"     be added by hand (that is where ftplugin/, after/, UltiSnips/, colors/,
"     indent/ and autoload/plug.vim live).
"   - The python3 provider needs an interpreter with pynvim installed. Homebrew
"     python is externally-managed, so a dedicated venv holds it. Without this,
"     has('python3') is 0 and UltiSnips, jedi-vim and gundo all silently die.
"
" Plugins install to ~/.local/share/nvim/plugged, NOT ~/.vim/plugged. Vim and
" Neovim therefore keep independent plugin trees: nothing done here can break
" the working MacVim setup, which stays available as a fallback.

let $VIMCFG = empty($VIMCFG) ? expand('~/dotfiles') : $VIMCFG

" Shared runtime dir, ahead of the Neovim defaults, mirroring what VIMINIT does
" for Vim in ~/.zshrc.
execute 'set runtimepath^=' . fnameescape($VIMCFG . '/vim')
execute 'set runtimepath+=' . fnameescape($VIMCFG . '/vim/after')
execute 'set packpath^='    . fnameescape($VIMCFG . '/vim')

" python3 provider. Skip the ~120ms interpreter probe Neovim does at startup by
" naming the interpreter outright.
let s:pyvenv = expand('~/.local/share/nvim/venv/bin/python3')
if executable(s:pyvenv)
  let g:python3_host_prog = s:pyvenv
endif

" Providers this config does not use. Disabling them removes them from
" :checkhealth noise and skips their startup probes.
let g:loaded_python_provider = 0
let g:loaded_ruby_provider   = 0
let g:loaded_perl_provider   = 0
let g:loaded_node_provider   = 0

" ---------------------------------------------------------------------------
" Clear Neovim default mappings that Vim does not have.
"
" Neovim ships default mappings (:help default-mappings) that Vim lacks, and
" they land BEFORE plugins load. Two plugins then lose keys they own under Vim,
" each failing silently in its own way:
"
"   vim-searchindex uses `map <unique> * ...`. <unique> checks every mode the
"   command covers (n, v, o), so Neovim's visual-mode `x *` / `x #` defaults
"   (:help v_star-default) make the whole command fail with E227 -- and because
"   the command is prefixed `silent!`, no message is printed. Normal-mode * and
"   # end up with no search-count indicator at all.
"
"   vim-unimpaired guards with mapcheck() and quietly skips any key already
"   taken, so Neovim's ]q/[q/]b/[b/]a/[a/]t/[t/]l/[l and ]<Space>/[<Space>
"   defaults win over unimpaired's, which support counts and wrap-around.
"
" Dropping the defaults here lets both plugins claim their keys exactly as they
" do under Vim. This must stay ahead of the `source vimrc` line below: plugin/
" files are sourced after user config, so this is the last chance to act.
for s:lhs in ['[q', ']q', '[b', ']b', '[a', ']a', '[t', ']t', '[l', ']l',
      \ '[<Space>', ']<Space>']
  execute 'silent! nunmap ' . s:lhs
endfor
silent! xunmap *
silent! xunmap #

" Neovim redefines Y as y$; Vim yanks the whole line. Restore Vim's meaning.
" Delete this line to adopt Neovim's (more consistent with C and D).
silent! nunmap Y

execute 'source ' . fnameescape($VIMCFG . '/vimrc')
