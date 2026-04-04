\\ cheb_structure.gp — Clean structural results
\\
\\ Established:
\\   m = lcm of Lucas ranks alpha(p^e) over p^e || d  [4284/4284]
\\   alpha(p) = 2 iff p | z                            [4776/4776]
\\   alpha(p) = ord(lambda) in F_p* for split p
\\            = ord(lambda)/2 in F_p^2* for inert p
\\
\\ Now: deeper structural patterns

\p 50

lucas_rank(P, Q, m) = {
  my(u0 = 0, u1 = 1);
  for(n = 1, 6*m,
    if(u1 % m == 0, return(n));
    my(u2 = (P*u1 - Q*u0) % m);
    if(u2 < 0, u2 += m);
    u0 = u1; u1 = u2
  );
  -1
};

\\ === Symmetry: alpha(z,p) = alpha(p-z,p)? ===
{
  print("=== Symmetry alpha(z,p) = alpha(p-z,p) ===\n");
  my(nok = 0, ntot = 0);
  forprime(p = 3, 200,
    for(z = 2, p\2,
      ntot++;
      my(a1 = lucas_rank(2*z, 1, p));
      my(a2 = lucas_rank(2*(p-z), 1, p));
      if(a1 == a2, nok++)
    )
  );
  printf("alpha(z) = alpha(p-z): %d/%d = %.1f%%\n\n", nok, ntot, nok*100.0/ntot)
}

\\ === The alpha map decomposes by quadratic character ===
\\ For fixed p: the values alpha takes are divisors of p-1 (split) or p+1 (inert)
\\ The distribution of alpha values over z in [2..p-2]:
{
  print("=== Alpha value spectrum for each prime p ===\n");
  forprime(p = 5, 53,
    my(counts = Map());
    for(z = 2, p-2,
      my(a = lucas_rank(2*z, 1, p));
      mapput(~counts, a, if(mapisdefined(counts, a), mapget(counts, a)+1, 1))
    );
    printf("p=%d (p-1=%d=%s):", p, p-1, factor(p-1));
    for(d = 1, p,
      if(mapisdefined(counts, d),
        printf(" %d:%dx", d, mapget(counts, d)))
    );
    print("")
  )
}

\\ === For prime p: #(z with alpha=d) = Euler totient structure? ===
{
  print("\n=== Count z with alpha(z,p) = d, vs phi/structural count ===\n");
  forprime(p = 5, 31,
    printf("p=%d:\n", p);
    for(z = 2, p-2,
      my(a = lucas_rank(2*z, 1, p));
      my(leg = kronecker(z^2-1, p));
      \\ For QR (leg=1): alpha | p-1
      \\ For QNR (leg=-1): alpha | p+1
      \\ Number of elements of given order d in F_p*: phi(d) if d | p-1
      \\ Number of elements with half-order d in norm-1 of F_p^2:
      \\   phi(2d) if 2d | p+1 (approximately)
    )
  )
}

\\ === Key theorem: alpha(p) for the Pell-relevant z values ===
\\ When we choose z from a decomposition c^2*n = a0^2 + r,
\\ the value z mod p for p | d is CONSTRAINED by:
\\   z = (2*a0^2 + r)/r = 2*a0^2/r + 1 mod p
\\ Since p | d = r/gcd(r,2*a0): p divides r/gcd(r,2*a0).
\\ If gcd(r,2*a0) is divisible by all prime factors of r EXCEPT p:
\\   then p | r/gcd and we need p ∤ r.
\\ Actually: d = r/gcd(r, 2*a0). If p | d then p | r/gcd(r,2*a0).
{
  print("\n=== z mod p for primes p | d ===\n");

  for(n = 2, 200,
    if(issquare(n), next);
    for(c = 1, 20,
      my(cn = c^2*n, divs = divisors(2*cn));
      for(j = 1, #divs,
        my(r = divs[j]);
        if(r == 0 || r >= cn, next);
        if(!issquare(cn - r), next);
        my(a0 = sqrtint(cn - r));
        if(a0 == 0 || (2*a0^2 + r) % r != 0, next);
        my(z = (2*a0^2 + r) \ r);
        if(z <= 1, next);
        my(g = gcd(2*a0, r), dd = r \ g);
        if(dd <= 2 || dd > 50, next);

        my(fa = factor(dd));
        for(i = 1, matsize(fa)[1],
          my(p = fa[i,1]);
          if(p == 2, next);
          my(zp = z % p);
          my(alpha = lucas_rank(2*z, 1, p));
          my(leg = kronecker(core(n), p));
          my(splitting = if(leg==1,"S",if(leg==-1,"I","R")));
          \\ What algebraic value is z mod p?
          \\ z = 2*a0^2/r + 1 mod p. Since p | d = r/g where g = gcd(r,2a0):
          \\ Let v_p(r) = exponent of p in r, v_p(2a0) = exponent in 2a0.
          \\ p | d means v_p(r) > v_p(2a0), i.e., v_p(r) > v_p(a0) + (1 if p=2).
          \\ z = 2a0^2/r + 1. If p^2 | r but p | a0: 2a0^2/r mod p = ?
          printf("  n=%d c=%d p=%d: z≡%d, a0≡%d, r≡%d(mod p) alpha=%d %s\n",
            n, c, p, zp, a0%p, r%p, alpha, splitting)
        )
      )
    )
  )
}

\\ === Prime power lifting: alpha(p^2) vs alpha(p) ===
{
  print("\n=== Prime power lifting: alpha(p^e) = p^(e-1) * alpha(p)? ===\n");
  my(nok = 0, ntot = 0);
  forprime(p = 3, 50,
    for(z = 2, 50,
      my(a1 = lucas_rank(2*z, 1, p));
      my(a2 = lucas_rank(2*z, 1, p^2));
      ntot++;
      if(a2 == p * a1, nok++,
        if(ntot - nok <= 10,
          printf("  p=%d z=%d: alpha(p)=%d alpha(p^2)=%d ratio=%.2f\n",
            p, z, a1, a2, a2*1.0/a1))
      )
    )
  );
  printf("\nalpha(p^2) = p * alpha(p): %d/%d = %.1f%%\n", nok, ntot, nok*100.0/ntot)
}

\\ === MAIN THEOREM SUMMARY ===
{
  print("\n========================================");
  print("=== CHEBYSHEV-PELL PERIOD THEOREM ===");
  print("========================================\n");
  print("Given: n non-square, c >= 1, decomposition c^2*n = a0^2 + r");
  print("  with z = (2*a0^2 + r)/r ∈ Z, w = 2*a0/r = p_w/d (reduced)\n");
  print("Then: x = T_m(z), y = c*w*U_{m-1}(z) solves x^2 - n*y^2 = 1");
  print("  where m = lcm_{p^e || d} alpha(p^e)\n");
  print("  alpha(p^e) = Lucas rank of apparition of (2z, 1) mod p^e\n");
  print("Properties:");
  print("  (1) alpha(p) = 2 iff p | z");
  print("  (2) alpha(p) | p-1 if n is QR mod p (p splits in Q(sqrt(n)))");
  print("      alpha(p) | p+1 if n is QNR mod p (p inert)");
  print("  (3) alpha(p) = ord(z+sqrt(z^2-1)) mod p [QR: in F_p*, QNR: half-order in F_p^2*]");
  print("  (4) alpha(p^e) = p^(e-1) * alpha(p) [standard lifting]");
  print("  (5) alpha(z,p) = alpha(p-z,p) [symmetry]");
  print("  (6) Regulator: R = m * arccosh(z) / k where k = R_pell / (m*arccosh(z))");
}
