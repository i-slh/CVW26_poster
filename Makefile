# Makefile for LaTeX (pdflatex + bibtex)

# ---- Config ----
MAIN       = main
BIBFILE    = refs.bib
ENGINE     = pdflatex                 # or lualatex/xelatex
LATEXFLAGS = -interaction=nonstopmode -halt-on-error

# ---- Targets ----
.PHONY: all presentation clean distclean

all: $(MAIN).pdf

presentation: presentation.pdf

presentation.pdf: presentation.tex
	pdflatex $(LATEXFLAGS) presentation.tex
	pdflatex $(LATEXFLAGS) presentation.tex

# 1) First LaTeX pass: produces .aux, etc.
$(MAIN).aux: $(MAIN).tex
	$(ENGINE) $(LATEXFLAGS) $(MAIN).tex

# 2) BibTeX reads .aux, writes .bbl
# Depend on $(BIBFILE) so bibtex reruns when references.bib changes.
$(MAIN).bbl: $(MAIN).aux $(BIBFILE)
	bibtex $(MAIN)

# 3) Two more LaTeX passes to resolve citations/refs/outlines
$(MAIN).pdf: $(MAIN).tex $(MAIN).bbl
	$(ENGINE) $(LATEXFLAGS) $(MAIN).tex
	$(ENGINE) $(LATEXFLAGS) $(MAIN).tex

# ---- Housekeeping ----
clean:
	rm -f \
	  *.aux *.log *.out *.toc *.lof *.lot *.lol *.loa *.fls *.fdb_latexmk \
	  *.synctex.gz *.bbl *.blg *.bcf *.run.xml *.tdo *.nav *.snm *.Identifier\
	  *.loc *.soc

distclean: clean
	rm -f $(MAIN).pdf
