(* Analytic Structure of G(s,xi) = Li_s(w) - w *)
(* What falls out when we decompose through L-functions? *)

G[s_, xi_] := PolyLog[s, Exp[2 Pi I xi]] - Exp[2 Pi I xi];
iDS[s_, xi_] := G[s, xi] * G[s, -xi]; (* = |G|^2 for real s *)

Print["=== Analytic Structure of the Intersection Series ===\n"];

(* ============================================================ *)
Print["--- 1. G(s, xi) at special xi values ---\n"];

eta[s_] := (1 - 2^(1 - s)) Zeta[s];

Print["xi=0:   G = zeta(s) - 1"];
Print["xi=1/2: G = 1 - eta(s) = 1 - (1-2^{1-s})zeta(s)"];
Print["xi=1/3: G decomposes into zeta + L(s, chi_3)"];
Print["xi=1/4: G decomposes into Dirichlet beta function"];

(* Verify xi=1/2 *)
Print["\nVerify G(s,1/2) = 1-eta(s):"];
Do[
  diff = Abs[N[G[s, 1/2] - (1 - eta[s]), 15]];
  Print["  s=", s, ": err=", ScientificForm[diff, 2]],
  {s, {2, 3, 5, 1/2 + 14.13 I}}  (* last one: near first zeta zero *)
];

(* ============================================================ *)
Print["\n--- 2. L-function decomposition at q=3 ---\n"];
Print["G(s,1/3) = (1/2)[-(1-3^{-s})zeta(s) + i Sqrt[3] L(s,chi_3)] - w_3"];
Print["where chi_3 = Legendre symbol (./3)\n"];

w3 = Exp[2 Pi I/3];
decomp3[s_] := (-(1 - 3^(-s)) Zeta[s] + I Sqrt[3] DirichletL[3, 2, s])/2 - w3;

Do[
  err = Abs[N[G[s, 1/3] - decomp3[s], 15]];
  Print["  s=", s, ": err=", ScientificForm[err, 2]],
  {s, {2, 3, 4, 1/2 + 5 I}}
];

(* ============================================================ *)
Print["\n--- 3. L-function decomposition at q=4 ---\n"];
Print["Li_s(i) = i * beta(s)  where beta = Dirichlet beta function"];
Print["beta(s) = L(s, chi_4) = 1 - 1/3^s + 1/5^s - 1/7^s + ..."];
Print["So G(s,1/4) = i*beta(s) - i\n"];

beta[s_] := DirichletL[4, 2, s]; (* Dirichlet beta = L(s, chi_{-4}) *)

Do[
  gVal = N[G[s, 1/4], 12];
  betaVal = N[I beta[s] - I, 12];
  Print["  s=", s, ": G=", gVal, "  i(beta-1)=", betaVal,
    "  err=", ScientificForm[Abs[gVal - betaVal], 2]],
  {s, {2, 3, 4}}
];

Print["\nSpecial values of beta:"];
Print["  beta(1) = Pi/4  (Leibniz formula)"];
Print["  beta(2) = Catalan's constant G = ", N[beta[2], 12]];
Print["  beta(3) = Pi^3/32"];
Print["\nSo I(s,1/4) = |i(beta(s)-1)|^2 = (beta(s)-1)^2"];
Print["  I(2, 1/4) = (G - 1)^2 = ", N[(beta[2] - 1)^2, 10],
  "  where G = Catalan's constant"];

(* ============================================================ *)
Print["\n--- 4. Functional equation ---\n"];
Print["Jonquiere: Li_s(e^{2Pi I xi}) = "];
Print["  Gamma(1-s)/(2Pi)^{1-s} [i^{1-s} zeta(1-s,xi) + i^{s-1} zeta(1-s,1-xi)]"];

jonq[s_, xi_] := Gamma[1 - s]/(2 Pi)^(1 - s) *
  (I^(1 - s) HurwitzZeta[1 - s, xi] + I^(s - 1) HurwitzZeta[1 - s, 1 - xi]);

Print["\nVerification at complex s:"];
Do[
  lhs = N[PolyLog[s0, Exp[2 Pi I xi0]], 12];
  rhs = N[jonq[s0, xi0], 12];
  Print["  s=", s0, " xi=", xi0, ": err=", ScientificForm[Abs[lhs - rhs], 2]],
  {s0, {1/2 + 3 I, -1 + 2 I, 1/2 + 14.13 I}},
  {xi0, {1/3, 1/4}}
];

Print["\nConsequence: G(s,xi) has a functional equation relating s <-> 1-s"];
Print["This constrains zeros of I(s,xi) = |G|^2 (critical line structure)"];

(* ============================================================ *)
Print["\n--- 5. |G(s,xi)|^2 along real axis ---\n"];
Print["      s     xi=0         xi=1/4       xi=1/3       xi=1/2"];
Print["            (zeta-1)^2   (beta-1)^2   (L-mix)^2    (1-eta)^2"];
Print[StringJoin @ Table["-", 70]];
Do[
  vals = Table[Re[N[iDS[sigma, xi]]], {xi, {0, 1/4, 1/3, 1/2}}];
  Print["  ", NumberForm[N@sigma, {4, 1}], "   ",
    StringJoin[StringPadRight[ToString@NumberForm[#, {8, 6}], 14] & /@ vals]],
  {sigma, {1.1, 1.5, 2.0, 3.0, 5.0, 10.0, 50.0}}
];
Print["\nAs s->inf: I -> |w^2/4|^2 = 1/16 -> 0... wait"];
Print["G(s,xi) = w^2/2^s + w^3/3^s + ... -> w^2/2^s -> 0"];
Print["So I(s,xi) -> 0 for all xi as s->inf"];

(* ============================================================ *)
Print["\n--- 6. Zeros of G(s,xi) near Re(s)=1/2 ---\n"];
Print["G(s,0) = 0 iff zeta(s) = 1 ('one-points' of zeta)"];
Print["G(s,1/2) = 0 iff eta(s) = 1"];
Print["G(s,1/4) = 0 iff beta(s) = 1"];
Print["These are GEOMETRICALLY: s-values where the weighted"];
Print["intersection sum vanishes at height xi\n"];

(* Find: where is |G(s,xi)|^2 smallest near the critical line? *)
Print["Scanning |G(1/2+it, xi)|^2 for t in [0,30]:"];
Do[
  Print["\nxi = ", xi, ":"];
  mins = {};
  Do[
    s0 = 1/2 + t I;
    val = Re[N[iDS[s0, xi]]];
    If[val < 0.1,
      AppendTo[mins, {t, val}]],
    {t, 0.1, 30, 0.1}
  ];
  (* Find local minima *)
  If[Length[mins] > 0,
    Print["  Near-zeros (|G|^2 < 0.1):"];
    Do[Print["    t=", NumberForm[m[[1]], {5, 1}],
      "  |G|^2=", NumberForm[m[[2]], {6, 4}]],
      {m, mins}],
    Print["  No near-zeros found in [0,30]"]
  ],
  {xi, {0, 1/4, 1/3, 1/2}}
];

(* ============================================================ *)
Print["\n--- 7. Key identity: I encodes 'missing primes' ---\n"];
Print["zeta(s)^2 = Sum d(n)/n^s  (ALL divisor pairs)"];
Print["I(s,0)    = (zeta-1)^2 = Sum (d(n)-2)/n^s  (INTERIOR pairs only)"];
Print["\nSo: zeta(s)^2 = 1 + 2(zeta-1) + I(s,0)"];
Print["     = 1 + 2*G(s,0) + |G(s,0)|^2"];
Print["     = (1 + G(s,0))^2 = zeta(s)^2  (trivially)"];
Print["\nBut for xi != 0, the decomposition is NON-TRIVIAL:"];

(* The xi != 0 generalization of zeta^2 *)
Print["\nDefine Z(s,xi) = Sum_{n>=1} sigma_xi(n)/n^s"];
Print["  where sigma_xi(n) = Sum_{d|n} e^{2Pi I xi (d-n/d)}"];
Print["Then: Z(s,xi) = Li_s(w)^2  (NOT |Li_s(w)|^2 !)"];

(* Verify *)
sigmaXi[n_, xi_] := Total[Exp[2 Pi I xi (# - n/#)] & /@ Divisors[n]];

Print["\nVerify Z(s,xi) = Li_s(w)^2 at s=3, xi=1/4:"];
direct = N[Sum[sigmaXi[n, 1/4]/n^3, {n, 1, 500}], 10];
formula = N[PolyLog[3, Exp[2 Pi I/4]]^2, 10];
Print["  Direct (N=500): ", direct];
Print["  Li_3(i)^2:      ", formula];
Print["  Diff:            ", ScientificForm[Abs[direct - formula], 3]];

Print["\nDecomposition:"];
Print["Z(s,xi) = Li_s(w)^2 = (G + w)^2 = G^2 + 2wG + w^2"];
Print["  G^2     = sum over pairs with BOTH a,b >= 2"];
Print["  2wG     = sum over pairs with exactly ONE of a,b = 1"];
Print["  w^2     = the (1,1) pair (= 0 for n>1, = w^2 at n=1)"];
Print["\nI(s,xi) = G*conj(G) != G^2 in general!"];
Print["I is the MODULUS squared, Z is the algebraic square."];
Print["Both are tractable, but they encode DIFFERENT information."];
