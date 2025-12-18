(* Fair comparison: computational cost per digit *)

Print["=== FAIR COMPARISON: COST PER DIGIT ===\n"];

(* Count basic operations (multiplications + additions) *)

Print["=== TAYLOR SERIES ==="];
Print["e = Σ 1/n!"];
Print["To compute n! from (n-1)!: 1 multiplication"];
Print["To get n terms: n multiplications total"];
Print["Digits achieved: ~n"];
Print["Cost: ~1 mult per digit\n"];

Print["=== OUR MONOTONE SERIES ==="];
Print["e = 1 + 4 Σ (4j+3)/(s_{2j-1} · s_{2j+1})"];
Print["Recurrence: s_n = (4n+2)·s_{n-1} + s_{n-2}"];
Print["Each s_n: 1 mult + 1 add from previous"];
Print["For k terms: need s_1, s_3, ..., s_{2k+1}"];
Print["That requires computing s_1 through s_{2k+1}: 2k+1 recurrence steps"];
Print["Plus: k divisions for the terms"];
Print["Total: ~3k operations for ~6k digits"];
Print["Cost: ~0.5 ops per digit\n"];

Print["=== BUT WAIT - WHAT ABOUT THE DENOMINATORS? ===\n"];

(* The s_n grow very fast - we need arbitrary precision arithmetic *)
s[0] = 1; s[1] = 7;
s[n_] := s[n] = (4 n + 2) s[n - 1] + s[n - 2];

Print["Size of s_n (digits):"];
Table[
  Print["s_", n, " has ", IntegerLength[s[n]], " digits"];
  , {n, {1, 5, 10, 15, 20}}
];

Print["\n=== THE REAL COST ==="];
Print["For D-digit accuracy:"];
Print["- Taylor: O(D) terms, each term has O(D) digit arithmetic"];
Print["- Our series: O(D/6) terms, but s_n has O(D) digits too!"];
Print[""];
Print["So the 'dirty trick' critique is PARTIALLY valid:"];
Print["We're not getting 6x speedup in raw operations."];
Print["We ARE getting 6x fewer TERMS (useful for rational approx)."];
Print[""];
Print["The REAL advantage: optimal rational approximations to e."];
Print["Our partial sums are BEST possible rationals of their size."];

Print["\n=== VERIFICATION: DENOMINATOR SIZES ===\n"];

(* Our monotone partial sums *)
sOdd[0] = 1;
sOdd[k_] := s[2 k - 1];
monotonePartial[n_] := 1 + 4 Sum[(4 j + 3)/(sOdd[j] sOdd[j + 1]), {j, 0, n}];

Print["Term\tDigits accuracy\tDenominator digits\tRatio"];
Table[
  partial = monotonePartial[k];
  denom = Denominator[partial];
  err = -Log10[Abs[N[partial - E, 100]]];
  denomDigits = IntegerLength[denom];
  Print[k, "\t", Round[err, 0.1], "\t\t", denomDigits, "\t\t\t",
        Round[err/denomDigits, 0.01]];
  , {k, 0, 8}
];

Print["\nRatio ≈ 2: we get ~2 digits of accuracy per digit of denominator"];
Print["This is OPTIMAL for continued fractions (Hurwitz theorem bound)"];
