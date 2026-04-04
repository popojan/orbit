\\ cheb_theory.gp — Theory of Chebyshev period mod d
\\
\\ Key connection: U_k(z) = LucasU_{k+1}(2z, 1)
\\ So d | U_{m-1}(z) iff LucasU_m(2z, 1) ≡ 0 mod d
\\
\\ The "rank of apparition" α(p) = smallest n>0 with LucasU_n(P,Q) ≡ 0 mod p
\\ is well-studied. α(p) | p - (Δ|p) where Δ = P²-4Q = 4z²-4 = 4(z²-1).
\\
\\ Conjecture: m = lcm of α(p^e) over prime powers p^e || d.

\p 50

\\ Lucas rank of apparition: smallest n>0 with LucasU_n(P,Q) ≡ 0 mod m
\\ LucasU: U_0=0, U_1=1, U_n = P*U_{n-1} - Q*U_{n-2}
lucas_rank(P, Q, m) = {
  my(u0 = 0, u1 = 1);
  for(n = 1, 4*m + 10,
    if(u1 % m == 0, return(n));
    my(u2 = (P*u1 - Q*u0) % m);
    if(u2 < 0, u2 += m);
    u0 = u1; u1 = u2
  );
  -1  \\ not found
};

\\ Chebyshev zero: smallest k>=0 with d | U_k(z)
cheb_zero(z, d) = {
  if(d == 1, return(0));
  my(zm = z % d, u0 = 1, u1 = (2*zm) % d);
  if(u1 < 0, u1 += d);
  if(u0 % d == 0, return(0));
  if(u1 % d == 0, return(1));
  for(k = 2, 4*d*d,
    my(u2 = (2*zm*u1 - u0) % d);
    if(u2 < 0, u2 += d);
    if(u2 == 0, return(k));
    u0 = u1; u1 = u2
  );
  -1
};

\\ === Part 1: Verify m = lcm(ranks) formula ===
{
  print("=== PART 1: Verify m = lcm(alpha(p^e)) ===\n");
  my(test_cases = [
    \\ [z, d, expected_m]  (m = cheb_zero + 1)
    [6649, 86, 42],   \\ n=13078849728, c=5
    [3, 2, 2],        \\ n=32, c=1
    [8, 2, 2],        \\ n=28, c=3
    [24, 1, 1],       \\ n=23, c=5 (trivial)
    [8, 1, 1]         \\ n=7, c=3
  ]);

  for(j = 1, #test_cases,
    my(z = test_cases[j][1], d = test_cases[j][2], m_exp = test_cases[j][3]);
    my(k = cheb_zero(z, d));
    my(m_actual = k + 1);

    \\ Compute lcm of ranks
    my(fa = factor(d));
    my(m_lcm = 1);
    printf("z=%d d=%d (=%s):\n", z, d,
      concat([Str(fa[i,1], "^", fa[i,2], " ") | i <- [1..matsize(fa)[1]]]));

    for(i = 1, matsize(fa)[1],
      my(p = fa[i,1], e = fa[i,2], pe = p^e);
      my(P = 2*z, Q = 1);
      my(alpha = lucas_rank(P, Q, pe));
      my(delta = 4*(z^2 - 1));
      my(leg = if(p == 2, 0, kronecker(delta, p)));
      printf("  p^e=%d: alpha=%d  (p-%s=%d)\n",
        pe, alpha, if(leg >= 0, Str("(",leg,")"), Str("(",leg,")")), p - leg);
      m_lcm = lcm(m_lcm, alpha)
    );

    printf("  lcm(alphas) = %d, actual m = %d, expected = %d  %s\n\n",
      m_lcm, m_actual, m_exp, if(m_lcm == m_actual, "OK", "MISMATCH!"))
  )
}

\\ === Part 2: Generate more test cases and verify ===
{
  print("=== PART 2: Systematic verification ===\n");
  my(nok = 0, ntot = 0, failures = List());

  for(n = 2, 500,
    if(issquare(n), next);
    for(c = 1, 20,
      my(cn = c^2*n);
      my(divs = divisors(2*cn));
      for(j = 1, #divs,
        my(r = divs[j]);
        if(r == 0 || r >= cn, next);
        if(!issquare(cn - r), next);
        my(a0 = sqrtint(cn - r));
        if(a0 == 0, next);
        my(z = (2*a0^2 + r) \ r);
        if((2*a0^2 + r) % r != 0, next);
        if(z <= 1, next);

        my(g = gcd(2*a0, r), dd = r \ g);
        if(dd <= 1 || dd > 200, next);  \\ only d > 1 for interesting cases

        ntot++;
        my(k = cheb_zero(z, dd));
        if(k < 0, next);
        my(m_actual = k + 1);

        \\ Compute lcm of ranks
        my(fa = factor(dd), m_lcm = 1);
        for(i = 1, matsize(fa)[1],
          my(pe = fa[i,1]^fa[i,2]);
          my(alpha = lucas_rank(2*z, 1, pe));
          if(alpha < 0,
            m_lcm = -1; break);
          m_lcm = lcm(m_lcm, alpha)
        );
        if(m_lcm < 0, next);

        if(m_lcm == m_actual, nok++,
          listput(failures, [n, c, z, dd, m_actual, m_lcm])
        )
      )
    )
  );

  printf("Verified: %d/%d\n", nok, ntot);
  if(#failures > 0,
    print("Failures:");
    for(j = 1, min(10, #failures),
      printf("  n=%d c=%d z=%d d=%d m_actual=%d m_lcm=%d\n",
        failures[j][1], failures[j][2], failures[j][3],
        failures[j][4], failures[j][5], failures[j][6]));
  )
}

\\ === Part 3: Distribution of alpha(p) for random z, p ===
{
  print("\n=== PART 3: Distribution of alpha(p) ===\n");
  print("For prime p: alpha | p-(z^2-1|p). What fraction of p±1?\n");

  my(data = Map());
  forprime(p = 3, 200,
    for(z = 2, 50,
      my(alpha = lucas_rank(2*z, 1, p));
      my(leg = kronecker(4*(z^2-1), p));
      my(bound = p - leg);
      my(ratio = bound / alpha);
      if(!mapisdefined(data, ratio),
        mapput(~data, ratio, 1),
        mapput(~data, ratio, mapget(data, ratio) + 1)
      )
    )
  );

  \\ Print ratio distribution
  my(ratios = List());
  for(r = 1, 200,
    if(mapisdefined(data, r),
      listput(ratios, [r, mapget(data, r)]))
  );
  my(total = sum(j = 1, #ratios, ratios[j][2]));
  printf("Ratio (p-(leg))/alpha distribution (%d cases):\n", total);
  for(j = 1, min(15, #ratios),
    printf("  ratio=%d: %d (%.1f%%)\n",
      ratios[j][1], ratios[j][2], ratios[j][2]*100.0/total))
}

\\ === Part 4: The eigenvalue interpretation ===
{
  print("\n=== PART 4: Eigenvalue λ = z + sqrt(z²-1) mod p ===\n");
  print("alpha(p) = ord(λ) in F_p* (when z²-1 is QR) or F_p²* (QNR)\n\n");

  \\ For the n=13078849728 example
  my(z = 6649, p = 43);
  my(zm = z % p);  \\ = 27
  my(delta = (zm^2 - 1) % p);  \\ z^2-1 mod p
  my(leg = kronecker(delta, p));
  printf("z=%d mod %d = %d, z²-1 mod %d = %d, Legendre = %d\n",
    z, p, zm, p, delta, leg);

  if(leg == 1,
    \\ sqrt(z²-1) exists in F_p
    my(sq = Mod(delta, p)^((p+1)/4));  \\ valid when p ≡ 3 mod 4
    if(p % 4 != 3,
      \\ use Tonelli-Shanks or PARI
      sq = sqrt(Mod(delta, p))
    );
    my(lam = Mod(zm, p) + sq);
    printf("λ = %d + %d = %d mod %d\n", zm, lift(sq), lift(lam), p);
    my(ord_lam = znorder(lam));
    printf("ord(λ) = %d\n", ord_lam);
    my(alpha = lucas_rank(2*z, 1, p));
    printf("alpha(p) = %d\n", alpha);
    printf("Match: %s\n\n", if(ord_lam == alpha, "YES", "NO"))
  );

  \\ More examples: check alpha = ord(lambda) for various (z, p)
  print("Systematic check alpha = ord(lambda):");
  my(nok = 0, ntot = 0);
  forprime(p = 3, 100,
    for(z = 2, 30,
      my(zm = z % p);
      if(zm <= 1, next);
      my(delta = (zm^2 - 1) % p);
      my(leg = kronecker(delta, p));
      ntot++;

      my(alpha = lucas_rank(2*z, 1, p));

      if(leg == 1,
        \\ lambda in F_p
        my(sq = sqrt(Mod(delta, p)));
        my(lam = Mod(zm, p) + sq);
        my(ord_lam = znorder(lam));
        if(ord_lam == alpha, nok++,
          if(ntot - nok <= 5,
            printf("  MISMATCH: z=%d p=%d alpha=%d ord=%d (QR)\n",
              z, p, alpha, ord_lam)))
      ,
        \\ lambda in F_p² — need to work in the extension
        \\ λ = z + sqrt(z²-1) in F_p[x]/(x²-(z²-1))
        my(T = Mod(Mod(1, p)*x + zm, x^2 - delta));
        my(ord_lam = 1);
        my(power = T);
        while(power != Mod(1, x^2 - delta),
          power = power * T;
          ord_lam++;
          if(ord_lam > p^2, break)
        );
        if(ord_lam <= p^2 && ord_lam == alpha, nok++,
          if(ntot - nok <= 5 && ord_lam <= p^2,
            printf("  MISMATCH: z=%d p=%d alpha=%d ord=%d (QNR)\n",
              z, p, alpha, ord_lam)))
      )
    )
  );
  printf("alpha = ord(lambda): %d/%d\n", nok, ntot)
}

\\ === Part 5: When alpha(p) = p-1 (primitive root case) ===
{
  print("\n=== PART 5: Fraction of cases where alpha = p-1 or p+1 ===\n");
  my(n_max = 0, n_full = 0, ntot = 0);

  forprime(p = 3, 500,
    for(z = 2, min(50, p-1),
      my(leg = kronecker(4*(z^2-1), p));
      my(alpha = lucas_rank(2*z, 1, p));
      my(bound = p - leg);
      ntot++;
      if(alpha == bound, n_max++);
      if(alpha * 2 >= bound, n_full++)
    )
  );

  printf("alpha = p-(leg) (maximal): %d/%d = %.1f%%\n",
    n_max, ntot, n_max*100.0/ntot);
  printf("alpha >= (p-(leg))/2: %d/%d = %.1f%%\n",
    n_full, ntot, n_full*100.0/ntot);
  print("(Similar to primitive root density ≈ 37.4%)")
}
