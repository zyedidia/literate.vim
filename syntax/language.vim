exec 'runtime syntax/' . tolower(b:codetype) . '.vim'

" syntax region blockReference start=/@{/ end=/}/
syn match blockReference "@{.*}"

hi link blockReference PreProc
