(* Verification of lemmas in chebyshev-integral-identity.tex *)

Print["=== Lemma 1: A_k = Integrate[|Sin[k theta]|, {theta, 0, Pi}] = 2 ==="];
Print[""];

(* Integer k *)
Print["Integer k:"];
Do[
  val = NIntegrate[Abs[Sin[k theta]], {theta, 0, Pi}];
  Print["  A_", k, " = ", val, "  (expected 2, diff = ", Abs[val - 2], ")"],
  {k, 1, 20}
];

Print[""];
Print["Half-integer k:"];
Do[
  val = NIntegrate[Abs[Sin[k theta]], {theta, 0, Pi}];
  Print["  A_", k, " = ", val, "  (expected 2, diff = ", Abs[val - 2], ")"],
  {k, {3/2, 5/2, 7/2, 9/2, 11/2, 13/2, 15/2, 17/2, 19/2, 21/2}}
];

Print[""];
Print["Paper's example: A_{5/2} = 4/5 + 4/5 + 2/5 = 2"];
(* Verify by splitting at zeros of Sin[5 theta/2] in [0,Pi] *)
(* Zeros at theta = 2m Pi/5, m=0,1,2 *)
a1 = Integrate[Abs[Sin[5 theta/2]], {theta, 0, 2 Pi/5}];
a2 = Integrate[Abs[Sin[5 theta/2]], {theta, 2 Pi/5, 4 Pi/5}];
a3 = Integrate[Abs[Sin[5 theta/2]], {theta, 4 Pi/5, Pi}];
Print["  Piece 1: ", a1, "  Piece 2: ", a2, "  Piece 3: ", a3, "  Sum: ", a1 + a2 + a3];

Print[""];
Print["Non-half-integer k (should NOT be 2):"];
Do[
  val = NIntegrate[Abs[Sin[k theta]], {theta, 0, Pi}];
  Print["  A_", k, " = ", val, "  (diff from 2: ", val - 2, ")"],
  {k, {1/3, 2/3, 4/3, 5/3, 7/3, Pi, E, Sqrt[2]}}
];

Print[""];
Print["=== Lemma 2: B_k = Integrate[|Sin[k theta]| Cos[2 theta], {theta, 0, Pi}] = 0 ==="];
Print[""];

Print["Integer k:"];
Do[
  val = NIntegrate[Abs[Sin[k theta]] Cos[2 theta], {theta, 0, Pi}];
  Print["  B_", k, " = ", val, "  (expected 0)"],
  {k, 2, 20}
];

Print[""];
Print["Half-integer k:"];
Do[
  val = NIntegrate[Abs[Sin[k theta]] Cos[2 theta], {theta, 0, Pi}];
  Print["  B_", k, " = ", val, "  (expected 0)"],
  {k, {3/2, 5/2, 7/2, 9/2, 11/2, 13/2, 15/2}}
];

Print[""];
Print["Non-half-integer k (should NOT be 0):"];
Do[
  val = NIntegrate[Abs[Sin[k theta]] Cos[2 theta], {theta, 0, Pi}];
  Print["  B_", k, " = ", val],
  {k, {1/3, 2/3, 4/3, 5/3, 7/3, Pi, E}}
];

Print[""];
Print["=== Theorem 1: I_k = Integrate[|T_{k+1}(x) - x T_k(x)|, {x, -1, 1}] = 1 ==="];
Print[""];

(* Use ChebyshevT for integer k *)
Print["Integer k (using ChebyshevT):"];
Do[
  fk[x_] := ChebyshevT[k + 1, x] - x ChebyshevT[k, x];
  val = NIntegrate[Abs[fk[x]], {x, -1, 1}];
  Print["  I_", k, " = ", val, "  (expected 1, diff = ", Abs[val - 1], ")"],
  {k, 2, 20}
];

Print[""];
Print["Half-integer k (using Cos representation):"];
Do[
  fk[theta_] := Cos[(k + 1) theta] - Cos[theta] Cos[k theta];
  val = NIntegrate[Abs[fk[theta]] Sin[theta], {theta, 0, Pi}];
  Print["  I_", k, " = ", val, "  (expected 1, diff = ", Abs[val - 1], ")"],
  {k, {3/2, 5/2, 7/2, 9/2, 11/2, 13/2, 15/2}}
];

Print[""];
Print["k=1 exception:"];
val = NIntegrate[Abs[ChebyshevT[2, x] - x ChebyshevT[1, x]], {x, -1, 1}];
Print["  I_1 = ", val, "  (expected 4/3 = ", N[4/3], ")"];

Print[""];
Print["=== Verify: f_k(cos theta) = -Sin[k theta] Sin[theta] ==="];
Print[""];
Do[
  err = Simplify[
    ChebyshevT[k + 1, Cos[theta]] - Cos[theta] ChebyshevT[k, theta] -
    (-Sin[k theta] Sin[theta]) // TrigExpand
  ];
  (* Use numerical check instead *)
  testPts = Table[Pi i/17, {i, 0, 17}];
  maxErr = Max[Abs[Table[
    ChebyshevT[k + 1, Cos[t]] - Cos[t] ChebyshevT[k, t] - (-Sin[k t] Sin[t]),
    {t, testPts}
  ]]];
  Print["  k=", k, ": max numerical error = ", maxErr],
  {k, 2, 10}
];

Print[""];
Print["=== Theorem 2: Signed Integral ==="];
Print[""];

Print["Odd integer k (expected 4/(k^3-4k)):"];
Do[
  fk[x_] := ChebyshevT[k + 1, x] - x ChebyshevT[k, x];
  val = NIntegrate[fk[x], {x, -1, 1}];
  expected = 4/(k^3 - 4 k);
  Print["  k=", k, ": integral = ", val, "  expected = ", N[expected],
        "  diff = ", Abs[val - N[expected]]],
  {k, {3, 5, 7, 9, 11, 13, 15, 17, 19}}
];

Print[""];
Print["Even integer k (expected 0):"];
Do[
  fk[x_] := ChebyshevT[k + 1, x] - x ChebyshevT[k, x];
  val = NIntegrate[fk[x], {x, -1, 1}];
  Print["  k=", k, ": integral = ", val, "  (expected 0)"],
  {k, {2, 4, 6, 8, 10, 12}}
];

Print[""];
Print["Half-integer k (expected 2/(k^3-4k)):"];
Do[
  fk[theta_] := Cos[(k + 1) theta] - Cos[theta] Cos[k theta];
  val = NIntegrate[fk[theta] Sin[theta], {theta, 0, Pi}];
  expected = 2/(k^3 - 4 k);
  Print["  k=", k, ": integral = ", val, "  expected = ", N[expected],
        "  diff = ", Abs[val - N[expected]]],
  {k, {3/2, 5/2, 7/2, 9/2, 11/2, 13/2, 15/2}}
];

Print[""];
Print["=== Remark 2: Integral[(1-x^2)|U_{k-1}(x)|, {x,-1,1}] = 1 for k>=2 ==="];
Print[""];
Do[
  val = NIntegrate[(1 - x^2) Abs[ChebyshevU[k - 1, x]], {x, -1, 1}];
  Print["  k=", k, ": ", val, "  (expected 1, diff = ", Abs[val - 1], ")"],
  {k, 2, 15}
];

Print[""];
Print["=== Symbolic verification of A_k for small k ==="];
Print[""];
Do[
  val = Integrate[Abs[Sin[k theta]], {theta, 0, Pi}, Assumptions -> theta \[Element] Reals];
  Print["  A_", k, " = ", val, "  (simplified: ", FullSimplify[val], ")"],
  {k, {1, 2, 3, 4, 5, 3/2, 5/2, 7/2}}
];

Print[""];
Print["=== DONE ==="];
