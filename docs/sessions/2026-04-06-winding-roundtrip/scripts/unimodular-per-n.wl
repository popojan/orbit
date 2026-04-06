(* ================================================================ *)
(* For each n=3..30, find a scaling k with |det(W^(k))| = 1        *)
(* Also: check if ζ(3) or 11/4 or 2π give small det               *)
(* ================================================================ *)

nMax = 50;
gList = Table[N[Im[ZetaZero[n]], 20], {n, nMax}];
lpList = Table[Log[N[Prime[j], 20]], {j, nMax}];

fWM[nz_, k_] := Table[
  Floor[k gList[[n]] lpList[[j]] / (2 Pi)], {n, nz}, {j, nz}]

Print["╔══════════════════════════════════════════════════════╗"];
Print["║  UNIMODULAR SCALING PER DIMENSION                    ║"];
Print["╚══════════════════════════════════════════════════════╝\n"];

Print["n    det@ζ(3)    det@11/4    det@2π    unimod k (first found)"];
Print[StringJoin[Table["─", 75]]];

z3 = N[Zeta[3], 20];

Do[
  dz3 = Det[fWM[n, z3]];
  d114 = Det[fWM[n, 11/4]];
  d2pi = Det[fWM[n, N[2 Pi, 20]]];

  (* Search for unimodular k: try p/q with small q first *)
  uniK = None;
  Do[
    k = p/q;
    If[k <= 0 || k > 10, Continue[]];
    d = Det[fWM[n, k]];
    If[Abs[d] == 1,
      uniK = k; Break[]],
  {q, 1, 50}, {p, 1, 10 q}];

  Print[PaddedForm[n, 3], "   ",
    PaddedForm[dz3, 10], "  ",
    PaddedForm[d114, 10], "  ",
    PaddedForm[d2pi, 10], "  ",
    If[uniK =!= None,
      ToString[uniK] <> " ≈ " <> ToString[NumberForm[N[uniK], {5, 3}]],
      "NOT FOUND (q≤50)"]],
{n, 3, 30}];

(* Summary *)
Print["\n=== Summary: det magnitudes ==="];
Print["n     |det@ζ(3)|   |det@11/4|   |det@2π|"];
Do[
  dz3 = Abs[Det[fWM[n, z3]]];
  d114 = Abs[Det[fWM[n, 11/4]]];
  d2pi = Abs[Det[fWM[n, N[2 Pi, 20]]]];
  Print[PaddedForm[n, 3], "   ",
    PaddedForm[dz3, 12], "  ",
    PaddedForm[d114, 12], "  ",
    If[d2pi < 10^15, PaddedForm[d2pi, 12], ScientificForm[d2pi, 3]]],
{n, 3, 30}];
