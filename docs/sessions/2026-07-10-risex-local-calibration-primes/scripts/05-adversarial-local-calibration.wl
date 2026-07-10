(* Self-adversarial check (per CLAUDE.md discipline): pipeline A beats the fully
   global classical liInv[m+2] by 10x-1000x. Before believing that means it beats
   Cramer/gap-independence, compare it against classical competitors that ALSO get
   to use the one known local prime p = Prime[m+1] -- if those already close most
   of the gap to A, there is no tension with gap independence: it's just local
   calibration, same idea as A, nothing deeper. *)

Sm[m_] := Sum[n/Log[Prime[n]] // N, {n, 2, m}];
riseX[m_] := (-1 + Sm[m])/(Log[m] LogIntegral[m] // N);

errf[m_, p_, q_, rX_] :=
 -(1/(Log[1 + m] p LogIntegral[1 + m])) -
   m/(Log[1 + m] p LogIntegral[1 + m]) +
  rX (1/2 - (Log[m] LogIntegral[m])/(
       Log[1 + m] LogIntegral[1 + m]) + (Log[m] LogIntegral[m])/(
       2 Log[2 + m] LogIntegral[2 + m])) +
   1/(2 Log[2 + m] p LogIntegral[2 + m]) +
   m/(2 Log[2 + m] p LogIntegral[2 + m]) +
   1/(Log[2 + m] q LogIntegral[2 + m]) +
   m/(2 Log[2 + m] q LogIntegral[2 + m]);

liInv[n_] := x /. Quiet[FindRoot[LogIntegral[x] == n, {x, Max[4, n (Log[n] + Log[Log[n]])]}]];

classical[m_] := liInv[m + 2]; (* no local info at all *)

recalibrated[m_] := Prime[m + 1] + (liInv[m + 2] - liInv[m + 1]); (* known p + global curve's local step *)

localLiStep[m_] := Module[{p1 = Prime[m + 1]}, (* known p + Li-density Poisson-style step *)
   x /. Quiet[FindRoot[LogIntegral[x] - LogIntegral[p1] == 1, {x, p1 + Log[p1]}]]
   ];

naiveGap[m_] := Prime[m + 1] + Log[Prime[m + 1]]; (* known p + textbook average gap *)

Print["m | true | errf(true riseX,true p) | recalibrated | localLiStep | naiveGap | classical(no local info)"];
Do[
  pTrue2 = Prime[m + 2];
  pKnownExact = Log[Prime[m + 1]];
  rXtrue = riseX[m];
  qA = q /. Quiet[FindRoot[errf[m, pKnownExact, q, rXtrue] == 0, {q, Log[N[pTrue2]]}]];
  predErrf = Exp[qA];
  predRecal = recalibrated[m];
  predLocal = localLiStep[m];
  predNaive = naiveGap[m];
  predClass = classical[m];
  relE[x_] := N[(x - pTrue2)/pTrue2, 6];
  Print[{m, "true=", pTrue2}];
  Print["   errf(true riseX,true p): pred=", N[predErrf, 10], " relErr=", relE[predErrf]];
  Print["   recalibrated           : pred=", N[predRecal, 10], " relErr=", relE[predRecal]];
  Print["   localLiStep (density)  : pred=", N[predLocal, 10], " relErr=", relE[predLocal]];
  Print["   naiveGap (p+log p)     : pred=", N[predNaive, 10], " relErr=", relE[predNaive]];
  Print["   classical (no local)   : pred=", N[predClass, 10], " relErr=", relE[predClass]],
  {m, {10, 50, 200, 1000, 5000, 20000}}
];
