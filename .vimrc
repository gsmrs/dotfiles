call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'ctrlpvim/ctrlp.vim'
Plug 'majutsushi/tagbar'
Plug 'flazz/vim-colorschemes'
Plug 'Evalir/dosbox-vim-colorscheme'
Plug 'chriskempson/base16-vim'
Plug 'altercation/vim-colors-solarized'
Plug 'morhetz/gruvbox'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'junegunn/vim-easy-align'
Plug 'PeterRincker/vim-argumentative'

Plug 'rhysd/vim-clang-format'

" language specific plugins
Plug 'plasticboy/vim-markdown'
Plug 'davidhalter/jedi-vim', {'for': 'python'}
Plug 'tikhomirov/vim-glsl'
Plug 'mattn/emmet-vim', {'for': ['html', 'css', 'htmldjango']}
Plug 'rust-lang/rust.vim'
Plug 'ziglang/zig.vim'
Plug 'fatih/vim-go'

call plug#end()
set nocompatible
filetype off

" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugins
filetype plugin indent on

set encoding=utf-8

" Set to auto read when a file is changed from the outside
set autoread

" sane splits
set splitright
set splitbelow

" Permanent undo
set undodir=~/.vimdid
set undofile

let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git\|target'

" Enable mouse
set mouse=a

set foldmethod=indent
set foldlevel=1

set number
" set relativenumber

" set scrolloffset to 2 lines (always keep 2 lines in each direction visible around the current line)
set scrolloff=2

" Turn on the WiLd menu (command line completion)
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc

"Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch
" Don't highlight after sourcing .vimrc
nohlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
"
" How many tenths of a second to blink when matching brackets
set mat=1

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" integrated fuzzy finder
set path+=**

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

" Enable true colors; this is only needed for vim, neovim works
" fine out of the box
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set background=dark
colorscheme elflord

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=m
    set guioptions+=e
    set t_Co=256
    set guitablabel=%M\ %t
    set guifont=DejaVu\ Sans\ Mono\ Bold\ 10
endif

" Use Unix as the standard file type
set ffs=unix,dos,mac

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set autoindent "Auto indent
" set smartindent "Smart indent
set nosmartindent
set wrap "Wrap lines

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Delete trailing white space on save
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

augroup vimrc_autocmd
    autocmd!
    autocmd BufWrite * :call DeleteTrailingWS()

    " Generate ctags
    " autocmd BufWritePost *.c,*.cpp,*.h,*.hpp,*.py,*.rb silent! !ctags -R .
    "
    autocmd FileType c,cpp nnoremap <buffer><Leader>cf :ClangFormat<CR>
    " Return to last edit position when opening files (You want this!)
    autocmd BufReadPost *
         \ if line("'\"") > 0 && line("'\"") <= line("$") |
         \   exe "normal! g`\"" |
         \ endif
augroup END

" Remember info about open buffers on close
set viminfo^=%

let g:clang_format#style_options = {
            \ "ColumnLimit": 80,
            \ "Standard" : "C++11"
            \}


""""""""""""""""""""""""""""""
" => Status line (airline)
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2
let g:airline#extensions#tabline#enabled=1
let g:airline_powerline_fonts=0

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let maplocalleader = "\\"
let g:mapleader = ","

" Fast saving & closing
nmap <leader>w :w!<cr>
nmap <leader>q :q!<cr>

" switch buffers using <leader>n / <leader>m
nnoremap <leader>n :bp<cr>
nnoremap <leader>m :bn<cr>

" Reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv

" use H and L to go to beginning / end of line
map H ^
map L $

" Easier access to ESC
imap jj <ESC>
nnoremap <C-k> <Esc>
inoremap <C-k> <Esc>
vnoremap <C-k> <Esc>
snoremap <C-k> <Esc>
xnoremap <C-k> <Esc>
cnoremap <C-k> <Esc>
onoremap <C-k> <Esc>
lnoremap <C-k> <Esc>
tnoremap <C-k> <Esc>

" Edit .vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

nnoremap <leader>t :CtrlPBufTag<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :bd<cr>

" Close all the buffers
map <leader>ba :1,1000 bd!<cr>

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => EasyAlign key bindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

nnoremap <F8> :TagbarToggle<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Jedi configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:jedi#usages_command = "<leader>u"
let g:jedi#use_splits_not_buffers = "right"
let g:jedi#popup_select_first = 0
let g:jedi#popup_on_dot = 0
let g:jedi#smart_auto_mappings = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Python
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>bp Oimport ipdb; ipdb.set_trace()<ESC><ESC>j


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Rust
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rustfmt_autosave = 0
