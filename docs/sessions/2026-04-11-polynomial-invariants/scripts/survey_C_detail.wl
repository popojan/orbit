<< Orbit`

(* Dense survey of C(alpha) around k=2 and k=3 to see the local shape *)

nTerms = 200;

estimateCRichardson[seq_List] := Module[{len = Length[seq], estimates, idx},
  estimates = Table[
    idx = len - i;
    N[seq[[idx]] * Sqrt[Pi * idx] / 4^idx, 30],
    {i, 0, 9}
  ];
  Mean[estimates]
]

(* Dense rational points around k=2: alpha from 1.5 to 2.5, step ~0.05 *)
(* Use fractions p/q with q up to 20 *)
slopeList = {};
Do[
  Do[
    If[GCD[pp, qq] == 1 && pp/qq >= 3/2 && pp/qq <= 5/2,
      AppendTo[slopeList, {pp, qq, pp/qq}]
    ],
    {pp, qq + 1, 3*qq}
  ],
  {qq, 1, 12}
];

(* Also around k=3: alpha from 2.5 to 3.5 *)
Do[
  Do[
    If[GCD[pp, qq] == 1 && pp/qq > 5/2 && pp/qq <= 7/2,
      AppendTo[slopeList, {pp, qq, pp/qq}]
    ],
    {pp, 2*qq + 1, 4*qq}
  ],
  {qq, 1, 12}
];

slopeList = DeleteDuplicatesBy[SortBy[slopeList, Last], Last];

Print["Dense survey: ", Length[slopeList], " slopes around k=2 and k=3"];

results = {};
Do[
  {pp, qq, alphaVal} = entry;
  betaArg = qq/pp;

  seq = Table[BeattyBallotCount[betaArg, {nn, nn}], {nn, 1, nTerms}];
  cEst = estimateCRichardson[seq];

  AppendTo[results, {N[alphaVal, 15], cEst, pp, qq}];
  Print["  ", pp, "/", qq, " = ", N[alphaVal, 6], "  C = ", cEst];,

  {entry, slopeList}
];

(* Export *)
outFile = FileNameJoin[{DirectoryName[$InputFileName], "survey_C_detail.tsv"}];
Export[outFile,
  Prepend[
    {ToString[NumberForm[#[[1]], 12]], ToString[NumberForm[#[[2]], 15]], #[[3]], #[[4]]} & /@ results,
    {"alpha", "C", "p", "q"}
  ],
  "TSV"
];
Print["\nSaved ", Length[results], " points to ", outFile];
