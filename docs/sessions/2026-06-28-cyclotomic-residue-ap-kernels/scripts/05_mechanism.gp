\\ 05 -- Mechanism: what each ingredient does, and the numerator congruence.
\\ (a) sign is NOT load-bearing for the residue identity, but IS for the denominator.
\\ (b) the additive sum collapses to ONE term mod p (single-factor kernel).
\\ (c) forced genuine 2-term addition still carries L (adjacent factorials).
\\ (d) the numerator congruence  N_k = (D_k/p) * (-1)^{(p-1)/q} ((p-1)/q)!  (mod p).

cubicLM(p) = { my(M=1,L); while(27*M^2<4*p, if(issquare(4*p-27*M^2,&L), if((L%3)==2,L=-L); return([L,M])); M++); [0,0]; }

print("=== (a) sign load-bearing for RESIDUE? (no) and for DENOMINATOR? (yes) ===");
{
my(k=400, A3=sum(j=1,k,(-1)^j*j!/(3*j+1)), P3=sum(j=1,k,j!/(3*j+1)));
my(a3=0,p3=0,t3=0);
forprime(p=30,3*k+1, if(p%3==1 && valuation(denominator(A3),p)==1,
  t3++;
  if(Mod(p*A3,p)^3*cubicLM(p)[1]==Mod(1,p), a3++);
  if(valuation(denominator(P3),p)==1 && Mod(p*P3,p)^3*cubicLM(p)[1]==Mod(1,p), p3++)));
printf("  q=3 residue identity: ALT %d/%d , POS(no sign) %d  -> sign NOT load-bearing for arithmetic\n",a3,t3,p3);
\\ denominator: q=4 at k=6 loses the prime 5 without the sign (25=5^2 coincidence)
my(DA=denominator(sum(n=1,6,(-1)^n*n!/((4*n+1)))), DP=denominator(sum(n=1,6,n!/((4*n+1)))));
printf("  q=4,k=6 denominator primes  ALT=%s  POS=%s  -> sign IS load-bearing for denominator\n",
  Set(factor(DA)[,1]), Set(factor(DP)[,1]));
}

print("=== (b) single-factor sum collapses to ONE term mod p ===");
{
my(k=400, SS=sum(j=1,k,(-1)^j*j!/(3*j+1)), one=0, van=0, t=0);
forprime(p=30,1201, if(p%3==1 && valuation(denominator(SS),p)==1,
  t++;
  if(Mod(p*SS,p)==Mod(((p-1)/3)!,p), one++);
  if(4*p>1201 || Mod(((4*p-1)/3)!,p)==0, van++)));
printf("  p*S = ((p-1)/3)! mod p exactly: %d/%d ; higher-multiple term vanishes: %d/%d\n", one,t,van,t);
}

print("=== (c) forced genuine 2-term addition (two-factor kernel) still carries L ===");
{
my(k=400, SS=sum(n=1,k,(-1)^n*n!/((3*n+1)*(3*n+4))), carry=0, t=0);
forprime(p=30,600, if(p%3==1 && valuation(denominator(SS),p)==1,
  t++;
  my(res=Mod(p*SS,p), f=Mod(((p-1)/3)!,p), ratio=centerlift(res/f));
  if(res^3*cubicLM(p)[1]==Mod(ratio^3,p), carry++)));   \\ res=ratio*f, f^3=1/L => res^3=ratio^3/L
printf("  two-term residue = (elementary)*((p-1)/3)!, still determines L: %d/%d\n", carry,t);
}

print("=== (d) numerator congruence  N_k = (D_k/p) * ((p-1)/q)!  (mod p),  q=3 ===");
{
my(k=200, SS=sum(j=1,k,(-1)^j*j!/(3*j+1)), N=numerator(SS), D=denominator(SS), ok=0, t=0);
forprime(p=30,601, if(p%3==1 && valuation(D,p)==1,
  t++;
  if(lift(Mod(N,p))==lift(Mod(((p-1)/3)!*(D/p),p)), ok++)));
printf("  N_k = ((p-1)/3)! * (D_k/p) mod p:  %d/%d\n", ok, t);
}
quit;
