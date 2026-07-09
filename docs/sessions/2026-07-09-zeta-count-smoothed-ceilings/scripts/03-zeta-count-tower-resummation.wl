(* HYPOTHESES stated before testing:
   H1: ceilSmoothS[x,1] == ceilBook[x] exactly (r=1 recovers the sharp/exact ceiling atom).
   H2: waveXX[t,p,1/Sqrt[p]] is literally -(1/Pi) Sum_j Lambda(p^j) Sin[t Log p^j]/(Sqrt[p^j] Log p^j)
       (resums the WHOLE p-power tower in closed form), same sign convention as the prior
       session's sPrimes explicit-formula term.
   H3: zetaZeroCount = nt7 + (this resummed prime-power sum over first m primes) should reduce
       RMS error against true N(t) as m grows, same qualitative behavior as the already-validated
       sPrimes[t,xmax] channel (RMS 0.24->0.045), even though truncation here is "first m primes,
       all powers" rather than "all n up to xmax" -- a genuinely different truncation shape.
   H4: no single prime contributes the sharp r=1 ceilBook atom -- max r is 1/Sqrt[2]=0.707 (p=2);
       r->0 as p grows. The hard atom is never actually reached at any finite prime. *)

ceilBook[x_] := x + 1/2 + ArcTan[Cot[Pi x]]/Pi;
ceilSmoothS[x_, r_] := 1/2 + x - ArcCot[Cot[2 Pi x] - Csc[2 Pi x]/r]/Pi;
waveXX[x_, p_, r_] := 1/Pi ArcCot[Cot[x Log@p] - Csc[x Log@p]/r];
nt7[t_] := t/(2 Pi) Log[t/(2 Pi E)] + 7/8;

Print["=== H1: ceilSmoothS[x,1] == ceilBook[x] ==="];
Print["symbolic difference: ", Simplify[ceilSmoothS[x, 1] - ceilBook[x]]];

Print["\n=== H2: waveXX[t,p,1/Sqrt[p]] resums the whole prime-power tower ==="];
towerSum[t_, p_, jmax_] := -(1/Pi) Sum[Log[p] Sin[t Log[p^j]]/(Sqrt[p^j] Log[p^j]), {j, 1, jmax}]
Print["waveXX vs partial tower sum (jmax=40, should converge closely since r<1 geometric): ",
  Table[N[waveXX[tt, pp, 1/Sqrt[pp]] - towerSum[tt, pp, 40]], {pp, {2, 3, 5}}, {tt, {1.3, 7.1}}]
  // Flatten];

Print["\n=== H4: r=1/Sqrt[p] never reaches 1; max at p=2 ==="];
Print[N[1/Sqrt[2]], "  (largest r, at the smallest prime; r -> 0 as p grows)"];

zetaZeroCount[t_, m_] := nt7[t] + Sum[waveXX[t, Prime[k], 1/Sqrt[Prime[k]]], {k, 1, m}];

Print["\n=== H3: RMS of zetaZeroCount against TRUE N(t) vs number of primes m ==="];
kmax = 300;
gams = Table[N[Im[ZetaZero[k]], 25], {k, kmax}];
(* evaluate zetaZeroCount just BELOW each true zero ordinate: N(gamma_k^-) = k-1 exactly,
   but to compare against nt7+S(t) convention (which places gamma_k at k-1/2), test at gamma_k itself *)
Do[
  vals = Table[zetaZeroCount[gams[[k]], m] - (k - 1/2), {k, kmax}];
  Print["m=", m, " primes (up to ", If[m == 0, "-", Prime[m]], ")  RMS=", N[Sqrt[Mean[vals^2]], 4],
    "  max|err|=", N[Max[Abs[vals]], 4],
    "  Ceiling successes: ",
    Count[Table[Ceiling[zetaZeroCount[gams[[k]], m]] == k, {k, kmax}], True], "/", kmax],
  {m, {0, 5, 20, 50, 100, 168}}
]
