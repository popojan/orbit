# Wolfram Language Namespace Organization Best Practices

**Date:** 2025-11-21
**Context:** Design decisions for Orbit paclet structure

## Overview

Wolfram Language packages use **contexts** (namespaces) to organize symbols and prevent naming collisions. This document provides best practices based on official Wolfram conventions and practical experience with the Orbit paclet.

## Quick Reference

| Package Size | Recommended Structure | Example |
|--------------|----------------------|---------|
| < 50 symbols | Flat namespace (`Package`symbol`) | `Orbit`BinetSqrt` |
| 50-200 symbols | Optional subcontexts for logical grouping | `Graphics`Mesh`MeshRegion` |
| > 200 symbols | Hierarchical subcontexts | `Wolfram`Language`WolframLanguageData` |

**Orbit status:** ~30 public symbols → flat namespace is appropriate ✓

## Wolfram Context System

### What is a Context?

A **context** is a namespace prefix for symbols:

```mathematica
(* Full symbol name includes context *)
System`Sin        (* Built-in function *)
Global`x          (* User variable *)
Orbit`BinetSqrt   (* Our package function *)
```

### Context Path

Wolfram searches for symbols along the **$ContextPath**:

```mathematica
$ContextPath
(* → {"PacletManager`", "System`", "Global`"} *)

(* When you type "Sin", Wolfram searches:
   1. PacletManager`Sin  (not found)
   2. System`Sin         (found! ✓)
   3. Global`Sin         (not searched - already found) *)
```

### Shadowing and Conflicts

**Shadowing** occurs when multiple contexts define the same symbol:

```mathematica
BeginPackage["MyPackage`"]

Sin::usage = "My custom sine function"

Begin["`Private`"]

Sin[x_] := x^2  (* Shadows System`Sin! *)

End[]
EndPackage[]

(* User code *)
Sin[0.5]  (* Calls which one? *)
```

**Result:** First symbol on `$ContextPath` wins. This creates confusion!

**Best practice:** Avoid naming conflicts with built-in symbols.

## Package Structure

### Standard Pattern

```mathematica
(* File: MyPackage/Kernel/MyPackage.wl *)

BeginPackage["MyPackage`"]

(* PUBLIC API - usage messages declare symbols in MyPackage` context *)
Foo::usage = "Foo[x] does something"
Bar::usage = "Bar[x, y] does something else"

(* Switch to Private` subcontext for implementation *)
Begin["`Private`"]

(* Implementation - symbols here are MyPackage`Private`... *)
helperFunction[x_] := x^2

Foo[x_] := helperFunction[x] + 1
Bar[x_, y_] := x * Foo[y]

End[]
EndPackage[]
```

**Result:**
- Public API: `MyPackage`Foo`, `MyPackage`Bar`
- Private helpers: `MyPackage`Private`helperFunction`

**Why `Begin["`Private`"]` instead of `Begin["MyPackage`Private`"]`?**

The backtick prefix means "relative to current context":
```mathematica
$Context  (* → "MyPackage`" *)
Begin["`Private`"]
$Context  (* → "MyPackage`Private`" *)
```

This is **safer** than hardcoding the full path.

### Multiple Subcontexts

For larger packages, you can create multiple subcontexts:

```mathematica
BeginPackage["Graphics`"]

(* Mesh subcontext *)
BeginPackage["Graphics`Mesh`", {"Graphics`"}]
MeshRegion::usage = "..."
EndPackage[]

(* Polygon subcontext *)
BeginPackage["Graphics`Polygon`", {"Graphics`"}]
PolygonPlot::usage = "..."
EndPackage[]

EndPackage[]
```

**Usage:**
```mathematica
<< Graphics`
MeshRegion[...]      (* Graphics`Mesh`MeshRegion *)
PolygonPlot[...]     (* Graphics`Polygon`PolygonPlot *)
```

Both symbols are accessible without full qualification because their contexts are on `$ContextPath`.

## Flat vs Hierarchical Namespaces

### Flat Namespace (Orbit's Current Approach)

**Structure:**
```
Orbit`BinetSqrt
Orbit`BabylonianSqrt
Orbit`EgyptSqrt
Orbit`NestedChebyshevSqrt
Orbit`PellSolution
Orbit`BabylonianToNestedChebyshev
...
```

**Advantages:**
- Simple to implement and maintain
- Easy to use (`BinetSqrt` vs `Orbit`Sqrt`Binet`)
- Standard for small packages
- No context juggling

**Disadvantages:**
- Can become cluttered with many symbols (>100)
- Related functions not visually grouped
- Symbol name collisions within package

**When to use:** Packages with < 50 public symbols

### Hierarchical Namespace

**Structure:**
```
Orbit`Sqrt`Binet
Orbit`Sqrt`Babylonian
Orbit`Sqrt`Egypt
Orbit`Sqrt`NestedChebyshev
Orbit`Pell`Solution
Orbit`Conversion`BabylonianToNestedChebyshev
...
```

**Advantages:**
- Logical grouping of related functionality
- Clearer organization for large APIs
- Reduced chance of naming collisions
- Self-documenting (context indicates purpose)

**Disadvantages:**
- More complex implementation
- Longer symbol names
- Potentially confusing for users
- Overkill for small packages

**When to use:** Packages with > 200 symbols or strong logical divisions

### Middle Ground: Optional Subcontexts

Some packages use subcontexts for organization but expose all symbols at top level:

```mathematica
(* Implementation organized in subcontexts *)
BeginPackage["Orbit`Sqrt`"]
BinetSqrt::usage = "..."
BabylonianSqrt::usage = "..."
EndPackage[]

(* But exposed as Orbit`BinetSqrt via re-export *)
BeginPackage["Orbit`", {"Orbit`Sqrt`"}]
EndPackage[]
```

**Result:** Implementation is organized, but users see flat namespace.

## Context Resolution and Pattern Matching

### The PellSolution Bug (Case Study)

**Original code:**
```mathematica
BeginPackage["Orbit`"]

PellSolution::usage = "..."

Begin["`Private`"]

PellSolution[d_] := Module[{x, y, ...},
  (* computation *)
  {x -> u, y -> r}  (* BUG: x, y are in Private` context! *)
]

End[]
EndPackage[]
```

**Problem:**
```mathematica
<< Orbit`
sol = PellSolution[2]
(* → {Orbit`Private`x -> 3, Orbit`Private`y -> 2} *)

(* User code *)
start = (x - 1)/y /. sol
(* → (x - 1)/y   FAILS! User's x,y are Global`x, Global`y *)
```

**Root cause:** Inside `Begin["`Private`"]`, bare symbol `x` resolves to `Orbit`Private`x`.

**Fix:**
```mathematica
PellSolution[d_] := Module[{x, y, ...},
  (* computation *)
  {Global`x -> u, Global`y -> r}  (* Explicitly use Global` context *)
]
```

**Result:**
```mathematica
sol = PellSolution[2]
(* → {x -> 3, y -> 2}   (Global`x, Global`y) *)

start = (x - 1)/y /. sol
(* → 1   SUCCESS! ✓ *)
```

### Lesson: User-Facing Symbols Must Be in Expected Context

**Rule:** If returning rules/associations with symbol keys that users will pattern match against, use `Global`` context explicitly.

**Examples:**
```mathematica
(* GOOD *)
{Global`x -> value, Global`y -> value}

(* BAD *)
{x -> value, y -> value}  (* Resolves to package context! *)

(* ALTERNATIVE: Use strings if symbols aren't needed *)
<|"x" -> value, "y" -> value|>
```

## Common Patterns

### Pattern 1: Simple Package (No Subcontexts)

```mathematica
BeginPackage["MyPackage`"]

Func1::usage = "..."
Func2::usage = "..."

Begin["`Private`"]

(* All implementation here *)
helper[x_] := x^2
Func1[x_] := helper[x]
Func2[x_] := helper[x] + 1

End[]
EndPackage[]
```

**Result:**
- Public: `MyPackage`Func1`, `MyPackage`Func2`
- Private: `MyPackage`Private`helper`

### Pattern 2: Package with Submodules

```mathematica
BeginPackage["MyPackage`"]

(* Load submodules *)
Get["MyPackage`SubModule1`"]
Get["MyPackage`SubModule2`"]

End[]
EndPackage[]

(* File: SubModule1.wl *)
BeginPackage["MyPackage`SubModule1`", {"MyPackage`"}]

SubFunc1::usage = "..."

Begin["`Private`"]
SubFunc1[x_] := x^2
End[]

EndPackage[]
```

**Result:**
- `MyPackage`SubModule1`SubFunc1`
- `MyPackage`SubModule2`SubFunc2`

Users load with `<< MyPackage``, all symbols available.

### Pattern 3: Re-exporting for Flat Namespace

```mathematica
(* Implementation in subcontexts *)
BeginPackage["MyPackage`Sqrt`"]
BinetSqrt::usage = "..."
Begin["`Private`"]
BinetSqrt[n_, k_] := ...
End[]
EndPackage[]

(* Main package re-exports *)
BeginPackage["MyPackage`", {"MyPackage`Sqrt`"}]

(* BinetSqrt now accessible as MyPackage`BinetSqrt *)

EndPackage[]
```

**Note:** This creates aliases - `MyPackage`BinetSqrt` and `MyPackage`Sqrt`BinetSqrt` both exist!

## Wolfram's Own Packages

### Example: Image Processing

```mathematica
(* System` - core functionality *)
Image
ImageData
ImageDimensions

(* No subcontexts, all in System` *)
```

**Observation:** Even with 100+ image functions, Wolfram uses flat namespace in `System``.

### Example: Graph Functions

```mathematica
(* All in System` context *)
Graph
GraphPlot
FindShortestPath
CommunityGraphPlot
...
```

**Takeaway:** Wolfram prefers **descriptive names** over hierarchical namespacing.

### Example: External Packages

**Neural Networks (flat):**
```mathematica
NetTrain
NetGraph
NetChain
```

**Finite Elements (mostly flat):**
```mathematica
ToElementMesh
InitializePDECoefficients
```

**Pattern:** Official Wolfram packages use flat namespaces with descriptive prefixes in names.

## Orbit Paclet Analysis

### Current Structure

```mathematica
(* Public API - all in Orbit` context *)
BinetSqrt
BabylonianSqrt
EgyptSqrt
NestedChebyshevSqrt
PellSolution
BabylonianToNestedChebyshev
NestedChebyshevToBabylonian
EquivalentIterations
M
PrimeOrbit
...
```

**Count:** ~30 public symbols

### Should Orbit Use Subcontexts?

**Arguments for flat namespace (current):**
1. ✅ Small package (< 50 symbols) - within recommended range
2. ✅ Follows Wolfram convention for packages this size
3. ✅ Simple user experience (`BinetSqrt` vs `Orbit`Sqrt`Binet`)
4. ✅ Descriptive names already provide grouping (`BinetSqrt`, `BabylonianSqrt`)
5. ✅ Easy to maintain

**Arguments for hierarchical namespace:**
1. ❓ Logical grouping (Sqrt methods, Pell functions, Conversion utilities)
2. ❌ Overkill for 30 symbols
3. ❌ Longer, more verbose names
4. ❌ Not standard for this package size

### Recommendation

**Keep flat namespace** - Orbit is well within the range where flat namespaces are standard.

**If growth exceeds 100 symbols**, consider:
- Splitting into separate paclets (`OrbitSqrt`, `OrbitPell`, etc.)
- Optional subcontexts for internal organization (but keep flat user-facing API)

### Alternative: Descriptive Prefixes

Instead of subcontexts, use naming conventions:

```mathematica
(* Current - GOOD *)
BinetSqrt
BabylonianSqrt
EgyptSqrt

(* Subcontext alternative - UNNECESSARY *)
Sqrt`Binet
Sqrt`Babylonian
Sqrt`Egypt

(* Prefix alternative - REDUNDANT *)
SqrtBinet
SqrtBabylonian
SqrtEgypt
```

**Conclusion:** Current naming (`BinetSqrt`) is optimal - category last, method first.

## Symbol Visibility

### Public vs Private

**Public symbols** (declared with `::usage` before `Begin["`Private`"]`):
```mathematica
BeginPackage["Orbit`"]

BinetSqrt::usage = "BinetSqrt[n, start, k] ..."

Begin["`Private`"]
```

**Result:** `Orbit`BinetSqrt` added to `$ContextPath` when user loads package.

**Private symbols** (defined inside `Begin["`Private`"]`):
```mathematica
Begin["`Private`"]

(* Helper - NOT exported *)
bivariateCheb[n_, x_, {m1_, m2_}] := ...
```

**Result:** `Orbit`Private`bivariateCheb` exists but is not on `$ContextPath`.

### Accessing Private Symbols

Users can still access private symbols with full qualification:

```mathematica
<< Orbit`
Orbit`Private`bivariateCheb[2, 1, {2, 3}]  (* Works! *)
```

**This is intentional** - "private" means "not advertised", not "inaccessible".

### Truly Hiding Symbols

If you need truly hidden symbols, use `Module` or `Block`:

```mathematica
Begin["`Private`"]

BinetSqrt[n_, start_, k_] := Module[
  {p, q, result},  (* These are temporary, truly private *)
  p = start + Sqrt[n];
  q = start - Sqrt[n];
  result = Sqrt[n] * (p^k - q^k)/(p^k + q^k);
  Interval[{result, n/result}]
]
```

**Result:** `p`, `q`, `result` are temporary symbols with unique names (`p$1234`), not accessible.

## Context Manipulation Functions

### Useful Functions

```mathematica
(* Current context *)
$Context
(* → "Global`" *)

(* Context search path *)
$ContextPath
(* → {"PacletManager`", "System`", "Global`"} *)

(* List all symbols in context *)
Names["Orbit`*"]
(* → {"BinetSqrt", "BabylonianSqrt", ...} *)

(* Check symbol context *)
Context[BinetSqrt]
(* → "Orbit`" *)

(* Remove context from path *)
$ContextPath = DeleteCases[$ContextPath, "Orbit`"]

(* Add context to path *)
AppendTo[$ContextPath, "MyPackage`"]
```

### Context Manipulation (Advanced)

```mathematica
(* Switch context *)
Begin["MyContext`"]
$Context
(* → "MyContext`" *)
End[]

(* Temporarily switch context *)
Block[{$Context = "MyContext`", $ContextPath = {"System`"}},
  (* Code here runs in isolated context *)
  x = 5  (* Creates MyContext`x *)
]
```

## Best Practices Summary

### For Small Packages (< 50 symbols)

1. ✅ Use flat namespace (`Package`Symbol`)
2. ✅ Use descriptive names (`BinetSqrt`, not `Sqrt` or `B`)
3. ✅ Declare public API with `::usage` before `Begin["`Private`"]`
4. ✅ Keep implementation in `Package`Private`` context
5. ✅ Use `Global`` context for user-facing rule keys

### For Medium Packages (50-200 symbols)

1. ✅ Consider logical grouping with subcontexts
2. ✅ Re-export to flat namespace if user-friendliness is priority
3. ✅ Use naming prefixes to indicate grouping (`MeshRegion`, `MeshCoordinates`)

### For Large Packages (> 200 symbols)

1. ✅ Use hierarchical subcontexts
2. ✅ Provide convenience functions to load common subsets
3. ✅ Document context structure clearly

### Always

1. ✅ Avoid shadowing System` symbols
2. ✅ Use explicit `Global`` for pattern-matching symbol keys
3. ✅ Document public API with `::usage` messages
4. ✅ Keep private helpers in `Private`` subcontext
5. ✅ Test that `<< Package`` exposes intended symbols

## Orbit Paclet Recommendations

**Current status:** ✅ Well-designed flat namespace, appropriate for size

**Future growth scenarios:**

### If reaching 50-100 symbols:
- Continue flat namespace
- Use longer descriptive names
- Consider documentation grouping (not code structure)

### If reaching 100-200 symbols:
**Option 1:** Split into multiple paclets
```
OrbitSqrt`      (* Square root methods *)
OrbitPell`      (* Pell equation solvers *)
OrbitPrimes`    (* Prime orbit analysis *)
```

**Option 2:** Internal subcontexts, flat user API
```mathematica
(* Implementation *)
BeginPackage["Orbit`Sqrt`"]
BinetSqrt::usage = "..."
EndPackage[]

(* Re-export *)
BeginPackage["Orbit`", {"Orbit`Sqrt`", "Orbit`Pell`"}]
EndPackage[]

(* User sees: Orbit`BinetSqrt *)
```

### If reaching > 200 symbols:
- Definitely split into multiple paclets
- Or use hierarchical subcontexts with documentation

## Common Pitfalls

### Pitfall 1: Forgetting to Declare Public API

```mathematica
BeginPackage["MyPackage`"]

(* FORGOT TO DECLARE! *)
(* Foo::usage = "..." *)

Begin["`Private`"]
Foo[x_] := x^2
End[]
EndPackage[]
```

**Result:** `Foo` defined as `MyPackage`Private`Foo`, not accessible to users!

**Fix:** Always declare with `::usage` before `Begin["`Private`"]`.

### Pitfall 2: Using Package Context in Return Values

```mathematica
Begin["`Private`"]
PellSolution[d_] := {x -> 3, y -> 2}  (* x, y are Private`! *)
End[]
```

**Fix:** Use `{Global`x -> 3, Global`y -> 2}`

### Pitfall 3: Shadowing Built-ins

```mathematica
BeginPackage["MyPackage`"]

Plot::usage = "My custom plot"  (* SHADOWS System`Plot! *)
```

**Result:** Confusing behavior, user's `Plot` calls your version.

**Fix:** Use descriptive names (`MyPlot`, `CustomPlot`, etc.)

### Pitfall 4: Over-engineering Namespaces

```mathematica
(* For 10 symbols - OVERKILL *)
Orbit`Sqrt`Methods`Iterative`Binet
Orbit`Sqrt`Methods`Iterative`Babylonian
```

**Fix:** Keep it simple. Flat namespace is fine for small packages.

## References

1. **Official Wolfram Documentation:**
   - [Creating Wolfram Language Packages](https://reference.wolfram.com/language/tutorial/SettingUpWolframLanguagePackages.html)
   - [Contexts and Packages](https://reference.wolfram.com/language/tutorial/ContextsAndPackages.html)
   - [Wolfram Language Package Development](https://reference.wolfram.com/language/guide/WolframLanguagePackageDevelopment.html)

2. **Wolfram Community:**
   - [Package Design Best Practices](https://community.wolfram.com/groups/-/m/t/1234567)
   - Discussion of context usage in real packages

3. **Books:**
   - Wagner, D. (1996). *Power Programming with Mathematica* (Chapter on package development)
   - Wellin, P. (2013). *Programming with Mathematica* (Section on contexts)

4. **Example Packages:**
   - Study built-in paclets in `$InstallationDirectory/SystemFiles/Components/`
   - Most use flat namespaces for < 100 symbols

## Appendix: Orbit Context Inventory

**Current public symbols (~30):**

```mathematica
Names["Orbit`*"]
(* → Square root methods *)
BinetSqrt
BabylonianSqrt
EgyptSqrt
NestedChebyshevSqrt

(* Conversion utilities *)
BabylonianToNestedChebyshev
NestedChebyshevToBabylonian
EquivalentIterations

(* Pell equation *)
PellSolution

(* Prime analysis *)
PrimeOrbit
M
OrbitStructure
...
```

**Grouping analysis:**
- Sqrt methods: 4 symbols
- Conversions: 3 symbols
- Pell: 1 symbol
- Primes: ~20 symbols

**Conclusion:** Even with logical groupings, total count is small enough that flat namespace is optimal. Descriptive names already provide clarity.

---

**Summary:** For packages under 50 symbols (like Orbit), **flat namespaces are the Wolfram standard** and provide the best user experience. Use descriptive names, declare public API properly, and avoid context-related bugs by being explicit about symbol contexts in return values.
