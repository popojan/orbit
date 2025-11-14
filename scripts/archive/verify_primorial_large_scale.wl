(* Large-scale primorial verification script *)

(* Direct formula - slow for large m *)
PrimorialRaw[m_Integer] := Module[{h, sum},
  h = Floor[(m - 1)/2];
  sum = 1/2 * Sum[(-1)^k * (k!)/(2*k + 1), {k, h}];
  sum
];

(* Iterative sieve formulation - fast for large m *)
RecurseState[{n_, a_, b_}] := {n + 1, b, b + (a - b)*(n + 1/(3 + 2*n))};

SieveState[m_Integer] := Module[{h, state},
  h = Floor[(m - 1)/2];
  state = {0, 0, 1};
  Do[state = RecurseState[state], {h}];
  state
];

PrimorialFromState[{n_, a_, b_}] := 2 * Denominator[-1 + b];

Primorial0[m_Integer] := If[m == 2, 2, PrimorialFromState[SieveState[m]]];

StandardPrimorial[m_Integer] := Times @@ Prime[Range[PrimePi[m]]];

(* Main verification *)
Print["=== LARGE-SCALE PRIMORIAL VERIFICATION ==="];
Print["Using efficient iterative sieve method"];
Print[];

testPoints = {100, 1000, 10000, 50000, 100000, 500000, 1000000};

Print["m\t\tπ(m)\tTime(s)\tDigits\tVerified"];
Print[StringRepeat["=", 65]];

Do[
  Module[{t, computed, standard, digits, pi, verified},
    pi = PrimePi[m];

    (* Time the sieve computation *)
    {t, computed} = AbsoluteTiming[Primorial0[m]];
    digits = IntegerLength[computed];

    (* Verify correctness for selected points *)
    verified = If[MemberQ[{100, 10000, 100000, 1000000}, m],
      {t2, standard} = AbsoluteTiming[StandardPrimorial[m]];
      If[computed == standard,
        "✓ (" <> ToString[N[t2, 3]] <> "s)",
        "✗ FAIL"
      ],
      "skip"
    ];

    Print[m, "\t\t", pi, "\t", N[t, 3], "\t", digits, "\t", verified];
  ],
  {m, testPoints}
];

Print[];
Print["=== FINAL VERIFICATION ==="];
Print["Testing m=1,000,000 with full comparison..."];

{tSieve, resultSieve} = AbsoluteTiming[Primorial0[1000000]];
{tStd, resultStd} = AbsoluteTiming[StandardPrimorial[1000000]];

Print["Sieve method:     ", N[tSieve, 4], "s -> ", IntegerLength[resultSieve], " digits"];
Print["Standard method:  ", N[tStd, 4], "s -> ", IntegerLength[resultStd], " digits"];
Print["Results match:    ", resultSieve == resultStd];
Print["Speedup:          ", N[tStd/tSieve, 3], "x"];
Print[];

If[resultSieve == resultStd,
  Print["SUCCESS: Formula verified for m=1,000,000"],
  Print["FAILURE: Formula fails at m=1,000,000"]
];
