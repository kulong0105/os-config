set nu
set cindent
set bg=dark
" colorscheme pablo
colorscheme elflord
set tabstop=4
set shiftwidth=4
"set expandtab
set autoindent
set smartindent
:source /home/renyl/.vim/abbreviation.vim
autocmd FileType make setlocal noexpandtab
autocmd Filetype ruby setlocal ts=2 sw=2 expandtab
autocmd FileType python set tabstop=4|set shiftwidth=4|set expandtab

"set fileencodings=cp936,utf-8,ucs-bom,gb18030,gbk,gb2312
set encoding=utf-8

set mouse=

map <F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
nmap su :w !sudo tee %<CR>

let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Ctags_Cmd="/usr/bin/ctags"


nmap hm :GtagsCursor<CR>


set nocp
filetype plugin on

let g:SuperTabDefaultCompletionType="context"

let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1
let g:miniBufExplMoreThanOne=0

let g:NERDTree_title="[NERDTree]"
let g:winManagerWindowLayout="NERDTree|TagList"

function! NERDTree_Start()

        exec 'NERDTree'

endfunction

function! NERDTree_IsValid()

        return 1
endfunction

nmap wm :WMToggle<CR>


set cscopetag
set cscopeprg='gtags-cscope'
let GtagsCscope_Auto_Load=1
let CtagsCscope_Auto_Map=1
let GtagsCscope_Quiet=1
"let g:Gtags_OpenQuickfixWindow = 1
"let g:Gtags_Auto_Update = 0

nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
