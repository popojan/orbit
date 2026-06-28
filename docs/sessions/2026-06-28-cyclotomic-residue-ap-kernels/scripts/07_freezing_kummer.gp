\\ 07 -- The freezing-regime test: does the elementary tight-set combinatorics produce
\\ non-trivial Stickelberger content, or land on Kummer-classical?  DECISIVE: anti-correlation.
\\
\\ Result: a Gauss sum is attached ONLY at signal primes (index (p-1)/q < p, digit sum DORMANT);
\\ non-trivial digit sums occur ONLY at contamination primes (which carry NO character/Gauss sum).
\\ The two never coincide -> the construction CANNOT produce non-trivial Stickelberger content.
\\ Where digit sums appear at all, they are Kummer (1852) / Legendre (1808); Gross-Koblitz (1979)
\\ is the bridge to Gauss sums.  All classical.

sp(n,pp) = { my(s=0); while(n>0, s+=n%pp; n=n\pp); s; }
S3(k) = sum(j=1, k, (-1)^j * j! / (3*j+1));

print("=== A. signal prime p=7: multi-digit index 16 (=22_7, s_7=4) never touches the residue ===");
{
my(ks=[2,15,16,20]);
for(i=1,#ks,
  my(k=ks[i], v=valuation(denominator(S3(k)),7));
  printf("  k=%-3d nu_7(D)=%d  7-unit residue=%d\n", k, v, centerlift(Mod(7^v*S3(k),7))));
print("  (49=7^2 enters at k=16) -> nu_7=1, residue=2=((7-1)/3)! throughout: permanently DORMANT.");
}

print("");
print("=== B. contamination prime 2 (=2 mod3, inert): nu_2 non-trivial, NO cubic Gauss sum ===");
{
my(ks=[2,8,16]);
for(i=1,#ks, my(k=ks[i]); printf("  k=%-3d nu_2(D)=%d\n", k, valuation(denominator(S3(k)),2)));
print("  (multi-digit Legendre bookkeeping; 2 carries no character here -> not Stickelberger)");
}

print("");
print("=== C. anti-correlation: unit residue always = single-digit-index factorial (no leak) ===");
{
my(k=400, SS=S3(k), ok=0, tot=0);
forprime(p=7, 1201, if(p%3==1 && valuation(denominator(SS),p)==1,
  tot++; my(idx=(p-1)/3); if(idx<p && Mod(p*SS,p)==Mod(idx!,p), ok++)));
printf("  residue = single-digit-index factorial: %d/%d\n", ok, tot);
}

print("");
print("=== D. anchor: Stickelberger's Jacobi exponent = Kummer's carry = nu_p(binomial) ===");
{
my(ok=0, tot=0);
forprime(p=5, 13, for(a=1,40, for(b=1,40,
  my(carry=(sp(a,p)+sp(b,p)-sp(a+b,p))/(p-1));
  tot++; if(carry==valuation(binomial(a+b,a),p), ok++))));
printf("  carry = nu_p(C(a+b,a)): %d/%d  -> digit-sum structure is Kummer(1852)/Legendre(1808).\n", ok, tot);
}

print("");
print("VERDICT: Kummer-classical. The construction is STRUCTURALLY decoupled from non-trivial");
print("Stickelberger content (Gauss-sum primes are digit-sum-dormant). No new elementary route.");
quit;
