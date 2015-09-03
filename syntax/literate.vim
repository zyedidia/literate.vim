if exists("b:current_syntax")
	finish
endif

let s:codetypeline_num = search("^@code_type", "n")
let s:codetypeline = getline(s:codetypeline_num)

let b:codetype = "not found"

if s:codetypeline_num != 0
    let b:codetype = split(s:codetypeline)[1]
    let b:codetype_ext = split(s:codetypeline)[2][1:]
endif

syntax case match

syntax match literateCommand "^@s"
syntax match literateCommand "^@title"
syntax match literateCommand "^@code_type"
syntax match literateCommand "^@comment_type"
syntax match literateCommand "@{.\{-}}"
syntax match literateCommand "^@include"
syntax match literateCommand "^@change"
syntax match literateCommand "^@change_end"
syntax match literateCommand "@add_css"
syntax match literateCommand "@overwrite_css"
syntax match literateCommand "@colorscheme"

syntax match markdownCommand "`.\{-}`"
syntax match markdownCommand "\$.\{-}\$"
syntax match markdownCommand "\*.\{-}\*"
syntax match markdownCommand "\*\*.\{-}\*\*"

syntax region changeFrom start="^@replace"ms=e+1 end="^@with"me=s-1
syntax region changeTo start="^@with"ms=e+1 end="^@end"me=s-1
hi def link changeFrom String
hi def link changeTo Statement

hi link literateCommand Underlined
hi link markdownCommand String

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
