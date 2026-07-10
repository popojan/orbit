(* 17: the from-scratch next-prime formula, validated at great heights.
   Derivation chain (see README section 14):
   1. density lambda(x) = 1/log x (PNT; RH controls the smooth error);
   2. primes > P ~ inhomogeneous Poisson (Gallagher's theorem under uniform HL);
   3. survival S(h) = exp(-(Li(P+h) - Li(P)));
   4. mean-optimal: Li^-1(Li(P)+1) = P + log P + log^2 P/(2P) + ...
      median: P + ln2 log P;  alpha-quantile: P + ln(1/(1-alpha)) log P.
   Empirics here: consecutive-prime gaps sampled at 10^9..10^18 via NextPrime
   (three warm-up steps decorrelate from the size-biased entry prime). *)

SeedRandom[1859];
gapSample[height_, n_] := Table[Module[{p},
    p = NextPrime[height + RandomInteger[{0, Round[height/100]}]];
    p = NextPrime[p]; p = NextPrime[p];
    N[NextPrime[p] - p]], {n}];

Print["height | n | mean/logP (Poisson: 1; classic confusion (logP-1)/logP shown) | median/mean (ln2=0.6931) | q90/mean (ln10/1? = 2.3026) | se"];
Do[
  {h, n} = hn;
  gaps = gapSample[10^h, n];
  q = Log[10.^h];
  Print[{h, n, "mean/logP=", N[Mean[gaps]/q, 4], " ((logP-1)/logP=", N[(q - 1)/q, 4], ")",
    " median/mean=", N[Median[gaps]/Mean[gaps], 4],
    " q90/mean=", N[Quantile[gaps, 0.9]/Mean[gaps], 4],
    " se(mean/logP)=", N[StandardDeviation[gaps]/(q Sqrt[n]), 3]}],
  {hn, {{9, 3000}, {12, 1500}, {15, 800}, {18, 500}}}];

Print[""];
qM = 136279841;
lgP = qM Log[2.];
Print["record Mersenne P = 2^136279841 - 1:  log P = q ln 2 = ", N[lgP, 8]];
Print["  mean-optimal next prime : P + ", N[lgP, 6]];
Print["  median-optimal          : P + ", N[Log[2.] lgP, 6]];
Print["  95%-quantile upper bound: P + ", N[Log[20.] lgP, 6]];
Print["  irreducible sd of the estimate: +- log P = +- ", N[lgP, 4]];
Print["  RH-certified hard window: P + O(sqrt(P) log P), sqrt(P) ~ 10^", N[qM Log[10, 2.]/2, 8]];
