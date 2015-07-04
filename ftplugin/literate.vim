if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

let s:codetypeline = getline(search("@codetype", "n"))

let b:codetype = split(s:codetypeline)[1]
