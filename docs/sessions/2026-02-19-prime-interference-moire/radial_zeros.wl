(* Zeros of J(s) = Zeta[s-1] - Zeta[s] *)
(* "Where does radial counting = vertical counting?" *)

Print["=== Zeros of J(s) = Zeta[s-1] - Zeta[s] ===\n"];

J[s_] := Zeta[s - 1] - Zeta[s];

(* --- 1. Poles --- *)
Print["--- 1. Pole structure ---"];
Print["Zeta[s-1] has pole at s=2, Zeta[s] has pole at s=1"];
Print["Near s=2: J ~ 1/(s-2) + (EulerGamma - Zeta[2]) + ..."];
Print["Near s=1: J ~ Zeta[0] - (-1/(s-1)) = -1/2 + 1/(s-1) + ..."];
Print["Residue at s=2: +1, Residue at s=1: +1"];
Print["  (both from the positive pole of zeta)\n"];

(* --- 2. Real axis behavior --- *)
Print["--- 2. J(s) on real axis ---\n"];
Print["s         J(s)          Zeta[s-1]     Zeta[s]"];
Print[StringJoin@Table["-", 55]];
Do[
  If[s != 2 && s != 1,
    jv = N[J[s], 8];
    Print["  ", StringPadRight[ToString@NumberForm[N@s, {5, 2}], 10],
      StringPadRight[ToString@NumberForm[jv, {10, 6}], 14],
      StringPadRight[ToString@NumberForm[N@Zeta[s - 1], {10, 6}], 14],
      NumberForm[N@Zeta[s], {10, 6}]]
  ],
  {s, {-5, -4, -3, -2, -1, -1/2, 0, 1/2, 3/2, 5/2, 3, 4, 5, 10, 20}}
];

(* --- 3. Negative integers: use Zeta[-n] = -B_{n+1}/(n+1) --- *)
Print["\n--- 3. Trivial zeros? ---"];
Print["Zeta has trivial zeros at s = -2, -4, -6, ..."];
Print["J(s) = Zeta[s-1] - Zeta[s] at these points:\n"];
Do[
  Print["  s=", StringPadRight[ToString[s], 4],
    " Zeta[s-1]=", NumberForm[N@Zeta[s - 1], 6],
    " Zeta[s]=", NumberForm[N@Zeta[s], 6],
    " J=", NumberForm[N@J[s], 6]],
  {s, {-1, -2, -3, -4, -5, -6, -7, -8}}
];

(* --- 4. Find complex zeros near the critical strip --- *)
Print["\n--- 4. Complex zeros of J(s) ---"];
Print["Looking for s where Zeta[s-1] = Zeta[s]\n"];

(* Search by scanning |J(s)| on a grid *)
Print["Scanning |J(sigma + i*t)| for sigma in [0,3], t in [0,30]:\n"];

(* Coarse grid first *)
minima = {};
Do[
  Do[
    s0 = sigma + I t;
    val = Abs[N[J[s0]]];
    If[val < 0.3,
      AppendTo[minima, {sigma, t, val}]],
    {t, 0.5, 40, 0.5}
  ],
  {sigma, -1, 4, 0.25}
];

(* Cluster nearby points and find local minima *)
Print["Near-zeros (|J| < 0.3):"];
Print["  sigma     t         |J|"];
Print["  ", StringJoin@Table["-", 35]];
Do[
  Print["  ",
    StringPadRight[ToString@NumberForm[m[[1]], {4, 2}], 10],
    StringPadRight[ToString@NumberForm[m[[2]], {4, 1}], 10],
    NumberForm[m[[3]], {6, 4}]],
  {m, Select[minima, #[[3]] < 0.15 &]}
];

(* --- 5. Refine zeros using FindRoot --- *)
Print["\n--- 5. Refined zeros (FindRoot) ---\n"];

(* Good starting points from the scan *)
startPts = {
  1.5 + 2 I, 1.5 + 5 I, 1.5 + 8 I, 1.5 + 10 I,
  1.5 + 13 I, 1.5 + 15 I, 1.5 + 18 I, 1.5 + 20 I,
  1.5 + 22 I, 1.5 + 25 I, 1.5 + 28 I, 1.5 + 30 I,
  1.5 + 33 I, 1.5 + 35 I, 1.5 + 38 I
};

foundZeros = {};
Do[
  Quiet[
    Check[
      z = s /. FindRoot[J[s] == 0, {s, sp}, MaxIterations -> 200];
      If[Abs[N[J[z]]] < 10^-8 && Im[z] > 0.5,
        AppendTo[foundZeros, z]],
      Null
    ]
  ],
  {sp, startPts}
];

(* Also try starting from known zeta zeros shifted *)
Do[
  Quiet[
    Check[
      gamma = Im[ZetaZero[k]];
      z = s /. FindRoot[J[s] == 0, {s, 1.5 + I gamma}, MaxIterations -> 200];
      If[Abs[N[J[z]]] < 10^-8 && Im[z] > 0.5,
        AppendTo[foundZeros, z]],
      Null
    ]
  ],
  {k, 1, 15}
];

(* Remove duplicates *)
foundZeros = DeleteDuplicatesBy[foundZeros, Round[N[#], 0.01] &];
foundZeros = SortBy[foundZeros, Im];

Print["Found zeros of J(s) = Zeta[s-1] - Zeta[s]:"];
Print["  Re[s]       Im[s]       |J(s)|       Re[s] near 1/2?"];
Print["  ", StringJoin@Table["-", 55]];
Do[
  z = N[z0, 12];
  Print["  ",
    StringPadRight[ToString@NumberForm[Re[z], {8, 5}], 14],
    StringPadRight[ToString@NumberForm[Im[z], {8, 5}], 13],
    StringPadRight[ToString@ScientificForm[Abs[N[J[z]]], 2], 13],
    If[Abs[Re[z] - 1/2] < 0.1, "YES (near 1/2)",
      If[Abs[Re[z] - 3/2] < 0.1, "near 3/2",
        If[Abs[Re[z] - 1] < 0.1, "near 1", ""]]]],
  {z0, foundZeros}
];

(* --- 6. Relationship to Riemann zeros --- *)
Print["\n--- 6. Relationship to Riemann zeros ---"];
Print["If rho is a Riemann zero (Zeta[rho]=0), is rho or rho+1 a zero of J?\n"];

Print["At s = rho (Riemann zero): J(rho) = Zeta[rho-1] - 0 = Zeta[rho-1]"];
Print["At s = rho+1: J(rho+1) = Zeta[rho] - Zeta[rho+1] = -Zeta[rho+1]"];
Print["Neither is zero in general.\n"];

Do[
  rho = N[ZetaZero[k], 10];
  Print["  rho_", k, " = ", NumberForm[rho, {8, 4}],
    "  J(rho) = Zeta[rho-1] = ", NumberForm[N[Zeta[rho - 1]], {8, 4}],
    "  J(rho+1) = -Zeta[rho+1] = ", NumberForm[-N[Zeta[rho + 1]], {8, 4}]],
  {k, 1, 5}
];

(* --- 7. Functional equation --- *)
Print["\n--- 7. Functional equation? ---"];
Print["Zeta[s] satisfies: Zeta[s] = 2^s Pi^{s-1} Sin[Pi s/2] Gamma[1-s] Zeta[1-s]"];
Print["J(s) = Zeta[s-1] - Zeta[s] does NOT have a simple functional equation"];
Print["because the shift s -> s-1 breaks the s <-> 1-s symmetry.\n"];

Print["However, J(s) + J(2-s) might be interesting:"];
Print["J(s) + J(2-s) = Zeta[s-1] - Zeta[s] + Zeta[1-s] - Zeta[2-s]"];
Print["= [Zeta[s-1] + Zeta[1-s]] - [Zeta[s] + Zeta[2-s]]"];
Print["Using Zeta[s] + Zeta[1-s] = ... (no simple form)\n"];

Do[
  s0 = sigma + I t;
  js = N[J[s0]];
  j2s = N[J[2 - s0]];
  Print["  s=", NumberForm[s0, {4, 1}],
    "  J(s)=", NumberForm[js, {7, 3}],
    "  J(2-s)=", NumberForm[j2s, {7, 3}],
    "  sum=", NumberForm[js + j2s, {7, 3}]],
  {sigma, {1}}, {t, {3, 7, 14}}
];
