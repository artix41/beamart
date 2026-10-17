.PHONY: pdf

pdf:
	latexmk -cd -pdf -synctex=1 -interaction=nonstopmode -halt-on-error -file-line-error merlin/main.tex
