(* Deeper analysis: What determines the excess prime powers? *)

(* Compute bare alternating sum *)
ComputeBareSumAlt[m_Integer] := Module[{k},
  k = Floor[(m-1)/2];
  Sum[(-1)^i * i! / (2i+1), {i, 1, k}]
];

(* Compute Σ_m^alt mod 1/(m-1)! *)
ModFactorial[m_Integer] := Module[{sigma, modulus},
  sigma = ComputeBareSumAlt[m];
  modulus = 1/((m-1)!);
  Mod[sigma, modulus]
];

(* p-adic valuation of k! *)
PadicValFactorial[k_, p_] := Sum[Floor[k/p^j], {j, 1, Floor[Log[p, k] + 1]}];

(* Analyze excess powers systematically *)
AnalyzeExcessPowers[m_Integer] := Module[{result, den, fact, primorial, primorialFact, excessData, k},
  k = Floor[(m-1)/2];
  result = ModFactorial[m];

  If[result == 0,
    Return[<|"m" -> m, "isPrime" -> False, "isZero" -> True|>]
  ];

  den = Denominator[result];
  fact = FactorInteger[den];
  primorial = Product[Prime[i], {i, 1, PrimePi[m]}];
  primorialFact = FactorInteger[primorial];

  (* Compute excess for each prime *)
  excessData = Table[
    Module[{p, denPow, primPow, excess, vpK, vpM1},
      p = fact[[i, 1]];
      denPow = fact[[i, 2]];
      primPow = SelectFirst[primorialFact, #[[1]] == p &, {p, 0}][[2]];
      excess = denPow - primPow;

      (* Compute ν_p(k!) and ν_p((m-1)!) *)
      vpK = PadicValFactorial[k, p];
      vpM1 = PadicValFactorial[m-1, p];

      <|
        "prime" -> p,
        "denPower" -> denPow,
        "primorialPower" -> primPow,
        "excess" -> excess,
        "k" -> k,
        "vpK" -> vpK,
        "vpM1" -> vpM1
      |>
    ],
    {i, 1, Length[fact]}
  ];

  <|
    "m" -> m,
    "k" -> k,
    "isPrime" -> PrimeQ[m],
    "denominator" -> den,
    "excessData" -> excessData
  |>
];

(* Test for primes *)
primes = Select[Range[3, 23, 2], PrimeQ];

Print["=== EXCESS POWER ANALYSIS ==="];
Print[""];

results = Table[AnalyzeExcessPowers[p], {p, primes}];

Do[
  m = results[[i]]["m"];
  k = results[[i]]["k"];
  Print["m = ", m, ", k = ", k];
  Print[StringRepeat["-", 80]];
  Print["p | den pow | prim pow | excess | ν_p(k!) | ν_p((m-1)!)"];
  Print[StringRepeat["-", 80]];

  excessData = results[[i]]["excessData"];
  Do[
    d = excessData[[j]];
    Print[
      d["prime"], " | ",
      d["denPower"], " | ",
      d["primorialPower"], " | ",
      d["excess"], " | ",
      d["vpK"], " | ",
      d["vpM1"]
    ];
    , {j, 1, Length[excessData]}
  ];
  Print[""];
  , {i, 1, Length[results]}
];

(* Look for formula connecting excess to known quantities *)
Print["=== HYPOTHESIS TESTING ==="];
Print[""];

Do[
  m = results[[i]]["m"];
  k = results[[i]]["k"];
  excessData = results[[i]]["excessData"];

  Print["m = ", m, " (k = ", k, "):"]; Do[
    d = excessData[[j]];
    p = d["prime"];
    excess = d["excess"];
    vpK = d["vpK"];
    vpM1 = d["vpM1"];

    Print["  p=", p, ": excess=", excess,
      ", ν_p(k!)=", vpK,
      ", ν_p((m-1)!)=", vpM1];

    (* Check various hypotheses *)
    If[excess == vpK, Print["    ✓ excess = ν_p(k!)"]];
    If[excess == vpM1, Print["    ✓ excess = ν_p((m-1)!)"]];
    If[excess == vpM1 - 1, Print["    ✓ excess = ν_p((m-1)!) - 1"]];
    If[excess == vpK + vpM1, Print["    ✓ excess = ν_p(k!) + ν_p((m-1)!)"]];

    , {j, 1, Length[excessData]}
  ];
  Print[""];
  , {i, 1, Length[results]}
];

Print["=== END ==="];
