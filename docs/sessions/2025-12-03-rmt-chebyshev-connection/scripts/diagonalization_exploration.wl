(* Diagonalization Exploration for B(n,k) -> Zeta zeros *)
(* Session: 2025-12-03 RMT-Chebyshev Connection *)
(* Goal: Find map (n,k) -> m that relates to zeta zeros *)

(* === Basic definitions === *)
beta[n_] := (n - Cot[Pi/n])/(4 n);
B[n_, k_] := 1 + beta[n] Cos[(2 k - 1) Pi/n];

(* === Approach 1: Circulant Matrix === *)
(* C(n) = circulant(B(n,1), B(n,2), ..., B(n,n)) *)
(* Eigenvalues of circulant = DFT of first row *)

Print["=== Circulant Matrix Eigenvalues ===\n"];

Do[
  firstRow = Table[N[B[n, k], 10], {k, 1, n}];
  omega = Exp[2 Pi I / n];
  eigsC = Table[
    Sum[firstRow[[j + 1]] omega^(m j), {j, 0, n - 1}],
    {m, 0, n - 1}
  ];
  Print["n = ", n, ": eigenvalues = ", N[eigsC, 4]],
  {n, 2, 8}
];

(* Observation: Most eigenvalues are 0 because B(n,k) has only one Fourier mode *)
Print["\nNote: B(n,k) = 1 + beta*cos((2k-1)pi/n) has only one Fourier mode"];
Print["-> Circulant has eigenvalues: n, beta*n/2*exp(i*pi/n), conj, and zeros"];

(* === Approach 2: Diagonal Matrix D(n) === *)
Print["\n=== Diagonal Matrix Det(D_n) = Product of B values ===\n"];

Do[
  detD = Product[B[n, k], {k, 1, n}];
  gmean = detD^(1/n);
  Print["n = ", n, ": (Prod B)^(1/n) = ", N[gmean, 8]],
  {n, 2, 12}
];

Print["\nLimit as n->inf: (1 + sqrt(1 - beta_inf^2))/2 ≈ 0.9927"];

(* === Approach 3: Transfer Matrix === *)
Print["\n=== Transfer Matrix Ideas ==="];
Print["In statistical mechanics: 2D -> 1D via transfer matrix eigenvalues"];
Print["Could define T(n)_{k,k'} with B(n,k) on diagonal + coupling terms"];
Print["Largest eigenvalue determines partition function behavior"];

(* === Approach 4: Cantor Diagonalization === *)
Print["\n=== Cantor Diagonal: (n,k) -> single index m ==="];

cantor[n_, k_] := (n + k - 1)(n + k - 2)/2 + k;

Print["Cantor pairing: m = (n+k-1)(n+k-2)/2 + k"];
Print["\nFirst 15 B values in Cantor order:"];
Print["m\t(n,k)\tB(n,k)"];
Print["-------------------"];

pairs = Flatten[Table[{cantor[n, k], n, k, N[B[n, k], 6]}, {n, 2, 8}, {k, 1, n}], 1];
sorted = SortBy[pairs, First];
Do[
  {m, n, k, b} = sorted[[i]];
  Print[m, "\t(", n, ",", k, ")\t", b],
  {i, 1, Min[15, Length[sorted]]}
];

(* === The Fundamental Problem === *)
Print["\n=== THE GAP ==="];
Print[""];
Print["B(n,k) --Sum--> eta(s) --analytic--> zeta(s) --solve--> zeros"];
Print[""];
Print["We know how to go B -> eta(s) as a FUNCTION"];
Print["But extracting individual ZEROS from infinite sum is hard"];
Print[""];
Print["Key question: Is there a spectral representation where"];
Print["eigenvalues of some B-matrix directly give zeta zeros?"];
