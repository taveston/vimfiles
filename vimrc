execute pathogen#infect()
Helptags

"==============================================================================
" Editor
"==============================================================================
filetype plugin on
set autoindent
set backspace=indent,eol,start						" allow backspacing over everything in insert mode
set history=50										" keep 50 lines of command line history
set ruler											" show the cursor position all the time
set showcmd											" display incomplete commands
set incsearch										" do incremental searching
set backup											" keep a backup file
set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
set dir=$TEMP//,$TMP//,.
set backupdir=$TEMP//,$TMP//,.
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

"---
" desert
"colorscheme desert
"highlight LineNr guifg=grey40 ctermfg=darkgrey
"highlight ColorColumn guibg=grey25 ctermbg=darkgrey
"highlight csClass guifg=Khaki
"highlight csIface guifg=Khaki 
"highlight SignColumn guibg=gray25
"---
" codeschool
"colorscheme codeschool
"let g:airline_theme='base16_codeschool'
"highlight SignColumn guibg=#2a343a
"highlight SignifySignAdd guifg=#43820d guibg=#2a343a gui=bold
"highlight SignifySignDelete guifg=#880708 guibg=#2a343a
"highlight SignifySignChange guifg=#3c98d9 guibg=#2a343a
"---
" solarized light
"set background=light
"colorscheme solarized
"---
" solarized dark
"set background=dark
"colorscheme solarized
"highlight SignColumn guibg=#073642
"---
" base16-ateliersavanna
"set background=dark
"colorscheme base16-ateliersavanna
"---
" gruvbox 
let g:gruvbox_vert_split = 'fg4'					" get rid of pipe chars
colorscheme gruvbox
"---

set number											" show line numbers
set listchars=tab:▸\ ,eol:¬
set hlsearch										" highlight search pattern
"set guifont=Consolas:h11:cANSI
set guifont=Hack:h10.2:cANSI
set guicursor+=a:blinkon0							" disable cursor blink
set guioptions-=T									" no tool bar
set guioptions-=m									" no menu bar
set guioptions-=r									" no right-hand scroll bar
set guioptions-=L	  								" no left-hand scroll bar
set guioptions+=c	  								" no popups

" Default right margins at 80 and 110 characters
let &colorcolumn="80,".join(range(110, 999), ",")

" Extra guidelines for SQL files
autocmd BufEnter *.sql let &colorcolumn="37,80,".join(range(110, 999), ",")
autocmd BufLeave *.sql let &colorcolumn="80,".join(range(110, 999), ",")

" Status bar
set laststatus=2

"==============================================================================
" Plugins
"==============================================================================
" omnisharp/syntastic
let g:syntastic_cs_checkers = ['syntax', 'semantic'] ", 'issues']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

autocmd FileType cs setlocal omnifunc=OmniSharp#Complete
autocmd BufEnter,TextChanged,InsertLeave *.cs SyntasticCheck

" Automatically add new cs files to the nearest project on save
autocmd BufWritePost *.cs call OmniSharp#AddToProject()

" show type information automatically when the cursor stops moving
autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()
autocmd FileType cs nnoremap gd :OmniSharpGotoDefinition<cr>

" signify
let g:signify_vcs_list = [ 'git', 'svn' ]
let g:signify_sign_add = '+'
let g:signify_sign_delete = '-'
let g:signify_sign_change = '~'
" conque term
let g:ConqueTerm_CloseOnEnd = 1
" airline
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline_symbols.maxlinenr = ''
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#tab_nr_type = 2 " splits and tab number
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#hunks#hunk_symbols = ['+', '~', '-']
let g:airline#extensions#branch#use_vcscommand = 1

let g:airline#extensions#branch#format = 'FormatBranchName'
function! FormatBranchName(name)
	let name = a:name

	" When using the vcscommand svn plugin the name is the revision number, which is kind of useless. 
	" Instead, try to parse the branch name out of svn info. This requires some assumptions about the 
	" structure of the repository.
	if exists('b:VCSCommandVCSType') && b:VCSCommandVCSType == 'SVN'
		let fileName = bufname(VCSCommandGetOriginalBuffer(bufnr('%')))
		let infoText = system('svn info --non-interactive -- "' . fileName . '"')
		let match = matchlist(infoText, '\(\n\|^\)Relative URL: \^\/\(\(\(project\|branch\(es\)?\|tags?\)\/[^/$]*\|trunk\|master\)\)')
		let name = get(match, 2, name)
	endif

	return name 
endfunction

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
nnoremap <leader>k :setlocal spell! spelllang=en_gb<CR>

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
