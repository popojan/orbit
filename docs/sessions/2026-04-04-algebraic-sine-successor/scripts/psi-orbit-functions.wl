(* ================================================================ *)
(* PsiOrbit functions — ψ(x) via successor orbits                  *)
(* All formulas from the session 2026-04-04/05                     *)
(* ================================================================ *)

<< Orbit`

(* === ψ(x) at x = e^{k/N} via orbit identity === *)
(* Exact for integer k, any N *)
PsiOrbitN[k_Integer, NN_Integer, nZeros_Integer: 30] := Module[
  {rho, g, sig, cN, rhoSq, t = k/NN},
  Exp[t] - Sum[
    rho = N[ZetaZero[n], 15];
    sig = Re[rho]; g = Im[rho];
    cN = Cos[g/NN];
    rhoSq = sig^2 + g^2;
    2 Exp[t sig]/rhoSq *
      (sig SuccessorOrbit[1, k, 2 cN] +
       (g Sin[g/NN] - cN sig) SuccessorOrbit[1, k - 1, 2 cN]),
    {n, 1, nZeros}
  ] - Log[2 Pi]
]

(* === ψ(x) for any real x — phantom N cancels === *)
PsiOrbitReal[x_?NumericQ, nZeros_Integer: 30, NN_Integer: 100] := Module[
  {rho, g, sig, cN, sN, rhoSq, k},
  k = NN Log[N[x, 15]];
  Exp[k/NN] - Sum[
    rho = N[ZetaZero[n], 15];
    sig = Re[rho]; g = Im[rho];
    cN = Cos[g/NN]; sN = Sin[g/NN];
    rhoSq = sig^2 + g^2;
    2 Exp[k sig/NN]/rhoSq *
      (sig (cN sN SuccessorOrbit[1, k - 1, 2 cN] +
            sN^2 SuccessorOrbit[1, k, 2 cN]) +
       g sN SuccessorOrbit[1, k - 1, 2 cN]),
    {n, 1, nZeros}
  ] - Log[2 Pi]
]

(* === Convenient: (k, N) for given integer x === *)
OrbitKN[x_Integer, eps_: 0.3] := Module[{NN, k},
  NN = Ceiling[x / (2 eps)];
  k = Round[NN Log[N[x, 20]]];
  {k, NN}
]

(* === ψ'(x) — the unweighted cosine sum === *)
PsiDeriv[x_?NumericQ, nZeros_Integer: 30] :=
  1 - 2/Sqrt[N[x, 15]] Sum[
    Cos[N[Im[ZetaZero[n]], 15] Log[N[x, 15]]],
  {n, 1, nZeros}]

(* === Dual: S(T) via prime-parametrized orbits === *)
SDualOrbit[T_?NumericQ, nPrimes_Integer: 50, NN_Integer: 100] := Module[
  {ps = Prime /@ Range[nPrimes], k, cP, sP},
  k = Round[NN N[T]];
  -1./Pi Total[Table[
    cP = Cos[Log[N[p, 15]] / NN];
    sP = Sin[Log[N[p, 15]] / NN];
    sP SuccessorOrbit[1, k - 1, 2 cP] / Sqrt[N[p]],
  {p, ps}]]
]

(* === S(T) collapsed (Euler product form) === *)
SCollapsed[T_?NumericQ, nPrimes_Integer: 50] := Module[
  {ps = Prime /@ Range[nPrimes], s = 1/2 + I N[T]},
  -1./Pi Total[Table[Im[Log[1 - N[p]^(-s)]], {p, ps}]]
]

(* === Exact comparisons === *)
psiExact[x_Integer] := N[Total[MangoldtLambda /@ Range[x]]]

theta[T_] := N[Im[LogGamma[1/4 + I T/2]] - T Log[Pi]/2]
NZeroExact[T_] := Module[{c = 0, n = 1},
  While[N[Im[ZetaZero[n]]] <= T, c++; n++]; c]
SExact[T_] := NZeroExact[T] - theta[T]/Pi - 1 // N

(* === Usage examples === *)
(*
{k, NN} = OrbitKN[100];
PsiOrbitN[k, NN, 50]          (* ψ(100) via orbits *)

PsiDeriv[7, 30]               (* ψ'(7) — should be large (prime!) *)

SDualOrbit[14.13, 50]         (* S(γ₁) via dual orbits *)
SCollapsed[50., 100]          (* S(50) via Euler product *)
*)
