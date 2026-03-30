pslv[nn_] := {x, y} /. First@FindInstance[x x - nn y y == 1, {x, y}, PositiveIntegers]

Print["=== COMPREHENSIVE k vs m ANALYSIS ===\n"];

(* For each n <= 200, each c <= 30: compute k and m, record mismatches *)
matches = 0; mismatches = 0; allPairs = {};

Do[
  If[IntegerQ[Sqrt[n0]], Continue[]];
  {xf, yf} = pslv[n0];
  Rf = Log[N[xf + yf*Sqrt[n0], 50]];
  Do[
    cn = c^2*n0; a0 = Floor[Sqrt[cn]]; r = cn - a0^2;
    If[r > 0 && Denominator[(2a0^2+r)/r] <= 2,
      z = (2a0^2+r)/r; w = 2a0/r;
      Catch[Do[
        xc = ChebyshevT[m, z]; Yc = w*ChebyshevU[m-1, z];
        If[IntegerQ[xc] && IntegerQ[Yc] && xc > 0,
          yn = c*Yc;
          Rc = Log[N[xc + yn*Sqrt[n0], 50]];
          k = Round[Rc/Rf];
          AppendTo[allPairs, {n0, c, k, m, k/m}];
          If[k == m, matches++, mismatches++];
          Throw[True]],
      {m, 1, 20}]]],
  {c, 1, 30}],
{n0, 2, 200}];

Print["Total pairs: ", Length[allPairs]];
Print["k = m: ", matches, " (", Round[100. matches/Length[allPairs], 0.1], "%)"];
Print["k ≠ m: ", mismatches, " (", Round[100. mismatches/Length[allPairs], 0.1], "%)\n"];

(* Show all mismatches *)
Print["=== ALL MISMATCHES (k ≠ m) ===\n"];
Print[StringPadRight["n", 5], StringPadRight["c", 4],
  StringPadRight["k", 5], StringPadRight["m", 4],
  StringPadRight["k/m", 8], "notes"];
Print[StringJoin[Table["-", {35}]]];

mismatchList = Select[allPairs, #[[3]] != #[[4]] &];
Do[
  {n0, c0, k0, m0, rat} = entry;
  Print[StringPadRight[ToString[n0], 5],
    StringPadRight[ToString[c0], 4],
    StringPadRight[ToString[k0], 5],
    StringPadRight[ToString[m0], 4],
    StringPadRight[ToString[N[rat, 4]], 8],
    "k/m=", k0, "/", m0, "=", If[IntegerQ[k0/m0], ToString[k0/m0], ToString[N[k0/m0,3]]]],
{entry, mismatchList}];

Print["\n=== DISTRIBUTION of k/m ===\n"];
ratios = #[[5]] & /@ allPairs;
Print["k/m values: ", Union[Round[#, 0.001] & /@ ratios]];
Print["k/m = 1: ", Count[ratios, x_ /; Abs[x-1] < 0.01], " cases"];
Print["k/m integer: ", Count[ratios, x_ /; Abs[x - Round[x]] < 0.01], " cases"];
Print["k/m = integer > 1: ",
  Count[ratios, x_ /; Abs[x - Round[x]] < 0.01 && Round[x] > 1], " cases"];
