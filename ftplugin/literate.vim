if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

let s:codetypeline_num = search("@codetype", "n")
let s:codetypeline = getline(s:codetypeline_num)

let b:codetype = "not found"

if s:codetypeline_num != 0
	let b:codetype = split(s:codetypeline)[1]
	let b:codetype_ext = split(s:codetypeline)[2]
endif
