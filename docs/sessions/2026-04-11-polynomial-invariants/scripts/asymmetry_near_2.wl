<< Orbit`

(* C(2-1/n) vs C(2+1/n) for n = 2, 3, ..., 30 *)
(* Rise sequences and transfer matrix structure *)

nTerms = 200;

estimateC[seq_List] := Module[{len = Length[seq], estimates, idx},
  estimates = Table[
    idx = len - i;
    N[seq[[idx]] * Sqrt[Pi * idx] / 4^idx, 30],
    {i, 0, 9}
  ];
  Mean[estimates]
]

(* Rise sequence for rational slope p/q *)
riseSeq[pp_, qq_, len_] := Table[
  Floor[pp * x / qq] - Floor[pp * (x - 1) / qq], {x, 1, len}]

Print["=== Rise sequences near k=2 ==="];
Print[""];
Do[
  alphaBelow = (2 nn - 1) / nn;    (* 2 - 1/n *)
  alphaAbove = (2 nn + 1) / nn;    (* 2 + 1/n *)

  risesB = riseSeq[2 nn - 1, nn, nn];
  risesA = riseSeq[2 nn + 1, nn, nn];

  Print["n=", nn, ":"];
  Print["  2-1/", nn, " = ", N[alphaBelow, 6],
    "  rises(one period)=", risesB,
    "  min=", Min[risesB], " max=", Max[risesB]];
  Print["  2+1/", nn, " = ", N[alphaAbove, 6],
    "  rises(one period)=", risesA,
    "  min=", Min[risesA], " max=", Max[risesA]];
  Print[""];,
  {nn, 2, 6}
];

(* Now compute C for 2 +/- 1/n systematically *)
Print["=== C(2 +/- 1/n) ==="];
Print["n\tC(2-1/n)\tC(2+1/n)\tC(2)-C(below)\tC(above)-C(2)"];

cAt2 = estimateC[Table[BeattyBallotCount[1/2, {mm, mm}], {mm, 1, nTerms}]];
Print["C(2) = ", cAt2];
Print[""];

results = {};
Do[
  alphaBelow = (2 nn - 1) / nn;
  alphaAbove = (2 nn + 1) / nn;

  seqB = Table[BeattyBallotCount[nn / (2 nn - 1), {mm, mm}], {mm, 1, nTerms}];
  seqA = Table[BeattyBallotCount[nn / (2 nn + 1), {mm, mm}], {mm, 1, nTerms}];

  cBelow = estimateC[seqB];
  cAbove = estimateC[seqA];

  gapBelow = cAt2 - cBelow;
  gapAbove = cAbove - cAt2;
  ratio = If[gapAbove > 0, gapBelow / gapAbove, Infinity];

  AppendTo[results, {nn, cBelow, cAbove, gapBelow, gapAbove, ratio}];
  Print[nn, "\t",
    NumberForm[cBelow, 8], "\t",
    NumberForm[cAbove, 8], "\t",
    NumberForm[gapBelow, 6], "\t",
    NumberForm[gapAbove, 6], "\t",
    "ratio=", NumberForm[ratio, 4]];,
  {nn, 2, 20}
];
