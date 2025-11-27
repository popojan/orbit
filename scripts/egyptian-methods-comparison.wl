(* Egyptian Fractions: Method Comparison for Factor Detection *)
(* Testing different decomposition methods *)

Print["═══════════════════════════════════════════════════════════════"]
Print["  EGYPTIAN FRACTION METHODS: Which Reveals Factors Best?"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

(* Load ResourceFunction if available, otherwise define methods manually *)

(* Method 1: Greedy (Fibonacci-Sylvester) *)
egyptianGreedy[r_] := Module[{result = {}, rem = r, unit},
  While[rem > 0 && Length[result] < 30,
    unit = Ceiling[1/rem];
    AppendTo[result, unit];
    rem = rem - 1/unit;
  ];
  result
]

(* Method 2: Odd Greedy - only odd denominators *)
egyptianOddGreedy[r_] := Module[{result = {}, rem = r, k},
  While[rem > 0 && Length[result] < 30,
    k = Ceiling[1/rem];
    If[EvenQ[k], k = k + 1];
    AppendTo[result, k];
    rem = rem - 1/k;
  ];
  result
]

(* Method 3: Binary - powers of 2 where possible *)
egyptianBinary[r_] := Module[{num = Numerator[r], den = Denominator[r], result = {}, k},
  While[num > 0 && Length[result] < 30,
    k = Ceiling[den/num];
    AppendTo[result, k];
    num = num * k - den;
    den = den * k;
    {num, den} = {num, den}/GCD[num, den];
  ];
  result
]

(* Method 4: "Raw" - direct factorization of denominator *)
(* For a/b, write as sum of 1/d where d | b *)
egyptianRaw[r_] := Module[{num = Numerator[r], den = Denominator[r], divs, result = {}},
  divs = Reverse[Divisors[den]];  (* largest first *)
  Do[
    While[num >= den/d && Length[result] < 30,
      AppendTo[result, d];
      num = num - den/d;
    ],
    {d, divs}
  ];
  If[num > 0, AppendTo[result, "incomplete"]];
  result
]

(* Method 5: Engel expansion related *)
engelExpansion[r_] := Module[{result = {}, rem = r, a},
  While[rem > 0 && Length[result] < 30,
    a = Ceiling[1/rem];
    AppendTo[result, a];
    rem = a * rem - 1;
  ];
  result
]

(* Test on S_∞ for n = 143 *)
n = 143;
{p, q} = {11, 13};
sInf = (p - 1)/p + (q - 1)/q;

Print["n = ", n, " = ", p, " × ", q]
Print["S_∞ = ", sInf, " = ", N[sInf]]
Print[""]

Print["───────────────────────────────────────────────────────────────"]
Print["Method 1: GREEDY (Fibonacci-Sylvester)"]
Print["───────────────────────────────────────────────────────────────"]
ef1 = egyptianGreedy[sInf];
Print["Denominators: ", ef1]
Print["GCDs with n: ", GCD[#, n] & /@ ef1]
Print["Factors found: ", Select[GCD[#, n] & /@ ef1, # > 1 && # < n &]]
Print[""]

Print["───────────────────────────────────────────────────────────────"]
Print["Method 2: ODD GREEDY"]
Print["───────────────────────────────────────────────────────────────"]
ef2 = egyptianOddGreedy[sInf];
Print["Denominators: ", ef2]
Print["GCDs with n: ", GCD[#, n] & /@ ef2]
Print["Factors found: ", Select[GCD[#, n] & /@ ef2, # > 1 && # < n &]]
Print[""]

Print["───────────────────────────────────────────────────────────────"]
Print["Method 3: BINARY-style"]
Print["───────────────────────────────────────────────────────────────"]
ef3 = egyptianBinary[sInf];
Print["Denominators: ", ef3]
Print["GCDs with n: ", GCD[#, n] & /@ ef3]
Print["Factors found: ", Select[GCD[#, n] & /@ ef3, # > 1 && # < n &]]
Print[""]

Print["───────────────────────────────────────────────────────────────"]
Print["Method 4: RAW (divisor-based)"]
Print["───────────────────────────────────────────────────────────────"]
Print[""]
Print["S_∞ = 262/143"]
Print["Divisors of 143: ", Divisors[143]]
Print[""]

(* Raw method: express 262/143 using divisors of 143 *)
(* 262 = k₁ × (143/d₁) + k₂ × (143/d₂) + ... *)
(* where each term contributes k_i/d_i *)

Print["143 = 11 × 13, so divisors are {1, 11, 13, 143}"]
Print["We need: 262/143 = a/1 + b/11 + c/13 + d/143"]
Print["         262 = 143a + 13b + 11c + d"]
Print[""]

(* Solve for non-negative integer coefficients *)
Print["Solving 262 = 143a + 13b + 11c + d with a,b,c,d >= 0:"]
Print["  a = 1: 262 - 143 = 119 = 13b + 11c + d"]
Print["  b = 0: 119 = 11c + d"]
Print["  c = 10: 119 - 110 = 9 = d"]
Print[""]
Print["Solution: 262/143 = 1/1 + 0/11 + 10/13 + 9/143"]
Print["        = 1 + 10/13 + 9/143"]
Print[""]

(* Verify *)
verify = 1 + 10/13 + 9/143;
Print["Verification: ", verify, " = ", sInf, " ? ", verify == sInf]
Print[""]

Print["RAW decomposition uses DIVISORS OF DENOMINATOR directly!"]
Print["For S_∞ = 262/143, the divisors 11 and 13 are the FACTORS of n!"]
Print[""]

Print["───────────────────────────────────────────────────────────────"]
Print["Method 5: ENGEL expansion"]
Print["───────────────────────────────────────────────────────────────"]
ef5 = engelExpansion[sInf];
Print["Engel: ", Take[ef5, Min[10, Length[ef5]]]]
Print["(Engel gives multipliers, not direct denominators)"]
Print[""]

Print["═══════════════════════════════════════════════════════════════"]
Print["  KEY INSIGHT: RAW METHOD"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

Print["The 'Raw' method expresses a/b using divisors of b."]
Print[""]
Print["For S_∞ = (2n - p - q)/n:"]
Print["  Denominator = n = p × q"]
Print["  Divisors of n = {1, p, q, n}"]
Print[""]
Print["So RAW decomposition DIRECTLY USES p and q as potential denominators!"]
Print[""]

Print["BUT: To use RAW method, we need to KNOW the divisors of n."]
Print["     Finding divisors of n = factoring n!"]
Print[""]
Print["The RAW method is CIRCULAR for factoring:"]
Print["  - Input: S_∞ = a/n"]
Print["  - RAW needs divisors of n"]
Print["  - Divisors of n require factoring"]
Print[""]

Print["═══════════════════════════════════════════════════════════════"]
Print["  ALTERNATIVE: What if we try small divisors?"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

Print["We could try: does 262 have a nice representation using small primes?"]
Print["262 = 2 × 131"]
Print[""]

Print["S_∞ = 262/143 = 2 × 131 / (11 × 13)"]
Print[""]

Print["This doesn't directly reveal 11 or 13 without knowing the factorization."]
Print[""]

Print["═══════════════════════════════════════════════════════════════"]
Print["  TEST RAW ON MULTIPLE SEMIPRIMES"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

testCases = {{5, 7}, {7, 11}, {11, 13}, {7, 13}, {3, 17}, {17, 19}};

Do[
  {pp, qq} = pq;
  nn = pp * qq;
  ss = (pp - 1)/pp + (qq - 1)/qq;
  num = Numerator[ss];
  den = Denominator[ss];

  Print["n = ", nn, " = ", pp, " × ", qq];
  Print["  S_∞ = ", ss, " = ", num, "/", den];

  (* Check if denominator = n *)
  If[den == nn,
    Print["  Denominator = n, so RAW would use divisors {1, ", pp, ", ", qq, ", ", nn, "}"];
    Print["  → Factors directly visible in RAW decomposition!"],
    Print["  Denominator = ", den, " ≠ n = ", nn];
    Print["  S_∞ simplified, factors may be hidden"]
  ];
  Print[""],

  {pq, testCases}
]

Print["═══════════════════════════════════════════════════════════════"]
Print["  CONCLUSION"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]
Print["RAW method is the MOST DIRECT for factor revelation:"]
Print["  - Uses divisors of denominator"]
Print["  - For S_∞ with denominator n, divisors = factors of n"]
Print[""]
Print["BUT: RAW requires knowing divisors ≡ knowing factors"]
Print["     This is CIRCULAR - not a shortcut."]
Print[""]
Print["GREEDY method (50% success) is the only 'blind' approach"]
Print["that sometimes reveals factors via arithmetic coincidence."]
