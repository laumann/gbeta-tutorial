GBTUT	= gbeta-tutorial

all: gbeta-tutorial stats

gbeta-tutorial: $(GBTUT).aux $(GBTUT).bbl $(GBTUT).blg $(GBTUT).tex
	latex $(GBTUT)
	latex $(GBTUT)

stats: $(GBTUT).tex
	@echo "Word Count:"
	@echo -e "Words:        `detex $(GBTUT).tex | wc -w`"
	@echo -e "Characters:   `detex gbeta-tutorial.tex | wc -c`"
	@echo -e "Lines:        `detex gbeta-tutorial.tex | wc -l`"

$(GBTUT).bbl $(GBTUT).blg:
	bibtex $(GBTUT)

$(GBTUT).aux $(GBTUT).dvi:
	latex $(GBTUT)

## View command - uses gv (GhostScript viewer)
view: $(GBTUT).ps
	@gv $(GBTUT).ps

$(GBTUT).ps: $(GBTUT).dvi
	@dvips $(GBTUT)

clean:
	@rm -rfv $(GBTUT).dvi
	@rm -rfv $(GBTUT).log
	@rm -rfv $(GBTUT).blg
	@rm -rfv $(GBTUT).toc
	@rm -rfv $(GBTUT).bbl
	@rm -rfv $(GBTUT).ps
	@rm -rfv $(GBTUT).aux
	@rm -rfv $(GBTUT).d
	@rm -rfv *~