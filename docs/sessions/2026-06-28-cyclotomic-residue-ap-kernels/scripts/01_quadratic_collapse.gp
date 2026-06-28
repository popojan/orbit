\\ 01 -- Quadratic family (q=2): the tight-set residue COLLAPSES to coarse/classical.
\\ Sibling of primorial-formula.tex (Thm "Modular closed form") and the
\\ 2026-06-24 prime-interval-detector session (per-prime closed form, equidistribution).
\\
\\ Four checks:
\\  (a) prime-entry residue = half-factorial w_p = ((p-1)/2)! mod p  = class-number datum
\\  (b) ground truth from the actual rational N_k mod p matches the intrinsic eps*w/2
\\  (c) interval-detector multi-element residue collapses to the elementary staircase
\\  (d) the quadratic Jacobi sum is itself elementary (why q=2 can't be "new")

print("=== (a) half-factorial w_p = ((p-1)/2)! mod p  vs class number h(-p) ===");
{
my(n3=0, ok3=0);
forprime(p=5, 400,
  my(k=(p-1)/2, w=lift(Mod(k!,p)), w2=lift(Mod(w^2,p)));
  my(predw2=lift(Mod((-1)^((p+1)/2),p)));        \\ Wilson: w^2 = (-1)^((p+1)/2)
  if(w2!=predw2, error("Wilson FAILED at p=",p));
  if(p%4==3,
    my(h=qfbclassno(-p), predw=lift(Mod((-1)^((h+1)/2),p)));   \\ Mordell: w = (-1)^((h+1)/2)
    n3++; if(w==predw, ok3++, print("  Mordell MISMATCH p=",p)));
);
printf("  Wilson: all OK to 400.  Mordell class-number prediction (p=3 mod4): %d/%d\n", ok3, n3);
}

print("=== (b) ground-truth N_k mod p (from the real rational) vs intrinsic eps*w/2 ===");
Sk(k) = 1/2 * sum(j=1, k, (-1)^j * j! / (2*j+1));
{
my(tot=0, ok=0);
forprime(p=5, 80,
  my(k=(p-1)/2, eps=(-1)^k, w=lift(Mod(k!,p)), Lp=lift(Mod(eps*w/2,p)));
  my(Nk=numerator(Sk(k)), mm=prod(j=1,primepi(p),prime(j)));
  my(dress=lift(Mod(mm/p,p)), strip=lift(Mod(lift(Mod(Nk,p))/dress,p)));
  tot++; if(strip==Lp, ok++, print("  MISMATCH p=",p)));
printf("  N_k mod p (stripped) = eps*((p-1)/2)!/2 :  %d/%d\n", ok, tot);
}

print("=== (c) interval-detector multi-element residue: elementary staircase? (collapse) ===");
Sint(m) = sum(n=1, 2*m, (-1)^n * 2/((2*n+1)*(n+1)));
{
my(tot=0, elem=0, carryw=0);
for(m=14, 60,
  my(M=2^m*m!, T=M*Sint(m), N=numerator(T), A=denominator(T));
  forprime(p=m+1, 4*m+2,
    if(A%p==0,
      my(eps=(-1)^((p-1)/2), dress=lift(Mod(M*(A/p),p)));
      if(dress==0, next);
      my(Lact=lift(Mod(lift(Mod(N,p))/dress,p)));
      my(stairs=[(p-1)/2,p-1,(3*p-1)/2], cc=[4*eps,-2,-4*eps/3], Lel=0);
      for(t=1,3, if(stairs[t]<=2*m, Lel+=cc[t]));
      Lel=lift(Mod(Lel,p));
      my(w=lift(Mod(((p-1)/2)!,p)), deep=lift(Mod(eps*w/2,p)));
      tot++; if(Lact==Lel, elem++); if(Lact==deep && Lact!=Lel, carryw++);
    );
  );
);
printf("  band-prime residues %d ; ELEMENTARY (=staircase) %d ; carry half-factorial w %d\n", tot, elem, carryw);
}

print("=== (d) quadratic Jacobi sum J(chi2,chi2) = -chi2(-1) : elementary everywhere ===");
{
my(tot=0, ok=0);
forprime(p=7, 60,
  my(chi2(a)=if(a%p==0,0,kronecker(lift(a),p)));
  my(J=lift(Mod(sum(a=2,p-1, chi2(Mod(a,p))*chi2(Mod(1-a,p))),p)));
  my(elem=lift(Mod(-kronecker(-1,p),p)));
  tot++; if(J==elem, ok++));
printf("  J(chi2,chi2) = -chi2(-1) :  %d/%d  (no 2-parameter datum -> coarse)\n", ok, tot);
}
quit;
