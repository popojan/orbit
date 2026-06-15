(* Emergent gate: Weil form for DH from the ARITHMETIC side (Lambda_f from
   -f'/f, plus archimedean), validated at low t against enumerated on-line
   zeros, then applied at t~114 (the off-line FE pair) to read the signature.
   No high-t zeros are consulted in the arithmetic side. *)

prec = 30;
w    = 1/2;
kappa = N[(Sqrt[10 - 2 Sqrt[5]] - 2)/(Sqrt[5] - 1), 40];

cc[n_] := {1, kappa, -kappa, -1, 0}[[Mod[n - 1, 5] + 1]];
fDH[s_] := 5^(-s) (HurwitzZeta[s, 1/5] + kappa HurwitzZeta[s, 2/5]
                    - kappa HurwitzZeta[s, 3/5] - HurwitzZeta[s, 4/5]);

(* ---- Lambda_f via  c(n) log n = sum_{d|n} Lambda_f(d) c(n/d) ---- *)
Nmax = 3000;
lamf = ConstantArray[0, Nmax];
Do[
  lamf[[n]] = cc[n] Log[n] -
     Sum[lamf[[d]] cc[n/d], {d, Most[Divisors[n]]}],   (* d<n *)
  {n, 2, Nmax}];
Print["Lambda_f head (n=2..8): ", N[Take[lamf, {2, 8}], 6]];

(* ---- test-function pieces (same modulated Gaussians as Exp 0) ---- *)
Bamp[a_, b_] := 2 Pi w^2 Exp[-w^2 (a - b)^2/4];
cmid[a_, b_] := (a + b)/2;
hval[a_, b_, r_] := Bamp[a, b] Exp[-w^2 (r - cmid[a, b])^2];

(* arithmetic side: arch - prime  (no pole; DH coeffs are mean-zero) *)
Acon = Log[5/Pi];                          (* conductor-5, to be validated *)
archDH[a_, b_] := Module[{c = cmid[a, b], B = Bamp[a, b]},
  (1/(2 Pi)) NIntegrate[
    B Exp[-w^2 (r - c)^2] (Re[PolyGamma[0, 3/4 + I r/2]] + Acon),
    {r, c - 25, c + 25}, WorkingPrecision -> prec, AccuracyGoal -> 18]];
primeDH[a_, b_, nm_] := Sum[
   With[{L = lamf[[n]]},
     If[L == 0, 0,
      L n^(-1/2) * 2 w Sqrt[Pi] Exp[-w^2 (a - b)^2/4] *
        Cos[cmid[a, b] Log[n]] Exp[-Log[n]^2/(4 w^2)]]],
   {n, 2, nm}];
geomDH[a_, b_, nm_] := archDH[a, b] - primeDH[a, b, nm];

(* ---- enumerate on-line DH zeros for validation (Phi real on the line) ---- *)
Phir[t_] := Re[(5/Pi)^((1/2 + I t + 1)/2) Gamma[(1/2 + I t + 1)/2] fDH[1/2 + I t]];
(* scan sign changes of Phir in t in [3,30] *)
ts = Range[3, 30, 0.05];
sgnpts = Transpose[{Most[ts], Sign[Phir /@ Most[ts]], Sign[Phir /@ Rest[ts]]}];
brackets = Select[Transpose[{Most[ts], Rest[ts]}],
   Phir[#[[1]]] Phir[#[[2]]] < 0 &];
onlineZeros = (t /. FindRoot[Phir[t] == 0, {t, Mean[#]},
      WorkingPrecision -> prec]) & /@ brackets;
onlineZeros = Sort[DeleteDuplicates[onlineZeros, Abs[#1 - #2] < 0.01 &]];
Print["on-line DH zeros in [3,30] (", Length[onlineZeros], "): ",
   N[onlineZeros, 7]];

zeroSideLow[a_, b_] := Sum[
   hval[a, b, g] + hval[a, b, -g], {g, onlineZeros}];

(* ---- VALIDATION at low-t basis ---- *)
Print["\n=== VALIDATION (low-t, arithmetic side vs on-line zero side) ==="];
nuLow = {12, 14, 16, 18};
nmV = 3000;
Do[With[{a = nuLow[[j]], b = nuLow[[k]]},
   Module[{g = geomDH[a, b, nmV], z = zeroSideLow[a, b]},
    Print["  (", a, ",", b, ")  geom=", ScientificForm[N[g, 10]],
      "  zero=", ScientificForm[N[z, 10]],
      "  reldiff=", ScientificForm[N[Abs[(g - z)/z], 5]]]]],
  {j, {1, 2}}, {k, {1, 2}}];

(* ---- SIGNATURE at the off-line region t~114 (arithmetic side only) ---- *)
Print["\n=== DH Weil form near t=114.16 (off-line FE pair), ARITHMETIC side ==="];
nuHi = {112.5, 113.3, 114.163, 115.0, 115.8};
mH = Length[nuHi];
MdhGeom = Table[geomDH[nuHi[[j]], nuHi[[k]], 3000], {j, mH}, {k, mH}];
MdhGeom = (MdhGeom + Transpose[MdhGeom])/2;
ev = Sort[Eigenvalues[N[MdhGeom, prec]]];
Print["  eigenvalues: ", ScientificForm[N[ev, 6]]];
Print["  min eigenvalue = ", ScientificForm[N[Min[ev], 6]],
   If[Min[ev] < 0, "   <-- INDEFINITE (DH off-line zeros detected from arithmetic)",
      "   PSD (unexpected)"]];

(* control: same basis but a region with only on-line zeros (t~50) should be PSD *)
Print["\n=== control: t~50 (on-line only) should stay PSD ==="];
nuC = {48, 49, 50, 51, 52};
MdhC = Table[geomDH[nuC[[j]], nuC[[k]], 3000], {j, 5}, {k, 5}];
MdhC = (MdhC + Transpose[MdhC])/2;
evC = Sort[Eigenvalues[N[MdhC, prec]]];
Print["  min eigenvalue = ", ScientificForm[N[Min[evC], 6]],
   If[Min[evC] < 0, "   INDEFINITE", "   PSD"]];

Print["\nDONE."];
