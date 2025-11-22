# Makefile for LaTeX/OpTeX documents
# Automatically compiles all .tex files in the directory

.PHONY: all clean distclean

# Find all .tex files in the current directory
TEX_SOURCES := $(wildcard *.tex)

PDFLATEX_SOURCES := $(TEX_SOURCES)

# Generate PDF targets
PDFLATEX_TARGETS := $(PDFLATEX_SOURCES:.tex=.pdf)

# All targets
ALL_TARGETS := $(PDFLATEX_TARGETS)

# Default target: compile all
all: $(ALL_TARGETS)

# Pattern rule for standard LaTeX documents (two passes for references)
%.pdf: %.tex
	@echo "Compiling $< (pass 1/2)..."
	@pdflatex -interaction=nonstopmode $< > /dev/null
	@echo "Compiling $< (pass 2/2)..."
	@pdflatex -interaction=nonstopmode $< > /dev/null
	@echo "✓ Generated: $@"

# Clean auxiliary files
clean:
	rm -f *.aux *.log *.out *.toc *.fls *.fdb_latexmk *.synctex.gz
	@echo "Cleaned auxiliary files"

# Clean everything including PDFs
distclean: clean
	rm -f $(ALL_TARGETS)
	@echo "Cleaned all generated files"

# Show what would be compiled
list:
	@echo "LaTeX sources (pdflatex):"
	@for src in $(PDFLATEX_SOURCES); do echo "  - $$src"; done
	@echo "Targets:"
	@for tgt in $(ALL_TARGETS); do echo "  - $$tgt"; done
