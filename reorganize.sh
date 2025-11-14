#!/bin/bash
# Repository reorganization script
# Run from orbit/ root directory

set -e  # Exit on error

echo "════════════════════════════════════════════════════════════"
echo "ORBIT REPOSITORY REORGANIZATION"
echo "════════════════════════════════════════════════════════════"
echo ""

# Create new directory structure
echo "Creating directory structure..."
mkdir -p docs/papers
mkdir -p docs/modules
mkdir -p docs/active
mkdir -p docs/archive
mkdir -p scripts/archive
mkdir -p misc

echo "✓ Directories created"
echo ""

# ============================================================================
# 1. MOVE MISC/MYSTERIOUS FILES TO misc/
# ============================================================================
echo "Moving miscellaneous files to misc/..."

# Mysterious text files
[ -f misto.txt ] && mv misto.txt misc/
[ -f docs/backdoors.txt ] && mv docs/backdoors.txt misc/
[ -f docs/BEG.txt ] && mv docs/BEG.txt misc/
[ -f docs/softice.txt ] && mv docs/softice.txt misc/
[ -f docs/primorial-as-a-sieve.txt ] && mv docs/primorial-as-a-sieve.txt misc/

# Unrelated scripts and chat examples
[ -f angle.wl ] && mv angle.wl misc/
[ -f fast-sqrt.wl ] && mv fast-sqrt.wl misc/
[ -f horcrux.wl ] && mv horcrux.wl misc/

echo "✓ Miscellaneous files moved"
echo ""

# ============================================================================
# 2. DELETE DUPLICATE .wl FILES FROM ROOT (if any remain)
# ============================================================================
echo "Deleting any remaining duplicate .wl scripts from root..."

rm -f *.wl

echo "✓ Root .wl files deleted"
echo ""

# ============================================================================
# 3. ORGANIZE DOCUMENTATION
# ============================================================================

# 3a. Move module documentation
echo "Moving module documentation to docs/modules/..."
mv docs/primorial-formula.md docs/modules/
mv docs/modular-factorials.md docs/modules/
mv docs/chebyshev-pell-sqrt-framework.md docs/modules/
mv docs/semiprime-factorization.md docs/modules/ 2>/dev/null || true
mv docs/prime-dag-gap-theorem.md docs/modules/

echo "✓ Module docs moved"
echo ""

# 3b. Move session notes to archive
echo "Moving session notes to docs/archive/..."
mv docs/complex-extension-analysis.md docs/archive/
mv docs/computational-utility-analysis.md docs/archive/
mv docs/quantum-primorial-analysis.md docs/archive/
mv docs/quantum-primal-forest-analysis.md docs/archive/

echo "✓ Session notes archived"
echo ""

# 3c. Move WIP files to docs/active/
echo "Moving work-in-progress files to docs/active/..."
mv docs/primorial-duality.tex docs/active/
mv docs/primorial-duality-correction.tex docs/active/ 2>/dev/null || true
mv docs/phd-roadmap.md docs/active/
mv docs/proof-development-plan.md docs/active/

echo "✓ WIP files moved"
echo ""

# 3d. Move ALL papers (.tex + .pdf) to docs/papers/
echo "Moving papers to docs/papers/..."
mv docs/*.tex docs/papers/ 2>/dev/null || true
mv docs/*.pdf docs/papers/ 2>/dev/null || true

echo "✓ Papers moved"
echo ""

# 3e. Archive remaining docs (discovery notes, corrections, etc.)
echo "Archiving remaining documentation..."
mv docs/*.md docs/archive/ 2>/dev/null || true

echo "✓ Remaining docs archived"
echo ""

# ============================================================================
# 4. ORGANIZE SCRIPTS
# ============================================================================

echo "Archiving exploratory scripts to scripts/archive/..."

# Archive all explore_* and investigate_* (clearly one-offs)
mv scripts/explore_*.wl scripts/archive/ 2>/dev/null || true
mv scripts/investigate_*.wl scripts/archive/ 2>/dev/null || true

# Archive old search/analysis variants
mv scripts/search_gap_theorem_*.wl scripts/archive/ 2>/dev/null || true
mv scripts/analyze_2adic_pairings.wl scripts/archive/ 2>/dev/null || true
mv scripts/analyze_2k_plus_1_pattern.wl scripts/archive/ 2>/dev/null || true

# Archive comparison scripts (results documented)
mv scripts/*comparison*.wl scripts/archive/ 2>/dev/null || true
mv scripts/*benchmark*.wl scripts/archive/ 2>/dev/null || true
mv scripts/fair_*.wl scripts/archive/ 2>/dev/null || true
mv scripts/*m1_*.wl scripts/archive/ 2>/dev/null || true

# Archive old proof attempt scripts
mv scripts/*recurrence*.wl scripts/archive/ 2>/dev/null || true
mv scripts/*reduced*.wl scripts/archive/ 2>/dev/null || true
mv scripts/*unreduced*.wl scripts/archive/ 2>/dev/null || true

# Archive numerator analysis (findings documented)
mv scripts/analyze_numerator*.wl scripts/archive/ 2>/dev/null || true
mv scripts/attack_numerator*.wl scripts/archive/ 2>/dev/null || true
mv scripts/*numerator*.wl scripts/archive/ 2>/dev/null || true

# Archive Egyptian fraction explorations
mv scripts/egyptian_*.wl scripts/archive/ 2>/dev/null || true

# Archive zeta/RH explorations
mv scripts/*zeta*.wl scripts/archive/ 2>/dev/null || true
mv scripts/factorial_sum_zeta*.wl scripts/archive/ 2>/dev/null || true
mv scripts/hypergeometric*.wl scripts/archive/ 2>/dev/null || true
mv scripts/cf_primorial*.wl scripts/archive/ 2>/dev/null || true

# Archive old verification variants (keep only one main one)
mv scripts/verify_primorial_exhaustive.wl scripts/archive/
mv scripts/verify_primorial_large_scale.wl scripts/archive/
mv scripts/verify_primorial_with_progress.wl scripts/archive/
# Keep: verify_primorial_resumable.wl, verify_primorial_parallel.wl, verify_primorial_complete.wl

echo "✓ Exploratory scripts archived"
echo ""

# ============================================================================
# 5. SUMMARY
# ============================================================================

echo "════════════════════════════════════════════════════════════"
echo "REORGANIZATION COMPLETE"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "New structure:"
echo "  docs/"
echo "    papers/          - All .tex and .pdf papers"
echo "    modules/         - Module documentation for Orbit paclet"
echo "    active/          - Current work-in-progress"
echo "    archive/         - Discovery notes, session work, corrections"
echo ""
echo "  scripts/"
echo "    (30-40 active verification/utility scripts)"
echo "    archive/         - Exploratory/one-off scripts"
echo ""
echo "  misc/              - Mysterious/unrelated files (gitignored)"
echo ""
echo "Files gitignored: *.log, *.mx, verification_*.txt, misc/"
echo ""
echo "Next steps:"
echo "  1. Review the new structure"
echo "  2. Test that everything works"
echo "  3. git add -A && git commit -m \"refactor: reorganize repository structure\""
echo ""
