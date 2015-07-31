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
    let b:codetype_ext = split(s:codetypeline)[2][1:]
endif

function FindCodeblock()
    let line = getline('.')

    if !empty(matchstr(line, '^---.\+$'))
        let match = matchlist(line, '\v^---\s*(.{-})(\s*\+\=)?$')[1]

        exec "/" . match
    elseif !empty(matchstr(line, '@{.*}'))
        let match = matchlist(line, '\v\@\{(.*)\}')[1]

        exec "/" . match
    end
endfunc

function LitCode()
    exec "w"
    exec "silent !lit -code %"

    let splits = map(range(1, winnr('$')), 'fnamemodify(bufname(winbufnr(v:val)), ":t")')

    if index(splits, expand("%:r") . "." . b:codetype_ext) == -1
        exec "vsp %:r.".b:codetype_ext
    endif
endfunc

function! LitHtml()
    exec "w"
    exec "silent !lit -html %"
    exec "silent !open %:r.html"
    exec "redraw!"
endfunc

nnoremap <C-]> :call FindCodeblock()<CR>
nnoremap <Leader>l :call LitCode()<CR>
nnoremap <Leader>o :call LitHtml()<CR>
