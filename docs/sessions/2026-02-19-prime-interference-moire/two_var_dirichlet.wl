(* Two-variable Dirichlet series D(s,w) = Sum 1/((ij)^s (i+j)^w) *)
(* Interpolates between multiplicative (w=0) and additive (s=0) *)

Print["=== D(s,w) = Sum_{i,j >= 2} 1/((ij)^s (i+j)^w) ===\n"];

(* Direct computation by partial sums *)
dDirect[s_, w_, nMax_] := Sum[
  1/((i j)^s (i + j)^w),
  {i, 2, nMax}, {j, 2, nMax}
];

(* --- 1. Verify known limits --- *)
Print["--- 1. Known limits ---\n"];

Print["D(s, 0) should be (Zeta[s]-1)^2:"];
Do[
  d = N[dDirect[s, 0, 200], 10];
  ref = N[(Zeta[s] - 1)^2, 10];
  Print["  s=", s, ": D=", d, "  (z-1)^2=", ref,
    "  ratio=", NumberForm[d/ref, {5, 4}]],
  {s, {2, 3, 4}}
];

Print["\nD(0, w) = Sum (c-3)/c^w (for c >= 4, counting pairs i,j>=2 with i+j=c):"];
Do[
  d = N[dDirect[0, w, 200], 10];
  ref = N[Sum[(c - 3)/c^w, {c, 4, 200}], 10];
  Print["  w=", w, ": D=", d, "  direct=", ref],
  {w, {2, 3, 4}}
];

(* --- 2. Along special lines --- *)
Print["\n--- 2. D along special lines ---\n"];

Print["Diagonal s = w:"];
Print["D(s,s) = Sum 1/[(ij)(i+j)]^s = Sum 1/[i^2 j + ij^2]^s"];
Do[
  d = N[dDirect[s, s, 300], 8];
  Print["  s=", s, ": D(s,s) = ", d],
  {s, {1, 3/2, 2, 3}}
];

Print["\nAnti-diagonal s + w = 4:"];
Do[
  d = N[dDirect[s, 4 - s, 300], 8];
  Print["  s=", NumberForm[N@s, {3, 1}], " w=", NumberForm[N[4 - s], {3, 1}],
    ": D = ", d],
  {s, {0, 1/2, 1, 3/2, 2, 5/2, 3, 7/2, 4}}
];

(* --- 3. Inner sum structure: fixed c = i+j --- *)
Print["\n--- 3. Inner sum: B(s,c) = Sum_{i=2}^{c-2} 1/(i(c-i))^s ---\n"];

innerB[s_, c_] := Sum[1/(i (c - i))^s, {i, 2, c - 2}];

Print["B(s, c) for small c:"];
Print["c    B(1,c)       B(2,c)       B(3,c)"];
Do[
  Print["  ", StringPadRight[ToString[c], 5],
    StringPadRight[ToString@NumberForm[N[innerB[1, c]], {8, 5}], 13],
    StringPadRight[ToString@NumberForm[N[innerB[2, c]], {8, 5}], 13],
    NumberForm[N[innerB[3, c]], {8, 5}]],
  {c, 4, 20}
];

(* --- 4. Asymptotic: B(s,c) for large c --- *)
Print["\n--- 4. B(s,c) asymptotics for large c ---"];
Print["For large c: i(c-i) ~ c*i for small i, ~ c^2/4 for i~c/2"];
Print["Dominant contribution from i ~ c/2: B ~ (c^2/4)^{-s} * c"];
Print["So B(s,c) ~ c^{1-2s} * 4^s * (integral factor)\n"];

Print["Check: c^{2s-1} * B(s,c) should converge:"];
Do[
  Do[
    ratio = N[c^(2 s - 1) innerB[s, c]];
    If[c == 100, Print["  s=", s, " c=", c,
      " c^{2s-1}*B = ", NumberForm[ratio, {8, 4}]]],
    {c, {20, 50, 100}}
  ],
  {s, {1, 3/2, 2, 3}}
];

Print["\nThe integral limit: Int_0^1 1/(t(1-t))^s dt = Beta(1-s, 1-s)"];
Print["  = Gamma(1-s)^2 / Gamma(2-2s)  (converges for s < 1)"];
Do[
  intVal = N[Beta[1 - s, 1 - s], 8];
  numVal = N[100^(2 s - 1) innerB[s, 100], 8];
  Print["  s=", NumberForm[N@s, {3, 2}],
    ": Beta(1-s,1-s) = ", intVal,
    "  numerical = ", numVal],
  {s, {1/4, 1/2, 3/4}}
];

(* --- 5. Pole structure of D(s,w) --- *)
Print["\n--- 5. Pole structure ---"];
Print["D(s,w) = Sum_c c^{-w} B(s,c) where B(s,c) ~ c^{1-2s} * const"];
Print["So D ~ const * Sum c^{-w+1-2s} = const * Zeta(w+2s-1)"];
Print["Pole when w + 2s - 1 = 1, i.e., w + 2s = 2\n"];

Print["Verify: D(s,w) diverges near w + 2s = 2:"];
Do[
  w = 2 - 2 s + 0.5; (* slightly above the pole line *)
  d = N[dDirect[s, w, 100], 6];
  w2 = 2 - 2 s + 0.1;
  d2 = N[dDirect[s, w2, 100], 6];
  Print["  s=", NumberForm[N@s, {3, 1}],
    " w=", NumberForm[w, {4, 2}], ": D=", NumberForm[d, {8, 3}],
    "   w=", NumberForm[w2, {4, 2}], ": D=", NumberForm[d2, {8, 3}],
    If[Abs[d2] > Abs[d], " (growing -> pole)", ""]],
  {s, {1/2, 3/4, 1}}
];

(* --- 6. Full landscape: D(s,w) for a grid of (s,w) --- *)
Print["\n--- 6. D(s,w) landscape (N=150) ---\n"];
Print["           w=0       w=1       w=2       w=3       w=4"];
Print[StringJoin@Table["-", 65]];
Do[
  vals = Table[
    If[s == 0 && w <= 1, "div",
      ToString@NumberForm[Re@N[dDirect[s, w, 150]], {7, 4}]],
    {w, {0, 1, 2, 3, 4}}
  ];
  Print["  s=", StringPadRight[ToString@NumberForm[N@s, {3, 1}], 5],
    StringJoin[StringPadRight[#, 10] & /@ vals]],
  {s, {0, 1/2, 1, 3/2, 2, 3}}
];

(* --- 7. Multiplicative structure: does D factor for special (s,w)? --- *)
Print["\n--- 7. Special structure ---"];
Print["At w=1: D(s,1) = Sum 1/((ij)^s (i+j))"];
Print["  = Sum 1/((ij)^s) * [1/i - 1/j]/(j-i) ... partial fractions?"];
Print["  Using 1/(i+j) = Int_0^1 t^{i+j-1} dt:"];
Print["  D(s,1) = Int_0^1 [Sum_{i>=2} t^{i-1}/i^s]^2 dt"];
Print["         = Int_0^1 [Li_s(t) - t]^2 / t^2 dt  (... almost)"];

(* Verify this integral representation *)
Print["\nVerify integral representation at s=2:"];
integrand[s_, t_] := (PolyLog[s, t] - t)^2/t^2;
intResult = NIntegrate[integrand[2, t], {t, 0, 1},
  MaxRecursion -> 20, WorkingPrecision -> 15];
directResult = N[dDirect[2, 1, 300], 10];
Print["  Integral:  ", NumberForm[intResult, {10, 6}]];
Print["  Direct:    ", NumberForm[directResult, {10, 6}]];
Print["  Match:     ", Abs[intResult - directResult] < 0.01];

(* Hmm, let me derive more carefully *)
(* D(s,1) = Sum_{i,j>=2} 1/((ij)^s (i+j)) *)
(* Using 1/(i+j) = Int_0^inf e^{-(i+j)t} dt: *)
(* D(s,1) = Int_0^inf [Sum_{i>=2} e^{-it}/i^s]^2 dt *)
(*        = Int_0^inf [Li_s(e^{-t}) - e^{-t}]^2 dt *)

Print["\nAlternate: using 1/(i+j) = Int_0^inf e^{-(i+j)t} dt:"];
Print["D(s,1) = Int_0^inf [Li_s(e^{-t}) - e^{-t}]^2 dt"];
intResult2 = NIntegrate[(PolyLog[2, Exp[-t]] - Exp[-t])^2, {t, 0, Infinity},
  MaxRecursion -> 20, WorkingPrecision -> 15];
Print["  Integral (s=2): ", NumberForm[intResult2, {10, 6}]];
Print["  Direct (s=2):   ", NumberForm[directResult, {10, 6}]];
Print["  Match:           ", Abs[intResult2 - directResult] < 0.001];

(* --- 8. General integral representation --- *)
Print["\n--- 8. General integral representation ---"];
Print["D(s,w) = (1/Gamma[w]) Int_0^inf t^{w-1} [Li_s(e^{-t}) - e^{-t}]^2 dt"];
Print["  (using 1/(i+j)^w = (1/Gamma[w]) Int t^{w-1} e^{-(i+j)t} dt)\n"];

Print["This is the MELLIN TRANSFORM of |G(s, it/(2 Pi))|^2 !"];
Print["  G(s, xi) = Li_s(e^{2 Pi i xi}) - e^{2 Pi i xi}"];
Print["  Setting xi = it/(2Pi) (imaginary): e^{2Pi i xi} = e^{-t}"];
Print["  So [Li_s(e^{-t}) - e^{-t}]^2 = G(s, it/(2Pi))^2"];
Print[""];
Print["D(s,w) connects the VERTICAL series G(s,xi)"];
Print["  to the RADIAL series through a Mellin transform in w!"];

(* Verify for a few (s,w) *)
Print["\nVerify integral representation:"];
Do[
  intVal = NIntegrate[
    t^(w - 1) (PolyLog[s, Exp[-t]] - Exp[-t])^2 / Gamma[w],
    {t, 0, Infinity},
    MaxRecursion -> 20, WorkingPrecision -> 12];
  dirVal = N[dDirect[s, w, 200], 8];
  Print["  s=", s, " w=", w,
    ": integral=", NumberForm[Re@intVal, {8, 5}],
    "  direct=", NumberForm[dirVal, {8, 5}],
    "  match=", Abs[intVal - dirVal]/Abs[dirVal] < 0.02],
  {s, {2, 3}}, {w, {1, 2, 3}}
];
