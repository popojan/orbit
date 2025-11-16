#!/usr/bin/env wolframscript
(* Quick test: Direct finite sum on critical line *)
(* NOT analytic continuation - just truncated approximation for comparison *)

Print["=== Direct Finite Sum Test ===\n"];
Print["WARNING: This is NOT analytic continuation!"];
Print["Just truncated approximation for comparison.\n"];

M[n_Integer] := Module[{divs},
  divs = Select[Divisors[n], 2 <= # <= Sqrt[n] &];
  Length[divs]
];

(* Direct finite sum *)
LMDirect[s_, nmax_] := Sum[M[n]/n^s, {n, 2, nmax}];

(* Closed form (reference for Re(s) > 1) *)
CApprox[s_, jmax_:500] := Sum[HarmonicNumber[j-1, s]/j^s, {j, 2, jmax}];
LMClosed[s_, jmax_:500] := Zeta[s]*(Zeta[s] - 1) - CApprox[s, jmax];

Print["Test points:"];
Print[StringRepeat["=", 70], "\n"];

testPoints = {
  {2, "Re(s)=2 (has reference)"},
  {1/2 + 5*I, "Critical line: s=1/2+5i"},
  {1/2 + 10*I, "Critical line: s=1/2+10i"}
};

Do[
  {s0, desc} = test;
  Print[desc];
  Print[StringRepeat["-", 70]];

  (* Reference if available *)
  If[Re[s0] > 1,
    refValue = LMClosed[s0, 500];
    Print["Reference (closed form): ", N[refValue, 8]];
  ,
    refValue = Null;
  ];

  (* Test different nmax *)
  Print["Direct sum convergence:"];
  results = Table[
    val = LMDirect[s0, nmax];
    {nmax, val},
    {nmax, {100, 200, 500, 1000}}
  ];

  Do[
    {nmax, val} = results[[i]];
    If[refValue =!= Null,
      err = Abs[(val - refValue)/refValue];
      Print[StringForm["  nmax=%:  L_M ≈ %,  RelErr = %%",
        nmax, N[val, 8], N[err*100, 3]
      ]];
    ,
      Print[StringForm["  nmax=%:  L_M ≈ %",
        nmax, N[val, 8]
      ]];
    ];
  , {i, 1, Length[results]}];

  (* Convergence check *)
  If[Length[results] >= 2,
    lastTwo = results[[-2;;]];
    diff = Abs[lastTwo[[2,2]] - lastTwo[[1,2]]];
    relChange = diff / Abs[lastTwo[[2,2]]];
    Print[StringForm["  Last change (500→1000): %% relative",
      N[relChange*100, 3]
    ]];
  ];

  Print[""];
, {test, testPoints}];

Print[StringRepeat["=", 70]];
Print["Interpretation:"];
Print["- If values converge on critical line → truncation is stable"];
Print["- But remember: this is NOT analytic continuation!"];
Print["- Just an approximation (like truncating any divergent series)"];
Print[StringRepeat["=", 70]];
