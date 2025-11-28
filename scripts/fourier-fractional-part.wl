(* Fourier series for fractional part: {x} = 1/2 - (1/pi) Sum[sin(2 pi k x)/k] *)

Print["==============================================================="]
Print["  FOURIER SERIES FOR FRACTIONAL PART"]
Print["==============================================================="]
Print[""]

f[n_, i_] := Product[n^2 - j^2, {j, 1, i}]

n = 143;
{p, q} = {11, 13};

Print["Fourier representation:"]
Print["  {x} = 1/2 - (1/pi) * Sum[sin(2 pi k x)/k, {k, 1, inf}]"]
Print[""]

(* Verify the Fourier series *)
fourierFrac[x_, maxK_] := 1/2 - Sum[Sin[2 Pi k x]/(Pi k), {k, 1, maxK}]

Print["1. VERIFY FOURIER SERIES CONVERGES TO {x}"]
Print["==============================================================="]
Print[""]

testValues = {0.3, 0.7, 1.5, 2.8, 10.25};
Do[
  exact = FractionalPart[x];
  approx = fourierFrac[x, 100];
  Print["  x=", x, ": {x}=", exact, ", Fourier(100)=", N[approx, 6]],
  {x, testValues}
]
Print[""]

Print["2. APPLY TO OUR SIGNAL"]
Print["==============================================================="]
Print[""]

Print["signal(n,i) = {f(n,i)/(2i+1)}"]
Print["           = 1/2 - (1/pi) Sum[sin(2 pi k f(n,i)/(2i+1))/k]"]
Print[""]

(* At Wilson point i = (p-1)/2 = 5 *)
i = (p - 1)/2;
fVal = f[n, i];
d = 2 i + 1;  (* = p = 11 *)

Print["At Wilson point i = ", i, " (where 2i+1 = ", d, " = p):"]
Print["  f(n,i) = ", fVal]
Print["  f/p = ", N[fVal/p, 10]]
Print["  f mod p = ", Mod[fVal, p], " (= p-1 by Wilson!)"]
Print[""]

(* The fractional part *)
fracDirect = FractionalPart[fVal/d];
fracFourier = fourierFrac[fVal/d, 200];
Print["  {f/p} direct = ", fracDirect]
Print["  {f/p} Fourier = ", N[fracFourier, 10]]
Print[""]

Print["3. THE KEY: sin(2 pi k f/p) STRUCTURE"]
Print["==============================================================="]
Print[""]

(* sin(2 pi k f/p) = sin(2 pi k (M + (p-1)/p)) where M is integer *)
(* = sin(2 pi k (p-1)/p) *)
(* = sin(2 pi k - 2 pi k/p) *)
(* = sin(-2 pi k/p) = -sin(2 pi k/p) *)

Print["Since f = M*p + (p-1) for some large M:"]
Print["  sin(2 pi k f/p) = sin(2 pi k (p-1)/p)"]
Print["                  = sin(2 pi k - 2 pi k/p)"]
Print["                  = -sin(2 pi k/p)"]
Print[""]

Print["First few terms of Fourier series for {(p-1)/p}:"]
Do[
  term = -Sin[2 Pi k/p]/(Pi k);
  Print["  k=", k, ": -sin(2 pi k/", p, ")/(pi k) = ", N[term, 6]],
  {k, 1, 10}
]
Print[""]

Print["Sum = 1/2 - Sum[...] = ", N[fourierFrac[(p - 1)/p, 100], 10]]
Print["Expected: (p-1)/p = ", N[(p - 1)/p, 10]]
Print[""]

Print["4. CAN FOURIER DETECT FACTORS?"]
Print["==============================================================="]
Print[""]

(* The Fourier series for {f(n,i)/d} has specific structure when d | n *)
(* At i = (p-1)/2, d = p: the series gives (p-1)/p *)
(* At other i: the series gives 0 (or small values) *)

Print["Fourier sum for various i (testing d = 2i+1):"]
Do[
  fVal = f[n, i];
  d = 2 i + 1;
  fracDirect = FractionalPart[fVal/d];
  fracFourier = fourierFrac[fVal/d, 100];
  divides = Divisible[n, d];
  Print["  i=", i, " (d=", d, "): {f/d}=", N[fracDirect, 4],
    If[divides, " <- d divides n!", ""]],
  {i, 1, 10}
]
Print[""]

Print["5. THE PROBLEM: COMPUTING THE FOURIER SUM"]
Print["==============================================================="]
Print[""]

Print["To evaluate {f(n,i)/(2i+1)} via Fourier, we need:"]
Print["  Sum[sin(2 pi k f(n,i)/(2i+1))/k, {k, 1, inf}]"]
Print[""]

Print["But sin(2 pi k f/d) depends on f mod d."]
Print["For large f (like f(143,5) = 3.5 * 10^21), computing f mod d is:"]
Print["  - Trivial if we know f explicitly"]
Print["  - But we need to compute f first!"]
Print[""]

Print["6. POISSON SUMMATION APPROACH"]
Print["==============================================================="]
Print[""]

(* Poisson: Sum[f(n)] = Sum[F(k)] where F is Fourier transform *)
(* Maybe we can transform the sum over i into something tractable? *)

Print["Our S_inf = Sum[{f(n,i)/(2i+1)}, {i, 1, inf}]"]
Print[""]
Print["Using Fourier: S_inf = Sum[1/2 - (1/pi) Sum[sin(2 pi k f(n,i)/(2i+1))/k]]"]
Print[""]
Print["Exchanging sums (if valid):"]
Print["  S_inf = (1/2) * (# nonzero terms) - (1/pi) Sum_k (1/k) Sum_i sin(...)"]
Print[""]

Print["The inner sum Sum_i sin(2 pi k f(n,i)/(2i+1)) is complicated."]
Print["No obvious simplification."]
Print[""]

Print["7. GAUSS SUMS CONNECTION"]
Print["==============================================================="]
Print[""]

(* Gauss sums: g(a,p) = Sum[e^(2 pi i a k^2 / p), {k, 0, p-1}] *)
(* Related to quadratic residues and Legendre symbol *)

Print["Gauss sum: g(a,p) = Sum[exp(2 pi i a k^2 / p)]"]
Print["|g(1,p)|^2 = p for odd prime p"]
Print[""]

(* Our sin terms involve f(n,i) which is product of squares *)
(* Maybe there's a connection? *)

Print["f(n,i) = Product[(n-j)(n+j)] involves products, not sums of squares."]
Print["Direct Gauss sum connection is unclear."]
Print[""]

Print["8. EXPONENTIAL SUM BOUND"]
Print["==============================================================="]
Print[""]

(* Weyl bound: |Sum[e^(2 pi i f(k)/q)]| << q^(1-delta) for polynomial f *)
(* This might bound our Fourier terms *)

Print["Weyl bound for exponential sums:"]
Print["  |Sum[exp(2 pi i P(k)/q)]| << q^(1-1/2^d) for degree d polynomial"]
Print[""]

Print["But our sum is over FIXED i with varying k in Fourier,"]
Print["not over i with fixed k.")
Print["Different structure.")
Print[""]

Print["9. CONCLUSION"]
Print["==============================================================="]
Print[""]

Print["The Fourier series {x} = 1/2 - (1/pi) Sum[sin(2 pi k x)/k]"]
Print["is CORRECT but doesn't help for factoring because:"]
Print[""]
Print["1. Computing sin(2 pi k f/d) requires knowing f mod d"]
Print["2. f(n,i) is a huge number - must compute it explicitly"]
Print["3. The Fourier sum converges SLOWLY (O(1/k) terms)"]
Print["4. No algebraic simplification when summing over i"]
Print[""]
Print["The fractional part {x} is DISCONTINUOUS at integers."]
Print["Fourier captures this via infinite sum (Gibbs phenomenon)."]
Print["This discontinuity is exactly what makes factoring hard:"]
Print["  - Continuous functions can't detect integer boundaries"]
Print["  - Detecting when d | f requires discrete/modular arithmetic"]
