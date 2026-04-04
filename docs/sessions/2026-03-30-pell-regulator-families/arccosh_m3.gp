\\ arccosh_m3.gp — Check the "surprise" cases + fix norm sign

\p 200  \\ extra precision

\\ === Check the 9 surprise cases with delta > 2 ===
{
  print("=== Surprise cases (delta > 2 but apparent integer m) ===\n");

  \\ Find them
  for(n = 2, 10000,
    if(issquare(n), next);
    my(a0 = sqrtint(n), r = n - a0^2);
    my(z = (2*a0^2 + r) / r);
    my(delta = denominator(z));
    if(delta <= 2, next);  \\ skip normal cases

    my(az = acosh(z * 1.0));
    my(R = quadregulator(4*n));
    my(m_exact = R / az);
    my(frac = abs(m_exact - round(m_exact)));
    if(frac < 0.01,
      printf("n=%-5d a0=%d r=%d delta=%d  m=%.15f  frac=%.2e\n",
        n, a0, r, delta, m_exact, frac);

      \\ Check: is r | 2a0 after gcd simplification?
      my(g = gcd(r, 2*a0));
      printf("   gcd(r,2a0)=%d  r/gcd=%d  2a0/gcd=%d\n", g, r/g, 2*a0/g);

      \\ Factor n
      printf("   n=%s  n mod 4 = %d\n\n", factor(n), n % 4)
    )
  )
}

\\ === Fix norm sign: use Pell regulator (norm+1) instead of field regulator ===
{
  print("=== Using PELL regulator (2R when norm=-1) ===\n");
  my(maxn = 10000, nok = 0, ntot_rd = 0, nbad = 0);

  for(n = 2, maxn,
    if(issquare(n), next);

    \\ Find R-D decompositions: r | 2a0
    for(a0 = 1, sqrtint(n),
      my(r = n - a0^2);
      if(r <= 0 || r > 2*a0, next);
      if((2*a0) % r != 0, next);
      ntot_rd++;

      my(z = (2*a0^2 + r) / r);
      my(az = acosh(z * 1.0));

      \\ Pell regulator: if fundamental unit has norm -1, double it
      my(Rfield = quadregulator(4*n));
      my(qf = bnfinit(x^2 - n).fu[1]);
      my(nm = nfeltnorm(nfinit(x^2 - n), qf));
      my(Rpell = if(nm < 0, 2*Rfield, Rfield));

      my(m = Rpell / az);
      my(frac = abs(m - round(m)));
      if(frac < 0.001, nok++,
        nbad++;
        if(nbad <= 10,
          printf("  BAD: n=%d a0=%d r=%d delta=%d m=%.6f norm=%d\n",
            n, a0, r, denominator(z), m, nm))
      )
    )
  );
  printf("\nWith Pell regulator: %d/%d give integer m (%d bad)\n",
    nok, ntot_rd, nbad);
}

\\ === What if we compute alpha directly and check if it's in O_K? ===
{
  print("\n=== Alpha = (a0+sqrt(n))^2/r — when is it in O_K? ===\n");

  \\ For delta=1 (z integer, w integer): alpha in Z[sqrt(n)] always
  \\ For delta=2 (z half-int, w half-int): alpha in O_K iff n ≡ 1 mod 4
  \\   (because O_K = Z[(1+sqrt(n))/2] for n ≡ 1 mod 4)

  \\ Count cases where alpha in O_K but delta=2 and n ≡ 1 mod 4
  my(nyes = 0, nno = 0);
  for(n = 2, 5000,
    if(issquare(n), next);
    my(a0 = sqrtint(n), r = n - a0^2);
    my(delta = denominator((2*a0^2 + r) / r));
    if(delta != 2, next);
    if(n % 4 == 1,
      \\ alpha = z + w*sqrt(n) with z, w half-integers
      \\ Write alpha = a + b*(1+sqrt(n))/2: w = b/2, z = a + b/2
      \\ So b = 2w, a = z - w. Both must be integers.
      my(w = 2*a0/r, z = (2*a0^2+r)/r);
      my(b = 2*w, aa = z - w);
      if(denominator(b) == 1 && denominator(aa) == 1, nyes++, nno++)
    ,
      nno++  \\ n ≡ 2,3 mod 4: O_K = Z[sqrt(n)], half-ints not in O_K
    )
  );
  printf("delta=2, n≡1(4): alpha in O_K: %d, not in O_K: %d\n", nyes, nno);
}

\\ === The REAL question: for general n, what's the quotient structure? ===
{
  print("\n=== Quotient R/arccosh(z) distribution (default decomp) ===\n");
  my(maxn = 1000);
  my(rationals = 0, integers = 0, half_ints = 0, third_ints = 0);
  my(others = List());

  for(n = 2, maxn,
    if(issquare(n), next);
    my(a0 = sqrtint(n), r = n - a0^2);
    my(z = (2*a0^2 + r) / r);
    my(az = acosh(z * 1.0));
    my(R = quadregulator(4*n));
    my(q = R / az);

    \\ Check if q is close to p/d for small d
    my(found = 0);
    for(d = 1, 12,
      my(qd = q * d);
      if(abs(qd - round(qd)) < 0.001,
        if(d == 1, integers++);
        if(d == 2, half_ints++);
        if(d == 3, third_ints++);
        found = 1; break
      )
    );
    if(!found, listput(others, [n, q]))
  );

  printf("Integers: %d\n", integers);
  printf("Half-integers: %d\n", half_ints);
  printf("Thirds: %d\n", third_ints);
  printf("Other: %d\n", #others);
  if(#others > 0 && #others <= 20,
    for(j = 1, #others,
      printf("  n=%d q=%.6f\n", others[j][1], others[j][2])
    )
  );
  if(#others > 20,
    printf("  (first 10:)\n");
    for(j = 1, 10,
      printf("  n=%d q=%.6f\n", others[j][1], others[j][2])
    )
  )
}
