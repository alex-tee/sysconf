set encoding=utf-8
scriptencoding utf-8
" enable plugins
filetype plugin on

" Auto-install vim-plug if not present
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Init vim-plug
call plug#begin('~/.vim/plugged')

"Plug 'Yggdroot/indentLine'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
"Plug 'majutsushi/tagbar'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'lepture/vim-jinja'
"Plug 'xolox/vim-misc'
"Plug 'xolox/vim-session'
"Plug 'vim-scripts/OmniCppComplete'
"Plug 'tpope/vim-fugitive'
"Plug 'tpope/vim-sensible'
" For highlighting trailing whitespace
"Plug 'ntpeters/vim-better-whitespace'
"Plug 'vim-scripts/AutoComplPop'
"Plug 'Valloric/YouCompleteMe'
"Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
"Plug 'tpope/vim-surround'
"Plug 'vim-scripts/Conque-GDB'
"Plug 'ericcurtin/CurtineIncSw.vim'
"Plug 'chazy/cscope_maps'
Plug 'octol/vim-cpp-enhanced-highlight'
"Plug 'ctrlpvim/ctrlp.vim'
"Plug 'Shougo/denite.nvim'
"Plug 'edkolev/promptline.vim'
"Plug 'vim-ctrlspace/vim-ctrlspace'
"Plug 'tpope/vim-unimpaired'
"Plug 'vim-syntastic/syntastic'
"Plug 'w0rp/ale'
"Plug 'vim-scripts/a.vim'
Plug 'w0ng/vim-hybrid' " theme
Plug 'joshdick/onedark.vim' " theme
"Plug 'NLKNguyen/papercolor-theme'
"Plug 'tenfyzhong/vim-gencode-cpp'
"Plug 'leafgarland/typescript-vim'
Plug 'tikhomirov/vim-glsl'
Plug 'HiPhish/guile.vim'
"Plug 'gko/vim-coloresque'
Plug 'ap/vim-css-color'
"Plug 'fatih/vim-go'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'gmoe/vim-faust'

" Initialize plugin system.
call plug#end()

set background=dark
colorscheme hybrid
let g:solarized_termcolors=256

" Enable per-project configuration files.
set exrc

" Set UTF-8 encoding.
set fileencoding=utf-8
set termencoding=utf-8
" use indentation of previous line
set autoindent
" use intelligent indentation for C
set smartindent
" insert spaces whenever <Tab> is pressed
set expandtab
" number of spaces to add when <Tab> is pressed
set tabstop=2
set shiftwidth=2 " indent also with 2 spaces

" mark tab characters as 'T>'
highlight SpecialKey ctermfg=1
set list
set listchars=tab:T>

" wrap lines at 120 chars. 80 is somewaht antiquated with nowadays displays.
"set textwidth=120
" turn syntax highlighting on
set t_Co=256
syntax on
set number " turn on line numbers
" highlight matching braces
set showmatch
" intelligent comments
set comments=sl:/*,mb:\ *,elx:\ */
" Don't save hidden and unloaded buffers in sessions.
set sessionoptions-=buffers
set tags+=tags
set showbreak=->
set relativenumber
set noswapfile

"automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

let g:NERDTreeShowHidden=1 " show hidden files

"let g:easytags_async=1
"let g:easytags_syntax_keyword='always'
"let g:easytags_include_members=1
highlight link cMember Special
"let g:easytags_dynamic_files = 1

" vim.cpp
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1

"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#hunks#enabled = 0
let g:airline_powerline_fonts = 1
let g:airline#extensions#tagbar#enabled = 0
let g:airline#extensions#fugitiveline#enabled = 0
let g:airline#extensions#branch#enabled = 0

let g:session_persist_font = 0
let g:session_persist_colors = 0
let g:session_autoload = 0

function! MarkWindowSwap()
    let g:markedWinNum = winnr()
endfunction

" Mappings
"
" switch between header/source with F4
"map <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>
" Open the definition in a new tab
" map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
" Open the definition in a vertical split
"map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
" start renaming
noremap <Leader>r :call Renamec()<cr>
" update cscope reference file
"map <F12> :!cscope -R -k -b<CR>:cs reset<CR>
map <F12> :!gentags<CR>
map <C-F12> :!gentagsall<CR>
" build tags of your own project with Ctrl-F12
"map <C-F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
" Map Ctrl-Backspace to delete the previous word in insert mode.
"imap <C-BS> <C-W><CR>
" Esc exits insert mode immediately
"imap <Esc> <Esc><Esc><CR>
vmap <Esc> <Esc><Esc><CR>
"map <F2> :NERDTreeToggle<CR>

nmap <F8> :TagbarToggle<CR>
map <C-_> <Plug>NERDCommenterToggle<CR>
map <Esc><Esc> :noh<CR>
function! GotoDefinition()
  let l:n = search("\\<".expand("<cword>")."\\>[^(]*([^)]*)\\s*\\n*\\s*{")
endfunction
map <F4> :call GotoDefinition()<CR>
imap <F4> <c-o>:call GotoDefinition()<CR>
nmap ff :GREP<Enter>
nmap fa :GREPALLSRC<Enter>
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :<C-u>cfirst<CR>
nnoremap ]Q :<C-u>clast<CR>

" change windows with Ctrl + hjkl
nnoremap <silent> <C-l> <c-w>l
nnoremap <silent> <C-h> <c-w>h
nnoremap <silent> <C-k> <c-w>k
nnoremap <silent> <C-j> <c-w>j

nmap j gj
nmap k gk
vmap j gj
vmap k gk

set modelines=0
set hlsearch    " Switch on highlighting the last used search pattern.
set ruler
set smarttab
set path+=** " add subfolders to path
set wildmenu
set wrap
" Display 5 lines above/below the cursor when scrolling with a mouse.
set scrolloff=5
set ttyfast
set laststatus=2
set showmode
set showcmd
set foldmethod=syntax
set foldlevel=1
set updatetime=100
set clipboard^=unnamed

" more powerful backspacing (deleting to prev line, etc.)
set backspace=indent,eol,start

" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

" HTML indentation
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"
let g:html_indent_inctags = "address,article,aside,audio,blockquote,canvas,dd,div,dl,fieldset,figcaption,figure,footer,form,h1,h2,h3,h4,h5,h6,header,hgroup,hr,main,nav,noscript,ol,output,p,pre,section,table,tfoot,ul,video"

" Easily GREP current word in current file.
command GREP :execute 'vimgrep /'.expand('<cword>').'/j '.expand('%') | :copen
"command GREPALL :execute 'vimgrep '.expand('<cword>').' ./**/*' | :copen | :cc
command GREPALL :execute 'noautocmd vimgrep /'.expand('<cword>').'/j * **/*' | :copen
command GREPALLSRC :execute 'noautocmd vimgrep /'.expand('<cword>').'/j *.cpp **/*.cpp *.h **/*.h */hpp **/*.hpp' | :copen

" Toggles the include type (from <> to "" or the opposite)
" FIXME only does one-way atm
command ToggleIncludeType '<,'>s/"\(.\+\)"/<\1>/g

" GNU style indentation for C/C++, with some customization
function! GnuIndent()
  setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(1s,u0,w1,m1
  setlocal shiftwidth=2
  setlocal tabstop=8
endfunction
au FileType c,cpp call GnuIndent()

" disable unsafe commands in project-specific vimrc files
set secure
command! -nargs=* Wrap set wrap linebreak nolist

au BufNewFile,BufRead .clang-tidy set filetype=yaml
au BufNewFile,BufRead CMakeLists.txt set filetype=cmake
au BufNewFile,BufRead *.j2.inc set filetype=jinja
au BufNewFile,BufRead *.env.example set filetype=sh
au BufNewFile,BufRead *.sh.inc set filetype=sh
au BufNewFile,BufRead *.dsp.* set filetype=faust
au BufNewFile,BufRead *.lib set filetype=faust
au FileType * autocmd BufWritePre <buffer> %s/\s\+$//e " strip trailing whitespace on save
au FileType html setlocal nosmartindent
au FileType xml,html,css,js,json,ts,ruby setlocal ts=2 sw=2 sts=2
au FileType c,cpp setlocal ts=2 sw=2 sts=2
"au BufRead * Wrap

" show the NERDTree when opening vim
autocmd VimEnter * NERDTree

" allow project specific vimrc's
set exrc
set secure

" Put these lines at the very end of your vimrc file.
" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL
