# Makefile for papers

PAPERS = chebyshev-integral-identity primorial-formula chebyshev-sqrt-iteration \
         egyptian-fractions-telescoping fibonacci-fractions involution-decomposition \
         sign-cosine-identity lissajous-class-numbers chebyshev-pell-tower \
         beatty-ballot ruin-multinacci-bridge
PDFS = $(addsuffix .pdf,$(PAPERS))

.PHONY: all clean

all: $(PDFS)

%.pdf: %.tex references.bib
	pdflatex -interaction=nonstopmode $<
	bibtex $(basename $<)
	pdflatex -interaction=nonstopmode $<
	pdflatex -interaction=nonstopmode $<

clean:
	rm -f *.aux *.log *.out *.toc *.lof *.lot *.fls *.fdb_latexmk *.synctex.gz *.bbl *.blg
	rm -f $(PDFS)
