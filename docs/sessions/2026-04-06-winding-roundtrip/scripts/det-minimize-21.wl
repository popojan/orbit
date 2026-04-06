(* ================================================================ *)
(* Find scaling k that minimizes |det(W^(k))| for n=21             *)
(* Goal: find k with |det| = 1 (unimodular) or small              *)
(* ================================================================ *)

nMax = 21;
gList = Table[N[Im[ZetaZero[n]], 30], {n, nMax}];
lpList = Table[Log[N[Prime[j], 30]], {j, nMax}];

fWM[k_] := Table[
  Floor[k gList[[n]] lpList[[j]] / (2 Pi)], {n, nMax}, {j, nMax}]

(* First: verify user's finding *)
Print["=== Verify k = 4π/3 ==="];
k43pi = 4 Pi / 3;
d = Det[fWM[k43pi]];
Print["k = 4π/3 ≈ ", N[k43pi], "  det = ", d];

(* Scan rational k in interesting ranges *)
Print["\n=== Scan: |det| for rational k near small values ==="];
Print["Looking for |det| ≤ 12...\n"];

results = {};
Do[
  k = p/q;
  If[k <= 0 || k > 10, Continue[]];
  d = Det[fWM[k]];
  ad = Abs[d];
  If[ad > 0 && ad <= 12,
    AppendTo[results, {k, d, ad}];
  ],
{q, 1, 80}, {p, 1, 10 q}];

results = SortBy[results, #[[3]] &];
Print["Found ", Length[results], " scalings with 0 < |det| ≤ 12"];
Print["\nSmallest |det|:"];
Do[
  {k, d, ad} = results[[i]];
  Print["  k=", k, " = ", NumberForm[N[k], {8, 5}],
    "  det=", d, "  |det|=", ad],
{i, Min[30, Length[results]]}];

(* Search specifically for |det| = 1 *)
Print["\n=== Search for unimodular (|det|=1) ==="];
unimod = Select[results, #[[3]] == 1 &];
Print["Found: ", Length[unimod]];
Do[
  {k, d, ad} = unimod[[i]];
  Print["  k=", k, " = ", NumberForm[N[k], {8, 5}], "  det=", d],
{i, Min[20, Length[unimod]]}];

(* Also try irrational scalings *)
Print["\n=== Irrational scalings ==="];
irrationals = {
  {4 Pi/3, "4π/3"}, {Pi, "π"}, {2 Pi, "2π"}, {Pi/2, "π/2"},
  {E, "e"}, {Sqrt[2 Pi], "√(2π)"}, {Pi^2/6, "ζ(2)"},
  {Log[2 Pi], "ln(2π)"}, {E Pi, "eπ"},
  {Pi/E, "π/e"}, {Sqrt[2] Pi, "√2·π"}, {Pi/3, "π/3"},
  {2 Pi/3, "2π/3"}, {5 Pi/3, "5π/3"}, {Pi/4, "π/4"},
  {3 Pi/4, "3π/4"}, {5 Pi/4, "5π/4"}, {7 Pi/4, "7π/4"},
  {Pi/6, "π/6"}, {5 Pi/6, "5π/6"}, {7 Pi/6, "7π/6"},
  {11 Pi/6, "11π/6"},
  (* sphere-related *)
  {4 Pi, "4π (sphere)"}, {4 Pi/3, "4π/3 (ball vol)"},
  {Pi^2, "π²"}, {2 Pi^2, "2π²"}
};
Do[
  {val, label} = ir;
  d = Det[fWM[val]];
  If[Abs[d] <= 100,
    Print["  ", PaddedForm[label, 12], " ≈ ",
      NumberForm[N[val], {6, 3}], "  det=", d]],
{ir, irrationals}];

(* Fine search near 4π/3 for det=1 *)
Print["\n=== Fine search near 4π/3 (rational p/q, q≤200) ==="];
target = N[4 Pi/3];
fineResults = {};
Do[
  k = p/q;
  If[Abs[N[k] - target] > 0.1, Continue[]];
  d = Det[fWM[k]];
  ad = Abs[d];
  If[ad > 0 && ad <= 12,
    AppendTo[fineResults, {k, d}]],
{q, 1, 200}, {p, Max[1, Floor[(target - 0.1) q]], Ceiling[(target + 0.1) q]}];
fineResults = SortBy[fineResults, Abs[#[[2]]] &];
Print["Near 4π/3, |det| ≤ 12:"];
Do[
  {k, d} = fineResults[[i]];
  Print["  k=", k, " ≈ ", NumberForm[N[k], {8, 5}], "  det=", d],
{i, Min[20, Length[fineResults]]}];
