" Use Vim settings, rather than Vi settings. This setting must be as early as
" possible, as it has side effects.
if &compatible
  set nocompatible
end

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

  " Autogenerate tags
  Plug 'craigemery/vim-autotag'

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
  Plug 'leafgarland/typescript-vim'

  " Tools for HTML
  Plug 'othree/html5.vim', { 'for': 'html' }

  " Emmet for writing HTML quickly
  Plug 'mattn/emmet-vim', { 'for': 'html' }

  " Tools for Elm
  Plug 'lambdatoast/elm.vim'
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
highlight NonText guibg=#060606
highlight Folded ctermbg=14 ctermfg=15
highlight Todo cterm=NONE ctermfg=white ctermbg=darkred
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
function! TrimTrailingWhiteSpace()
    %s/\s\+$//e
endfunction

if has('autocmd')
  augroup standard
    autocmd!

    " Don't expand tabs in make files
    autocmd FileType make setlocal noexpandtab

    " Check spelling in git commits
    autocmd FileType gitcommit setlocal spell textwidth=72

    " Filetypes with 2-space indents
    autocmd FileType vim,ruby,scss,sass,typescript setlocal ts=2 sts=2 sw=2

    " 2 space indents for html
    autocmd FileType html setlocal ts=2 sts=2 sw=2

    " Wrap at 80 cols and spell check
    autocmd FileType md,markdown,text setlocal spell tw=79 fo+=a

    " Remove whitespace on save
    autocmd FileWritePre    * :call TrimTrailingWhiteSpace()
    autocmd FileAppendPre   * :call TrimTrailingWhiteSpace()
    autocmd FilterWritePre  * :call TrimTrailingWhiteSpace()
    autocmd BufWritePre     * :call TrimTrailingWhiteSpace()

    " Restore file cursor position on open
    autocmd BufReadPost *
         \ if line("'\"") > 0 && line("'\"") <= line("$") |
         \   exe "normal! g`\"" |
         \ endif

    autocmd BufNewFile,BufRead *.markdown,*.md set filetype=markdown

    " Build html after wiki saves
    autocmd FileWritePost   *.wiki :Vimwiki2HTML
    autocmd FileAppendPost  *.wiki :Vimwiki2HTML
    autocmd FilterWritePost *.wiki :Vimwiki2HTML
    autocmd BufWritePost    *.wiki :Vimwiki2HTML

  augroup END
endif
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

" Disable arrow keys
nnoremap <Left> :echoe "Use h"<cr>
nnoremap <Down> :echoe "Use j"<cr>
nnoremap <Up> :echoe "Use k"<cr>
nnoremap <Right> :echoe "Use l"<cr>

" Window splits
nnoremap <leader>\ :vsplit<cr>
nnoremap <leader>- :split<cr>

" Paste from system clipboard
nnoremap <leader>P "+p<cr>

" Don't deselect in visual mode when indenting/dedenting
vnoremap > >gv
vnoremap < <gv

" Clear search highlights
nnoremap <leader>l :nohlsearch<cr>

" Grep word under cursor, brings up quickfix window
nnoremap K :grep! "\b<cword>\b"<cr>:cw<cr>

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

" --- The Silver Searcher {{{
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use Ag in CtrlP for listing files. Super fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " Ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif
" --- }}}

" --- CtrlP {{{

let g:ctrlp_max_height=15           " Height of the ctrlp window

" ctags with CtrlP
nnoremap <leader>. :CtrlPTag<cr>

" --- }}}

" --- Syntastic {{{

" Clear visual marks for errors and warnings
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'

" Enable the quick fix window on open and save
let g:syntastic_check_on_open=1
let g:syntastic_check_on_wq=0

" Location list settings
let g:syntastic_loc_list_height=5
let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=1

" Enable some sane default JavaScript options
let g:syntastic_javascript_jslint_args = '--nomen --browser --node'

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
