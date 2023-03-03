" ~/.vimrc
set tabstop=3
set shiftwidth=3
set incsearch
set autoindent
set smartindent
set hlsearch
syntax on
set background=dark
"set background=light
"
" http://vim.wikia.com/wiki/Show_current_function_name_in_C_programs
fun! ShowFuncName()
        let lnum = line(".")
        let col = col(".")
        echohl ModeMsg
        echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
        echohl None
        call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun
map f :call ShowFuncName() <CR>
"
"set softtabstop=0 noexpandtab
set tabstop=2 softtabstop=2 expandtab shiftwidth=2 smarttab


