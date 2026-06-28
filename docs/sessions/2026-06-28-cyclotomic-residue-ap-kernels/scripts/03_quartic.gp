\\ 03 -- Quartic family (q=4): residue ((p-1)/4)! = Gamma_p(1/4) shadow, carries p = a^2 + b^2.
\\ Classical (Gauss): C((p-1)/2, (p-1)/4) = +- 2a (mod p) for p = 1 mod 4, p = a^2+b^2, a odd.
print("=== quartic binomial  C((p-1)/2,(p-1)/4) = +-2a  (mod p),  p = a^2+b^2, a odd ===");
{
my(tot=0, ok=0);
forprime(p=5, 600, if(p%4==1,
  my(a=0,b=0,t);
  for(bb=1, sqrtint(p), if(issquare(p-bb^2,&t), b=bb; a=t; break));
  if(a%2==0, t=a; a=b; b=t);                         \\ a odd, b even
  my(c=centerlift(Mod(binomial((p-1)/2,(p-1)/4),p)));
  tot++; if(abs(c)==2*a, ok++)));
printf("  C((p-1)/2,(p-1)/4) = +-2a :  %d/%d  (carries the splitting of p in Z[i])\n", ok, tot);
}
quit;
