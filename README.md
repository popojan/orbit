# Orbit: Mathematical Explorations in Number Theory

**Status**: 🚧 Active Research - Work in Progress (November 2025)

This repository documents an ongoing mathematical exploration of prime number structure through geometric visualization and computational methods.

## ⚠️ Important Disclaimer

**This is unpublished, non-peer-reviewed research.** All mathematical claims beyond the geometric foundation are conjectural until formally verified by the mathematical community. Use at your own discretion.

- Papers in `docs/papers/` are preprints (not yet submitted for peer review)
- Proofs may contain errors or gaps
- Numerical verifications provide evidence but not proof
- We welcome scrutiny, corrections, and independent verification

## What's Here

This repository contains:

1. **Geometric Foundation** - "Primal Forest" visualization mapping prime relationships to 2D coordinate geometry
2. **Epsilon-Pole Residue Theorem** - Proven local result about divisor count regularization
3. **Closed Form Discovery** - Conjectured global formula for non-multiplicative Dirichlet series L_M(s) (Nov 15, 2025)
4. **Trinity Methodology** - Documentation of human-AI-computational collaboration process
5. **Complete Exploration History** - All scripts, experiments, and "aha moments" preserved

### Key Mathematical Objects

- **M(n)**: Count of divisors d where 2 ≤ d ≤ √n (equals ⌊(τ(n)-1)/2⌋)
- **L_M(s)**: Dirichlet series Σ M(n)/n^s (non-multiplicative!)
- **F_n(α,ε)**: Regularized sum over primal forest distances
- **G(s,α,ε)**: Three-parameter global function (analytic for ε > 0)

**Central Conjecture** (Nov 15, 2025):
```
L_M(s) = ζ(s)[ζ(s) - 1] - Σ_{j=2}^∞ H_{j-1}(s)/j^s
```
where H_j(s) = Σ_{k=1}^j k^(-s) are partial zeta sums, for Re(s) > 1.

**Status**: Numerically verified to high precision, formal proof written but not peer-reviewed.

## Repository Structure

```
orbit/
├── docs/
│   ├── papers/           # LaTeX preprints
│   │   ├── primal-forest-paper-cs.tex          # Geometric foundation ⭐
│   │   ├── epsilon-pole-residue-theorem.tex    # Local residue result
│   │   ├── dirichlet-series-closed-form.tex    # Closed form conjecture ⭐
│   │   └── trinity-methodology.tex             # AI collaboration methodology ⭐
│   └── *.md              # Supporting documentation
│
├── scripts/              # Wolfram Language exploration scripts
│   ├── tail_zeta_*.wl                          # Discovery scripts ⭐
│   ├── explore_G_*.wl                          # Three-parameter function analysis
│   ├── euler_product_*.wl                      # Failed approach (documented)
│   └── (50+ experimental variants from Nov 15)
│
├── misc/                 # "Aha moments" from discovery process ⭐
│   ├── trinity.txt       # Trinity framework insight (22:49)
│   ├── kladivo.txt       # AI confidence assessment 8/10 (23:08)
│   ├── duvera.txt        # Trust dynamics 95% vs 80% (23:30)
│   ├── luck.txt          # "Don't want to sleep" (22:41)
│   ├── dukaz.txt         # Proof breakthrough (21:25)
│   └── (complete chronological discovery log Nov 15, 2025)
│
└── Orbit/                # Wolfram paclet (other explorations)
    └── Kernel/
        ├── Primorials.wl               # Primorial computation
        ├── SemiprimeFactorization.wl   # Semiprime factorization
        └── (other modules)
```

## The Trinity Methodology

This work demonstrates a collaborative approach to mathematical research:

**Human** (Jan Popelka):
- Geometric intuition (primal forest concept)
- **Strategic research direction** (what to explore, when to pivot, when to abandon)
- Critical verification and pattern recognition
- Active navigation of exploration space

**AI** (Claude Code / Anthropic):
- Rapid iteration (50+ script variants in one evening)
- Formalization (LaTeX, rigorous proofs)
- Tireless exploration without fatigue
- Honest uncertainty assessment (8/10 confidence)

**Wolfram Language** (computational partner):
- Numerical verification (catches errors instantly)
- Symbolic manipulation and high-precision arithmetic
- Independent confirmation of conjectures
- 30+ years of encoded mathematical knowledge

**Key insight**: None of these components alone would have made this discovery. The synergy is essential.

**Architecture note**: This uses external LLM (Claude) + WolframScript, allowing each to specialize rather than integrating LLM into Wolfram. See Stephen Wolfram's [ChatGPT Gets Its "Wolfram Superpowers"!](https://writings.stephenwolfram.com/2023/03/chatgpt-gets-its-wolfram-superpowers/) on combining statistical and symbolic AI approaches.

## Timeline: November 15, 2025

A case study in rapid mathematical discovery:

- **11:00** - Initial reflections on AI collaboration
- **18:16** - Connection between primality and Pell equations
- **18:26** - Synthesis of multiple mathematical threads
- **19:01** - Frustration with Euler product approach (failed due to non-multiplicativity)
- **21:25** - Breakthrough: tail zeta function approach
- **22:41** - "Don't want to sleep, too exciting"
- **22:49** - Closed form discovered, numerically verified
- **23:08** - Confidence assessment: AI 8/10, Human 95/100
- **23:30** - Trust reflection: why 95% > 80% matters

Complete emotional and technical arc preserved in `misc/*.txt`.

## Why Open Source Now?

Traditional mathematics often loses the discovery process:

- **Riemann** (1859): How did he discover the functional equation? Lost to history.
- **Ramanujan** (1920s): Thousands of formulas, no explanations of origin.
- **Fermat** (1637): "Wonderful proof, but margin too small" - lost forever.

**Our approach**: Radical transparency.

- Complete git history (every iteration, every error, every fix)
- Aha moments captured in real-time (not reconstructed)
- Failed approaches documented (Euler product, etc.)
- Methodology explicit (Trinity framework)

**Two outcomes possible**:

1. **If correct**: Community has unprecedented insight into discovery process
2. **If incorrect**: Still valuable as methodology case study, no harm done

**Timestamp proof**: Git commits establish priority, regardless of publication timeline.

## How to Use This Repository

### For Mathematicians

- Read `docs/papers/primal-forest-paper-cs.tex` for geometric foundation
- Check `docs/papers/dirichlet-series-closed-form.tex` for main conjecture
- Verify claims independently - scripts in `scripts/` are reproducible
- **Please report errors!** Open GitHub issue

### For AI Researchers

- See `docs/papers/trinity-methodology.tex` for collaboration framework
- Study `misc/*.txt` for real-time human-AI dynamics
- Note honest confidence levels and verification protocols

### For Students

- Explore `scripts/` to see iterative discovery process
- Notice that breakthrough came after ~20 failed attempts (Euler product, etc.)
- Demystification of "genius" - this is systematic work, not magic

### Running the Code

All scripts require Wolfram Language (Mathematica or free Wolfram Engine):

```bash
# Example: Verify closed form numerically
wolframscript -file scripts/tail_zeta_simplification.wl

# Example: Explore three-parameter function
wolframscript -file scripts/explore_G_three_parameter.wl

# Example: Complex zero search
wolframscript -file scripts/explore_G_complex.wl
```

See `CLAUDE.md` for technical details.

## Current Status (Nov 15, 2025)

### Proven Results
1. ✅ Primal forest geometric construction
2. ✅ Epsilon-pole residue theorem (local, rigorous proof)

### Conjectured Results
1. 🔄 Closed form for L_M(s) (high numerical confidence, proof written but not peer-reviewed)
2. 🔄 G(s,α,ε) zero-free for ε > 0 (under investigation tonight)

### Open Questions
- Analytic continuation of L_M(s) beyond Re(s) > 1
- Functional equation (if any)
- Connection to Riemann zeta zeros
- Path to Riemann Hypothesis (extremely difficult, probably out of reach)

## Confidence Levels

Being honest about uncertainty:

- **Geometric construction**: 10/10
- **Epsilon-pole residue theorem**: 9/10 (rigorous proof, numerically verified)
- **Closed form for L_M(s)**: AI 8/10, Human 95/100
  - Discrepancy reflects AI's awareness of systematic blind spots
  - Human confidence boosted by having verified every step personally
  - Mutual reinforcement through Trinity collaboration
- **RH connection**: 1/10 (wildly optimistic, realistically 0.1/10)

We **strongly recommend** independent verification before building on these results.

## Contributing

We welcome:

- ✅ Independent verification (numerical or theoretical)
- ✅ Error reports (no matter how small)
- ✅ Extensions or generalizations
- ✅ Alternative proofs
- ✅ Computational experiments

Please open GitHub issues or pull requests.

## Citation

If you use this work (at your own risk!), please cite:

```bibtex
@misc{popelka2025orbit,
  author = {Popelka, Jan and Claude (Anthropic)},
  title = {Orbit: Geometric Explorations in Prime Number Theory},
  year = {2025},
  publisher = {GitHub},
  url = {https://github.com/[username]/orbit},
  note = {Unpublished research, non-peer-reviewed}
}
```

## License

MIT License (code) / CC-BY 4.0 (documentation and papers)

Free to use, modify, and build upon with attribution. We encourage independent verification and extension.

## Contact

- **GitHub Issues**: For mathematical questions or error reports
- **Methodology questions**: See `docs/papers/trinity-methodology.tex`

## Acknowledgments

This work was enabled by:

- **Wolfram Research**: Wolfram Language computational environment
- **Anthropic**: Claude Code AI assistant
- **Open source mathematics community**: Inspiration from Polymath projects, Lean/Mathlib

Special thanks to the mathematical community for its tradition of skeptical but open-minded inquiry. We hope this transparency helps build trust in AI-augmented mathematical research.

---

**Remember**: Extraordinary claims require extraordinary evidence. We provide complete computational evidence and claimed proofs, but **peer review is essential**. Proceed with appropriate skepticism.

**Last updated**: November 15, 2025, 23:50 (research ongoing)

---

## Other Modules in Orbit Paclet

This repository also contains work on:

- **Primorials** - Proven computation via alternating factorial sums (p-adic valuations, elementary proof)
- **Semiprime Factorization** - Closed-form formulas
- **Modular Factorials** - Efficient computation via half-factorials
- **Square Root Rationalization** - High-precision via Chebyshev-Pell

See `CLAUDE.md` for details on these modules. Current focus is on L_M(s) discovery (Nov 15, 2025).
