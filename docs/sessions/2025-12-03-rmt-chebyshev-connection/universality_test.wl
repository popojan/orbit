(* Test RMT universality: ANY symmetric matrix + noise → GOE *)

pGOE[s_] := (Pi/2) s Exp[-Pi s^2/4];

testMatrix[type_, n_] := Switch[type,
  (* Chebyshev Jacobi *)
  "Chebyshev", SparseArray[{
    Band[{1, 2}] -> 1/2, Band[{2, 1}] -> 1/2}, {n, n}],

  (* Diagonal with random entries - totally unrelated to zeta *)
  "RandomDiag", DiagonalMatrix[RandomReal[{-5, 5}, n]],

  (* Fibonacci-like tridiagonal *)
  "Fibonacci", SparseArray[{
    Band[{1, 1}] -> Table[Fibonacci[k], {k, n}],
    Band[{1, 2}] -> 1, Band[{2, 1}] -> 1}, {n, n}],

  (* Prime numbers on diagonal *)
  "Primes", DiagonalMatrix[Prime[Range[n]]],

  (* Totally arbitrary: powers of pi *)
  "PiPowers", DiagonalMatrix[Table[Pi^(k/10), {k, n}]],

  (* Circulant matrix *)
  "Circulant", ToeplitzMatrix[Join[{1}, Table[0, n/2 - 1], {1}], Join[{1}, Table[0, n/2 - 1], {1}]]
];

Print["═══════════════════════════════════════════════════════════════"];
Print["RMT UNIVERSALITY TEST"];
Print["Any symmetric matrix + Gaussian noise → GOE statistics"];
Print["═══════════════════════════════════════════════════════════════\n"];

nSize = 40;
eps = 0.1;
nTrials = 300;

types = {"Chebyshev", "RandomDiag", "Fibonacci", "Primes", "PiPowers"};

Do[
  allSpacings = {};
  Do[
    base = N[testMatrix[type, nSize]];
    noise = RandomVariate[NormalDistribution[], {nSize, nSize}];
    noise = (noise + Transpose[noise])/2;
    mat = base + eps * noise;
    eigs = Sort[Eigenvalues[mat]];
    spacings = Differences[eigs];
    meanS = Mean[spacings];
    If[meanS > 0,
      normalized = spacings / meanS;
      allSpacings = Join[allSpacings, normalized]
    ],
    {nTrials}
  ];

  ps02 = N[Count[allSpacings, _?(# < 0.2 &)] / Length[allSpacings]];

  (* Chi-square vs GOE *)
  chiSq = Sum[
    Module[{low = b, high = b + 0.2, obs, exp},
      obs = Count[allSpacings, _?(low <= # < high &)] / Length[allSpacings];
      exp = NIntegrate[pGOE[s], {s, low, high}];
      If[exp > 0.001, (obs - exp)^2 / exp, 0]
    ],
    {b, 0, 2.8, 0.2}
  ];

  Print[type, ":\t P(s<0.2) = ", NumberForm[ps02, {3, 3}],
        "\t χ² vs GOE = ", NumberForm[chiSq, {4, 4}]],
  {type, types}
];

Print["\nGOE reference: P(s<0.2) = 0.031, χ² = 0"];

Print["\n═══════════════════════════════════════════════════════════════"];
Print["CONCLUSION"];
Print["═══════════════════════════════════════════════════════════════"];
Print["\nIf ALL matrices give similar χ² ≈ 0, then:"];
Print["  → GOE statistics are UNIVERSAL"];
Print["  → Not special to Chebyshev or zeta"];
Print["  → Any symmetric matrix + noise → GOE"];

