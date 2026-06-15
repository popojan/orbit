(* Refined off-line sweep in EXACT/high precision (no machine-real underflow).
   Reuses the validated Weil harness; quartet planted at a high-sensitivity
   center (gamma0 = 14, a basis node) so the signal sits far above any floor.
   minEig as a function of sigma0 = 1/2 + delta : the "divide" is delta=0. *)

prec = 40;
w    = 1/2;
nus  = {10, 14, 18, 22, 26, 30, 34};
m    = Length[nus];

Bamp[nuj_, nuk_] := 2 Pi w^2 Exp[-w^2 (nuj - nuk)^2/4];
cmid[nuj_, nuk_] := (nuj + nuk)/2;
hval[nuj_, nuk_, r_] := Bamp[nuj, nuk] Exp[-w^2 (r - cmid[nuj, nuk])^2];

nZeros = 80;
gammas = N[Im[ZetaZero[Range[nZeros]]], prec];
zeroEntry[nuj_, nuk_] := Sum[
   hval[nuj, nuk, gammas[[k]]] + hval[nuj, nuk, -gammas[[k]]], {k, nZeros}];
Mzero = Table[zeroEntry[nus[[j]], nus[[k]]], {j, m}, {k, m}];
Mzero = (Mzero + Transpose[Mzero])/2;

quartetEntry[nuj_, nuk_, g0_, sig0_] := Module[{d = sig0 - 1/2},
  hval[nuj, nuk, g0 + I d] + hval[nuj, nuk, g0 - I d] +
  hval[nuj, nuk, -g0 + I d] + hval[nuj, nuk, -g0 - I d]];
MctrlExact[g0_, sig0_] := Module[{Q},
  Q = Table[quartetEntry[nus[[j]], nus[[k]], g0, sig0], {j, m}, {k, m}];
  Q = Re[(Q + Transpose[Q])/2];
  Mzero + Q];

g0 = 14;
Print["=== off-line sweep, gamma0=", g0, ", EXACT precision ", prec, " ==="];
Print[" delta=sigma0-1/2 :  minEig(Weil form)   [delta=0 is ON the line]"];
Do[
  With[{sig0 = 1/2 + del},
   Module[{me = Min[Eigenvalues[N[MctrlExact[g0, sig0], prec]]]},
    Print["   delta=", PaddedForm[N[del, 4], {5, 3}], "   minEig = ",
      ScientificForm[N[me, 8]],
      If[me < 0, "   INDEFINITE", "   PSD"]]]],
  {del, {0, 1/100, 1/40, 1/20, 1/10, 3/20, 1/5, 1/4, 3/10, 2/5}}];

(* small-delta scaling: is the leading drop ~ delta^2 (sinh^2 prediction)? *)
Print["\n=== small-delta scaling check (minEig at delta vs delta^2) ==="];
e0 = Min[Eigenvalues[N[MctrlExact[g0, 1/2], prec]]];
Do[
  With[{sig0 = 1/2 + del},
   Module[{me = Min[Eigenvalues[N[MctrlExact[g0, sig0], prec]]]},
    Print["   delta=", ScientificForm[N[del, 4]],
      "   (minEig-minEig0)/delta^2 = ",
      ScientificForm[N[(me - e0)/del^2, 6]]]]],
  {del, {1/200, 1/100, 1/50, 1/25}}];

Print["\nDONE."];
