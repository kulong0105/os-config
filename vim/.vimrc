set nu
set cindent
set bg=dark
" colorscheme pablo
"colorscheme elflord
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set nocompatible
set nocp

set showcmd
set foldenable
set foldmethod=manual
set helplang=cn
set laststatus=2 "Always display the statusline in all windows
set t_Co=256

"set textwidth=80
"set colorcolumn=+1
"set fileencodings=cp936,utf-8,ucs-bom,gb18030,gbk,gb2312
set encoding=utf-8
set mouse=
set hlsearch


syntax on
filetype plugin on

:source /Users/yilong/.vim/abbreviation.vim
autocmd FileType make setlocal noexpandtab
autocmd Filetype ruby setlocal ts=2 sw=2 expandtab
autocmd Filetype go setlocal ts=2 sw=2 expandtab
autocmd FileType python set tabstop=4|set shiftwidth=4|set expandtab

" auto wrap long lines for python
"autocmd BufRead,BufNewFile *.py set wm=2 tw=80


"colorscheme molokai
"let g:molokai_original = 1
"let g:rehash256 = 1

map <F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
nmap gi :GitGutter <CR>
nmap su :w !sudo tee %<CR>


" Auto add head info
" .py file into add header
function HeaderPython()
    call setline(1, "#!/usr/bin/env python")
    call append(1, "# coding: utf-8")
    normal G
    normal o
endf
autocmd bufnewfile *.py call HeaderPython()

" .sh file
function HeaderBash()
    call setline(1, "#!/bin/bash")
    normal G
    normal o
endf
autocmd bufnewfile *.sh call HeaderBash()


call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'Chiel92/vim-autoformat'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'luochen1990/rainbow'              "different color for parens

Plug 'easymotion/vim-easymotion'        "fast move
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-easymotion.vim'

Plug 'Raimondi/delimitMate'             "auto-completion for quotes / parens / brackets
Plug 'tpope/vim-commentary'             "easy comments/uncomments
"""Plug 'prettier/vim-prettier', {'do': 'yarn install', 'for': ['json', 'python', 'markdown', 'yaml']} "auto format


Plug 'vim-scripts/taglist.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'fholgado/minibufexpl.vim'
Plug 'vim-scripts/OmniCppComplete'
Plug 'ycm-core/YouCompleteMe'
Plug 'vim-syntastic/syntastic'

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

Plug 'vim-python/python-syntax'
Plug 'vim-scripts/indentpython.vim'
Plug 'nvie/vim-flake8'
Plug 'davidhalter/jedi-vim'

Plug 'majutsushi/tagbar'

Plug 'SpaceVim/SpaceVim'
call plug#end()


" global setting
let mapleader="\<Space>"


" vim-autoformat'
nmap rm :RemoveTrailingSpaces<CR>

" rainbow (彩虹括号)
let g:rainbow_active=1
let g:rainbow_conf = {
\	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
\	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
\	'operators': '_,_',
\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\	'separately': {
\		'*': {},
\		'tex': {
\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
\		},
\		'lisp': {
\			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
\		},
\		'vim': {
\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
\		},
\		'html': {
\			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
\		},
\		'css': 0,
\	}
\}


" vim-easymotion setting
map <Leader> <Plug>(easymotion-prefix)
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)
" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)
" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)
" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)
" You can use other keymappings like <C-l> instead of <CR> if you want to
" use these mappings as default search and sometimes want to move cursor with
" EasyMotion.
function! s:incsearch_config(...) abort
  return incsearch#util#deepextend(deepcopy({
  \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
  \   'keymap': {
  \     "\<CR>": '<Over>(easymotion)'
  \   },
  \   'is_expr': 0
  \ }), get(a:, 1, {}))
endfunction
noremap <silent><expr> /  incsearch#go(<SID>incsearch_config())
noremap <silent><expr> ?  incsearch#go(<SID>incsearch_config({'command': '?'}))
noremap <silent><expr> g/ incsearch#go(<SID>incsearch_config({'is_stay': 1}))


" taglist setting
let Tlist_Show_One_File=1           "不同时显示多个文件的tag，只显示当前文件的
let Tlist_Exit_OnlyWindow=1         "如果taglist窗口是最后一个窗口，则退出vim
let Tlist_Ctags_Cmd="/usr/local/bin/ctags"  "将taglist与ctags关联
nmap tl :TlistToggle<CR>


" winmanager setting
"let g:winManagerWindowLayout = "FileExplorer"
let g:NERDTree_title="[NERDTree]"
let g:winManagerWindowLayout="NERDTree|TagList"
function! NERDTree_Start()
    exec 'NERDTree'
endfunction
function! NERDTree_IsValid()
    return 1
endfunction
nmap wm :WMToggle<CR>


" minibufexpl setting
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1
let g:miniBufExplMoreThanOne=0
noremap wn :MBEbn<CR>
noremap wp :MBEbp<CR>


" YouCompleteMe setting
set completeopt=longest,menu
let g:ycm_min_num_of_chars_for_completion=2
let g:ycm_cache_omnifunc=0
let g:ycm_seed_identifiers_with_syntax=1
let g:ycm_complete_in_comments = 1
let g:ycm_complete_in_strings = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 0
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_autoclose_preview_window_after_completion=1
map <c-p>  :YcmCompleter GoToDefinition<CR>


" syntastic setting
let g:syntastic_enable_signs=1
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_remove_include_errors = 1
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = {'mode': 'passive', 'active_filetypes': [], 'passive_filetypes': []}
" Use pylint to check python files.
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_quiet_messages = { 'regex': ['trailing-newlines', 'invalid-name',
    \'too-many-lines', 'too-many-instance-attributes', 'too-many-public-methods',
    \'too-many-locals', 'too-many-branches'] }


" jedi-vim setting
let g:jedi#completions_enabled = 0


" vim-flake8 setting
nmap ck :call flake8#Flake8()<CR>
" let g:flake8_quickfix_height=5
" auto check every time when file is changed
" autocmd BufWritePost *.py call flake8#Flake8()

" tagbar setting: https://github.com/jstemmer/gotags
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
    \ }

let g:tagbar_left = 1
nmap <F8> :TagbarToggle<CR>

