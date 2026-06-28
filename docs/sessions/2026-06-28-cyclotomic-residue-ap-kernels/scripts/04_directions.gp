\\ 04 -- Open directions 1 & 2 (follow-up).
\\
\\ Direction 1 (RESOLVED): quartic analogue of f3^3 = 1/L.
\\   From C((p-1)/2,(p-1)/4) = ((p-1)/2)!/((p-1)/4)!^2 = w/g1^2 = +-2a  and  w^2 = -1,
\\   squaring kills the sign:  g1^4 = w^2/(2a)^2 = -1/(2a)^2,  i.e.  4 a^2 ((p-1)/4)!^4 = -1.
\\
\\ Direction 2 (RESOLVED with nuance): general (q,a).  Residue = Gamma_p(a/q) shadow
\\   (Gross-Koblitz).  Clean SINGLE-INTEGER congruence f^q = c/X exists only for q=3,4
\\   (Q(zeta_q) imaginary quadratic, classical binomial congruence).  q=6 entangles cubic x
\\   quadratic (Hasse-Davenport) -> no clean power of L.  q=5 (degree-4 field) is a vector
\\   datum -> no single-integer congruence.  Inert class (a=2 mod 3) carries no splitting.

cubicLM(p) = { my(M=1,L); while(27*M^2<4*p, if(issquare(4*p-27*M^2,&L), if((L%3)==2,L=-L); return([L,M])); M++); [0,0]; }

print("=== Direction 1: 4 a^2 ((p-1)/4)!^4 = -1 (mod p), and (a^2,b^2) recovery ===");
{
my(tot=0, ok=0, rec=0);
forprime(p=5, 3000, if(p%4==1,
  my(a=0,b=0,t); for(bb=1,sqrtint(p), if(issquare(p-bb^2,&t), b=bb;a=t;break));
  if(a%2==0, t=a;a=b;b=t);
  my(g1=Mod(((p-1)/4)!,p)); tot++;
  if(4*a^2*g1^4 == Mod(-1,p), ok++);
  my(a2=centerlift(-1/(4*g1^4))); if(a2<0,a2+=p);
  if(a2==a^2 && issquare(p-a2), rec++)));
printf("  4a^2 g1^4 = -1 : %d/%d ;  (a^2,b^2) recovered from g1 alone : %d/%d\n", ok,tot,rec,tot);
}

print("\n=== Direction 2: split vs inert (q=3) -- only the split class carries L ===");
{
my(s=0,st=0, i=0,it=0);
forprime(p=7,1500, if(p%3==1,
  st++; if(Mod(((p-1)/3)!,p)^3 * cubicLM(p)[1] == Mod(1,p), s++)));
forprime(p=5,1500, if(p%3==2,                    \\ inert: no L,M ; look for any small congruence
  it++; my(f=Mod(((p-2)/3)!,p), B=2*sqrtint(p), found=0);
  for(X=-B,B, if(X!=0, for(c=-2,2, if(c!=0 && f^3==Mod(c,p)/X, found=1; break))); if(found,break));
  if(found, i++)));
printf("  split a=1 (p=1 mod3):  f^3 = 1/L  in %d/%d\n", s, st);
printf("  inert a=2 (p=2 mod3):  any small f^3=c/X  in %d/%d  (spurious, ~24/sqrt(p) by chance)\n", i, it);
}

print("\n=== Direction 2: q=6 -- same field Q(sqrt-3) but order-6 char entangles cubic x quadratic ===");
{
my(hit=0, tot=0);
forprime(p=7,2000, if((p-1)%6==0,
  my(L=cubicLM(p)[1], f=Mod(((p-1)/6)!,p), found=0);
  for(j=-2,2, for(c=-9,9, if(c!=0 && f^6==Mod(c,p)*Mod(L,p)^j, found=1)));
  tot++; if(found,hit++)));
printf("  ((p-1)/6)!^6 = c*L^j (|c|<=9,|j|<=2):  %d/%d  (NOT clean -> Hasse-Davenport entanglement)\n", hit, tot);
}

print("\n=== Direction 2: q=5 -- degree-4 field, vector datum, NO single-integer congruence ===");
{
my(has=0, tot=0);
forprime(p=11,2000, if((p-1)%5==0,
  my(f5=Mod(((p-1)/5)!,p)^5, B=2*sqrtint(p), found=0);
  for(X=-B,B, if(X!=0, for(c=-3,3, if(c!=0 && f5==Mod(c,p)/X, found=1; break))); if(found,break));
  tot++; if(found,has++)));
printf("  ((p-1)/5)!^5 = c/X (small):  %d/%d  (decays with p -> spurious; genuinely richer)\n", has, tot);
}
quit;
