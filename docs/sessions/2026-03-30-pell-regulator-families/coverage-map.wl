pslv[nn_] := {x, y} /. First@FindInstance[x x - nn y y == 1, {x, y}, PositiveIntegers]

(* For each n <= 1000: find best (c, m, k) with smallest k.
   "Covered" = we can compute a Pell solution via Chebyshev.
   "Fundamental" = k = 1. *)

Nmax = 1000; Cmax = 30;

results = {};
Do[
  If[IntegerQ[Sqrt[n0]], Continue[]];
  {xf, yf} = pslv[n0]; Rf = Log[N[xf + yf*Sqrt[n0], 50]];
  bestK = Infinity; bestEntry = {};
  Do[
    cn = c^2*n0; a0 = Floor[Sqrt[cn]]; r = cn - a0^2;
    If[r > 0 && Denominator[(2a0^2+r)/r] <= 2,
      z = (2a0^2+r)/r; w = 2a0/r;
      Catch[Do[
        xc = ChebyshevT[m, z]; Yc = w*ChebyshevU[m-1, z];
        If[IntegerQ[xc] && IntegerQ[Yc] && xc > 0,
          yn = c*Yc; Rc = Log[N[xc + yn*Sqrt[n0], 50]];
          k = Round[Rc/Rf];
          If[k < bestK, bestK = k; bestEntry = {c, m, k, r, z}];
          Throw[True]],
      {m, 1, 15}]]],
  {c, 1, Cmax}];
  AppendTo[results, {n0, bestK, bestEntry}],
{n0, 2, Nmax}];

(* Classification *)
fundamental = Select[results, #[[2]] == 1 &];
covered = Select[results, #[[2]] < Infinity &];
uncovered = Select[results, #[[2]] == Infinity &];

Print["=== COVERAGE MAP n = 2..1000, c <= 30 ===\n"];
Print["Fundamental (k=1): ", Length[fundamental], "/", Length[results],
  " = ", Round[100. Length[fundamental]/Length[results], 0.1], "%"];
Print["Covered (any k):   ", Length[covered], "/", Length[results],
  " = ", Round[100. Length[covered]/Length[results], 0.1], "%"];
Print["UNCOVERED:          ", Length[uncovered], "/", Length[results],
  " = ", Round[100. Length[uncovered]/Length[results], 0.1], "%"];

Print["\n=== UNCOVERED n <= 1000 ===\n"];
uncovN = #[[1]] & /@ uncovered;
Print[uncovN];
Print["\nCount: ", Length[uncovN]];

(* Check specific n values asked by user *)
Print["\n=== SPECIFIC n VALUES ===\n"];
Do[
  entry = SelectFirst[results, #[[1]] == n0 &];
  If[entry =!= Missing["NotFound"],
    {nn, bk, be} = entry;
    If[bk < Infinity,
      {cc, mm, kk, rr, zz} = be;
      {xf, yf} = pslv[nn];
      Print["n=", nn, ": c=", cc, " m=", mm, " k=", kk,
        " r=", rr, " z=", zz,
        If[kk==1, " FUNDAMENTAL", " (need "<>ToString[kk]<>"-th root)"],
        "  fund=(", xf, ",", yf, ")"],
      Print["n=", nn, ": UNCOVERED (no c <= 30 gives δ ≤ 2)"]]],
{n0, {61, 127, 193, 409, 541, 991, 661, 811, 431, 311}}];

(* What do uncovered n have in common? *)
Print["\n=== ANALYSIS OF UNCOVERED n ===\n"];
Print["First 50: ", uncovN[[;;Min[50, Length[uncovN]]]]];
Print[];
Print["Are they all prime?"];
primeCount = Count[uncovN, _?PrimeQ];
Print["  Prime: ", primeCount, "/", Length[uncovN]];
Print["  Composite: ", Length[uncovN] - primeCount];
Print[];
Print["n mod 4: ", Tally[Mod[uncovN, 4]]];
Print["n mod 8: ", Tally[Mod[uncovN, 8]]];

(* CF period distribution *)
Print["\nCF period L of uncovered n:"];
Lvals = Table[
  cf = ContinuedFraction[Sqrt[n0]];
  If[Length[cf]==2, Length[cf[[2]]], -1],
{n0, uncovN}];
Print["  min L: ", Min[Lvals], "  max L: ", Max[Lvals],
  "  mean L: ", Round[N@Mean[Lvals], 0.1]];
Print["  L distribution: ", Tally[Lvals] // SortBy[-#[[2]]&] // Short];

(* Compare with covered n *)
covN = #[[1]] & /@ covered;
LvalsCov = Table[
  cf = ContinuedFraction[Sqrt[n0]];
  If[Length[cf]==2, Length[cf[[2]]], -1],
{n0, covN}];
Print["\nCF period of COVERED n:"];
Print["  min L: ", Min[LvalsCov], "  max L: ", Max[LvalsCov],
  "  mean L: ", Round[N@Mean[LvalsCov], 0.1]];
