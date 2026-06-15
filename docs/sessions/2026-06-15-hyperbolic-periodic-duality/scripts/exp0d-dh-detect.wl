(* Detection attempt: can a finer, tightly-localized basis (suppressing the
   dense on-line neighbours) flip the DH Weil form indefinite at the off-line
   FE pair t=114.163 (delta=0.1508)?  Control at t=50 (on-line only) must stay
   PSD to attribute any negativity to the off-line zero. Arithmetic side only. *)

$MaxExtraPrecision = 2000;
prec = 45;
w    = 11/5;                              (* 2.2 : std in r ~ 0.45 *)
kappa = N[(Sqrt[10 - 2 Sqrt[5]] - 2)/(Sqrt[5] - 1), 60];

cc[n_] := {1, kappa, -kappa, -1, 0}[[Mod[n - 1, 5] + 1]];

Nmax = 15000;
Print["building Lambda_f to ", Nmax, " ..."];
lamf = ConstantArray[0, Nmax];
Do[lamf[[n]] = N[cc[n] Log[n] - Sum[lamf[[d]] cc[n/d], {d, Most[Divisors[n]]}], prec],
   {n, 2, Nmax}];
Print["  done. |Lambda_f| max over n<=Nmax = ", N[Max[Abs[lamf]], 6]];

Bamp[a_, b_] := 2 Pi w^2 Exp[-w^2 (a - b)^2/4];
cmid[a_, b_] := (a + b)/2;
Acon = Log[5/Pi];
archDH[a_, b_] := Module[{c = cmid[a, b], B = Bamp[a, b]},
  (1/(2 Pi)) NIntegrate[
    B Exp[-w^2 (r - c)^2] (Re[PolyGamma[0, 3/4 + I r/2]] + Acon),
    {r, c - 22, c + 22}, WorkingPrecision -> prec, AccuracyGoal -> 22]];
primeDH[a_, b_] := Sum[
   With[{L = lamf[[n]]},
     If[L == 0, 0,
      L n^(-1/2) 2 w Sqrt[Pi] Exp[-w^2 (a - b)^2/4] *
        Cos[cmid[a, b] Log[n]] Exp[-Log[n]^2/(4 w^2)]]],
   {n, 2, Nmax}];
geomDH[a_, b_] := archDH[a, b] - primeDH[a, b];

(* tight basis: spread 0.4 (< on-line spacing ~0.85), centered at the zero *)
base = 114163/1000;
offs = {-1/5, -1/10, 0, 1/10, 1/5};
formMin[ctr_] := Module[{nu = ctr + offs, mm, M},
  mm = Length[nu];
  M = Table[geomDH[nu[[j]], nu[[k]]], {j, mm}, {k, mm}];
  M = (M + Transpose[M])/2;
  Sort[Eigenvalues[N[M, prec]]]];

Print["\n=== DH off-line region t=114.163 (delta=0.1508), tight basis ==="];
ev114 = formMin[base];
Print["  eigenvalues: ", ScientificForm[N[ev114, 6]]];
Print["  min eig = ", ScientificForm[N[Min[ev114], 6]],
   If[Min[ev114] < 0, "   <-- INDEFINITE (off-line zero detected from arithmetic!)",
      "   PSD (still below resolution threshold)"]];

Print["\n=== control t=50 (on-line only), identical tight basis ==="];
ev50 = formMin[50];
Print["  min eig = ", ScientificForm[N[Min[ev50], 6]],
   If[Min[ev50] < 0, "   INDEFINITE (would undermine attribution)", "   PSD (good control)"]];

Print["\n=== control t=85.699 (the other off-line zero, sigma=0.8085, delta=0.3085) ==="];
ev85 = formMin[856993/10000];
Print["  min eig = ", ScientificForm[N[Min[ev85], 6]],
   If[Min[ev85] < 0, "   <-- INDEFINITE (larger delta, easier to detect)", "   PSD"]];

Print["\nDONE."];
