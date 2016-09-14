execute pathogen#infect()
Helptags

"==============================================================================
" Editor
"==============================================================================
filetype plugin indent on

set dir=$TEMP//,$TMP//,.
set backupdir=$TEMP//,$TMP//,.
set path=.,,**

set autoindent
set backspace=indent,eol,start						" allow backspacing over everything in insert mode
set history=50										" keep 50 lines of command line history
set ruler											" show the cursor position all the time
set incsearch										" do incremental searching
set backup											" keep a backup file
set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
set encoding=utf-8
set grepprg=grep\ -nH								" asume grep exists
set scrolloff=5
set gdefault										" substitute has /g by default
set nofoldenable									" disable folding

" Parse g++ errors better
set errorformat^=%-GIn\ file\ included\ from\ %f:%l:%c:,%-GIn\ file
       \\ included\ from\ %f:%l:%c\\,,%-GIn\ file\ included\ from\ %f
       \:%l:%c,%-GIn\ file\ included\ from\ %f:%l
	
let &colorcolumn="100"
autocmd BufEnter *.sql let &colorcolumn="37,100"
autocmd BufLeave *.sql let &colorcolumn="100"

"==============================================================================
" Visuals
"==============================================================================
syntax on											" enable source formatting

let g:gruvbox_italic = 0							" italics are sometimes glitchy
colorscheme gruvbox

set number											" show line numbers
set relativenumber									" line numbers are relative 
set cursorline										" highlight cursor line
set hlsearch										" highlight search pattern
set laststatus=2									" show status bar
set noshowmode										" don't display mode (redundant with airline)
set showcmd											" display incomplete commands

if has('gui_running')
	set lines=35 columns=120

	set listchars=tab:→\ ,eol:↵,trail:∙
	set fillchars=vert:┆

	" Font
	set guifont=DejaVuSansMonoForPowerline_NF:h10.5:cANSI,Consolas:h11:cANSI

	" Doesn't seem to be a way of detecting if the fallback font is being
	" used, and try-catch wierdly doesn't seem to work in the vimrc, just have
	" to asume we have a powerline font for now
	let has_powerline_font = 1

	" GUI options
	set guicursor+=a:blinkon0						" disable cursor blink
	set guioptions-=T								" no tool bar
	set guioptions-=m								" no menu bar
	set guioptions-=r								" no right-hand scroll bar
	set guioptions-=L	  							" no left-hand scroll bar
	set guioptions+=c	  							" no popups

	" Default right margins at 80 and 100 characters
	"let &colorcolumn="80,".join(range(100, 999), ",")

	" Extra guidelines for SQL files
	" autocmd BufEnter *.sql let &colorcolumn="37,80,".join(range(100, 999), ",")
	" autocmd BufLeave *.sql let &colorcolumn="80,".join(range(100, 999), ",")
else
	set listchars=tab:>\ ,eol:$
	set fillchars=vert:|

	let has_powerline_font = 0
endif

"==============================================================================
" Plugins
"==============================================================================

" wimproved
autocmd GUIEnter * silent! WToggleClean

" startify
let g:startify_bookmarks = [ '\cvs', '\cvs\csr\db', '~\vimfiles\vimrc', '~\documents\repos' ]
let g:startify_custom_header = []
let g:startify_relative_path = 1
let g:startify_change_to_dir = 1

" omnisharp/syntastic
let g:syntastic_cs_checkers = ['syntax', 'semantic'] ", 'issues']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_cpp_compiler_options = '-std=c++14' 

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

" devicons
let g:webdevicons_enable = has_powerline_font
let g:WebDevIconsNerdTreeAfterGlyphPadding = ''

" airline
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline_symbols.maxlinenr = ''
let g:airline_powerline_fonts = has_powerline_font
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
nnoremap <leader>w :set list!<return>

" Toggle spell-check
nnoremap <leader>k :setlocal spell! spelllang=en_gb<return>

" Sets SQL case according to CR360 conventions
nnoremap <leader>q~ :%call CapitaliseSQL()<return>
vnoremap <leader>q~ :call CapitaliseSQL()<return>

" Open Windows exporer in file directory
nnoremap <leader>x :!start explorer %:p:h<return>

map <leader>t :NERDTreeToggle<return>

map <F11> :WToggleFullscreen<return>

"==============================================================================
" Utilities
"==============================================================================
function! CapitaliseSQL() 
 .s/\<\w\+\>/\=synIDattr(synID(line('.'),col('.'),1),'name')=~?'sql\%(keyword\|operator\|statement\)'?toupper(submatch(0)):submatch(0)/ge
endfunction
