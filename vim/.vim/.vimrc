"set mouse-=a

set cscopetag
set cscopeprg='gtags-cscope'
let GtagsCscope_Auto_Load=1
let CtagsCscope_Auto_Map=1
let GtagsCscope_Quiet=1
"let g:Gtags_OpenQuickfixWindow = 1
"let g:Gtags_Auto_Update = 0

nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
