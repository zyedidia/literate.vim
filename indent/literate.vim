if exists("b:did_indent")
  finish
endif

let s:codetypeline = getline(search("@codetype", "n"))

let b:codetype = split(s:codetypeline)[1]

exec "runtime! indent/".tolower(b:codetype).".vim"
let b:did_indent = 1

if exists("*GetLiterateIndent")
	setlocal indentexpr=GetLiterateIndent()

	finish
end

function GetLiterateIndent()
	if searchpair('^---.','','^---$','bWnm') > 0
		if b:codetype ==? "c"
			setlocal cindent
			return -1
		endif
		let Fn = function("Get".b:codetype."Indent")
		return Fn()
	else
		return -1
	endif
endfunc

setlocal indentexpr=GetLiterateIndent()
