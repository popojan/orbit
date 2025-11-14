#!/usr/bin/env wolframscript
(* Test semiprimes with large q to see if pattern holds when m > p *)

Print["Testing Semiprimes with Large q (where m might exceed p)\n"];
Print[StringRepeat["=", 70], "\n"];

(* Generate semiprimes p*q where q is much larger than p *)
testCases = {
  {3, 17},   (* m ≈ 3 *)
  {3, 23},   (* m ≈ 3.8 *)
  {3, 31},   (* m ≈ 4.9 *)
  {3, 43},   (* m ≈ 5.7 *)
  {5, 23},   (* m ≈ 5.3 *)
  {5, 31},   (* m ≈ 6.2 *)
  {7, 31},   (* m ≈ 7.3 *)
  {7, 43}    (* m ≈ 8.6 *)
};

Do[
  Module[{n, m, sum, num, denom, vp, vpDenom},
    n = p * q;
    m = Floor[(Sqrt[n] - 1)/2];

    sum = Sum[
      (-1)^i * Pochhammer[1-n, i] * Pochhammer[1+n, i] / (2*i+1),
      {i, 1, m}
    ];

    num = Numerator[sum];
    denom = Denominator[sum];

    vp = IntegerExponent[num, p];
    vpDenom = IntegerExponent[denom, p];

    Print["p=", p, ", q=", q, ", n=", n];
    Print["  m = ", m, " (compare to p = ", p, ")"];
    Print["  m >= p? ", m >= p];
    Print["  ν_p(numerator) = ", vp];
    Print["  ν_p(denominator) = ", vpDenom];
    Print["  Difference = ", vp - vpDenom];
    Print["  Reduced denominator = ", denom / GCD[num, denom]];
    Print["  Equals p? ", denom / GCD[num, denom] == p];
    Print[];
  ],
  {case, testCases},
  {p, case[[1]]},
  {q, case[[2]]}
];

Print["Does the pattern ν_p(num) - ν_p(denom) = -1 hold even when m >= p?"];
