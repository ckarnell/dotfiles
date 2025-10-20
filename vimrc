"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sections:
"    -> General
"    -> VIM_plugins
"    -> VIM_plugin_settings
"    -> Plugin_option_toggling
"    -> VIM_user_interface
"    -> Colors_and_Fonts
"    -> Files_and_backups
"    -> Text_tab_and_indent_related
"    -> Movement_tabs_windows_and_buffers
"    -> Status_line
"    -> Editing_mappings
"    -> Context_sensitive_mappings
"    -> Functions
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Output codes
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

" Set paste and unpaste modes when pasting
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ''
endfunction

" Sets how many lines of history VIM has to remember
set history=700

" Set to auto read when a file is changed from the outside
set autoread

" Search <leader> in this file to browse available leader commands
" let g:mapleader = "\<space>"
let g:mapleader = " " " Is this better?

" Source vim easily
nnoremap <leader>v :source ~/.vimrc<cr>

" ctags path
set tags=tags;
set path+=/Users/cohen/trial-simulation-data-extraction/**


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM_plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" execute pathogen#infect()
" " syntax on " If you see this and nothing is broken, remove it
" if has('autocmd')
"   augroup pathogen_group
"     " autocmd BufReadPost *
"     "      \ if line("'\"") > 0 && line("'\"") <= line("$") |
"     "      \   exe "normal! g`\"" |
"     "      \ endif
"   augroup END
" endif

" Vundle (vim package manager)
" Use ':PluginInstall' inside vim to install plugins with vundle
" set nocompatible              " be iMproved, required " TODO: Delete
filetype off                  " required

call plug#begin('~/.vim/plugged')
  if has('nvim')
    " Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'neoclide/coc.nvim', {'branch': 'release'} # Completion I guess
  else
    set pyxversion=3
    " Run ':py3 import pip; pip.main(['install', '--user', 'pynvim'])' for setup,
    " or follow instructions here: https://github.com/roxma/vim-hug-neovim-rpc

    " Plug 'OmniSharp/omnisharp-vim'
    Plug 'tpope/vim-rhubarb'
    Plug 'github/copilot.vim'
    Plug 'lambdalisue/vim-unified-diff'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
    " Plug 'Shougo/deoplete.nvim'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " Plug 'deoplete-plugins/deoplete-jedi'
    Plug 'Shougo/vimproc.vim', {'do': 'make'}
    Plug 'Quramy/tsuquyomi'
    " Plug 'kh3phr3n/python-syntax'
    " Plug 'yssl/QFEnter'

    " Plug 'w0rp/ale' " Async linting
    Plug 'ascandella/ale', {'branch': 'mypy-daemon'} " Async linting with dmypy support
    Plug 'Julian/vim-textobj-variable-segment', {'branch': 'main'} " Variable text object
    " Plug 'Shougo/neocomplete.vim' " Autocompletion. Less powerful than YCM but way less overhead
    Plug 'SirVer/ultisnips' " Snippets!
    Plug 'airblade/vim-gitgutter', {'branch': 'main'} " Show git info in the gutter
    Plug 'ckarnell/Antonys-macro-repeater' " Repeat macros
    Plug 'ckarnell/history-traverse' " Go back and forth in your window's buffer history
    Plug 'ctrlpvim/ctrlp.vim' " Fuzzy file finding
    Plug 'google/vim-searchindex' " Shows the total number of search results after every search
    Plug 'junegunn/vader.vim' " Vimscript testing framework
    Plug 'kana/vim-textobj-user' " Required for the variable text object plugin
    Plug 'keith/investigate.vim' " Search docs from inside vim using K or gK
    Plug 'mhinz/vim-grepper' " Provides a grepping motion and different grepping tools
    Plug 'michaeljsmith/vim-indent-object' " Create an indentation text object, 'i'
    Plug 'nelstrom/vim-visual-star-search' " Make * and # behave how they should in visual mode
    Plug 'tpope/tpope-vim-abolish' " Substitution generation
    Plug 'tpope/vim-commentary' " Comment stuff out
    Plug 'tpope/vim-fugitive' " Execute git commands from inside vim
    Plug 'tpope/vim-repeat' " Repeat plugin commands with '.'
    Plug 'tpope/vim-surround' " Add the surround motion, s
    Plug 'tpope/vim-unimpaired' " Decent defaults... look at the docs for the options
    Plug 'tpope/vim-vinegar' " Good settings for the netrw file explorer
    Plug 'unblevable/quick-scope' " Improve 'f' and 't' motions in vim
    Plug 'wellle/targets.vim' " Several text objects
    Plug 'xolox/vim-colorscheme-switcher' " Switch colorschemes easily. [z and ]z are mapped for this
    Plug 'xolox/vim-misc' " Required for vim-colorscheme-switcher... really not a fan of this
    Plug 'sjl/gundo.vim' " Undo tree visualization
    Plug 'christoomey/vim-tmux-navigator' " Tmux window navigation
    Plug 'christoomey/vim-sort-motion' " Sorting motion
    Plug 'alfredodeza/pytest.vim' " Pytest integration
    " Color schemes
    Plug 'morhetz/gruvbox'
    Plug 'mgedmin/python-imports.vim' " Auto imports for Python

    " File type formatting
    " Plug 'chrisbra/csv.vim' " scss syntax highlighting and indentation support
   
    " Syntax highlighting
    Plug 'cakebaker/scss-syntax.vim' " scss syntax highlighting and indentation support
    Plug 'elzr/vim-json' " Json syntax highlighting
    Plug 'vim-python/python-syntax'
    " The following two are recommended to work together
    " Plug 'leafgarland/typescript-vim'
    " Plug 'peitalin/vim-jsx-typescript' " TODO: Reenable?
    Plug 'jparise/vim-graphql'
    Plug 'pangloss/vim-javascript' " Javascript indentation and syntax support TODO: Reenable?
    " Plug 'deoplete-plugins/deoplete-jedi' " Autocomplete for Python using deoplete
    Plug 'davidhalter/jedi-vim' " Use this for smarter goto definition in Python
    Plug 'tpope/vim-projectionist'
    " Plug 'python-rope/ropevim' " Refactoring tools for Python
    Plug 'jaxbot/semantic-highlight.vim'
  endif
call plug#end()

" if has('gui_running')
"     let g:deoplete#enable_at_startup = 1
"     " let g:deoplete#enable_profile = 1
"     call deoplete#custom#option({
"     \ 'on_insert_enter': v:true,
"     \ 'omni_patterns': v:true,
"     \ 'smart_case': v:true,
"     \ })
" end
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

filetype plugin indent on    " redundant but required
let g:gruvbox_invert_selection = 0

" VIM packed-in plugins that aren't defaults:
packadd! matchit " Improves % to match HTML tags and other things
packadd! termdebug " Debugger
packadd! cfilter " Filtering quickfix and location lists

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM_plugin_settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Change sort motion mappings
let g:sort_motion = 'gy'
let g:sort_motion_lines = 'gyy'
let g:sort_motion_visual = 'gy'

" Python syntax
let python_highlight_all = 1

" Gundo
let g:gundo_prefer_python3 = 1
nnoremap <F5> :GundoToggle<CR>

" CoC extensions
" Also had to run ":CocInstall coc-omnisharp"
let g:coc_global_extensions = ['coc-tsserver']
" Gonna try Plug 'OmniSharp/omnisharp-vim' instead
" let g:coc_global_extensions = ['coc-tsserver', 'coc-omnisharp']
" Settings for the new plugin, idk
" let g:OmniSharp_server_use_mono = 1
" let g:OmniSharp_server_use_mono = 0
" let g:OmniSharp_server_stdio = 1

" auto-imports
augroup auto_import
  autocmd FileType python nnoremap <F4>    :ImportName<CR>
  autocmd FileType python nnoremap <C-F4>  :ImportNameHere<CR>
  autocmd FileType typescript nnoremap <F4>    :TsuImport<CR>
  autocmd FileType typescript nnoremap <leader>g    :TsuTypeDefinition<CR>
augroup END

" Typescript settings
let g:tsuquyomi_disable_quickfix = 1 
let g:tsuquyomi_single_quote_import	= 1
let g:tsuquyomi_baseurl_import_path = 1
nnoremap <leader>i :TsuImport<cr>

" Ale
" Check :ALEInfo to see what's going on
" Use this for Python after next PR:
" \     'python': [{buffer -> {
" \     'command': 'isort -sp /Users/cohen/spark/.isort.cfg %t',
" \     'read_temporary_file': 1,
" \    }}, {buffer -> {
" \     'command': 'add-trailing-comma --py35-plus --py36-plus %t',
" \     'read_temporary_file': 1,
" \   }}, 'yapf'],
let g:ale_linters_explicit = 1
let g:ale_fixers = {
\   'javascript': ['eslint', 'prettier'],
\	  'typescript': ['prettier', 'tslint', 'eslint'],
\	  'typescriptreact': ['prettier', 'tslint', 'eslint'],
\   'python': ['black'],
\   'scss': ['scsslint'],
\   'styler': {
\       'function': 'ale#fixers#styler#Fix',
\       'suggested_filetypes': ['r', 'R'],
\       'description': 'Fix R files with styler.',
\   },
\}
let g:ale_linters = {
\   'python': [
\        'ruff', 'mypy',
\    ],
\   'vim': ['vint'],
\   'scss': ['scsslint'],
\   'sql': ['sqlint'],
\   'javascript': ['eslint', 'stylelint'],
\   'typescript': ['tsserver', 'stylelint', 'tslint'],
\   'typescriptreact': ['tsserver', 'stylelint', 'tslint'],
\    'cs': ['omnisharp'],
\}
let g:ale_sign_error = '🐛'
let g:ale_sign_warning = '🐋'
let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_history_log_output = 0
let g:ale_python_mypy_ignore_invalid_syntax = 1
" let g:ale_python_mypy_options = '--follow-imports skip'
let g:ale_python_mypy_use_daemon = 1
let g:ale_python_mypy_autostart_daemon = 1
let g:ale_python_mypy_daemon_options = '--follow-imports=normal'
let g:ale_python_mypy_auto_pipenv = 1 " Not sure what this does, borrowing from Harris
let g:ale_python_pylint_change_directory = 0
let g:ale_typescript_tsserver_config_path = '~/spark/tsconfig.json'
" The following two don't seem to work, but would be nice.
" They're for navigating between errors.
" nmap <silent> <C-k> <Plug>(ale_previous_wrap)
" nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Gitgutter settings
let g:gitgutter_map_keys = 0 " Do this or it worsens your <leader>h settings
nmap <leader>gs <Plug>(GitGutterStageHunk)
nmap <leader>gu <Plug>(GitGutterUndoHunk)
nmap <leader>gp <Plug>(GitGutterPreviewHunk)
nmap ]c <Plug>(GitGutterNextHunk)
nmap [c <Plug>(GitGutterPrevHunk)

" after dir doesn't seem to have worked here
" Use :UltiSnipsEdit to edit snippets for the current filetype on the fly
nnoremap <leader>ne :UltiSnipsEdit<cr>
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
if has('gui_running')
    let g:UltiSnipsUsePythonVersion=3
end
let g:UltiSnipsExpandTrigger='<c-l>'
let g:UltiSnipsJumpForwardTrigger='<c-n>'
let g:UltiSnipsJumpBackwardTrigger='<c-z>'
let g:UltiSnipsDir='~/.vim/UltiSnips'

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit='vertical'

" Run :CocConfig and past this into the file it opens:
"{
"  "suggest.noselect": true
"}

" Tab cycles; Shift-Tab cycles backwards
inoremap <silent><expr> <Tab>    coc#pum#visible() ? coc#pum#next(1)  : (CheckBackspace() ? "\<Tab>" : coc#refresh())
inoremap <silent><expr> <S-Tab>  coc#pum#visible() ? coc#pum#prev(1)  : "\<C-h>"

" Enter accepts the currently selected item
inoremap <silent><expr> <CR>     coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction


" Set the filetypes to skip over adding to the history.
" This defaults to ['.netrw'], but setting this variable completely
" overrides the default value.
let g:history_ft_ignore = ['pyc', 'netrw', 'fugitiveblame']
" Set the maximum length of each buffers history. This defaults to 100.
let g:history_max_len = 1000
let g:history_mr_max_len = 1000
let g:history_mr_auto_open = 1

" History traverse mappings
nnoremap <BS> @=':HisTravBack<C-V><CR>'<CR>
nnoremap <C-N> @=':HisTravForward<C-V><CR>'<CR>
nnoremap <leader>mr :HisTravRecent<CR>

" JSON syntax highlighting settings
let g:vim_json_syntax_conceal = 0

" Use dash with vim investigate
let g:investigate_use_dash=1
let g:investigate_dash_for_javascriptjsx='react'
nnoremap K :call investigate#Investigate('n')<CR>

" Search settings
" If you don't have ag, install it: https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Create the 'Ag' command and a mapping to call it
  " Call it with ':Ag <pattern>'
  set grepprg=ag\ --nogroup\ --nocolor
  command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
  nnoremap <leader>sr :Ag ''<left>
endif
" vim-grepper mapping
nnoremap <leader>gs :Grepper<cr>

" Quick-scope and semantic highlighting color settings
if has('gui_running')
    " let g:semanticEnableFileTypes = ['javascript', 'typescript', 'python']
    " let g:qs_first_occurrence_highlight_color = '#afff5f'
    " let g:qs_second_occurrence_highlight_color = '#5fffff'
    set guicursor=n-v-c:block-Cursor
    set guicursor+=n-v-c:blinkon1
else
    highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
    highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
endif

" netrw settings
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+' " Hide dot files by default. Toggle this with gh
let g:netrw_banner=1 " Toggle the banner

" CtrlP settings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_extensions = ['line', 'dir', 'tag']
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git\|dist'

" Jedi settings
" let g:jedi#completions_enabled = 0 " Use deoplete for this instead
" Jedi commands
let g:jedi#goto_command = "<leader>g"
let g:jedi#goto_assignments_command = ""
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = ""
let g:jedi#usages_command = "<leader>u"
let g:jedi#completions_command = ""
let g:jedi#rename_command = "<leader>r"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin_option_toggling
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" " Semantic highlighting
" nnoremap [ops :SemanticHighlight<cr>
" nnoremap ]ops :SemanticHighlightRevert<cr>
nnoremap =ops :SemanticHighlightToggle<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM_user_interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set 7 lines to the cursor when moving vertically
set scrolloff=7

" Set the cursorline and column so you can see where you are very easily
set cursorline

" File extensions to check for when using gf
set suffixesadd+=.js,.jsx,.ts,.tsx,.scss,.css,.py,.json;

" Turn on the Wild menu
set wildmenu

" Ignore compiled files, module folders, and repo folders
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico,*.pyc,*.o,*~
set wildignore+=*.pdf,*.psd
set wildignore+=**/node_modules/**
" set wildignore+=node_modules/*
" " ignores node_modules
" set wildignore+=**/node_modules

" Fold options
set foldenable
" set foldmethod=indent
" set foldlevelstart=50
" Useful fold commands: Use zM to close all folds by indentation,
" and zR to open them all. za opens a close fold and closes an open fold.

" Always highlight current line
set ruler
set rulerformat=%38(%#TabLine#\ %-t\ %m\ %#MatchParen#\ %12(%l:%c%V%)\ %k\ %4p%%%)

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hidden

" Show number lines in 'hybrid mode'
set relativenumber
set number

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" Searches are only case sensitive when you use capital letters
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set matchtime=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set timeoutlen=500


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors_and_Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable syntax highlighting
let g:colors_var=0

" Python colors
let g:python_highlight_all=1

" vim-colorscheme-switcher related
let g:colorscheme_switcher_exclude_builtins = 1
" Next colorscheme
" map ]z @=':NextColorScheme<C-V><cr>'<cr>
" map [z @=':PrevColorScheme<C-V><cr>'<cr>
map ]z :NextColorScheme<cr>
map [z :PrevColorScheme<cr>

syntax enable
if has('gui_running')
    colorscheme gruvbox " Default GUI scheme
else
    colorscheme gruvbox " Default terminal scheme
    let g:colorscheme_switcher_exclude = ['boa', 'crunchbang'] " GUI only
endif
" colorscheme crunchbang " gui only

" Set extra options when running in GUI mode
if has('gui_running')
    " set guioptions+=e
    set t_Co=256
    set guitablabel=%M\ %t
    set guioptions-=m  " remove menu bar
    set guioptions-=T  " remove toolbar
    set guioptions-=r  " remove right-hand scroll bar
    set guioptions-=L  " remove left-hand scroll bar
    highlight Cursor guifg=white guibg=black
    highlight iCursor guifg=white guibg=steelblue
    set guicursor=n-v-c:block-Cursor
    set guicursor+=i:ver100-iCursor
    set guicursor+=n-v-c:blinkon0
    set guicursor+=i:blinkwait10
endif

set background=dark " This is totally required for some reason

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf-8
scriptencoding utf-8

" Use Unix as the standard file type
set fileformats=unix,dos,mac


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files_and_backups
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" No backup needed because we use git
set nobackup
set nowritebackup
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text_tab_and_indent_related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs
set smarttab

" 1 tab == 4 spaces.
" This is needed or else it defaults to tab doing *8* spaces
set shiftwidth=2
set tabstop=2

" Linebreak on 500 characters
set linebreak
set textwidth=500

" Auto indent
set autoindent

" Wrap lines
set wrap


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Movement_tabs_windows_and_buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Search by exact word
nnoremap <leader>\ /\<\><left><left>

" Automatically change working directory to the current buffer's
" set autochdir

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" New windows open below the current one by default
set splitbelow

" New windows open to the right of the current one by default
set splitright

" Smart way to move between windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
if has('terminal')
  " set termkey=<C-B>
  tnoremap <c-j> <c-b>j
  tnoremap <c-k> <c-b>k
  tnoremap <c-h> <c-b>h
  tnoremap <c-l> <c-b>l
endif

" Close all the buffers
map <leader>ba :1,1000 bd!<cr>

" Next / previous tab ([v]iewport), supports count
nnoremap ]v @=':tabn<C-V><cr>'<cr>
nnoremap [v @=':tabp<C-V><cr>'<cr>

" New tab
map <leader>tn :tabnew<cr>

map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
" Open current buffer in  new tab
map <leader>tb :tabedit %<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab
  set showtabline=2
catch
endtry

" Return to last edit position when opening files
augroup retain_last_edit_position
  autocmd BufReadPost *
       \ if line("'\"") > 0 && line("'\"") <= line("$") |
       \   exe "normal! g`\"" |
       \ endif
augroup END
" Remember info about open buffers on close
" set viminfo^=% " Is this valuable?


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Status_line
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Always show the status line
set laststatus=2

" Format the status line (see :help statusline)
" set statusline=\ %F%m%r%h\ %w
set statusline=\ %F       " Path to file
set statusline+=%m         " Modified flag
set statusline+=%=        " Switch to the right side
set statusline+=%{HistoryIndicator()}
set statusline+=\ Col:\ 
set statusline+=%c " Column indicator
set statusline+=\ 


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing_mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Save easily
nnoremap <C-s> :w<cr>

" nnoremap <leader>ty [mw"xye<C-o>:let @+ = 'pytest -s -p no:flaky ' . expand('%:p') . ' -k <c-R>x'<cr>
nnoremap <leader>ty :let @+ = 'pytest -s -p no:flaky ' . expand('%:p') . ' -k <c-R>0'<cr>
" Does this next one work? Untested
" nnoremap <leader>ty [mwye<C-o>:let @+ = 'pytest -s -p no:flaky ' . expand('%:p') . ' -k <c-R>0'<cr>

" Make ctags add to the location list
nnoremap <leader>lt :silent! ltag<cr>:lopen<cr>

" Undo highlights
" Try :highlight to see some shit
" function DisableHL()
"   nohl
"   redraw
" endfunction

" Unhighlight the search
nnoremap <silent> <leader>h :nohlsearch<cr>

" " Breaks visual block mode
" let g:unhighlight_flag = 0
" autocmd! InsertEnter * if ! g:unhighlight_flag | call feedkeys("\<C-\>\<C-o>:nohlsearch|let g:unhighlight_flag = 1\<CR>", 'n') | endif
" autocmd! InsertLeave * let g:unhighlight_flag = 0

" Close all buffers, then reopen the one that was last in focus
" nnoremap <leader>bcr :w | %bd | e#

" Remap VIM 0 to first non-blank character
nnoremap 0 ^

" Native vim fuzzy
" nnoremap <leader>se :e **/*

" Mappings I will never ever use
if has('mac') || has('macunix')
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" Fast saving
nmap <leader>w :w!<cr>

" Yank a visual highlight to the clipboard (normal copy functionality)
map <leader>y "+y
" Paste from the clipboard
map <leader>p "+p

" List the current buffers and quickly select
nnoremap <leader>lb :ls<cr>:b<space>
" Open the location list and quickfix list easily
nnoremap <leader>lo :lopen<cr>
nnoremap <leader>co :copen<cr>



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Context_sensitive_mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Make quickfix and locationlist close when you press q
augroup quick_fix
  autocmd!
  " If you find yourself wanting to use a macro (the default 'q' functionality) in a qf, look at ':h cfdo'
  " Also this article: https://chrisarcand.com/vims-new-cdo-command/
  autocmd FileType qf nnoremap <buffer><silent> q :quit<cr>
  autocmd FileType qf nnoremap <buffer><silent> <esc> :quit<cr>
  autocmd FileType qf nnoremap <buffer><silent> <cr> <cr>:lclose<cr>:cclose<cr>
  autocmd FileType qf nnoremap <buffer><silent> o <cr>:copen<cr>
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


command! Ga silent exec "!git add -A"
command! Gac silent exec "!git commit -a"
command! Gacap silent exec "!git commit -a --amend --no-edit && git push -f"

function! RunSearch(searchDirection, searchString)
  execute a:searchDirection . a:searchString
  call search(a:searchString, 'c')
  return @/
endfunction

function! FuzzySearch(searchDirection, inString)
  let l:line = FuzzifyLine(a:inString)
  let @/ = RunSearch(a:searchDirection, l:line)
endfunction

nnoremap <leader>/ :call FuzzySearch('/', '')<left><left>
nnoremap <leader>? :call FuzzySearch('?', '')<left><left>

function! FuzzifyLine(inString)
  let l:splitString = split(a:inString)
  call map(l:splitString, function('FuzzifyWord'))
  let l:result = join(l:splitString, '\S*\s\+.*')
  return l:result
endfunction

function! FuzzifyWord(ind, inString)
  let l:charList = split(a:inString, '\zs')
  let l:joinedString = join(l:charList, '\S*')
  return l:joinedString
endfunction

" Using this function allows you to filter the quickfix list by calling ':QFilter pattern'.
" By default it filters the list to keep results matching the pattern but if you call
" it with ':QFilter! pattern' it will remove results that match the pattern.
function! s:FilterQuickfixList(bang, pattern)
  let cmp = a:bang ? '!~#' : '=~#'
  call setqflist(filter(getqflist(), "bufname(v:val['bufnr']) " . cmp . " a:pattern"))
endfunction
command! -bang -nargs=1 -complete=file QFilter call s:FilterQuickfixList(<bang>0, <q-args>)


" Author: Bernardo Fontes <falecomigo@bernardofontes.net>
" Website: http://www.bernardofontes.net
" This code is based on this one: http://www.cmdln.org/wp-content/uploads/2008/10/python_ipdb.vim
" I worked with refactoring and it simplifies a lot the remove breakpoint feature.
" To use this feature, you just need to copy and paste the content of this file at your .vimrc file! Enjoy!
" python3 << EOF
" import vim
" import re
" 
" ipdb_breakpoint = 'import ipdb; ipdb.set_trace()'
" 
" def set_breakpoint():
"     breakpoint_line = int(vim.eval('line(".")')) - 1
" 
"     current_line = vim.current.line
"     white_spaces = re.search('^(\s*)', current_line).group(1)
" 
"     vim.current.buffer.append(white_spaces + ipdb_breakpoint, breakpoint_line)
" 
"     # vim.command('map <C-I> :py3 set_breakpoint()<cr>')
" 
" def remove_breakpoints():
"     op = 'g/^.*%s.*/d' % ipdb_breakpoint
"     vim.command(op)
" 
" vim.command('map <C-P> :py3 remove_breakpoints()<cr>')
" 
" def toggle_breakpoint():
"     breakpoint_line = int(vim.eval('line(".")')) - 1
"     if 'import ipdb; ipdb.set_trace()' in vim.current.buffer[breakpoint_line]:
"         remove_breakpoints()
"     elif 'import ipdb; ipdb.set_trace()' in vim.current.buffer[breakpoint_line-1]:
"         remove_breakpoints()
"     else :
"         set_breakpoint()
"     vim.command(':let g:ale_fix_on_save=0')
"     vim.command(':w')
"     vim.command(':let g:ale_fix_on_save=1')
" 
" 
" # vim.command('map <f6> :py3 toggle_breakpoint()<cr>')
" 
" EOF
