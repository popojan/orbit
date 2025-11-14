#!/usr/bin/env wolframscript
(* Compare reduced vs unreduced numerators *)

Print["Reduced vs Unreduced Numerator Comparison\n"];
Print[StringRepeat["=", 70], "\n"];

AnalyzeBoth[n_] := Module[{p, q, m, D, N, gcd, Nred, Dred, L},
  {p, q} = FactorInteger[n][[All, 1]];
  m = Floor[(Sqrt[n] - 1)/2];

  (* Unreduced: compute with LCM denominator *)
  D = LCM @@ Table[2*i+1, {i, 1, m}];
  N = Sum[(-1)^i * Pochhammer[1-n, i] * Pochhammer[1+n, i] * D/(2*i+1),
          {i, 1, m}];

  (* Reduced: compute directly *)
  sum = Sum[(-1)^i * Pochhammer[1-n, i] * Pochhammer[1+n, i] / (2*i+1),
            {i, 1, m}];
  Nred = Numerator[sum];
  Dred = Denominator[sum];
  gcd = GCD[N, D];

  Print["n = ", n, " = ", p, " × ", q, "  (m = ", m, ")\n"];

  Print["UNREDUCED FORM:"];
  Print["  Denominator D = ", D, "  (D = lcm{3,5,...,", 2*m+1, "})"];
  Print["  Numerator N = ", N];
  Print["  ν_p(D) = ", IntegerExponent[D, p]];

  If[IntegerExponent[D, p] == 1,
    L = D/p;
    Print["  D = p·L where L = ", L, " (coprime to p)"];
    Print["  N mod p = ", Mod[N, p]];
    Print["  L mod p = ", Mod[L, p]];
    Print["  L^(-1) mod p = ", PowerMod[L, -1, p]];
  ];

  Print["\nREDUCED FORM:"];
  Print["  N_red = ", Nred];
  Print["  D_red = ", Dred];
  Print["  gcd(N,D) = ", gcd];
  Print["  Check: N/gcd = ", N/gcd, " = N_red? ", N/gcd == Nred];
  Print["  Check: D/gcd = ", D/gcd, " = D_red? ", D/gcd == Dred];

  Print["\nCONGRUENCE CHECK:"];
  Print["  N_red mod p = ", Mod[Nred, p]];
  Print["  p-1 = ", p-1];
  Print["  N_red ≡ (p-1) mod p? ", Mod[Nred, p] == p-1];

  Print["\nRELATIONSHIP:"];
  Print["  N_red = N/L (since gcd = L)"];
  Print["  So: N_red ≡ N·L^(-1) (mod p)"];
  If[IntegerExponent[D, p] == 1,
    Print["  Check: ", Mod[N, p], " · ", PowerMod[L, -1, p],
          " ≡ ", Mod[N * PowerMod[L, -1, p], p], " (mod p)"];
    Print["  Matches N_red mod p? ",
          Mod[N * PowerMod[L, -1, p], p] == Mod[Nred, p]];
  ];

  Print["\n", StringRepeat["-", 70], "\n"];
];

(* Test several semiprimes *)
semiprimes = {15, 21, 35, 55, 77, 91};

Do[AnalyzeBoth[n], {n, semiprimes}];

Print[StringRepeat["=", 70]];
Print["SUMMARY:\n"];
Print["The REDUCED numerator N_red always satisfies N_red ≡ (p-1) mod p."];
Print["The UNREDUCED numerator N satisfies N ≡ N_red · L (mod p),"];
Print["where D = p·L is the unreduced denominator."];
