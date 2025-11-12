# Makefile for LaTeX/OpTeX documents

.PHONY: all clean formula gap

all: formula-reference.pdf gap-theorem.pdf

# Standard LaTeX document
formula-reference.pdf: formula-reference.tex
	pdflatex -interaction=nonstopmode formula-reference.tex
	@echo "Generated: formula-reference.pdf"

# OpTeX document (requires OpTeX v1.18+)
# Compile with: luahbtex -fmt optex gap-theorem
gap-theorem.pdf: gap-theorem.tex
	@echo "Compiling with OpTeX v1.18..."
	luahbtex -fmt optex gap-theorem.tex
	@echo "Generated: gap-theorem.pdf"

# Individual targets
formula: formula-reference.pdf
gap: gap-theorem.pdf

# Clean auxiliary files
clean:
	rm -f *.aux *.log *.out *.toc *.fls *.fdb_latexmk *.synctex.gz
	@echo "Cleaned auxiliary files"

# Clean everything including PDFs
distclean: clean
	rm -f formula-reference.pdf gap-theorem.pdf
	@echo "Cleaned all generated files"
