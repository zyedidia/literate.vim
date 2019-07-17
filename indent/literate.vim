if exists("b:did_indent")
	finish
endif

let s:codetypeline_num = search("@code_type", "n")
let s:codetypeline = getline(s:codetypeline_num)

if s:codetypeline_num > 0
	let b:codetype = split(s:codetypeline)[1]

	exec "runtime! indent/".tolower(b:codetype).".vim"
	let b:did_indent = 1

	if exists("*GetLiterateIndent")
		setlocal indentexpr=GetLiterateIndent()

		finish
	end

	function GetLiterateIndent()
		if searchpair('^---.','','^---$','bWnm') > 0
			let Fn = function("Get".b:codetype."Indent")
			return Fn()
		else
			return -1
		endif
	endfunc

	setlocal indentexpr=GetLiterateIndent()
endif
