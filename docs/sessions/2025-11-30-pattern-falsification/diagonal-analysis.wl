(* Analysis: Why diagonal lines? *)
(* For n in [k², (k+1)²], sqPos = (n - k²)/(2k+1) *)
(* For sqrt(n) in [p_i, p_{i+1}], primePos = (sqrt(n) - p_i)/(p_{i+1} - p_i) *)

(* The diagonal structure: when both increase together *)
(* Rate of sqPos increase with n: d(sqPos)/dn = 1/(2k+1) *)
(* Rate of primePos increase with n: d(primePos)/dn = 1/(2*sqrt(n)*(p_{i+1}-p_i)) *)

(* Key insight: signedDist captures deviation from k², floorSqrt captures k *)
(* So these two indicators together encode position in both lattices *)

(* Let's verify the connection: *)
signedDist[p_] := Module[{s = Floor[Sqrt[p]], d},
  d = p - s^2;
  If[d <= s, d, d - 2*s - 1]
];

sqPos[n_] := Module[{k = Floor[Sqrt[n]]},
  (n - k^2)/(2 k + 1) // N
];

(* Test correlation between signedDist and sqPos *)
data = Table[{signedDist[n], sqPos[n]}, {n, 2, 1000}];

Print["Correlation signedDist vs sqPos: ", Correlation[data[[All,1]], data[[All,2]]]];

(* More interesting: signedDist mod 4 partitions the square position *)
grouped = GroupBy[Table[{Mod[signedDist[n], 4], sqPos[n]}, {n, 2, 500}], First -> Last];
Do[
  Print["signedDist mod 4 = ", k, ": mean sqPos = ", Mean[grouped[k]], 
        ", count = ", Length[grouped[k]]],
  {k, 0, 3}
];
