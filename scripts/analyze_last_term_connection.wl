(* Analyze connection between fractional part and last term *)

ComputeBareSumAlt[m_Integer] := Module[{k},
  k = Floor[(m-1)/2];
  Sum[(-1)^i * i! / (2i+1), {i, 1, k}]
];

Print["Analyzing Connection to Last Term"];
Print[""];

primes = Select[Range[3, 43, 2], PrimeQ];

Print["m | k | FP_num | Last term | Last*k(m-1)! | Pattern"];
Print[StringRepeat["-", 90]];

Do[
  Module[{m, k, sigma, fpNum, lastTerm, lastTimesFactorial, lastModM, pattern},
    m = p;
    k = Floor[(m-1)/2];
    sigma = ComputeBareSumAlt[m];

    (* Fractional part numerator *)
    fpNum = Numerator[Mod[sigma * (m-1)!, 1]];

    (* Last term: (-1)^k · k! / (2k+1) *)
    lastTerm = (-1)^k * k! / (2*k + 1);

    (* Last term times (m-1)! *)
    lastTimesFactorial = lastTerm * (m-1)!;

    (* Last term times (m-1)! mod m *)
    lastModM = Mod[lastTimesFactorial, m];

    (* Check various patterns *)
    pattern = Which[
      fpNum == lastModM, "FP = last*(m-1)! mod m",
      fpNum == Mod[-lastModM, m], "FP = -last*(m-1)! mod m",
      fpNum == Mod[lastModM * Denominator[lastTerm], m], "Related to denom",
      True, "Unknown"
    ];

    Print[m, " | ", k, " | ", fpNum, " | ", N[lastTerm, 3], " | ",
      N[lastTimesFactorial, 3], " | ", pattern];
    Print["   Last*k(m-1)! mod m = ", lastModM,
      ", -last*(m-1)! mod m = ", Mod[-lastModM, m]];
  ],
  {p, primes}
];

Print[""];
Print["Deeper analysis: Compute sum WITHOUT last term"];
Print[""];

Print["m | FP with all terms | FP without last | Last contribution | Match?"];
Print[StringRepeat["-", 90]];

Do[
  Module[{m, k, sigmaFull, sigmaWithoutLast, fpFull, fpWithout, lastContrib},
    m = p;
    k = Floor[(m-1)/2];

    (* Full sum *)
    sigmaFull = Sum[(-1)^i * i! / (2i+1), {i, 1, k}];
    fpFull = Mod[sigmaFull * (m-1)!, 1];

    (* Sum without last term *)
    sigmaWithoutLast = If[k > 1, Sum[(-1)^i * i! / (2i+1), {i, 1, k-1}], 0];
    fpWithout = Mod[sigmaWithoutLast * (m-1)!, 1];

    (* Last term contribution *)
    lastContrib = Mod[fpFull - fpWithout, 1];

    Print[m, " | ", fpFull, " | ", fpWithout, " | ", lastContrib];
  ],
  {p, primes}
];
