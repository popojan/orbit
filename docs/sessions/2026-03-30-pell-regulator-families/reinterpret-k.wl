pslv[nn_] := {x, y} /. First@FindInstance[x x - nn y y == 1, {x, y}, PositiveIntegers]
sqfree[n_] := Times @@ (Power @@@ ({#1, Mod[#2, 2]} & @@@ FactorInteger[n]))

(* REINTERPRETATION: group by actual k value, not k/m ratio *)
Print["=== REGROUP BY k (not k/m) ===\n"];

cases = {};
Do[
  If[IntegerQ[Sqrt[n0]], Continue[]];
  {xf, yf} = pslv[n0]; Rf = Log[N[xf + yf*Sqrt[n0], 50]];
  Do[
    cn = c^2*n0; a0 = Floor[Sqrt[cn]]; r = cn - a0^2;
    If[r > 0 && Denominator[(2a0^2+r)/r] <= 2,
      z = (2a0^2+r)/r; w = 2a0/r;
      Catch[Do[
        xc = ChebyshevT[m, z]; Yc = w*ChebyshevU[m-1, z];
        If[IntegerQ[xc] && IntegerQ[Yc] && xc > 0,
          yn = c*Yc; Rc = Log[N[xc + yn*Sqrt[n0], 50]];
          k = Round[Rc/Rf];
          AppendTo[cases, {n0, c, k, m}];
          Throw[True]],
      {m, 1, 20}]]],
  {c, 1, 15}],
{n0, 2, 1000}];

Print["Total: ", Length[cases], " pairs\n"];

Print["By k value:"];
kTally = Tally[#[[3]] & /@ cases] // SortBy[-#[[2]] &];
Do[Print["  k=", e[[1]], ": ", e[[2]], " cases (",
  Round[100. e[[2]]/Length[cases], 0.1], "%)"], {e, kTally}];

Print["\nBy (k, m) pair:"];
kmTally = Tally[{#[[3]], #[[4]]} & /@ cases] // SortBy[-#[[2]] &];
Do[
  {{kv, mv}, cnt} = e;
  If[cnt >= 5,
    Print["  k=", kv, " m=", mv, ": ", cnt, " cases",
      If[kv == 1, "  *** FUNDAMENTAL ***", ""]]],
{e, kmTally}];

Print["\n=== THE REAL PICTURE ===\n"];
k1 = Count[cases, e_ /; e[[3]] == 1];
Print["k = 1 (FUNDAMENTAL): ", k1, "/", Length[cases],
  " = ", Round[100. k1/Length[cases], 0.1], "%\n"];

Print["These break down by m:"];
k1cases = Select[cases, #[[3]] == 1 &];
m1Tally = Tally[#[[4]] & /@ k1cases] // SortBy[First];
Do[Print["  k=1, m=", e[[1]], ": ", e[[2]], " cases"], {e, m1Tally}];

Print["\nNon-fundamental (k > 1): ", Length[cases] - k1, " cases (",
  Round[100. (Length[cases]-k1)/Length[cases], 0.1], "%)"];
kgt1 = Select[cases, #[[3]] > 1 &];
kgt1Tally = Tally[{#[[3]], #[[4]]} & /@ kgt1] // SortBy[-#[[2]] &];
Do[{{kv, mv}, cnt} = e;
  Print["  k=", kv, " m=", mv, ": ", cnt, " cases"],
{e, kgt1Tally[[;;Min[15, Length[kgt1Tally]]]]}];
