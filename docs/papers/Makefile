# Makefile for papers

PAPERS = chebyshev-integral-identity primorial-formula chebyshev-sqrt-iteration
PDFS = $(addsuffix .pdf,$(PAPERS))

.PHONY: all clean

all: $(PDFS)

%.pdf: %.tex
	pdflatex -interaction=nonstopmode $<
	pdflatex -interaction=nonstopmode $<

clean:
	rm -f *.aux *.log *.out *.toc *.lof *.lot *.fls *.fdb_latexmk *.synctex.gz *.bbl *.blg
	rm -f $(PDFS)
