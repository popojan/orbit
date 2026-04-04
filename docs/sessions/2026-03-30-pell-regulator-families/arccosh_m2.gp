\\ arccosh_m2.gp — Deeper investigation
\\ Q1: Is n=13078849728 m=42 exact?
\\ Q2: For each n, try ALL r|4n decompositions — any give integer m?
\\ Q3: What algebraic condition makes m integer?

\p 100

\\ === Q1: Verify n=13078849728 ===
{
  print("=== Q1: n=13078849728 ===\n");
  my(n = 13078849728);
  my(a0 = sqrtint(n), r = n - a0^2);
  my(z = (2*a0^2 + r) / r);
  my(w = 2*a0 / r);
  printf("a0=%d r=%d z=%s delta=%d\n", a0, r, z, denominator(z));
  printf("w=%s\n", w);

  \\ Check: z^2 - n*w^2 = ?
  printf("z^2 - n*w^2 = %s (should be 1)\n", z^2 - n*w^2);

  my(R = quadregulator(4*n));
  my(az = acosh(z * 1.0));
  my(ratio = R / az);
  printf("R = %.50f\n", R);
  printf("arccosh(z) = %.50f\n", az);
  printf("R/arccosh(z) = %.20f\n", ratio);
  printf("round = %d, frac = %.2e\n", round(ratio), abs(ratio - round(ratio)));
}

\\ === Q2: For the 1087 "good" n: what is delta? ===
{
  print("\n=== Q2: Delta distribution of integer-m cases ===\n");
  my(maxn = 10000, d1 = 0, d2 = 0, dother = 0);

  for(n = 2, maxn,
    if(issquare(n), next);
    my(a0 = sqrtint(n), r = n - a0^2);
    my(z = (2*a0^2 + r) / r);
    my(az = acosh(z * 1.0));
    my(R = quadregulator(4*n));
    my(m_exact = R / az);
    my(frac = abs(m_exact - round(m_exact)));
    if(frac < 0.001,
      my(delta = denominator(z));
      if(delta == 1, d1++,
        if(delta == 2, d2++,
          dother++;
          if(dother <= 5,
            printf("  SURPRISE: n=%d delta=%d m=%d r=%d\n",
              n, delta, round(m_exact), r))
        ))
    )
  );
  printf("delta=1: %d\n", d1);
  printf("delta=2: %d\n", d2);
  printf("delta>2: %d\n", dother);
}

\\ === Q3: Try all divisor decompositions for hard primes ===
{
  print("\n=== Q3: Divisor method — any integer m? ===\n");
  my(primes = [7, 14, 19, 23, 31, 67, 127, 193, 409, 541, 991]);

  for(j = 1, #primes,
    my(n = primes[j]);
    my(R = quadregulator(4*n));
    printf("n=%d R=%.6f\n", n, R);

    \\ Try all r | 4n with n-r = square, r < n
    my(divs = divisors(4*n), found_int = 0);
    for(k = 1, #divs,
      my(r = divs[k]);
      if(r >= n || r == 0, next);
      if(!issquare(n - r), next);
      my(a0 = sqrtint(n - r));
      if(a0^2 + r != n, next);  \\ sanity
      my(z = (2*a0^2 + r) / r);
      if(z <= 1, next);
      my(az = acosh(z * 1.0));
      my(m = R / az);
      my(frac = abs(m - round(m)));
      my(is_int = frac < 0.001);
      if(is_int, found_int++);
      printf("  r=%-4d a0=%-3d delta=%-4d m=%.4f %s\n",
        r, a0, denominator(z), m, if(is_int, " <-- INTEGER", ""))
    );
    if(!found_int, print("  (no integer m found)"));
    print("")
  )
}

\\ === Q4: Scaling approach: try c^2*n ===
{
  print("\n=== Q4: Scaling c^2*n for hard primes ===\n");
  my(hard = [127, 193]);

  for(j = 1, #hard,
    my(n = hard[j]);
    my(R = quadregulator(4*n));
    printf("n=%d R=%.6f\n", n, R);

    for(c = 1, 30,
      my(cn = c^2 * n);
      my(a0 = sqrtint(cn), r = cn - a0^2);
      if(r == 0, next);
      my(z = (2*a0^2 + r) / r);
      my(delta = denominator(z));
      if(delta > 2, next);  \\ only delta<=2

      my(az = acosh(z * 1.0));
      \\ Now Rc = log of Pell solution for cn = c^2*n
      \\ This relates to R via: Rc = k * R for some integer k
      my(Rc = quadregulator(4*cn));
      my(m = Rc / az);
      my(frac = abs(m - round(m)));
      if(frac < 0.001,
        printf("  c=%d cn=%d r=%d delta=%d m=%d Rc/R=%.3f\n",
          c, cn, r, delta, round(m), Rc/R))
    );
    print("")
  )
}

\\ === Q5: What if we use r|2*a0 decompositions specifically? ===
{
  print("\n=== Q5: R-D decompositions (r|2a0) — always integer m? ===\n");
  my(maxn = 1000, nok = 0, ntot = 0, nbad = 0);

  for(n = 2, maxn,
    if(issquare(n), next);

    \\ Find all a0, r with n = a0^2 + r and r | 2*a0
    for(a0 = 1, sqrtint(n),
      my(r = n - a0^2);
      if(r <= 0, next);
      if(r > 2*a0, next);  \\ only small r
      if((2*a0) % r != 0, next);  \\ r | 2a0

      ntot++;
      my(z = (2*a0^2 + r) / r);
      my(az = acosh(z * 1.0));
      my(R = quadregulator(4*n));
      my(m = R / az);
      my(frac = abs(m - round(m)));
      if(frac < 0.001, nok++,
        nbad++;
        if(nbad <= 10,
          printf("  BAD: n=%d a0=%d r=%d delta=%d m=%.4f\n",
            n, a0, r, denominator(z), m))
      )
    )
  );
  printf("\nr|2a0 decompositions: %d/%d give integer m (%d bad)\n", nok, ntot, nbad);
}
