(* Connection: Lissajous figures, Powermod, and factor detection *)

Print["==============================================================="]
Print["  LISSAJOUS - POWERMOD - FACTORING CONNECTION"]
Print["==============================================================="]
Print[""]

Print["1. LISSAJOUS CURVES"]
Print["==============================================================="]
Print[""]

Print["Lissajous curve: x = sin(a*t), y = sin(b*t)"]
Print[""]
Print["Key property: curve closes when gcd(a,b) > 1"]
Print["             curve fills region when gcd(a,b) = 1"]
Print[""]

Print["For (7, 11): gcd = ", GCD[7, 11], " -> fills region"]
Print["For (6, 9):  gcd = ", GCD[6, 9], " -> simpler curve"]
Print[""]

Print["2. POWERMOD AND PERIODICITY"]
Print["==============================================================="]
Print[""]

Print["PowerMod[a, k, n] = a^k mod n"]
Print["This is PERIODIC in k with period ord_n(a)"]
Print[""]

n = 143;
a = 2;
ord = MultiplicativeOrder[a, n];
Print["n = ", n, ", a = ", a]
Print["ord_", n, "(", a, ") = ", ord]
Print[""]

Print["First ", ord + 5, " powers of 2 mod 143:"]
powers = Table[PowerMod[a, k, n], {k, 0, ord + 4}];
Print[powers]
Print[""]

Print["Period confirmed: ", powers[[1 ;; ord]] == powers[[ord + 1 ;; 2 ord]]]
Print[""]

Print["3. EGYPTIAN FRACTIONS AND POWERMOD"]
Print["==============================================================="]
Print[""]

Print["Egyptian fraction algorithm uses:"]
Print["  d_k = ceiling(n/r) where r is remainder"]
Print[""]

Print["'Backwards' method: finding modular inverse"]
Print["  If we have 1/d in decomposition,"]
Print["  we need r such that r * d = 1 (mod something)"]
Print["  This uses PowerMod for modular inverse!"]
Print[""]

(* Modular inverse: a^(-1) mod m = PowerMod[a, -1, m] *)
Print["Example: inverse of 7 mod 11:"]
inv = PowerMod[7, -1, 11];
Print["  7^(-1) mod 11 = ", inv]
Print["  Check: 7 * ", inv, " mod 11 = ", Mod[7 * inv, 11]]
Print[""]

Print["4. LISSAJOUS PARAMETRIZATION OF sin(2 pi k r/d)"]
Print["==============================================================="]
Print[""]

Print["Our detection: sin(2 pi k r/d) for k = 1, 2, ..."]
Print[""]

Print["This traces a Lissajous-like pattern:"]
Print["  x_k = sin(2 pi k * 1/d) = sin(2 pi k/d)"]
Print["  y_k = sin(2 pi k * r/d)"]
Print[""]

Print["The pattern depends on gcd(1, r) = 1 and gcd(r, d)!"]
Print[""]

(* Plot the discrete points *)
d = 11;
r = 10;  (* = p-1 for factor p = 11 *)
Print["For d = ", d, ", r = ", r, " (Wilson residue when d | n):"]
points = Table[{Sin[2 Pi k/d], Sin[2 Pi k r/d]}, {k, 1, d - 1}];
Print["Points (x_k, y_k):"]
Do[
  Print["  k=", k, ": (", N[Sin[2 Pi k/d], 4], ", ", N[Sin[2 Pi k r/d], 4], ")"],
  {k, 1, d - 1}
]
Print[""]

Print["5. THE KEY: STRUCTURE WHEN r = d-1 (WILSON)"]
Print["==============================================================="]
Print[""]

Print["When r = d-1 (factor via Wilson):"]
Print["  sin(2 pi k (d-1)/d) = sin(2 pi k - 2 pi k/d)"]
Print["                      = sin(-2 pi k/d)"]
Print["                      = -sin(2 pi k/d)"]
Print[""]

Print["So y_k = -x_k, giving a DIAGONAL LINE!"]
Print[""]

Print["Verify:"]
Do[
  xk = Sin[2 Pi k/d];
  yk = Sin[2 Pi k (d - 1)/d];
  Print["  k=", k, ": x=", N[xk, 4], ", y=", N[yk, 4], ", y=-x: ", Abs[yk + xk] < 10^-10],
  {k, 1, d - 1}
]
Print[""]

Print["6. NON-FACTOR: DIFFERENT PATTERN"]
Print["==============================================================="]
Print[""]

d = 7;
r = Mod[3566085730553567692800, 7];  (* f(143,5) mod 7 *)
Print["For d = ", d, " (not a factor), r = f mod 7 = ", r]
Print[""]

If[r == 0,
  Print["r = 0, so d | f (all points at origin)"],
  (* else *)
  Print["Points (x_k, y_k):"];
  Do[
    xk = Sin[2 Pi k/d];
    yk = Sin[2 Pi k r/d];
    Print["  k=", k, ": (", N[xk, 4], ", ", N[yk, 4], ")"],
    {k, 1, d - 1}
  ]
]
Print[""]

Print["7. DETECTING FACTORS VIA LISSAJOUS PATTERN"]
Print["==============================================================="]
Print[""]

Print["FACTOR (Wilson r = d-1): diagonal y = -x"]
Print["NON-FACTOR (r = 0):      all points at origin"]
Print["NON-FACTOR (r other):    scattered pattern"]
Print[""]

Print["The DIAGONAL pattern y = -x is unique signature of factors!"]
Print[""]

Print["8. CONNECTION TO POWERMOD"]
Print["==============================================================="]
Print[""]

Print["In Egyptian fractions 'reverse' algorithm:"]
Print["  We compute sequences involving PowerMod"]
Print["  The periodicity relates to ord_d(base)"]
Print[""]

Print["For detecting factors:"]
Print["  ord_p(a) | p-1 by Fermat's Little Theorem"]
Print["  When we hit period = p-1, we've found a factor!"]
Print[""]

Print["This is EXACTLY what Shor's algorithm does:"]
Print["  Find period of a^k mod n via QFT"]
Print["  Period relates to factors via gcd(a^(r/2) +/- 1, n)"]
Print[""]

Print["9. CAN WE DETECT DIAGONAL PATTERN EFFICIENTLY?"]
Print["==============================================================="]
Print[""]

Print["To check if y_k = -x_k for all k:"]
Print["  sin(2 pi k r/d) = -sin(2 pi k/d)"]
Print["  This holds iff r = d-1 (mod d)"]
Print["  i.e., iff r = d-1"]
Print[""]

Print["But checking this requires computing r = f mod d."]
Print["Still O(1) per candidate d, but O(sqrt(n)) candidates."]
Print[""]

Print["10. AGGREGATE DETECTION?"]
Print["==============================================================="]
Print[""]

Print["What if we sum the Lissajous 'energy' over all d?"]
Print[""]

(* Define 'diagonality' measure *)
diagonality[fVal_, d_] := Module[{r, sum},
  r = Mod[fVal, d];
  If[r == 0, Return[0]];  (* d | f, not interesting *)
  sum = Sum[(Sin[2 Pi k r/d] + Sin[2 Pi k/d])^2, {k, 1, d - 1}];
  sum/(d - 1)  (* normalize *)
]

fVal = 3566085730553567692800;  (* f(143, 5) *)
Print["Diagonality measure (0 = perfect diagonal):"]
Do[
  diag = diagonality[fVal, d];
  divN = Divisible[143, d];
  Print["  d=", d, ": diag=", N[diag, 4], If[divN, " <- d | n", ""], If[diag < 0.01 && diag > 0, " DIAGONAL!", ""]],
  {d, 3, 20}
]
Print[""]

Print["Factors d = 11, 13 have diagonality ~ 0 (perfect diagonal)!"]
Print["Non-factors either have diag = 0 (d | f) or diag > 0 (scattered)"]
