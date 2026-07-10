(* Claim: errf[m,p,q] (as handed in by the user, built from riseX) is EXACTLY
   diffX[m+1] with p := Log[Prime[m+1]], q := Log[Prime[m+2]] substituted in.
   Verify both by direct numeric match, and by the closed-form solve for q
   (errf is linear in 1/q, so "Solve for q" is pure algebra, not a numerical root-find). *)

Sm[m_] := Sum[n/Log[Prime[n]] // N, {n, 2, m}];
riseX[m_] := (-1 + Sm[m])/(Log[m] LogIntegral[m] // N);
diffX[m_] := (riseX[m + 1] + riseX[m - 1])/2 - riseX[m];

errf[m_, p_ : Log[Prime[1 + m]], q_ : Log[Prime[2 + m]]] :=
 -(1/(Log[1 + m] p LogIntegral[1 + m])) -
   m/(Log[1 + m] p LogIntegral[1 + m]) +
  riseX[m] (1/2 - (Log[m] LogIntegral[m])/(
       Log[1 + m] LogIntegral[1 + m]) + (Log[m] LogIntegral[m])/(
       2 Log[2 + m] LogIntegral[2 + m])) +
   1/(2 Log[2 + m] p LogIntegral[2 + m]) +
   m/(2 Log[2 + m] p LogIntegral[2 + m]) +
   1/(Log[2 + m] q LogIntegral[2 + m]) +
   m/(2 Log[2 + m] q LogIntegral[2 + m]);

Print["errf[m, Log@Prime[m+1], Log@Prime[m+2]]  vs  diffX[m+1]  (should match to numeric noise):"];
Do[
  a = errf[m, Log[Prime[m + 1]], Log[Prime[m + 2]]] // N;
  b = diffX[m + 1] // N;
  Print[{m, "errf=", a, "diffX(m+1)=", b, "match?", Chop[a - b, 10^-9] == 0}],
  {m, {3, 10, 30, 80}}
];

(* errf(m,p,q) = A(m,p,rX) + B(m)/q  -- linear in 1/q, so "solve for q" is closed form *)
D0[m_] := Log[m] LogIntegral[m];
Bcoef[m_] := (m + 2)/(2 D0[m + 2]);
Acoef[m_, p_, rX_] := (m + 1)/p*(1/(2 D0[m + 2]) - 1/D0[m + 1]) +
   rX*(1/2 - D0[m]/D0[m + 1] + D0[m]/(2 D0[m + 2]));
qClosedForm[m_, p_, rX_] := -Bcoef[m]/Acoef[m, p, rX];

Print[""];
Print["Closed-form q-hat (no FindRoot needed) vs FindRoot -- should agree exactly:"];
Do[
  pTrue2 = Prime[m + 2];
  pKnown = Log[Prime[m + 1]];
  rXtrue = riseX[m];
  qFR = q /. Quiet[FindRoot[errf[m, pKnown, q] == 0, {q, Log[N[pTrue2]]}]];
  qCF = qClosedForm[m, pKnown, rXtrue];
  Print[{m, "FindRoot q=", N[qFR, 12], "closed-form q=", N[qCF, 12],
     "diff=", N[qFR - qCF, 3]}],
  {m, {3, 10, 50, 300}}
];
