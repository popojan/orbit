(* Integral Representation Approach *)
(* Can we express S_∞ as an integral with closed form? *)

Print["=== Integral Representation ==="]
Print[""]

(* Our product: *)
(* Π(n²-j²) = Γ(n+i+1) / (n × Γ(n-i)) *)

(* Using Beta function: B(a,b) = Γ(a)Γ(b)/Γ(a+b) *)
(* And integral: B(a,b) = ∫_0^1 t^{a-1}(1-t)^{b-1} dt *)

Print["Gamma formulation:"]
Print["  Π(n²-j²) = Γ(n+i+1) / (n × Γ(n-i))"]
Print[""]

(* Let's verify this matches *)
n = 143;
Do[
  prod = Product[n^2 - j^2, {j, 1, i}];
  gamma = Gamma[n + i + 1]/(n * Gamma[n - i]);
  Print["  i=", i, ": Product = ", prod, ", Gamma = ", gamma, ", Equal: ", prod == gamma],
  {i, 1, 5}
]
Print[""]

(* The sum term: *)
(* T_i = {Γ(n+i+1) / (n × Γ(n-i) × (2i+1))} *)

Print["=== Integral for Gamma Ratio ==="]
Print[""]

(* Γ(n+i+1)/Γ(n-i) = (n+i)!/(n-i-1)! = Π_{k=n-i}^{n+i} k *)
(* This is a rising factorial: (n-i)_{2i+1} *)

Print["Γ(n+i+1)/Γ(n-i) = Pochhammer[n-i, 2i+1]"]

Do[
  gamma = Gamma[n + i + 1]/Gamma[n - i];
  poch = Pochhammer[n - i, 2 i + 1];
  Print["  i=", i, ": ", gamma, " = ", poch, " | Equal: ", gamma == poch],
  {i, 1, 4}
]
Print[""]

(* So our term becomes: *)
(* T_i = {Pochhammer[n-i, 2i+1] / (n × (2i+1))} *)

Print["=== Generating Function as Integral? ==="]
Print[""]

(* The generating function: *)
(* G(x) = Σ_{i=1}^∞ {Γ(n+i+1)/(n·Γ(n-i)·(2i+1))} x^i *)

(* For semiprime n = pq, G(1) = (p-1)/p + (q-1)/q *)

(* Contour integral approach: *)
(* {y} = y - floor(y) can be written as: *)
(* {y} = (1/2πi) ∮ (e^{2πiy} - 1)/(e^{2πiz} - 1) × π cot(πz) dz *)

Print["Fractional part has contour integral representation:"]
Print["  {y} = y - Σ_{k ≤ y} 1"]
Print["      = y - (1/2πi) ∮ (y^s/s) × ζ(s) ds  (Perron's formula)"]
Print[""]

(* This is getting into advanced complex analysis *)
(* Let's try a different approach: residue calculus *)

Print["=== Residue Approach ==="]
Print[""]

(* The fractional part {f(n,i)/(2i+1)} = (p-1)/p when 2i+1 = p *)
(* This is because f(n,i) ≡ -(p-1)! (mod p) by Wilson *)
(* And -(p-1)! ≡ 1 (mod p) *)

(* So f(n,i)/(2i+1) = k + (p-1)/p for some integer k when 2i+1 = p *)

Print["The fractional part 'spikes' at prime divisors."]
Print[""]

(* Can we detect these spikes via Fourier analysis? *)
Print["=== Fourier Approach ==="]
Print[""]

signal[n_, i_] := FractionalPart[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1)]

(* Compute DFT of signal *)
n = 143;
maxI = 20;  (* enough to cover both factors *)
sig = Table[signal[n, i], {i, 1, maxI}];

Print["Signal for n = 143 (first 20 terms):"]
Print[sig]
Print[""]

(* DFT *)
dft = Fourier[N[sig]];
Print["DFT magnitude:"]
Do[
  Print["  k=", k, ": |DFT| = ", Abs[dft[[k]]]],
  {k, 1, 10}
]
Print[""]

(* The signal is extremely sparse *)
(* DFT of 2-sparse signal should have specific structure *)

Print["=== Chinese Remainder Theorem Angle ==="]
Print[""]

(* For n = pq, the ring Z/nZ ≅ Z/pZ × Z/qZ *)
(* Our formula detects factors via (Z/nZ)* structure *)

(* CRT gives us: *)
(* For any x: x mod n ↔ (x mod p, x mod q) *)

(* The product Π(n²-j²) mod n: *)
(* = Π(n²-j²) mod p × Π(n²-j²) mod q (via CRT) *)

Print["CRT decomposition:"]
{p, q} = {11, 13};
n = p * q;

Do[
  prod = Product[n^2 - j^2, {j, 1, i}];
  modP = Mod[prod, p];
  modQ = Mod[prod, q];
  Print["  i=", i, ": prod mod ", p, " = ", modP, ", prod mod ", q, " = ", modQ],
  {i, 1, 8}
]
Print[""]

(* At i = (p-1)/2 = 5: prod ≡ 0 (mod p) because term (n²-25) = n²-p² ≡ 0 *)
(* Wait, that's not right... *)

Print["=== Direct mod p analysis ==="]
Print[""]

(* n² - j² mod p: *)
(* Since n = pq ≡ 0 (mod p), we have n² ≡ 0 (mod p) *)
(* So n² - j² ≡ -j² (mod p) *)

Print["n² - j² ≡ -j² (mod p) for n = pq"]
Print[""]

(* Product: Π_{j=1}^{i} (-j²) = (-1)^i × (i!)² mod p *)
Print["Π(n²-j²) ≡ (-1)^i × (i!)² (mod p)"]
Print[""]

Do[
  prod = Product[n^2 - j^2, {j, 1, i}];
  modP = Mod[prod, p];
  expected = Mod[(-1)^i * (Factorial[i])^2, p];
  Print["  i=", i, ": prod mod ", p, " = ", modP, ", (-1)^i(i!)² = ", expected, " | match: ", modP == expected],
  {i, 1, 8}
]
Print[""]

(* By Wilson's theorem: (p-1)! ≡ -1 (mod p) *)
(* So at i = p-1: (i!)² = ((p-1)!)² ≡ 1 (mod p) *)

Print["At i = (p-1)/2:"]
i = (p - 1)/2;
Print["  ((p-1)/2)!² mod p = ", Mod[(Factorial[i])^2, p]]
Print["  But this doesn't directly give Wilson..."]
Print[""]

(* Actually, the Wilson detection happens when we divide by (2i+1) *)
(* At i = (p-1)/2, we have 2i+1 = p *)
(* So we need prod/(2i+1) mod p = prod/p which requires prod ≡ 0 (mod p²) for integer *)
(* Or more precisely, we look at the fractional part *)

Print["=== The Wilson Detection Mechanism ==="]
Print[""]

Print["For 2i+1 = p (i.e., i = (p-1)/2):"]
Print["  prod = Π_{j=1}^{(p-1)/2} (n² - j²)"]
Print["  prod mod p = (-1)^{(p-1)/2} × ((p-1)/2)!² mod p"]
Print[""]

(* By Wilson: ((p-1)/2)!² × (-1)^{(p-1)/2} ≡ -1 (mod p) *)
(* This is a known identity! *)

i = (p - 1)/2;
wilson = Mod[(-1)^i * (Factorial[i])^2, p];
Print["(-1)^{(p-1)/2} × ((p-1)/2)!² mod p = ", wilson]
Print["This equals -1 (mod p) = ", p - 1, " ✓"]
Print[""]

Print["So prod ≡ p-1 (mod p) at i = (p-1)/2"]
Print["And prod/p = integer + (p-1)/p"]
Print["Hence {prod/p} = (p-1)/p ✓"]
Print[""]

Print["=== Summary ==="]
Print[""]
Print["The detection mechanism is clear:"]
Print["1. At i = (p-1)/2, divisor is 2i+1 = p"]
Print["2. Product ≡ p-1 (mod p) by Wilson-like identity"]
Print["3. Fractional part {prod/p} = (p-1)/p"]
Print[""]
Print["BUT: We still need to evaluate at the right i to trigger this."]
Print["The question remains: is there a shortcut to find these special i values?"]
