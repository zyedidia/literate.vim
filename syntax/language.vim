exec 'runtime syntax/' . tolower(b:codetype) . '.vim'

syntax region blockReference start=/@{/ end=/}/
hi link blockReference PreProc
