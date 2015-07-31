if exists("b:current_syntax")
	finish
endif

let s:codetypeline_num = search("^@code_type", "n")
let s:codetypeline = getline(s:codetypeline_num)

let b:codetype = "not found"

if s:codetypeline_num != 0
    let b:codetype = split(s:codetypeline)[1]
    let b:codetype_ext = split(s:codetypeline)[2]
endif

set syntax=markdown

syntax case match

syntax match literateCommand "@s"
syntax match literateCommand "@title"
syntax match literateCommand "@code_type"
syntax match literateCommand "@comment_type"
syntax match literateCommand "@{.\{-}}"
hi link literateCommand Underlined

function! TextEnableCodeSnip(filetype,start,end,textSnipHl) abort
	let ft=toupper(a:filetype)
	let group='textGroup'.ft
	if exists('b:current_syntax')
		let s:current_syntax=b:current_syntax
		" Remove current syntax definition, as some syntax files (e.g. cpp.vim)
		" do nothing if b:current_syntax is defined.
		unlet b:current_syntax
	endif
    execute 'syntax include @'.group.' syntax/language.vim'
	" execute 'syntax include @'.group.' syntax/'.a:filetype.'.vim'
	" try
		" execute 'syntax include @'.group.' after/syntax/'.a:filetype.'.vim'
	" catch
	" endtry
	if exists('s:current_syntax')
		let b:current_syntax=s:current_syntax
	else
        if exists('b:current_syntax')
            unlet b:current_syntax
        endif
	endif
	execute 'syntax region textSnip'.ft.'
				\ matchgroup='.a:textSnipHl.'
				\ start="'.a:start.'" end="'.a:end.'"
				\ contains=@'.group
endfunction

if b:codetype != "not found"
	call TextEnableCodeSnip(tolower(b:codetype), "^---.*$", "^---$", "Identifier")
endif

let b:current_syntax = "literate"
