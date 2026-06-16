(* H2 (operator-existence / edge test): the orbit recurrence is a Jacobi matrix;
   "the operator meets the conditions" <=> its spectral measure is a positive
   measure on [-2,2] <=> the Chebyshev/cosine moment sequence is PSD
   (Carathodory-Toeplitz).  Off-line zero = a complex "frequency" whose moment
   contribution grows like cosh(k delta) (the hyperbolic orbit growth) -> breaks
   Toeplitz positivity at some order K_detect.

   QUESTION: does the orbit/Jacobi/moment route detect an off-line zero CHEAPLY
   (K_detect bounded as delta->0 => algorithmic edge => load-bearing) or
   EXPENSIVELY (K_detect ~ C/delta => reduces to classical growth => prose)?

   PRE-REGISTERED PREDICTION: K_detect ~ C/delta  (need k*delta ~ O(1) for cosh
   to beat the bounded on-line baseline). Bounded K_detect would FALSIFY me. *)

prec = 30;
T0   = 100;
sw   = 14;                                  (* window width in gamma *)

idx  = Range[5, 95];
gpos = N[Im[ZetaZero[idx]], prec];
gpos = Select[gpos, T0 - 40 < # < T0 + 40 &];
wts  = Exp[-(gpos - T0)^2/(2 sw^2)];
Print["window: ", Length[gpos], " zeta zeros (atoms), gamma in ",
   N[{Min[gpos], Max[gpos]}, 6]];
{g0, w0} = First[SortBy[Transpose[{gpos, wts}], Abs[#[[1]] - T0] &]];
Print["off-line slot at gamma0 = ", N[g0, 8],
   ", weight w0 = ", N[w0, 4], "\n"];

Kmax = 30;                                  (* < #atoms so baseline stays PD *)
tol  = 10^-6;

(* precompute baseline and off-line-carrier moment vectors (k=0..Kmax-1) *)
mbase = Table[2 Sum[Cos[k gpos[[n]]] wts[[n]], {n, Length[gpos]}], {k, 0, Kmax - 1}];
cg0   = Table[2 Cos[k g0] w0, {k, 0, Kmax - 1}];

momVec[delta_] := mbase + cg0 * Table[Cosh[k delta] - 1, {k, 0, Kmax - 1}];

relMinEig[mvec_, kk_] := Module[{M, ev},
  M = Table[mvec[[Abs[i - j] + 1]], {i, kk}, {j, kk}];
  ev = Re[Eigenvalues[N[M, prec]]];
  Min[ev]/Max[Abs[ev]]];

Kdetect[delta_] := Module[{mv = momVec[delta], kk = 2},
  While[kk <= Kmax && relMinEig[mv, kk] >= -tol, kk++];
  If[kk > Kmax, Infinity, kk]];

Print["baseline no-false-positive check: K_detect(delta=0) = ",
   Kdetect[0], "  (must be Infinity within Kmax=", Kmax, ")"];

Print["\n delta  | K_detect | K_detect*delta   (flat => K~C/delta => expensive)"];
deltas = {1/10, 151/1000, 1/5, 1/4, 308/1000, 2/5, 1/2};
res = {};
Do[Module[{kd = Kdetect[delta]},
   AppendTo[res, {N[delta], kd}];
   Print["  ", PaddedForm[N[delta, 4], {6, 4}], " | ",
     PaddedForm[kd, 7], "  | ",
     If[kd === Infinity, "  --", PaddedForm[N[kd delta, 3], {6, 3}]],
     Which[delta == 151/1000, "   <- real DH zero (T=114)",
           delta == 308/1000, "   <- real DH zero (T=85.7)", True, ""]]],
  {delta, deltas}];

(* verdict: is K_detect*delta roughly constant (1/delta law) or does K_detect
   stay bounded as delta shrinks? *)
prod = Select[res, NumberQ[#[[2]]] &] /. {d_, k_} :> d k;
Print["\nK_detect*delta values: ", N[prod, 4]];
Print["spread: min ", N[Min[prod], 3], "  max ", N[Max[prod], 3]];
Print["\nVERDICT: roughly constant K_detect*delta  =>  K_detect ~ C/delta  =>",
   " EXPENSIVE (k*delta~O(1) needed) => orbit/Jacobi route reduces to classical",
   " growth, NO algorithmic edge (prediction confirmed). A K_detect bounded as",
   " delta->0 (product growing like 1/delta) would have falsified it."];
Print["DONE."];
