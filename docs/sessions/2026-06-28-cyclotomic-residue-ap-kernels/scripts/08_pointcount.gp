\\ 08 -- Capstone (expository): the numerator residue counts points on the Fermat cubic.
\\ The construction's L = 1/((p-1)/3)!^3 (mod p) equals:
\\   (i)  N_aff - (p-2),  N_aff = #{ (x,y) in F_p^2 : x^3+y^3 = 1 }   (Gauss);
\\   (ii) -a_p of the j=0 elliptic curve y^2 = x^3 - 432  (trace of Frobenius).
\\ Classical (Gauss / CM), but it gives the family its single most concrete image.

cubicLM(p) = { my(M=1,L); while(27*M^2<4*p, if(issquare(4*p-27*M^2,&L), if((L%3)==2,L=-L); return([L,M])); M++); [0,0]; }
Naff(p) = { my(c=0); for(x=0,p-1, for(y=0,p-1, if((x^3+y^3)%p==1, c++))); c; }

print("=== L_constr = N_aff(x^3+y^3=1) - (p-2)  and  = -a_p(y^2=x^3-432) ===");
{
my(E=ellinit([0,-432]), ok1=0, ok2=0, tot=0);
forprime(p=7, 200, if(p%3==1,
  my(fL=centerlift(1/Mod(((p-1)/3)!,p)^3));      \\ construction L (mod p, |L|<2sqrt p, =1 mod3)
  my(dev=Naff(p)-(p-2), ap=ellap(E,p));
  tot++;
  if(fL==dev, ok1++);
  if(fL==-ap, ok2++) ));
printf("  construction L = N_aff - (p-2)  (Gauss point count):  %d/%d\n", ok1, tot);
printf("  construction L = -a_p of y^2=x^3-432 (j=0 Frobenius):  %d/%d\n", ok2, tot);
}
print("");
print("CAPSTONE: an alternating factorial sum whose DENOMINATOR is the primorial has a");
print("NUMERATOR that counts the points of x^3+y^3=1 mod each prime (and gives a_p of the");
print("j=0 elliptic curve).  Classical (Gauss/CM) -- the family's most concrete single image.");
quit;
