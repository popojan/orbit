(* Euler-Maclaurin expansion of R(s,c) for large c *)
(* R(s,c) = Sum_{i=1}^{c-1} 1/(i(c-i))^s *)
(* Substitution t = i/c: R(s,c) ~ c^{1-2s} Int_0^1 (t(1-t))^{-s} dt + corrections *)

Print["=== Euler-Maclaurin for R(s,c) ===\n"];

R[s_, c_] := Sum[1/(i (c - i))^s, {i, 1, c - 1}];

(* --- 1. The leading integral --- *)
Print["--- 1. Leading term: c^{1-2s} * I(s) ---"];
Print["I(s) = Int_0^1 (t(1-t))^{-s} dt = Beta(1-s, 1-s) = Gamma(1-s)^2/Gamma(2-2s)"];
Print["  Converges only for Re(s) < 1!\n"];

(* For s >= 1, the integral diverges at t=0 and t=1 *)
(* But the DISCRETE sum R(s,c) converges for all s *)
(* So we need a regularized version *)

Print["--- 2. Regularized: exclude endpoints ---"];
Print["R(s,c) = Sum_{i=1}^{c-1} f(i/c)/c^{2s} where f(t) = (t(1-t))^{-s}"];
Print["The sum is a Riemann sum of f on (0,1) with step 1/c\n"];

(* Euler-Maclaurin: Sum_{i=1}^{N-1} g(i) = Int_1^{N-1} g + corrections *)
(* Here g(i) = 1/(i(c-i))^s, summed from i=1 to c-1 *)

(* More useful: compute R(s,c)*c^{2s-1} and see how it depends on c *)
Print["--- 3. Normalized: R(s,c) * c^{2s-1} ---\n"];

Do[
  Print["s = ", s, ":"];
  Do[
    normalized = N[R[s, c] * c^(2 s - 1), 12];
    Print["  c=", StringPadRight[ToString[c], 6],
      " R*c^{2s-1} = ", NumberForm[normalized, {10, 6}]],
    {c, {5, 10, 20, 50, 100, 200, 500}}
  ];
  Print[""],
  {s, {3/2, 2, 3}}
];

(* --- 4. Fit: R(s,c)*c^{2s-1} = A + B/c + C/c^2 + ... --- *)
Print["--- 4. Asymptotic expansion R(s,c)*c^{2s-1} = A(s) + B(s)/c + C(s)/c^2 + ... ---\n"];

Do[
  data = Table[{c, N[R[s, c] c^(2 s - 1), 20]}, {c, 50, 500, 50}];
  (* Fit polynomial in 1/c *)
  fit = Fit[{1/#1, #2} & @@@ data, {1, x, x^2, x^3}, x];
  coeffs = CoefficientList[fit, x];
  Print["s = ", s, ":"];
  Print["  A(s) = ", NumberForm[coeffs[[1]], {10, 6}]];
  If[Length[coeffs] >= 2, Print["  B(s) = ", NumberForm[coeffs[[2]], {10, 6}]]];
  If[Length[coeffs] >= 3, Print["  C(s) = ", NumberForm[coeffs[[3]], {10, 6}]]];

  (* Compare A(s) with known constants *)
  Print["  Compare A with:"];
  Print["    2*Zeta(2s-1)*(2s-2)!/(s-1)!^2/4^(s-1)... too complicated"];

  (* For s=2: A should relate to pi^2 or zeta values *)
  If[s == 2,
    Print["    Pi^2/3 = ", NumberForm[N[Pi^2/3], {10, 6}]];
    Print["    Pi^2/6 = ", NumberForm[N[Pi^2/6], {10, 6}]];
    Print["    4 = ", 4];
  ];
  If[s == 3,
    Print["    Pi^4/... "];
    Print["    3*Zeta(3)/2 = ", NumberForm[N[3 Zeta[3]/2], {10, 6}]];
    Print["    3/2 = ", 3/2];
  ];
  Print[""],
  {s, {2, 3, 4}}
];

(* --- 5. Direct: what is A(s) exactly? --- *)
Print["--- 5. A(s) = lim_{c->inf} c^{2s-1} R(s,c) ---\n"];

(* For large c: R(s,c) ~ (1/c) Sum_{i=1}^{c-1} (c^2/(i(c-i)))^s / c^{2s} *)
(* = c^{1-2s} * (1/c) Sum_{i=1}^{c-1} (i/c (1-i/c))^{-s} *)
(* -> c^{1-2s} Int_0^1 (t(1-t))^{-s} dt as Riemann sum *)
(* But this integral diverges for s >= 1! *)

Print["The Riemann sum interpretation fails for s >= 1"];
Print["because (t(1-t))^{-s} is not integrable at t=0, t=1.\n"];
Print["But the DISCRETE sum converges because i >= 1 and c-i >= 1."];
Print["The Euler-Maclaurin correction terms REGULARIZE the divergence.\n"];

(* Alternative: use Hurwitz zeta / digamma *)
Print["--- 6. Exact via partial fractions ---\n"];

(* 1/(i(c-i))^s: partial fraction in i *)
(* For s=2: 1/(i^2(c-i)^2) = (1/c^2)(1/i + 1/(c-i))^2 *)
(*   = (1/c^2)(1/i^2 + 2/(i(c-i)) + 1/(c-i)^2) *)
(* Sum = (1/c^2)(2 H_{c-1}^{(2)} + (2/c) 2 H_{c-1}) *)

(* For s=1: already done: 2 H_{c-1}/c *)
(* Asymptotic: H_n ~ ln(n) + gamma + 1/(2n) - ... *)
(* So R(1,c) ~ (2/c)(ln(c) + gamma) ~ (2 ln c)/c *)

Print["R(1,c) = 2 H_{c-1}/c ~ (2 ln c + 2 gamma)/c"];
Print["R(2,c) = (2/c^2)(H_{c-1}^{(2)} + 2H_{c-1}/c)"];
Print["       ~ (2/c^2)(pi^2/6 + 2(ln c + gamma)/c)"];
Print["       = pi^2/(3c^2) + 4(ln c + gamma)/c^3 + ..."];
Print[""];
Print["So c^3 * R(2,c) ~ pi^2 c/3 + 4 ln c + 4 gamma + O(1/c)"];
Print["  This DIVERGES (linear in c)! So R*c^{2s-1} with s=2 means R*c^3,"];
Print["  which grows as c. The data confirms this.\n"];

(* Redo: for s=2, c^{2s-1} = c^3. R(2,c) ~ pi^2/(3c^2) + ... *)
(* So c^3 R ~ pi^2 c/3 -> diverges. Need higher s for convergence *)

Print["--- 7. Correct normalization ---"];
Print["R(s,c) has TWO regimes:"];
Print["  Bulk (i ~ c/2): contributes ~ c^{1-2s}"];
Print["  Boundary (i ~ 1 or ~ c-1): contributes ~ c^{-s} (from 1/(1*(c-1))^s)"];
Print["For s <= 1: bulk dominates. For s > 1: BOUNDARY dominates!\n"];

(* The boundary terms: i=1 and i=c-1 give 2/(c-1)^s *)
Print["Boundary: R_boundary(s,c) = 2/(c-1)^s ~ 2/c^s"];
Print["Bulk:     R_bulk(s,c) ~ c^{1-2s} * (regularized integral)"];
Print[""];
Print["For s=2: boundary ~ 2/c^2, bulk ~ c^{-3}. Boundary DOMINATES."];
Print["For s=3: boundary ~ 2/c^3, bulk ~ c^{-5}. Boundary DOMINATES."];
Print[""];
Print["So: zeta(s)^2 = Sum R(s,c) is dominated by the BOUNDARY terms:"];
Print["  ~ 2 Sum 1/(c-1)^s = 2 zeta(s) for the boundary"];
Print[""];

(* Verify *)
Print["--- 8. Decompose: R = boundary + interior ---\n"];
Rbound[s_, c_] := 2/(c - 1)^s;
Rinterior[s_, c_] := R[s, c] - Rbound[s, c];

Print["zeta(s)^2 = Sum R = Sum R_boundary + Sum R_interior"];
Print["         = 2 zeta(s) + Sum R_interior\n"];
Print["So: Sum R_interior = zeta(s)^2 - 2 zeta(s) = (zeta(s) - 1)^2 - 1\n"];

Do[
  sumBound = N[Sum[Rbound[s, c], {c, 2, 500}], 10];
  sumInter = N[Sum[Rinterior[s, c], {c, 2, 500}], 10];
  z2 = N[Zeta[s]^2, 10];
  twoz = N[2 Zeta[s], 10];
  Print["s=", s, ":"];
  Print["  Sum R_bound(500) = ", sumBound, "  2*zeta = ", twoz];
  Print["  Sum R_inter(500) = ", sumInter, "  zeta^2 - 2*zeta = ", N[Zeta[s]^2 - 2 Zeta[s], 10]];
  Print["  Total = ", sumBound + sumInter, "  zeta^2 = ", z2];
  Print[""],
  {s, {2, 3, 4}}
];

Print["=== KEY IDENTITY ===\n"];
Print["zeta(s)^2 = 2*zeta(s) + Sum_{c=3}^{inf} R_interior(s, c)"];
Print["where R_interior(s,c) = Sum_{i=2}^{c-2} 1/(i(c-i))^s"];
Print["  (excludes boundary factorizations i=1, i=c-1)"];
Print[""];
Print["Equivalently: (zeta(s) - 1)^2 = 1 + Sum_{c=3}^{inf} R_interior(s,c)"];
Print[""];
Print["The INTERIOR sum is the contribution of NON-TRIVIAL factorizations"];
Print["to zeta^2, organized by circles. For prime p:"];
Print["  R_interior(s, p+1) = Sum_{i=2}^{p-1} 1/(i(p+1-i))^s"];
Print["  which has NO term with i*j = p (since p is prime!)"];
