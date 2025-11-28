(* Analytic continuation: Can we detect Wilson signal analytically? *)

Print["==============================================================="]
Print["  ANALYTIC CONTINUATION OF WILSON DETECTION"]
Print["==============================================================="]
Print[""]

f[n_, i_] := Product[n^2 - j^2, {j, 1, i}]

n = 143;
{p, q} = {11, 13};

Print["Key observation: {f(n,i)/(2i+1)} is nonzero iff (2i+1) | n"]
Print[""]

Print["1. FOURIER SERIES FOR FRACTIONAL PART"]
Print["==============================================================="]
Print[""]

(* {x} = x - Floor[x] *)
(* Fourier: {x} = 1/2 - Sum[sin(2 pi k x)/(pi k), {k, 1, inf}] *)
(* So {f/d} = 1/2 - Sum[sin(2 pi k f/d)/(pi k)] *)

Print["Fourier series: {x} = 1/2 - Sum[sin(2 pi k x)/(pi k)]"]
Print[""]

(* At Wilson point i = (p-1)/2: *)
(* f(n,i) = M*p + (p-1) for some large M *)
(* f/p = M + (p-1)/p *)
(* {f/p} = (p-1)/p *)

i = (p - 1)/2;
fVal = f[n, i];
fModP = Mod[fVal, p];
Print["At i = ", i, " (Wilson point for p = ", p, "):"]
Print["  f(n,i) = ", fVal]
Print["  f mod p = ", fModP, " = p-1 (Wilson!)"]
Print[""]

Print["2. DETECTING DIVISIBILITY VIA TRIGONOMETRIC SUMS"]
Print["==============================================================="]
Print[""]

(* sin(2 pi k f/d) = 0 when d | f *)
(* So if we sum sin(2 pi k f/d) over many k, it's small when d | f *)

trigSum[x_, d_, maxK_] := Sum[Sin[2 Pi k x/d]/(Pi k), {k, 1, maxK}]

Print["For d = ", p, " (a factor of n):"]
Do[
  fVal = f[n, i];
  ts = trigSum[fVal, p, 100];
  fracPartDirect = FractionalPart[fVal/p];
  Print["  i=", i, ": trig sum = ", N[ts, 6], ", {f/p} = ", N[fracPartDirect, 6]],
  {i, 1, 8}
]
Print[""]

Print["For d = 7 (NOT a factor):"]
d = 7;
Do[
  fVal = f[n, i];
  ts = trigSum[fVal, d, 100];
  fracPartDirect = FractionalPart[fVal/d];
  Print["  i=", i, ": trig sum = ", N[ts, 6], ", {f/d} = ", N[fracPartDirect, 6]],
  {i, 1, 8}
]
Print[""]

Print["3. RAMANUJAN SUM APPROACH"]
Print["==============================================================="]
Print[""]

(* Ramanujan sum: c_q(n) = Sum[e^(2 pi i k n/q), gcd(k,q)=1] *)
(* c_q(n) = mu(q/gcd(n,q)) * phi(q) / phi(q/gcd(n,q)) *)
(* When q | n: c_q(n) = phi(q) *)
(* When gcd(q,n) = 1: c_q(n) = mu(q) *)

cq[qq_, nn_] := Sum[Exp[2 Pi I k nn/qq], {k, Select[Range[qq], GCD[#, qq] == 1 &]}]

Print["Ramanujan sums c_d(f(n,i)):"]
Print[""]

Print["d = ", p, ":"]
Do[
  fVal = f[n, i];
  c = cq[p, fVal];
  Print["  i=", i, ": c_", p, "(f) = ", c, " (phi(", p, ")=", EulerPhi[p], ")"],
  {i, 1, 8}
]
Print[""]

Print["Interpretation:"]
Print["  c_p(f) = phi(p) = p-1 when p | f"]
Print["  This detects divisibility!"]
Print[""]

Print["4. CAN WE USE THIS FOR FACTORING?"]
Print["==============================================================="]
Print[""]

(* To factor n, we'd need to find d such that c_d(f(n,i)) = phi(d) *)
(* But we don't know which d to try! *)

Print["Problem: We need to TEST each candidate divisor d."]
Print["Computing c_d(f) for all d up to sqrt(n) is O(sqrt(n))."]
Print["No speedup over trial division."]
Print[""]

Print["5. WHAT IF WE SUM OVER ALL d?"]
Print["==============================================================="]
Print[""]

(* Sum_{d=2}^{M} c_d(f(n,i)) *)
(* When f has small prime factors, this sum has spikes *)

sumRamanujan[fVal_, maxD_] := Sum[Re[cq[d, fVal]], {d, 2, maxD}]

Print["Sum of c_d(f) for d = 2 to 20:"]
Do[
  fVal = f[n, i];
  sR = sumRamanujan[fVal, 20];
  Print["  i=", i, ": Sum c_d = ", sR],
  {i, 1, 6}
]
Print[""]

Print["6. MELLIN TRANSFORM APPROACH"]
Print["==============================================================="]
Print[""]

(* The Mellin transform of {x} involves zeta function *)
(* integral_0^inf {x} x^(s-1) dx relates to zeta(s) *)

Print["Mellin transform of fractional part:"]
Print["  M[{x}](s) = -zeta(s)/s  for Re(s) > 1"]
Print[""]

Print["This connects fractional parts to zeta function poles,"]
Print["but doesn't give a factoring shortcut."]
Print[""]

Print["7. RESIDUE AT s=1"]
Print["==============================================================="]
Print[""]

(* zeta(s) has pole at s=1 with residue 1 *)
(* The fractional part function's Mellin transform inherits this structure *)

Print["Near s=1: M[{x}](s) ~ -1/(s-1)"]
Print["This is the 'equidistribution' of fractional parts."]
Print[""]

Print["For our specific f(n,i)/d, the residue structure would")
Print["encode divisibility, but extracting it requires knowing d."]
Print[""]

Print["8. GENERATING FUNCTION IN COMPLEX PLANE"]
Print["==============================================================="]
Print[""]

(* G(z) = Sum[{f(n,i)/(2i+1)} z^i] *)
(* As analytic function of z, where are the singularities? *)

gFrac[nn_, z_, maxI_] := Sum[FractionalPart[f[nn, i]/(2 i + 1)] * z^i, {i, 1, maxI}]

Print["G(z) = Sum[{f(n,i)/(2i+1)} z^i] near z=1:"]
Do[
  g = gFrac[n, z, 20];
  Print["  G(", z, ") = ", N[g, 8]],
  {z, {0.5, 0.9, 0.99, 1.0}}
]
Print[""]

Print["G(1) = S_inf = ", N[gFrac[n, 1, 20], 10]]
Print["Expected: (p-1)/p + (q-1)/q = ", N[(p - 1)/p + (q - 1)/q, 10]]
Print[""]

Print["9. ANALYTIC STRUCTURE"]
Print["==============================================================="]
Print[""]

(* The generating function has finite support (only 2 nonzero terms for semiprime) *)
(* So G(z) is actually a polynomial! *)

Print["For semiprime n = pq, only TWO terms are nonzero:"]
Print["  i = (p-1)/2: contributes (p-1)/p * z^((p-1)/2)"]
Print["  i = (q-1)/2: contributes (q-1)/q * z^((q-1)/2)"]
Print[""]

i1 = (p - 1)/2;
i2 = (q - 1)/2;
Print["G(z) = (", p - 1, "/", p, ") z^", i1, " + (", q - 1, "/", q, ") z^", i2]
Print[""]

Print["If we knew G(z) as a polynomial, the EXPONENTS give (p-1)/2 and (q-1)/2!"]
Print[""]

Print["10. THE CIRCULAR TRAP"]
Print["==============================================================="]
Print[""]

Print["To find the exponents in G(z), we need to:"]
Print["  - Either evaluate G at enough points to interpolate (O(sqrt n) points)"]
Print["  - Or compute terms directly (O(sqrt n) terms)"]
Print[""]
Print["Either way: O(sqrt n) work to extract the polynomial structure."]
Print[""]
Print["CONCLUSION: Analytic continuation doesn't bypass iteration."]
Print["The factor information IS there, but ACCESSING it requires work."]
