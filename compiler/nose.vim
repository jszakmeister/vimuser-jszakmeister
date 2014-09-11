" Vim compiler file
" Based on nose.vim
" Compiler: Unit testing for Python using nose
" Maintainer: Olivier Le Thanh Duong <olivier@lethanh.be>
" Last Change: 2010 Sep 1

" Modified by lambdalisue
" Last Change: 2011 Dec 12

" Based on pyunit.vim distributed with vim
" Compiler: Unit testing tool for Python
" Maintainer: Max Ischenko <mfi@ukr.net>
" Last Change: 2004 Mar 27

" Modified by jszakmeister
" Last Change: 2014 Sept 11


if exists("current_compiler")
  finish
endif
let current_compiler = "nose"

if exists(":CompilerSet") != 2 " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet efm=%f:%l:\ fail:\ %m,%f:%l:\ error:\ %m

" Some differences with lambdalisue's nose.vim plugin: we don't include doctest
" by default, and the arguments are passed at the end to override anything set
" here.
CompilerSet makeprg=nosetests\ -q\ --with-machineout\ $*
