(* Test with stronger noise *)

pGOE[s_] := (Pi/2) s Exp[-Pi s^2/4];

testMatrix[type_, n_] := Switch[type,
  "Chebyshev", SparseArray[{Band[{1, 2}] -> 1/2, Band[{2, 1}] -> 1/2}, {n, n}],
  "Fibonacci", SparseArray[{
    Band[{1, 1}] -> Table[Fibonacci[k], {k, n}],
    Band[{1, 2}] -> 1, Band[{2, 1}] -> 1}, {n, n}],
  "Primes", DiagonalMatrix[Prime[Range[n]]],
  "PiPowers", DiagonalMatrix[Table[Pi^(k/10), {k, n}]]
];

Print["═══════════════════════════════════════════════════════════════"];
Print["UNIVERSALITY vs NOISE STRENGTH"];
Print["═══════════════════════════════════════════════════════════════\n"];

nSize = 40;
nTrials = 200;
types = {"Chebyshev", "Fibonacci", "Primes", "PiPowers"};

Print["ε\t\tChebyshev\tFibonacci\tPrimes\t\tPiPowers"];

Do[
  results = {};
  Do[
    allSpacings = {};
    Do[
      base = N[testMatrix[type, nSize]];
      (* Scale noise by matrix norm *)
      matScale = Max[Abs[Flatten[Normal[base]]]];
      noise = RandomVariate[NormalDistribution[], {nSize, nSize}];
      noise = (noise + Transpose[noise])/2;
      mat = base + eps * matScale * noise;
      eigs = Sort[Eigenvalues[mat]];
      spacings = Differences[eigs];
      meanS = Mean[spacings];
      If[meanS > 0, normalized = spacings/meanS; allSpacings = Join[allSpacings, normalized]],
      {nTrials}
    ];
    ps02 = N[Count[allSpacings, _?(# < 0.2 &)] / Length[allSpacings]];
    AppendTo[results, ps02],
    {type, types}
  ];
  Print[eps, "\t\t", NumberForm[results[[1]], {3,3}], "\t\t",
        NumberForm[results[[2]], {3,3}], "\t\t",
        NumberForm[results[[3]], {3,3}], "\t\t",
        NumberForm[results[[4]], {3,3}]],
  {eps, {0.01, 0.1, 0.5, 1.0, 2.0}}
];

Print["\nGOE target: P(s<0.2) = 0.031"];

Print["\n═══════════════════════════════════════════════════════════════"];
Print["INSIGHT: Universality requires sufficient noise"];
Print["═══════════════════════════════════════════════════════════════"];
Print["\n- Chebyshev (tridiagonal, small entries): converges quickly"];
Print["- Fibonacci (huge diagonal entries): needs more noise"];
Print["- The RATIO of noise to eigenvalue spacing matters"];
Print["- Eventually ALL → GOE (but rate depends on structure)"];

