if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

setlocal expandtab

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
