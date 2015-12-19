## Pure-Functional Tiger Language - Vim Extention

These two files highlights and indents tgf (this language) files.

#### Installation

In order to install, execute the following command:

```sh
$ make
```

And add the following line to your .vimrc:

```vim
au BufRead,BufNewFile *.tgf set filetype=tgf
```

