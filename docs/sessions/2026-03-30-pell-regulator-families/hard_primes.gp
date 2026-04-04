\\ hard_primes.gp — Attack hard primes via Chebyshev period (d>1)
\\ For n=127: try all (c, a0) with a0^2 < c^2*n and z integer

\p 100

\\ Chebyshev zero: find smallest k with d | U_k(z)
cheb_zero(z, d, maxiter=50000) = {
  if(d == 1, return(0));
  my(zm = z % d, u0 = 1 % d, u1 = (2*zm) % d);
  if(u0 == 0, return(0));
  if(u1 == 0, return(1));
  my(u_prev = u0, u_cur = u1);
  for(k = 2, maxiter,
    my(u_next = (2*zm*u_cur - u_prev) % d);
    if(u_next < 0, u_next += d);
    if(u_next == 0, return(k));
    u_prev = u_cur; u_cur = u_next
  );
  -1
};

\\ For given n, c: try ALL decompositions (not just divisor method)
\\ This is O(sqrt(c^2*n)) but we limit a0 range
find_all_decomps(n, c, max_d=1000) = {
  my(cn = c^2 * n, results = List());
  my(a0max = sqrtint(cn));

  \\ Strategy: enumerate divisors of 2*cn (for integer z condition: r | 2*cn)
  my(divs = divisors(2*cn));
  for(j = 1, #divs,
    my(r = divs[j]);
    if(r == 0 || r >= cn, next);
    if(!issquare(cn - r), next);
    my(a0 = sqrtint(cn - r));

    \\ z = (2*a0^2 + r)/r, guaranteed integer since r | 2*cn = 2*a0^2 + 2*r
    my(z = (2*a0^2 + r) \ r);
    if(z <= 1, next);

    \\ w = 2*a0/r, compute denominator d
    my(g = gcd(2*a0, r));
    my(d = r \ g);

    if(d > max_d, next);  \\ skip huge denominators

    \\ Find Chebyshev zero
    my(k = cheb_zero(z, d));
    if(k < 0, next);
    my(m = k + 1);

    listput(results, [m, c, r, a0, z, d])
  );
  Vec(results)
};

\\ === Attack n=127 ===
{
  print("=== n=127 (R_pell=16.063) ===\n");
  my(n = 127, Rpell = quadregulator(4*127));
  if(norm(quadunit(4*127)) < 0, Rpell *= 2);

  for(c = 1, 200,
    my(res = find_all_decomps(n, c, 500));
    for(j = 1, #res,
      my(v = res[j]);
      my(m = v[1], z = v[5], d = v[6]);
      my(Rcand = m * acosh(z * 1.0));
      my(ratio = Rpell / Rcand);
      if(abs(ratio - round(ratio)) < 0.01 && round(ratio) >= 1,
        my(k = round(ratio));
        printf("  c=%d r=%d a0=%d z=%d d=%d m=%d k=%d R=%.6f\n",
          c, v[3], v[4], z, d, m, k, m*k*acosh(z*1.0));
      )
    )
  );
  print("")
}

\\ === Attack n=193 ===
{
  print("=== n=193 (R_pell=30.153) ===\n");
  my(n = 193, Rpell = quadregulator(4*193));
  if(norm(quadunit(4*193)) < 0, Rpell *= 2);

  for(c = 1, 200,
    my(res = find_all_decomps(n, c, 500));
    for(j = 1, #res,
      my(v = res[j]);
      my(m = v[1], z = v[5], d = v[6]);
      my(Rcand = m * acosh(z * 1.0));
      my(ratio = Rpell / Rcand);
      if(abs(ratio - round(ratio)) < 0.01 && round(ratio) >= 1,
        my(k = round(ratio));
        printf("  c=%d r=%d a0=%d z=%d d=%d m=%d k=%d R=%.6f\n",
          c, v[3], v[4], z, d, m, k, m*k*acosh(z*1.0));
      )
    )
  );
  print("")
}

\\ === Coverage at higher c ===
{
  print("=== Coverage n=2..1000 with c<=100 ===\n");
  my(maxn = 1000, solved = 0, unsolved_list = List());

  for(n = 2, maxn,
    if(issquare(n), next);
    my(Rpell = quadregulator(4*n));
    if(norm(quadunit(4*n)) < 0, Rpell *= 2);

    my(found = 0);
    for(c = 1, 100,
      if(found, break);
      my(res = find_all_decomps(n, c, 200));
      for(j = 1, #res,
        my(v = res[j]);
        my(m = v[1], z = v[5]);
        my(Rcand = m * acosh(z * 1.0));
        my(ratio = Rpell / Rcand);
        if(abs(ratio - round(ratio)) < 0.01 && round(ratio) >= 1,
          found = 1; break
        )
      )
    );
    if(found, solved++, listput(unsolved_list, n))
  );

  my(ntot = 969);  \\ non-squares 2..1000
  printf("Solved: %d/%d = %.1f%%\n", solved, ntot, solved*100.0/ntot);
  printf("Unsolved (%d): %s\n", #unsolved_list,
    if(#unsolved_list <= 30, Vec(unsolved_list),
      Str(Vec(unsolved_list)[1..30], "...")))
}
