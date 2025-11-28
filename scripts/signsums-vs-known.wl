(* Adversarial check: Does Σsigns relate to known number-theoretic functions? *)

Print["=== Σsigns vs Known Functions ===\n"];

(* Compute Σsigns directly *)
signSum[k_] := Module[{prims},
  prims = Select[Range[2, k-1], GCD[#-1, k] == 1 && GCD[#, k] == 1 &];
  Total[(-1)^(# - 1) & /@ prims]
];

(* Test range: squarefree composites *)
composites = Select[Range[6, 500], !PrimeQ[#] && SquareFreeQ[#] &];

Print["Testing ", Length[composites], " squarefree composites up to 500\n"];

(* Compute all values *)
data = Table[
  {k, signSum[k], EulerPhi[k], MoebiusMu[k], LiouvilleLambda[k],
   PrimeNu[k], PrimeOmega[k]},
  {k, composites}
];

(* Headers *)
Print["Sample data:"];
Print["k\tΣsigns\tφ(k)\tμ(k)\tλ(k)\tω(k)\tΩ(k)"];
Print["-----------------------------------------------------------"];
Do[Print[StringRiffle[ToString /@ data[[i]], "\t"]], {i, Min[15, Length[data]]}];

Print["\n=== Correlation Analysis ===\n"];

ss = data[[All, 2]];
phi = data[[All, 3]];
mu = data[[All, 4]];
lambda = data[[All, 5]];
omega = data[[All, 6]];
bigOmega = data[[All, 7]];

corr[x_, y_] := Correlation[N[x], N[y]];

Print["Correlation with Σsigns:"];
Print["  φ(k):  r = ", NumberForm[corr[ss, phi], 4]];
Print["  μ(k):  r = ", NumberForm[corr[ss, mu], 4]];
Print["  λ(k):  r = ", NumberForm[corr[ss, lambda], 4]];
Print["  ω(k):  r = ", NumberForm[corr[ss, omega], 4]];
Print["  Ω(k):  r = ", NumberForm[corr[ss, bigOmega], 4]];

(* Check if Σsigns is a simple function of ω *)
Print["\n=== Σsigns by ω(k) ===\n"];
Do[
  subset = Select[data, #[[6]] == w &];
  If[Length[subset] > 0,
    vals = subset[[All, 2]];
    Print["ω=", w, ": ", Length[subset], " cases, Σsigns range: ",
          Min[vals], " to ", Max[vals], ", mean: ", N[Mean[vals], 4]]
  ],
  {w, 2, 6}
];

(* Check modular patterns *)
Print["\n=== Σsigns mod small numbers ===\n"];
Do[
  counts = Counts[Mod[ss, m]];
  Print["mod ", m, ": ", counts],
  {m, {2, 3, 4, 8}}
];

(* Check: is Σsigns always ≡ something (mod 4)? *)
Print["\n=== Congruence patterns by ω ===\n"];
Do[
  subset = Select[data, #[[6]] == w &];
  If[Length[subset] > 0,
    mods = Union[Mod[subset[[All, 2]], 4]];
    Print["ω=", w, ": Σsigns mod 4 ∈ ", mods]
  ],
  {w, 2, 6}
];

(* Is there a formula? *)
Print["\n=== Testing: Σsigns = f(φ, μ, ω) ===\n"];

(* Try: Σsigns = a*μ + b for semiprimes *)
semiprimes = Select[data, #[[6]] == 2 &];
Print["Semiprimes (ω=2):"];
Print["  All have μ(k) = 1"];
Print["  Σsigns values: ", Union[semiprimes[[All, 2]]]];

(* Deeper: check if Σsigns relates to Jacobi symbol structure *)
Print["\n=== Jacobi symbol connection? ===\n"];

(* For semiprime pq, check relation to (p|q) and (q|p) *)
Print["For semiprimes pq, checking Legendre symbols:"];
semiprimeData = Select[composites, PrimeNu[#] == 2 &];

jacobiTest = Table[
  {p, q} = FactorInteger[k][[All, 1]];
  jp = JacobiSymbol[p, q];
  jq = JacobiSymbol[q, p];
  ss = signSum[k];
  {k, p, q, ss, jp, jq, jp*jq},
  {k, Take[semiprimeData, 30]}
];

Print["k\tp\tq\tΣsigns\t(p|q)\t(q|p)\tproduct"];
Do[Print[StringRiffle[ToString /@ jacobiTest[[i]], "\t"]], {i, Length[jacobiTest]}];

(* Check correlation *)
ssVals = jacobiTest[[All, 4]];
jpjq = jacobiTest[[All, 7]];
Print["\nCorrelation Σsigns vs (p|q)(q|p): r = ", NumberForm[corr[ssVals, jpjq], 4]];

(* Quadratic reciprocity angle *)
Print["\n=== Quadratic Reciprocity Connection ===\n"];
Print["(p|q)(q|p) = (-1)^{(p-1)(q-1)/4} by QR"];
Print["Checking if Σsigns relates to (p-1)(q-1)/4 mod 2..."];

qrData = Table[
  {p, q} = FactorInteger[k][[All, 1]];
  qrExp = Mod[(p-1)(q-1)/4, 2];
  ss = signSum[k];
  {k, ss, qrExp, (-1)^qrExp},
  {k, Take[semiprimeData, 50]}
];

Print["\nΣsigns by QR exponent:"];
exp0 = Select[qrData, #[[3]] == 0 &][[All, 2]];
exp1 = Select[qrData, #[[3]] == 1 &][[All, 2]];
Print["  QR exp = 0: Σsigns ∈ ", Union[exp0]];
Print["  QR exp = 1: Σsigns ∈ ", Union[exp1]];
