(* ================================================================ *)
(* Interaction Matrix M_{np} = cos(γ_n ln p)                       *)
(* Double Chebyshev factorization: M = T_{k1}(T_{k2}(c_{np}))     *)
(* Working script for exploration                                   *)
(* ================================================================ *)

<< Orbit`

(* === Data === *)
nZ = 8; nP = 8;
gammas = Table[N[Im[ZetaZero[n]], 15], {n, nZ}];
lnP = Table[Log[N[Prime[j], 15]], {j, nP}];
primes = Prime /@ Range[nP];

(* === Build interaction matrix === *)
buildM[nz_, np_] := Table[Cos[gammas[[n]] lnP[[j]]], {n, Min[nz, nZ]}, {j, Min[np, nP]}]

(* === Minimal k for "well-behaved" seed === *)
(* Criterion: |cos(α/k)| ∈ [lo, hi] *)
minK[alpha_, lo_: 0.1, hi_: 0.95] := Module[{k = 1},
  While[k < 500 && (Abs[Cos[alpha/k]] > hi || Abs[Cos[alpha/k]] < lo), k++];
  k
]

(* Per-zero and per-prime minimal k *)
k2[n_] := minK[gammas[[n]]]
k1[j_] := minK[lnP[[j]]]

(* === Seed matrix for given k1, k2 vectors === *)
seedMatrix[k1vec_, k2vec_] := Table[
  Cos[gammas[[n]] lnP[[j]] / (k1vec[[j]] k2vec[[n]])],
{n, Length[k2vec]}, {j, Length[k1vec]}]

(* === Index (step) matrix === *)
stepMatrix[k1vec_, k2vec_] := Outer[Times, k2vec, k1vec]

(* === Verify double factorization === *)
verifyFactorization[k1vec_, k2vec_] := Module[{cm, sm, maxErr = 0},
  cm = seedMatrix[k1vec, k2vec];
  Do[
    Module[{inner, outer, exact},
      inner = ChebyshevT[k2vec[[n]], cm[[n, j]]];
      outer = ChebyshevT[k1vec[[j]], inner];
      exact = Cos[gammas[[n]] lnP[[j]]];
      maxErr = Max[maxErr, Abs[outer - exact]]
    ],
  {n, Length[k2vec]}, {j, Length[k1vec]}];
  maxErr
]

(* === SVD analysis === *)
analyzeSVD[mat_] := Module[{svd = SingularValueList[mat], frobSq},
  frobSq = Total[Flatten[mat^2]];
  <|"singularValues" -> svd,
    "ratio12" -> svd[[1]]/svd[[2]],
    "rank1fraction" -> svd[[1]]^2/frobSq,
    "conditionNumber" -> svd[[1]]/svd[[-1]]|>
]

(* === Symbolic polynomial matrix === *)
(* Entries are T_{K}(c) as polynomials in symbolic c *)
symbolicPolyMatrix[k1vec_, k2vec_] := Table[
  ChebyshevT[k1vec[[j]] k2vec[[n]], c] // Expand,
{n, Length[k2vec]}, {j, Length[k1vec]}]

(* === Example usage === *)
Print["=== Interaction Matrix Explorer ===\n"];

k2vec = Table[k2[n], {n, nZ}];
k1vec = Table[k1[j], {j, nP}];
Print["k₂ (per zero): ", k2vec];
Print["k₁ (per prime): ", k1vec];

Print["\nStep matrix K = k₂ ⊗ k₁:"];
Print[MatrixForm[stepMatrix[k1vec, k2vec]]];

Print["\nVerification error: ", verifyFactorization[k1vec, k2vec]];

Print["\nSVD of seed matrix:"];
sm = seedMatrix[k1vec, k2vec];
Print[analyzeSVD[sm]];

Print["\nSVD of original M:"];
Print[analyzeSVD[buildM[nZ, nP]]];

Print["\n=== Symbolic polynomial matrix (first 4×4) ==="];
sp = symbolicPolyMatrix[k1vec[[1;;4]], k2vec[[1;;4]]];
Print[MatrixForm[sp]];
