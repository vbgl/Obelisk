SRC=src
DOC=docs
MISC=misc
TARGET=native
MAIN=main.$(TARGET)
EXE=obelisk
VERSION=0.3.1
CC=ocamlbuild
FLAGS=-use-menhir -use-ocamlfind -pkgs str -Is $(SRC),$(SRC)/helpers
PARSER=$(SRC)/parser.mly
RECO=$(MISC)/reco.mly
IMAGES=tabular syntax backnaur
PREFIX=my

.PHONY: all latex html default reco readme doc tests clean cleandoc install uninstall

all: opam
	@$(CC) $(FLAGS) $(SRC)/$(MAIN)
	@mv $(MAIN) $(EXE)

%.tex:
	@./$(EXE) latex -prefix $(PREFIX) -$* $(PARSER) -o $@

%.pdf: %.tex
	@pdflatex -interaction batchmode $<

%.png: %.pdf
	@convert -density 150 $< -format png $(MISC)/$@
	@rm -f $*.tex $< $*.aux $*.log

latex: all $(IMAGES:%=%.png)

html: all
	@./$(EXE) html $(PARSER) -o test.html
	@wkhtmltoimage -f png --width 800 test.html $(MISC)/html.png
	@rm -f test.html

default:
	@echo -e "\nDefault output on $(PARSER):"
	@./$(EXE) $(PARSER)

reco:
	@echo -e "\nDefault output on $(RECO):"
	@./$(EXE) $(RECO)
	@echo -e "\nDefault output on $(RECO) with '-i' switch:"
	@./$(EXE) -i $(RECO)

readme: latex html default reco

doc: cleandoc $(DOC)/$(EXE).odocl $(DOC)/doc.css
	@$(CC) $(FLAGS) $(DOC)/$(EXE).docdir/index.html
	@cp $(EXE).docdir/*.html $(DOC)
	@rm -f $(EXE).docdir

opam: Makefile
	@sed -e "s/%%VERSION%%/$(VERSION)/"\
       -e "s/%%NAME%%/$(EXE)/" < $@.in > $@

tests: all
	@$(MAKE) -C $@

cleandoc:
	@rm -rf $(DOCS)/*.html

clean: cleandoc
	@$(CC) -clean
	@$(MAKE) -C tests $@

install: all
	echo $(BINDIR)
	@mkdir -p $(BINDIR)
	@install $(EXE) $(BINDIR)/$(EXE)

uninstall:
	@rm -f $(BINDIR)/$(EXE)
