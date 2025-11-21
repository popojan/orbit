# Wolfram Pattern Matching vs Prolog Unification

**Date:** 2025-11-21
**Context:** Design decisions for Orbit paclet API

## Overview

Wolfram Language and Prolog both use pattern matching extensively, but their semantics differ fundamentally. Understanding these differences is crucial for designing intuitive APIs and avoiding subtle bugs.

This document provides a rigorous comparison for developers coming from logic programming backgrounds.

## Core Differences

| Feature | Prolog | Wolfram Language |
|---------|--------|------------------|
| **Direction** | Bidirectional (unification) | Unidirectional (pattern → data) |
| **Backtracking** | Yes (search all solutions) | No (first match wins) |
| **Evaluation** | Lazy (goal-driven) | Eager (term rewriting) |
| **Occurs Check** | Usually disabled (for speed) | Always enabled |
| **Purpose** | Logic programming (relations) | Term rewriting (transformations) |

## 1. Directionality

### Prolog: Bidirectional Unification

```prolog
?- f(X, 2) = f(1, Y).
X = 1, Y = 2.  % Both sides modified
```

Unification is **symmetric**:
```prolog
?- f(a, X) = f(Y, b).
X = b, Y = a.  % Solves for both variables
```

**Algorithm:** Robinson's unification (1965)
- Walk both terms simultaneously
- Bind variables on either side
- Check occurs (if enabled)
- Result: most general unifier (MGU)

### Wolfram: Unidirectional Matching

```mathematica
f[x_, 2] := x + 2
f[1, y_] := y + 1

MatchQ[f[1, 2], f[x_, 2]]  (* True, x → 1 *)
MatchQ[f[x_, 2], f[1, 2]]  (* False! Pattern doesn't match backwards *)
```

**Direction matters:**
- Left side = **pattern** (template with holes)
- Right side = **data** (concrete expression)
- Pattern variables (`x_`) bind to data, NOT vice versa

**This is fundamental to term rewriting:**
```mathematica
f[a, b] /. f[x_, y_] :> g[x, y]  (* → g[a, b] *)
f[x_, y_] /. f[a, b] :> g[x, y]  (* → f[x_, y_], no match! *)
```

## 2. Backtracking vs First-Match

### Prolog: Exhaustive Search

```prolog
member(X, [X|_]).
member(X, [_|T]) :- member(X, T).

?- member(X, [1,2,3]).
X = 1 ;       % backtrack
X = 2 ;       % backtrack
X = 3 ;       % backtrack
false.
```

**Execution model:**
1. Try first clause
2. If fails, backtrack and try next clause
3. Continue until all clauses exhausted or solution found
4. User can force more solutions via `;`

### Wolfram: Priority-Based Dispatch

```mathematica
f[x_] := "general case"
f[1] := "specific case"

f[1]  (* → "specific case" - more specific pattern wins *)
f[2]  (* → "general case" *)
```

**Pattern specificity hierarchy:**
1. Exact match (`f[1]`)
2. Constrained pattern (`f[x_Integer]`)
3. General pattern (`f[x_]`)
4. Sequence patterns (`f[x__]`)

**No backtracking:**
```mathematica
(* Multiple definitions *)
g[x_] := x^2
g[x_] := x^3  (* Warning: redefinition! Previous lost *)

(* Conditional patterns instead *)
h[x_ /; x > 0] := Sqrt[x]
h[x_] := -Sqrt[-x]  (* Fallback for x ≤ 0 *)
```

## 3. Evaluation Strategy

### Prolog: Lazy, Goal-Driven

```prolog
infinite(0).
infinite(N) :- N1 is N+1, infinite(N1).

% This works! (generates infinite stream on demand)
?- infinite(N), N < 5.
N = 0 ;
N = 1 ;
N = 2 ;
N = 3 ;
N = 4.
```

**Key:** Evaluation happens only when needed (goal-driven).

### Wolfram: Eager, Bottom-Up

```mathematica
f[x_] := x^2
f[1 + 1]  (* Evaluates 1+1 = 2 FIRST, then matches f[2] *)
```

**Evaluation order:**
1. Evaluate arguments (bottom-up)
2. Try pattern matching with evaluated form
3. Apply transformation if match

**Problem for symbolic work:**
```mathematica
f[x_] := HoldForm[x]
f[1 + 1]  (* → HoldForm[2], not HoldForm[1+1] *)
```

**Solution: Hold attributes**
```mathematica
SetAttributes[f, HoldAll]
f[x_] := HoldForm[x]
f[1 + 1]  (* → HoldForm[1+1] ✓ *)
```

## 4. The Occurs Check

### Prolog: Usually Disabled

```prolog
% SWI-Prolog (with occurs_check disabled, traditional behavior)
?- X = f(X).
X = f(f(f(f(...)))) % Infinite structure! (or error in modern Prolog)

% With occurs_check enabled:
?- unify_with_occurs_check(X, f(X)).
false.
```

**Why disabled by default?**
- Performance: occurs check is O(n) per unification
- Most programs don't create cyclic structures
- Historical: early Prolog implementations

**Modern Prolog:** SWI-Prolog detects and errors on cyclic structures.

### Wolfram: Always Enabled

```mathematica
x = f[x]  (* Creates ∞ structure with WARNING *)
(* During evaluation...
   $IterationLimit::itlim: Iteration limit of 4096 exceeded. *)
```

Wolfram prevents infinite recursion via:
1. **Iteration limit** (default 4096)
2. **Recursion limit** (default 1024)
3. **Memory guards**

**This is safer but different:**
```mathematica
(* Prolog: X = [1|X] creates infinite list *)
(* Wolfram: x = Prepend[x, 1] → error *)
```

## 5. Pattern Constraints

### Prolog: Guards and Type Checks

```prolog
positive_sqrt(X, Y) :-
    X > 0,              % Guard: arithmetic constraint
    Y is sqrt(X).

?- positive_sqrt(-4, Y).
false.  % Guard fails before sqrt
```

**Type checking:**
```prolog
list_length([], 0).
list_length([_|T], N) :-
    list_length(T, N1),
    N is N1 + 1.
```

No explicit type in pattern - structure determines type.

### Wolfram: Rich Pattern Language

```mathematica
(* Type constraints *)
f[x_Integer] := "integer"
f[x_Rational] := "rational"
f[x_Real] := "real"

(* Conditional patterns *)
f[x_ /; x > 0] := Sqrt[x]
f[x_] := -Sqrt[-x]

(* Structural patterns *)
f[{x_, y_}] := "pair"
f[{x_, y_, z_}] := "triple"

(* Named patterns with conditions *)
f[x_Integer /; PrimeQ[x]] := "prime"
```

**Pattern matching is Wolfram's type system!**

## 6. Practical Example: Our API Bug

### The Bug

```mathematica
PellSolution[d_] := Module[{...},
  ...
  {x -> u, y -> r}  (* x, y in Private` context! *)
]

(* User code *)
sol = PellSolution[2]
start = (x - 1)/y /. sol  (* FAILS: x,y are Global`, keys are Private` *)
```

### Why This Happened

In Prolog, this would work:
```prolog
pell_solution(D, X, Y) :- ... .

?- pell_solution(2, X, Y), Start is (X-1)/Y.
X = 3, Y = 2, Start = 1.  % Variables unified regardless of context
```

### The Fix

```mathematica
PellSolution[d_] := Module[{...},
  ...
  {Global`x -> u, Global`y -> r}  (* Explicit global context *)
]
```

**Lesson:** Wolfram pattern matching is **namespace-aware**. Symbol identity includes context.

## 7. Comparison Table

### Pattern Features

| Feature | Prolog | Wolfram |
|---------|--------|---------|
| Variable binding | Logic variable (∀) | Pattern variable (template hole) |
| Anonymous var | `_` | `_` |
| Repeated var | `f(X, X)` matches if same | `f[x_, x_]` matches if same |
| List patterns | `[H\|T]` head/tail | `{h_, t___}` first/rest |
| Nested patterns | `f(g(X), Y)` | `f[g[x_], y_]` |
| Constraints | `:- X > 0` (guard) | `x_ /; x > 0` (condition) |
| Type checking | Implicit (structure) | Explicit (`x_Integer`) |

### Semantic Differences

| Aspect | Prolog | Wolfram |
|--------|--------|---------|
| `f(X) = f(1)` | `X = 1` (unifies) | Pattern match fails (wrong direction) |
| `X = X` | Always true (trivial unification) | Error if X undefined |
| `f(X, X)` | Constraint: both must be same | Pattern: both must be identical |
| Multiple clauses | Try all (backtracking) | Priority-based dispatch |
| Variable scope | Local to clause | Context-aware |

## 8. When Each Paradigm Excels

### Prolog Strengths

**Relational programming:**
```prolog
append([], L, L).
append([H|T1], L2, [H|T3]) :- append(T1, L2, T3).

?- append([1,2], [3,4], X).
X = [1,2,3,4].

?- append(X, Y, [1,2,3]).
X = [], Y = [1,2,3] ;
X = [1], Y = [2,3] ;
X = [1,2], Y = [3] ;
X = [1,2,3], Y = [].
```

**Solving for any argument!** (true relations)

### Wolfram Strengths

**Term rewriting:**
```mathematica
(* Symbolic differentiation *)
D[f_[x_], x_] := f'[x]
D[u_ + v_, x_] := D[u, x] + D[v, x]
D[u_ * v_, x_] := u * D[v, x] + v * D[u, x]
D[c_, x_] /; FreeQ[c, x] := 0

D[x^2 + 3*x, x]  (* → 2x + 3 *)
```

**Directed transformation:** pattern → replacement

## 9. Design Implications for Orbit

### What We Learned

1. **Pattern direction matters**
   ```mathematica
   (* Good: Specific to general *)
   BinetSqrt[nn_, n_, k_Integer] := ...

   (* Bad: Would need backtracking to invert *)
   (* Can't solve: BinetSqrt[2, start, k] = result for k *)
   ```

2. **Context sensitivity**
   ```mathematica
   (* Must use Global` for user-facing symbols *)
   PellSolution[d_] := {Global`x -> ..., Global`y -> ...}
   ```

3. **Type constraints for safety**
   ```mathematica
   (* Reject non-integers early *)
   NestedChebyshevSqrt[nn_, start_, {m1_Integer, m2_Integer}] := ...

   (* Not: {m1_, m2_} - allows symbolic, may cause confusion *)
   ```

4. **No overloading by computation**
   ```mathematica
   (* Can't do: *)
   f[x_] := ... (* compute forward *)
   f[result_] := ... (* solve backward *)

   (* Prolog could: *)
   % f(X, Y) :- ... % works both directions
   ```

## 10. Recommendations

### For Prolog Programmers Using Wolfram

1. **Think transformations, not relations**
   - Patterns are templates, not logic variables
   - Direction is built into API design

2. **Embrace specificity ordering**
   - More specific patterns first
   - No backtracking fallback

3. **Use constraints liberally**
   - `x_Integer` prevents surprises
   - `x_ /; x > 0` explicit guards

4. **Be context-aware**
   - Symbol identity includes namespace
   - Use `Global`` for user-visible symbols

### For Wolfram Programmers

1. **Understand evaluation order**
   - Arguments evaluate before matching
   - Use `Hold` attributes for symbolic work

2. **Pattern specificity is your type system**
   - Design APIs with specificity in mind
   - General fallback at end

3. **Test pattern direction**
   - Patterns don't work backwards
   - Design separate functions for inverse operations

## References

1. **Prolog Unification:**
   - Robinson, J.A. (1965). "A Machine-Oriented Logic Based on the Resolution Principle"
   - Sterling & Shapiro (1994). *The Art of Prolog*

2. **Wolfram Pattern Matching:**
   - Wolfram, S. (2003). *The Mathematica Book* (Chapter 2.3: Patterns)
   - Official Documentation: https://reference.wolfram.com/language/tutorial/PatternsAndTransformationRules.html

3. **Term Rewriting Theory:**
   - Baader & Nipkow (1998). *Term Rewriting and All That*
   - Focuses on Wolfram-style directed rewriting

4. **Context and Namespaces:**
   - Wolfram Language Documentation: "Contexts and Packages"

---

**Summary:** Prolog unification is **bidirectional and search-based** (logic programming), while Wolfram pattern matching is **unidirectional and rewrite-based** (transformation). Understanding this distinction prevents API design mistakes and user confusion.
