\\ 06 -- Stickelberger bridge attempt (q=3).  Connect three objects and ask if it is NEW.
\\   (1) construction residue f = ((p-1)/3)! mod p,  f^3 = 1/L
\\   (2) the genuine Jacobi sum J(chi,chi) = A + B*omega in Z[omega]
\\   (3) Stickelberger: factorization of (J) via fractional parts <c/q>.

cubicLM(p) = { my(M=1,L); while(27*M^2<4*p, if(issquare(4*p-27*M^2,&L), if((L%3)==2,L=-L); return([L,M])); M++); [0,0]; }
jac3(p) = {
  my(g=lift(znprimroot(p)), ind=vector(p-1), x=1, cnt=vector(3));
  for(k=0,p-2, ind[x]=k; x=(x*g)%p);
  for(t=2,p-1, my(u=lift(Mod(1-t,p)), e=(ind[t]+ind[u])%3); cnt[e+1]++);
  [cnt[1]-cnt[3], cnt[2]-cnt[3]];          \\ J = A + B*omega,  omega^2+omega+1=0
}
Nw(A,B) = A^2 - A*B + B^2;
sp(n,pp) = { my(s=0); while(n>0, s+=n%pp; n=n\pp); s; }

print("=== (1)<->(2)<->(3): residue computes J's trace; N(J)=p is Stickelberger's deg-1 prime ===");
{
my(ok=0, normok=0, tot=0);
forprime(p=7, 1000, if(p%3==1,
  my(AB=jac3(p), A=AB[1], B=AB[2], N=Nw(A,B));
  my(fc=centerlift(1/Mod(((p-1)/3)!,p)^3));     \\ = L mod p  (construction)
  my(tr=2*A-B);                                  \\ trace-like coordinate of J
  tot++;
  if(N==p, normok++);
  if(centerlift(Mod(fc-tr,p))==0 || centerlift(Mod(fc+tr,p))==0, ok++) ));
printf("  construction L (=1/f^3) = +-(2A-B) = J's trace mod p :  %d/%d\n", ok, tot);
printf("  N(J)=p  (J degree-1 prime; Stickelberger (e_1,e_2)=(0,1)) :  %d/%d\n", normok, tot);
}

print("\n=== Stickelberger exponents e_c = 2<c/3> - <2c/3> ===");
{
my(f1 = 2*(1/3) - (2/3), f2 = 2*(2/3) - 1/3);   \\ <4/3>=1/3
printf("  (e_1,e_2) = (%d,%d)  ->  (J) = sigma_2(p-bar), one prime above p.\n", f1, f2);
}

print("\n=== Is the bridge NEW?  The engine is Legendre's digit sum (= proof of Gross-Koblitz) ===");
print("  nu_p(j!) = (j - s_p(j))/(p-1).  For the clean kernel the surviving index j=(p-1)/3 < p,");
print("  so s_p(j)=j is a SINGLE digit -> digit-sum structure is DORMANT (nu_p(j!)=0 trivially).");
{
forprime(p=7,60, if(p%3==1,
  my(j=(p-1)/3);
  printf("  p=%-3d j=%-3d  s_p(j)=%d (=j, one digit)  nu_p(j!)=%d\n", p, j, sp(j,p), (j-sp(j,p))/(p-1)) ));
print("  => the Stickelberger fractional-part structure is exercised only in the prime-power /");
print("     multi-element (freezing) regime where indices exceed p.  The clean identities sidestep it.");
}
quit;
