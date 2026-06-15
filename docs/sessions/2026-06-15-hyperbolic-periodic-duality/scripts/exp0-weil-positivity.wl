(* Experiment 0: Weil-positivity signature as an RH detector.
   Tests the lens claim: orbit-Cassini positivity = Weil positivity, i.e.
   the explicit-formula quadratic form (built from the GEOMETRIC side:
   primes + archimedean + pole, NO reference to zero locations) is
   positive semidefinite for genuine zeta, and goes INDEFINITE when the
   spectrum contains an FE-symmetric off-line quartet of zeros.

   Test functions: modulated Gaussians  f_j(u) = exp(-u^2/(2w^2)) exp(I nu_j u)
   so  fhat_j(r) = w Sqrt[2Pi] exp(-w^2 (r-nu_j)^2/2).
   h_{jk}(r) = fhat_j(r) fhat_k(r) = 2Pi w^2 exp(-w^2 dnu^2/4) exp(-w^2 (r-c)^2),
   with dnu = nu_j-nu_k, c = (nu_j+nu_k)/2.   (real, symmetric in j,k)

   Riemann-Weil explicit formula (validated numerically below):
     Sum_rho h(gamma_rho) = [pole] + [arch] - [prime]
   pole = h(I/2)+h(-I/2)
   arch = (1/2Pi) Int h(r) [Re psi(1/4 + I r/2) - Log Pi] dr
   prime = Sum_n Lambda(n) n^{-1/2} ( g(log n) + g(-log n) ),  g = invFT(h).
*)

prec = 30;
w    = 1/2;
nus  = {10, 14, 18, 22, 26, 30, 34};   (* basis centers *)
m    = Length[nus];

(* ---- building blocks for a given pair (nuj,nuk) ---- *)
Bamp[nuj_, nuk_] := 2 Pi w^2 Exp[-w^2 (nuj - nuk)^2/4];
cmid[nuj_, nuk_] := (nuj + nuk)/2;

(* h_{jk}(r) as analytic function of (possibly complex) r *)
hval[nuj_, nuk_, r_] := Bamp[nuj, nuk] Exp[-w^2 (r - cmid[nuj, nuk])^2];

(* pole term *)
poleTerm[nuj_, nuk_] := hval[nuj, nuk, I/2] + hval[nuj, nuk, -I/2];

(* archimedean term, numeric integral; h localized at c, width ~1/(w Sqrt2) *)
archTerm[nuj_, nuk_] := Module[{c = cmid[nuj, nuk], B = Bamp[nuj, nuk]},
  (1/(2 Pi)) NIntegrate[
     B Exp[-w^2 (r - c)^2] (Re[PolyGamma[0, 1/4 + I r/2]] - Log[Pi]),
     {r, c - 25, c + 25}, WorkingPrecision -> prec, AccuracyGoal -> 20]];

(* prime term: g(log n)+g(-log n) = 2 w Sqrt[Pi] exp(-dnu^2 w^2/4) *)
(*            * cos(c log n) exp(-(log n)^2/(4 w^2))                 *)
gSym[nuj_, nuk_, u_] := 2 w Sqrt[Pi] Exp[-w^2 (nuj - nuk)^2/4] *
   Cos[cmid[nuj, nuk] u] Exp[-u^2/(4 w^2)];
primeTerm[nuj_, nuk_, nMax_] := Sum[
   With[{L = MangoldtLambda[n]},
     If[L == 0, 0, L n^(-1/2) gSym[nuj, nuk, Log[n]]]],
   {n, 2, nMax}];

geomEntry[nuj_, nuk_, nMax_] :=
  poleTerm[nuj, nuk] + archTerm[nuj, nuk] - primeTerm[nuj, nuk, nMax];

(* ---- zero side (validation + clean PSD baseline) ---- *)
nZeros = 80;
gammas = N[Im[ZetaZero[Range[nZeros]]], prec];
zeroEntry[nuj_, nuk_] := Sum[
   hval[nuj, nuk, gammas[[k]]] + hval[nuj, nuk, -gammas[[k]]], {k, nZeros}];

(* =================== VALIDATION =================== *)
Print["=== VALIDATION: geometric side vs zero side (a few entries) ==="];
nMax = 2000;
Do[
  With[{nuj = nus[[j]], nuk = nus[[k]]},
   Module[{g = geomEntry[nuj, nuk, nMax], z = zeroEntry[nuj, nuk]},
    Print["  (", j, ",", k, ")  geom=", ScientificForm[N[g, 12]],
      "  zero=", ScientificForm[N[z, 12]],
      "  reldiff=", ScientificForm[N[Abs[(g - z)/z], 6]]]]],
  {j, {1, 3, 5}}, {k, {1, 3, 5}}];

(* =================== ZETA MATRIX (both sides) =================== *)
Print["\n=== ZETA Weil form ==="];
Mgeom = Table[geomEntry[nus[[j]], nus[[k]], nMax], {j, m}, {k, m}];
Mgeom = (Mgeom + Transpose[Mgeom])/2;        (* symmetrize tiny numeric asym *)
Mzero = Table[zeroEntry[nus[[j]], nus[[k]]], {j, m}, {k, m}];
Mzero = (Mzero + Transpose[Mzero])/2;
egeom = Sort[Eigenvalues[N[Mgeom, prec]]];
ezero = Sort[Eigenvalues[N[Mzero, prec]]];
Print["  eig(M_geom) min..max : ", ScientificForm[N[{Min[egeom], Max[egeom]}, 6]]];
Print["  eig(M_zero) min..max : ", ScientificForm[N[{Min[ezero], Max[ezero]}, 6]]];
Print["  M_zero is a Gram matrix => PSD by construction; min eig = ",
   ScientificForm[N[Min[ezero], 6]]];

(* =================== OFF-LINE QUARTET CONTROL =================== *)
(* add FE+conj symmetric quartet of zeros at rho0 = sig0 + I g0 :
   ordinates  +-g0 +- I (sig0-1/2).  Contribution = Sum_q h_{jk}(r_q). *)
quartetEntry[nuj_, nuk_, g0_, sig0_] := Module[{d = sig0 - 1/2},
  hval[nuj, nuk, g0 + I d] + hval[nuj, nuk, g0 - I d] +
  hval[nuj, nuk, -g0 + I d] + hval[nuj, nuk, -g0 - I d]];

Mctrl[g0_, sig0_] := Module[{Q},
  Q = Table[quartetEntry[nus[[j]], nus[[k]], g0, sig0], {j, m}, {k, m}];
  Q = Re[(Q + Transpose[Q])/2];
  Mzero + Q];

Print["\n=== CONTROL: zeta zeros + one off-line quartet at gamma0=22 ==="];
Print["  sig0 : min eigenvalue of Weil form   (sig0=1/2 is ON the line)"];
Do[
  With[{me = Min[Eigenvalues[N[Mctrl[22, sig0], prec]]]},
   Print["   sig0=", N[sig0, 3], "  (delta=", N[sig0 - 1/2, 3], ")  minEig=",
     ScientificForm[N[me, 6]],
     If[me < 0, "   <-- INDEFINITE (off-line detected)", "   (PSD)"]]],
  {sig0, {0.50, 0.55, 0.60, 0.65, 0.70, 0.75, 0.80, 0.90}}];

Print["\n=== CONTROL across gamma0 (sig0=0.75 fixed) ==="];
Do[
  With[{me = Min[Eigenvalues[N[Mctrl[g0, 0.75], prec]]]},
   Print["   gamma0=", N[g0, 3], "  minEig=", ScientificForm[N[me, 6]],
     If[me < 0, "   INDEFINITE", " PSD"]]],
  {g0, {12, 16, 20, 24, 28, 32}}];

Print["\nDONE."];
