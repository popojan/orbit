(* Orbit Sigmoid Analysis
   Computes gap ratio, RMSE, and max error for prime invariants *)

sigma[x_] := (1 - x)/(1 + x);
kappa[x_] := 1 - x;

orbitEnumerate[p_, maxDenom_:10000] := Module[{orb, queue, new},
  orb = {1/(1 + p)};
  queue = orb;
  While[queue =!= {},
    new = {};
    Do[
      Do[
        nx = f[x];
        If[0 < nx < 1 && Denominator[nx] <= maxDenom && !MemberQ[orb, nx],
          AppendTo[new, nx];
          AppendTo[orb, nx]
        ],
        {f, {sigma, kappa}}
      ],
      {x, queue}
    ];
    queue = new
  ];
  Sort[orb]
];

gapRatio[orb_] := Module[{logits, gaps},
  If[Length[orb] < 3, Return[Infinity]];
  logits = Log[N[#]/(1 - N[#])] & /@ orb;
  gaps = Differences[logits];
  Max[gaps]/Min[gaps]
];

(* PWL interpolation vs true sigmoid *)
sigmoidRMSE[orb_] := Module[{logits, testPts, errors},
  logits = Log[N[#]/(1 - N[#])] & /@ orb;
  testPts = Range[-6, 6, 0.012];
  errors = Table[
    Module[{trueSig, pwlSig, idx, t},
      trueSig = 1/(1 + Exp[-x]);
      idx = LengthWhile[logits, # < x &] + 1;
      If[idx <= 1,
        pwlSig = orb[[1]] // N,
        If[idx > Length[orb],
          pwlSig = orb[[-1]] // N,
          t = (x - logits[[idx-1]])/(logits[[idx]] - logits[[idx-1]]);
          pwlSig = N[orb[[idx-1]]] + t * (N[orb[[idx]]] - N[orb[[idx-1]]])
        ]
      ];
      (trueSig - pwlSig)^2
    ],
    {x, testPts}
  ];
  Sqrt[Mean[errors]]
];

sigmoidMaxError[orb_] := Module[{logits, testPts},
  logits = Log[N[#]/(1 - N[#])] & /@ orb;
  testPts = Range[-6, 6, 0.01];
  Max[Table[
    Module[{trueSig, pwlSig, idx, t},
      trueSig = 1/(1 + Exp[-x]);
      idx = LengthWhile[logits, # < x &] + 1;
      If[idx <= 1,
        pwlSig = orb[[1]] // N,
        If[idx > Length[orb],
          pwlSig = orb[[-1]] // N,
          t = (x - logits[[idx-1]])/(logits[[idx]] - logits[[idx-1]]);
          pwlSig = N[orb[[idx-1]]] + t * (N[orb[[idx]]] - N[orb[[idx-1]]])
        ]
      ];
      Abs[trueSig - pwlSig]
    ],
    {x, testPts}
  ]]
];

analyzePrime[p_, maxDenom_:10000] := Module[{orb, gr, rmse, maxErr},
  orb = orbitEnumerate[p, maxDenom];
  gr = gapRatio[orb];
  rmse = sigmoidRMSE[orb];
  maxErr = sigmoidMaxError[orb];
  <|
    "p" -> p,
    "p-1" -> p - 1,
    "factors" -> FactorInteger[p - 1],
    "nPoints" -> Length[orb],
    "gapRatio" -> gr,
    "rmse" -> rmse,
    "maxError" -> maxErr
  |>
];

(* Example usage *)
If[$ScriptCommandLine =!= {},
  Print["Analyzing prime invariants for orbit sigmoid..."];
  Print[""];
  Print["p | p-1 | factors | n | gap ratio | RMSE | max err"];
  Print["----------------------------------------------------------"];
  Do[
    result = analyzePrime[p];
    Print[
      p, " | ", p-1, " | ", result["factors"], " | ",
      result["nPoints"], " | ",
      NumberForm[result["gapRatio"], {4, 2}], " | ",
      NumberForm[result["rmse"], {4, 4}], " | ",
      NumberForm[result["maxError"], {4, 4}]
    ],
    {p, {7, 13, 19, 37, 53, 73, 109}}
  ];
];
