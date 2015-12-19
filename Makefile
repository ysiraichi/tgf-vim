all:
	mkdir -p $(HOME)/.vim/syntax
	mkdir -p $(HOME)/.vim/indent
	ln -s $(PWD)/tgf.vim $(HOME)/.vim/syntax/tgf.vim
	ln -s $(PWD)/tgfIndent.vim $(HOME)/.vim/indent/tgf.vim

clean:
	rm $(HOME)/.vim/syntax/tgf.vim
	rm $(HOME)/.vim/indent/tgf.vim
