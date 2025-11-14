#!/usr/bin/env wolframscript

(* Define and measure "orbit richness" *)

SetDirectory[ParentDirectory[DirectoryName[$InputFileName]]];
PacletDirectoryLoad["Orbit"];
Needs["Orbit`"];

Print["=== DEFINING ORBIT RICHNESS ==="];
Print[""];

AbstractSparse[n_Integer, seq_List] := Module[{r = n, result = {}, s},
  While[r >= First[seq],
    s = SelectFirst[Reverse[seq], # <= r &, None];
    If[s === None, Break[]];
    AppendTo[result, s];
    r -= s
  ];
  Append[result, r]
]

AbstractOrbit[n_Integer, seq_List] := Module[{orbit = {}, queue = {n}, current, sparse, elems},
  While[queue != {},
    current = First[queue];
    queue = Rest[queue];
    If[current >= First[seq] && !MemberQ[orbit, current],
      sparse = AbstractSparse[current, seq];
      elems = Select[Most[sparse], MemberQ[seq, #] &];
      orbit = Union[orbit, elems];
      queue = Join[queue, FirstPosition[seq, #, {0}][[1]] & /@ elems];
    ];
  ];
  Sort[orbit]
]

(* Propose metrics for orbit richness *)

RichnessMetrics[seq_, sampleSize_] := Module[{sample, orbits, lengths, data},
  sample = Take[seq, UpTo[sampleSize]];
  orbits = AbstractOrbit[#, seq] & /@ sample;
  lengths = Length /@ orbits;

  data = <|
    (* 1. Average depth *)
    "MeanLength" -> N[Mean[lengths]],
    "MedianLength" -> N[Median[lengths]],

    (* 2. Variability *)
    "StdDevLength" -> N[StandardDeviation[lengths]],
    "LengthRange" -> Max[lengths] - Min[lengths],

    (* 3. Distribution shape *)
    "TrivialFraction" -> N[Count[lengths, 1] / Length[lengths]],  (* Length 1 *)
    "ShallowFraction" -> N[Count[lengths, 2] / Length[lengths]],  (* Length 2 *)
    "DeepFraction" -> N[Count[lengths, x_ /; x >= 4] / Length[lengths]],  (* Length >= 4 *)

    (* 4. Entropy (information-theoretic measure) *)
    "Entropy" -> Module[{dist, probs},
      dist = Tally[lengths];
      probs = N[#[[2]] / Length[lengths] & /@ dist];
      -Total[# * Log[2, #] & /@ Select[probs, # > 0 &]]
    ]
  |>;

  data
]

Print["PROPOSED RICHNESS METRICS:"];
Print[""];
Print["1. Mean/Median Length: Higher = deeper recursion"];
Print["2. Std Dev & Range: Higher = more structural variety"];
Print["3. Fraction by depth:"];
Print["   - Trivial (length 1): Lower = better"];
Print["   - Shallow (length 2): Lower = better"];
Print["   - Deep (length ≥4): Higher = better"];
Print["4. Entropy: Higher = more diverse orbit structures"];
Print[""];

(* Generate sequences *)
primes = Select[Range[2, 500], PrimeQ];
semiprimes = Select[Range[4, 500], PrimeOmega[#] == 2 &];
almostPrimes3 = Select[Range[8, 500], PrimeOmega[#] == 3 &];
evens = Range[2, 500, 2];
integers = Range[1, 500];

sampleSize = 50;

Print["=== RICHNESS MEASUREMENTS ==="];
Print[""];

metricsPrimes = RichnessMetrics[primes, sampleSize];
metricsSemi = RichnessMetrics[semiprimes, sampleSize];
metricsAlmost3 = RichnessMetrics[almostPrimes3, sampleSize];
metricsEvens = RichnessMetrics[evens, sampleSize];
metricsInts = RichnessMetrics[integers, sampleSize];

PrintMetrics[name_, metrics_] := Module[{},
  Print[name, ":"];
  Print["  Mean length: ", metrics["MeanLength"]];
  Print["  Median length: ", metrics["MedianLength"]];
  Print["  Std dev: ", metrics["StdDevLength"]];
  Print["  Range: ", metrics["LengthRange"]];
  Print["  Trivial (len=1): ", N[100 * metrics["TrivialFraction"]], "%"];
  Print["  Shallow (len=2): ", N[100 * metrics["ShallowFraction"]], "%"];
  Print["  Deep (len≥4): ", N[100 * metrics["DeepFraction"]], "%"];
  Print["  Entropy: ", metrics["Entropy"]];
  Print[""];
]

PrintMetrics["PRIMES", metricsPrimes];
PrintMetrics["SEMIPRIMES", metricsSemi];
PrintMetrics["3-ALMOST PRIMES", metricsAlmost3];
PrintMetrics["EVEN NUMBERS", metricsEvens];
PrintMetrics["INTEGERS", metricsInts];

(* Propose richness threshold *)
Print["=== PROPOSED 'RICH' THRESHOLD ==="];
Print[""];
Print["A sequence has RICH orbit structure if:"];
Print["  1. Mean length ≥ 3.5"];
Print["  2. Deep fraction (≥4) ≥ 30%"];
Print["  3. Entropy ≥ 1.5"];
Print["  4. Trivial fraction < 10%"];
Print[""];

ClassifyRichness[name_, metrics_] := Module[{rich},
  rich = metrics["MeanLength"] >= 3.5 &&
         metrics["DeepFraction"] >= 0.30 &&
         metrics["Entropy"] >= 1.5 &&
         metrics["TrivialFraction"] < 0.10;

  Print[name, ": ",
    If[rich, "RICH ✓", "SHALLOW/TRIVIAL ✗"]];
  Print["  Mean: ", metrics["MeanLength"], If[metrics["MeanLength"] >= 3.5, " ✓", " ✗"]];
  Print["  Deep%: ", N[100*metrics["DeepFraction"]], If[metrics["DeepFraction"] >= 0.30, " ✓", " ✗"]];
  Print["  Entropy: ", metrics["Entropy"], If[metrics["Entropy"] >= 1.5, " ✓", " ✗"]];
  Print["  Trivial%: ", N[100*metrics["TrivialFraction"]], If[metrics["TrivialFraction"] < 0.10, " ✓", " ✗"]];
  Print[""];
]

ClassifyRichness["Primes", metricsPrimes];
ClassifyRichness["Semiprimes", metricsSemi];
ClassifyRichness["3-almost primes", metricsAlmost3];
ClassifyRichness["Even numbers", metricsEvens];
ClassifyRichness["Integers", metricsInts];

Print["=== COMPLETE ==="];
