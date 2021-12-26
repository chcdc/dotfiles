set mouse=a
set termguicolors
set number
set showcmd
set tabstop=4
set shiftwidth=4
set encoding=UTF-8
set smartindent noexpandtab tabstop=4 shiftwidth=4 textwidth=80
set nocompatible
set background=dark
set ttimeoutlen=0
set foldmethod=marker ignorecase smartcase
set listchars=tab:⁞\ ,trail:· list
let mapleader="\<Tab>"

filetype plugin on
syntax on

" {{{ Plugins
call plug#begin('~/.config/nvim/plugged')
    "{{{ essentials
	Plug 'tveskag/nvim-blame-line'		" Git info
	Plug 'wakatime/vim-wakatime'		" Wakatime
	Plug 'neomake/neomake'				" ShellCheck
	Plug 'junegunn/fzf.vim'				" fuzzy finder for lines, files, commits, etc.
	Plug 'godlygeek/tabular' 			" Vim script for text filtering and alignment
	Plug 'thaerkh/vim-indentguides'		" Identacoes

	" Wilder Menu
	if has('nvim')
	  Plug 'gelguy/wilder.nvim', { 'do': ':UpdateRemotePlugins' }
	else
	  Plug 'gelguy/wilder.nvim'

	  " To use Python remote plugin features in Vim, can be skipped
	  Plug 'roxma/nvim-yarp'
	  Plug 'roxma/vim-hug-neovim-rpc'
	endif

	"}}}
	" {{{ the nerd (file) tree
	Plug 'preservim/nerdtree'
	Plug 'ryanoasis/vim-devicons'
	let g:NERDTreeDirArrowExpandable = '+'
	let g:NERDTreeDirArrowCollapsible = '-'
	let g:NERDTreeMinimalUI = 1
	let NERDTreeIgnore = ['\.pyc$', '^__pycache__$', '^.terragrunt-cache$', '^.terraform$']
	" }}}
" {{{ themes and additional highlighting
	Plug 'ryanoasis/vim-devicons' 			" Icons
	Plug 'morhetz/gruvbox' 					" Retro groove color scheme for Vim 
	Plug 'vim-airline/vim-airline' 			" Status Line
	Plug 'vim-airline/vim-airline-themes' 	" Status Line
	Plug 'keith/tmux.vim'               	" .tmux.conf syntax highlighting
	Plug 'hashivim/vim-terraform'          	" terraform related convenience
" }}}
call plug#end()
" }}}
" {{{ some Configs and functions
	colorscheme gruvbox
	" ShellCheck
	call neomake#configure#automake('nrwi', 500)
	" Default keys wilder
	call wilder#setup({
			\ 'modes': [':', '/', '?'],
			\ 'next_key': '<Tab>',
			\ 'previous_key': '<S-Tab>',
			\ 'accept_key': '<Down>',
			\ 'reject_key': '<Up>',
			\ })

	"{{{ IndentGuides
	let g:indentguides_spacechar = '▏'
	let g:indentguides_tabchar = '▏'
	"}}}
"}}}

