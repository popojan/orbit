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
    Module[{p, denPow, primPow, excess, vp_k_factorial, vp_2kp1_doublefact},
      p = fact[[i, 1]];
      denPow = fact[[i, 2]];
      primPow = SelectFirst[primorialFact, #[[1]] == p &, {p, 0}][[2]];
      excess = denPow - primPow;

      (* Compute ν_p(k!) *)
      vp_k_factorial = Sum[Floor[k/p^j], {j, 1, Floor[Log[p, k] + 1]}];

      (* Compute ν_p((2k+1)!!) *)
      vp_2kp1_doublefact = Sum[Floor[(2*k+1)/p^j] - Floor[k/p^j], {j, 1, Floor[Log[p, 2*k+1] + 1]}];

      <|
        "prime" -> p,
        "denPower" -> denPow,
        "primorialPower" -> primPow,
        "excess" -> excess,
        "k" -> k,
        "ν_p(k!)" -> vp_k_factorial,
        "ν_p((2k+1)!!)" -> vp_2kp1_doublefact,
        "ν_p((m-1)!)" -> Sum[Floor[(m-1)/p^j], {j, 1, Floor[Log[p, m-1] + 1]}]
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
primes = Select[Range[3, 31, 2], PrimeQ];

Print["=== EXCESS POWER ANALYSIS ==="];
Print[""];

results = Table[AnalyzeExcessPowers[p], {p, primes}];

Do[
  m = results[[i]]["m"];
  k = results[[i]]["k"];
  Print["m = ", m, ", k = ", k];
  Print[StringRepeat["-", 100]];
  Print["prime | den pow | prim pow | excess | ν_p(k!) | ν_p((2k+1)!!) | ν_p((m-1)!)"];
  Print[StringRepeat["-", 100]];

  excessData = results[[i]]["excessData"];
  Do[
    d = excessData[[j]];
    Print[
      d["prime"], " | ",
      d["denPower"], " | ",
      d["primorialPower"], " | ",
      d["excess"], " | ",
      d["ν_p(k!)"], " | ",
      d["ν_p((2k+1)!!)"], " | ",
      d["ν_p((m-1)!)"]
    ];
    , {j, 1, Length[excessData]}
  ];
  Print[""];
  , {i, 1, Min[8, Length[results]]}
];

(* Look for formula connecting excess to known quantities *)
Print["=== HYPOTHESIS TESTING ==="];
Print[""];
Print["Testing if excess = ν_p(k!) or ν_p((2k+1)!!) or ν_p((m-1)!) ..."];
Print[""];

Do[
  m = results[[i]]["m"];
  k = results[[i]]["k"];
  excessData = results[[i]]["excessData"];

  Print["m = ", m, ":"];
  Do[
    d = excessData[[j]];
    p = d["prime"];
    excess = d["excess"];
    vp_k = d["ν_p(k!)"];
    vp_2kp1 = d["ν_p((2k+1)!!)"];
    vp_m1 = d["ν_p((m-1)!)"];

    Print["  p=", p, ": excess=", excess,
      ", ν_p(k!)=", vp_k,
      ", ν_p((2k+1)!!)=", vp_2kp1,
      ", ν_p((m-1)!)=", vp_m1];

    (* Check various hypotheses *)
    If[excess == vp_k, Print["    ✓ excess = ν_p(k!)"]];
    If[excess == vp_2kp1, Print["    ✓ excess = ν_p((2k+1)!!)"]];
    If[excess == vp_m1, Print["    ✓ excess = ν_p((m-1)!)"]];
    If[excess == vp_m1 - 1, Print["    ✓ excess = ν_p((m-1)!) - 1"]];

    , {j, 1, Length[excessData]}
  ];
  Print[""];
  , {i, 1, Min[6, Length[results]]}
];

Print["=== END ==="];
