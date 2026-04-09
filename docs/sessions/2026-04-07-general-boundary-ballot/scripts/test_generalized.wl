(* Quick test of GeneralizedEgyptSqrt *)

<< Orbit`

Print["=== Integer d (should match SqrtInterval) ==="];
Print[""];

Do[
  Module[{gen, classic, sd = N[Sqrt[d], 30]},
    gen = GeneralizedEgyptSqrt[d, 3];
    classic = SqrtInterval[d, 3 + 1];  (* +1 because different k convention *)
    Print["d=", d];
    Print["  Generalized: ", gen];
    Print["  Contains sqrt(d): ", Min[gen] <= sd <= Max[gen]];
    Print["  Width: ", ScientificForm[Max[gen] - Min[gen], 4]];
    Print["  Dedekind: lower*upper = ", NumberForm[N[Min[gen] Max[gen]], 12],
      " (should be ", d, ")"];
    Print[""];
  ],
{d, {2, 5, 13}}];

Print["=== Irrational d ==="];
Print[""];

Do[
  Module[{gen, sd = N[Sqrt[d], 50]},
    gen = GeneralizedEgyptSqrt[d, k];
    Print[dName, ", k=", k, ":"];
    Print["  Interval: ", gen];
    Print["  Contains sqrt(d): ", Min[gen] <= sd <= Max[gen]];
    Print["  Width: ", ScientificForm[Max[gen] - Min[gen], 4]];
    Print["  Dedekind: lower*upper = ",
      NumberForm[N[Min[gen] Max[gen], 30], 15],
      " (should be ", NumberForm[N[d, 15], 12], ")"];
    Print["  Error: ", ScientificForm[Abs[(Min[gen] + Max[gen])/2 - sd], 4]];
    Print[""];
  ],
{d, {Pi, E, GoldenRatio^2, Sqrt[2]}},
{dName, {"Pi", "E", "GoldenRatio^2", "Sqrt[2]"}},
{k, {2, 4, 6}}];

Print["=== Convergence table for d=Pi ==="];
Print[""];
Module[{sd = N[Sqrt[Pi], 50]},
  Do[
    Module[{gen = GeneralizedEgyptSqrt[Pi, k],
      mid, err},
      mid = (Min[gen] + Max[gen])/2;
      err = Abs[mid - sd];
      Print["k=", k, "  width=", ScientificForm[Max[gen]-Min[gen], 3],
        "  digits~", If[err > 0, Floor[-Log10[err]], ">50"]]
    ],
  {k, 1, 10}]
];

Print[""];
Print["Done."];
