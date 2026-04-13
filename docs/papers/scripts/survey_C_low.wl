<< Orbit`

(* Generate C(alpha) data for alpha in [1.05, 1.45], the region
   near the phase transition C(1)=0 where kinks are most visible *)

nTerms = 200;

estimateC[seq_List] := Module[{len = Length[seq], estimates},
  estimates = Table[
    N[seq[[len - i]] * Sqrt[Pi * (len - i)] / 4^(len - i), 30],
    {i, 0, 9}
  ];
  Mean[estimates]
]

(* Rational slopes p/q with 1 < p/q < 3/2, q <= 8 *)
slopes = {};
Do[
  Do[
    If[GCD[pp, qq] == 1 && pp/qq > 1 && pp/qq < 3/2,
      AppendTo[slopes, {pp, qq, pp/qq}]
    ],
    {pp, qq + 1, 2*qq - 1}
  ],
  {qq, 1, 8}
];

slopes = SortBy[DeleteDuplicatesBy[slopes, Last], Last];

Print["Computing C for ", Length[slopes], " slopes in (1, 3/2)..."];

results = {};
Do[
  {pp, qq, alphaVal} = entry;
  seq = Table[BeattyBallotCount[qq/pp, {nn, nn}], {nn, 1, nTerms}];
  cEst = estimateC[seq];
  AppendTo[results, {N[alphaVal, 12], cEst, pp, qq}];
  Print["  ", pp, "/", qq, " = ", N[alphaVal, 5], "  C = ", cEst];,
  {entry, slopes}
];

outFile = FileNameJoin[{DirectoryName[$InputFileName], "survey_C_low.tsv"}];
Export[outFile,
  Prepend[
    {ToString[NumberForm[#[[1]], 12]], ToString[NumberForm[#[[2]], 15]], #[[3]], #[[4]]} & /@ results,
    {"alpha", "C", "p", "q"}
  ],
  "TSV"
];
Print["\nSaved to ", outFile];
