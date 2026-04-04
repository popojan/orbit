\\ cheb_deep.gp — Deep structure of Chebyshev period
\\
\\ Proved: m = lcm of Lucas ranks alpha(p^e) over p^e || d
\\ alpha(p) = ord(lambda) in F_p* [QR case]
\\          = ord(lambda)/2 in F_p^2* [QNR case]
\\ where lambda = z + sqrt(z^2-1) mod p
\\
\\ Key: lambda = (a0 + sqrt(n*c^2))^2 / r mod p
\\ So alpha(p) relates to the order of (a0+sqrt(cn)) mod p!
\\
\\ Questions:
\\ Q1: When is alpha(p) small? (Gives small m)
\\ Q2: Connection to the CF period of sqrt(n)?
\\ Q3: For prime p | d: does alpha(p) relate to the Pell structure of n mod p?

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

\\ === Q1: Alpha as function of z mod p ===
{
  print("=== Q1: Map z mod p -> alpha(p) for small primes ===\n");

  forprime(p = 5, 23,
    printf("p=%d: z -> alpha(p):\n  ", p);
    for(z = 2, p-1,
      my(alpha = lucas_rank(2*z, 1, p));
      printf("%d:%d ", z, alpha)
    );
    print("\n")
  )
}

\\ === Q2: What determines alpha(p)? ===
\\ alpha(p) = ord(z + sqrt(z^2-1)) in F_p* or F_p^2*/norm-1
\\ This equals ord of the IDEAL (a0 + sqrt(c^2*n)) modulo p
{
  print("=== Q2: Alpha = order of ideal (a0+sqrt(N)) mod p ===\n");
  print("For N = c^2*n, the ideal I = (a0+sqrt(N)) has norm |a0^2-N| = r.\n");
  print("Modulo prime p: alpha relates to the splitting of p in Q(sqrt(n)).\n\n");

  \\ For p | d with d = r/gcd(r,2a0): p divides a quotient of r.
  \\ If p splits in Q(sqrt(n)): sqrt(n) exists mod p, lambda in F_p
  \\ If p is inert: sqrt(n) doesn't exist, lambda in F_p^2

  \\ Check: does Legendre(n, p) = Legendre(z^2-1, p)?
  \\ z^2 - 1 = 4*a0^2*n/r^2. If p ∤ r: (z^2-1|p) = (4a0^2 n / r^2 | p) = (n|p).
  \\ If p | r: need care.

  print("Legendre(z^2-1, p) vs Legendre(n, p):\n");
  my(nok = 0, ntot = 0);
  for(n = 2, 200,
    if(issquare(n), next);
    for(c = 1, 10,
      my(cn = c^2*n, divs = divisors(2*cn));
      for(j = 1, #divs,
        my(r = divs[j]);
        if(r == 0 || r >= cn, next);
        if(!issquare(cn - r), next);
        my(a0 = sqrtint(cn - r));
        if(a0 == 0, next);
        if((2*a0^2 + r) % r != 0, next);
        my(z = (2*a0^2 + r) \ r);
        if(z <= 1, next);
        my(g = gcd(2*a0, r), dd = r \ g);
        if(dd <= 1 || dd > 100, next);

        my(fa = factor(dd));
        for(i = 1, matsize(fa)[1],
          my(p = fa[i,1]);
          if(p == 2, next);
          ntot++;
          my(leg_z = kronecker(z^2-1, p));
          my(nsf = core(n));  \\ squarefree part
          my(leg_n = kronecker(nsf, p));
          if(leg_z == leg_n, nok++,
            if(ntot - nok <= 5,
              printf("  n=%d c=%d z=%d p=%d: Leg(z^2-1)=%d Leg(n_sf)=%d r=%d\n",
                n, c, z, p, leg_z, leg_n, r)))
        )
      )
    )
  );
  printf("\nLeg(z^2-1, p) = Leg(n_sf, p): %d/%d = %.1f%%\n\n", nok, ntot, nok*100.0/ntot)
}

\\ === Q3: Connection to splitting type of p in Q(sqrt(n)) ===
{
  print("=== Q3: Alpha when p splits vs inert in Q(sqrt(n)) ===\n");

  \\ When p splits (n is QR mod p): alpha | p-1
  \\ When p is inert (n is QNR mod p): alpha | p+1
  \\ How big is alpha relative to p?

  my(split_alphas = List(), inert_alphas = List());

  for(n = 2, 200,
    if(issquare(n), next);
    for(c = 1, 10,
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
        if(dd <= 1 || dd > 100, next);

        my(fa = factor(dd));
        for(i = 1, matsize(fa)[1],
          my(p = fa[i,1]);
          if(p < 3, next);
          my(alpha = lucas_rank(2*z, 1, p));
          my(nsf = core(n));
          my(leg = kronecker(nsf, p));
          if(leg == 1,
            listput(split_alphas, [alpha, p, p-1, n, z])
          ,
            if(leg == -1,
              listput(inert_alphas, [alpha, p, p+1, n, z])
            )
          )
        )
      )
    )
  );

  printf("Split primes (n QR mod p): %d cases\n", #split_alphas);
  if(#split_alphas > 0,
    my(ratios = [s[3]/s[1] | s <- Vec(split_alphas)]);
    printf("  (p-1)/alpha: mean=%.1f median=%d range=%d..%d\n",
      vecsum(ratios)*1.0/#ratios, vecsort(ratios)[#ratios\2],
      vecmin(ratios), vecmax(ratios)));

  printf("Inert primes (n QNR mod p): %d cases\n", #inert_alphas);
  if(#inert_alphas > 0,
    my(ratios = [s[3]/s[1] | s <- Vec(inert_alphas)]);
    printf("  (p+1)/alpha: mean=%.1f median=%d range=%d..%d\n",
      vecsum(ratios)*1.0/#ratios, vecsort(ratios)[#ratios\2],
      vecmin(ratios), vecmax(ratios)))
}

\\ === Q4: Alpha(p) = 2 iff p | z ===
{
  print("\n=== Q4: Alpha(p) = 2 iff p | z (verified) ===\n");
  my(nok = 0, ntot = 0);
  forprime(p = 3, 100,
    for(z = 2, 200,
      ntot++;
      my(alpha = lucas_rank(2*z, 1, p));
      my(pred = if(z % p == 0, 2, -1));
      if(pred == 2 && alpha == 2, nok++,
        if(pred != 2 && alpha != 2, nok++)
      )
    )
  );
  printf("alpha=2 iff p|z: %d/%d = %.1f%%\n", nok, ntot, nok*100.0/ntot)
}

\\ === Q5: Large example — anatomy of m for n=13078849728 ===
{
  print("\n=== Q5: Full anatomy of n=13078849728, c=5 ===\n");
  my(n = 13078849728, c = 5);
  my(cn = c^2*n, r = 98337216);
  my(a0 = sqrtint(cn - r));
  my(z = (2*a0^2 + r) \ r);
  my(g = gcd(2*a0, r), d = r \ g);
  my(nsf = core(n));

  printf("n = %d = %s\n", n, factor(n));
  printf("n_sf = %d\n", nsf);
  printf("c = %d, c^2*n = %d\n", c, cn);
  printf("a0 = %d, r = %d = %s\n", a0, r, factor(r));
  printf("z = %d, w = %d/%d\n", z, 2*a0, r);
  printf("d = %d = %s\n", d, factor(d));

  my(fa = factor(d));
  printf("\nPrime decomposition of d=%d:\n", d);
  for(i = 1, matsize(fa)[1],
    my(p = fa[i,1], e = fa[i,2]);
    my(alpha = lucas_rank(2*z, 1, p^e));
    my(leg = kronecker(nsf, p));
    my(bound = p - leg);
    my(splitting = if(leg == 1, "SPLIT", if(leg == -1, "INERT", "RAMIFIED")));
    printf("  p=%d^%d: alpha=%d, %s in Q(sqrt(%d)), bound=%d, (bound/alpha=%d)\n",
      p, e, alpha, splitting, nsf, bound, bound/alpha)
  );
  my(m = 1);
  for(i = 1, matsize(fa)[1],
    my(pe = fa[i,1]^fa[i,2]);
    m = lcm(m, lucas_rank(2*z, 1, pe)));
  printf("\nm = lcm(alphas) = %d\n", m);
  printf("R = %d * arccosh(%d) = %.10f\n", m, z, m * acosh(z*1.0));
}

\\ === Q6: Can we find decompositions with alpha(p)=2 (p|z) for hard primes? ===
{
  print("\n=== Q6: Force alpha=2 by choosing z ≡ 0 mod all primes of d ===\n");
  print("Condition: d | z. Then m = 2 (best possible for d>1).\n\n");

  \\ For n=127: find (c, decomposition) with d | z
  my(n = 127);
  my(Rpell = quadregulator(4*n));
  if(norm(quadunit(4*n)) < 0, Rpell *= 2);

  printf("n=%d, R_pell=%.6f\n\n", n, Rpell);

  for(c = 1, 500,
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
      if(dd <= 1, next);

      \\ Check d | z
      if(z % dd != 0, next);

      \\ m = 2 guaranteed. Check if R = 2*arccosh(z) matches
      my(Rcand = 2 * acosh(z * 1.0));
      my(ratio = Rpell / Rcand);
      if(abs(ratio - round(ratio)) < 0.01 && round(ratio) >= 1,
        my(k = round(ratio));
        printf("  FOUND! c=%d r=%d a0=%d z=%d d=%d m=2 k=%d total=%d\n",
          c, r, a0, z, dd, k, 2*k);
        break(2)  \\ exit both loops
      )
    )
  );
}
