(* ================================================================ *)
(* Which breakpoints (i,j) are CLOSEST to ζ(3) across many n?     *)
(* A breakpoint k = m/(a_i·ℓ_j) near ζ(3) means                  *)
(*   ζ(3) · a_i · ℓ_j ≈ integer m                                 *)
(* i.e. ζ(3) · γ_i · ln(p_j) / (2π) ≈ integer                   *)
(*                                                                  *)
(* This is a DIOPHANTINE condition on ζ(3).                        *)
(* ================================================================ *)

gList = Table[N[Im[ZetaZero[n]], 25], {n, 30}];
lpList = Table[Log[N[Prime[j], 25]], {j, 30}];
z3 = N[Zeta[3], 25];

(* For each (i,j), compute ζ(3) · a_i · ℓ_j and its fractional part *)
Print["╔══════════════════════════════════════════════════════╗"];
Print["║  DIOPHANTINE: {ζ(3) · γ_i · ln(p_j) / (2π)}        ║"];
Print["╚══════════════════════════════════════════════════════╝\n"];

(* Compute x_{ij} = ζ(3) · γ_i · ln(p_j) / (2π) *)
(* Breakpoint distance to ζ(3) = min({x}, 1-{x}) / (a_i · ℓ_j) *)
Print["=== Fractional parts closest to 0 or 1 ==="];
Print["(These create breakpoints nearest to ζ(3))\n"];

fracData = {};
Do[
  x = z3 * gList[[i]] * lpList[[j]] / (2 Pi);
  frac = FractionalPart[x];
  distToInt = Min[frac, 1 - frac];
  (* Distance in k-space: distToInt / (a_i · ℓ_j) *)
  aill = gList[[i]] * lpList[[j]] / (2 Pi);
  kDist = distToInt / aill;
  AppendTo[fracData, {i, j, x, frac, distToInt, kDist, Prime[j]}],
{i, 20}, {j, 20}];

(* Sort by k-distance (breakpoint proximity to ζ(3)) *)
fracData = SortBy[fracData, #[[6]] &];

Print["(i,j)   p_j   ζ(3)·γ_i·ln(p_j)/(2π)   {x}      dist_to_int  Δk"];
Do[
  {i, j, x, frac, dti, dk, pj} = fracData[[idx]];
  Print["  (", i, ",", j, ")  p=", PaddedForm[pj, 3],
    "  x=", NumberForm[x, {10, 6}],
    "  {x}=", NumberForm[frac, {6, 4}],
    "  d=", ScientificForm[dti, 3],
    "  Δk=", ScientificForm[dk, 3]],
{idx, 25}];

(* KEY: the closest breakpoints — which (i,j) pairs dominate? *)
Print["\n=== Breakpoint frequency: which entries appear in top-50 nearest? ===\n"];
top50 = fracData[[;; 50]];
(* Count by row i *)
rowCounts = Tally[top50[[All, 1]]] // SortBy[#, -#[[2]] &] &;
Print["By row (zero index i): ", rowCounts];
(* Count by column j *)
colCounts = Tally[top50[[All, 2]]] // SortBy[#, -#[[2]] &] &;
Print["By col (prime index j): ", colCounts];

(* The CLOSEST breakpoint is always the same (i,j)? *)
Print["\nClosest breakpoint: (", fracData[[1, 1]], ",", fracData[[1, 2]],
  ") = γ_", fracData[[1, 1]], " · ln(", Prime[fracData[[1, 2]]], ")"];
Print["  x = ", NumberForm[fracData[[1, 3]], 15]];
Print["  {x} = ", NumberForm[fracData[[1, 4]], 15]];
Print["  Δk = ", ScientificForm[fracData[[1, 6]], 6]];

(* What IS this nearest-integer? *)
x1 = fracData[[1, 3]];
m1 = Round[x1];
Print["  Nearest integer m = ", m1];
Print["  x - m = ", NumberForm[x1 - m1, 15]];

(* ================================================================ *)
(* CRITICAL: Is ζ(3)·γ_i·ln(p_j)/(2π) close to integer            *)
(* for MANY (i,j) simultaneously?                                  *)
(* Compare with random constant: how many are within ε of integer  *)
(* ================================================================ *)
Print["\n=== ζ(3) vs random: fraction of x_{ij} within ε of integer ===\n"];
Do[
  (* Count x_{ij} with {x} < ε or {x} > 1-ε *)
  nNear = Count[fracData, _?(#[[5]] < eps &)];
  nTotal = Length[fracData];
  expected = 2 eps * nTotal;  (* for uniform {x} *)
  Print["ε=", NumberForm[eps, {4, 4}],
    "  near-integer: ", nNear, "/", nTotal,
    "  expected(uniform): ", NumberForm[expected, {5, 1}],
    "  ratio: ", NumberForm[nNear / expected, {4, 2}]],
{eps, {0.001, 0.005, 0.01, 0.05, 0.1}}];

(* Same test for k = 1 (standard winding) *)
Print["\nComparison: k=1 (standard)"];
fracData1 = {};
Do[
  x = 1 * gList[[i]] * lpList[[j]] / (2 Pi);
  frac = FractionalPart[x];
  distToInt = Min[frac, 1 - frac];
  AppendTo[fracData1, distToInt],
{i, 20}, {j, 20}];
Do[
  nNear = Count[fracData1, _?(# < eps &)];
  nTotal = Length[fracData1];
  expected = 2 eps * nTotal;
  Print["ε=", NumberForm[eps, {4, 4}],
    "  near-integer: ", nNear, "/", nTotal,
    "  expected: ", NumberForm[expected, {5, 1}],
    "  ratio: ", NumberForm[nNear / expected, {4, 2}]],
{eps, {0.001, 0.005, 0.01, 0.05, 0.1}}];
