(* 09 -- Jan: "with only 10 primes I get almost exact zeta at low heights -- does the
   truncation error amplify as t rises?"
   HYPOTHESES (stated before running):
   H1: NO t-amplification at fixed sigma > 1. The error is the tail -Sum_{p>p_m} Log(1-p^{-s});
       worst case Sum_{p>p_m} p^{-sigma} (t-independent bound; phases rotate, never grow),
       typical size the RMS sqrt(Sum_{p>p_m} p^{-2 sigma}) (near-orthogonal phases).
       At sigma=2, m=10 (p>29): bound ~1e-2, RMS ~2e-3 -- flat from t=10 to t=10^6.
   H2: the error amplifies as sigma DECREASES at fixed m: tail Sum p^{-sigma} grows,
       diverges at sigma=1. Check sigma = 2, 1.5, 1.2, 1.05 at two heights.
   H3: the catch at the critical line: a finite partial Euler product NEVER vanishes
       (finite product of nonzero factors), so at sigma=1/2 it cannot reproduce zeta's
       zeros at ANY truncation -- |partial| stays O(1) at t = gamma_k while |zeta| = 0.
       The zeros are an m -> infinity collective effect (same emergence theme as SS5-6). *)

logZeta[sig_, t_, m_] := -Sum[Log[1 - Prime[k]^(-sig - I t)], {k, 1, m}];

Print["=== H1: error vs t at sigma=2, m=10 (p <= 29) ==="];
tailBound = Total[Select[Range[30, 100000], PrimeQ]^-2.];
tailRMS = Sqrt[Total[Select[Range[30, 100000], PrimeQ]^-4.]];
Print["a-priori: worst-case bound ", N[tailBound, 3], ",  RMS ", N[tailRMS, 3]];
Do[
  err = Abs[logZeta[2, tt, 10] - Log[Zeta[2 + I tt]]];
  Print["t=10^", Log10[tt], "  |err|=", N[err, 3]],
  {tt, {10., 100., 1000., 10.^4, 10.^5, 10.^6}}
];

Print["\n=== H2: error vs sigma at m=10, two heights ==="];
Do[
  Print["sigma=", sig, "  |err|(t=13.7)=",
    N[Abs[logZeta[sig, 13.7, 10] - Log[Zeta[sig + 13.7 I]]], 3],
    "  |err|(t=10^4)=",
    N[Abs[logZeta[sig, 10.^4, 10] - Log[Zeta[sig + 10.^4 I]]], 3]],
  {sig, {2, 1.5, 1.2, 1.05}}
];

Print["\n=== H3: at sigma=1/2 the partial product cannot see the zeros ==="];
partialAbs[t_, m_] := Abs[Exp[logZeta[1/2, t, m]]];
Do[
  gam = N[Im[ZetaZero[k]], 20];
  Print["zero #", k, " (gamma=", N[gam, 6], "):  |partial product| m=10: ",
    N[partialAbs[gam, 10], 3], ",  m=100: ", N[partialAbs[gam, 100], 3],
    ",  |zeta(1/2+I gamma)| = 0"],
  {k, {1, 10, 50}}
];
Print["finite products of nonzero factors never vanish -- zeros need m -> infinity."];
