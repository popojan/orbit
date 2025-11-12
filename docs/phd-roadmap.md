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
  - Square root computation via Egyptian fraction sums
  - Connection to **Pell equations** $x^2 - ny^2 = 1$
  - Recursive formula $a(n,i)$ with convergence to $\sqrt{n}$
  - Example doc: `egypt/doc/sqrt.pdf` (clean presentation style!)
  - Shows: computational approach + classical NT (Pell) + algebraic numbers

- [ ] **Continued fractions (CF) connection**
  - Relationship to Egyptian fractions
  - Any interesting patterns/formulas
  - Computational tools built
  - Rust implementation in egypt repo?

- [ ] **Ratio package**
  - What it does
  - Where it lives (separate repo?)
  - Brief documentation
  - Connection to NT if any

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
