" Enable the signature plugin.
call filter(g:pathogen_disabled, 'v:val != "signature"')

if has('nvim')
    call add(g:pathogen_disabled, "togglecursor")
    runtime! python_setup.vim
endif
