if exists('g:loaded_syntastic_literate_lit_checker')
    finish
endif
let g:loaded_syntastic_literate_lit_checker = 1

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_literate_lit_GetLocList() dict
    let makeprg = self.makeprgBuild({ 'args': '--compiler -t' })

    let errorformat =
        \ '%f:%l:%trror: %m,' .
        \ '%f:%l:%tarning: %m,' .
        \ '%f:%l: %m,'

    return SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat,
        \ 'defaults': {'bufnr': bufnr('')} })

endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'literate',
    \ 'name': 'lit'})

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set sw=4 sts=4 et fdm=marker:
