exec 'runtime syntax/' . b:codetype . '.vim'

syntax region blockReference start=/@{/ end=/}/
hi link blockReference Underlined
