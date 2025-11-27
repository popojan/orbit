(* Alternating Sum Analysis *)
(* G(1) gives sum, G(-1) gives alternating sum *)
(* Can these two values determine p and q? *)

signal[n_, i_] := FractionalPart[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1)]

Print["=== Alternating Sum Structure ==="]
Print[""]

(* For semiprime n = pq: *)
(* G(1) = (p-1)/p + (q-1)/q *)
(* G(-1) = (-1)^{(p-1)/2} × (p-1)/p + (-1)^{(q-1)/2} × (q-1)/q *)

(* The sign depends on p, q mod 4: *)
(* p ≡ 1 (mod 4) → (p-1)/2 even → sign = +1 *)
(* p ≡ 3 (mod 4) → (p-1)/2 odd  → sign = -1 *)

Print["Sign pattern for primes mod 4:"]
primes = Select[Range[3, 50], PrimeQ];
Do[
  sign = (-1)^((p - 1)/2);
  Print["  p = ", p, " ≡ ", Mod[p, 4], " (mod 4) → sign = ", sign],
  {p, Take[primes, 12]}
]
Print[""]

(* Test several semiprimes *)
Print["=== Testing Semiprimes ==="]
Print[""]

testCases = {{11, 13}, {7, 11}, {7, 13}, {5, 7}, {3, 17}, {3, 23}, {7, 23}};

Do[
  {p, q} = pq;
  n = p * q;

  g1 = (p-1)/p + (q-1)/q;
  gMinus1 = (-1)^((p-1)/2) * (p-1)/p + (-1)^((q-1)/2) * (q-1)/q;

  (* Verify by direct computation *)
  g1Direct = Sum[signal[n, i], {i, 1, (q-1)/2}];
  gMinus1Direct = Sum[(-1)^i * signal[n, i], {i, 1, (q-1)/2}];

  Print["n = ", n, " = ", p, " × ", q];
  Print["  p ≡ ", Mod[p, 4], ", q ≡ ", Mod[q, 4], " (mod 4)"];
  Print["  G(1)  = ", g1, " = ", N[g1, 6]];
  Print["  G(-1) = ", gMinus1, " = ", N[gMinus1, 6]];
  Print["  Direct: G(1) = ", g1Direct, ", G(-1) = ", N[gMinus1Direct, 6]];

  (* Can we recover p and q from G(1) and G(-1)? *)
  (* Let a = (p-1)/p, b = (q-1)/q *)
  (* Sign patterns: *)
  (*   Both ≡1(4): G(1)=a+b, G(-1)=a+b *)
  (*   Both ≡3(4): G(1)=a+b, G(-1)=-a-b *)
  (*   p≡1,q≡3:   G(1)=a+b, G(-1)=a-b *)
  (*   p≡3,q≡1:   G(1)=a+b, G(-1)=-a+b *)

  sp = (-1)^((p-1)/2);
  sq = (-1)^((q-1)/2);

  If[sp == 1 && sq == 1,
    Print["  Case: both ≡1(4), G(1)=G(-1), no extra info"]
  ];
  If[sp == -1 && sq == -1,
    Print["  Case: both ≡3(4), G(-1)=-G(1), no extra info"]
  ];
  If[sp == 1 && sq == -1,
    (* G(1) = a + b, G(-1) = a - b *)
    (* → a = (G(1)+G(-1))/2 = (p-1)/p *)
    (* → b = (G(1)-G(-1))/2 = (q-1)/q *)
    a = (g1 + gMinus1)/2;
    b = (g1 - gMinus1)/2;
    pRecovered = 1/(1 - a);
    qRecovered = 1/(1 - b);
    Print["  Case: p≡1(4), q≡3(4)"];
    Print["  → (p-1)/p = ", a, " → p = ", pRecovered];
    Print["  → (q-1)/q = ", b, " → q = ", qRecovered]
  ];
  If[sp == -1 && sq == 1,
    (* G(1) = a + b, G(-1) = -a + b *)
    (* → a = (G(1)-G(-1))/2 = (p-1)/p *)
    (* → b = (G(1)+G(-1))/2 = (q-1)/q *)
    a = (g1 - gMinus1)/2;
    b = (g1 + gMinus1)/2;
    pRecovered = 1/(1 - a);
    qRecovered = 1/(1 - b);
    Print["  Case: p≡3(4), q≡1(4)"];
    Print["  → (p-1)/p = ", a, " → p = ", pRecovered];
    Print["  → (q-1)/q = ", b, " → q = ", qRecovered]
  ];

  Print[""],
  {pq, testCases}
]

Print["=== Key Insight ==="]
Print[""]
Print["When p and q have DIFFERENT residues mod 4,"]
Print["G(1) and G(-1) together determine both factors!"]
Print[""]
Print["G(1) = (p-1)/p + (q-1)/q"]
Print["G(-1) = ±(p-1)/p ∓ (q-1)/q  (opposite signs)"]
Print[""]
Print["Solving: p = 1/(1 - (G(1)±G(-1))/2)"]
Print[""]

Print["=== The Catch ==="]
Print[""]
Print["Computing G(-1) = Σ (-1)^i × {f(n,i)/(2i+1)}"]
Print["still requires iterating through all i up to (q-1)/2"]
Print[""]
Print["UNLESS there's a closed form for the alternating sum..."]
Print[""]

(* Is there a pattern in the alternating product? *)
Print["=== Alternating Product Structure ==="]
Print[""]

n = 143;
Print["For n = 143:"]
Do[
  prod = Product[n^2 - j^2, {j, 1, i}];
  altProd = Product[(-1)^j * (n^2 - j^2), {j, 1, i}];
  Print["  i=", i, ": Product = ", prod, ", Alternating = ", altProd],
  {i, 1, 6}
]
Print[""]

(* The alternating sum involves weighted products... *)
(* Not obviously simplifiable *)

Print["=== Connection to Chebyshev? ==="]
Print[""]

(* Product[n^2 - j^2, {j,1,i}] relates to Chebyshev polynomials *)
(* Specifically: appears in U_{n-1}(cos θ) formulas *)

(* Let's check if there's a Chebyshev connection *)
Print["Chebyshev U connection:"]
Print["U_n(x) = Sin[(n+1) ArcCos[x]] / Sin[ArcCos[x]]"]
Print[""]

(* Product[x^2 - k^2, {k, 1, n}] = x × (x^2 - 1^2) × ... × (x^2 - n^2) *)
(* This is related to the Gamma function as we showed *)
Print["Our product: Π(n² - j²) = Γ(n+i+1) / (n × Γ(n-i))"]
Print[""]

(* Alternating version? *)
Print["Alternating: Π(-1)^j(n² - j²) = (-1)^{i(i+1)/2} × Π(n² - j²)"]
Print[""]

(* Check *)
Do[
  regular = Product[n^2 - j^2, {j, 1, i}];
  alternating = Product[(-1)^j * (n^2 - j^2), {j, 1, i}];
  factor = alternating / regular;
  expected = (-1)^(i (i + 1)/2);
  Print["  i=", i, ": factor = ", factor, ", expected (-1)^{i(i+1)/2} = ", expected,
        " | match: ", factor == expected],
  {i, 1, 6}
]
Print[""]

Print["So: Alternating product = (-1)^{i(i+1)/2} × Regular product"]
Print[""]
Print["This means G(-1) has same fractional part structure,"]
Print["just with alternating signs on the sum."]
Print["No computational shortcut found."]
