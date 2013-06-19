""""""""""""""""""""""""""""""""""""""
" 语法着色与高亮设置
""""""""""""""""""""""""""""""""""""""

"开启语法高亮
syntax enable
syntax on

"配色
"colo ruki
"colors ruki
"colorscheme murphy
hi Comment ctermfg =darkgray

"设置高亮搜索
:set hlsearch

""""""""""""""""""""""""""""""""""""""
" 文件设置
""""""""""""""""""""""""""""""""""""""

set encoding=utf-8
"set fenc=utf-8
"set fileencodings=utf-8,gbk,cp936,latin-1
set fileencoding=chinese
set fileencodings=ucs-bom,utf-8,chinese
set ambiwidth=double
"语言设置
set langmenu=zh_CN.UTF-8
set helplang=cn

"ADDed
set cursorline         " 突出显示当前行
"缩进相关
":%retab!
set softtabstop=4
set shiftwidth=4        " 设定 << 和 >> 命令移动时的宽度为 4 
set tabstop=4           " 设定 tab 长度为 4 
set smartindent         " 开启新行时使用智能自动缩进 
set laststatus=2        " 显示状态栏 (默认值为 1, 无法显示状态栏) 
" 历史记录数
set history=1000
" 不要用空格代替制表符     
"set noexpandtab
" 用空格代替制表符     
set expandtab
" 记住上次打开的位置
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

" 设置在状态行显示的信息 
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&encoding}\ %c:%l/%L%)\
"set mouse=a
""关闭备份,不产生swp文件
"set nobackup
"set nowb
"退出输入模式自动保存
au InsertLeave *.* write

let php_folding=0

" php
" 高亮字符串里的SQL语句
let php_sql_query=1
" " 高亮字符串里的HTML
let php_htmlInStrings=1
" " 禁用php的短标记
let php_noShortTags=1
" " 启用代码折叠（用于类和函数、自动）
let php_folding=0
"added over
"
"检测文件的类型
filetype on
:let mapleader=","

"默认无备份
:set nobackup
:set nowritebackup

""""""""""""""""""""""""""""""""""""""
" 鼠标设置
""""""""""""""""""""""""""""""""""""""

"鼠标支持
"if has('mouse')
":set mouse=a
"endif

"使鼠标用起来象微软 Windows,似乎正好解决 连续多行缩进问题、退格问题
":behave mswin

""""""""""""""""""""""""""""""""""""""
" 编辑器设置
""""""""""""""""""""""""""""""""""""""

"显示行号
set nu

"Tab 宽度
":set ts=4

"自动缩进
":set sw=4

"C/C++ 风格的自动缩进
:set cin
"设定 C/C++ 风格自动缩进的选项
:set cino=:0g0t0(sus

"打开普通文件类型的自动缩进
:set ai

"在编辑过程中，在右下角显示光标位置的状态行
:set ruler

"显示匹配括号
:set showmatch

"在insert模式下能用删除键进行删除
:set backspace=indent,eol,start

"代码折叠, 命令 za
:set foldmethod=syntax
:set foldlevel=100  "启动vim时不要自动折叠代码

"设置字体 
":set guifont=courier/ 9

"当右键单击窗口的时候， 弹出快捷菜单
:set mousemodel=popup

"自动换行
if (has("gui_running")) "图形界面下的设置

"指定不折行。如果一行太长，超过屏幕宽度，则向右边延伸到屏幕外面
:set nowrap
"添加水平滚动条。如果你指定了不折行，那为窗口添加一个水平滚动条就非常有必要了
:set guioptions+=b

else "字符界面下的设置
   set wrap
endif

""""""""""""""""""""""""""""""""""""""
" 快捷键设置
""""""""""""""""""""""""""""""""""""""
"<F1>菜单栏与工具栏隐藏与显示动态切换
set guioptions-=m
set guioptions-=T
"map <silent> <F1> :if &guioptions =~# 'T' <Bar>
"/set guioptions-=T <Bar>
"/set guioptions-=m <bar>
"/else <Bar>
"/set guioptions+=T <Bar>
"/set guioptions+=m <Bar>
"/endif<CR>

"<F2>code_complete.vim插件：函数自动完成
if !exists("g:completekey")
   let g:completekey = "<F2>"   "hotkey
endif

"<F3><F4>大小写转换 
map <F3> gu
map <F4> gU

"当前目录生成tags语法文件，用于自动完成，函数提示：code_complete.vim OmniCppComplete.vim ...
"map <F5> :!ctags -R --c-kinds=+p --fields=+S . <CR>
map <F5> :!ctags -R --c-kinds=+p --c++-kinds=+p --fields=+iaS --extra=+q . <CR>

"函数和变量列表
map <F6> :TlistToggle<CR>

"文件浏览器 
map <F7> :WMToggle<CR> 
let g:winManagerWindowLayout = "FileExplorer"

"文件树状列表
map <F8> :NERDTreeToggle<CR>
"autocmd VimEnter * NERDTree
"let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=2

"映射复制、粘贴、剪贴ctrl+c ctrl+v ctrl+x
:map <C-V> "+pa<Esc>
:map! <C-V> <Esc>"+pa
:map <C-C> "+y
:map <C-X> "+x
:map <C-L> :VCSCommit [debug]<CR>

" 映射全选 ctrl+a
:map <C-A> ggVG
:map! <C-A> <Esc>ggVG

" 多行缩进
:map <Tab> >
:map <S-Tab> <
:map <c-]> g<c-]>

""""""""""""""""""""""""""""""""""""""
" 插件设置
""""""""""""""""""""""""""""""""""""""

"开启OmniCppComplete.vim
set nocp
filetype plugin on

"2Html插件，启用XHtml css
:let html_number_lines=1
:let html_use_css=1
:let use_xhtml=1

"fencview.vim 插件设置
let g:fencview_autodetect = 1  "打开文件时自动识别编码
let g:fencview_checklines = 10 "检查前后10行来判断编码

"autocomplpop.vim & supertab.vim 插件设置
let g:AutoComplPop_IgnoreCaseOption=1
"忽略大小写
set ignorecase

""""""""""""""""""""""""""""""""""""""
" 其他设置
""""""""""""""""""""""""""""""""""""""
source ~/.vim/plugin/php-doc.vim 
inoremap <C-P> <ESC>:call PhpDocSingle(<CR>i 
nnoremap <C-P> :call PhpDocSingle(<CR> 
vnoremap <C-P> :call PhpDocRange(<CR> )))

"去掉讨厌的有关vi一致性模式，避免以前版本的一些bug和局限
:set nocompatible

" ======= 引号 && 括号自动匹配 ======= "
":inoremap ( ()<ESC>i
":inoremap ) <c-r>=ClosePair(')')<CR>
":inoremap { {}<ESC>i
":inoremap } <c-r>=ClosePair('}')<CR>
":inoremap [ []<ESC>i
":inoremap ] <c-r>=ClosePair(']')<CR>
":inoremap " ""<ESC>i
":inoremap ' ''<ESC>i
":inoremap ` ``<ESC>i
function ClosePair(char)
	if getline('.')[col('.') - 1] == a:char
		return "\<Right>"
	else
		return a:char
	endif
endf

" snipMate 配置
" 代码自动填充
" 配置在~/.vim/snippets
filetype plugin on
au BufRead,BufNewFile *.php set filetype=php.html
