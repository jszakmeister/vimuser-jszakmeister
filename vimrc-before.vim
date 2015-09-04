" On my Dvorak keyboard, I much prefer the use of , as the leader.
let mapleader=","

" Use the subtle search highlighting in my colorscheme.
if !exists("g:szakdark_subtle_search")
    let g:szakdark_subtle_search = 1
endif

" For some reason, gnome-terminal says xterm-color even though it supports
" xterm-256color.
if !has("gui_running") && $COLORTERM == "gnome-terminal" && &t_Co <= 16
    if $TERM == "xterm"
        " Override the default xterm setting of Gnome Terminal so that
        " Powerline works.
        let $TERM = "xterm-256color"
    endif
    set t_Co=256
endif

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
    let g:FontSize = AdjustBaseFontSize(12)
endif

if has("nvim")
    " Background detection is not trustyworth in nvim, so set the colorscheme.
    colorscheme szakdark

    " Neovim turns on gui support when truecolor support is activated.
    " Unfortunately, it messes with our font selection logic, so let's just set
    " a font knowing full well it won't be used for now.
    if $NVIM_TUI_ENABLE_TRUE_COLOR != ""
        let g:FontFamily = "DejaVu Sans Mono for Powerline"
    endif
endif

if $USER =~? "szak" || $VIMUSER =~? "szak"
    " Main vimrc will tack on the other default choices.
    let g:DefaultFontFamilies = ["Hack"]
endif
