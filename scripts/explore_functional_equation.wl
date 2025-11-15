#!/usr/bin/env wolframscript
(*
  Functional Equation Search for L_M(s)

  Goal: Find relationship between L_M(s) and L_M(1-s)

  Classical FR for ζ(s):
    π^(-s/2) Γ(s/2) ζ(s) = π^(-(1-s)/2) Γ((1-s)/2) ζ(1-s)

  We test:
  1. Direct ratio L_M(s) / L_M(1-s)
  2. With Gamma factors
  3. With π factors
*)

Print["================================================"];
Print["Functional Equation Search for L_M(s)"];
Print["================================================\n"];

(* Closed form computation *)
TailZeta[s_?NumericQ, m_Integer] := Zeta[s] - Sum[k^(-s), {k, 1, m-1}];

ComputeLM[s_?NumericQ, nMax_Integer : 200] := Module[{},
  (* Using closed form: L_M(s) = ζ(s)[ζ(s)-1] - Σ H_{j-1}(s)/j^s *)
  N[Zeta[s] * (Zeta[s] - 1) - Sum[TailZeta[s, j]/j^s, {j, 2, nMax}], 30]
];

(* ========================================= *)
(* Part 1: Direct ratio L_M(s) / L_M(1-s)  *)
(* ========================================= *)

Print["Part 1: Direct ratio L_M(s) / L_M(1-s)\n"];
Print["Testing for s = σ + it with varying σ, t\n"];

testPoints = {
  {1.5, 0},    (* Real axis *)
  {1.3, 0},
  {2.0, 5.0},  (* Complex *)
  {1.5, 10.0},
  {1.7, 14.135}  (* Near first RH zero *)
};

Print["s\t\t\tL_M(s)\t\t\tL_M(1-s)\t\tRatio"];
Print[StringRepeat["-", 80]];

ratios = Table[
  s = σ + I*t;
  s1 = 1 - s;  (* Reflected point *)

  Ls = ComputeLM[s, 200];
  Ls1 = ComputeLM[s1, 200];
  ratio = Ls / Ls1;

  Print[N[s, 4], "\t", N[Abs[Ls], 6], "\t", N[Abs[Ls1], 6], "\t", N[ratio, 6]];

  {s, ratio},
  {pt, testPoints}, {σ, pt[[1]]}, {t, pt[[2]]}
];

Print["\n"];

(* ========================================= *)
(* Part 2: With Gamma factors              *)
(* ========================================= *)

Print["Part 2: Testing with Gamma factors\n"];
Print["Classical zeta: π^(-s/2) Γ(s/2) ζ(s) = π^(-(1-s)/2) Γ((1-s)/2) ζ(1-s)\n"];

Print["Testing: Γ(s/2) L_M(s) vs Γ((1-s)/2) L_M(1-s)\n"];

gammaRatios = Table[
  s = σ + I*t;
  s1 = 1 - s;

  Ls = ComputeLM[s, 200];
  Ls1 = ComputeLM[s1, 200];

  (* With Gamma factors *)
  ΛLs = Gamma[s/2] * Ls;
  ΛLs1 = Gamma[(1-s)/2] * Ls1;

  ratio = ΛLs / ΛLs1;

  Print[N[s, 4], "\t", N[Abs[ratio], 6]];

  {s, ratio},
  {pt, testPoints}, {σ, pt[[1]]}, {t, pt[[2]]}
];

Print["\n"];

(* ========================================= *)
(* Part 3: With π factors                  *)
(* ========================================= *)

Print["Part 3: Testing with π^(-s/2) Γ(s/2) factors\n"];

piGammaRatios = Table[
  s = σ + I*t;
  s1 = 1 - s;

  Ls = ComputeLM[s, 200];
  Ls1 = ComputeLM[s1, 200];

  (* Full classical factor *)
  ΛLs = Pi^(-s/2) * Gamma[s/2] * Ls;
  ΛLs1 = Pi^(-(1-s)/2) * Gamma[(1-s)/2] * Ls1;

  ratio = ΛLs / ΛLs1;

  Print[N[s, 4], "\t", N[Abs[ratio], 6], "\t", N[Arg[ratio], 6]];

  {s, ratio},
  {pt, testPoints}, {σ, pt[[1]]}, {t, pt[[2]]}
];

Print["\n"];

(* ========================================= *)
(* Part 4: Scan critical line Re(s) = 1/2  *)
(* ========================================= *)

Print["Part 4: Scan critical line Re(s) = 1/2\n"];
Print["If FR exists, ratio should be constant (or simple function of t)\n"];

criticalRatios = Table[
  s = 0.5 + I*t;
  s1 = 0.5 - I*t;  (* Reflection on critical line *)

  Ls = ComputeLM[s, 200];
  Ls1 = ComputeLM[s1, 200];

  (* Note: s1 = Conjugate[s] on critical line *)
  (* So L_M(s) vs L_M(Conjugate[s]) *)

  ratio = Ls / Conjugate[Ls];

  {t, ratio, Abs[ratio], Arg[ratio]},
  {t, {5, 10, 14.135, 20, 25, 30}}
];

Print["t\t|ratio|\t\tArg(ratio)"];
Print[StringRepeat["-", 40]];
Do[
  Print[r[[1]], "\t", N[r[[3]], 6], "\t", N[r[[4]], 6]],
  {r, criticalRatios}
];

Print["\n"];

(* ========================================= *)
(* Part 5: Pattern detection               *)
(* ========================================= *)

Print["================================================"];
Print["PATTERN ANALYSIS"];
Print["================================================\n"];

Print["Looking for simple relationships:\n"];

(* Check if ratio is polynomial in s *)
Print["Hypothesis 1: L_M(s) / L_M(1-s) = f(s) (polynomial?)\n"];
ratioPoly = Table[
  s = 1.5 + I*t;
  s1 = 1 - s;
  Ls = ComputeLM[s, 200];
  Ls1 = ComputeLM[s1, 200];
  {t, Ls/Ls1},
  {t, {0, 5, 10, 15}}
];

Print["Ratios at different t (fixed σ=1.5):"];
Do[Print["t=", r[[1]], ": ratio=", N[r[[2]], 6]], {r, ratioPoly}];

Print["\n"];

(* Check symmetry on critical line *)
Print["Hypothesis 2: On critical line, L_M(1/2+it) = Conjugate[L_M(1/2-it)]\n"];
symmetryTest = Table[
  s = 0.5 + I*t;
  Ls = ComputeLM[s, 200];
  LsConj = ComputeLM[0.5 - I*t, 200];
  diff = Abs[Ls - Conjugate[LsConj]];
  {t, diff},
  {t, {5, 10, 14.135, 20}}
];

Print["t\t|L_M(1/2+it) - Conj[L_M(1/2-it)]|"];
Print[StringRepeat["-", 50]];
Do[Print[s[[1]], "\t", N[s[[2]], 8]], {s, symmetryTest}];

Print["\n"];

(* ========================================= *)
(* Part 6: Connection to ζ(s)              *)
(* ========================================= *)

Print["Part 6: Connection to ζ(s) functional equation\n"];
Print["Since L_M(s) = ζ(s)[ζ(s)-1] - Σ, can we derive FR from ζ FR?\n"];

(* ζ(s) satisfies: ξ(s) = ξ(1-s) where ξ(s) = π^(-s/2) Γ(s/2) ζ(s) *)
(* Question: What about ζ(s)[ζ(s)-1]? *)

Print["Testing: ξ(s)[ζ(s)-1] where ξ(s) = π^(-s/2) Γ(s/2) ζ(s)\n"];

zetaProductTest = Table[
  s = σ + I*t;
  s1 = 1 - s;

  ξs = Pi^(-s/2) * Gamma[s/2] * Zeta[s];
  ξs1 = Pi^(-(1-s)/2) * Gamma[(1-s)/2] * Zeta[s1];

  (* ξ(s) = ξ(1-s) by FR, verify: *)
  ξRatio = ξs / ξs1;

  (* Now test product: *)
  prod1 = ξs * (Zeta[s] - 1);
  prod2 = ξs1 * (Zeta[s1] - 1);

  prodRatio = prod1 / prod2;

  {s, N[ξRatio, 6], N[prodRatio, 6]},
  {pt, {{1.5, 0}, {1.3, 5}}}, {σ, pt[[1]]}, {t, pt[[2]]}
];

Print["s\t\tξ(s)/ξ(1-s)\t\tξ(s)[ζ(s)-1] / ξ(1-s)[ζ(1-s)-1]"];
Print[StringRepeat["-", 70]];
Do[
  Print[N[z[[1]], 4], "\t", z[[2]], "\t", z[[3]]],
  {z, zetaProductTest}
];

Print["\n"];

Print["================================================"];
Print["NEXT STEPS"];
Print["================================================\n"];

Print["1. If ratios show pattern → derive algebraic FR"];
Print["2. If symmetry on critical line → special case"];
Print["3. Numerical search for factor γ(s) such that γ(s)L_M(s) = γ(1-s)L_M(1-s)"];
Print["4. Connection to primal forest geometry?"];

Print["\nExploration complete!"];
