#!/usr/bin/env wolframscript
(*
  Direct Test: L_M(s) functional equation

  Hypothesis: γ(s) L_M(s) = γ(1-s) L_M(1-s)
  where γ(s) = π^(-s/2) Γ(s/2)
*)

Print["================================================"];
Print["Testing Functional Equation for L_M(s)"];
Print["================================================\n"];

(* Closed form *)
TailZeta[s_?NumericQ, m_Integer] := Zeta[s] - Sum[k^(-s), {k, 1, m-1}];

ComputeLM[s_?NumericQ, nMax_Integer : 200] := Module[{},
  N[Zeta[s] * (Zeta[s] - 1) - Sum[TailZeta[s, j]/j^s, {j, 2, nMax}], 30]
];

(* Gamma factor (same as for zeta!) *)
GammaFactor[s_?NumericQ] := Pi^(-s/2) * Gamma[s/2];

(* Test points away from critical line *)
testPoints = {
  1.5 + 5.0*I,
  1.3 + 10.0*I,
  2.0 + 14.135*I,
  1.7 + 20.0*I,
  1.2 + 25.0*I
};

Print["Testing γ(s) L_M(s) = γ(1-s) L_M(1-s)\n"];
Print["where γ(s) = π^(-s/2) Γ(s/2)\n"];
Print[StringRepeat["-", 80]];
Print["s\t\t\t|ratio|\t\t|diff|\t\tMatch?"];
Print[StringRepeat["-", 80]];

results = Table[
  Module[{s, s1, Ls, Ls1, gammaS, gammaS1, left, right, ratio, diff, match},
    s = pt;
    s1 = 1 - s;

    (* Compute L_M *)
    Ls = ComputeLM[s, 200];
    Ls1 = ComputeLM[s1, 200];

    (* Gamma factors *)
    gammaS = GammaFactor[s];
    gammaS1 = GammaFactor[s1];

    (* Test equation *)
    left = gammaS * Ls;
    right = gammaS1 * Ls1;

    ratio = left / right;
    diff = Abs[left - right];

    match = (Abs[Abs[ratio] - 1] < 0.01) && (diff < 0.01);

    Print[N[s, 5], "\t", N[Abs[ratio], 8], "\t", N[diff, 8], "\t",
          If[match, "✓", "✗"]];

    {s, Abs[ratio], diff, match}
  ],
  {pt, testPoints}
];

Print["\n"];
Print["Statistics:"];
Print["  Matches: ", Count[results, {_, _, _, True}], " / ", Length[results]];
Print["  Mean |ratio|: ", N[Mean[results[[All, 2]]], 6]];
Print["  Mean |diff|: ", N[Mean[results[[All, 3]]], 6]];

(* If all match, test on critical line too *)
If[AllTrue[results, Last],
  Print["\n✓ All points match! Testing on critical line...\n"];

  criticalTests = Table[
    Module[{s, s1, Ls, Ls1, gammaS, gammaS1, left, right, diff},
      s = 0.5 + I*t;
      s1 = 0.5 - I*t;

      Ls = ComputeLM[s, 200];
      Ls1 = ComputeLM[s1, 200];

      gammaS = GammaFactor[s];
      gammaS1 = GammaFactor[s1];

      left = gammaS * Ls;
      right = gammaS1 * Ls1;

      diff = Abs[left - right];

      Print["t = ", t, "\t|γ(s)L_M(s) - γ(1-s)L_M(1-s)| = ", N[diff, 8]];

      {t, diff}
    ],
    {t, {5, 10, 14.135, 20, 25, 30}}
  ];

  Print["\nCritical line test:"];
  Print["  Max |diff|: ", N[Max[criticalTests[[All, 2]]], 8]];
  Print["  All < 10^-10? ", AllTrue[criticalTests[[All, 2]], # < 10^(-10) &]];
,
  Print["\n✗ Some points don't match - hypothesis FALSE"];
  Print["Listing failures:\n"];
  failures = Select[results, !Last[#] &];
  Do[
    Print["  s = ", N[f[[1]], 5], " : ratio = ", N[f[[2]], 6],
          ", diff = ", N[f[[3]], 6]],
    {f, failures}
  ];
];

Print["\n================================================"];
Print["CONCLUSION"];
Print["================================================\n"];

If[AllTrue[results, Last],
  Print["✓✓✓ FUNCTIONAL EQUATION VERIFIED (numerically)"];
  Print["\n    L_M(s) satisfies:"];
  Print["    γ(s) L_M(s) = γ(1-s) L_M(1-s)"];
  Print["\n    where γ(s) = π^(-s/2) Γ(s/2)"];
  Print["\n    This is the SAME factor as for Riemann zeta!"];
  Print["\n    Status: NUMERICAL CONFIRMATION (not proven)"];
,
  Print["✗ Functional equation does NOT hold with this factor"];
  Print["  Need to search for different γ(s)"];
];

Print["\nTest complete!"];
