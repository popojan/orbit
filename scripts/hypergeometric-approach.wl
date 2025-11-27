(* Hypergeometric Function Approach *)
(* Can S_∞ be expressed via hypergeometric functions? *)

Print["═══════════════════════════════════════════════════════════════"]
Print["  HYPERGEOMETRIC APPROACH"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

n = 143;
{p, q} = {11, 13};

(* Our product: *)
(* f(n,i) = Product[n^2 - j^2, {j,1,i}] = Gamma[n+i+1]/(n*Gamma[n-i]) *)

(* In Pochhammer form: *)
(* f(n,i) = (-1)^i * Pochhammer[1-n, i] * Pochhammer[1+n, i] *)

(* Hypergeometric functions are defined as: *)
(* ₂F₁(a,b;c;z) = Σ (a)_k (b)_k / ((c)_k k!) z^k *)

Print["Our product in Pochhammer form:"]
Print["  f(n,i) = (-1)^i × (1-n)_i × (1+n)_i"]
Print[""]

(* The term in our sum: *)
(* T_i = {f(n,i)/(2i+1)} *)

(* Let's look at the GENERATING FUNCTION: *)
(* G(z) = Σ_{i=0}^∞ f(n,i) z^i / (2i+1) *)

Print["Generating function (without fractional part):"]
Print["  G(z) = Σ_{i=0}^∞ f(n,i) × z^i / (2i+1)")
Print[""]

(* f(n,i) = (-1)^i (1-n)_i (1+n)_i *)
(* So: G(z) = Σ (-1)^i (1-n)_i (1+n)_i z^i / (2i+1) *)

(* This looks related to: *)
(* ₂F₁(a,b;c;z) with special parameters *)

Print["Attempting hypergeometric identification..."]
Print[""]

(* Key identity: *)
(* (a)_k (b)_k / (c)_k = Gamma[a+k]Gamma[b+k]Gamma[c] / (Gamma[a]Gamma[b]Gamma[c+k]) *)

(* For ₂F₁(1-n, 1+n; c; z): *)
(* = Σ (1-n)_k (1+n)_k / ((c)_k k!) z^k *)

(* We need: (1-n)_k (1+n)_k / (2k+1) vs (1-n)_k (1+n)_k / ((c)_k k!) *)

(* (2k+1) = 2k+1 *)
(* (3/2)_k = Gamma[3/2+k]/Gamma[3/2] = (1/2)(3/2)(5/2)...(k+1/2) × sqrt(pi) / (sqrt(pi)/2) *)
(*         = (1)(3)(5)...(2k+1) / 2^k *)
(*         = (2k+1)!! / 2^k *)

(* So (3/2)_k × 2^k = (2k+1)!! = 1×3×5×...×(2k+1) *)
(* And (2k+1) = (2k+1)!! / (2k-1)!! *)

Print["Pochhammer (3/2)_k relationship:"]
Print["  (3/2)_k = (2k+1)!! / 2^k")
Print["  where (2k+1)!! = 1×3×5×...×(2k+1)")
Print[""]

(* Verify *)
Do[
  poch = Pochhammer[3/2, k];
  doubleFactorial = Product[2 j + 1, {j, 0, k - 1}];  (* = (2k-1)!! *)
  ratio = poch / (doubleFactorial / 2^k);
  Print["  k=", k, ": (3/2)_k = ", poch, ", (2k+1)!!/2^k = ", doubleFactorial/2^k * (2k+1)],
  {k, 1, 5}
]
Print[""]

(* Actually, let me compute (3/2)_k more carefully *)
Print["Direct (3/2)_k values:"]
Do[
  poch = Pochhammer[3/2, k];
  target = (2 k + 1)!!/(2^k);
  Print["  k=", k, ": (3/2)_k = ", poch, ", target = ", If[k > 0, Product[2j+1, {j, 0, k-1}], 1]/2^k],
  {k, 0, 5}
]
Print[""]

(* Let's try a different approach: direct series identification *)
Print["═══════════════════════════════════════════════════════════════"]
Print["  DIRECT SERIES IDENTIFICATION"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

(* Compute partial sums and compare to hypergeometric *)
Print["Computing G(1) = Σ f(n,i)/(2i+1) (full expression, not fractional):"]
Print[""]

partialG[nn_, maxI_] := Sum[
  Product[nn^2 - j^2, {j, 1, i}]/(2 i + 1),
  {i, 1, maxI}
]

Do[
  pg = partialG[n, m];
  Print["  m=", m, ": G_m = ", N[pg]],
  {m, 1, 8}
]
Print[""]

(* The series diverges! f(n,i) grows very fast *)
Print["Note: Series DIVERGES because f(n,i) grows as (2n)!"]
Print[""]

(* What about z < 1? *)
Print["G(z) for z = 1/2:"]
partialGz[nn_, maxI_, z_] := Sum[
  Product[nn^2 - j^2, {j, 1, i}] * z^i / (2 i + 1),
  {i, 1, maxI}
]

Do[
  pg = partialGz[n, m, 1/2];
  Print["  m=", m, ": G_m(1/2) = ", N[pg]],
  {m, 1, 8}
]
Print[""]

(* Still diverges! *)

Print["═══════════════════════════════════════════════════════════════"]
Print["  REGULARIZATION NEEDED"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

Print["The raw series diverges. The FRACTIONAL PART regularizes it:"]
Print["  S_∞ = Σ {f(n,i)/(2i+1)} converges (finitely many nonzero terms)")
Print[""]

Print["The fractional part acts as a 'cutoff' or 'regularization':")
Print["  - For most i: f(n,i)/(2i+1) is an integer, so {·} = 0")
Print["  - For i = (p-1)/2: {f/p} = (p-1)/p")
Print["  - For i = (q-1)/2: {f/q} = (q-1)/q")
Print[""]

Print["═══════════════════════════════════════════════════════════════"]
Print["  DIGAMMA / POLYGAMMA APPROACH"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

(* ψ(z) = d/dz log Γ(z) = Γ'(z)/Γ(z) *)
(* ψ(n+1) = H_n - γ  where H_n = 1 + 1/2 + ... + 1/n *)

Print["Digamma function: ψ(z) = d/dz log Γ(z)"]
Print[""]

(* Our ratio: log[Γ(n+i+1)/Γ(n-i)] = log Γ(n+i+1) - log Γ(n-i) *)
(* d/di [...] = ψ(n+i+1) - (-1)ψ(n-i) = ψ(n+i+1) + ψ(n-i) *)

Print["d/di log[Γ(n+i+1)/Γ(n-i)] = ψ(n+i+1) + ψ(n-i)")
Print[""]

(* This relates the DERIVATIVE of our function to digamma *)
(* Maybe useful for asymptotic analysis? *)

Do[
  psi1 = PolyGamma[0, n + i + 1];
  psi2 = PolyGamma[0, n - i];
  sum = psi1 + psi2;
  Print["  i=", i, ": ψ(n+i+1) + ψ(n-i) = ", N[sum, 6]],
  {i, 0, 6}
]
Print[""]

Print["═══════════════════════════════════════════════════════════════"]
Print["  LAPLACE TRANSFORM APPROACH"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

(* L[f](s) = ∫_0^∞ f(t) e^{-st} dt *)
(* For Gamma: Γ(n) = ∫_0^∞ t^{n-1} e^{-t} dt *)

Print["Gamma as Laplace transform:"]
Print["  Γ(n) = L[t^{n-1}](1) = ∫_0^∞ t^{n-1} e^{-t} dt"]
Print[""]

(* Our product: Γ(n+i+1)/Γ(n-i) *)
(* = ∫∫ t^{n+i} u^{n-i-1} e^{-t-u} dt du / ??? *)

Print["Double integral representation for ratio?")
Print["  Γ(a)/Γ(b) = ∫_0^∞ t^{a-b} Γ(b,t) / t^{a-b} dt  (incomplete Gamma)")
Print["  This is getting complicated...")
Print[""]

Print["═══════════════════════════════════════════════════════════════"]
Print["  KEY INSIGHT: THE PROBLEM IS THE FRACTIONAL PART"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

Print["All continuous approaches struggle because:"]
Print["  1. The RAW series f(n,i)/(2i+1) DIVERGES"]
Print["  2. The FRACTIONAL PART is discontinuous (jumps at integers)")
Print["  3. {·} annihilates most terms, keeping only prime divisor positions"]
Print[""]

Print["The fractional part is doing NUMBER-THEORETIC work:")
Print["  It detects when (2i+1) divides n")
Print["  This is inherently DISCRETE, not continuous")
Print[""]

Print["This might explain why continuous/analytic approaches fail:")
Print["  The information we need is ARITHMETICAL, not ANALYTICAL"]
