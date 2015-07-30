if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

setlocal expandtab

let s:codetypeline_num = search("^@code_type", "n")
let s:codetypeline = getline(s:codetypeline_num)

let b:codetype = "not found"

if s:codetypeline_num != 0
	let b:codetype = split(s:codetypeline)[1]
	let b:codetype_ext = split(s:codetypeline)[2]
endif

function! FindCodeblock()
    let line = getline('.')

    if !empty(matchstr(line, '^---.\+$'))
        let match = matchlist(line, '\v^---\s*(.{-})(\s*\+\=)?$')[1]

        exec "/\\v((^---\\s*)|(\\@\\{))" . match . "(\\})?"
    elseif !empty(matchstr(line, '@{.*}'))
        let match = matchlist(line, '\v\@\{(.*)\}')[1]

        exec "/\\v((^---\\s*)|(\\@\\{))" . match . "(\\})?"
    end
endfunc

nnoremap <C-]> :call FindCodeblock()<CR>
