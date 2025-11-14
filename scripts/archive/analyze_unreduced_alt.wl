#!/usr/bin/env wolframscript
(* Analyze the unreduced form of alt[m] *)

Print["======================================================================"];
Print["Understanding the Chaos-to-Order Transition"];
Print["======================================================================\n"];

alt[m_] := Sum[(-1)^k * k!/(2k+1), {k, 1, Floor[(m-1)/2]}];

Print["For small primes, examine unreduced alt[m] vs reduced form:\n"];

primes = {3, 5, 7, 11, 13};

Do[
  Module[{h, altValue, num, denom, gcd, result, resultNum, resultDenom},
    h = (m-1)/2;

    (* Unreduced alt[m] *)
    altValue = alt[m];
    num = Numerator[altValue];
    denom = Denominator[altValue];
    gcd = GCD[num, denom];

    (* Reduced form after Mod *)
    result = Mod[altValue, 1/(m-1)!];
    resultNum = Numerator[result];
    resultDenom = Denominator[result];

    Print["m = ", m, " (h = ", h, ")"];
    Print["  Unreduced alt[m]: ", num, "/", denom];
    Print["  GCD: ", gcd];
    Print["  Reduced to: ", num/gcd, "/", denom/gcd];
    Print["  After Mod[·, 1/", (m-1)!, "]: ", resultNum, "/", resultDenom];
    Print["  Denominator factorization: ", FactorInteger[resultDenom]];

    (* Check the transformation *)
    Print["  Key question: How does ", num, "/", denom, " become 1/", resultDenom, "?"];

    (* Compute: (num * (m-1)!) / denom *)
    transformed = (num * (m-1)!) / denom;
    transformedReduced = transformed / GCD[Numerator[transformed], Denominator[transformed]];

    Print["  (num × (m-1)!) / denom = ", Numerator[transformed], "/", Denominator[transformed]];
    Print["  Reduced: ", Numerator[transformedReduced], "/", Denominator[transformedReduced]];

    (* Check if this matches the Mod result structure *)
    Print["  Does (m-1)!/resultDenom equal reduced denominator? ",
          (m-1)!/resultDenom == Denominator[transformedReduced]];

    Print[];
  ],
  {m, primes}
];

Print["======================================================================"];
Print["Pattern Investigation: What makes numerator become 1?"];
Print["======================================================================\n"];

Print["For prime m, the transition is:");
Print["  alt[m] = A/B  (chaotic A, predictable B)");
Print["  Mod[A/B, 1/(m-1)!] = 1/D");
Print["\nThis means: (A × (m-1)!)/B ≡ (m-1)!/D (mod 1)");
Print["Or: A × (m-1)! = B × (m-1)!/D + integer");
Print["Simplifying: A × D = B × k + (m-1)! for some integer k\n");

Print["Testing this relationship:\n"];

Do[
  Module[{altValue, A, B, result, D, k},
    altValue = alt[m];
    A = Numerator[altValue];
    B = Denominator[altValue];

    result = Mod[altValue, 1/(m-1)!];
    D = Denominator[result];

    (* A × D should equal B × k for some k close to (m-1)! *)
    k = (A * D - (m-1)!) / B;

    Print["m=", m, ": A×D - (m-1)! = B×", k];
    Print["  Is k an integer? ", IntegerQ[k]];
  ],
  {m, primes}
];

Print["\nDone!"];
