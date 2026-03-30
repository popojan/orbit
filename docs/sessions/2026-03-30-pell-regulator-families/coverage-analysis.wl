pslv[nn_] := {x, y} /. First@FindInstance[x x - nn y y == 1, {x, y}, PositiveIntegers]

(* Count distinct n <= N solvable by each approach *)

Nmax = 100000;

(* OLD: n = 4k^2 + 2^a, v2(k) >= ceil((a-4)/2) *)
oldSet = {};
Do[
  minV2 = Max[0, Ceiling[(a-4)/2]];
  Do[
    k0 = 2^minV2 * j; n = 4k0^2 + 2^a;
    If[n <= Nmax && !IntegerQ[Sqrt[n]], AppendTo[oldSet, n]],
  {j, 1, Ceiling[Sqrt[Nmax]/2]}],
{a, 3, Floor[Log[2, Nmax]]}];
oldSet = Union[oldSet];

(* NEW: n = a0^2 + r for r = p * 2^b, with p|a0 and Chebyshev condition *)
newSet = {};
Do[
  r = p0 * 2^b0;
  minV2 = Max[0, Ceiling[(b0-2)/2]];
  Do[
    a0 = p0 * 2^minV2 * j;
    n = a0^2 + r;
    If[n <= Nmax && !IntegerQ[Sqrt[n]], AppendTo[newSet, n]],
  {j, 1, Ceiling[Sqrt[Nmax]]}],
{p0, {3, 5, 7, 11, 13}}, {b0, {0, 1, 2, 3, 4}}];
newSet = Union[newSet];

(* Also add r with TWO odd primes: r = p*q*2^b *)
extraSet = {};
Do[
  r = p0*q0 * 2^b0;
  If[r <= 1000,
    minV2 = Max[0, Ceiling[(b0-2)/2]];
    Do[
      a0 = p0*q0 * 2^minV2 * j;
      n = a0^2 + r;
      If[n <= Nmax && !IntegerQ[Sqrt[n]], AppendTo[extraSet, n]],
    {j, 1, Ceiling[Sqrt[Nmax]]}]],
{p0, {3, 5, 7}}, {q0, {3, 5, 7}}, {b0, {0, 1, 2}}];
extraSet = Union[extraSet];

combined = Union[oldSet, newSet, extraSet];

totalNonSq = Nmax - Floor[Sqrt[Nmax]];

Print["=== COVERAGE COMPARISON for n ≤ ", Nmax, " ===\n"];
Print["Total non-square n: ", totalNonSq];
Print[];
Print["OLD (paper: r = 2^a only):     ", Length[oldSet],
  " n  (", Round[100. Length[oldSet]/totalNonSq, 0.01], "%)"];
Print["NEW (r = p*2^b, single prime):  ", Length[newSet],
  " n  (", Round[100. Length[newSet]/totalNonSq, 0.01], "%)"];
Print["EXTRA (r = p*q*2^b, two primes): ", Length[extraSet],
  " n  (", Round[100. Length[extraSet]/totalNonSq, 0.01], "%)"];
Print[];

genuinelyNew = Complement[newSet, oldSet];
genuinelyExtra = Complement[extraSet, oldSet, newSet];

Print["Genuinely NEW (not in old):      ", Length[genuinelyNew],
  " n  (", Round[100. Length[genuinelyNew]/totalNonSq, 0.01], "%)"];
Print["Genuinely EXTRA beyond new:      ", Length[genuinelyExtra],
  " n  (", Round[100. Length[genuinelyExtra]/totalNonSq, 0.01], "%)"];
Print[];

Print["COMBINED (old + new + extra):     ", Length[combined],
  " n  (", Round[100. Length[combined]/totalNonSq, 0.01], "%)"];
Print[];
Print["Gain from adding odd primes:      +", Length[genuinelyNew] + Length[genuinelyExtra],
  " n  (+", Round[100. (Length[genuinelyNew]+Length[genuinelyExtra])/Length[oldSet], 0.1], "% over old)"];

Print["\n=== BREAKDOWN by r ===\n"];
Do[
  r = r0;
  fac = FactorInteger[r];
  oddPart = Times @@ (Power @@@ Select[fac, #[[1]] > 2 &]);
  b = IntegerExponent[r, 2];
  minV2 = Max[0, Ceiling[(b-2)/2]];
  rSet = {};
  Do[
    a0 = oddPart * 2^minV2 * j;
    n = a0^2 + r;
    If[n <= Nmax && !IntegerQ[Sqrt[n]], AppendTo[rSet, n]],
  {j, 1, Ceiling[Sqrt[Nmax]]}];
  rSet = Union[rSet];
  newOnly = Length[Complement[rSet, oldSet]];
  Print["  r=", StringPadRight[ToString[r], 5],
    " (", StringPadRight[ToString[fac], 20], ")",
    " covers ", StringPadRight[ToString[Length[rSet]], 5], " n",
    "  of which ", newOnly, " are NEW"],
{r0, {3,5,6,7,10,12,14,15,20,21,24,28,30,35,40,42,45,56,60}}];

Print["\n=== FIRST FEW GENUINELY NEW n ===\n"];
Print[genuinelyNew[[;;Min[20, Length[genuinelyNew]]]]];
