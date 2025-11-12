# PhD Application Roadmap

**Goal**: Prepare materials and make contact for PhD program in Number Theory at Charles University, Prague

**Target supervisor**: Vít Kala (MFF Charles University) - algebraic and computational number theory

**Timeline**: Sprint goal ~2-4 weeks

---

## Sprint 1: arXiv Preprint (Week 1-2)

### Phase 1: Draft Paper ✓ Ready to Start

- [ ] **AI assistant drafts LaTeX paper** (2-3 pages)
  - Based on `docs/primorial-mystery-findings.md` and `docs/primorial-formula.md`
  - Title: "A Primorial Formula via Alternating Factorial Sums"
  - Structure:
    - Abstract (computational discovery + open problem)
    - Introduction (how discovered, why interesting)
    - The formula with examples
    - Cancellation problem (prime powers → p¹)
    - Computational verification
    - Open questions (formal problem statement)
  - Include link to GitHub: github.com/popojan/orbit

- [ ] **Review and edit draft**
  - Add personal touches
  - Verify mathematical accuracy
  - Check English/style
  - Ensure comfortable with all claims

- [ ] **Prepare supplementary materials**
  - Clean up repo (if needed)
  - Ensure scripts run correctly
  - Add README sections if helpful

### Phase 2: Get Endorsement

- [ ] **Draft email to Vít Kala**
  - Subject: "Computational NT discovery + PhD inquiry"
  - Contents:
    - Introduction (who you are: programmer/data scientist interested in NT)
    - Brief description of primorial formula discovery
    - Request for arXiv endorsement (math.NT category)
    - Express interest in PhD supervision
    - Attach/link to draft paper and GitHub
  - **Tone**: Professional but genuine about computational approach

- [ ] **Send email to Vít Kala**
  - Email: (look up on MFF website)
  - Attach: PDF of draft paper
  - Include: GitHub link

- [ ] **Alternative endorsement paths** (if Kala unavailable)
  - MathOverflow meta (request endorsement)
  - Other Czech mathematicians in NT
  - arXiv endorsement requests

### Phase 3: Submit to arXiv

- [ ] **Register arXiv account**
  - https://arxiv.org/user/register
  - Use popojan@protonmail.com

- [ ] **Prepare submission materials**
  - LaTeX source (.tex file)
  - Any figures (if added)
  - Bibliography (.bib or embedded \bibitem)

- [ ] **Submit to arXiv**
  - Primary category: math.NT (Number Theory)
  - Optional secondary: cs.SC (Symbolic Computation) or math.CO
  - Wait for moderation (usually 1 business day)

- [ ] **Receive arXiv ID**
  - Format: arXiv:YYMM.NNNNN
  - Note it down for future reference

---

## Sprint 2: Community Engagement (Week 2-3)

### Option A: MathOverflow

- [ ] **Post question on MathOverflow**
  - Title: "Primorial formula via alternating factorial sum: why do higher prime powers cancel?"
  - Link to arXiv paper
  - Include formula inline
  - Ask specific question about p-adic valuation
  - Tag: [number-theory], [prime-numbers], [computational-mathematics]

- [ ] **Monitor responses**
  - Engage with comments
  - Clarify if needed
  - Document any insights

### Option B: Lean/Formal Methods Community

- [ ] **Post to Lean Zulip**
  - Stream: #mathematics or #new members
  - Smaller community, formalization-focused
  - Ask about formalization approach

- [ ] **Consider Gauss AI submission**
  - Use draft from `docs/gauss-submission-draft.md`
  - Only if community doesn't provide proof direction
  - Decision point: after 1-2 weeks on MO/Lean

### Option C: Direct Mathematician Contact

- [ ] **If Kala responds positively**: Ask for feedback on problem
- [ ] **Other contacts**: Terence Tao (long shot), other NT researchers

---

## Sprint 3: PhD Application Materials (Week 3-4)

### Core Material (This Project)

- [x] Orbit paclet with modular structure
- [x] Three mathematical exploration modules (primorials, semiprimes, modular factorials)
- [x] Computational verification scripts
- [x] Documentation with theoretical connections
- [ ] arXiv preprint (in progress)
- [ ] Possible MathOverflow discussion/responses

### Supporting Material (Existing Work)

Document these as **additional computational NT explorations**:

- [ ] **Egyptian fractions work** (in `github.com/popojan/egypt`)
  - **Full Wolfram Language paclet**: `Egypt.wl` with multiple algorithms
    - `EgyptianFractions[q]` - convert rationals to Egyptian representation
    - `EgyptianSqrtApproximate[n]` - square root approximation via Egyptian fractions
    - Connection to **continued fractions** (CF integration)
    - Modular arithmetic and algorithmic optimizations
  - **Rust implementation**: `src/main.rs` - dual language implementation shows depth
  - Square root computation via Egyptian fraction sums
  - Connection to **Pell equations** $x^2 - ny^2 = 1$
  - Recursive formula $a(n,i)$ with convergence to $\sqrt{n}$
  - Example doc: `egypt/doc/sqrt.pdf` (clean presentation style!)
  - **Shows**: computational approach + classical NT (Pell, CF) + algorithmic number theory + dual-language implementation

- [ ] **Other materials to inventory**
  - Check `egypt/sqrt/` directory (factor.pdf, other work?)
  - Check if there are other repos with NT explorations
  - Any notebooks with interesting results?

**Format**: Could be:
- Separate GitHub repos (linked in CV/application)
- Additional sections in orbit repo
- Brief writeup (1 page each) describing the work
- Just code + README if time-limited

**Purpose**: Show breadth of computational NT experience, not formal publication

### Application Package (When Ready)

- [ ] **CV/Resume**
  - Education background
  - Programming/data science experience
  - Mathematical explorations (with arXiv link, GitHub links)
  - Relevant skills (Wolfram Language, computational methods)

- [ ] **Statement of purpose**
  - Why number theory
  - Why computational approach
  - Why Charles University / Vít Kala
  - Research interests
  - This primorial work as example

- [ ] **Check PhD program requirements**
  - Application deadlines
  - Required documents
  - Language requirements (Czech/English?)
  - Formal prerequisites

---

## Additional Publication-Ready Topics (New)

Beyond the primorial formula, several other discoveries have emerged with publication potential:

### 1. Chebyshev-Pell Square Root Rationalization **✨ Performance Breakthrough** ✅ PAPER COMPLETE

**Status**: ✅ Academic paper drafted and ready for submission (November 2025)

**What it is**:
- Ultra-high precision rational approximations to square roots via nested Chebyshev polynomials and Pell equations
- **Performance**: Beats Mathematica's Rationalize by 3-10× for precision >200 digits
- Super-quadratic convergence: ~10x precision per iteration (balanced), up to 6000x (optimized)
- **Extreme precision demonstrated**: 62 million digit rational approximation to √13

**Mathematical novelty**:
- Novel sqrttrf formula with **imaginary cancellation mechanism** (ChebyshevU ratio with complex arguments yields rational)
- Optimized closed forms for m=1,2 (20x speedup, eliminate symbolic computation)
- Fixed-point characterization of Pell solutions via Chebyshev series rationality
- Evolved from earlier Egyptian fraction explorations (egypt repository)

**Documentation**:
- Full LaTeX paper: `docs/chebyshev-pell-sqrt-paper.tex`
- Technical docs: `docs/chebyshev-pell-sqrt-framework.md`
- Summary: `docs/chebyshev-pell-sqrt-paper-summary.md`
- Build: `make chebyshev-sqrt` (in docs/)

**Submission venues** (in priority order):

**Primary targets:**
1. **arXiv cs.SC (Symbolic Computation)** - Fastest path, computational focus
   - Alternative: arXiv math.NT (Number Theory) - More theoretical emphasis
   - Timeline: Can submit immediately after local review

2. **Journal of Symbolic Computation** - Top venue for this work
   - Focus: Computational efficiency, algorithm design
   - Impact factor: 0.6, but highly respected in community
   - Review time: ~4-6 months

3. **Mathematics of Computation** - Prestigious computational math journal
   - Focus: Rigorous analysis + practical performance
   - Impact factor: 2.0
   - Review time: ~6-9 months
   - Note: May require more theoretical convergence proofs

**Secondary targets:**
4. **ACM Communications in Computer Algebra** - Quick publication
   - Focus: Implementation and benchmarks
   - Format: Short papers (4-8 pages)
   - Review time: ~2-3 months

5. **Experimental Mathematics** - Empirical discoveries
   - Focus: Computational exploration + conjectures
   - Good fit for fixed-point characterization
   - Review time: ~4-6 months

**Conference options:**
6. **ISSAC (International Symposium on Symbolic and Algebraic Computation)** - Premier conference
   - Deadline: Usually January for July conference
   - Proceedings published by ACM
   - Highly competitive but high visibility

7. **CASC (Computer Algebra in Scientific Computing)** - European conference
   - Less competitive than ISSAC
   - Published in Springer LNCS
   - Good audience for this work

**Recommended strategy:**
1. **Immediate**: Submit to arXiv (cs.SC or math.NT)
2. **Week 1-2**: Compile locally, final review, arXiv submission
3. **Week 2-3**: Submit to Journal of Symbolic Computation (primary target)
4. **Backup**: If rejected, try Mathematics of Computation or Experimental Mathematics
5. **Conference**: Submit to ISSAC 2026 if timing works out

**Timeline**: arXiv-ready NOW, journal submission within 2 weeks

### 2. Chebyshev Visualization: "Infinite Interference" **🎨 Mathematical Art**

**Status**: Fully documented, ready for visualization-focused publication

**What it is**:
- Family of curves $f_k(x) = T_{k+1}(x) - x \cdot T_k(x)$ inscribed in unit circle
- Each curve touches at exactly k+1 points (regular polygon vertices)
- Contact points rotated by -π/(2k) from standard position
- Unit integral norm: ∫|f_k| dθ = 1 for all k

**Mathematical novelty**:
- Explicit rotation angle formula (not arbitrary - intrinsic to polynomial structure)
- Complex number formulation via conjugate differences (Binet-like)
- Connection to cyclotomic polynomials and DFT
- Beautiful n-star patterns with deep theory

**Documentation**: `docs/chebyshev-visualization.md`
**Live demo**: https://www.shadertoy.com/view/MXc3Rj

**Publication angle**:
- Mathematical visualization journal (Journal of Mathematics and the Arts)
- Recreational mathematics (American Mathematical Monthly notes section)
- Could accompany Chebyshev-Pell paper as "companion piece"
- Gallery/poster submission to JMM or similar conference

**Timeline**: Gallery-ready now, paper could be written in days

### 3. Semiprime Factorization via Pochhammer Sums

**Status**: Complete, clean closed form

**What it is**:
- Closed-form factorization of semiprimes using fractional parts
- Works for all semiprimes n = p×q where p ≥ 3
- Uses Pochhammer symbol structure

**Documentation**: `docs/semiprime-factorization.md`

**Publication angle**:
- Experimental mathematics journal
- Could be note in Integers or similar
- Possibly interesting to cryptography community (though not practical for RSA)

**Timeline**: Could be written up quickly if needed

### 4. Modular Factorial Computation

**Status**: Complete, efficient algorithm

**What it is**:
- Efficient n! mod p using half-factorial structure
- Connection to Gauss sums and Stickelberger relation

**Documentation**: `docs/modular-factorials.md`

**Publication angle**:
- Algorithmic number theory venue
- Could be combined with other modular arithmetic work

**Timeline**: Lower priority, many existing algorithms in this space

### 5. Prime DAG and Gap Theorem

**Status**: Proven and verified for primes up to 1M

**What it is**:
- Prime structure via greedy additive decomposition
- Gap Theorem: gap after p equals children in DAG

**Documentation**: `docs/prime-dag-gap-theorem.md`, `CLAUDE.md`

**Publication angle**:
- More exploratory, might need deeper theoretical framework
- Could be part of broader "computational prime structure" paper

**Timeline**: Longer-term research program

---

## Recommended Publication Strategy

**Immediate (next 2-4 weeks)** - ✅ IN PROGRESS:
1. ✅ **Chebyshev-Pell sqrt paper** - COMPLETE, ready for arXiv submission
   - Target: arXiv cs.SC → Journal of Symbolic Computation
   - Shows: Computational expertise, algorithmic innovation, performance optimization
   - Status: Paper drafted, polished, committed to repository

2. **Primorial formula** - arXiv → PhD application centerpiece (NEXT)
   - Target: arXiv math.NT → journal TBD after proof progress
   - Shows: Mathematical discovery, problem formulation, open questions
   - Status: Awaiting draft

**Medium-term (2-3 months)**:
3. **Chebyshev visualization** - Gallery/poster submission + short paper
4. **Semiprime factorization** - Brief note or combined paper

**Longer-term (6-12 months, during PhD if accepted)**:
5. **Prime DAG structure** - Deeper exploration with advisor
6. **Comprehensive "computational explorations" paper** - Umbrella publication

**Updated rationale**:
- **Chebyshev-Pell now ready first** - Strong computational contribution, clear performance results
- Lead with concrete achievement (working algorithm, benchmarked)
- Follow with primorial formula (open problem, but shows discovery process)
- Two papers demonstrate both problem-solving AND problem-finding abilities
- Shows versatility: algorithmic optimization + mathematical discovery

---

## Further Mathematical Exploration (Ongoing)

While waiting for responses, continue exploring:

### Primorial Formula Deep Dives

From earlier suggestions:

- [ ] **Track p-adic valuations step-by-step**
  - Write script following ν_p(numerator) and ν_p(denominator) through partial sums
  - Look for telescoping patterns
  - See if Legendre's formula reveals structure

- [ ] **Examine numerator patterns**
  - Why are many numerators prime? (k=3,4,5 have prime numerators)
  - Is there a pattern to when numerators are prime vs composite?
  - Factor all numerators up to k=100

- [ ] **Modular analysis**
  - Compute partial sums mod p² for various primes
  - Look for vanishing higher terms
  - Connection to Wilson's theorem or Wolstenholme?

- [ ] **Generalization attempts**
  - Change coefficients: what if (-1)^k → (-2)^k?
  - Change denominators: what if 2k+1 → 3k+1?
  - Change numerators: what if k! → (2k)!?
  - Do any variants give interesting results?

### Other Modules

- [ ] **Gap theorem verification** (from CLAUDE.md exploration guide)
  - Already have DAG implementation
  - Could be another angle for PhD discussion

- [ ] **Connect modules**
  - Any relationship between primorial formula and semiprime factorization?
  - Both involve factorials and primes in interesting ways

---

## Key Mindset Points (Re-read When Doubting!)

From our discussion:

✅ **Experimental/computational mathematics is REAL mathematics**
- Ramanujan, Birch-Swinnerton-Dyer, Bailey-Borwein-Plouffe all started computationally
- Discovery is the hard part; proof can come later (even from others)
- OEIS exists entirely for computational discoveries

✅ **You have nothing to be embarrassed about**
- Your hard work: finding the formula, verifying it, tracking down WHY
- Any pure mathematician can try to prove it - but YOU found it
- Own your methodology proudly

✅ **This is PhD-worthy work**
- Shows research initiative
- Demonstrates computational skills (valuable in modern NT)
- Ability to formulate mathematical questions
- Perfect icebreaker with potential supervisor

✅ **The primorial cancellation is genuinely interesting**
- Not trivial (or you'd have proof already)
- Potentially publishable once proven
- Perfect for AI proof systems (clear goal, elementary objects, verifiable pattern)

---

## Decision Points

**After arXiv submission:**
- Continue with MathOverflow? → YES if comfortable with full public discussion
- Try Gauss AI? → YES if no progress after 1-2 weeks on MO
- Contact supervisor directly? → Already done via endorsement email

**About other material (Ratio, Egyptian fractions, CF):**
- Publish now? → NO, too much at once
- Document for PhD application? → YES, shows breadth
- Include in orbit repo? → MAYBE, or separate repos with links

**Timeline pressure:**
- PhD application deadlines? → CHECK SOON
- If deadline approaching: prioritize CV + statement of purpose
- If time available: can take full 4 weeks for quality arXiv paper

---

## Contact Information

**Vít Kala**
- Institution: MFF Charles University, Prague
- Department: Algebra
- Research: Algebraic number theory, computational aspects
- Email: (to be looked up on MFF website)
- Publications: Check MathSciNet/arXiv for recent work

**Other Potential Contacts**
- Czech NT community
- Computational number theory researchers
- MathOverflow community (for endorsement if needed)

---

## Resources

**arXiv:**
- Main site: https://arxiv.org
- Submission help: https://arxiv.org/help/submit
- Endorsement info: https://arxiv.org/help/endorsement
- math.NT category: https://arxiv.org/list/math.NT/recent

**MathOverflow:**
- Main site: https://mathoverflow.net
- Tag: number-theory, prime-numbers
- Search existing primorial questions first

**Lean/Formal Verification:**
- Lean Zulip: https://leanprover.zulipchat.com
- Gauss AI: https://www.math.inc/gauss (early access form)

**Charles University:**
- Math-Phys Faculty: https://www.mff.cuni.cz/en
- PhD programs: (look up specific requirements)
- Vít Kala's page: (find on department website)

---

## Progress Tracking

**Started**: 2025-11-12
**Last updated**: 2025-11-12
**Current phase**: Sprint 1, Phase 1 (drafting paper)

**Completed milestones:**
- [x] Computational discovery of primorial formula
- [x] Extensive verification (m=2 to 5000+)
- [x] Pattern identification (D_k = 2 × primes up to 2k+1)
- [x] Problem formulation (p-adic valuation question)
- [x] Repository organization with documentation
- [x] Gauss submission draft prepared
- [x] This roadmap created!

**Next immediate action**:
→ Request AI assistant to draft arXiv paper LaTeX

---

*This is a living document - update as progress is made and decisions are taken.*
