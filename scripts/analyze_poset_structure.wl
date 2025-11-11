#!/usr/bin/env wolframscript

(* Analysis of partial order structure on gap-children via orbit inclusion *)

(* Load local Orbit paclet *)
SetDirectory[ParentDirectory[DirectoryName[$InputFileName]]];
PacletDirectoryLoad["Orbit"];
Needs["Orbit`"];

(* Configuration *)
pmax = 10000;
sampleSize = 50;  (* Analyze top N hub primes *)

Print["Analyzing partial order structure on gap-children..."];
Print["Prime range: up to ", pmax];
Print[""];

(* Find primes with significant gaps (≥2 for meaningful poset analysis) *)
primes = Select[Range[2, pmax], PrimeQ];
gaps = Table[{p, NextPrime[p] - p}, {p, primes}];
gapsFiltered = Select[gaps, Last[#] >= 2 &];  (* Need at least 2 gap-children for pairs *)
hubPrimes = TakeLargest[gapsFiltered, sampleSize, Last][[All, 1]];

Print["Analyzing ", Length[hubPrimes], " primes with largest gaps"];
Print["Gaps range: ", MinMax[hubPrimes /. p_ :> NextPrime[p] - p]];
Print[""];

(* Compute poset statistics *)
Print["Computing poset statistics..."];
results = Table[PosetStatistics[p], {p, hubPrimes}];

(* Summary statistics *)
incompPercentages = #["Incomparable %"] & /@ results;
gapSizes = #["Gap"] & /@ results;

(* Safely compute statistics, handling edge cases *)
SafeMean[x_] := If[Length[x] > 0, N[Mean[x]], 0];
SafeStdDev[x_] := If[Length[x] > 1, N[StandardDeviation[x]], 0];
SafeCorr[x_, y_] := If[Length[x] > 1 && Length[y] > 1, N[Correlation[x, y]], 0];

summary = {
  "Total primes analyzed" -> Length[results],
  "Mean incomparability %" -> SafeMean[incompPercentages],
  "Std dev incomparability %" -> SafeStdDev[incompPercentages],
  "Min incomparability %" -> If[Length[incompPercentages] > 0, Min[incompPercentages], 0],
  "Max incomparability %" -> If[Length[incompPercentages] > 0, Max[incompPercentages], 0],
  "Correlation (gap vs incomp %)" -> SafeCorr[gapSizes, incompPercentages]
};

(* Identify interesting cases *)
fullyComparable = Select[results, #["Incomparable"] == 0 &];
highlyIncomparable = Select[results, #["Incomparable %"] > 80 &];

(* Generate markdown report *)
report = StringJoin[{
  "# Partial Order Structure Analysis\n\n",
  "Analysis of gap-children posets via orbit subset inclusion.\n\n",
  "## Configuration\n\n",
  "- **Prime range:** up to ", ToString[pmax], "\n",
  "- **Primes analyzed:** ", ToString[Length[hubPrimes]], " (largest gaps)\n",
  "- **Gap range:** ", ToString[Min[gapSizes]], " to ", ToString[Max[gapSizes]], "\n\n",

  "## Summary Statistics\n\n",
  "| Metric | Value |\n",
  "|--------|-------|\n",
  StringJoin[Table[
    "| " <> ToString[summary[[i, 1]]] <> " | " <> ToString[NumberForm[summary[[i, 2]], {5, 2}]] <> " |\n",
    {i, Length[summary]}
  ]],
  "\n",

  "## Interpretation\n\n",
  "For each prime $p$ with gap $g$, consider the $g$ primes at indices $\\pi(p), \\pi(p)+1, \\ldots, \\pi(p)+g-1$.\n\n",
  "Define a partial order by **orbit inclusion**: prime $q_i \\preceq q_j$ if $\\text{Orbit}(q_i) \\subseteq \\text{Orbit}(q_j)$.\n\n",
  "**Incomparability:** Fraction of pairs $(q_i, q_j)$ where neither $\\text{Orbit}(q_i) \\subseteq \\text{Orbit}(q_j)$ nor $\\text{Orbit}(q_j) \\subseteq \\text{Orbit}(q_i)$.\n\n",
  "- **Low incomparability** (near 0%): Poset is close to a total order (linear chain)\n",
  "- **High incomparability** (near 100%): Many independent branches, complex structure\n\n",
  "**Correlation:** ", If[summary[[6, 2]] > 0.3, "Positive correlation suggests larger gaps tend to have more complex poset structure.",
    If[summary[[6, 2]] < -0.3, "Negative correlation suggests larger gaps tend to be more ordered.",
      "Weak correlation - incomparability appears independent of gap size."]], "\n\n",

  "## Fully Comparable Cases (Total Order)\n\n",
  If[Length[fullyComparable] == 0,
    "No cases found where all pairs are comparable (0% incomparability).\n\n",
    StringJoin[{
      "Found ", ToString[Length[fullyComparable]], " cases with 0% incomparability (total order):\n\n",
      "| Prime | Gap | Total Pairs |\n",
      "|-------|-----|-------------|\n",
      StringJoin[Table[
        "| " <> ToString[fc["Prime"]] <> " | " <> ToString[fc["Gap"]] <> " | " <> ToString[fc["Total pairs"]] <> " |\n",
        {fc, fullyComparable}
      ]],
      "\n",
      "**Interpretation:** In these cases, all gap-children have orbits forming a total order (chain) via subset inclusion.\n\n"
    }]
  ],

  "## Highly Incomparable Cases\n\n",
  If[Length[highlyIncomparable] == 0,
    "No cases found with >80% incomparability.\n\n",
    StringJoin[{
      "Found ", ToString[Length[highlyIncomparable]], " cases with >80% incomparability:\n\n",
      "| Prime | Gap | Incomparable % |\n",
      "|-------|-----|----------------|\n",
      StringJoin[Table[
        "| " <> ToString[hi["Prime"]] <> " | " <> ToString[hi["Gap"]] <> " | " <>
        ToString[NumberForm[hi["Incomparable %"], {4, 1}]] <> "% |\n",
        {hi, highlyIncomparable}
      ]],
      "\n",
      "**Interpretation:** In these cases, most pairs of gap-children have non-comparable orbits (neither is a subset of the other).\n\n"
    }]
  ],

  "## Detailed Results\n\n",
  "Top 20 primes by gap size:\n\n",
  "| Prime | Gap | Total Pairs | Incomparable | Incomparable % |\n",
  "|-------|-----|-------------|--------------|----------------|\n",
  StringJoin[Table[
    "| " <> ToString[r["Prime"]] <> " | " <> ToString[r["Gap"]] <> " | " <>
    ToString[r["Total pairs"]] <> " | " <> ToString[r["Incomparable"]] <> " | " <>
    ToString[NumberForm[r["Incomparable %"], {4, 1}]] <> "% |\n",
    {r, Take[results, Min[20, Length[results]]]}
  ]],
  "\n",

  "## Open Questions\n\n",
  "1. **Is the poset ever a lattice?** (Do all pairs have a least upper bound and greatest lower bound?)\n",
  "2. **Is the poset ever a tree?** (Single root, no incomparability except siblings?)\n",
  "3. **What determines the poset structure?** Arithmetic properties of the prime? The gap size?\n",
  "4. **Does incomparability correlate with orbit length variance?**\n\n",

  "---\n\n",
  "*Generated by analyze_poset_structure.wl*\n"
}];

(* Export report *)
Export["reports/poset_structure_analysis.md", report, "Text"];

Print["✓ Analysis complete"];
Print["✓ Report exported to reports/poset_structure_analysis.md"];
Print[""];
Print["Summary: Mean incomparability = ", NumberForm[summary[[2, 2]], {4, 1}], "%"];
