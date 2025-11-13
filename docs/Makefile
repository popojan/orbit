# Makefile for LaTeX/OpTeX documents

.PHONY: all clean formula gap primorial proof primorial-cs chebyshev-sqrt primal-forest primorial-valuation primorial-valuation-clean

all: formula-reference.pdf gap-theorem.pdf primorial-arxiv-draft.pdf primorial-recurrence-proof.pdf primorial-arxiv-draft-cs.pdf chebyshev-pell-sqrt-paper.pdf primal-forest-paper.pdf primorial-proof.pdf primorial-proof-clean.pdf

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

# Chebyshev-Pell square root paper
chebyshev-pell-sqrt-paper.pdf: chebyshev-pell-sqrt-paper.tex
	pdflatex -interaction=nonstopmode chebyshev-pell-sqrt-paper.tex
	pdflatex -interaction=nonstopmode chebyshev-pell-sqrt-paper.tex
	@echo "Generated: chebyshev-pell-sqrt-paper.pdf"

# Primal Forest educational paper
primal-forest-paper.pdf: primal-forest-paper.tex
	pdflatex -interaction=nonstopmode primal-forest-paper.tex
	pdflatex -interaction=nonstopmode primal-forest-paper.tex
	@echo "Generated: primal-forest-paper.pdf"

# Primorial p-adic valuation proof
primorial-proof.pdf: primorial-proof.tex
	pdflatex -interaction=nonstopmode primorial-proof.tex
	pdflatex -interaction=nonstopmode primorial-proof.tex
	@echo "Generated: primorial-proof.pdf"

# Primorial p-adic valuation proof (clean version)
primorial-proof-clean.pdf: primorial-proof-clean.tex
	pdflatex -interaction=nonstopmode primorial-proof-clean.tex
	pdflatex -interaction=nonstopmode primorial-proof-clean.tex
	@echo "Generated: primorial-proof-clean.pdf"

# Individual targets
formula: formula-reference.pdf
gap: gap-theorem.pdf
primorial: primorial-arxiv-draft.pdf
proof: primorial-recurrence-proof.pdf
primorial-cs: primorial-arxiv-draft-cs.pdf
chebyshev-sqrt: chebyshev-pell-sqrt-paper.pdf
primal-forest: primal-forest-paper.pdf
primorial-valuation: primorial-proof.pdf
primorial-valuation-clean: primorial-proof-clean.pdf

# Clean auxiliary files
clean:
	rm -f *.aux *.log *.out *.toc *.fls *.fdb_latexmk *.synctex.gz
	@echo "Cleaned auxiliary files"

# Clean everything including PDFs
distclean: clean
	rm -f formula-reference.pdf gap-theorem.pdf primorial-arxiv-draft.pdf primorial-recurrence-proof.pdf primorial-arxiv-draft-cs.pdf chebyshev-pell-sqrt-paper.pdf primal-forest-paper.pdf primorial-proof.pdf primorial-proof-clean.pdf
	@echo "Cleaned all generated files"
