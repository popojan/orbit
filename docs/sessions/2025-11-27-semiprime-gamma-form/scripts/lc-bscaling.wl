S10[n_] := Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}]
getA[n_] := Numerator[S10[n]]

(* Vetsi semiprime *)
Print["b pro vetsi semiprime:"]
Print[""]

(* Generuj semiprime z prvocisel *)
primes = Prime[Range[3, 20]];  (* 5, 7, 11, ..., 71 *)
results = {};

Do[
  p = primes[[i]];
  q = primes[[j]];
  n = p * q;
  A = getA[n];
  bp = PowerMod[-A, -1, p];
  bq = PowerMod[-A, -1, q];
  (* Normalizuj na rozsah -(p-1)/2 .. (p-1)/2 *)
  If[bp > p/2, bp = bp - p];
  If[bq > q/2, bq = bq - q];
  AppendTo[results, {n, p, q, Abs[bp], Abs[bq]}],
  {i, 1, 8}, {j, i + 1, 9}
];

results = SortBy[results, First];
Do[
  {n, p, q, bp, bq} = results[[k]];
  Print["n=", n, " (", p, "*", q, "): |b_p|=", bp, " (~p/", N[p/bp, 3], "), |b_q|=", bq, " (~q/", N[q/bq, 3], ")"],
  {k, Min[20, Length[results]]}
]
Print["..."]
Print[""]

(* Pomer b/p *)
Print["Statistika |b|/p:"]
ratios = {};
Do[
  {n, p, q, bp, bq} = results[[k]];
  AppendTo[ratios, bp/p];
  AppendTo[ratios, bq/q],
  {k, Length[results]}
];
Print["  Mean |b|/p = ", N[Mean[ratios], 5]]
Print["  Max |b|/p = ", N[Max[ratios], 5]]
Print["  Min |b|/p = ", N[Min[ratios], 5]]
Print[""]

(* Asymptotika: je b ~ O(1), O(sqrt(p)), nebo O(p)? *)
Print["Skalovani b vs p:"]
data = {};
Do[
  {n, p, q, bp, bq} = results[[k]];
  AppendTo[data, {p, bp}];
  AppendTo[data, {q, bq}],
  {k, Length[results]}
];
(* Fit log(b) vs log(p) *)
logData = Select[data, #[[2]] > 0 &];
logData = {Log[#[[1]]], Log[#[[2]]]} & /@ logData;
fit = Fit[logData, {1, x}, x];
Print["  log(b) ~ ", fit]
Print["  => b ~ p^", Coefficient[fit, x]]
