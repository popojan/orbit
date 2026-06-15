(* Moment-growth probe: is the orbit/Chebyshev structure ALGORITHMICALLY
   load-bearing, or does it reduce to the classical O(sqrt x) criterion?

   Folded measure mu = sum_n w_n delta_{gamma_n} (symmetric in +-gamma).
   Chebyshev/cosine moments  m_k = int cos(k gamma) dmu = 2 sum_{gamma_n>0} cos(k gamma_n) w_n.
   Carathodory-Toeplitz: mu positive  <=>  Toeplitz [m_{|i-j|}] PSD.
   An off-line zero (ordinate gamma0 - i delta, FE+conj) contributes
   2 cos(k gamma0) cosh(k delta) w0  -- the hyperbolic orbit growth cosh(k delta).
   Question: at which moment order K does the Toeplitz turn indefinite, vs delta?

   PREDICTION (Hypothesis-First): K_detect ~ C/delta  (need k*delta ~ O(1) for
   cosh to dominate) -> expensive, = re-description of the classical growth
   criterion -> orbit structure NOT algorithmically load-bearing.
   FALSIFIED if K_detect stays bounded as delta->0 (cheap first-order detection). *)

prec = 30;
T0   = 100;
sw   = 8;                                   (* window width in gamma *)

idx    = Range[12, 60];
gpos   = N[Im[ZetaZero[idx]], prec];
gpos   = Select[gpos, T0 - 28 < # < T0 + 28 &];
wts    = Exp[-(gpos - T0)^2/(2 sw^2)];
Print["window: ", Length[gpos], " zeta zeros, gamma in ",
   N[{Min[gpos], Max[gpos]}, 6]];
{g0, w0} = First[SortBy[Transpose[{gpos, wts}], Abs[#[[1]] - T0] &]];
Print["off-line slot at gamma0 = ", N[g0, 8], "\n"];

(* moment m_k with one on-line pair at g0 pushed off the line by delta *)
mk[k_, delta_] := 2 Sum[Cos[k gpos[[n]]] wts[[n]], {n, Length[gpos]}]
   + 2 Cos[k g0] w0 (Cosh[k delta] - 1);

(* relative indefiniteness: min eig < -tol * max|eig| (cleanly above rank noise) *)
relMinEig[kk_, delta_] := Module[{m, M, ev},
  m = Table[mk[k, delta], {k, 0, kk - 1}];
  M = Table[m[[Abs[i - j] + 1]], {i, kk}, {j, kk}];
  ev = Re[Eigenvalues[N[M, prec]]];
  Min[ev]/Max[Abs[ev]]];

Kmax = 140;
tol  = 10^-6;
Kdetect[delta_] := Module[{kk = 2},
  While[kk <= Kmax && relMinEig[kk, delta] >= -tol, kk++];
  If[kk > Kmax, Infinity, kk]];

Print["sanity: baseline (delta=0) relative min-eig at K=Kmax = ",
   ScientificForm[N[relMinEig[Kmax, 0], 5]], "  (should be > -", tol, ", PSD)"];

Print["\n delta | K_detect | K_detect*delta  (flat => K~C/delta => expensive)"];
deltas = {1/40, 1/20, 151/1000, 1/5, 247/1000, 308/1000, 2/5, 1/2};
Do[Module[{kd = Kdetect[delta]},
   Print["  ", PaddedForm[N[delta, 4], {5, 3}], " | ",
     PaddedForm[kd, 6], "   | ",
     If[kd === Infinity, "--", ToString[N[kd delta, 4]]],
     Which[delta == 151/1000, "   <- real DH zero T=114",
           delta == 308/1000, "   <- real DH zero T=85.7", True, ""]]],
  {delta, deltas}];

Print["\nVERDICT: K_detect*delta ~ const  =>  K_detect ~ C/delta  =>  expensive",
   " (k*delta ~ O(1) needed) => reduces to classical growth => orbit NOT",
   " algorithmically load-bearing. Bounded K_detect as delta->0 would falsify."];
Print["DONE."];
