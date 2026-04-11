<< Orbit`

(* Survey of C(alpha) for rational slopes alpha = p/q
   a(n) = BeattyBallotCount[q/p, {n,n}] ~ cAsymp * 4^n / sqrt(pi*n)
   So cAsymp = lim a(n) * sqrt(pi*n) / 4^n

   We compute this for many rational alpha and plot cAsymp vs alpha.
*)

nTerms = 200;  (* enough terms for ~5 digit estimate *)

(* Estimate C from last 10 terms via Richardson-like averaging *)
estimateCRichardson[seq_List] := Module[{len = Length[seq], estimates, idx},
  estimates = Table[
    idx = len - i;
    N[seq[[idx]] * Sqrt[Pi * idx] / 4^idx, 30],
    {i, 0, 9}
  ];
  Mean[estimates]
]

(* Generate slopes: focus on integers 2..6 and rationals with q <= 4 *)
slopeList = {};

(* Integer slopes 2..6 *)
Do[AppendTo[slopeList, {kk, 1, kk}], {kk, 2, 6}];

(* Rational slopes p/q with alpha >= 1, gcd(p,q)=1, q = 2..4 *)
Do[
  Do[
    If[GCD[pp, qq] == 1 && pp/qq >= 1,
      AppendTo[slopeList, {pp, qq, pp/qq}]
    ],
    {pp, qq + 1, 6*qq}  (* up to slope 6 *)
  ],
  {qq, 2, 4}
];

(* Sort by slope value *)
slopeList = SortBy[slopeList, Last];

Print["Computing C(alpha) for ", Length[slopeList], " rational slopes, ", nTerms, " terms each..."];

results = {};
Do[
  {pp, qq, alphaVal} = entry;
  betaArg = qq/pp;  (* BeattyBallotCount argument *)

  Print["  alpha = ", pp, "/", qq, " = ", N[alphaVal, 5], " ..."];

  seq = Table[BeattyBallotCount[betaArg, {nn, nn}], {nn, 1, nTerms}];
  cEst = estimateCRichardson[seq];

  AppendTo[results, {N[alphaVal, 15], cEst, pp, qq}];
  Print["    C = ", cEst];,

  {entry, slopeList}
];

(* Output as table *)
Print["\n=== RESULTS ==="];
Print["alpha\tC(alpha)\tp/q"];
Do[
  {aV, cV, pV, qV} = r;
  Print[NumberForm[aV, 6], "\t", NumberForm[cV, 10], "\t", pV, "/", qV];,
  {r, results}
];

(* Export for plotting *)
outFile = FileNameJoin[{DirectoryName[$InputFileName], "survey_C_alpha.tsv"}];
Export[outFile,
  Prepend[
    {ToString[NumberForm[#[[1]], 12]], ToString[NumberForm[#[[2]], 15]], #[[3]], #[[4]]} & /@ results,
    {"alpha", "C", "p", "q"}
  ],
  "TSV"
];
Print["\nSaved to ", outFile];
