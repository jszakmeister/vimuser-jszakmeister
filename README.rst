********************
vimuser-jszakmeister
********************

This configuration build on top of Dr. Mike's vimfiles configuration.  To setup
everything, you need to clone Dr. Mike's config to `~/.vim` and run the
`setup.py` file::

    git clone git://github.com/drmikehenry/vimfiles.git ~/.vim
    cd ~/.vim
    python setup.py

And then clone this configuration into `~/.vimuser`::

    git clone git://github.com/jszakmeister/vimuser-jszakmeister.git ~/.vimuser

If you're building on top of this configuration, it might be more useful to
`~/.vimuser-jszakmeister`.  Then you would add the following to your
`vimrc-before.vim`::

    let s:inherit_dir = expand("$HOME/.vimuser-jszakmeister")
    call RtpInherit(s:inherit_dir)
    exec 'source ' . fnameescape(s:inherit_dir . '/vimrc-before.vim')

    " Your settings go here...

    " Unlet mapleader to prevent using ',' as the mapleader.
    unlet! mapleader

Then add the following to your `vimrc-after.vim`::

    source $HOME/.vimuser-jszakmeister/vimrc-after.vim

This will pull in the settings from my vimuser configuration, but still allow
you to customize settings to your liking without forking my vimuser
configuration.
