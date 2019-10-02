"let g:pathogen_disabled = [ 'vim-signify', 'vim-airline' ]
let g:pathogen_disabled = [ 'omnisharp', 'devicons', 'vim-fontzoom' ]
call pathogen#infect()
Helptags

"==============================================================================
" Editor
"==============================================================================
filetype plugin indent on

set dir=$TEMP//,$TMP//,.
set backupdir=$TEMP//,$TMP//,.
set path=.,,**

set autoindent
set backspace=indent,eol,start						" allow backspacing over everything in insert 
													" mode
set history=50										" keep 50 lines of command line history
set ruler											" show the cursor position all the time
set incsearch										" do incremental searching
set backup											" keep a backup file
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
set encoding=utf-8
set grepprg=grep\ -nH								" asume grep exists
set scrolloff=5
set gdefault										" substitute has /g by default
set nofoldenable									" disable folding
set display+=lastline
set formatoptions+=j								" Remove comment leader when joining lines

set spellsuggest=best,5								" show best 5 spelling suggestions only

set autoread
set autowrite

" Parse g++ errors better
set errorformat^=%-GIn\ file\ included\ from\ %f:%l:%c:,%-GIn\ file
       \\ included\ from\ %f:%l:%c\\,,%-GIn\ file\ included\ from\ %f
       \:%l:%c,%-GIn\ file\ included\ from\ %f:%l

set textwidth=100
let &colorcolumn="100"
autocmd BufEnter *.sql let &colorcolumn="37,101"
autocmd BufLeave *.sql let &colorcolumn="101"
autocmd BufNewFile,BufRead *.ashx set filetype=cs

autocmd BufEnter *.sql setlocal makeprg=powershell\ c:\cvs\staff\toma\tools\buildpkg.ps1\ %
autocmd BufEnter *.sql setlocal errorformat=%-PFile:\ %f,%E%l/%c\ %#%m,%Z***%#,%+C%.%#,%-G%.%#

" Auto show/hide quickfix window
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

let g:sql_type_default = 'plsql'

"==============================================================================
" Visuals
"==============================================================================
syntax on											" enable source formatting

let g:gruvbox_italic = 0							" italics cause glitches where the background 
let g:gruvbox_bold = 1								" colour changes (ie. at colour column)

colorscheme gruvbox
set background=dark

set number											" show line numbers
set relativenumber									" line numbers are relative 
set cursorline										" highlight cursor line
set hlsearch										" highlight search pattern
set laststatus=2									" show status bar
set noshowmode										" don't display mode (redundant with airline)
set showcmd											" display incomplete commands

if has('gui_running')
	set lines=35 columns=120

	set listchars=tab:→\ ,eol:$,trail:∙,nbsp:_

	" works from the console but not in vimrc
	set fillchars=vert:\┃

	" Font
	if has("gui_win32")
		set guifont=DejaVuSansMonoForPowerline_NF:h10:cANSI
		"set guifont=Powerline_Consolas:h11:cANSI
		"set guifont=DejaVuSansMonoForPowerline_NF:h10.5:cANSI
		"set guifont=Consolas:h11:cANSk
		"set guifont=mononoki_NF:h11:cANSI

		" doesn't work well with :WToggleFullscreen
		"set rop=type:directx

		autocmd GUIEnter * WSetAlpha 251

		" Go fullscreen
		" autocmd GUIEnter * WToggleFullscreen

		" Maximise
		autocmd GUIEnter * simalt ~x
	else
		set guifont=DejaVuSansMono\ Nerd\ Font\ Mono\ 10
	end

	" Doesn't seem to be a way of detecting if the fallback font is being
	" used, and try-catch wierdly doesn't seem to work in the vimrc, just have
	" to asume we have a powerline font
	let has_powerline_font = 1

	" GUI options
	set guicursor+=a:blinkon0						" disable cursor blink
	set guioptions-=T								" no tool bar
	set guioptions-=m								" no menu bar
	set guioptions-=r								" no right-hand scroll bar
	set guioptions-=L	  							" no left-hand scroll bar
	set guioptions+=c	  							" no popups

	" Extra guidelines for SQL files
	" autocmd BufEnter *.sql let &colorcolumn="37,80,".join(range(100, 999), ",")
	" autocmd BufLeave *.sql let &colorcolumn="80,".join(range(100, 999), ",")
else
	set listchars=tab:>\ ,eol:$
	set fillchars=vert:\|

	let has_powerline_font = 0
endif

"==============================================================================
" Plugins
"==============================================================================
" wimproved
autocmd GUIEnter * silent! WToggleClean

" startify
let g:startify_bookmarks = [ 'c:\oracle12cdb\product\12.2.0\db1\network\admin\tnsnames.ora', 'c:\windows\System32\drivers\etc\hosts' ]
let g:startify_custom_header = []
let g:startify_relative_path = 1
let g:startify_change_to_dir = 1

" omnisharp/syntastic
let g:syntastic_cs_checkers = ['syntax', 'semantic'] ", 'issues']

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 2
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

let g:syntastic_cpp_checkers = ['clang_check']
let g:syntastic_clang_tidy_config_file = '.syntastic_clang_check_config'

let g:syntastic_typescript_checkers = ['tslint']
let g:syntastic_typescript_tslint_args = '-c c:\cvs\fproot\node\config\tslint.dev.json'

let g:ycm_always_populate_location_list = 1
let g:ycm_open_loclist_on_ycm_diags = 1
let g:ycm_confirm_extra_conf = 0

"let g:syntastic_cpp_clang_check_args = '-extra-arg="-I."'
"let g:syntastic_cpp_compiler_options = '-std=c++14'

"autocmd FileType cs setlocal omnifunc=OmniSharp#Complete
"autocmd BufEnter,TextChanged,InsertLeave *.cs SyntasticCheck

" Automatically add new cs files to the nearest project on save
"autocmd BufWritePost *.cs call OmniSharp#AddToProject()

" show type information automatically when the cursor stops moving
"autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()
"autocmd FileType cs nnoremap gd :OmniSharpGotoDefinition<cr>

" signify
let g:signify_vcs_list = [ 'svn', 'git' ]
let g:signify_sign_add = '+'
let g:signify_sign_delete = '-'
let g:signify_sign_change = '~'

" conque term
let g:ConqueTerm_CloseOnEnd = 1

" devicons
"let g:webdevicons_enable = has_powerline_font
"let g:WebDevIconsNerdTreeAfterGlyphPadding = ''

let NERDTreeQuitOnOpen=1
let NERDTreeWinPos="right"
let NERDTreeAutoDeleteBuffer=1

" airline
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline_symbols.maxlinenr = ''
let g:airline_powerline_fonts = has_powerline_font

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_buffers = 0

let g:airline#extensions#whitespace#enabled = 0

let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#hunks#hunk_symbols = ['+', '~', '-']

"let g:airline#extensions#branch#use_vcscommand = 1
let g:airline#extensions#branch#format = 'FormatBranchName'

if &diff
	let g:airline#extensions#branch#enabled = 0
    let g:signify_disable_by_default = 0
	set list!
else
	autocmd BufWritePre	*.cs retab!
endif

" nerd tree
let NERDTreeQuitOnOpen=3
let NERDTreeAutoDeleteBuffer=1

" unicode.vim
nmap ga <Plug>(UnicodeGA)

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
"nnoremap <leader>x :!start explorer %:p:h<return>

map <leader>r :syn sync fromstart<return>

map <leader>tt :NERDTreeToggle<return>
map <leader>tf :NERDTreeFind<return>

if has("gui_win32")
	map <F11> :WToggleFullscreen<return>
endif

map <leader>x :!xmllint --format --output "%" "%"<return>

" Startify
nmap <leader>ss :SSave
nmap <leader>sc :SClose

" Fswitch
" Switch to the file and load it into the current window
nmap <silent> <Leader>of :FSHere<cr>
" Switch to the file and load it into the window on the right
nmap <silent> <Leader>ol :FSRight<cr>
" Switch to the file and load it into a new window split on the right
nmap <silent> <Leader>oL :FSSplitRight<cr>
" Switch to the file and load it into the window on the left
nmap <silent> <Leader>oh :FSLeft<cr>
" Switch to the file and load it into a new window split on the left
nmap <silent> <Leader>oH :FSSplitLeft<cr>
" Switch to the file and load it into the window above
nmap <silent> <Leader>ok :FSAbove<cr>
" Switch to the file and load it into a new window split above
nmap <silent> <Leader>oK :FSSplitAbove<cr>
" Switch to the file and load it into the window below
nmap <silent> <Leader>oj :FSBelow<cr>
" Switch to the file and load it into a new window split below
nmap <silent> <Leader>oJ :FSSplitBelow<cr>

" YCM
" F12, -gt = GoTo
nmap <leader>gt :YcmCompleter GoTo<cr>
nmap <F12> :YcmCompleter GoTo<cr>

nmap <leader>gf :YcmCompleter GoToDefinition<cr>
nmap <leader>gc :YcmCompleter GoToDeclaration<cr>
nmap <leader>gd :YcmCompleter GetDoc<cr>
nmap <leader>gx :YcmCompleter FixIt<cr>

" For typescript GoTo = GoToDefinition
autocmd FileType typescript nmap <buffer> <leader>gt :YcmCompleter GoToDefinition<cr>
autocmd FileType typescript nmap <buffer> <F12> :YcmCompleter GoToDefinition<cr>

" Paste and yank
nmap <silent> <Leader>p p`[v`]y
vmap <silent> <Leader>p p`[v`]y

"==============================================================================
" Utilities
"==============================================================================
function! CapitaliseSQL()
	.s/\<\w\+\>/\=synIDattr(synID(line('.'),col('.'),1),'name')=~?'sql\%(keyword\|operator\|statement\)'?toupper(submatch(0)):submatch(0)/ge
endfunction

function! GetSvnBranchName()
	function! GetSvnBranchNameJobFinished(channel)
		let infoText = ""
		while ch_status(a:channel, {'part': 'out'}) == 'buffered'
			let infoText = infoText . ch_read(a:channel)
		endwhile

		" Try to parse the branch name out of svn info. This requires some assumptions about the
		" structure of the repository.
		let pattern = '\(\n\|^\)Relative URL: \^\/\(\(\(project\|branch\(es\)?\|tags?\)\/[^/$]*\|trunk\|master\)\)'
		let match = matchlist(infoText, pattern)
		let b:svnBranchName = get(match, 2, '')
		AirlineRefresh
	endfunction

	if !exists('b:svnBranchName')
		let fileName = bufname(VCSCommandGetOriginalBuffer(bufnr('%')))
		let command = 'svn info --non-interactive -- "' . fileName . '"'
		let job = job_start(command, { 'close_cb': 'GetSvnBranchNameJobFinished', 'out_mode': 'raw' })

		let b:svnBranchName = ''
	endif

	return b:svnBranchName
endfunction

function! FormatBranchName(name)
	if !exists('b:VCSCommandVCSType') || b:VCSCommandVCSType != 'SVN'
		return a:name
	endif

	" When using the vcscommand svn plugin the branch name is the revision number, which is kind of
	" useless.
	return GetSvnBranchName()
endfunction

function! ToCamelCase()
	.s/\v_(\w)/\u\1/e
	.s/\v(\W|^)(\w)/\1\u\2/e
endfunction

function! ToSnakeCase()
	.s/\v([a-z])([A-Z])/\1_\l\2/e
	.s/\v(\W|^)([A-Z])/\1\l\2/e
endfunction
