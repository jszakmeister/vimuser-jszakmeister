" Enable the signature plugin.
call filter(g:pathogen_disabled, 'v:val != "signature"')

if has('nvim')
    runtime! python_setup.vim
endif

if v:version > 800
    call add(g:pathogen_disabled, 'syntastic')
    call filter(g:pathogen_disabled, 'v:val !~ "ale"')
    command! SyntasticReset let b:syntastic_enabled = 0
endif
