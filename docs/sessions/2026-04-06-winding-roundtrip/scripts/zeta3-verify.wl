(* ================================================================ *)
(* Verify ζ(3) connection: are the smallest never-singular k       *)
(* actually convergents of Apéry's constant?                       *)
(* ================================================================ *)

nMax = 50;
gList = Table[N[Im[ZetaZero[n]], 20], {n, nMax}];
lpList = Table[Log[N[Prime[j], 20]], {j, nMax}];

fWM[nz_, k_] := Table[
  Floor[k gList[[n]] lpList[[j]] / (2 Pi)], {n, nz}, {j, nz}]

firstSingular[k_] := Module[{},
  Do[If[Det[fWM[n, k]] == 0, Return[n, Module]], {n, 3, nMax}]; 0]

(* ζ(3) convergents *)
Print["=== ζ(3) = ", N[Zeta[3], 15], " ==="];
cfZ3 = ContinuedFraction[Zeta[3], 20];
Print["CF: ", cfZ3];
convZ3 = Convergents[cfZ3];
Print["Convergents: ", convZ3, "\n"];

Print["=== Singularity test for ζ(3) convergents ==="];
Do[
  k = convZ3[[i]];
  fs = firstSingular[k];
  Print["  k=", k, " ≈ ", NumberForm[N[k], {10, 7}],
    "  CF prefix: ", ContinuedFraction[k],
    If[fs == 0, "  ★ NEVER SINGULAR",
      "  first sing at n=" <> ToString[fs]]],
{i, Length[convZ3]}];

(* Also: test ζ(3) exact (irrational) *)
Print["\n=== ζ(3) exact (irrational) ==="];
fsExact = firstSingular[Zeta[3]];
Print["  k=ζ(3) ≈ ", N[Zeta[3], 10],
  If[fsExact == 0, "  ★ NEVER SINGULAR",
    "  first sing at n=" <> ToString[fsExact]]];

(* Compare: ζ(2), ζ(4), ζ(5) *)
Print["\n=== Other zeta values ==="];
Do[
  fs = firstSingular[Zeta[s]];
  Print["  k=ζ(", s, ") ≈ ", NumberForm[N[Zeta[s]], {8, 6}],
    If[fs == 0, "  ★ NEVER SINGULAR",
      "  first sing at n=" <> ToString[fs]]],
{s, {2, 3, 4, 5, 6, 7}}];

(* Where exactly does the transition happen?
   ζ(3) convergents: which are never-singular, which aren't? *)
Print["\n=== ζ(3) convergent quality ==="];
Do[
  k = convZ3[[i]];
  approxErr = Abs[N[k] - Zeta[3]];
  fs = firstSingular[k];
  Print["  ", PaddedForm[ToString[k], 10], " ≈ ",
    NumberForm[N[k], {10, 7}],
    "  |k-ζ(3)|=", ScientificForm[approxErr, 3],
    If[fs == 0, "  ★ NS", "  sing@" <> ToString[fs]]],
{i, Length[convZ3]}];

(* Is ζ(3) special among values near 1.202?
   Test k = 1.200, 1.201, ..., 1.210 (fine grid) *)
Print["\n=== Fine grid near ζ(3) ==="];
Do[
  k = n/1000;
  fs = firstSingular[k];
  If[fs == 0 || fs >= 30,
    Print["  k=", NumberForm[k, {6, 3}],
      If[fs == 0, "  ★ NS", "  sing@" <> ToString[fs]]]],
{n, 1190, 1210}];
