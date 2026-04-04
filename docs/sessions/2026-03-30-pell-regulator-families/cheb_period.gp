\\ cheb_period.gp — Determine m via Chebyshev period mod d
\\
\\ Key insight: for decomposition c²n = a0² + r with z = (2a0²+r)/r ∈ Z,
\\ w = 2a0/r = p/d (reduced). Need d | U_{m-1}(z) for integer Pell solution.
\\ U_k(z) mod d is periodic → m found by iterating mod d.
\\
\\ Algorithm:
\\   1. Find z (integer) and d = denom(w) from decomposition
\\   2. Iterate U_k(z) mod d to find first k with d | U_k(z)
\\   3. m = k + 1
\\   4. R = m * arccosh(z)

\p 100

\\ Find first k >= 0 with d | U_k(z). Returns k or -1 if not found within maxiter.
cheb_zero(z, d, maxiter=10000) = {
  if(d == 1, return(0));  \\ U_0 = 1, always divisible by 1
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
  -1  \\ not found
};

\\ For given n and c: try all divisor decompositions, find best m
find_m(n, c) = {
  my(cn = c^2 * n);
  my(divs = divisors(4*cn), results = List());

  for(j = 1, #divs,
    my(r = divs[j]);
    if(r == 0 || r >= cn, next);
    if(!issquare(cn - r), next);
    my(a0 = sqrtint(cn - r));
    if(a0 == 0, next);

    \\ Check z = (2a0^2 + r)/r is integer
    my(z_num = 2*a0^2 + r);
    if(z_num % r != 0, next);
    my(z = z_num \ r);
    if(z <= 1, next);

    \\ w = 2a0/r, reduce
    my(g = gcd(2*a0, r));
    my(p_w = (2*a0) \ g, d = r \ g);

    \\ Find Chebyshev zero
    my(k = cheb_zero(z, d));
    if(k < 0, next);
    my(m = k + 1);

    listput(results, [m, c, r, a0, z, d, k])
  );
  Vec(results)
};

\\ === Test on known examples ===
{
  print("=== Chebyshev period method ===\n");

  \\ Example 1: n=13078849728, c=5, expected m=42
  print("--- n=13078849728, c=5 ---");
  my(res = find_m(13078849728, 5));
  for(j = 1, #res,
    my(v = res[j]);
    if(v[5] == 6649,
      printf("  m=%d c=%d r=%d a0=%d z=%d d=%d\n",
        v[1], v[2], v[3], v[4], v[5], v[6]))
  );

  \\ Verify
  my(R = 42 * acosh(6649.0));
  printf("  R = 42 * arccosh(6649) = %.30f\n", R);
  printf("  quadregulator(4n) = %.30f\n", quadregulator(4*13078849728));
}

\\ === Systematic test: for each n, find ALL Chebyshev solutions ===
{
  print("\n=== Systematic test n=2..200 ===\n");
  my(maxn = 200, solved = 0, unsolved = 0, ntot = 0);
  my(solved_list = List());

  for(n = 2, maxn,
    if(issquare(n), next);
    ntot++;

    my(R = quadregulator(4*n));
    my(nm = norm(quadunit(4*n)));
    my(Rpell = if(nm < 0, 2*R, R));

    my(best_m = 0, best_info = []);
    for(c = 1, 20,
      my(res = find_m(n, c));
      for(j = 1, #res,
        my(v = res[j]); my(m = v[1], z = v[5]);
        my(Rcand = m * acosh(z * 1.0));
        \\ Check if Rcand matches Rpell
        my(ratio = Rpell / Rcand);
        if(abs(ratio - round(ratio)) < 0.001 && round(ratio) >= 1,
          my(k = round(ratio));
          my(total_m = m * k);
          if(best_m == 0 || total_m < best_m,
            best_m = total_m;
            best_info = [c, v[3], v[4], z, v[6], m, k, total_m]
          )
        )
      );
      if(best_m > 0, break)  \\ found a solution, stop trying c
    );

    if(best_m > 0,
      solved++;
      if(solved <= 30,
        printf("n=%-4d c=%-2d r=%-5d z=%-5d d=%-3d m_cheb=%-2d k=%-2d total=%d\n",
          n, best_info[1], best_info[2], best_info[4], best_info[5],
          best_info[6], best_info[7], best_info[8])
      );
      listput(solved_list, [n, best_info])
    ,
      unsolved++
    )
  );

  printf("\nSolved: %d/%d = %.1f%%\n", solved, ntot, solved*100.0/ntot);
  printf("Unsolved: %d\n", unsolved);
}

\\ === Hard primes test ===
{
  print("\n=== Hard primes with higher c ===\n");
  my(hard = [7, 23, 31, 67, 127, 193]);

  for(j = 1, #hard,
    my(n = hard[j]);
    my(R = quadregulator(4*n));
    my(nm = norm(quadunit(4*n)));
    my(Rpell = if(nm < 0, 2*R, R));

    printf("n=%d R_pell=%.6f:\n", n, Rpell);

    my(found = 0);
    for(c = 1, 50,
      my(res = find_m(n, c));
      for(k = 1, #res,
        my(v = res[k]);
        my(m = v[1], z = v[5]);
        my(Rcand = m * acosh(z * 1.0));
        my(ratio = Rpell / Rcand);
        if(abs(ratio - round(ratio)) < 0.001 && round(ratio) >= 1,
          my(rr = round(ratio));
          printf("  c=%d r=%d z=%d d=%d m_cheb=%d k=%d total=%d\n",
            c, v[3], z, v[6], m, rr, m*rr);
          found = 1; break
        )
      );
      if(found, break)
    );
    if(!found, print("  NOT FOUND (c<=50)"));
    print("")
  )
}
