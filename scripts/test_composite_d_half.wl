#!/usr/bin/env wolframscript
(* Test d[τ/2] = 2 for composite D ≡ 3 (mod 4) *)

(* CF auxiliary sequence *)
CFAuxSequence[D_Integer] := Module[{a0, m, d, a, seq, k},
  a0 = Floor[Sqrt[D]];
  m = 0; d = 1; a = a0;
  seq = {{0, m, d, a}};
  k = 0;

  While[True,
    k++;
    m = d*a - m;
    d = (D - m^2)/d;
    a = Floor[(a0 + m)/d];
    AppendTo[seq, {k, m, d, a}];

    (* Period detected when we return to start *)
    If[a == 2*a0 && k > 1, Break[]];

    (* Safety: max 200 iterations *)
    If[k > 200, Break[]];
  ];

  {seq, k}  (* Return full sequence and period length *)
];

(* Test composite numbers D ≡ 3 (mod 4) *)
TestCompositeD[] := Module[{
  composites, results, D, seq, tau, half, dHalf, mHalf, aHalf,
  dHalfMinus1, identity, a0
},
  (* Generate composite D ≡ 3 (mod 4), D < 200 *)
  composites = Select[
    Range[15, 200, 4],  (* D ≡ 3 (mod 4) means D = 4k+3 *)
    !PrimeQ[#] &
  ];

  Print["Testing composite D ≡ 3 (mod 4) for d[τ/2] = 2\n"];
  Print[StringForm["Found `` composite numbers to test", Length[composites]]];
  Print[""];

  results = Table[
    {seq, tau} = CFAuxSequence[D];
    a0 = Floor[Sqrt[D]];

    (* Check if period is even *)
    If[EvenQ[tau],
      half = tau/2;

      (* Extract values at τ/2 *)
      mHalf = seq[[half + 1, 2]];  (* +1 because seq starts at k=0 *)
      dHalf = seq[[half + 1, 3]];
      aHalf = seq[[half + 1, 4]];

      (* Extract d[τ/2 - 1] *)
      dHalfMinus1 = seq[[half, 3]];

      (* Check identity D - m² = 2·d[τ/2-1] *)
      identity = (D - mHalf^2) == 2*dHalfMinus1;

      {
        D,
        tau,
        dHalf,
        mHalf,
        aHalf,
        mHalf == aHalf,  (* m = a invariant? *)
        dHalfMinus1,
        D - mHalf^2,
        2*dHalfMinus1,
        identity
      }
      ,
      (* Period is odd *)
      {D, tau, "ODD", "-", "-", False, "-", "-", "-", False}
    ],
    {D, composites}
  ];

  results
];

(* Run test *)
results = TestCompositeD[];

(* Analyze results *)
Print["\nRESULTS:\n"];
Print["D    τ    d[τ/2]  m[τ/2]  a[τ/2]  m=a?  d[τ/2-1]  D-m²  2d    Identity?"];
Print[StringRepeat["-", 85]];

evenPeriod = Select[results, #[[2]] =!= "ODD" &];
oddPeriod = Select[results, #[[2]] === "ODD" &];

Do[
  Print[StringForm["``  ``  ``  ``  ``  ``  ``  ``  ``  ``",
    PaddedForm[r[[1]], {4, 0}],      (* D *)
    PaddedForm[r[[2]], {4, 0}],      (* τ *)
    PaddedForm[r[[3]], {4, 0}],      (* d[τ/2] *)
    PaddedForm[r[[4]], {4, 0}],      (* m[τ/2] *)
    PaddedForm[r[[5]], {4, 0}],      (* a[τ/2] *)
    If[r[[6]], "✓", "✗"],            (* m=a? *)
    PaddedForm[r[[7]], {4, 0}],      (* d[τ/2-1] *)
    PaddedForm[r[[8]], {6, 0}],      (* D - m² *)
    PaddedForm[r[[9]], {6, 0}],      (* 2d *)
    If[r[[10]], "✓", "✗"]            (* Identity? *)
  ]],
  {r, evenPeriod}
];

If[Length[oddPeriod] > 0,
  Print["\nOdd period cases (skipped):"];
  Do[
    Print[StringForm["D = ``, τ = ``", r[[1]], r[[2]]]],
    {r, oddPeriod}
  ];
];

(* Statistics *)
Print["\n" <> StringRepeat["=", 85]];
Print["STATISTICS:\n"];

dHalfIs2 = Count[evenPeriod, {_, _, 2, _, _, _, _, _, _, _}];
mEqualsA = Count[evenPeriod, {_, _, _, _, _, True, _, _, _, _}];
identityHolds = Count[evenPeriod, {_, _, _, _, _, _, _, _, _, True}];

Print[StringForm["Total composite D tested: ``", Length[results]]];
Print[StringForm["Even period: ``", Length[evenPeriod]]];
Print[StringForm["Odd period: ``", Length[oddPeriod]]];
Print[""];
Print[StringForm["d[τ/2] = 2: ``/`` (``%)",
  dHalfIs2, Length[evenPeriod],
  If[Length[evenPeriod] > 0, N[100.0 * dHalfIs2/Length[evenPeriod], 4], 0]
]];
Print[StringForm["m[τ/2] = a[τ/2]: ``/`` (``%)",
  mEqualsA, Length[evenPeriod],
  If[Length[evenPeriod] > 0, N[100.0 * mEqualsA/Length[evenPeriod], 4], 0]
]];
Print[StringForm["D - m² = 2·d[τ/2-1]: ``/`` (``%)",
  identityHolds, Length[evenPeriod],
  If[Length[evenPeriod] > 0, N[100.0 * identityHolds/Length[evenPeriod], 4], 0]
]];

(* Find counterexamples *)
Print["\n" <> StringRepeat["=", 85]];
counterD2 = Select[evenPeriod, #[[3]] != 2 &];
counterMA = Select[evenPeriod, !#[[6]] &];
counterIdentity = Select[evenPeriod, !#[[10]] &];

If[Length[counterD2] > 0,
  Print["COUNTEREXAMPLES for d[τ/2] = 2:"];
  Do[
    Print[StringForm["  D = ``, τ = ``, d[τ/2] = ``", r[[1]], r[[2]], r[[3]]]],
    {r, counterD2}
  ];
  ,
  Print["✓ NO counterexamples for d[τ/2] = 2 (pattern holds!)"];
];

If[Length[counterMA] > 0,
  Print["\nCOUNTEREXAMPLES for m = a:"];
  Do[
    Print[StringForm["  D = ``, m[τ/2] = ``, a[τ/2] = ``", r[[1]], r[[4]], r[[5]]]],
    {r, counterMA}
  ];
  ,
  Print["✓ NO counterexamples for m = a (pattern holds!)"];
];

Print["\nDONE"];
