execute pathogen#infect()

set backspace=indent,eol,start						" allow backspacing over everything in insert mode
set history=50										" keep 50 lines of command line history
set ruler											" show the cursor position all the time
set showcmd											" display incomplete commands
set incsearch										" do incremental searching
set backup											" keep a backup file
set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
set dir=$TEMP,$TMP,.
set backupdir=$TEMP,$TMP,.
set encoding=utf-8
set grepprg=grep\ -nH								" asume grep exists
set lines=35 columns=120
set path=.,,**
let g:netrw_liststyle=3

" Parse g++ errors better
set errorformat^=%-GIn\ file\ included\ from\ %f:%l:%c:,%-GIn\ file
       \\ included\ from\ %f:%l:%c\\,,%-GIn\ file\ included\ from\ %f
       \:%l:%c,%-GIn\ file\ included\ from\ %f:%l

"==============================================================================
" Visuals
"==============================================================================
syntax on											" enable source formatting

colorscheme desert

highlight LineNr guifg=grey40 ctermfg=darkgrey
highlight ColorColumn guibg=grey25 ctermbg=darkgrey
highlight csClass guifg=Khaki
highlight csIface guifg=Khaki 

set number											" show line numbers
set listchars=tab:▸\ ,eol:¬
set hlsearch										" highlight search pattern
set guifont=Consolas:h11:cANSI
set guicursor+=a:blinkon0							" disable cursor blink
set guioptions-=T									" no tool bar
set guioptions-=m									" no menu bar

" Default right margins at 80 and 110 characters
let &colorcolumn="80,".join(range(110, 999), ",")

" Extra guidelines for SQL files
autocmd BufEnter *.sql let &colorcolumn="37,80,".join(range(110, 999), ",")
autocmd BufLeave *.sql let &colorcolumn="80,".join(range(110, 999), ",")

" Display status bar, with file encoding 
set laststatus=2
if has("statusline")
 set statusline=%<%f\ %h%m%r%=%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"}%k\ %-14.(%l,%c%V%)\ %P
endif

"==============================================================================
" Shortcuts
"==============================================================================
let mapleader="-"

" Return to normal mode
inoremap jk <esc>

" Clear search
noremap <leader>s :nohlsearch<return>

" Display whitespace
nnoremap <leader>w :set list!<CR>

" Toggle spell-check
nnoremap <leader>c :setlocal spell! spelllang=en_gb<CR>

" Sets SQL case according to CR360 conventions
nnoremap <leader>q~ :call CapitaliseSQL()<return>

" Open Windows exporer in file directory
nnoremap <leader>x :!start explorer %:p:h<return>

map <leader>t :NERDTreeToggle<CR>

"==============================================================================
" Utilities
"==============================================================================
function! CapitaliseSQL()
 %s/\<\w\+\>/\=synIDattr(synID(line('.'),col('.'),1),'name')=~?'sql\%(keyword\|operator\|statement\)'?toupper(submatch(0)):submatch(0)/ge
endfunction
