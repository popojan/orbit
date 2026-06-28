\\ 02 -- Cubic family (q=3): the residue does NOT collapse -- it carries 4p = L^2 + 27 M^2.
\\
\\ Kernel  S(k) = sum_{j=1}^k (-1)^j j! / (3j+1)   (denominators = 1 mod 3, an AP-selective
\\ cubic analogue of the primorial kernel 1/(2j+1)).  For a band prime p = 1 mod 3 with a
\\ simple pole, the leading p-adic coefficient (p*S mod p) equals +- the third-factorial
\\   f1 = ((p-1)/3)! mod p  =  the Gross-Koblitz Gamma_p(1/3) shadow.
\\
\\ Claim (derived + verified):  f1^3 = L^{-1} (mod p),  hence f1 recovers the full cubic
\\ decomposition 4p = L^2 + 27 M^2 (the splitting of p in Z[omega]).

\\ cubic datum: 4p = L^2 + 27 M^2 with L = 1 mod 3 (sign-fixed)
cubicLM(p) = { my(M=1,L); while(27*M^2<4*p, if(issquare(4*p-27*M^2,&L), if((L%3)==2,L=-L); return([L,M])); M++); [0,0]; }

print("=== (a) classical cubic binomial  C(2k,k) = -L (mod p),  k=(p-1)/3 ===");
{
my(tot=0, ok=0);
forprime(p=7, 600, if(p%3==1,
  my(L=cubicLM(p)[1], c=centerlift(Mod(binomial(2*(p-1)/3,(p-1)/3),p)));
  tot++; if(centerlift(Mod(c+L,p))==0, ok++)));
printf("  C(2k,k) = -L :  %d/%d\n", ok, tot);
}

print("=== (b) kernel residue = +- third-factorial f1 = ((p-1)/3)!  (p*S mod p) ===");
S(k) = sum(j=1, k, (-1)^j * j! / (3*j+1));
{
my(k=400, SS=S(k), tot=0, ok=0);
forprime(p=30, 3*k+1, if(p%3==1,
  if(valuation(denominator(SS),p)==1,                 \\ simple pole only
    my(res=centerlift(Mod(p*SS,p)));
    my(f1=centerlift(Mod(((p-1)/3)!,p)));
    tot++; if(abs(res)==abs(f1), ok++))));
printf("  |p*S mod p| = |((p-1)/3)!| :  %d/%d  (residue IS the third-factorial)\n", ok, tot);
}

print("=== (c) the non-elementary identity  f1^3 * L = 1 (mod p), and full (L,M) recovery ===");
{
my(tot=0, cube=0, recover=0);
forprime(p=7, 4000, if(p%3==1,
  my(LM=cubicLM(p), L=LM[1], f1=Mod(((p-1)/3)!,p));
  tot++;
  if(f1^3*L==Mod(1,p), cube++);
  \\ recover L from the residue alone: L = 1/f1^3, take |.|<2sqrt(p) representative = 1 mod 3
  my(Lrec=centerlift(1/f1^3));
  if((Lrec%3)==2, Lrec-=p); if((Lrec%3)==2, Lrec+=2*p);
  my(rr=4*p-Lrec^2);
  if(rr>=0 && rr%27==0 && issquare(rr/27), recover++)));
printf("  f1^3 * L = 1 :  %d/%d\n", cube, tot);
printf("  4p = L^2 + 27 M^2 recovered from f1 alone :  %d/%d\n", recover, tot);
}
quit;
