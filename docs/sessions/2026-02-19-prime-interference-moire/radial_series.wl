(* Radial Dirichlet series J(s) = Zeta[s-1] - Zeta[s] *)
(* vs vertical series Zeta[s]^2 *)

Print["=== Radial vs Vertical Dirichlet Series ===\n"];

(* --- 1. Verify J(s) = Zeta[s-1] - Zeta[s] --- *)
Print["--- 1. Verify J(s) = Sum[(c-1)/c^s] = Zeta[s-1] - Zeta[s] ---\n"];
Do[
  direct = N[Sum[(c - 1)/c^s, {c, 2, 10000}], 10];
  formula = N[Zeta[s - 1] - Zeta[s], 10];
  Print["  s=", s, ": direct=", direct, "  formula=", formula,
    "  diff=", ScientificForm[Abs[direct - formula], 2]],
  {s, {3, 4, 5}}
];

(* --- 2. Poles and zeros --- *)
Print["\n--- 2. Poles ---"];
Print["J(s) = Zeta[s-1] - Zeta[s]"];
Print["  Pole at s=2: Zeta[s-1] has pole (Zeta[1] = inf)"];
Print["  Pole at s=1: -Zeta[s] has pole"];
Print["  Residue at s=2: lim_{s->2} (s-2) Zeta[s-1] = 1"];
Print["  Residue at s=1: lim_{s->1} (s-1)(-Zeta[s]) = -1"];

(* --- 3. Where does Zeta[s-1] = Zeta[s]? (zeros of J) --- *)
Print["\n--- 3. Zeros of J: where Zeta[s-1] = Zeta[s] ---"];
Print["On real axis (s > 2):"];
Print["  Zeta[s-1] is decreasing, Zeta[s] is decreasing"];
Print["  Zeta[s-1] > Zeta[s] for s > 2 (since s-1 < s and zeta decreasing)"];
Print["  So J(s) > 0 for all real s > 2: no real zeros.\n"];

Print["Scanning real axis:"];
Do[
  val = N[Zeta[s - 1] - Zeta[s]];
  Print["  s=", NumberForm[N@s, {4, 1}],
    "  J=", NumberForm[val, {8, 4}],
    "  zeta(s-1)=", NumberForm[N@Zeta[s - 1], {8, 4}],
    "  zeta(s)=", NumberForm[N@Zeta[s], {8, 4}]],
  {s, {2.5, 3, 4, 5, 10, 20}}
];

(* --- 4. Comparison on the critical line --- *)
Print["\n--- 4. J vs Zeta^2 on the critical line s = 2 + it ---"];
Print["(Using s=2+it since J has pole at s=1)\n"];
Print["t       |J(2+it)|      |Zeta(2+it)^2|   J/Z^2"];
Print[StringJoin@Table["-", 55]];
Do[
  s0 = 2 + I t;
  jVal = N[Zeta[s0 - 1] - Zeta[s0]];
  z2Val = N[Zeta[s0]^2];
  Print["  ", StringPadRight[ToString@NumberForm[N@t, {4, 1}], 8],
    StringPadRight[ToString@NumberForm[Abs[jVal], {8, 4}], 14],
    StringPadRight[ToString@NumberForm[Abs[z2Val], {8, 4}], 16],
    NumberForm[Abs[jVal/z2Val], {5, 3}]],
  {t, Range[0, 30, 2]}
];

(* --- 5. Radial height spectrum --- *)
Print["\n--- 5. Radial height spectrum: weighted by xi ---"];
Print["On circle r=c, heights are y = 2i-c for i=1,...,c-1"];
Print["Fourier transform at frequency xi:\n"];

radialHat[c_, xi_] := Sum[Exp[2 Pi I xi (2 i - c)], {i, 1, c - 1}];

Print["c    xi=0 (count)  xi=1/4          xi=1/2"];
Do[
  v0 = radialHat[c, 0];
  v14 = N[radialHat[c, 1/4], 6];
  v12 = N[radialHat[c, 1/2], 6];
  Print["  ", StringPadRight[ToString[c], 5],
    StringPadRight[ToString[v0], 14],
    StringPadRight[ToString@NumberForm[v14, {6, 3}], 16],
    NumberForm[v12, {6, 3}]],
  {c, 2, 15}
];

(* Closed form for xi=1/2 *)
Print["\nAt xi=1/2: sum = Sum[(-1)^(2i-c), {i,1,c-1}]"];
Print["  = (-1)^(-c) Sum[(-1)^(2i), {i,1,c-1}] = (-1)^c (c-1)"];
Print["  (since (-1)^(2i) = 1 always)\n"];

Print["Verify:"];
Do[
  Print["  c=", c, ": formula (-1)^c(c-1) = ", (-1)^c (c - 1),
    "  direct = ", radialHat[c, 1/2]],
  {c, 2, 10}
];

Print["\nSo the xi=1/2 radial series is:"];
Print["  Sum[(-1)^c (c-1)/c^s] = -Zeta[s-1] + Zeta[s] + 2(Zeta[s-1] - Zeta[s])..."];
Print["  Let me compute directly:"];

(* Split into even and odd c *)
Print["  Even c: Sum[(c-1)/c^s, c=2,4,6,...] = Sum[(2k-1)/(2k)^s]"];
Print["  Odd c:  Sum[-(c-1)/c^s, c=3,5,7,...] = -Sum[(2k)/(2k+1)^s]"];

(* Numerical check *)
Print["\n  Direct sum vs formula at s=3:"];
direct12 = N[Sum[(-1)^c (c - 1)/c^3, {c, 2, 10000}], 10];
Print["  Direct: ", direct12];

(* Try: (-1)^c (c-1)/c^s = (-1)^c c^{1-s} - (-1)^c c^{-s} *)
(* Sum (-1)^c c^{1-s} = -eta(s-1), Sum (-1)^c c^{-s} = -eta(s) *)
(* But careful: sum starts at c=2, and (-1)^c alternates starting with +1 *)
formulaAttempt = N[
  Sum[(-1)^c/c^2, {c, 2, Infinity}] - Sum[(-1)^c/c^3, {c, 2, Infinity}],
  10];
Print["  (-1)^c c^{-2} sum - (-1)^c c^{-3} sum: ", formulaAttempt];

(* More carefully: *)
(* Sum_{c>=2} (-1)^c c^{1-s} = Sum_{c>=1} (-1)^c c^{1-s} - (-1)^1 * 1 *)
(* = -eta(s-1) + 1 *)
(* Sum_{c>=2} (-1)^c c^{-s} = -eta(s) + 1 *)
(* So J_{1/2}(s) = (-eta(s-1)+1) - (-eta(s)+1) = eta(s) - eta(s-1) *)
formula12 = N[DirichletEta[3] - DirichletEta[2], 10];
Print["  eta(s) - eta(s-1) = eta(3)-eta(2) = ", formula12];
Print["  Match: ", Abs[direct12 - formula12] < 10^-6];

Print["\n=== KEY RESULT ==="];
Print["Radial series at xi=0:   J_0(s) = Zeta[s-1] - Zeta[s]"];
Print["Radial series at xi=1/2: J_{1/2}(s) = Eta[s] - Eta[s-1]"];
Print["Vertical series at xi=0:   I_0(s) = (Zeta[s]-1)^2"];
Print["Vertical series at xi=1/2: I_{1/2}(s) = (1-Eta[s])^2"];
