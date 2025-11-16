#!/usr/bin/env wolframscript
(*
  Verify algebra of closed form for L_M(s)

  Test whether:
  L_M(s) = ζ(s)[ζ(s) - 1] - Σ_{j=2}^∞ H_{j-1}(s)/j^s

  matches direct computation from definition.
*)

Print["================================================"];
Print["Verifying Closed Form Algebra"];
Print["================================================\n"];

(* Direct computation from definition *)
M[n_] := Floor[(DivisorSigma[0, n] - 1)/2];

DirectLM[s_?NumericQ, nMax_Integer : 100] :=
  N[Sum[M[n]/n^s, {n, 1, nMax}], 30];

(* Closed form *)
TailZeta[s_?NumericQ, m_Integer] := Zeta[s] - Sum[k^(-s), {k, 1, m-1}];

ClosedFormLM[s_?NumericQ, nMax_Integer : 200] :=
  N[Zeta[s] * (Zeta[s] - 1) - Sum[TailZeta[s, j]/j^s, {j, 2, nMax}], 30];

(* Alternative form via change of order *)
(* C(s) = Σ_{k=1}^∞ k^(-s) [ζ(s) - H_k(s)] *)
AlternativeLM[s_?NumericQ, nMax_Integer : 100] := Module[{Hk},
  Hk[k_] := Sum[j^(-s), {j, 1, k}];
  N[Sum[k^(-s) * (Zeta[s] - Hk[k]), {k, 1, nMax}], 30]
];

(* Test points *)
testPoints = {2.0, 2.5, 3.0, 1.5 + 2.0*I};

Print["Testing at multiple s values:\n"];
Print[StringRepeat["-", 80]];
Print["s\t\tDirect\t\tClosed\t\tAlt\t\tMatch?"];
Print[StringRepeat["-", 80]];

results = Table[
  Module[{s, direct, closed, alt, match1, match2},
    s = pt;

    direct = DirectLM[s, 100];
    closed = ClosedFormLM[s, 200];
    alt = AlternativeLM[s, 100];

    match1 = Abs[direct - closed] < 10^(-10);
    match2 = Abs[direct - alt] < 10^(-10);

    Print[N[s, 4], "\t", N[direct, 10], "\t", N[closed, 10], "\t",
          N[alt, 10], "\t", If[match1 && match2, "✓", "✗"]];

    {s, direct, closed, alt, match1, match2}
  ],
  {pt, testPoints}
];

Print["\n"];
Print["Summary:"];
Print["  Direct vs Closed: ",
      If[AllTrue[results, #[[5]] &], "ALL MATCH ✓", "MISMATCH ✗"]];
Print["  Direct vs Alternative: ",
      If[AllTrue[results, #[[6]] &], "ALL MATCH ✓", "MISMATCH ✗"]];

(* Now verify the algebra claim *)
Print["\n================================================"];
Print["Testing Algebra Transformation"];
Print["================================================\n"];

Print["Claim: C(s) = ζ(s)² - Σ_{k=1}^∞ k^(-s) H_k(s)\n"];

TestC[s_?NumericQ, nMax_Integer : 100] := Module[{C1, C2, Hk},
  (* Original definition *)
  TailZeta[s_, m_] := Zeta[s] - Sum[k^(-s), {k, 1, m-1}];
  C1 = Sum[TailZeta[s, j]/j^s, {j, 2, nMax}];

  (* Alternative via change of order *)
  Hk[k_] := Sum[j^(-s), {j, 1, k}];
  C2 = Zeta[s]^2 - Sum[k^(-s) * Hk[k], {k, 1, nMax}];

  Print["s = ", N[s, 5]];
  Print["  C (original):    ", N[C1, 15]];
  Print["  C (transformed): ", N[C2, 15]];
  Print["  |difference|:    ", N[Abs[C1 - C2], 10]];
  Print["  Match? ", If[Abs[C1 - C2] < 10^(-10), "✓", "✗"]];
  Print[""];

  Abs[C1 - C2] < 10^(-10)
];

algebraTests = Table[TestC[s, 100], {s, {2.0, 2.5, 3.0, 1.5 + 2.0*I}}];

Print["\nAlgebra transformation: ",
      If[AllTrue[algebraTests, # &], "VERIFIED ✓", "FAILED ✗"]];

Print["\n================================================"];
Print["Verification Complete"];
Print["================================================"];
