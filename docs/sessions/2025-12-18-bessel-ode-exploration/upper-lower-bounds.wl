(* Upper and Lower bounds for e *)

Print["=== UPPER AND LOWER BOUNDS FOR e ===\n"];

(* The s_n sequence *)
s[0] = 1; s[1] = 7;
s[n_] := s[n] = (4 n + 2) s[n - 1] + s[n - 2];

(* T_n from the paper: transformed convergents *)
(* T_n = 1 + 2/(1 + p_n/q_n) where p_n/q_n converges to (3-e)/(e-1) *)
(* Recurrence for T_n directly from s_n: *)
(* T_n = (s_n + s_{n-1}) / s_{n-1} = s_n/s_{n-1} + 1 ... actually more complex *)

(* Let me compute T_n from the CF convergents *)
(* CF for (3-e)/(e-1) = [0; 6, 10, 14, ...] *)
cfCoeffs = {0} ~Join~ Table[4 k + 2, {k, 1, 50}];
convs = Convergents[cfCoeffs, 20];

T[n_] := 1 + 2/(1 + convs[[n + 1]]);

Print["=== T_n SEQUENCE (alternates around e) ==="];
Table[
  tn = T[n];
  diff = N[tn - E, 20];
  sign = If[diff > 0, "ABOVE", "BELOW"];
  Print["T_", n, " = ", tn, " = ", N[tn, 15], " (", sign, " e)"];
  , {n, 1, 8}
];

Print["\n=== LOWER BOUNDS (odd T_n) ==="];
Print["e > T_1 > T_3 > T_5 > ... (NO! T_1 < T_3 < T_5 < e)"];
Print["Actually: T_1 < T_3 < T_5 < ... < e (increasing to e)\n"];

lowerBounds = Table[T[2 k - 1], {k, 1, 5}];
Print["Lower bounds: ", N[lowerBounds, 10]];
Print["Differences from e: ", N[# - E, 15] & /@ lowerBounds];

Print["\n=== UPPER BOUNDS (even T_n) ==="];
Print["T_2 > T_4 > T_6 > ... > e (decreasing to e)\n"];

upperBounds = Table[T[2 k], {k, 1, 5}];
Print["Upper bounds: ", N[upperBounds, 10]];
Print["Differences from e: ", N[# - E, 15] & /@ upperBounds];

Print["\n=== MONOTONE SERIES FROM BELOW ==="];
Print["(Our paper's formula)"];
Print["e = T_1 + (T_3-T_1) + (T_5-T_3) + ..."];
Print["  = T_1 + Σ (T_{2k+1} - T_{2k-1})"];
Print["Each difference is POSITIVE, so partial sums INCREASE to e.\n"];

Print["=== MONOTONE SERIES FROM ABOVE ==="];
Print["e = T_2 - (T_2-T_4) - (T_4-T_6) - ..."];
Print["  = T_2 - Σ (T_{2k} - T_{2k+2})"];
Print["Each subtracted term is POSITIVE, so partial sums DECREASE to e.\n"];

(* Compute upper bound partial sums *)
upperPartial[0] := T[2];
upperPartial[n_] := T[2] - Sum[T[2 k] - T[2 k + 2], {k, 1, n}];

Print["=== UPPER BOUND PARTIAL SUMS ==="];
Table[
  up = upperPartial[k];
  err = N[up - E, 30];
  digits = If[err == 0, ">30", Round[-Log10[Abs[err]], 0.1]];
  Print["Upper_", k, " = ", up, " (", digits, " digits, above by ",
        ScientificForm[N[err, 3]], ")"];
  , {k, 0, 5}
];

Print["\n=== BRACKETING e ==="];
Print["For each k, we have: T_{2k-1} < e < T_{2k}"];
Table[
  lo = T[2 k - 1];
  hi = T[2 k];
  width = hi - lo;
  Print["k=", k, ": ", N[lo, 12], " < e < ", N[hi, 12],
        " (width: ", ScientificForm[N[width, 3]], ")"];
  , {k, 1, 6}
];
