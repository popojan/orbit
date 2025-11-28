(* Can we extract factor info using phi(lcm)·phi(gcd) = phi(m)·phi(n)? *)

Print["==============================================================="]
Print["  PHI(LCM) * PHI(GCD) = PHI(M) * PHI(N)"]
Print["==============================================================="]
Print[""]

n = 143;
{p, q} = {11, 13};

Print["n = ", n, " = ", p, " * ", q]
Print["phi(n) = ", EulerPhi[n]]
Print[""]

Print["1. CHOOSING m STRATEGICALLY"]
Print["==============================================================="]
Print[""]

Print["If we choose m that shares a factor with n:"]
Print["  gcd(m, n) > 1 reveals that factor!"]
Print[""]

Print["Testing m = k (small values):"]
Do[
  g = GCD[m, n];
  l = LCM[m, n];
  phiM = EulerPhi[m];
  phiN = EulerPhi[n];
  phiL = EulerPhi[l];
  phiG = EulerPhi[g];
  Print["  m=", m, ": gcd=", g, ", lcm=", l, ", phi(gcd)=", phiG, If[g > 1, " <- FACTOR!", ""]],
  {m, 2, 20}
]
Print[""]

Print["2. BUT THIS IS JUST TRIAL DIVISION!"]
Print["==============================================================="]
Print[""]

Print["Checking gcd(m, n) for m = 2, 3, 4, ... is O(sqrt(n))."]
Print["No speedup over trial division."]
Print[""]

Print["3. WHAT IF WE COMPUTE PHI FIRST?"]
Print["==============================================================="]
Print[""]

Print["For random m, gcd(m,n) = 1 with high probability."]
Print["Then: phi(lcm) * phi(gcd) = phi(lcm) * 1 = phi(m) * phi(n)"]
Print["     phi(lcm) = phi(m) * phi(n)"]
Print[""]

Print["Since lcm(m,n) = m*n when gcd(m,n) = 1:"]
Print["     phi(m*n) = phi(m) * phi(n)"]
Print[""]

Print["This is just multiplicativity - no new info."]
Print[""]

Print["4. MERSENNE NUMBER CONNECTION"]
Print["==============================================================="]
Print[""]

Print["m | phi(a^m - 1) for all a > 1"]
Print[""]

Print["What if m = n (our semiprime)?"]
Print["Then n | phi(2^n - 1)"]
Print[""]

val = 2^n - 1;
Print["2^n - 1 = 2^", n, " - 1 (huge number)"]
Print["Factoring 2^n - 1 is generally HARDER than factoring n!"]
Print[""]

Print["5. FERMAT NUMBERS"]
Print["==============================================================="]
Print[""]

Print["phi(2^(2^k) + 1) has specific structure (Fermat primes)."]
Print["But this doesn't help for arbitrary n."]
Print[""]

Print["6. CYCLOTOMIC APPROACH"]
Print["==============================================================="]
Print[""]

(* Phi_n(x) = n-th cyclotomic polynomial *)
(* Phi_n(1) = p if n = p^k for prime p, else 1 *)
(* This detects prime powers! *)

Print["Cyclotomic Phi_d(1):"]
Print["  Phi_d(1) = p if d = p^k (prime power)"]
Print["  Phi_d(1) = 1 otherwise"]
Print[""]

Do[
  cyc = Cyclotomic[d, 1];
  Print["  Phi_", d, "(1) = ", cyc],
  {d, 1, 20}
]
Print[""]

Print["For n = 143 = 11 * 13:"]
Print["  Phi_143(1) = ", Cyclotomic[143, 1], " (not useful, n not prime power)"]
Print[""]

Print["7. RESULTANT / DISCRIMINANT"]
Print["==============================================================="]
Print[""]

(* The resultant of cyclotomic polynomials relates to gcd *)
(* Res(Phi_m, Phi_n) depends on gcd(m,n) *)

Print["Resultant of cyclotomics Res(Phi_m, Phi_n):"]
Print[""]

m = 11;  (* one of the factors *)
Print["Res(Phi_", m, ", Phi_143):"]
res = Resultant[Cyclotomic[m, x], Cyclotomic[143, x], x];
Print["  = ", res]
Print[""]

m = 7;  (* NOT a factor *)
Print["Res(Phi_", m, ", Phi_143):"]
res = Resultant[Cyclotomic[m, x], Cyclotomic[143, x], x];
Print["  = ", res]
Print[""]

Print["The resultant is 1 when gcd(m,n) = 1."]
Print["Non-trivial resultant when m | n or related."]
Print["But computing this for all m is still O(sqrt n)."]
Print[""]

Print["8. ORDER OF ELEMENTS"]
Print["==============================================================="]
Print[""]

Print["ord_n(a) | phi(n) for gcd(a,n) = 1"]
Print[""]

Print["If we find ord_n(2):"]
ord2 = MultiplicativeOrder[2, n];
Print["  ord_143(2) = ", ord2]
Print["  phi(143) = ", EulerPhi[n]]
Print["  ", ord2, " | ", EulerPhi[n], ": ", Divisible[EulerPhi[n], ord2]]
Print[""]

Print["The order divides phi(n), but doesn't uniquely determine it."]
Print["Shor's algorithm uses order-finding, but needs quantum parallelism."]
Print[""]

Print["9. FINAL ASSESSMENT"]
Print["==============================================================="]
Print[""]

Print["All phi-based formulas face the same issue:"]
Print[""]
Print["  Computing phi(n) REQUIRES the factorization of n."]
Print["  Using phi(n) GIVES the factorization of n."]
Print[""]
Print["  These are equivalent problems!"]
Print[""]
Print["The formulas are BEAUTIFUL but CIRCULAR for factoring."]
Print[""]

Print["Our S_inf = sum of fractional parts ALSO computes phi(n):"]
Print["  phi(n) = 1 - n + n * S_inf = ", 1 - n + n * (262/143)]
Print[""]
Print["But computing S_inf requires O(sqrt n) iteration."]
