(* Fixed: use Catch/Throw instead of Return inside Do *)
solvableQ[n0_, cmax_] := Catch[
  Do[Module[{cn, a0, r},
    cn = c^2 * n0; a0 = Floor[Sqrt[cn]]; r = cn - a0^2;
    If[r > 0 && Denominator[(2 a0^2 + r)/r] <= 2, Throw[True]]],
  {c, 1, cmax}];
  False
]

(* Quick sanity check *)
Print["Sanity: n=7 c<=3: ", solvableQ[7, 3], "  n=7 c<=1: ", solvableQ[7, 1]];
Print["Sanity: n=13 c<=1: ", solvableQ[13, 1]];
Print[];

Print["=== FIXED C, GROWING N ===\n"];
Do[
  Print["C = ", cmax, ":"];
  Do[
    Nmax = nn; count = 0;
    Do[If[!IntegerQ[Sqrt[n0]] && solvableQ[n0, cmax], count++], {n0, 2, Nmax}];
    total = Nmax - 1 - Floor[Sqrt[Nmax]];
    Print["  N=", StringPadRight[ToString[Nmax], 8],
      " count=", StringPadRight[ToString[count], 6],
      " fraction=", Round[100. count/total, 0.1], "%"],
  {nn, {500, 2000, 5000, 10000}}];
  Print[],
{cmax, {1, 10}}];

Print["=== C = sqrt(N) ===\n"];
Do[
  Nmax = nn; cmax = Max[1, Round[Sqrt[Nmax]]];
  count = 0;
  Do[If[!IntegerQ[Sqrt[n0]] && solvableQ[n0, cmax], count++], {n0, 2, Nmax}];
  total = Nmax - 1 - Floor[Sqrt[Nmax]];
  Print["  N=", StringPadRight[ToString[Nmax], 6],
    " C=", StringPadRight[ToString[cmax], 5],
    " fraction=", Round[100. count/total, 0.1], "%"],
{nn, {200, 500, 1000, 2000, 5000}}];
