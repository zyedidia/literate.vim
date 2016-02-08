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

function! EnableLinter()
    if exists(":Neomake") == 2
        let g:neomake_literate_lit_maker = {
                \ 'args': ['--compiler', '-t'],
                \ 'errorformat':
                    \ '%f:%l:%trror: %m,' .
                    \ '%f:%l:%tarning: %m,' .
                    \ '%f:%l: %m',
                \ }

        let g:neomake_literate_enabled_makers = ['lit']
    endif
endfunc

function! EnableTagbar()
    if exists(":TagbarToggle") == 2
        let g:tagbar_type_literate = {
                \ 'ctagstype' : 'literate',
                    \ 'kinds' : [
                        \ 's:section',
                        \ 'c:code',
                        \ 'i:includes'
                    \ ]
                \ }
    endif
endfunc

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

function! LitCode()
    if !exists('b:codetype_ext')
        echohl ErrorMsg | echo "@codetype not defined" | echohl None
        return
    endif
    exec "noautocmd w"
    exec "silent !lit -t %"

    let splits = map(range(1, winnr('$')), 'fnamemodify(bufname(winbufnr(v:val)), ":t")')

    if index(splits, expand("%:r") . "." . b:codetype_ext) == -1
        exec "vsp %:r.".b:codetype_ext
    else
        exec "wincmd l"
    endif
endfunc

function! LitHtml()
    exec "w"
    exec "silent !lit -w %"
    exec "silent !open %:r.html"
    exec "redraw!"
endfunc

if !exists('g:literate_find_codeblock')
    let g:literate_find_codeblock = '<C-]>'
endif
if !exists('g:literate_open_code')
    let g:literate_open_code = '<leader>c'
endif
if !exists('g:literate_open_html')
    let g:literate_open_html = '<leader>h'
endif

execute "autocmd FileType literate" "nnoremap <buffer>" g:literate_find_codeblock ":call FindCodeblock()<CR>"
execute "autocmd FileType literate" "nnoremap <buffer>" g:literate_open_code ":call LitCode()<CR>"
execute "autocmd FileType literate" "nnoremap <buffer>" g:literate_open_html ":call LitHtml()<CR>"

call EnableLinter()
call EnableTagbar()
