(* ================================================================ *)
(* FULL ENUMERATION: all valid 3×3 rank-1 floor matrices            *)
(* C1 (rank-1 floor) + C2 (monotone) + C3 (W₁₁=1)                 *)
(* Then: which also satisfy C4 (e^ℓ ∈ ℤ)?                          *)
(* ================================================================ *)

wEx = {{1, 2, 3}, {2, 3, 5}, {2, 4, 6}};
Print["Exact W: ", wEx, "  (columns: {2,3,5})\n"];

(* For column integers {k1,k2,k3}: find valid rows and count matrices *)
analyzeColumns[{k1_, k2_, k3_}] := Module[
  {lnk, bps, rows, validRows, nRows, count = 0, hasExact = False},
  lnk = Log[N[{k1, k2, k3}, 20]];

  (* Find all breakpoints of ⌊a·ln(kⱼ)⌋ for a ∈ (0, aMax) *)
  bps = Union[Flatten[Table[m/lnk[[j]],
    {j, 3}, {m, 1, 200}]]];
  bps = Select[Sort[bps], 0 < # <= 25. &];  (* a up to ~25, covers γ₅₀/(2π) *)

  (* Evaluate row at midpoint of each interval *)
  rows = {};
  Do[Module[{a = (bps[[i]] + bps[[i + 1]]) / 2, row},
    row = Table[Floor[a lnk[[j]]], {j, 3}];
    If[row[[1]] >= 1, AppendTo[rows, row]]],
  {i, Length[bps] - 1}];
  validRows = Union[rows];
  nRows = Length[validRows];

  (* Count monotone 3-tuples *)
  Do[
    If[AllTrue[Range[3], validRows[[b, #]] >= validRows[[a, #]] &],
      Do[
        If[AllTrue[Range[3], validRows[[c, #]] >= validRows[[b, #]] &],
          count++;
          If[{validRows[[a]], validRows[[b]], validRows[[c]]} === wEx,
            hasExact = True]],
      {c, b, nRows}]],
  {a, nRows}, {b, a, nRows}];

  {nRows, count, hasExact}
]

(* === Enumerate ALL integer column triples 2 ≤ k1 < k2 < k3 ≤ maxK === *)
maxK = 20;

Print["=== ALL integer columns {k1,k2,k3} from 2..", maxK, " ===\n"];
allResults = {};
totalMats = 0; totalCols = 0; exactIn = {};
Do[
  {nr, nm, fe} = analyzeColumns[{k1, k2, k3}];
  totalMats += nm; totalCols++;
  AppendTo[allResults, {{k1, k2, k3}, nr, nm, fe}];
  If[fe, AppendTo[exactIn, {k1, k2, k3}]];
  If[nm > 0,
    Print["  {", k1, ",", k2, ",", k3, "}: ",
      nr, " rows, ", nm, " mats",
      If[fe, " ★ EXACT", ""]]],
{k1, 2, maxK-2}, {k2, k1+1, maxK-1}, {k3, k2+1, maxK}];

Print["\nC4 (all integers): ", totalCols, " column triples, ",
  totalMats, " total matrices"];
Print["Exact W in: ", exactIn];

(* === Now filter: k1=2, k2,k3 odd (C5) === *)
Print["\n=== C5: k1=2, rest odd ===\n"];
totalC5 = 0; colsC5 = 0;
Do[
  res = Select[allResults, #[[1]] === {2, k2, k3} &];
  If[Length[res] > 0,
    {nr, nm, fe} = Rest[res[[1]]];
    totalC5 += nm; colsC5++],
{k2, 3, maxK-1, 2}, {k3, k2+2, maxK, 2}];
Print["C5: ", colsC5, " column triples, ", totalC5, " matrices"];

(* === C7: k1=2, rest odd + coprime to smaller === *)
Print["\n=== C7: k1=2, rest odd, sieved ===\n"];
sieved = Select[Range[3, maxK, 2],
  Function[k, !AnyTrue[Range[3, k-1, 2], Mod[k, #] == 0 &]]];
Print["Sieve survivors: ", sieved];
totalC7 = 0; colsC7 = 0;
Do[
  res = Select[allResults, #[[1]] === {2, k2, k3} &];
  If[Length[res] > 0,
    {nr, nm, fe} = Rest[res[[1]]];
    totalC7 += nm; colsC7++],
{k2, sieved}, {k3, Select[sieved, # > k2 &]}];
Print["C7: ", colsC7, " column triples, ", totalC7, " matrices"];

(* === Summary === *)
Print["\n══════════════════════════════════════"];
Print["3×3 CONSTRAINT SUMMARY"];
Print["══════════════════════════════════════"];
Print["C1+C2+C3 (rank-1, mono, W₁₁=1):"];
Print["  All columns 2..", maxK, ": ", totalCols, " triples → ", totalMats, " matrices"];
Print["+ C4 (e^ℓ ∈ ℤ): same (built into enumeration)"];
Print["+ C5 (odd j>1):  ", colsC5, " triples → ", totalC5, " matrices"];
Print["+ C7 (sieved):   ", colsC7, " triples → ", totalC7, " matrices"];
Print[""];
Print["Exact W found in column triples: ", exactIn];
Print["Exact W is unique? ", totalC7 == 1 || (totalC7 > 1 && "NO")];
