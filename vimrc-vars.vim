" Enable the signature plugin.
call filter(g:pathogen_disabled, 'v:val != "signature"')

if has('nvim')
    runtime! python_setup.vim
endif
