#!/usr/bin/env wolframscript
(*
  Complex Evaluation of G(s, α, ε) - Zero Search

  Goal: Evaluate G(s, α, ε) for complex s and search for zeros

  Key questions:
  1. Is G(s, α, ε) zero-free for ε > 0?
  2. Do zeros appear on critical line Re(s) = 1/2?
  3. How does zero distribution change with ε?

  Strategy:
  - For ε > 0, G is analytic (no poles!)
  - Can use standard complex analysis
  - Check critical strip 0 < Re(s) < 1
  - Focus on critical line Re(s) = 1/2
*)

Print["==============================================="];
Print["Complex Evaluation of G(s, α, ε)"];
Print["===============================================\n"];

(* Define F_n with regularization - same as before *)
ComputeFn[n_Integer, alpha_, epsilon_] := Module[{sum, d, k, dist2},
  sum = 0;
  For[d = 2, d <= n, d++,
    For[k = 0, k * d + d^2 <= 2*n, k++,
      dist2 = (n - k*d - d^2)^2 + epsilon;
      If[dist2 > 0,
        sum += dist2^(-alpha)
      ];
    ];
  ];
  sum
]

(* Global function G(s, α, ε) - NOW WITH COMPLEX s *)
ComputeGComplex[s_, alpha_, epsilon_, nMax_Integer] := Module[{G},
  G = Sum[ComputeFn[n, alpha, epsilon] / n^s, {n, 2, nMax}];
  N[G, 30]  (* Higher precision for complex values *)
]

(* ============================== *)
(* Part 1: Critical Line Check    *)
(* ============================== *)

Print["Part 1: G(1/2 + it, α, ε) on critical line"];
Print["Goal: Check if zeros exist on Re(s) = 1/2"];
Print[""];

epsilon = 0.1;
alpha = 1.0;
nMax = 200;

Print["t\t\t|G(1/2+it, 1, 0.1)|\tRe(G)\t\tIm(G)"];
Print["-\t\t-----------------\t-----\t\t-----"];

tValues = {0, 5, 10, 14.134725, 20, 21.022040, 25, 30};  (* Include first two RH zeros *)

Do[
  s = 0.5 + I*t;
  G = ComputeGComplex[s, alpha, epsilon, nMax];
  Print[t, "\t\t", N[Abs[G], 8], "\t", N[Re[G], 8], "\t", N[Im[G], 8]],
  {t, tValues}
];

Print["\nNote: t ≈ 14.135 and t ≈ 21.022 are first RH zeros"];
Print["If G has zeros there, they should show up!\n"];

(* ============================== *)
(* Part 2: Critical Strip Scan    *)
(* ============================== *)

Print["Part 2: Scan critical strip 0 < Re(s) < 1"];
Print["Goal: Find minimum |G| values"];
Print[""];

nMax = 150;  (* Faster for dense scan *)

Print["Re(s)\tIm(s)\t|G(s, 1, 0.1)|\tPhase(G)"];
Print["-----\t-----\t-------------\t--------"];

(* Grid search *)
sigmaValues = {0.25, 0.5, 0.75};
tValues2 = Range[0, 30, 5];

minAbsG = Infinity;
minLocation = {};

Do[
  Do[
    s = sigma + I*t;
    G = ComputeGComplex[s, alpha, epsilon, nMax];
    absG = Abs[G];
    phase = Arg[G];

    If[absG < minAbsG,
      minAbsG = absG;
      minLocation = {sigma, t};
    ];

    Print[sigma, "\t", t, "\t", N[absG, 8], "\t", N[phase, 6]],
    {t, tValues2}
  ],
  {sigma, sigmaValues}
];

Print["\nMinimum |G| found: ", N[minAbsG, 8]];
Print["Location: σ = ", minLocation[[1]], ", t = ", minLocation[[2]], "\n"];

(* ============================== *)
(* Part 3: Epsilon Dependence     *)
(* ============================== *)

Print["Part 3: How do zeros change with ε?"];
Print["Goal: Track minimum |G| as ε → 0"];
Print[""];

s = 0.5 + 14.134725*I;  (* First RH zero *)
nMax = 200;

Print["ε\t\t|G(s, 1, ε)| at first RH zero"];
Print["-\t\t--------------------------------"];

epsilonValues = {1.0, 0.5, 0.1, 0.05, 0.01};

Do[
  G = ComputeGComplex[s, 1.0, eps, nMax];
  Print[eps, "\t\t", N[Abs[G], 8]],
  {eps, epsilonValues}
];

Print["\nObservation: Does |G| → 0 as ε → 0 at RH zeros?"];
Print["Or does regularization kill the zeros?\n"];

(* ============================== *)
(* Part 4: Different α Values     *)
(* ============================== *)

Print["Part 4: G(s, α, ε) for different α"];
Print["Goal: Does α affect zero location?"];
Print[""];

s = 0.5 + 14.134725*I;
epsilon = 0.1;
nMax = 200;

Print["α\t|G(1/2+14.135i, α, 0.1)|"];
Print["-\t--------------------------"];

alphaValues = {0.5, 0.75, 1.0, 1.25, 1.5, 2.0};

Do[
  G = ComputeGComplex[s, a, epsilon, nMax];
  Print[a, "\t", N[Abs[G], 8]],
  {a, alphaValues}
];

Print["\n"];

(* ============================== *)
(* Part 5: Fine Grid Near RH Zero *)
(* ============================== *)

Print["Part 5: Fine scan near first RH zero"];
Print["Goal: Precisely locate minimum"];
Print[""];

epsilon = 0.1;
alpha = 1.0;
nMax = 200;

(* Fine grid around σ=1/2, t=14.135 *)
Print["σ\tt\t\t|G(s, 1, 0.1)|"];
Print["-\t-\t\t-------------"];

sigmaFine = Range[0.4, 0.6, 0.05];
tFine = Range[13, 15, 0.5];

minFine = Infinity;
minLocFine = {};

Do[
  Do[
    s = sigma + I*t;
    G = ComputeGComplex[s, alpha, epsilon, nMax];
    absG = Abs[G];

    If[absG < minFine,
      minFine = absG;
      minLocFine = {sigma, t};
    ];

    Print[sigma, "\t", t, "\t\t", N[absG, 8]],
    {t, tFine}
  ],
  {sigma, sigmaFine}
];

Print["\nFine grid minimum: ", N[minFine, 8]];
Print["Location: σ = ", minLocFine[[1]], ", t = ", minLocFine[[2]], "\n"];

(* ============================== *)
(* Summary and Conjectures        *)
(* ============================== *)

Print["==============================================="];
Print["SUMMARY"];
Print["===============================================\n"];

Print["Key findings:"];
Print["1. For ε > 0, G is analytic everywhere (no poles)"];
Print["2. Minimum |G| on critical line: (to be determined)"];
Print["3. Comparison with RH zero locations: (to be analyzed)"];
Print["4. Regularization effect: (to be understood)"];
Print[""];
Print["QUESTIONS:"];
Print["- Does G have zeros at all for ε > 0?"];
Print["- Do zeros approach RH zeros as ε → 0?"];
Print["- Or does regularization eliminate all zeros?"];
Print["- What happens in the limit ε → 0?"];
Print[""];
Print["If G is zero-free for ε > 0, that's HUGE!"];
Print["We have analytic function converging to L_M(s)"];
Print["Zero-free → use logarithmic methods"];
Print[""];
Print["Exploration complete!");
