(* Test additive hypothesis: Σsigns(p1p2p3) = f(Σsigns of sub-semiprimes) *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

(* Semiprime Σsigns: +1 or -3 *)
semiprimeSignSum[p_, q_] := If[OddQ[PowerMod[p, -1, q]], 1, -3];

Print["=== Test: Σsigns(p1p2p3) = Σsigns(p1p2) + Σsigns(p1p3) + Σsigns(p2p3) + c ===\n"];

data = {};
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];

    (* Sub-semiprime sign sums *)
    ss12 = semiprimeSignSum[p1, p2];
    ss13 = semiprimeSignSum[p1, p3];
    ss23 = semiprimeSignSum[p2, p3];

    sum3 = ss12 + ss13 + ss23;
    diff = ss - sum3;

    AppendTo[data, {k, p1, p2, p3, ss, ss12, ss13, ss23, sum3, diff}];
    Print[k, " = ", p1, "×", p2, "×", p3,
          ": Σsigns=", ss,
          ", (ss12,ss13,ss23)=(", ss12, ",", ss13, ",", ss23, ")",
          ", sum=", sum3, ", diff=", diff];
  ],
  {p1, {3}},
  {p2, Prime[Range[3, 8]]},
  {p3, Prime[Range[4, 12]]}
];

Print["\n=== Distribution of diff values ==="];
Tally[#[[10]] & /@ data] // Sort // Print;

Print["\n=== Is diff determined by something simple? ==="];
Do[
  d = row;
  If[d[[10]] != -2,  (* Focus on non-standard diff *)
    Print[d[[1]], ": diff=", d[[10]], ", primes=", d[[2]], "×", d[[3]], "×", d[[4]]]
  ],
  {row, data}
];
