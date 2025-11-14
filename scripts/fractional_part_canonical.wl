(* Canonical fractional part (reduce to [0,1)) *)

ComputeBareSumAlt[m_Integer] := Module[{k},
  k = Floor[(m-1)/2];
  Sum[(-1)^i * i! / (2i+1), {i, 1, k}]
];

Print["Canonical Fractional Part: FP_m in [0, 1)"];
Print[""];

primes = Select[Range[3, 47, 2], PrimeQ];

data = Table[
  Module[{m, k, sigma, product, Q, fp, canonicalFP, num},
    m = p;
    k = Floor[(m-1)/2];
    sigma = ComputeBareSumAlt[m];
    product = sigma * (m-1)!;
    Q = Floor[product];

    (* Raw fractional part (can be negative) *)
    fp = product - Q;

    (* Canonical form in [0, 1) *)
    canonicalFP = Mod[fp, 1];

    num = Numerator[canonicalFP];

    <|
      "m" -> m,
      "k" -> k,
      "rawFP" -> fp,
      "canonicalFP" -> canonicalFP,
      "num" -> num,
      "2k+1" -> 2*k + 1,
      "lastTermIndex" -> k,
      "lastTermDenom" -> 2*k + 1
    |>
  ],
  {p, primes}
];

Print["m | k | Canonical FP | num | 2k+1 | num=2k+1? | num=m-(2k+1)?"];
Print[StringRepeat["-", 80]];

Do[
  d = data[[i]];
  check1 = (d["num"] == d["2k+1"]);
  check2 = (d["num"] == d["m"] - d["2k+1"]);

  Print[
    d["m"], " | ",
    d["k"], " | ",
    d["canonicalFP"], " | ",
    d["num"], " | ",
    d["2k+1"], " | ",
    If[check1, "â YES", "â"], " | ",
    If[check2, "â YES", "â"]
  ];
  , {i, 1, Length[data]}
];

Print[""];
Print[""];
Print["TESTING: Is num = 2k+1 always?"];
check2kp1 = Table[d["num"] == d["2k+1"], {d, data}];
successRate = Count[check2kp1, True];
Print["Success rate: ", successRate, "/", Length[check2kp1]];

If[successRate == Length[check2kp1],
  Print[""];
  Print["âââ THEOREM DISCOVERED âââ"];
  Print[""];
  Print["For prime m â¥ 3, let k = â(m-1)/2â. Then:"];
  Print[""];
  Print["  FractionalPart[Î£_m^alt Â· (m-1)!] = (2k+1) / m"];
  Print[""];
  Print["where FractionalPart is taken in canonical form [0, 1)."];
  Print[""];
  Print["REMARKABLE COROLLARY:"];
  Print["  The last term in the sum has denominator 2k+1,"];
  Print["  and this EXACT VALUE appears as the fractional part numerator!"];
  Print[""];
  Print["âââââââââââââââââââââââââââââââââââââââââââââââââââââ"];
  ,
  Print[""];
  Print["Hypothesis FAILED for some primes."];
  failed = Select[Table[{data[[i]]["m"], check2kp1[[i]]}, {i, 1, Length[check2kp1]}],
    !Last[#] &];
  Print["Failed for m = ", failed[[All, 1]]];
  Print[""];
  Print["Let's check each failure:"];
  Do[
    d = Select[data, #["m"] == failed[[i, 1]] &][[1]];
    Print["  m=", d["m"], ": num=", d["num"], ", 2k+1=", d["2k+1"], ", diff=", d["num"] - d["2k+1"]];
    , {i, 1, Min[5, Length[failed]]}
  ];
];

Print[""];
