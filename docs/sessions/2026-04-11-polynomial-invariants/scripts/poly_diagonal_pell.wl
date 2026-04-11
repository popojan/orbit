(* Check the Pell coincidence *)
Print["=== Pell(13) check ==="];
Print["649^2 - 13*180^2 = ", 649^2 - 13*180^2];
Print["180*28 = ", 180*28, " = 7! ? ", 180*28 == 7!];
Print["649/5040 = ", 649/5040];
Print[""];

(* Newton coefficients of the diagonal: *)
(* 1, 2, 2, 2, 9/8, 17/24, 203/720, 649/5040, 533/13440, 2581/181440 *)

numerators = {1, 2, 2, 2, 9, 17, 203, 649, 533, 2581, 13207};
denominators = {1, 1, 1, 1, 8, 24, 720, 5040, 13440, 181440, 3628800};

Print["=== Check each numerator against Pell fundamental solutions ==="];
Print[""];

Do[
  num = numerators[[i]];
  (* Find d such that num^2 - d*y^2 = 1 for some y *)
  pellMatches = {};
  Do[
    y2 = (num^2 - 1)/d;
    If[IntegerQ[y2] && y2 > 0 && IntegerQ[Sqrt[y2]],
      y = Sqrt[y2];
      (* Check if this is the FUNDAMENTAL solution *)
      fund = {num, y} === {num, y}; (* placeholder *)
      AppendTo[pellMatches, {d, y}];
    ];,
    {d, 2, 200}
  ];
  If[Length[pellMatches] > 0,
    Print["  index ", i - 1, ": num=", num,
      "  Pell matches: ", pellMatches];,
    Print["  index ", i - 1, ": num=", num, "  no Pell match"];
  ];,
  {i, 1, Length[numerators]}
];

Print[""];
Print["=== Denominators structure ==="];
Do[
  Print["  index ", i - 1, ": den=", denominators[[i]],
    " = ", FactorInteger[denominators[[i]]],
    "  k!/den = ", If[i > 1, (i - 1)!/denominators[[i]], "n/a"]];,
  {i, 1, Length[denominators]}
];

Print[""];
Print["=== Is 649/5040 related to Bernoulli, Euler, or other named numbers? ==="];
Print["Bernoulli numbers B_k:"];
Do[Print["  B_", k, " = ", BernoulliB[k]];, {k, 0, 14}];

Print[""];
Print["=== OEIS candidates: diagonal values 1,3,9,31,108,391,1431,5319 ==="];
Print["These are lattice paths from (1,0) to (n,n) under y <= 2x"];
Print[""];

(* Also check: do the coefficients match a known generating function? *)
(* The Newton coeffs 1, 2, 2, 2, 9/8, 17/24, 203/720, 649/5040 *)
(* Could be Taylor coefficients of some function? *)
Print["=== Cumulative product test ==="];
Print["prod_{k=0}^{n} c_k:"];
coeffs = {1, 2, 2, 2, 9/8, 17/24, 203/720, 649/5040, 533/13440, 2581/181440};
prods = FoldList[Times, coeffs];
Print[prods];
Print[""];
Print["Ratios c_{k+1}/c_k:"];
ratios = Table[coeffs[[k + 1]]/coeffs[[k]], {k, 1, Length[coeffs] - 1}];
Print[N[ratios, 6]];
