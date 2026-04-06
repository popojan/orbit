(* ::Package:: *)

(* WindingMatrix: The interaction matrix between zeta zeros and primes

   M_{np} = cos(γ_n ln p)
   w_{np} = Floor[γ_n ln p / (2π)]  (winding numbers)
   r_{np} = FractionalPart[γ_n ln p / (2π)] * 2π  (residuals)

   Decomposition: γ_n ln p = 2π w_{np} + r_{np}
   And: M_{np} = cos(r_{np})
*)

BeginPackage["Orbit`"];

WindingMatrix::usage = "WindingMatrix[nZeros, nPrimes, k:1] returns the integer winding number matrix
w_{np} = Floor[k γ_n ln p / (2π)]. Scaling k controls resolution (default 1). Caches zero heights.";

InteractionMatrix::usage = "InteractionMatrix[nZeros, nPrimes] returns the real interaction matrix
M_{np} = cos(γ_n ln p).";

ResidualMatrix::usage = "ResidualMatrix[nZeros, nPrimes, k:1] returns the fractional residuals
r_{np} = FractionalPart[k γ_n ln p / (2π)], values in [0, 1). Scaling k matches WindingMatrix.";

SymbolicWindingMatrix::usage = "SymbolicWindingMatrix[nPrimes] returns the winding matrix
symbolically as Floor[ZetaZero[n] Log[Prime[j]] / (2π)], unevaluated.
Call N[] or replace ZetaZero to evaluate.";

SymbolicResidualMatrix::usage = "SymbolicResidualMatrix[nPrimes] returns the residual matrix
symbolically as FractionalPart[ZetaZero[n] Log[Prime[j]] / (2π)], unevaluated.
Call N[] or replace ZetaZero to evaluate.";

WindingData::usage = "WindingData[nZeros, nPrimes] returns an Association with keys
\"Winding\", \"Interaction\", \"Residual\", \"Theta\" (= γ⊗ℓ/(2π), rank 1),
\"Gammas\", \"LogPrimes\", \"SVD\".";

ZeroHeights::usage = "ZeroHeights[n] returns the first n imaginary parts of zeta zeros, cached.";

Begin["`Private`"];

(* Cache zero heights — computed once *)
$zeroCache = <||>;

ZeroHeights[n_Integer] := Module[{},
  If[!KeyExistsQ[$zeroCache, n] || Length[$zeroCache[n]] < n,
    $zeroCache[n] = Table[N[Im[ZetaZero[k]], 15], {k, n}]
  ];
  $zeroCache[n]
]

(* Core matrices *)
WindingMatrix[nz_Integer, np_Integer, k_:1] := Module[{g, lp},
  g = ZeroHeights[nz];
  lp = Table[Log[N[Prime[j], 15]], {j, np}];
  Table[Floor[k g[[n]] lp[[j]] / (2 Pi)], {n, nz}, {j, np}]
]

InteractionMatrix[nz_Integer, np_Integer] := Module[{g, lp},
  g = ZeroHeights[nz];
  lp = Table[Log[N[Prime[j], 15]], {j, np}];
  Table[Cos[g[[n]] lp[[j]]], {n, nz}, {j, np}]
]

ResidualMatrix[nz_Integer, np_Integer, k_:1] := Module[{g, lp},
  g = ZeroHeights[nz];
  lp = Table[Log[N[Prime[j], 15]], {j, np}];
  Table[FractionalPart[k g[[n]] lp[[j]] / (2 Pi)], {n, nz}, {j, np}]
]

(* Symbolic versions: return held expressions *)
(* Use Inactive to prevent evaluation of Floor/FractionalPart *)
SymbolicWindingMatrix[nz_Integer, np_Integer] :=
  Table[Inactive[Floor][Im[ZetaZero[n]] Log[Prime[j]] / (2 Pi)], {n, nz}, {j, np}]

SymbolicResidualMatrix[nz_Integer, np_Integer] :=
  Table[Inactive[FractionalPart][Im[ZetaZero[n]] Log[Prime[j]] / (2 Pi)], {n, nz}, {j, np}]

(* Activate + N to evaluate *)
(* Usage: Activate[N[SymbolicWindingMatrix[5, 5]]] *)

WindingData[nz_Integer, np_Integer] := Module[{g, lp, theta, ww, rr, mm, svd},
  g = ZeroHeights[nz];
  lp = Table[Log[N[Prime[j], 15]], {j, np}];
  theta = Outer[Times, g, lp] / (2 Pi);
  ww = Floor[theta * (2 Pi)] /. x_ /; NumericQ[x] :> Floor[x]; (* avoid double mult *)
  ww = Table[Floor[g[[n]] lp[[j]] / (2 Pi)], {n, nz}, {j, np}];
  rr = Table[FractionalPart[g[[n]] lp[[j]] / (2 Pi)], {n, nz}, {j, np}];
  mm = Cos[2 Pi rr];
  svd = SingularValueList[N[ww]];
  <|
    "Winding" -> ww,
    "Interaction" -> mm,
    "Residual" -> rr,
    "Theta" -> theta,
    "Gammas" -> g,
    "LogPrimes" -> lp,
    "SVD" -> svd,
    "SpectralGap" -> If[Length[svd] >= 2, svd[[1]]/svd[[2]], Infinity],
    "Rank1Fraction" -> If[Total[svd^2] > 0, svd[[1]]^2/Total[svd^2], 1]
  |>
]

End[];

EndPackage[];
