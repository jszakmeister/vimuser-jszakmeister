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

function! DetectPlatform()
    if has("gui_win32")
        return "win32"
    endif

    " Assume we're on a Unix box.
    let name = substitute(system("uname"), '^\_s*\(.\{-}\)\_s*$', '\1', '')

    return tolower(name)
endfunction

function DetectVmware(platform)
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

if !exists("g:FontSize")
    let g:FontSize = 14

    if g:Platform == "win32"
        let g:FontSize = 11
    elseif g:InVmware
        let g:FontSize = 12
    elseif g:Platform == "darwin"
        let g:FontSize = 15
    endif
endif
