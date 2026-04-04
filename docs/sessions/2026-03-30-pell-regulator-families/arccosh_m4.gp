\\ arccosh_m4.gp — Final questions:
\\ Q1: Are ALL R-D m values = 1? (or some > 1?)
\\ Q2: For delta=2 + n≡1(4): always m=1?
\\ Q3: Divisor method: for each n, BEST R-D decomposition

\p 100

\\ === Q1: m value distribution for R-D decompositions ===
{
  print("=== Q1: m values for R-D decompositions (r|2a0) ===\n");
  my(maxn = 10000, mcounts = Map(), ntot = 0);

  for(n = 2, maxn,
    if(issquare(n), next);
    for(a0 = 1, sqrtint(n),
      my(r = n - a0^2);
      if(r <= 0 || r > 2*a0, next);
      if((2*a0) % r != 0, next);
      ntot++;

      my(z = (2*a0^2 + r) / r);
      my(az = acosh(z * 1.0));

      \\ Use Pell regulator
      my(D = 4*n, h = qfbclassno(D));
      my(Rfield = quadregulator(D));
      \\ Check norm of fundamental unit via quadunit
      my(fu = quadunit(D));
      my(nm = norm(fu));
      my(Rpell = if(nm < 0, 2*Rfield, Rfield));

      my(m = round(Rpell / az));
      mapput(~mcounts, m, if(mapisdefined(mcounts, m), mapget(mcounts, m) + 1, 1))
    )
  );

  printf("Total R-D decompositions: %d\n", ntot);
  \\ Print m distribution
  for(m = 1, 20,
    if(mapisdefined(mcounts, m),
      printf("  m=%d: %d\n", m, mapget(mcounts, m)))
  )
}

\\ === Q2: delta=2 cases (n≡1 mod 4, default a0) ===
{
  print("\n=== Q2: delta=2 default decompositions (not R-D) ===\n");
  my(maxn = 10000, ntot = 0, m1 = 0, m3 = 0, mother = 0);
  my(others = List());

  for(n = 2, maxn,
    if(issquare(n), next);
    my(a0 = sqrtint(n), r = n - a0^2);
    my(z = (2*a0^2 + r) / r);
    my(delta = denominator(z));
    if(delta != 2, next);

    \\ Not R-D
    if((2*a0) % r == 0, next);

    ntot++;
    my(az = acosh(z * 1.0));
    my(D = 4*n);
    my(Rfield = quadregulator(D));
    my(nm = norm(quadunit(D)));
    my(Rpell = if(nm < 0, 2*Rfield, Rfield));
    my(m = round(Rpell / az));
    my(frac = abs(Rpell/az - m));
    if(frac > 0.001,
      listput(others, [n, Rpell/az]);
      mother++; next
    );
    if(m == 1, m1++,
      if(m == 3, m3++,
        listput(others, [n, m]);
        mother++
      )
    )
  );

  printf("Total delta=2 non-R-D: %d\n", ntot);
  printf("  m=1: %d\n", m1);
  printf("  m=3: %d\n", m3);
  printf("  other: %d\n", mother);
  if(#others > 0 && #others <= 20,
    print("  details:");
    for(j = 1, #others,
      printf("    n=%d val=%s\n", others[j][1], others[j][2])))
}

\\ === Q3: R-D coverage via divisor method: for each n, check ALL r|4n ===
{
  print("\n=== Q3: R-D via divisor method: coverage ===\n");
  my(maxn = 5000, covered = 0, uncovered = 0, ntot = 0);
  my(uncov_list = List());

  for(n = 2, maxn,
    if(issquare(n), next);
    ntot++;

    \\ Check: does any r | 4n with n-r = square and r | 2*sqrt(n-r) exist?
    my(found = 0);
    my(divs = divisors(4*n));
    for(k = 1, #divs,
      my(r = divs[k]);
      if(r == 0 || r >= n, next);
      if(!issquare(n - r), next);
      my(a0 = sqrtint(n - r));
      if(a0 == 0, next);
      if((2*a0) % r != 0, next);
      found = 1; break
    );

    \\ Also check delta=2 non-R-D (n≡1 mod 4)
    if(!found,
      for(k = 1, #divs,
        my(r = divs[k]);
        if(r == 0 || r >= n, next);
        if(!issquare(n - r), next);
        my(a0 = sqrtint(n - r));
        if(a0 == 0, next);
        my(z = (2*a0^2 + r) / r);
        my(delta = denominator(z));
        if(delta == 2 && n % 4 == 1, found = 1; break)
      )
    );

    if(found, covered++,
      uncovered++;
      if(uncovered <= 30, listput(uncov_list, n))
    )
  );

  printf("Coverage: %d/%d = %.1f%%\n", covered, ntot, covered*100.0/ntot);
  printf("Uncovered: %d (first 30: %s)\n", uncovered,
    Vec(uncov_list))
}

\\ === Q4: Is the idea of MULTIPLE arccosh values useful? ===
\\ For n with 2+ decompositions: check if arccosh ratios are rational
{
  print("\n=== Q4: Arccosh ratios between decompositions ===\n");
  my(examples = [12, 20, 30, 56, 72, 99, 110, 132, 156, 240]);

  for(j = 1, #examples,
    my(n = examples[j]);
    if(issquare(n), next);
    my(R = quadregulator(4*n));
    my(nm = norm(quadunit(4*n)));
    my(Rpell = if(nm < 0, 2*R, R));
    my(decomps = List());

    my(divs = divisors(4*n));
    for(k = 1, #divs,
      my(r = divs[k]);
      if(r == 0 || r >= n, next);
      if(!issquare(n - r), next);
      my(a0 = sqrtint(n - r));
      if(a0 == 0, next);
      if((2*a0) % r != 0, next);
      my(z = (2*a0^2 + r) / r);
      my(az = acosh(z * 1.0));
      my(m = round(Rpell / az));
      listput(decomps, [r, a0, az, m])
    );

    if(#decomps >= 2,
      printf("n=%d (R_pell=%.6f, %d R-D decompositions):\n", n, Rpell, #decomps);
      for(k = 1, #decomps,
        my(d = decomps[k]);
        printf("  r=%-3d a0=%-3d arccosh=%.6f m=%d\n", d[1], d[2], d[3], d[4])
      );
      \\ Ratios
      for(k1 = 1, #decomps - 1,
        for(k2 = k1 + 1, #decomps,
          my(ratio = decomps[k1][3] / decomps[k2][3]);
          printf("    ratio [r=%d]/[r=%d] = %.6f = %d/%d\n",
            decomps[k1][1], decomps[k2][1], ratio,
            decomps[k2][4], decomps[k1][4])
        )
      );
      print("")
    )
  )
}
