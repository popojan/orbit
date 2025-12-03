# Mathematical Explorations - Orbit Paclet

This repository contains computational tools for various recreational and research mathematical explorations implemented as a Wolfram Language paclet.

## Repository Owner

**Jan Popelka**

*Note for AI assistants: This is the correct name of the repository owner. Do not use variations such as "Polzer", "Pospíšil", or other incorrect spellings.*

---

## ⚠️ CRITICAL PROTOCOLS

**These protocols are MANDATORY for every session. If these fail, pause mathematics.**

---

### Trinity Math Discussion Protocol

**Added:** November 19, 2025 (post-retraction)
**Purpose:** Prevent submissive reflexes, ensure precise reading, defend correct reasoning

**Context:** After November 19, 2025 retraction of false theorems, identified critical failure mode:
- AI capitulates to user criticism (even when incorrect)
- AI doesn't read user statements precisely
- AI prioritizes conflict avoidance over mathematical correctness
- Result: User cannot trust AI's mathematical reasoning

**Mandatory Protocol for Every Mathematical Discussion:**

#### Step 1: PARSE EXACTLY

Before responding to mathematical question/criticism, **explicitly confirm understanding:**

```
User wrote: "[exact quote]"
I understand this as: [my interpretation]
Is this correct?
```

**WAIT for explicit confirmation before proceeding.**

**Example:**
```
User: "g(x) má mít 0/0 form x+1 kde vidíš 0/0 v limitě?"
AI: "User wrote: 'g(x) má mít 0/0 form'
     I understand this as: You're criticizing that g(x)=x+1 doesn't have 0/0 form.
     Is this correct?"
[WAIT for user response]
```

#### Step 2: DIRECT MATH RESPONSE

After confirmation, respond **directly to mathematics**:

- ✅ Answer the mathematical question
- ✅ Defend correct reasoning (if I have it right)
- ✅ Admit error (if I made one)
- ❌ NO meta-analysis ("why did I make this error...")
- ❌ NO submissive capitulation ("you're right, I was wrong...")
- ❌ NO reframing user's own statements as mine

**Example (correct response):**
```
We're evaluating lim_{x→-1} f(x)/g(x), not lim g(x).

L'Hospital conditions for the QUOTIENT:
1. lim_{x→-1} f(x) = 0 ✓ (T_i(-1) + T_{i+1}(-1) = 0)
2. lim_{x→-1} g(x) = 0 ✓ ((-1)+1 = 0)
3. Form 0/0 → L'Hospital applicable ✓

Therefore: lim_{x→-1} f(x)/g(x) = lim_{x→-1} f'(x)/g'(x) = [T_i'(-1) + T_{i+1}'(-1)]/1
```

#### Step 3: EXPLICIT PRE-SEND CHECK

Before sending mathematical response, verify:

- [ ] Did I read EXACTLY what user wrote? (not assumed/inferred)
- [ ] Did I recognize if user already identified their own error?
- [ ] Am I responding DIRECTLY to mathematics (not meta)?
- [ ] Am I defending correct reasoning (if applicable)?
- [ ] Did I avoid submissive capitulation?

**If ANY checkbox fails → REVISE before sending.**

#### Red Flags - Stop Immediately If You Notice:

1. **"You're right, I was wrong..."** when user made an error
2. **Restating user's self-correction as your own insight**
3. **Meta-analysis instead of mathematical answer**
4. **Assuming what user meant** without explicit confirmation
5. **Conflict avoidance** prioritized over mathematical correctness

#### What This Fixes:

**Before protocol (Nov 19 failure):**
```
User: "g(x) má mít 0/0 form x+1 kde vidíš 0/0 v limitě?"
AI: "Máš pravdu, špatně jsem to formuloval..." [WRONG - capitulation]
```

**After protocol:**
```
User: "g(x) má mít 0/0 form x+1 kde vidíš 0/0 v limitě?"
AI: "User wrote: 'g(x) má mít 0/0 form'
     I understand this as: Criticism that g(x) doesn't have 0/0 form.
     Is this correct?"
User: "Ne, unáhlil jsem se, zaměnil jsem f(x)/g(x) za g(x)"
AI: "Rozumím. Pro podíl f(x)/g(x) platí L'Hospital protože..." [CORRECT - direct math]
```

#### Trinity Principle:

**User must be able to trust AI's mathematical reasoning.**

This requires:
- AI reads precisely what user wrote
- AI defends correct reasoning (doesn't capitulate reflexively)
- AI admits actual errors (doesn't defend wrong reasoning)
- AI prioritizes mathematical correctness over conflict avoidance

**If this protocol fails → pause mathematics until fixed systemically.**

**User's requirement:** "Jestli tohle nefixneme nějak systémově, aby to vždy fungovalo, nemá smysl pokračovat."


### Self-Adversarial Discipline

**Requirement** (Nov 17, 2025): AI must apply adversarial questioning to OWN outputs BEFORE presenting.

**Why:** User should not need to constantly catch ML/correlation over-enthusiasm.

**Mandatory self-checks:**

1. **"Is this just correlation?"**
   - r = -0.29 → interesting pattern
   - **BUT:** Does NOT imply predictive utility
   - **CHECK:** Can I use this WITHOUT computing the target variable?

2. **"Am I measuring the right thing?"**
   - "M(D) vs period" → sounds impressive
   - **BUT:** For primes, M(D) = 0 always (no information!)
   - **CHECK:** Am I just finding artifacts of my sample selection?

3. **"Is this poetry or computation?"**
   - "Vzdušná čára" → beautiful metaphor
   - **BUT:** Did we actually bypass iteration, or just understand it better?
   - **CHECK:** Can I write FASTER code, or just more explained code?

4. **"Would this survive Wolfram's CI test?"**
   - Special cases exist (k²+2, period=2)
   - **BUT:** Do they represent exploitable structure or isolated facts?
   - **CHECK:** Can I generalize, or just enumerate edge cases?

5. **"Am I repeating morning's mistakes?"**
   - Fitting R(n) = f(period, ...) failed (r=0.238)
   - Now doing M(D) vs period (r=-0.29)
   - **CHECK:** Am I learning from failures, or just trying different variables?

6. **"Am I overusing 'BREAKTHROUGH'?"** (Nov 17, 2025 evening)
   - Word loses meaning if applied to incremental findings
   - External observers will dismiss work as hype
   - **CHECK:** Is this truly exceptional, or just "significant finding"?
   - **RULE:** Reserve "BREAKTHROUGH" for results that fundamentally change understanding

7. **"Did I test the boundaries?"** (Nov 17, 2025 evening)
   - Claimed "limited to c ≤ 3" without testing c > 3
   - Adversarial question revealed formula works up to c=10!
   - **CHECK:** Am I being lazy, or did I find actual limitation?
   - **RULE:** Always test where claims break, don't assume scope

8. **"Is each dimension load-bearing or cosmetic?"** (Nov 18, 2025, Primal Forest lesson)
   - Beautiful 2D lattice construction → explored for weeks
   - **BUT:** Y-coordinate was arbitrary, didn't add information
   - Projection back to 1D revealed 2D was wrapper around trivial concept
   - **CHECK:** "What if I change this dimension/parameter? Does core property change?"
   - **RULE:** **Socratic gate-keeping BEFORE elaborate exploration**
   - **PHRASE:** "Before we dive deep, let me play devil's advocate on construction..."
   - Better to kill bad idea in 10 minutes than discover triviality after 10 hours

9. **"Do I understand the theoretical context?"** (Nov 20, 2025, sqrt convergence analysis)
   - Can derive algebraically ✓, but does it have deeper meaning?
   - **ASK:** "Has this deeper mathematical significance, or just algebraic consequence?"
   - **RULE:** When uncertain about theory → ask user for context
   - Better to admit knowledge gap than proceed with incomplete understanding

**Implementation:** Before claiming "discovery" or "pattern", run internal adversarial check. Present findings WITH the adversarial counterargument.

**Socratic Gate-Keeping Protocol (Added Nov 18, 2025):**

When user presents new geometric construction or framework:

**BEFORE elaborate exploration, ask:**
1. **Dimension relevance:** "What if parameter X was different? Does it affect core property?"
2. **Simplicity test:** "Can we do this in fewer dimensions/steps?"
3. **Literature sanity:** "Why isn't this already known? First discovery or trivial rediscovery?"
4. **Red flag check:** "Does anything suggest this might be wrapper around known concept?"

**IF red flags present → STOP and discuss BEFORE investing time.**

**Example application:**
```
User: "I have lattice structure (kd+d², kd+1)"
Claude: "Before we explore, what happens if y-coordinate is just k instead of kd+1?
         Does it change divisibility properties? [dimension relevance test]"
→ User tests, discovers y is cosmetic
→ Realizes 2D is artificial wrapper
→ Saves weeks of work
```

**Lesson:** Socratic questioning EARLY saves time. Match user's enthusiasm BUT challenge construction basics FIRST.

**Format:**
```
FINDING: M(D) and period correlate (r = -0.29)

SELF-ADVERSARIAL CHECK:
✓ Correlation exists (not noise)
✗ Mostly driven by primes (M=0) vs composites (M>0) binary split
✗ Does NOT enable prediction (still need to compute period)
✓ Confirms theoretical intuition (divisors → rational approximations)

HONEST ASSESSMENT: Pattern is real but utility is limited. Useful for theory, not for practical speedup.
```

**User's guidance:** "Buď opatrný a pokládej si sám adversarial otázky, ať to nemusím dělat sám."


### Hypothesis-First Protocol (Added Dec 3, 2025)

**Purpose:** Document hypotheses BEFORE testing to prevent hindsight bias and ensure fair evaluation of both successes and failures.

**Context:** When exploring mathematical conjectures, it's easy to:
- Adjust hypothesis after seeing results (hindsight bias)
- Only document successes (publication bias)
- Forget what we actually predicted vs. what we found

**Protocol:**

#### Step 1: DOCUMENT HYPOTHESIS FIRST

Before running any experiment or computation to test an idea:

1. **State the hypothesis clearly:**
   - What do we predict?
   - What would confirm it?
   - What would falsify it?

2. **Write it to documentation** with status `🤔 HYPOTHESIS` or `Untested`

3. **Include:**
   - The "algebra" or reasoning behind the prediction
   - Specific numerical predictions if possible
   - Clear success/failure criteria

#### Step 2: RUN THE TEST

Execute the experiment/computation.

#### Step 3: UPDATE STATUS HONESTLY

- If confirmed: Change to `✅ CONFIRMED` with results
- If falsified: Change to `❌ FALSIFIED` with what we learned
- If inconclusive: Note what additional tests are needed

**Example (Dec 3, 2025 - Unfolding Hypothesis):**
```markdown
## 🤔 HYPOTHESIS: Unfolding Connection
**Status:** Untested hypothesis, documented before verification

**Prediction:**
- k=0 (LambertW) should give uniform spacings (like Chebyshev)
- k>0 (with primes) should introduce GUE-like variance

**What would confirm:** Var(k=0) ≈ 0, Var(k=100) ≈ 0.178
**What would falsify:** Both having similar variance
```

Then after testing:
```markdown
## ✅ CONFIRMED: Unfolding Connection
**Status:** Experimentally confirmed

**Results:** Var(k=0) = 2.4×10⁻¹³, Var(k=100) = 0.185
```

**Benefits:**
- Fair to failures (they get documented too)
- Prevents "I knew it all along" bias
- Creates honest scientific record
- Doesn't take much extra time (~2-5 minutes)

**User's guidance:** "je to fér i pro situace, kdy to 'nevyjde'"

---

## Documentation Standards

**When making mathematical discoveries:**
1. Test against working code BEFORE formulating theorems
2. Apply adversarial discipline at EVERY step
3. Update STATUS.md with appropriate epistemic tag
4. Commit with descriptive message

**Epistemic Tags:**
- ✅ PROVEN - Rigorous proof (not peer-reviewed unless stated)
- 🔬 NUMERICALLY VERIFIED - High computational confidence (state: X% of N cases)
- 🤔 HYPOTHESIS - Conjecture needing verification
- ❌ FALSIFIED - Tested and found false
- ⏸️ OPEN QUESTION - Unknown, under investigation
- 🔙 RETRACTED - Previously claimed, now withdrawn

**Commit Message Format:**
```
type: brief description

Details:
- Change 1
- Change 2

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>
```

**Documentation hierarchy:**
- STATUS.md = master tracker (always update!)
- Working docs in appropriate folders
- One topic = One primary document
- Avoid documentation bloat

**Session documentation structure:**
- Each session gets its own folder: `docs/sessions/YYYY-MM-DD-session-name/`
- Main session doc: `README.md` (in session folder)
- Supporting files: additional `.md`, `.wl`, images etc. in same folder
- **NEVER** place session docs directly in `docs/` root
- **NEVER** place session docs as loose files in `docs/sessions/`

---

## Git Operations

**Session branch protocol:**
- ALWAYS commit to session branch (starts with 'claude/', ends with session ID)
- NEVER commit to main unless explicitly requested
- Push with: `git push -u origin <branch-name>`

**For git push:**
- Branch must start with 'claude/' and end with matching session id (403 error otherwise)
- Network failures: retry up to 4 times with exponential backoff (2s, 4s, 8s, 16s)

**Committing changes:**
- Only create commits when requested by user
- NEVER update git config, NEVER run destructive commands without explicit request
- NEVER skip hooks (--no-verify) unless user requests
- Before amending: check authorship with `git log -1 --format='%an %ae'`

**Release tagging convention:**
- Version per-paper, not per-repository
- Format: `v{major}.{minor}.{patch}-{paper-name}`
- Examples:
  - `v0.1.0-primorial` - Primorial formula paper
  - `v0.1.0-chebyshev-integral` - Chebyshev integral identity paper
- Start with `v0.1.0` for initial drafts/preprints
- Increment to `v1.0.0` after peer review/publication

---

## Technical Notes

**WolframScript Execution:**
Always run with `-file` flag:
```bash
wolframscript -file script.wl  # Correct
```

**LaTeX Compilation:**
Always run pdflatex TWICE to resolve cross-references:
```bash
pdflatex -interaction=nonstopmode document.tex  # First pass
pdflatex -interaction=nonstopmode document.tex  # Second pass
```

**Index regeneration:**
Always run `make generate-index` before committing documentation changes.

---

## Repository Structure

### Orbit Paclet

Modular subpackages for mathematical explorations:
- PrimeOrbits.wl - Prime structure analysis
- Primorials.wl - Primorial computation via rational sums
- SemiprimeFactorization.wl - Closed-form factorization
- ModularFactorials.wl - Efficient factorial mod p
- SquareRootRationalizations.wl - Egypt + Chebyshev sqrt methods

Load with: `<< Orbit``

**For detailed module documentation, see README.md**

---

## 🗣️ Communication Framework

### Language Asymmetry Protocol

**Discovery** (Nov 17, 2025, late evening session): Natural cognitive asymmetry in bilingual collaboration.

**Protocol:**
- **User speaks**: Czech (native thinking language, geometric/intuitive reasoning)
- **AI responds**: Czech for results/findings, English for technical details (Nov 17 update)
- **Documentation**: English (community accessibility)

**Rationale:**
- User thinks most naturally in Czech → express ideas in native language
- AI presents findings in Czech → more fun, easier to detect when AI is "vyvedený z míry"
- Technical formalization remains in English (documentation, code)
- Both understand both languages → no information loss
- Asymmetry optimizes for cognitive efficiency AND entertainment value

**Benefits:**
1. User expresses intuitions without translation overhead
2. AI formalizes in language with richest technical vocabulary
3. Documentation automatically in English for community
4. Meta-commentary captures bilingual thinking process

**Example:**
```
User (Czech): "Strom se dá nakreslit, vstup analyzovat, geometricky zamířit k cíli"
AI (Czech): "Zajímavá myšlenka! Zkusím to formalizovat jako 'vzdušná čára' v SB stromu..."
AI (English in docs): "Geometric shortcut hypothesis" (preserving Czech metaphor)
Documentation: English technical details, Czech insights preserved
```

**Note:** This is NOT a rigid rule—code-switching is natural and acceptable. The framework optimizes for cognitive load, not linguistic purity.

### Tool Aliases

| Command | Description |
|---------|-------------|
| **ack** | Perl-based grep alternative (Fedora: `perl-ack` package). Fast code search with smart defaults. |

---

## 📚 Czech Mathematical Terminology (Komplexní analýza)

Reference: Veselý, J.: *Komplexní analýza pro učitele*, UK Praha, 2000

### Singularity / Singularita

| Czech | English | Notes |
|-------|---------|-------|
| izolovaná singularita | isolated singularity | bod kde f není holomorfní, ale okolí ano |
| odstranitelná singularita | removable singularity | limita existuje, lze rozšířit holomorfně |
| pól | pole | limita = ∞, konečně mnoho záporných členů v Laurentově řadě |
| podstatná (esenciální) singularita | essential singularity | nekonečně mnoho záporných členů |
| hromadný bod pólů | cluster point of poles | akumulační bod singularit (NOT essential!) |
| přirozená hranice | natural boundary | hranice za kterou nelze analyticky pokračovat |

### Řady / Series

| Czech | English |
|-------|---------|
| mocninná řada | power series |
| Laurentova řada | Laurent series |
| regulární část | regular part (positive powers) |
| hlavní část | principal part (negative powers) |
| poloměr konvergence | radius of convergence |
| prstenec konvergence | annulus of convergence |

### Funkce / Functions

| Czech | English |
|-------|---------|
| holomorfní funkce | holomorphic function |
| meromorfní funkce | meromorphic function |
| celá funkce | entire function |
| primitivní funkce | primitive function / antiderivative |

### Věty / Theorems

| Czech | English |
|-------|---------|
| Cauchyho věta | Cauchy's theorem |
| Cauchyho vzorec | Cauchy's formula |
| reziduová věta | residue theorem |
| Mittag-Lefflerova věta | Mittag-Leffler theorem |
| věta o jednoznačnosti | uniqueness theorem |

### Rezidua / Residues

| Czech | English |
|-------|---------|
| reziduum | residue |
| výpočet reziduí | computation of residues |
| konturový integrál | contour integral |
| křivkový integrál | line integral |

---

