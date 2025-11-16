#!/usr/bin/env wolframscript
(* Verification of Integral Representation for L_M(s) *)

Print["=== Integral Representation Verification ==="];
Print["Testing: L_M(s) = 1/Γ(s) ∫ t^(s-1) [Li_s(e^-t) - e^-t]/(1-e^-t) dt"];
Print[""];

(* Direct sum reference (for Re(s) > 1) *)
M[n_] := Floor[(DivisorSigma[0, n] - 1)/2];

DirectLM[s_?NumericQ, nMax_Integer : 5000] :=
  N[Sum[M[n]/n^s, {n, 1, nMax}], 50];

(* Integral representation - with separated singular part *)
LMIntegral[s_?NumericQ] := Module[{singularPart, regularIntegrand, regularPart, result},
  (* Singular part: (ζ(s)-1)/(s-1) *)
  If[Abs[s - 1] > 0.01,
    singularPart = (Zeta[s] - 1)/(s - 1),
    singularPart = 0  (* Skip near pole for now *)
  ];

  (* Regular integrand: full - singular/t^{s-1} *)
  regularIntegrand[t_] := Module[{full, singular},
    If[t == 0, Return[0]];

    full = (PolyLog[s, Exp[-t]] - Exp[-t])/(1 - Exp[-t]);
    singular = (Zeta[s] - 1)/t;

    t^(s-1) * (full - singular)
  ];

  (* Integrate regular part *)
  regularPart = NIntegrate[regularIntegrand[t], {t, 0, 30},
    WorkingPrecision -> 30,
    Method -> "GlobalAdaptive",
    MaxRecursion -> 15
  ];

  (* Combine *)
  result = (singularPart + regularPart) / Gamma[s];
  result
];

(* Test 1: Convergence in Re(s) > 1 *)
Print["Test 1: Agreement with direct sum (Re(s) > 1)"];
Print["-----------------------------------------------"];

testPoints = {2, 3, 2 + I, 1.5 + 2*I};

Do[
  Module[{s, direct, integral, error},
    s = pt;
    direct = DirectLM[s, 5000];
    integral = LMIntegral[s];
    error = Abs[direct - integral];

    Print["s = ", s];
    Print["  Direct sum:  ", direct];
    Print["  Integral:    ", integral];
    Print["  Error:       ", ScientificForm[error]];
    Print["  Relative:    ", ScientificForm[error/Abs[integral]]];
    Print[""];
  ],
  {pt, testPoints}
];

(* Test 2: Analytic continuation to critical line *)
Print["Test 2: Values on critical line (Re(s) = 1/2)"];
Print["-----------------------------------------------"];

criticalPoints = Table[1/2 + I*t, {t, {5, 10, 20, 30}}];

Do[
  Module[{s, val},
    s = pt;
    val = LMIntegral[s];

    Print["s = ", s];
    Print["  L_M(s) = ", val];
    Print["  |L_M(s)| = ", Abs[val]];
    Print["  arg(L_M(s)) = ", Arg[val]];
    Print[""];
  ],
  {pt, criticalPoints}
];

(* Test 3: Schwarz symmetry L_M(conj(s)) = conj(L_M(s)) *)
Print["Test 3: Schwarz symmetry on critical line"];
Print["-------------------------------------------"];

Do[
  Module[{s, sConj, valS, valSConj, conjValS, error},
    s = 1/2 + I*t;
    sConj = Conjugate[s];

    valS = LMIntegral[s];
    valSConj = LMIntegral[sConj];
    conjValS = Conjugate[valS];

    error = Abs[valSConj - conjValS];

    Print["t = ", t];
    Print["  L_M(1/2+it) = ", valS];
    Print["  L_M(1/2-it) = ", valSConj];
    Print["  conj(L_M(1/2+it)) = ", conjValS];
    Print["  Schwarz error = ", ScientificForm[error]];
    Print[""];
  ],
  {t, {5, 10, 20}}
];

Print["=== Verification complete ==="];
