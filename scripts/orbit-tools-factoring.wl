(* Can Our Orbit Tools Help with Factoring? *)
(* Egyptian fractions, Chebyshev CF, sqrt rationalization *)

Print["=== ORBIT TOOLS vs FACTORING ==="]
Print[""]

n = 143;
{p, q} = {11, 13};

Print["Target: n = ", n, " = ", p, " × ", q]
Print[""]

Print["════════════════════════════════════════════════════════════"]
Print["1. EGYPTIAN FRACTIONS for S_∞"]
Print["════════════════════════════════════════════════════════════"]
Print[""]

(* S_∞ = (p-1)/p + (q-1)/q *)
sInf = (p - 1)/p + (q - 1)/q;
Print["S_∞ = ", sInf, " = ", N[sInf, 10]]
Print[""]

(* Egyptian fraction representation of S_∞ *)
(* S_∞ = 262/143 = 1 + 119/143 *)

(* Greedy algorithm for Egyptian fractions *)
egyptianGreedy[r_] := Module[{result = {}, rem = r, unit},
  While[rem > 0 && Length[result] < 20,
    unit = Ceiling[1/rem];
    AppendTo[result, unit];
    rem = rem - 1/unit;
  ];
  result
]

ef = egyptianGreedy[sInf];
Print["Egyptian fraction decomposition of S_∞:"]
Print["  S_∞ = ", StringJoin[Riffle[ToString /@ (1/# & /@ ef), " + "]]]
Print["  Denominators: ", ef]
Print[""]

(* Check if denominators reveal factors *)
Print["GCD of denominators with n:"]
Do[
  Print["  gcd(", d, ", ", n, ") = ", GCD[d, n]],
  {d, ef}
]
Print[""]

Print["════════════════════════════════════════════════════════════"]
Print["2. CHEBYSHEV-BASED CF (backwards)"]
Print["════════════════════════════════════════════════════════════"]
Print[""]

(* Our Chebyshev method expresses sqrt(n) via T_k, U_k *)
(* sqrt(n) ≈ T_k(x)/U_{k-1}(x) for appropriate x *)

(* The key identity: T_k(cosh θ) = cosh(kθ) *)
(* For sqrt(n): n = (e^θ + e^{-θ})^2/4 leads to θ = log(sqrt(n) + sqrt(n-1)) *)

theta = Log[Sqrt[n] + Sqrt[n - 1]];
Print["θ = log(√n + √(n-1)) = ", N[theta, 10]]
Print[""]

(* cosh(θ) = (√n + √(n-1))/2 + (√n - √(n-1))/2 = √n *)
Print["cosh(θ) = √n = ", N[Sqrt[n], 10]]
Print[""]

(* T_k(√n) / U_{k-1}(√n) approximates... what? *)
Do[
  tk = ChebyshevT[k, Sqrt[n]];
  uk = ChebyshevU[k - 1, Sqrt[n]];
  ratio = tk/uk;
  Print["  k=", k, ": T_", k, "(√n)/U_", k-1, "(√n) = ", N[ratio, 8]],
  {k, 1, 5}
]
Print[""]

Print["════════════════════════════════════════════════════════════"]
Print["3. HALF-FACTORIAL / PRIMORIAL CONNECTION"]
Print["════════════════════════════════════════════════════════════"]
Print[""]

(* Our formula uses Product[n² - j²] which relates to factorials *)
(* Primorial: p# = product of primes up to p *)

Print["Primorials and factor detection:"]
Print["  11# = ", Times @@ Select[Range[11], PrimeQ], " = 2310"]
Print["  13# = ", Times @@ Select[Range[13], PrimeQ], " = 30030"]
Print[""]

(* GCD of primorial with n *)
Print["gcd(p#, n) for various p:"]
Do[
  primorial = Times @@ Select[Range[pp], PrimeQ];
  g = GCD[primorial, n];
  If[g > 1, Print["  gcd(", pp, "#, ", n, ") = ", g, " ← FACTOR!"],
            Print["  gcd(", pp, "#, ", n, ") = ", g]],
  {pp, {5, 7, 11, 13, 17}}
]
Print[""]

(* This is just trial division in disguise! *)

Print["════════════════════════════════════════════════════════════"]
Print["4. SQRT RATIONALIZATION"]
Print["════════════════════════════════════════════════════════════"]
Print[""]

(* Our sqrt rationalization: √n = a/b + c/d × √m *)
(* For semiprime n = pq, can we express √n in terms of √p or √q? *)

Print["√", n, " = ", N[Sqrt[n], 10]]
Print[""]

(* Factorization would give: √(pq) = √p × √q *)
(* But this requires knowing p, q! *)

(* What about rational approximations via our method? *)
(* CF convergents of √n: *)
cfSqrt = ContinuedFraction[Sqrt[n], 10];
Print["CF(√", n, ") = ", cfSqrt]
Print[""]

(* Our Egyptian-style decomposition of √n - floor(√n)? *)
fracPart = Sqrt[n] - Floor[Sqrt[n]];
Print["Fractional part of √n: ", N[fracPart, 10]]
Print[""]

efSqrt = egyptianGreedy[fracPart];
Print["Egyptian decomposition of {√n}:"]
Print["  Denominators: ", Take[efSqrt, Min[Length[efSqrt], 10]]]
Print[""]

Print["GCD of these denominators with n:"]
Do[
  Print["  gcd(", d, ", ", n, ") = ", GCD[d, n]],
  {d, Take[efSqrt, Min[Length[efSqrt], 5]]}
]
Print[""]

Print["════════════════════════════════════════════════════════════"]
Print["5. THE KEY QUESTION: Can Orbit tools provide NEW ANGLE?"]
Print["════════════════════════════════════════════════════════════"]
Print[""]

(* Our S_∞ = (p-1)/p + (q-1)/q has a specific structure *)
(* It's a sum of "almost 1" fractions *)

Print["S_∞ = (p-1)/p + (q-1)/q"]
Print["    = (1 - 1/p) + (1 - 1/q)"]
Print["    = 2 - (1/p + 1/q)"]
Print["    = 2 - (p+q)/(pq)"]
Print[""]

(* Egyptian fraction of 1/p + 1/q *)
sumInvPQ = 1/p + 1/q;
Print["1/p + 1/q = ", sumInvPQ, " = ", N[sumInvPQ, 10]]
Print[""]

efInv = egyptianGreedy[sumInvPQ];
Print["Egyptian decomposition of 1/p + 1/q:"]
Print["  ", StringJoin[Riffle[("1/" <> ToString[#]) & /@ efInv, " + "]]]
Print["  Denominators: ", efInv]
Print[""]

(* Interesting! 1/11 + 1/13 = 24/143 *)
(* Egyptian: 1/6 + 1/858 = 143/858 + 1/858 = 144/858 ≠ 24/143 *)
(* Let me check... *)
Print["Verification: ", 1/6 + 1/858, " vs ", sumInvPQ]
Print["  Match: ", 1/6 + 1/858 == sumInvPQ]
Print[""]

(* So Egyptian gives us denominators 6, 858 *)
(* gcd(6, 143) = 1, gcd(858, 143) = 11! *)
Print["gcd(858, 143) = ", GCD[858, 143], " ← FACTOR!"]
Print[""]

Print["════════════════════════════════════════════════════════════"]
Print["6. EGYPTIAN FRACTION FACTOR DETECTION?"]
Print["════════════════════════════════════════════════════════════"]
Print[""]

Print["Hypothesis: Egyptian decomposition of (p+q)/n may reveal factors"]
Print[""]

(* Test on more semiprimes *)
testCases = {{5, 7}, {7, 11}, {11, 13}, {7, 13}, {5, 11}, {3, 17}, {7, 17}};

Do[
  {pp, qq} = pq;
  nn = pp * qq;
  sumInv = 1/pp + 1/qq;  (* = (p+q)/n *)
  ef2 = egyptianGreedy[sumInv];
  gcds = GCD[#, nn] & /@ ef2;
  nonTrivial = Select[gcds, # > 1 &];

  Print["n = ", nn, " = ", pp, " x ", qq];
  Print["  1/p + 1/q = ", sumInv];
  Print["  Egyptian denominators: ", ef2];
  Print["  GCDs with n: ", gcds];
  If[Length[nonTrivial] > 0,
    Print["  NON-TRIVIAL: ", nonTrivial, " <- factors revealed!"],
    Print["  No factors found"]
  ];
  Print[""],

  {pq, testCases}
]
