(* ================================================================ *)
(* FAST constraint measurement: only C5 (odd) and C7 (sieved)      *)
(* For each column 4-tuple: count rows, count matrices              *)
(* ================================================================ *)

wEx = {{1, 2, 3, 4}, {2, 3, 5, 6}, {2, 4, 6, 7}, {3, 5, 7, 9}};

(* For given ks, find all valid rows and count ordered 4-tuples *)
analyze[ks_] := Module[{lnk, bps, rows, validRows, nRows, count = 0,
    foundExact = False, mat},
  lnk = Log[N[ks]];
  bps = Union[Flatten[Table[m/lnk[[j]],
    {j, 4}, {m, 1, Ceiling[20. lnk[[j]]]}]]];
  bps = Select[Sort[bps], 0 < # <= 20. &];
  rows = {};
  Do[Module[{a = (bps[[i]] + bps[[i+1]])/2, row},
    row = Table[Floor[a lnk[[j]]], {j, 4}];
    If[row[[1]] >= 1, AppendTo[rows, row]]],
  {i, Length[bps] - 1}];
  validRows = Union[rows];
  nRows = Length[validRows];

  (* Count monotone 4-tuples *)
  Do[
    If[AllTrue[Range[4], validRows[[b,#]] >= validRows[[a,#]] &],
      Do[
        If[AllTrue[Range[4], validRows[[c,#]] >= validRows[[b,#]] &],
          Do[
            If[AllTrue[Range[4], validRows[[d,#]] >= validRows[[c,#]] &],
              count++;
              If[{validRows[[a]], validRows[[b]],
                  validRows[[c]], validRows[[d]]} == wEx,
                foundExact = True]],
          {d, c, nRows}]],
      {c, b, nRows}]],
  {a, nRows}, {b, a, nRows}];
  {ks, nRows, count, foundExact}
]

maxK = 25;

(* C5: k1=2, rest odd *)
Print["=== C5: k₁=2, rest odd, up to ", maxK, " ===\n"];
odds = Range[3, maxK, 2];
totalC5 = 0; colsC5 = 0; found5 = False;
Do[
  {ks, nr, nm, fe} = analyze[{2, k2, k3, k4}];
  totalC5 += nm; colsC5++;
  If[fe, found5 = True;
    Print["  ★ ", ks, ": ", nr, " rows, ", nm, " matrices ← EXACT W HERE"]];
  If[nm > 0 && !fe,
    Print["  ", ks, ": ", nr, " rows, ", nm, " matrices"]],
{k2, odds}, {k3, Select[odds, # > k2 &]},
{k4, Select[odds, # > k3 &]}];
Print["\nC5 total: ", colsC5, " column 4-tuples, ", totalC5, " matrices"];
Print["Exact W found: ", found5];

(* C7: k1=2, rest = odd primes-like (sieved) *)
Print["\n=== C7: k₁=2, rest odd + self-sieve ===\n"];
sieved = Select[odds,
  Function[k, !AnyTrue[Select[odds, # < k && # > 1 &],
    Mod[k, #] == 0 &]]];
Print["Sieve survivors: ", sieved, "\n"];
totalC7 = 0; colsC7 = 0; found7 = False;
Do[
  {ks, nr, nm, fe} = analyze[{2, k2, k3, k4}];
  totalC7 += nm; colsC7++;
  If[fe, found7 = True;
    Print["  ★ ", ks, ": ", nr, " rows, ", nm, " matrices ← EXACT W"]];
  If[nm > 0 && !fe,
    Print["  ", ks, ": ", nr, " rows, ", nm, " matrices"]],
{k2, sieved}, {k3, Select[sieved, # > k2 &]},
{k4, Select[sieved, # > k3 &]}];
Print["\nC7 total: ", colsC7, " column 4-tuples, ", totalC7, " matrices"];
Print["Exact W found: ", found7];

(* Summary *)
Print["\n═══════════════════════════════════"];
Print["SUMMARY"];
Print["═══════════════════════════════════"];
Print["C5 (2+odds):    ", colsC5, " col-tuples → ", totalC5, " matrices"];
Print["C7 (2+sieved):  ", colsC7, " col-tuples → ", totalC7, " matrices"];
Print["Reduction C5→C7: ×", NumberForm[N[totalC5/Max[1,totalC7]], {4,1}]];
