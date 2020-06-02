" Use Vim settings, rather than Vi settings. This setting must be as early as
" possible, as it has side effects.
if &compatible
  set nocompatible
end


" --- Ale {{{

let g:ale_fixers = {
\   'javascript': ['prettier'],
\   'javascriptreact': ['prettier'],
\   'typescript': ['prettier'],
\   'typescriptreact': ['prettier'],
\   'less': ['prettier'],
\}

let g:ale_fix_on_save = 1

" --- }}}

" --- Vim Plug {{{
" Auto-install plug-vim
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
  " Aesthetic status line lightline
  Plug 'itchyny/lightline.vim'

  " Fuzzy file finder
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'

  " Async linter
  Plug 'w0rp/ale'

  " Color schemes from base16
  Plug 'chriskempson/base16-vim'

  " Autogenerate tags
  Plug 'craigemery/vim-autotag'

  " Ctags Outline View
  Plug 'majutsushi/tagbar'

  " Seamless transition between vim-splits and tmux panes
  Plug 'christoomey/vim-tmux-navigator'

  " Use Git
  Plug 'tpope/vim-fugitive'

  " Tools to change delimiters
  Plug 'tpope/vim-surround'

  " Helping out netrw
  Plug 'tpope/vim-vinegar'

  " Tools for code alignment
  Plug 'junegunn/vim-easy-align'

  " Tools for TypeScript
  Plug 'HerringtonDarkholme/yats.vim'

  " Language Server Support
  Plug 'neoclide/coc.nvim', {'branch': 'release' }

  " Tools for GraphQL
  Plug 'jparise/vim-graphql'

  " Tools for JSX
  Plug 'MaxMEllon/vim-jsx-pretty'

  " Tools for Rust
  Plug 'rust-lang/rust.vim'

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
set scrolloff=999               " Center current line vertically if we can
set sidescrolloff=5             " Scroll horizontally before edge
set history=25                  " Limit history to 25 commands
set ttimeoutlen=100             " Faster mode switching
set updatetime=300              " Faster diagnostic messages

" Interface
set hidden                      " When I open a new file in a buffer, hide old buffer
set shortmess+=Iat              " Disable help screen, avoid enter prompt
set nowrap                      " Don't line wrap
set backspace=indent,eol,start  " Treat backspace as delete
set modeline                    " Make file-specific settings in comments
set cmdheight=2                 " Give more room for cmd messages
set number                      " Show the line number
set virtualedit=all             " EOL is not a navigation barrier

" Split in the correct direction
set splitbelow
set splitright

" When listing characters, show some invisible characters of interest
set listchars=tab:▸\ ,eol:¬,trail:·

if v:version >= 703
  set cursorline                " Highlight the current line
  set numberwidth=6             " Use more padding for the numbers
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
highlight Folded ctermbg=darkblue ctermfg=white

let base16colorspace=256
set background=dark
colorscheme base16-gruvbox-dark-hard
" --- }}}

" --- Tab completion {{{

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

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

    " Remove trailing whitespace (cleaans up for virtualedit)
    fun! <SID>TrimTrailingWhitespace()
        let l = line('.')
        let c = col('.')
        %s/\s\+$//e
        call cursor(l, c)
    endfun
    autocmd BufWritePre * :call <SID>TrimTrailingWhitespace()

    " Restore file cursor position on open
    autocmd BufReadPost *
         \ if line("'\"") > 0 && line("'\"") <= line("$") |
         \   exe "normal! g`\"" |
         \ endif

    autocmd BufNewFile,BufRead *.markdown,*.md setlocal filetype=markdown

    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup END
endif
" --- }}}

" --- Abbreviations {{{
abbreviate cagdas Çağdaş
" --- }}}

" --- Mappings {{{
" Leader
let mapleader = " "

" ; as :
nnoremap ; :

" Jump to start/end of line using home row keys
nnoremap H ^
nnoremap L $
vnoremap H ^
vnoremap L $

" Reload .vimrc
nnoremap <leader>R :so $MYVIMRC<cr>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Save files
nnoremap <Leader>e :w<cr>

" Window splits
nnoremap <leader>\ :vsplit<cr>
nnoremap <leader>- :split<cr>

" Copy/Paste to/from system clipboard
vnoremap <leader>C "+y
nnoremap <leader>P "+p<cr>

" Don't deselect in visual mode when indenting/dedenting
vnoremap > >gv
vnoremap < <gv

" Clear search highlights
nnoremap <leader>l :nohlsearch<cr>
"
" Grep word under cursor, brings up quickfix window
nnoremap X :grep! "\b<cword>\b"<cr>:cw<cr>

" Press K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Use jj to escape insert mode
inoremap jj <esc>

" Expand opening-brace followed by ENTER to a block and place cursor inside
inoremap {<CR> {<CR>}<esc>O

" Close an open paren
inoremap ( ()<esc>i
inoremap (<esc> (<esc>
inoremap (<cr> (<cr>)<esc>O
inoremap () ()

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Rename current word
nmap <leader>rn <Plug>(coc-rename)

nnoremap <leader>w :w<Enter>:!!<Enter>

" --- }}}

" --- Status Line {{{

  let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
    \ },
    \ 'component_function': {
    \   'filename': 'LightlineFilename',
    \   'cocstatus': 'coc#status'
    \ },
  \ }

function! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction
" --- }}}

" --- Ripgrep {{{
if executable('rg')
  " Use ripgrep over grep
  set grepprg=rg\ --vimgrep\ --no-heading
endif
" --- }}}

" --- FZF {{{

" Less crazy size for fzf
let g:fzf_layout = { 'down': '~20%' }

" Opening fizes with FZF
nnoremap <c-p> :GFiles<cr>

" Buffer management
nnoremap <leader>, :Buffers<cr>

" ctags with FZF
nnoremap <leader>. :Tags<cr>

" <leader>s for Rg search
noremap <leader>s :Rg<space>
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" --- }}}

" --- Tagbar {{{
" ctags with Tagbar
nnoremap <leader>t :TagbarToggle<cr>
" --- }}}

" --- Fugitive {{{

nnoremap <leader>b :Gblame<cr>
nnoremap <leader>d :Gdiff<cr>

" --- }}}

" --- Easy Align {{{
nnoremap <leader>a <Plug>(EasyAlign)
xnoremap <leader>a <Plug>(EasyAlign)
" --- }}}

" vim: autoindent tabstop=2 expandtab shiftwidth=2 softtabstop=2 filetype=vim
