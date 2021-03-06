" Use Vim settings, rather than Vi settings. This setting must be as early as
" possible, as it has side effects.
if &compatible
  set nocompatible
end


" --- Ale {{{
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'jsx': ['eslint'],
\   'javascriptreact': ['eslint'],
\   'typescript': ['tsserver', 'eslint'],
\   'typescriptreact': ['tsserver', 'eslint'],
\}

let g:ale_fixers = {
\   'javascript': ['prettier'],
\   'javascriptreact': ['prettier'],
\   'typescript': ['prettier'],
\   'typescriptreact': ['prettier'],
\   'less': ['prettier'],
\}

let g:ale_fix_on_save = 1

" ALE completion needs to be configured before loading, so this block goes
" above the vim-plug block
let g:ale_completion_enabled = 1
let g:ale_completion_tsserver_autoimport = 1
" --- }}}

" --- Vim Plug {{{
" Auto-install plug-vim
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
  " Fuzzy file finder
  Plug 'ctrlpvim/ctrlp.vim'

  " Async linter
  Plug 'w0rp/ale'

  " Autogenerate tags
  Plug 'craigemery/vim-autotag'

  " Ctags Outline View
  Plug 'majutsushi/tagbar'

  " Seamless transition between vim-splits and tmux panes
  Plug 'christoomey/vim-tmux-navigator'

  " Un-indent ending structures
  Plug 'tpope/vim-endwise'

  " Use Git
  Plug 'tpope/vim-fugitive'

  " Tools to change delimiters
  Plug 'tpope/vim-surround'

  " Helping out netrw
  Plug 'tpope/vim-vinegar'

  " Tools for code alignment
  Plug 'junegunn/vim-easy-align'

  " Notetaking
  Plug 'vimwiki/vimwiki'

  " Tools for TypeScript
  Plug 'HerringtonDarkholme/yats.vim'

  " Tools for HTML
  Plug 'othree/html5.vim', { 'for': 'html' }

  " Emmet for writing HTML quickly
  Plug 'mattn/emmet-vim', { 'for': 'html' }

  " Tools for Elm
  Plug 'lambdatoast/elm.vim'

  " Tools for JSX
  Plug 'MaxMEllon/vim-jsx-pretty'

  " Manage JS imports
  Plug 'kristijanhusak/vim-js-file-import', {'do': 'npm install'}
call plug#end()
" --- }}}

" --- General Settings {{{
" File Settings
set encoding=utf-8              " Read files using utf-8
set autoread                    " Read a changed file

" Backup/swap files
set nobackup
set nowritebackup
set noswapfile

" Enable persistent undo
if has('persistent_undo')
  set undofile
  set undodir=/tmp
endif

" Delete comment character when joining commented lines
if v:version > 703 || v:version == 703 && has('patch541')
  set formatoptions+=j
endif

set autowrite

" Performance
set lazyredraw                  " Don't redraw while running macros
set ttyfast                     " Speed up scrolling
set ttyscroll=3                 " Speed up scrolling
set scrolloff=999               " Center current line vertically if we can
set sidescrolloff=5             " Scroll horizontally before edge
set history=25                  " Limit history to 25 commands
set ttimeoutlen=100             " Faster mode switching

" Interface
set hidden                      " When I open a new file in a buffer, hide old buffer
set shortmess+=Iat              " Disable help screen, avoid enter prompt
set nowrap                      " Don't line wrap
set backspace=indent,eol,start  " Treat backspace as delete
set modeline                    " Make file-specific settings in comments

" Split in the correct direction
set splitbelow
set splitright

" When listing characters, show some invisible characters of interest
set listchars=tab:▸\ ,eol:¬,trail:·

if v:version >= 703
  set relativenumber            " Use relative numbers for ease of movement
  set cursorline                " Highlight the current line
endif


" Searching
set ignorecase                  " Ignore case in search
set smartcase                   " Don't ignore case if contains uppercase letter
set wrapscan                    " Wrap search from bottom of file to top
set showmatch                   " Show matching brackets
set hlsearch                    " Highlight search results
set incsearch                   " Search as you type

" Sets 'very magic' mode, similar to Python/Ruby/Grep regex syntax
cnoremap %s/ %s/\v
nnoremap / /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v

" Tabs/spaces
set tabstop=4                   " Replace tabs with four spaces
set shiftwidth=4
set softtabstop=4
set expandtab

" Indenting
set autoindent                  " Enable auto indenting
set smartindent                 " Try to 'improve' indenting rules

" Folding
set foldenable                  " Enable code folding on markers
set foldmethod=marker
set foldnestmax=1
" --- }}}

" --- Wild Menu {{{
set wildignore+=*.swp,*~,tags,__init__.py,*.pyc,*.pyo,*.ttf,*.DS_Store
set wildignore+=*.mp3,*.wav,*.ogg,*.ico,*.icns,*.jpg,*.jpeg,*.png,*.gif,*.db
set wildignore+=*.out,*/tmp/*,*/build/*,*/node_modules/*,*.gem,*/dist/*
set wildignore+=*/bower_components/*,*.svg,*/*.egg-info/*,*/bin/*
" --- }}}

" --- Color scheme {{{
highlight CursorLine cterm=NONE ctermbg=black
highlight CursorLineNr cterm=NONE
highlight NonText guibg=#060606
highlight Folded ctermbg=darkblue ctermfg=white
highlight Todo cterm=NONE ctermfg=white ctermbg=darkred
highlight DiffAdd ctermfg=black ctermbg=2
highlight DiffDelete ctermfg=white ctermbg=darkred
highlight DiffChange ctermfg=black ctermbg=yellow
" --- }}}

" --- Tab completion {{{
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
set complete=.,w,t
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
" --- }}}

" --- Autocommands {{{
if has('autocmd')
  augroup standard
    autocmd!

    " Don't expand tabs in make files
    autocmd FileType make setlocal noexpandtab

    " Check spelling in git commits
    autocmd FileType gitcommit setlocal spell textwidth=72

    " Filetypes with 2-space indents
    autocmd FileType vim,javascript,javascriptreact,typescript,typescript.tsx,typescriptreact setlocal ts=2 sts=2 sw=2

    " 2 space indents for html
    autocmd FileType html setlocal ts=2 sts=2 sw=2

    " Fallback to typescript.tsx filetype for now
    autocmd FileType typescriptreact setlocal filetype=typescript.tsx

    " Wrap at 80 cols and spell check
    autocmd FileType md,markdown,text setlocal spell tw=79

    " Restore file cursor position on open
    autocmd BufReadPost *
         \ if line("'\"") > 0 && line("'\"") <= line("$") |
         \   exe "normal! g`\"" |
         \ endif

    autocmd BufNewFile,BufRead *.markdown,*.md setlocal filetype=markdown

    " Build html after wiki saves
    autocmd FileWritePost   *.wiki :Vimwiki2HTML
    autocmd FileAppendPost  *.wiki :Vimwiki2HTML
    autocmd FilterWritePost *.wiki :Vimwiki2HTML
    autocmd BufWritePost    *.wiki :Vimwiki2HTML
  augroup END
endif
" --- }}}

" --- Abbreviations {{{
abbreviate cagdas Çağdaş
" --- }}}

" --- Mappings {{{
" Leader
let mapleader = " "

" Reload .vimrc
nnoremap <leader>r :so $MYVIMRC<cr>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Save files
nnoremap <Leader>e :w<cr>

" Window splits
nnoremap <leader>\ :vsplit<cr>
nnoremap <leader>- :split<cr>

" Copy/Paste to/from system clipboard
vnoremap <leader>C "+ygv
nnoremap <leader>P "+p<cr>

" Don't deselect in visual mode when indenting/dedenting
vnoremap > >gv
vnoremap < <gv

" Clear search highlights
nnoremap <leader>l :nohlsearch<cr>

" Grep word under cursor, brings up quickfix window
nnoremap K :grep! "\b<cword>\b"<cr>:cw<cr>

" Use jj to escape insert mode
inoremap jj <esc>

" Expand opening-brace followed by ENTER to a block and place cursor inside
inoremap {<CR> {<CR>}<Esc>O
" --- }}}

" --- Status Line {{{
set laststatus=2
set statusline=%f%m%r%h                     " file, modified, ro, help tags
if v:version >= 703
  set statusline+=%q                        " quickfix tag
endif
set statusline+=\ %{fugitive#statusline()}  " git status (branch)
set statusline+=%#warningmsg#
set statusline+=%*                          "*
set statusline+=\ %=#%n                     " start right-align. buffer number
set statusline+=\ %l/%L,%c                  " lines/total, column
set statusline+=\ [%P]                      " percentage in file
" --- }}}

" --- Ripgrep {{{
if executable('rg')
  " Use ripgrep over grep
  set grepprg=rg\ --vimgrep\ --no-heading

  " Use ripgrep in CtrlP for listing files
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'

  " ripgrep is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif
" --- }}}

" --- CtrlP {{{
let g:ctrlp_max_height=15           " Height of the ctrlp window

" ctags with CtrlP
nnoremap <leader>. :CtrlPTag<cr>
" --- }}}

" --- Tagbar {{{
" ctags with Tagbar
nnoremap <leader>t :TagbarToggle<cr>
" --- }}}

" --- Fugitive {{{
nnoremap <leader>b :Gblame<cr>
nnoremap <leader>B :Gbrowse<cr>
nnoremap <leader>c :Gcommit %<cr>
nnoremap <leader>C :Gcommit -a<cr>
nnoremap <leader>d :Gdiff<cr>
nnoremap <leader>s :Gstatus<cr>
" --- }}}

" --- Easy Align {{{
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)
" --- }}}

" vim: autoindent tabstop=2 expandtab shiftwidth=2 softtabstop=2 filetype=vim
