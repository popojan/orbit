(* Simple computation of fractional parts *)

ComputeBareSumAlt[m_Integer] := Module[{k},
  k = Floor[(m-1)/2];
  Sum[(-1)^i * i! / (2i+1), {i, 1, k}]
];

Print["Fractional Part Analysis"];
Print[""];
Print["m | k | FP_m | num | Numerator pattern analysis"];
Print[StringRepeat["-", 80]];

primes = Select[Range[3, 47, 2], PrimeQ];

data = Table[
  Module[{m, k, sigma, product, fp, num, den},
    m = p;
    k = Floor[(m-1)/2];
    sigma = ComputeBareSumAlt[m];
    product = sigma * (m-1)!;
    fp = FractionalPart[product];
    num = Numerator[fp];
    den = Denominator[fp];

    (* Check various hypotheses *)
    <|
      "m" -> m,
      "k" -> k,
      "fp" -> fp,
      "num" -> num,
      "den" -> den,
      "2k+1" -> 2*k + 1,
      "m-num" -> m - num,
      "num mod (2k+1)" -> Mod[num, 2*k + 1],
      "(m-1)/2" -> (m-1)/2,
      "k(k+1)/2" -> k*(k+1)/2,
      "triangular_k" -> k*(k+1)/2
    |>
  ],
  {p, primes}
];

Do[
  d = data[[i]];
  Print[
    d["m"], " | ",
    d["k"], " | ",
    d["fp"], " | ",
    d["num"], " | ",
    "2k+1=", d["2k+1"], ", ",
    "T(k)=", d["triangular_k"], ", ",
    "m-num=", d["m-num"]
  ];
  , {i, 1, Length[data]}
];

Print[""];
Print["Pattern observations:"];
Print["  1. Denominator ALWAYS = m"];
Print["  2. Numerator sequence: ", data[[All, "num"]]];
Print["  3. Check if num ≡ something mod (2k+1)"];
Print[""];

(* Look for mod 2k+1 pattern *)
Print["Numerator mod (2k+1):"];
Do[
  d = data[[i]];
  Print["  m=", d["m"], ": num=", d["num"], " mod ", d["2k+1"], " = ", d["num mod (2k+1)"]];
  , {i, 1, Min[12, Length[data]]}
];

Print[""];
Print["Check special cases:"];
Print["  For primes where m ≡ 3 (mod 4):"];
specialMod3 = Select[data, Mod[#["m"], 4] == 3 &];
Print["    ", Table[{d["m"], d["num"], d["m-num"]}, {d, specialMod3}]];

Print[""];
Print["  For primes where m ≡ 1 (mod 4):"];
specialMod1 = Select[data, Mod[#["m"], 4] == 1 &];
Print["    ", Table[{d["m"], d["num"], d["m-num"]}, {d, specialMod1}]];

Print[""];
Print["Check if numerator relates to last term's denominator 2k+1:"];
Do[
  d = data[[i]];
  lastDenom = 2*d["k"] + 1;
  Print["  m=", d["m"], ", k=", d["k"], ", last denom=", lastDenom, ", numerator=", d["num"]];
  , {i, 1, Min[10, Length[data]]}
];
