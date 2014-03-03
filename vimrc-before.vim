" On my Dvorak keyboard, I much prefer the use of , as the leader.
let mapleader=","

" Don't use Powerline on 8-color terminals... it just doesn't look good.
if !has("gui_running") && &t_Co == 8
    let g:EnablePowerline = 0
endif

" Neovim isn't building python bindings yet... so disable UltiSnips if python
" isn't available.
if !has("python") && !has("python3")
    let g:EnableUltiSnips = 0
endif

if !exists("g:FontSize")
    " Default font size.
    if has("gui_win32")
        let g:FontSize = 11
    else
        let g:FontSize = 14
    endif
endif
