(* ================================================================ *)
(* CONSTRAINT POWER: measure reduction per constraint (4×4)         *)
(* ================================================================ *)

(* Exact winding matrix *)
gEx = Table[N[Im[ZetaZero[n]], 20], {n, 4}];
lpEx = Table[Log[N[Prime[j], 20]], {j, 4}];
wEx = Table[Floor[gEx[[n]] lpEx[[j]] / (2 Pi)], {n, 4}, {j, 4}];

Print["Exact W:"];
Print[wEx // MatrixForm];
Print[""];

(* === C1: row consistency check === *)
(* Row {w1,w2,w3,w4} valid iff ∃ increasing ℓ₁<ℓ₂<ℓ₃<ℓ₄ and a>0 *)
(* s.t. ⌊a·ℓⱼ⌋ = wⱼ. Equivalent: ratio intervals have increasing solution *)
rowValid[{w1_, w2_, w3_, w4_}] := Module[
  {mins, maxs, prev},
  If[w1 < 1, Return[False]];
  (* ℓⱼ/ℓ₁ ∈ [wⱼ/(w1+1), (wⱼ+1)/w1] *)
  mins = {1., w2/(w1 + 1.), w3/(w1 + 1.), w4/(w1 + 1.)};
  maxs = {1., (w2 + 1.)/w1, (w3 + 1.)/w1, (w4 + 1.)/w1};
  (* Need increasing sequence in these intervals *)
  prev = 0.;
  Do[
    If[maxs[[j]] <= prev, Return[False]];
    prev = Max[prev + 10.^-10, mins[[j]]],
  {j, 4}];
  True
]

(* === C4: column lattice — e^ℓⱼ ∈ ℤ === *)
(* For row with w1, ratio ℓⱼ/ℓ₁ ∈ [wⱼ/(w1+1), (wⱼ+1)/w1] *)
(* Need: ∃ integers k₁<k₂<k₃<k₄ with ln(kⱼ)/ln(k₁) in ratio interval *)
rowValidC4[{w1_, w2_, w3_, w4_}] := Module[
  {mins, maxs},
  If[w1 < 1, Return[False]];
  mins = {1., w2/(w1 + 1.), w3/(w1 + 1.), w4/(w1 + 1.)};
  maxs = {1., (w2 + 1.)/w1, (w3 + 1.)/w1, (w4 + 1.)/w1};
  (* Try k₁ = 2,...,20 *)
  AnyTrue[Range[2, 20], Function[k1,
    Module[{lnk1 = Log[N[k1]], prev = k1, ok = True},
      Do[
        Module[{kLo = Ceiling[k1^mins[[j]]], kHi = Floor[k1^maxs[[j]]]},
          kLo = Max[kLo, prev + 1];
          If[kLo > kHi, ok = False; Break[]];
          prev = kLo],  (* greedy: pick smallest valid *)
      {j, 2, 4}];
      ok]]]
]

(* === C5: OddQ for j>1 === *)
rowValidC5[{w1_, w2_, w3_, w4_}] := Module[
  {mins, maxs},
  If[w1 < 1, Return[False]];
  mins = {1., w2/(w1 + 1.), w3/(w1 + 1.), w4/(w1 + 1.)};
  maxs = {1., (w2 + 1.)/w1, (w3 + 1.)/w1, (w4 + 1.)/w1};
  AnyTrue[Range[2, 20], Function[k1,  (* k1 can be even (=2) *)
    Module[{lnk1 = Log[N[k1]], prev = k1, ok = True},
      Do[
        Module[{kLo = Ceiling[k1^mins[[j]]], kHi = Floor[k1^maxs[[j]]]},
          kLo = Max[kLo, prev + 1];
          (* Force odd for j > 1 *)
          If[EvenQ[kLo], kLo++];
          While[kLo <= kHi && EvenQ[kLo], kLo += 2];
          If[kLo > kHi, ok = False; Break[]];
          prev = kLo],
      {j, 2, 4}];
      ok]]]
]

(* === Enumerate === *)
maxW = 11;  (* max entry *)

Print["Enumerating rows with entries 1..", maxW, "...\n"];

c1Rows = {};
Do[
  row = {w1, w2, w3, w4};
  If[rowValid[row], AppendTo[c1Rows, row]],
{w1, 1, maxW}, {w2, w1, 2 maxW}, {w3, w2, 3 maxW}, {w4, w3, 4 maxW}];

Print["C1+C2+C3 (row consistent, monotone, w₁≥1): ", Length[c1Rows], " rows"];

c4Rows = Select[c1Rows, rowValidC4];
Print["+ C4 (e^ℓ ∈ ℤ):                            ", Length[c4Rows], " rows"];

c5Rows = Select[c4Rows, rowValidC5];
Print["+ C5 (odd for j>1):                         ", Length[c5Rows], " rows"];

Print["\nReduction: ", Length[c1Rows], " → ", Length[c4Rows],
  " → ", Length[c5Rows]];
Print["Factors:   ×", NumberForm[N[Length[c1Rows]/Length[c4Rows]], {3,1}],
  "  ×", NumberForm[N[Length[c4Rows]/Length[c5Rows]], {3,1}]];

(* Check exact rows present *)
Print["\nExact W rows:"];
Do[Print["  ", wEx[[n]], " in C1:", MemberQ[c1Rows, wEx[[n]]],
    " C4:", MemberQ[c4Rows, wEx[[n]]],
    " C5:", MemberQ[c5Rows, wEx[[n]]]],
{n, 4}];

(* === Count matrices (ordered 4-tuples of rows) === *)
Print["\n=== Counting 4×4 matrices ===\n"];

(* For each row set, count ordered 4-tuples with componentwise monotonicity *)
countMats[rows_] := Module[{count = 0, nr = Length[rows]},
  Do[
    If[AllTrue[Range[4], rows[[i2, #]] >= rows[[i1, #]] &],
      Do[
        If[AllTrue[Range[4], rows[[i3, #]] >= rows[[i2, #]] &],
          Do[
            If[AllTrue[Range[4], rows[[i4, #]] >= rows[[i3, #]] &],
              count++],
          {i4, i3, nr}]],
      {i3, i2, nr}]],
  {i1, 1, nr}, {i2, i1, nr}];
  count
]

nMatC5 = countMats[c5Rows];
Print["Matrices from C5 rows: ", nMatC5];

(* Also count for C4 if not too many rows *)
If[Length[c4Rows] <= 500,
  nMatC4 = countMats[c4Rows];
  Print["Matrices from C4 rows: ", nMatC4],
  Print["C4 rows too many (", Length[c4Rows], ") for matrix enumeration"]];

If[Length[c1Rows] <= 200,
  nMatC1 = countMats[c1Rows];
  Print["Matrices from C1 rows: ", nMatC1],
  Print["C1 rows too many (", Length[c1Rows], ") for matrix enumeration"]];

(* Find the exact W among C5 matrices *)
Print["\n=== Search for exact W ==="];
foundRank = 0;
matCount = 0;
Do[
  If[AllTrue[Range[4], c5Rows[[i2, #]] >= c5Rows[[i1, #]] &],
    Do[
      If[AllTrue[Range[4], c5Rows[[i3, #]] >= c5Rows[[i2, #]] &],
        Do[
          If[AllTrue[Range[4], c5Rows[[i4, #]] >= c5Rows[[i3, #]] &],
            matCount++;
            mat = {c5Rows[[i1]], c5Rows[[i2]], c5Rows[[i3]], c5Rows[[i4]]};
            If[mat == wEx, foundRank = matCount;
              Print["  FOUND exact W at position #", matCount]]],
        {i4, i3, Length[c5Rows]}]],
    {i3, i2, Length[c5Rows]}]],
{i1, 1, Length[c5Rows]}, {i2, i1, Length[c5Rows]}];

Print["  Total matrices: ", matCount];
If[foundRank > 0,
  Print["  Exact W at rank: #", foundRank, " of ", matCount],
  Print["  Exact W NOT FOUND (check row enumeration range)"]];
