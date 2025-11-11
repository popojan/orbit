.PHONY: preview clean

DOCS := $(shell find . -name '*.md' -not -path './preview/*')
HTML := $(patsubst %.md,preview/%.html,$(DOCS))

preview: $(HTML)
	@echo "✓ All HTML previews generated in preview/"
	@xdg-open preview/README.html 2>/dev/null || open preview/README.html 2>/dev/null || echo "Please open preview/README.html manually"

preview/%.html: %.md
	@mkdir -p $(dir $@)
	@sed 's/\.md)/\.html)/g' $< | pandoc -f markdown -o $@ --mathjax --standalone --metadata title="$(notdir $(basename $<))"
	@echo "✓ Generated $@"

clean:
	rm -rf preview/
	@echo "✓ Cleaned preview files"
