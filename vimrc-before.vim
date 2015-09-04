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

function! DetectPlatform()
    if has("gui_win32")
        return "win32"
    endif

    " Assume we're on a Unix box.
    let name = substitute(system("uname"), '^\_s*\(.\{-}\)\_s*$', '\1', '')

    return tolower(name)
endfunction

function! DetectVmware(platform)
    if a:platform == "linux"
        if filereadable("/sys/class/dmi/id/sys_vendor")
            for line in readfile("/sys/class/dmi/id/sys_vendor", '', 10)
                if line =~ '\cvmware'
                    return 1
                endif
            endfor
        endif
    elseif a:platform == "freebsd"
        if executable("kldstat")
            let output = system("kldstat")
            if output =~ "vmxnet"
                return 1
            endif
        endif
    endif

    return 0
endfunction

let g:Platform = DetectPlatform()
let g:InVmware = DetectVmware(g:Platform)

function! AdjustBaseFontSize(size)
    if g:Platform != "darwin"
        return a:size
    endif

    " Mac's idea of a point on screen is not the same as everyone else's.
    " It appears that most operating systems either expect the screen to be 96
    " DPI, or will query the monitor.  Mac, on the other hand, assumes that the
    " monitor is 72 DPI.
    return ((a:size * 96) + 35) / 72
endfunction

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

    let g:startify_disable_at_vimenter = 1
endif
