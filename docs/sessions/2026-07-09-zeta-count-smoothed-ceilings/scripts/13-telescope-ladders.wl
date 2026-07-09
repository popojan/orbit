(* 13 -- Jan's telescoping idea (SS4.2.5): could the quantized/binned sum "telescope
   closed" -- over primes (obstacle: enumeration) or over all naturals?
   Both branches are classical; documented and verified here.
   HYPOTHESES (stated before running):
   H1 (branch (a): prime enumeration is REMOVABLE at sigma > 1): Moebius-zeta ladder
         P(s) = Sum_k MoebiusMu[k]/k Log[Zeta[k s]]
       -- prime-only data from the all-naturals object zeta (computable prime-free via
       Euler-Maclaurin), geometric in k. Check s = 2 against built-in PrimeZetaP.
   H2 (branch (b): the ALL-NATURALS wave sum closes):
         -Sum_{n>=2} (1/Pi) Im Log[1 - n^{-s}] == (1/Pi) Im Sum_k (Zeta[k s] - 1)/k,
       the log of the multiplicative-partitions product Prod_{n>=2}(1 - n^{-s})^{-1}.
       Sign lesson (honest record): the first check placed the minus on the wrong side;
       the identity is -Sum_n Log(1-n^{-s}) = +Sum_k (Zeta[ks]-1)/k.
   H3 (what never telescopes: the HEAD): at s = 1/2 + I t the k = 1 rung of either
       ladder IS log zeta on the critical line -- the ladder strips the tower
       corrections (zeta(1+2it), zeta(3/2+3it), ... geometrically small) but cannot
       evaluate the head. Telescoping closes the ENUMERATION, not the EVALUATION.
   Structure note: telescoping needs a successor; N has n -> n+1, the primes have no
   algebraic successor -- the Moebius ladder borrows N's successor structure for the
   primes, with the same mu(k)/k coefficients as the necklace ladder of script 11
   (conjugate domains: harmonic index k*theta there, argument ladder k*s here; both are
   the Moebius shadow of unique factorization). *)

Print["=== H1: prime zeta from zeta only -- no prime list ==="];
ladderA = N[Sum[MoebiusMu[k]/k Log[Zeta[2 k]], {k, 1, 40}], 10];
Print["Sum_k mu(k)/k Log[Zeta[2k]] = ", ladderA];
Print["PrimeZetaP[2]              = ", N[PrimeZetaP[2], 10], "   |diff| = ",
  N[Abs[ladderA - PrimeZetaP[2]], 2]];

Print["\n=== H2: all-naturals wave sum closes into the zeta ladder ==="];
s = 2 + 13.7 I;
lhs = -Sum[Im[Log[1 - n^-s]]/Pi, {n, 2, 200000}];
rhs = Im[Sum[(Zeta[k s] - 1)/k, {k, 1, 60}]]/Pi;
Print["direct Sum_{n>=2} (truncated 2*10^5) = ", N[lhs, 8]];
Print["zeta ladder Sum_k (Zeta[ks]-1)/k     = ", N[rhs, 8], "   |diff| = ", N[Abs[lhs - rhs], 2]];

Print["\n=== H3: on the critical line the k=1 rung IS the target ==="];
sc = 1/2 + 13.7 I;
Print["rung magnitudes |mu(k)/k Log[Zeta[k sc]]| at sc = 1/2 + 13.7 I, k=1..6:"];
Print[Table[N[Abs[MoebiusMu[k]/k Log[Zeta[k sc]]], 4], {k, 1, 6}]];
Print["k=1 rung = |log zeta(1/2+it)| itself (the hard object); k>=2 rungs are the"];
Print["geometrically small tower strip. The ladder removes prime enumeration (H1) and"];
Print["closes the naturals sum (H2), but the head evaluation is conserved -- a per-bin"];
Print["telescope at sigma=1/2 would be a sub-sqrt(t) algorithm for S(t0) (open; bet against)."];
