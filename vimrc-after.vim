" =============================================================
" Variables
" =============================================================

function! AdjustSzakDarkColors()
    " This is here to help me test out adjustments to the color scheme.
    if exists('+colorcolumn')
        if &t_Co > 255 || has("gui_running")
            highlight ColorColumn ctermbg=234 guibg=#1c1c1c
        endif
    endif
endfunction

if g:colors_name == 'szakdark'
    call AdjustSzakDarkColors()
endif

" Turn on some Java-syntax related options.  Namely, let's color all
" built-in classes and object methods.
let java_highlight_all = 1

" =============================================================
" Detect custom exectuables
" =============================================================

if filereadable(expand("$HOME/.local/bin/ctags"))
    let Tlist_Ctags_Cmd = expand("$HOME/.local/bin/ctags")
    let g:tagbar_ctags_bin = Tlist_Ctags_Cmd
elseif filereadable("/usr/local/bin/ctags")
    let Tlist_Ctags_Cmd = "/usr/local/bin/ctags"
    let g:tagbar_ctags_bin = Tlist_Ctags_Cmd
endif

if filereadable(expand("$HOME/.local/bin/git"))
    let g:fugitive_git_executable = expand("$HOME/.local/bin/git")
    let g:Gitv_GitExecutable = g:fugitive_git_executable
endif

" =============================================================
" Mappings
" =============================================================

" Make Y work the way I expect it to: yank to the end of the line.
nnoremap Y y$

" Keep the block highlighted while shifting.
vnoremap < <gv
vnoremap > >gv

" Visually select the text that was last edited/pasted.
" From http://vim.wikia.com/wiki/Selecting_your_pasted_text
nnoremap <expr> gV '`[' . strpart(getregtype(), 0, 1) . '`]'

" Some reminders of the tag-related shortcuts, since I tend to check my
" configuration first.
" C-] - go to definition
" C-T - Jump back from the definition.
" C-W C-] - Open the definition in a horizontal split

" C-\ - Open the definition in a new tab
" A-] - Open the definition in a vertical split
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" The next several entries are taken from:
"     <http://stevelosh.com/blog/2010/09/coming-home-to-vim/>

" Split the window vertically, and go to it.
nnoremap <leader>w <C-w>v<C-w>l

" I often want to close a buffer without closing the window.  Using
" :BW also drops the associated metadata.
nnoremap <leader><leader>d :lclose<CR>:BW<CR>
nnoremap <leader><leader>D :lclose<CR>:BW!<CR>

" Shortcut for clearing CtrlP caches
nnoremap <Leader><Leader>r :<C-U>CtrlPClearAllCaches<CR>

" Add some mappings for Regrep since I don't use the function keys.
vnoremap <expr> <Leader><Leader>g VisualRegrep()
nnoremap <expr> <Leader><Leader>g NormalRegrep()

" Copies a selection to the clipboard, with 4 spaces added to the front.
" This makes it easier to paste into a markdown-enabled form, like on
" StackOverflow and on GitHub.
function! CopyForMarkdown() range
    let lines = getline(a:firstline, a:lastline)
    call map(lines, '"    " . v:val')
    let @+ = join(lines, "\n") . "\n"
endfunction
command! -range CopyForMarkdown <line1>,<line2>call CopyForMarkdown()

vnoremap <Leader><Leader>cm :CopyForMarkdown<CR>

function! CopyAsBoxQuote() range
    let header = [',----[ ' . expand('%:t') . ' ]-']
    if a:firstline != 1
        let header += ['| [...]']
    endif

    echom len(header[0])-1
    let trailer = ['`' . repeat('-', len(header[0])-1)]
    if a:lastline != line('$')
        let trailer = ['| [...]'] + trailer
    endif

    let digits = len(string(a:lastline))
    let lines = getline(a:firstline, a:lastline)
    let formatStr = '| %' . digits . 'd %s'

    for i in range(a:lastline - a:firstline + 1)
        let lines[i] = substitute(printf(formatStr, i + a:firstline, lines[i]),
                    \             '\s\+$', '', '')
    endfor

    let @+ = join(header + lines + trailer, "\n") . "\n"
endfunction
command! -range CopyAsBoxQuote <line1>,<line2>call CopyAsBoxQuote()

vnoremap <Leader><Leader>cb :CopyAsBoxQuote<CR>

function! UnmapUnwanted()
    " Here to help remove unwanted mappings set up by plugins.
endfunction

" Allow . to work over visual ranges.
vnoremap . :normal .<CR>

" Yank to the system clipboard.
vnoremap <Leader><Leader>y "+y

function! SmartHome()
    let c = col('.')
    let l = getline('.')
    if mode() == "i"
        let prefix = "\<C-o>"
        " I want the cursor to be 1 position after the match in insert mode.
        let offset = 1
    else
        let prefix = ""
        let offset = 0
    endif

    if match(l, '^\s*$') == -1
        if c == matchend(l, '^\s*')+1
            return prefix . '0'
        else
            return prefix . '^'
        endif
    else
        " The line is just whitespace, so we behave slightly different.
        if c == matchend(l, '^\s*') + offset
            return prefix . '0'
        else
            return prefix . '$'
        endif
    endif
endfunction

" Smart Home.  Idea taken from http://vim.wikia.com/wiki/Smart_home, but
" tweaked by me.
noremap <expr> <Home> SmartHome()
inoremap <expr> <Home> SmartHome()

" =============================================================
" Options
" =============================================================

" Turn on list, and setup the listchars.
set listchars=tab:▸\ ,trail:·,extends:>,precedes:<,nbsp:·
if &termencoding ==# 'utf-8' || &encoding ==# 'utf-8'
    let &listchars = "tab:\u21e5 ,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u26ad"
    let &fillchars = "vert:\u254e,fold:\u00b7"
endif
set list

" I dislike wrapping being on by default.
set nowrap

" Round to the nearest stop when shifting a block.
set shiftround

" When I do turn it on though, I want to see a better line break character.
let &showbreak = '↳   '

" Ignore some Clojure/Java-related files.
set wildignore+=target,asset-cache,out

" I regularly create tmp folders that I don't want searched.
set wildignore+=tmp,.lein-*,*.egg-info,.*.swo

" Set colorcolumn, if available.
if exists('+colorcolumn')
    " This sets it to textwidth+1
    set colorcolumn=+1
endif

" Make splits appear on the right.
set splitright

" Adjust the scrolling.
set scrolloff=4
set sidescrolloff=5

" -------------------------------------------------------------
" GUI options
" -------------------------------------------------------------

" Turn off the scrollbars... I don't need them.
if has("gui_running")
    set guioptions-=R
    set guioptions-=r
    set guioptions-=L
    set guioptions-=l
endif

if has("gui_macvim")
    set macmeta
endif

" On remote systems, I like to change the background color so that I remember
" I'm on a remote system. :-)  This does break when you sudo su to root though.
if !empty($SSH_TTY)
    hi Normal guibg=#071407
endif

" -------------------------------------------------------------
" Font selection
" -------------------------------------------------------------

" =============================================================
" Fullscreen
" =============================================================

" Allow Vim to go fullscreen under Mac and Linux.
if has("gui_macvim")
    " grow to maximum horizontal width on entering fullscreen mode
    set fuoptions+=maxhorz

    " This needs to go in a gvimrc, otherwise the macmenu defaults
    " clobber my setting.  Not sure how I want to do this just yet.
    " " free up Command-F
    " macmenu Edit.Find.Find\.\.\. key=<nop>

    " " toggle fullscreen mode
    " map <D-f> :set invfu<CR>
    nnoremap <Leader><Leader>f :set invfu<CR>
endif

if has("unix")
    let s:os = substitute(system('uname'), "\n", "", "")
    if v:version >= 703 && s:os == "Linux" && has("gui_running")
        function! ToggleFullScreen()
           call system("wmctrl -i -r ".v:windowid." -b toggle,fullscreen")
           redraw
        endfunction

        nnoremap <Leader><Leader>f call ToggleFullScreen()<CR>
    endif
endif

" =============================================================
" Setup routines
" =============================================================

" Override SetupSource's enabling of longline handling.  It messes
" up syntax-coloring, and it's often not under my control when contributing
" to other project.  Also, it is acceptable in some projects, like Git, to
" exceed 80 characters if it keeps the code more coherent.
function! CustomSetupSource()
    call SetupSource()
    Highlight nolonglines
endfunction
command! -bar SetupSource call CustomSetupSource()

" Same as the above, but for C.
function! CustomSetupC()
    call SetupC()
    Highlight nolonglines

    " Cope with Doxygen style /// comments.
    setlocal comments=s:/*,mb:\ ,e-4:*/,:///,://
endfunction
command! -bar SetupC call CustomSetupC()

function! SetupAnt()
    SetupMarkup
    set sts=4 sw=4
endfunction
command! -bar SetupAnt call SetupAnt()

function! StripJustBeforeCursor()
    let currentLine = getline(".")
    let curPos = getpos(".")
    let matchRe = '\s*\%' . curPos[2] . 'c'
    let start = match(currentLine, matchRe)
    let end = matchend(currentLine, matchRe)
    let newLine = substitute(currentLine, matchRe, "", "")
    call setline(".", newLine)
    call setpos(".", curPos)
    return end - start
endfunction

function! StripJustAfterCursor()
    let currentLine = getline(".")
    let curPos = getpos(".")
    let matchRe = '\%>' . curPos[2] . 'c\s*'
    let newLine = substitute(currentLine, matchRe, "", "")
    call setline(".", newLine)
    call setpos(".", curPos)
endfunction

function! PareditForwardSlurp()
    let savePos = getpos('.')

    " We do this non-sense to make sure we're positioned on the final paren of
    " the enclosing s-expression, even if it's empty.
    call PareditFindOpening('(', ')', 0)
    call PareditFindClosing('(', ')', 0)
    call PareditMoveRight()

    " Slurping into empty parens can add a space at the front.
    call PareditFindOpening('(', ')', 0)
    call StripJustAfterCursor()

    " Re-indent the selection and go back to insert mode.
    " normal! v)=
    call setpos('.', savePos)
endfunction

function! PareditForwardBarf()
    let savePos = getpos('.')

    " We do this non-sense to make sure we're positioned on the final paren of
    " the enclosing s-expression, even if it's empty.
    call PareditFindOpening('(', ')', 0)
    call PareditFindClosing('(', ')', 0)
    call PareditMoveLeft()

    " Check to see if our cursor position will still be valid.
    let curPos = getpos('.')

    if (curPos[1] < savePos[1])
                \ || ((curPos[1] == savePos[1]) && (curPos[2] < savePos[2]))
        let savePos = curPos
    endif

    " normal! v(=
    call setpos('.', savePos)
endfunction

function! PareditBackwardSlurp()
    let savePos = getpos('.')
    call PareditFindOpening('(', ')', 0)
    call PareditMoveLeft()

    " Slurping into empty parens can add a space at the back.
    call PareditFindClosing('(', ')', 0)
    let numCharsRemoved = StripJustBeforeCursor()
    let savePos[2] = savePos[2] - numCharsRemoved

    " normal! v(=
    call setpos('.', savePos)
endfunction

function! PareditBackwardBarf()
    let savePos = getpos('.')
    call PareditFindOpening('(', ')', 0)
    call PareditMoveRight()

    let curPos = getpos('.')

    " If the starting paren is now at the cursor, or further into the line,
    " let's cuddle against the start of the s-expression.
    if (curPos[1] > savePos[1])
                \ || ((curPos[1] == savePos[1]) && (curPos[2] >= savePos[2]))
        let savePos = curPos
        let savePos[2] = savePos[2] + 1
    endif

    " normal! v)=
    call setpos('.', savePos)
endfunction

function! CustomSetupClojure()
    call SetupClojure()

    " Add the Emacs paredit bindings for slurpage and barfage.
    inoremap <buffer> <C-Left> <C-\><C-O>:call PareditForwardBarf()<CR>
    inoremap <buffer> <C-Right> <C-\><C-O>:call PareditForwardSlurp()<CR>
    inoremap <buffer> <C-M-Left> <C-\><C-O>:call PareditBackwardSlurp()<CR>
    inoremap <buffer> <C-M-Right> <C-\><C-O>:call PareditBackwardBarf()<CR>

    " Map fireplace's Eval.  Likely to change, but let's try this for now.
    nnoremap <buffer> <Leader><Leader>e :Eval<CR>
    nnoremap <buffer> <Leader>e :Eval<CR>
    vnoremap <buffer> <Leader><Leader>e :Eval<CR>
    vnoremap <buffer> <Leader>e :Eval<CR>
endfunction
command! -bar SetupClojure call CustomSetupClojure()

function! CustomSetupCmake()
    call SetupCmake()

    " Line up function args, except when they start on a new line.
    setlocal cinoptions+=(0
    setlocal cinoptions+=Ws
endfunction
command! -bar SetupCmake call CustomSetupCmake()

function! CustomSetupGo()
    setlocal tw=80
endfunction
command! -bar SetupGo call CustomSetupGo()

function! CustomSetupGroovy()
    SetupSource
endfunction
command! -bar SetupGroovy call CustomSetupGroovy()

function! CustomSetupHelp()
    call SetupHelp()

    setlocal nolist
endfunction
command! -bar SetupHelp call CustomSetupHelp()

function! CustomSetupMail()
    call SetupMail()

    vnoremap <buffer> <Leader><Leader>s c[snip]<ESC><Down><Home>
endfunction
command! -bar SetupMail call CustomSetupMail()

function! CustomSetupMarkdownSyntax()
    call SetupMarkdownSyntax()

    " Support my trac-style code blocks that I tend to use in my blog.
    for lang in g:markdownEmbeddedLangs
        let synLang = lang
        if lang == "c"
            let synLang = "cpp"
        endif

        let synGroup = "markdownTracEmbeddedHighlight" . synLang

        exe 'syn region ' . synGroup . ' ' .
                    \ 'matchgroup=markdownCodeDelimiter ' .
                    \ 'start="^\s*{{{\n\s*::' . lang .
                    \ '\>.*$" end="^\s*}}}\ze\s*$" ' .
                    \ 'keepend contains=@markdownHighlight' . synLang
    endfor
endfunction
command! -bar SetupMarkdownSyntax call CustomSetupMarkdownSyntax()

" =============================================================
" Setup routines for lvimrc files
" =============================================================

function! GitLvimrc()
    call SetupKernelSource()
    call Highlight('nocommas', 'nolonglines', 'notabs')
    call AppendSnippetDirs("snippets/git")
endfunction

function! NeovimLvimrc()
    call Highlight('nolonglines')

    if &filetype == "c"
        setlocal cinoptions+=(0
        setlocal sts=2 sw=2
    elseif &filetype == "cmake"
        setlocal cinoptions+=(0
        setlocal sts=2 sw=2
    elseif &filetype == "make"
        setlocal sts=2 sw=2
    elseif &filetype == "moon" || &filetype == "lua"
        setlocal sts=2 sw=2
    elseif &filetype == "sh"
        setlocal noexpandtab sts=8 sw=8
    elseif &filetype == "yaml"
        setlocal sts=2 sw=2
    endif
endfunction

" =============================================================
" Plugin settings
" =============================================================

" -------------------------------------------------------------
" BufExplorer
" -------------------------------------------------------------

" let g:bufExplorerShowUnlisted = 1

" -------------------------------------------------------------
" CtrlP
" -------------------------------------------------------------

nnoremap <SNR>CtrlP.....<C-s>     :<C-U>CtrlPRTS<CR>

" -------------------------------------------------------------
" Grep
" -------------------------------------------------------------

" Use ack for grep
if executable('ack')
    set grepprg=ack
    set grepformat=%f:%l:%m
endif

" Be compatible with both grep on Linux and Mac
let Grep_Xargs_Options = '-0'

" -------------------------------------------------------------
" Gitv
" -------------------------------------------------------------

let g:Gitv_WipeAllOnClose = 1
let g:Gitv_OpenHorizontal = 1
let g:Gitv_OpenPreviewOnLaunch = 1

" -------------------------------------------------------------
" Indent Guides
" -------------------------------------------------------------

let g:IndentGuides = 1

" -------------------------------------------------------------
" localvimrc
" -------------------------------------------------------------

let s:project_whitelist = [
            \ 'jszakmeister',
            \ 'intelesys',
            \ 'git',
            \ 'llvm',
            \ ]
let g:localvimrc_whitelist = resolve(expand('$HOME/projects')) . '/\(' .
            \ join(s:project_whitelist, '\|') . '\)/.*'

" Turn off the sandbox, otherwise I can't turn off some highlighting features.
let g:localvimrc_sandbox = 0

" Persist all decisions.
let g:localvimrc_persistent = 2

" -------------------------------------------------------------
" manpageview
" -------------------------------------------------------------

" let g:manpageview_options= "-P 'cat -'"

" -------------------------------------------------------------
" Powerline
" -------------------------------------------------------------

if exists("g:EnablePowerline") && g:EnablePowerline
    " Add back in a few segments...
    call Pl#Theme#InsertSegment('mode_indicator', 'after', 'paste_indicator')
    call Pl#Theme#InsertSegment('filetype', 'before', 'scrollpercent')

    if !has("gui_running")
        if &termencoding ==# 'utf-8' || &encoding ==# 'utf-8'
            let g:Powerline_symbols_override = {
                \ 'BRANCH': [0x2442],
                \ }
        endif
    endif

    let g:Powerline_colorscheme = 'szakdark'
endif


" -------------------------------------------------------------
" Syntastic
" -------------------------------------------------------------

let g:syntastic_mode_map['active_filetypes'] =
            \ g:syntastic_mode_map['active_filetypes'] +
            \ ['c', 'cpp', 'go', 'haskell', 'html', 'javascript', 'less', 'rst',
            \  'sh', 'vim', 'zsh']

" let g:syntastic_debug = 31
let g:syntastic_python_checkers = ["pyflakes"]

" -------------------------------------------------------------
" Tagbar
" -------------------------------------------------------------

" Add support for Clojure.  It requires that your ctags have support for
" Clojure.
let g:tagbar_type_clojure = {
    \ 'ctagstype': 'clojure',
    \ 'ctagsbin' : 'ctags',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 'n:namespaces',
        \ 'f:functions',
        \ 'p:private functions',
        \ 'i:inline',
        \ 'a:multimethod definitions',
        \ 'b:multimethod instances',
        \ 'c:definitions (once)',
        \ 's:structures',
        \ 'v:interns',
        \ 'm:macros',
        \ 'd:definitions'
    \ ],
\ }

" =============================================================
" Autocommands
" =============================================================

" If GR_NAME is set, then attempt to load that session.
function! RestoreGrSession()
    if $GR_NAME == ""
        return
    endif

    let names = xolox#session#get_names(0)

    if index(names, $GR_NAME) != -1
        call xolox#session#open_cmd($GR_NAME, '', 'OpenSession')
    endif
endfunction

" Always turn on the sign column.  An autocommand will be used to insert this
" into every buffer.
sign define _hidden

" Help set up a filetype for the edit-in-emacs plugin for chrome.
function! SetupEditServerFileType(domain, type)
    if $TMPDIR == ""
        return
    endif

    let name = "chrome_*" . a:domain . "*.txt"

    let editserver_path = $TMPDIR . name

    " For use with edit-server and using Vim to edit emails in GMail.
    exec "autocmd BufRead,BufNewFile " . editserver_path . " set ft=" . a:type
endfunction

function! ReloadColorScheme()
    redir => current_scheme
    colorscheme
    redir END

    let current_scheme = xolox#misc#str#trim(current_scheme)

    execute 'colorscheme ' . current_scheme
endfunction

augroup jszakmeister_vimrc
    autocmd!

    " Don't fall back to the terminal version of vim if the GUI fails to
    " start (usually because of an authorization problem).  Instead, exit
    " with an error.
    autocmd GUIFailed * cquit

    autocmd VimEnter * call UnmapUnwanted()
    autocmd VimEnter * nested call RestoreGrSession()

    if has("nvim") && $NVIM_TUI_ENABLE_TRUE_COLOR != ""
        " Neovim has a few issues when it comes to colorschemes right now.  The
        " main one being is that some of the terminal support bits don't come
        " until much later, for truecolor support.  So you need to reload the
        " colorscheme to have it take effect.
        autocmd VimEnter * nested call ReloadColorScheme()
    endif

    " The toggle help feature seems to reset list.  I really want it off for
    " the help buffer though.
    autocmd BufEnter * if &bt == "help" | setlocal nolist | endif

    " Make sure the sign column is always present.
    autocmd BufEnter *
                \ execute 'sign place 9999999 line=1000000000 name=_hidden '
                \ . 'buffer=' . expand('<abuf>')

    " Set up syntax highlighting for e-mail and mutt.
    autocmd BufRead,BufNewFile
                \ .followup,.article,.letter,/tmp/pico*,nn.*,snd.*,/tmp/mutt*
                \ set ft=mail
    autocmd BufRead,BufNewFile *.mbox set ft=mail

    " Add a mapping to make it easy to kill a VCS buffer
    autocmd User VCSBufferCreated silent! nmap <unique> <buffer> q :bwipeout<CR>

    " Use slightly different settings for Ant's build.xml files.
    autocmd BufRead,BufNewFile build.xml SetupAnt

    " Adjustments for my color scheme.
    autocmd ColorScheme szakdark call AdjustSzakDarkColors()

    " Treat patch files as mail when preparing to send to a list.
    autocmd BufNewFile,BufRead [0-9][0-9][0-9][0-9]-*.patch set ft=mail

    " Treat my .etcrc file as shell.
    autocmd BufRead,BufNewFile .etcrc set ft=sh

    call SetupEditServerFileType("mail.google.com", "mail")
    call SetupEditServerFileType("stackoverflow.com", "markdown")
augroup END

" =============================================================
" Commands
" =============================================================

function! SourceRange() range
    let l:regSave = @"
    execute a:firstline . "," . a:lastline . 'y"'
    @"
    let @" = l:regSave
endfunction
command! -range=% Source <line1>,<line2>call SourceRange()

function! ShowHighlightGroup()
    echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
        \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
        \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"
endfunction
command! -bar ShowHighlightGroup call ShowHighlightGroup()

function! ShowAvailableColors()
    " Optional: First enter ":let g:rgb_fg=1" to highlight foreground only.
    " Restore normal highlighting by typing ":call clearmatches()"
    "
    " Create a new scratch buffer:
    " - Read file $VIMRUNTIME/rgb.txt
    " - Delete lines where color name is not a single word (duplicates).
    " - Delete "grey" lines (duplicate "gray"; there are a few more "gray").
    " Add matches so each color name is highlighted in its color.
    call clearmatches()
    new
    setlocal buftype=nofile bufhidden=hide noswapfile
    0read $VIMRUNTIME/rgb.txt
    let find_color = '^\s*\(\d\+\s*\)\{3}\zs\w*$'
    silent execute 'v/'.find_color.'/d'
    silent g/grey/d
    let namedcolors=[]
    1
    while search(find_color, 'W') > 0
        let w = expand('<cword>')
        call add(namedcolors, w)
    endwhile

    for w in namedcolors
        execute 'hi col_'.w.' guifg=black guibg='.w
        execute 'hi col_'.w.'_fg guifg='.w.' guibg=NONE'
        execute '%s/\<'.w.'\>/'.printf("%-36s%s", w, w).'/g'

        call matchadd('col_'.w, '\<'.w.'\>', -1)
        " determine second string by that with large # of spaces before it
        call matchadd('col_'.w.'_fg', ' \{10,}\<'.w.'\>', -1)
    endfor
    1
    nohlsearch
endfunction
command! -bar ShowAvailableColors call ShowAvailableColors()

" Size for the big screen.
function! BigScreenTv()
    if has("gui_running")
        " Set the font first, and let Vim automatically scale back if there are
        " too many rows and columns to fit on the screen.
        let &guifont =
                    \ substitute(&guifont, '.*\%(:h\| \)\zs[^:]*\ze$', '25', '')

        set columns=120
        set lines=36
    endif
endfunction
command! -bar BigScreenTv call BigScreenTv()

function! RestoreSize()
    if has("gui_running")
        SetFont

        " Set the width to accommodate a full 80 column view + signs + tagbar +
        " some change.
        set columns=134
        set lines=50
    endif
endfunction
command! -bar RestoreSize call RestoreSize()

" -------------------------------------------------------------
" Toggling diffs for printing.
" -------------------------------------------------------------

" Colors used when print colors is toggled
let s:diffAddColors = ["#00ff00", "NONE"]
let s:diffDeleteColors = ["#ff0000", "NONE"]

function! s:GetFgBgColor(name)
    let l:hlId = hlID(a:name)
    let l:fgColor = synIDattr(l:hlId, 'fg#')
    let l:fgColor = empty(l:fgColor) ? "NONE" : l:fgColor
    let l:bgColor = synIDattr(l:hlId, 'bg#')
    let l:bgColor = empty(l:bgColor) ? "NONE" : l:bgColor

    return [l:fgColor, l:bgColor]
endfunction

function! TogglePrintColors()
    let l:savedColors = s:GetFgBgColor('DiffAdd')
    exe ":hi DiffAdd guifg=" . s:diffAddColors[0] . " guibg=" . s:diffAddColors[1]
    let s:diffAddColors = l:savedColors

    let l:savedColors = s:GetFgBgColor('DiffDelete')
    exe ":hi DiffDelete guifg=" . s:diffDeleteColors[0] . " guibg=" . s:diffDeleteColors[1]
    let s:diffDeleteColors = l:savedColors
endfunction
command! TogglePrintColors call TogglePrintColors()

" -------------------------------------------------------------
" PrettyXML
" -------------------------------------------------------------

" This was taken from the Vim wiki:
"   http://vim.wikia.com/wiki/Pretty-formatting_XML
"
" It requires xmllint, but that's fine by me.
function! DoPrettyXML()
    " save the filetype so we can restore it later
    let l:origft = &ft
    set ft=
    " delete the xml header if it exists. This will
    " permit us to surround the document with fake tags
    " without creating invalid xml.
    1s/<?xml .*?>//e
    " insert fake tags around the entire document.
    " This will permit us to pretty-format excerpts of
    " XML that may contain multiple top-level elements.
    0put ='<PrettyXML>'
    $put ='</PrettyXML>'
    silent %!xmllint --format -
    " xmllint will insert an <?xml?> header. it's easy enough to delete
    " if you don't want it.
    " delete the fake tags
    2d
    $d
    " restore the 'normal' indentation, which is one extra level
    " too deep due to the extra tags we wrapped around the document.
    silent %<
    " back to home
    1
    " restore the filetype
    exe "set ft=" . l:origft
endfunction
command! -bar PrettyXML call DoPrettyXML()

" -------------------------------------------------------------
" GrabGithubIssueSnippet
" -------------------------------------------------------------
if has("python")
    " We wrap this Python block in a function to prevent parsing errors when
    " Python is not present.
    function! s:DefGlobalPython()
        python << endpython
def getIssueData(apiUrl, repo, issueNumber):
    import requests
    import json
    import types

    if apiUrl.endswith('/'):
        apiUrl = apiUrl.rstrip('/')

    r = requests.get('%s/repos/%s/issues/%s' % (apiUrl, repo, issueNumber))
    return json.loads(r.text)
endpython
    endfunction
    call s:DefGlobalPython()

    function! GrabGithubIssueSnippet(repo, issueNumber)
        if exists('b:gh_api_url')
            let l:gh_api_url = b:gh_api_url
        else
            let l:gh_api_url = 'https://api.github.com/'
        endif

python << endpython
data = getIssueData(vim.eval("l:gh_api_url"),
                    vim.eval("a:repo"),
                    vim.eval("a:issueNumber"))
issueUrl = data['html_url']
title = data['title']

vim.command("let l:issueUrl = '%s'" % issueUrl)
vim.command("let l:title = '%s'" % title)
endpython

        return "#" . a:issueNumber . ": " . l:title . "\n" .
                    \ "<" . l:issueUrl . ">"
    endfunction

    function! GrabIssueSnippetFromCurrentRepo(issueNumber)
        if !exists("b:gh_repo")
            echoerr "You must define 'b:gh_repo' first!"
        endif
        return GrabGithubIssueSnippet(b:gh_repo, a:issueNumber)
    endfunction
    command! -nargs=1 GrabGithubIssueSnippet
                \ :execute "normal! a" . GrabIssueSnippetFromCurrentRepo(<args>)
endif

" -------------------------------------------------------------
" GrabMap
" -------------------------------------------------------------

function! GrabMap()
    let l:save_a = @a
    let @a = ''
    redir @A
    map
    redir END
    enew
    set buftype=nofile
    set bufhidden=hide
    setlocal noswapfile
    execute 'normal 0"ap'
    let @a = l:save_a
endfunction
command! GrabMap :call GrabMap()

" -------------------------------------------------------------
" ReadJinjaTemplate
" -------------------------------------------------------------

if has("python")
    function! ReadJinjaTemplate(template)
        if !filereadable(a:template)
            echoerr "'" . a:template . "' doesn't exist or cannot be read."
            return
        endif

python << endpython
import jinja2
import re
import os

f = open(vim.eval("a:template"), 'rb')
buf = f.read()
f.close()

name = os.path.basename(vim.current.buffer.name or '')

template = jinja2.Template(buf)
buf = template.render(basename=name,
                      name=name[0:name.find('.')]).encode(vim.eval("&encoding"))
lines = buf.splitlines()

vim.current.buffer[:] = lines
endpython
    endfunction
    command! -nargs=1  -complete=file
                \ ReadJinjaTemplate :call ReadJinjaTemplate(<f-args>)
endif

" =============================================================
" Machine Specific Settings
" =============================================================

if $VIMMACHINE == ""
    let $VIMMACHINE=hostname()
endif

let s:VIMMACHINE_CONFIG = $VIMUSERFILES . "/" .
    \ "/machine/" . $VIMMACHINE . ".vim"

" If a machine local config exists, source it.
if filereadable(s:VIMMACHINE_CONFIG)
    execute "source " . s:VIMMACHINE_CONFIG
endif

" This needs to happen here so that the Powerline variables are set correctly
" before the plugin loads.  It needs to come after the machine scripts, so that
" they have an opportunity to adjust the desired font size.
RestoreSize
