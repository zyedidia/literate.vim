if exists("b:did_indent")
  finish
endif

runtime! indent/julia.vim

let b:did_indent = 1

if exists("*GetLiterateIndent")
	setlocal indentexpr=GetLiterateIndent()

	finish
end

function GetLiterateIndent()
	if searchpair('^---.','','^---$','bWnm') > 0
		return GetJuliaIndent()
	else
		return -1
	endif
endfunc

set indentexpr=GetLiterateIndent()
