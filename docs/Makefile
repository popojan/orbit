# Makefile for LaTeX/OpTeX documents

.PHONY: all clean formula gap primorial proof primorial-cs

all: formula-reference.pdf gap-theorem.pdf primorial-arxiv-draft.pdf primorial-recurrence-proof.pdf primorial-arxiv-draft-cs.pdf

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

# Primorial preprint
primorial-arxiv-draft.pdf: primorial-arxiv-draft.tex
	pdflatex -interaction=nonstopmode primorial-arxiv-draft.tex
	pdflatex -interaction=nonstopmode primorial-arxiv-draft.tex
	@echo "Generated: primorial-arxiv-draft.pdf"

# Primorial recurrence proof
primorial-recurrence-proof.pdf: primorial-recurrence-proof.tex
	pdflatex -interaction=nonstopmode primorial-recurrence-proof.tex
	pdflatex -interaction=nonstopmode primorial-recurrence-proof.tex
	@echo "Generated: primorial-recurrence-proof.pdf"

# Primorial preprint (Czech)
primorial-arxiv-draft-cs.pdf: primorial-arxiv-draft-cs.tex
	pdflatex -interaction=nonstopmode primorial-arxiv-draft-cs.tex
	pdflatex -interaction=nonstopmode primorial-arxiv-draft-cs.tex
	@echo "Generated: primorial-arxiv-draft-cs.pdf"

# Individual targets
formula: formula-reference.pdf
gap: gap-theorem.pdf
primorial: primorial-arxiv-draft.pdf
proof: primorial-recurrence-proof.pdf
primorial-cs: primorial-arxiv-draft-cs.pdf

# Clean auxiliary files
clean:
	rm -f *.aux *.log *.out *.toc *.fls *.fdb_latexmk *.synctex.gz
	@echo "Cleaned auxiliary files"

# Clean everything including PDFs
distclean: clean
	rm -f formula-reference.pdf gap-theorem.pdf primorial-arxiv-draft.pdf primorial-recurrence-proof.pdf primorial-arxiv-draft-cs.pdf
	@echo "Cleaned all generated files"
