\\ arccosh_m.gp — Verify R = m * arccosh(z) universally
\\ and explore Bach estimate for predicting m
\\
\\ Key identity: for n = a0^2 + r, z = (2*a0^2 + r)/r,
\\   alpha = z + (2*a0/r)*sqrt(n) has norm 1 in Q(sqrt(n))
\\   hence alpha = eps^m for unique positive integer m
\\   and R = m * arccosh(z)

\p 100  \\ 100 digits precision

\\ === Part 1: Verify R = m * arccosh(z) for all non-square n ===
{
  print("=== PART 1: Verify R = m * arccosh(z) ===\n");
  my(maxn = 10000, nok = 0, ntot = 0, worst_frac = 0.0, worst_n = 0);
  my(mvals = Map());

  for(n = 2, maxn,
    if(issquare(n), next);
    ntot++;

    my(a0 = sqrtint(n), r = n - a0^2);
    my(z = (2*a0^2 + r) / r);   \\ exact rational
    my(az = acosh(z * 1.0));     \\ arccosh(z) at current precision

    my(R = quadregulator(4*n));

    my(m_exact = R / az);
    my(m_round = round(m_exact));
    my(frac = abs(m_exact - m_round));

    if(frac > worst_frac, worst_frac = frac; worst_n = n);
    if(frac > 0.01,
      printf("BAD: n=%d m_exact=%.6f frac=%.6f\n", n, m_exact, frac);
      next
    );
    nok++;

    \\ Collect m distribution
    mapput(~mvals, m_round,
      if(mapisdefined(mvals, m_round), mapget(mvals, m_round) + 1, 1))
  );

  printf("\nVerified: %d/%d (worst frac = %.2e at n=%d)\n", nok, ntot, worst_frac, worst_n);

  \\ Print m distribution
  print("\nm distribution:");
  my(keys = Vec(mvals));
  \\ Actually, iterate manually
  my(mcounts = List());
  for(n = 2, maxn,
    if(issquare(n), next);
    my(a0 = sqrtint(n), r = n - a0^2);
    my(z = (2*a0^2 + r) / r);
    my(az = acosh(z * 1.0));
    my(R = quadregulator(4*n));
    my(m = round(R / az));
    listput(mcounts, m)
  );
  my(v = Vec(mcounts));
  my(vmax = vecmax(v));
  printf("  m range: 1..%d\n", vmax);
  printf("  m=1: %d\n", #select(x -> x == 1, v));
  printf("  m=2: %d\n", #select(x -> x == 2, v));
  printf("  m=3: %d\n", #select(x -> x == 3, v));
  printf("  m<=5: %d\n", #select(x -> x <= 5, v));
  printf("  m<=10: %d\n", #select(x -> x <= 10, v));
  printf("  median: %d\n", vecsort(v)[#v\2]);
  printf("  mean: %.1f\n", vecsum(v)*1.0/#v);
}

\\ === Part 2: Bach L-function estimate ===
{
  print("\n=== PART 2: Bach L(1,chi) estimate for m ===\n");

  \\ L(1, chi_D) where D = 4n (fundamental or not)
  \\ L(1, chi) = sum_{k=1}^Q kronecker(D,k)/k for Q = (4n)^{1/5}
  bach_L1(n) = {
    my(D = 4*n, Q = ceil(D^0.2));
    my(s = 0.0);
    for(k = 1, Q,
      my(kr = kronecker(D, k));
      if(kr, s += kr / (k * 1.0))
    );
    s
  };

  \\ E = sqrt(n) * L(1,chi) ~ h * R
  bach_E(n) = sqrt(n * 1.0) * bach_L1(n);

  my(maxn = 5000, nok = 0, ntot = 0);
  my(errors = List());

  for(n = 2, maxn,
    if(issquare(n), next);
    ntot++;

    my(a0 = sqrtint(n), r = n - a0^2);
    my(z = (2*a0^2 + r) / r);
    my(az = acosh(z * 1.0));
    my(R = quadregulator(4*n));
    my(m_true = round(R / az));

    \\ Bach estimate
    my(E = bach_E(n));
    my(m_est = round(E / az));

    \\ m_est should be h * m_true
    my(ratio = m_est * 1.0 / m_true);

    if(abs(ratio - round(ratio)) < 0.1 && round(ratio) >= 1,
      nok++;
      listput(errors, round(ratio))
    ,
      if(ntot <= 20 || #errors < 10,
        printf("  n=%d m_true=%d m_est=%d ratio=%.3f E=%.3f R=%.6f\n",
          n, m_true, m_est, ratio, E, R))
    )
  );

  printf("\nBach estimate: %d/%d have m_est = h*m_true (h integer)\n", nok, ntot);

  \\ h distribution
  my(v = Vec(errors));
  printf("  h=1 (exact): %d\n", #select(x -> x == 1, v));
  printf("  h=2: %d\n", #select(x -> x == 2, v));
  printf("  h=3: %d\n", #select(x -> x == 3, v));
  printf("  h>=4: %d\n", #select(x -> x >= 4, v));
}

\\ === Part 3: Accuracy of m prediction for h=1 case ===
{
  print("\n=== PART 3: Direct m prediction (h=1 discriminants) ===\n");

  my(maxn = 5000, nok_exact = 0, nok_within1 = 0, ntot = 0);

  for(n = 2, maxn,
    if(issquare(n), next);
    my(D = 4*n);
    my(h = qfbclassno(D));
    if(h != 1, next);  \\ only h=1 cases
    ntot++;

    my(a0 = sqrtint(n), r = n - a0^2);
    my(z = (2*a0^2 + r) / r);
    my(az = acosh(z * 1.0));
    my(R = quadregulator(D));
    my(m_true = round(R / az));

    my(E = bach_E(n));
    my(m_est = round(E / az));

    if(m_est == m_true, nok_exact++);
    if(abs(m_est - m_true) <= 1, nok_within1++);
  );

  printf("h=1 discriminants up to n=%d: %d cases\n", 5000, ntot);
  printf("  m predicted exactly: %d/%d = %.1f%%\n",
    nok_exact, ntot, nok_exact*100.0/ntot);
  printf("  m within ±1: %d/%d = %.1f%%\n",
    nok_within1, ntot, nok_within1*100.0/ntot);
}

\\ === Part 4: Multiple decompositions ===
{
  print("\n=== PART 4: Multiple decompositions via divisors of 4n ===\n");
  print("For each r|4n with n-r=square: we get an arccosh. All give same R.\n");

  my(examples = [127, 193, 541, 991, 67, 211, 409]);
  for(j = 1, #examples,
    my(n = examples[j]);
    my(R = quadregulator(4*n));
    printf("n=%d, R=%.6f:\n", n, R);

    my(divs = divisors(4*n));
    my(found = 0);
    for(k = 1, #divs,
      my(r = divs[k]);
      if(r >= n, next);
      if(!issquare(n - r), next);
      my(a0 = sqrtint(n - r));
      my(z = (2*a0^2 + r) / r);
      if(z <= 1, next);
      my(az = acosh(z * 1.0));
      my(m = round(R / az));
      my(frac = abs(R/az - m));
      my(delta = denominator(z));
      printf("  r=%-6d a0=%-5d z=%-12s delta=%-5d acosh=%.6f  m=%d (frac=%.2e)\n",
        r, a0, Str(z), delta, az, m, frac);
      found++
    );
    if(!found, print("  (no decomposition found)"))
  )
}
