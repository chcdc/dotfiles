syntax on

"set rtp+=/opt/homebrew/opt/fzf
"" Encoding
set encoding=utf-8
set fileencodings=utf-8

"" Fix backspace indent
set backspace=indent,eol,start

"" Tabs. May be overridden by autocmd rules
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab

set mouse=a
set wildmenu
set wildmode=full
set termguicolors
set number
set showcmd
set smartindent noexpandtab tabstop=4 shiftwidth=4 textwidth=80
set nocompatible
set background=dark
set ttimeoutlen=0
set foldmethod=marker ignorecase smartcase
set listchars=tab:⁞\ ,trail:· list
let mapleader="\<Tab>"
set guicursor=n-v-c-i:block
filetype plugin on

" {{{ Plugins
" {{{ install vim-plug if it's not present
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
        silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dir https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"}}}

call plug#begin('~/.config/nvim/plugged')
    "{{{ essentials
                Plug 'plytophogy/vim-virtualenv'
                Plug 'PieterjanMontens/vim-pipenv'
        Plug 'w0rp/ale', { 'do': 'pip install flake8 isort yapf' } "Python
                Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' } "Golang
                Plug 'keith/tmux.vim'           " .tmux.conf syntax highlighting
                Plug 'neomake/neomake'                  " ShellCheck
                Plug 'junegunn/fzf.vim'                 " fuzzy finder for lines, files, commits, etc.
                Plug 'godlygeek/tabular'                " Vim script for text filtering and alignment
                Plug 'davidhalter/jedi-vim'             "jedi autocompletion library for VIM.
                Plug 'wakatime/vim-wakatime'    " Wakatime
                Plug 'chrisbra/changesPlugin'   "A Vim plugin for displaying changes in a buffer
                Plug 'tveskag/nvim-blame-line'  " Git info
                Plug 'tzachar/cmp-tabnine', {'do': './install.sh' }  "Tabnine
                Plug 'm4xshen/smartcolumn.nvim' "A Neovim plugin hiding your colorcolumn when unneeded.
                Plug 'nvim-lua/completion-nvim'
                Plug 'lukas-reineke/indent-blankline.nvim'      "Indent guides for Neovim
        "}}}
        "{{{ CMP Plugin
                Plug 'neovim/nvim-lspconfig'
                Plug 'hrsh7th/cmp-nvim-lsp'
                Plug 'hrsh7th/cmp-buffer'
                Plug 'hrsh7th/cmp-path'
                Plug 'hrsh7th/cmp-cmdline'
                Plug 'hrsh7th/nvim-cmp'
        "}}}
        "{{{ Terraform
                Plug 'hashivim/vim-terraform'   " terraform related convenience
                Plug 'juliosueiras/vim-terraform-completion'
        "}}}
        " {{{ the nerd (file) tree
                Plug 'preservim/nerdtree'
                Plug 'ryanoasis/vim-devicons'
                let g:NERDTreeDirArrowExpandable = '+'
                let g:NERDTreeDirArrowCollapsible = '-'
                let g:NERDTreeMinimalUI = 1
                let g:NERDTreeChDirMode=2
                let NERDTreeIgnore = ['\.pyc$', '^__pycache__$', '^.terragrunt-cache$', '^.terraform$']
                nnoremap <silent> <F2> :NERDTreeFind<CR>
                nnoremap <silent> <F3> :NERDTreeToggle<CR>
        " }}}
        " {{{ themes and additional highlighting
            Plug 'jacoborus/tender.vim'
                Plug 'rmehri01/onenord.nvim', { 'branch': 'main' } "Onenord
                Plug 'norcalli/nvim-colorizer.lua'
                Plug 'ryanoasis/vim-devicons'   " Icons
                " Plug 'navarasu/onedark.nvim'  " OneDark
                Plug 'vim-airline/vim-airline'                  " Status Line
                Plug 'vim-airline/vim-airline-themes'   " Status Line
        " }}}
        " {{{ git
                Plug 'mhinz/vim-signify'               " diff showing in real time

                        highlight SignifySignAdd ctermfg=green ctermbg=none cterm=none
                        highlight SignifySignDelete ctermfg=red ctermbg=none cterm=none
                        highlight SignifySignChange ctermfg=yellow ctermbg=none cterm=none

                        autocmd User SignifyHunk call s:show_current_hunk()

                        function! s:show_current_hunk() abort
                                let h = sy#util#get_hunk_stats()
                                if !empty(h)
                                        echo printf('[Hunk %d/%d]', h.current_hunk, h.total_hunks)
                                endif
                        endfunction

        " }}}
        " {{{ Snippets
        " }}}
call plug#end()
"}}}
" {{{ Some Configs and functions
        "{{{ Terraform Configs
                let g:terraform_align = 1
                let g:terraform_fmt_on_save = 1
                " Minimal Configuration

                " Syntastic Config
                set statusline+=%#warningmsg#
                set statusline+=%{SyntasticStatuslineFlag()}
                set statusline+=%*

                let g:syntastic_always_populate_loc_list = 1
                let g:syntastic_auto_loc_list = 1
                let g:syntastic_check_on_open = 1
                let g:syntastic_check_on_wq = 0

                " (Optional)Remove Info(Preview) window
                set completeopt-=preview

                " (Optional)Hide Info(Preview) window after completions
                autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
                autocmd InsertLeave * if pumvisible() == 0|pclose|endif

                " (Optional) Enable terraform plan to be include in filter
                let g:syntastic_terraform_tffilter_plan = 1

                " (Optional) Default: 0, enable(1)/disable(0) plugin's keymapping
                let g:terraform_completion_keys = 1

                " (Optional) Default: 1, enable(1)/disable(0) terraform module registry completion
                let g:terraform_registry_module_completion = 0
        "}}}
        " }}}
        " {{{ Themes Configs
        colorscheme tender
        " ShellCheck
        call neomake#configure#automake('nrwi', 500)
        "}}}
        "{{{ Blame Line configs
        nnoremap <silent> <leader>b :ToggleBlameLine<CR>
        autocmd BufEnter * EnableBlameLine
        let g:blameLineGitFormat = '%an - %ar - %s'
        "}}}
        "{{{ Jedi Configs
        let g:jedi#auto_initialization = 1
        let g:jedi#use_tabs_not_buffers = 1
        let g:jedi#popup_on_dot = 0
        let g:jedi#goto_assignments_command = "<leader>g"
        let g:jedi#goto_definitions_command = "<leader>d"
        let g:jedi#documentation_command = "K"
        let g:jedi#usages_command = "<leader>n"
        let g:jedi#rename_command = "<leader>r"
        let g:jedi#show_call_signatures = "0"
        let g:jedi#completions_command = "<C-Space>"
        let g:jedi#smart_auto_mappings = 0
        let g:jedi#completions_enabled = 0
        "}}}

"}}}


set statusline=
set statusline+=%#PmenuSel#
"set statusline+=%{b:gitbranch}
set statusline+=%#FileName#
set statusline+=\ %<%f\ %m\ %=
set statusline+=%#PmenuSel#
set statusline+=\ %y\ %6(L%l%)\ %-6(C%v%)\ %P\ %{''}

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#switch_buffers_and_tabs = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline_theme='luna'

" }}}
"{{{ LUA config
lua <<EOF
local tabnine = require('cmp_tabnine.config')
require("smartcolumn").setup()
local config = {
        colorcolumn = 80,
    disabled_filetypes = { "help", "text", "markdown" },
    custom_colorcolumn = {},
    limit_to_window = false,
}

tabnine:setup({
        max_lines = 1000;
        max_num_results = 20;
        sort = true;
        run_on_every_keystroke = true;
        snippet_placeholder = '..';
        show_prediction_strength = false;
})

vim.opt.termguicolors = true
vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]

vim.opt.list = true
vim.opt.listchars:append("eol:↴")

require("indent_blankline").setup {
        space_char_blankline = " ",
    char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
    },
    space_char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
    },
    show_trailing_blankline_indent = false,
}
EOF
"}}}
