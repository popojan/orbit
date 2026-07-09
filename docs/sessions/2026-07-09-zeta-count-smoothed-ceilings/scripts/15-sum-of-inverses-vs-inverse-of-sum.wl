(* 15 -- Jan's question: does summing the INVERSES of a family of invertible
   functions relate to inverting their SUM? Tested concretely on the per-prime
   smoothed ceiling family sP[t,p,r] = ceilSmooth[t Log[p]/(2 Pi), r].
   HYPOTHESES (stated before running):
   H1: ceilSmooth[n+1/2, r] == n+1 exactly, for ANY r -- the "shared midpoint
       height" Jan noticed visually in schody[] plots.
   H2: because of H1, each sP[t,p,r] is strictly increasing (Poisson-kernel
       derivative > 0), hence invertible; so F(t) = Sum_p sP[t,p,r] is ALSO
       invertible -- meaning F^-1 and G(y) := Sum_p sP^-1[y,p,r] are both
       well-defined, competing constructions.
   H3: they diverge, provably: F^-1's slope ~ 2 Pi / Sum(ln p) (reciprocal of
       the frequency SUM) while G's slope ~ 2 Pi * Sum(1/ln p) (SUM of
       reciprocal frequencies); by Cauchy-Schwarz/AM-HM their ratio is at
       least m^2 and grows without bound as more primes are added. *)

ceilSmooth[x_, r_] := x + 1/2 + ArcTan[r Sin[2 Pi x]/(1 - r Cos[2 Pi x])]/Pi;

Print["=== H1: ceilSmooth[n+1/2,r] == n+1, independent of r ==="];
Print["Symbolic: ", FullSimplify[ceilSmooth[n + 1/2, r] - (n + 1),
   Assumptions -> n \[Element] Integers && 0 < r < 1]];
SeedRandom[1];
Print["Numeric sweep max|diff|: ", Max@Table[
    With[{nn = RandomInteger[{0, 50}], rr = RandomReal[{0.001, 0.999}]},
     Abs[ceilSmooth[nn + 1/2, rr] - (nn + 1)]], {200}]];

Print["\n=== H2/H3: F (sum) vs G (sum of inverses) ==="];
primeList = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29};
rOf[p_] := 1/Sqrt[p];
sP[t_, p_] := ceilSmooth[t Log[p]/(2 Pi), rOf[p]];
fSum[t_, m_] := Sum[sP[t, primeList[[k]]], {k, 1, m}];
sInv[y_, p_] := t /. FindRoot[sP[t, p] == y, {t, (y - 1/2) 2 Pi/Log[p]}];
gSum[y_, m_] := Sum[sInv[y, primeList[[k]]], {k, 1, m}];

thetaOf[m_] := Sum[Log[primeList[[k]]], {k, 1, m}];
sumInvFreq[m_] := Sum[1/Log[primeList[[k]]], {k, 1, m}];

Do[
  y0 = 10.3;
  fInv = t /. FindRoot[fSum[t, m] == y0, {t, (y0 - m/2) 2 Pi/thetaOf[m]}];
  gVal = gSum[y0, m];
  Print["m=", m, "  F^-1(", y0, ")=", N[fInv, 6],
    "   G(", y0, ")=", N[gVal, 6],
    "   ratio G/F^-1=", N[gVal/fInv, 4],
    "   AM-HM lower bound theta*sumInvFreq=", N[thetaOf[m] sumInvFreq[m], 4]],
  {m, {1, 2, 4, 6, 8, 10}}
];
