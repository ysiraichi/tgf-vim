VIMhm=$(HOME)/.vim
all:
	mkdir -p $(VIMhm)/syntax $(VIMhm)/indent
	cp $(PWD)/tgf.vim         $(VIMhm)/syntax/tgf.vim
	cp $(PWD)/tgfIndent.vim   $(VIMhm)/indent/tgf.vim

clean:
	rm $(VIMhm)/syntax/tgf.vim
	rm $(VIMhm)/indent/tgf.vim
