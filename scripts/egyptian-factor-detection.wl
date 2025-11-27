(* Egyptian Fraction Factor Detection from S_∞ *)
(* CRITICAL TEST: S_∞ can be computed without knowing p, q *)
(* Does its Egyptian decomposition reveal factors? *)

Print["═══════════════════════════════════════════════════════════════"]
Print["   EGYPTIAN FRACTION DECOMPOSITION OF S_∞: FACTOR DETECTION?"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

(* Greedy Egyptian fraction algorithm *)
egyptianGreedy[r_] := Module[{result = {}, rem = r, unit},
  While[rem > 0 && Length[result] < 30,
    unit = Ceiling[1/rem];
    AppendTo[result, unit];
    rem = rem - 1/unit;
  ];
  result
]

(* Test semiprimes *)
testCases = {
  {3, 5}, {3, 7}, {3, 11}, {3, 13}, {3, 17}, {3, 19}, {3, 23},
  {5, 7}, {5, 11}, {5, 13}, {5, 17}, {5, 19}, {5, 23},
  {7, 11}, {7, 13}, {7, 17}, {7, 19}, {7, 23},
  {11, 13}, {11, 17}, {11, 19}, {11, 23},
  {13, 17}, {13, 19}, {13, 23},
  {17, 19}, {17, 23},
  {19, 23}
};

successCount = 0;
totalCount = Length[testCases];

Do[
  {p, q} = pq;
  n = p * q;

  (* S_∞ = (p-1)/p + (q-1)/q *)
  sInf = (p - 1)/p + (q - 1)/q;

  (* Egyptian decomposition *)
  ef = egyptianGreedy[sInf];

  (* Check GCDs *)
  gcds = GCD[#, n] & /@ ef;
  factors = Select[gcds, # > 1 && # < n &];

  If[Length[factors] > 0,
    successCount++;
    Print["n = ", n, " = ", p, " x ", q, ": S_inf = ", sInf];
    Print["  Egyptian denoms: ", Take[ef, Min[8, Length[ef]]], If[Length[ef] > 8, "...", ""]];
    Print["  GCDs: ", gcds];
    Print["  FACTORS FOUND: ", factors];
    Print[""],

    Print["n = ", n, " = ", p, " x ", q, ": NO non-trivial factors from Egyptian"]
  ],

  {pq, testCases}
];

Print[""]
Print["═══════════════════════════════════════════════════════════════"]
Print["SUMMARY: ", successCount, " / ", totalCount, " cases revealed factors"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

(* Now the critical question: is this cheaper than Wilson iteration? *)
Print["═══════════════════════════════════════════════════════════════"]
Print["                    COMPLEXITY ANALYSIS"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

Print["To use Egyptian fractions for factoring, we need S_∞."]
Print[""]
Print["Computing S_∞ via Wilson sum: O(sqrt(n)) iterations"]
Print["  Each iteration: O(i) multiplications for product"]
Print["  Total: O(sqrt(n)^2) = O(n) naive, O(sqrt(n) log n) with modular"]
Print[""]

Print["Egyptian decomposition of S_∞: O(log n) unit fractions"]
Print["  Each step: one division, one subtraction"]
Print["  Total: O(log n) operations"]
Print[""]

Print["THE CATCH: We still need S_∞ first!"]
Print["  Computing S_∞ = O(sqrt(n)) iterations minimum"]
Print["  Egyptian decomposition adds only O(log n)"]
Print["  Total: O(sqrt(n)) + O(log n) = O(sqrt(n))"]
Print[""]

Print["CONCLUSION: Egyptian decomposition is a CHEAP POST-PROCESSING step"]
Print["            but doesn't help compute S_∞ faster."]
Print[""]

(* Alternative: Can we compute Egyptian decomposition of S_∞ directly *)
(* without first computing S_∞? *)

Print["═══════════════════════════════════════════════════════════════"]
Print["         ALTERNATIVE: DIRECT EGYPTIAN DECOMPOSITION?"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

Print["Question: Can we compute Egyptian denominators of S_∞ directly?"]
Print[""]

Print["S_∞ = (p-1)/p + (q-1)/q = (2pq - p - q)/(pq)"]
Print["    = (2n - (p+q))/n"]
Print[""]

Print["First Egyptian denominator: ceil(n / (2n - p - q))"]
Print["  = ceil(1 / (2 - (p+q)/n))")
Print[""]

Print["For balanced semiprime p ~ q ~ sqrt(n):"]
Print["  p + q ~ 2 sqrt(n)"]
Print["  S_∞ ~ 2 - 2/sqrt(n) ~ 2"]
Print["  First denominator ~ 1"]
Print[""]

(* Test *)
n = 143;
{p, q} = {11, 13};
sInf = (p-1)/p + (q-1)/q;

Print["For n = 143:"]
Print["  S_∞ = ", sInf, " = ", N[sInf]]
Print["  First Egyptian denom = ceil(1/S_∞) = ", Ceiling[1/sInf]]
Print[""]

Print["The first unit fraction is 1 (since S_∞ > 1)."]
Print["Remainder: S_∞ - 1 = ", sInf - 1]
Print["Second denom = ceil(1/(S_∞ - 1)) = ", Ceiling[1/(sInf - 1)]]
Print[""]

(* The Egyptian algorithm doesn't provide a shortcut *)
(* because we still need to know S_∞ to start *)

Print["NO SHORTCUT FOUND: Egyptian decomposition requires S_∞ as input."]
