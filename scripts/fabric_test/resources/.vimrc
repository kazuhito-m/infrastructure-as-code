set nocompatible
filetype off            " for NeoBundle
 
if has('vim_starting')
        set rtp+=$HOME/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle'))
NeoBundleFetch 'Shougo/neobundle.vim'
 
" ここから NeoBundle でプラグインを設定します

" NeoBundle で管理するプラグインを追加します。
NeoBundle 'Shougo/neocomplcache.git'
NeoBundle 'Shougo/unite.vim.git'

 
" vim-markdown
NeoBundle 'Shougo/vimfiler'
NeoBundle 'godlygeek/tabular.git'
NeoBundle 'plasticboy/vim-markdown.git'
 
call neobundle#end()

filetype plugin indent on       " restore filetype

" vim-markdown settings
set number
set ai

