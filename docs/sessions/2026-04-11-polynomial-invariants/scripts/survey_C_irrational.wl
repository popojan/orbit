<< Orbit`

(* C(alpha) for irrational slopes in range [1.4, 3.5] *)

nTerms = 200;

estimateCRichardson[seq_List] := Module[{len = Length[seq], estimates, idx},
  estimates = Table[
    idx = len - i;
    N[seq[[idx]] * Sqrt[Pi * idx] / 4^idx, 30],
    {i, 0, 9}
  ];
  Mean[estimates]
]

irrationals = {
  {Sqrt[2], "sqrt(2)"},          (* 1.4142 *)
  {Pi - 1, "Pi-1"},              (* 2.1416 *)
  {E - 1, "e-1"},                (* 1.7183 *)
  {GoldenRatio, "phi"},          (* 1.6180 *)
  {Sqrt[3], "sqrt(3)"},          (* 1.7321 *)
  {Sqrt[5], "sqrt(5)"},          (* 2.2361 *)
  {Sqrt[6], "sqrt(6)"},          (* 2.4495 *)
  {Sqrt[7], "sqrt(7)"},          (* 2.6458 *)
  {Sqrt[8], "sqrt(8)"},          (* 2.8284 *)
  {Sqrt[10], "sqrt(10)"},        (* 3.1623 *)
  {Pi, "Pi"},                    (* 3.1416 *)
  {E, "e"},                      (* 2.7183 *)
  {1 + Sqrt[2], "1+sqrt(2)"},    (* 2.4142 *)
  {1 + GoldenRatio, "1+phi"}     (* 2.6180 *)
};

Print["Computing C(alpha) for ", Length[irrationals], " irrational slopes..."];

results = {};
Do[
  {alphaVal, label} = entry;
  betaArg = 1/alphaVal;

  Print["  ", label, " = ", N[alphaVal, 10], " ..."];

  seq = Table[BeattyBallotCount[betaArg, {nn, nn}], {nn, 1, nTerms}];
  cEst = estimateCRichardson[seq];

  AppendTo[results, {N[alphaVal, 15], cEst, label}];
  Print["    C = ", cEst];,

  {entry, irrationals}
];

outFile = FileNameJoin[{DirectoryName[$InputFileName], "survey_C_irrational.tsv"}];
Export[outFile,
  Prepend[
    {ToString[NumberForm[#[[1]], 12]], ToString[NumberForm[#[[2]], 15]], #[[3]]} & /@ results,
    {"alpha", "C", "label"}
  ],
  "TSV"
];
Print["\nSaved to ", outFile];
