(* Orbit Sqrt Methods for Factoring *)
(* Can our Pell/Chebyshev/Egypt sqrt tools reveal factors? *)

<< Orbit`

Print["═══════════════════════════════════════════════════════════════"]
Print["  ORBIT SQRT METHODS vs FACTORING"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

n = 143;
{p, q} = {11, 13};

Print["n = ", n, " = ", p, " × ", q]
Print["√n = ", N[Sqrt[n], 10]]
Print[""]

(* 1. Pell Solution *)
Print["───────────────────────────────────────────────────────────────"]
Print["1. PELL SOLUTION"]
Print["───────────────────────────────────────────────────────────────"]

sol = PellSolution[n];
{xPell, yPell} = {x, y} /. sol;
Print["Pell equation x² - ", n, "y² = 1:"]
Print["  x = ", xPell]
Print["  y = ", yPell]
Print["  Verification: ", xPell^2, " - 143×", yPell^2, " = ", xPell^2 - n*yPell^2]
Print[""]

(* Check GCDs *)
Print["GCDs with n:"]
Print["  gcd(x, n) = gcd(", xPell, ", ", n, ") = ", GCD[xPell, n]]
Print["  gcd(y, n) = gcd(", yPell, ", ", n, ") = ", GCD[yPell, n]]
Print["  gcd(x-1, n) = gcd(", xPell - 1, ", ", n, ") = ", GCD[xPell - 1, n]]
Print["  gcd(x+1, n) = gcd(", xPell + 1, ", ", n, ") = ", GCD[xPell + 1, n]]
Print[""]

(* 2. Egypt sqrt approximation *)
Print["───────────────────────────────────────────────────────────────"]
Print["2. EGYPT SQRT (FactorialTerm series)"]
Print["───────────────────────────────────────────────────────────────"]

Print["Starting point: (x-1)/y = ", (xPell - 1)/yPell]
Print[""]

Print["FactorialTerm contributions:"]
xm1 = xPell - 1;
Do[
  ft = FactorialTerm[xm1, j];
  ftNum = Numerator[ft];
  ftDen = Denominator[ft];
  Print["  j=", j, ": ", ft, " = ", N[ft, 6]];
  Print["    gcd(num, n) = ", GCD[ftNum, n], ", gcd(den, n) = ", GCD[ftDen, n]],
  {j, 1, 6}
]
Print[""]

(* 3. Chebyshev Terms *)
Print["───────────────────────────────────────────────────────────────"]
Print["3. CHEBYSHEV TERMS"]
Print["───────────────────────────────────────────────────────────────"]

Print["ChebyshevTerm contributions:"]
Do[
  ct = ChebyshevTerm[xm1, k];
  ctNum = Numerator[ct];
  ctDen = Denominator[ct];
  Print["  k=", k, ": ", ct, " = ", N[ct, 6]];
  Print["    gcd(num, n) = ", GCD[ctNum, n], ", gcd(den, n) = ", GCD[ctDen, n]],
  {k, 1, 6}
]
Print[""]

(* 4. Cumulative sqrt approximation *)
Print["───────────────────────────────────────────────────────────────"]
Print["4. CUMULATIVE SQRT APPROXIMATION"]
Print["───────────────────────────────────────────────────────────────"]

base = (xPell - 1)/yPell;
Print["Base: ", base]
Print[""]

cumSum = base;
Do[
  cumSum = cumSum * (1 + FactorialTerm[xm1, j]);
  cumNum = Numerator[cumSum];
  cumDen = Denominator[cumSum];
  Print["After j=", j, ": approx = ", N[cumSum, 10]];
  Print["  Numerator = ", cumNum];
  Print["  gcd(num, n) = ", GCD[cumNum, n], ", gcd(den, n) = ", GCD[cumDen, n]];

  (* Check if approximation reveals factors *)
  approxSq = cumSum^2;
  diff = approxSq - n;
  diffNum = Numerator[diff];
  Print["  approx² - n = ", diff];
  Print["  gcd(num(approx² - n), n) = ", GCD[diffNum, n]],

  {j, 1, 4}
]
Print[""]

(* 5. Direct sqrt and factor relationship *)
Print["───────────────────────────────────────────────────────────────"]
Print["5. SQRT AND FACTOR RELATIONSHIP"]
Print["───────────────────────────────────────────────────────────────"]

Print["For n = pq:"]
Print["  √n = √(pq) = √p × √q"]
Print["  p < √n < q  (since p < q)"]
Print[""]

Print["Bounds:"]
Print["  p = ", p, " < √143 = ", N[Sqrt[n], 6], " < q = ", q]
Print[""]

Print["Fermat's method uses x² - n = y² to find factors."]
Print["If x² - n = y², then n = (x-y)(x+y) and factors are gcd(x±y, n)."]
Print[""]

(* Try with Pell-derived values *)
Print["Testing Pell-derived combinations:"]

(* x² ≡ 1 (mod n) from Pell *)
Print["From Pell: ", xPell, "² ≡ ", Mod[xPell^2, n], " (mod ", n, ")")
Print["  Since x² - 143y² = 1, we have x² ≡ 1 (mod 143)")
Print["  So gcd(x-1, n) and gcd(x+1, n) may reveal factors"]
Print[""]

g1 = GCD[xPell - 1, n];
g2 = GCD[xPell + 1, n];
Print["  gcd(", xPell, " - 1, 143) = gcd(", xPell - 1, ", 143) = ", g1]
Print["  gcd(", xPell, " + 1, 143) = gcd(", xPell + 1, ", 143) = ", g2]

If[g1 > 1 && g1 < n,
  Print["  FACTOR FOUND: ", g1, "!"]
];
If[g2 > 1 && g2 < n,
  Print["  FACTOR FOUND: ", g2, "!"]
];
Print[""]

(* 6. Multiple Pell solutions *)
Print["───────────────────────────────────────────────────────────────"]
Print["6. POWERS OF FUNDAMENTAL PELL SOLUTION"]
Print["───────────────────────────────────────────────────────────────"]

Print["Higher powers of fundamental solution:"]
Print["If (x₁, y₁) is fundamental, then (x_k, y_k) = (x₁ + y₁√n)^k"]
Print[""]

fund = xPell + yPell * Sqrt[n];
Do[
  power = fund^k // Expand;
  xk = power /. Sqrt[n] -> 0;
  yk = Coefficient[power, Sqrt[n]];
  g1k = GCD[xk - 1, n];
  g2k = GCD[xk + 1, n];
  Print["k=", k, ": x = ", xk, ", y = ", yk];
  Print["  gcd(x-1, n) = ", g1k, ", gcd(x+1, n) = ", g2k];
  If[g1k > 1 && g1k < n, Print["  FACTOR: ", g1k]];
  If[g2k > 1 && g2k < n, Print["  FACTOR: ", g2k]],
  {k, 1, 5}
]
Print[""]

Print["═══════════════════════════════════════════════════════════════"]
Print["  CONCLUSION"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]
Print["Pell solution gives x² ≡ 1 (mod n), which is the CORE of"]
Print["many factoring methods (including parts of Shor's algorithm)."]
Print[""]
Print["gcd(x±1, n) may reveal factors, but for specific n it may give"]
Print["trivial factors (1 or n)."]
Print[""]
Print["Our Orbit sqrt tools (FactorialTerm, ChebyshevTerm) provide"]
Print["rational approximations but don't directly reveal factors"]
Print["beyond what Pell already provides."]
