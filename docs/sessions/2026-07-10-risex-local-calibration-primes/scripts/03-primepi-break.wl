(* Replacing LogIntegral by PrimePi in den[m] breaks the construction: PrimePi is
   a step function (jump exactly at prime integers) while LogIntegral is smooth,
   so the "curvature is negligible" assumption the whole scheme leans on fails. *)

Sm[m_] := Sum[n/Log[Prime[n]] // N, {n, 2, m}];

riseX[m_] := (-1 + Sm[m])/(Log[m] LogIntegral[m] // N);
diffX[m_] := (riseX[m + 1] + riseX[m - 1])/2 - riseX[m];

riseXPP[m_] := (-1 + Sm[m])/(N[Log[m] PrimePi[m]]);
diffXPP[m_] := (riseXPP[m + 1] + riseXPP[m - 1])/2 - riseXPP[m];

Print["m, primeQ(m-1,m,m+1), diffX (LogIntegral), diffXPP (PrimePi), |ratio|"];
Do[
  dX = diffX[m]; dXPP = diffXPP[m];
  primality = PrimeQ /@ {m - 1, m, m + 1};
  Print[{m, "primeQ(m-1,m,m+1)=", primality, "diffX=", N[dX, 6], "diffXPP=", N[dXPP, 6],
     "|ratio|=", N[Abs[dXPP/dX], 4]}],
  {m, Range[30, 45]}
];

Print[""];
Print["Aggregate magnitude comparison over m=30..300:"];
vals = Table[{m, Abs[diffX[m]], Abs[diffXPP[m]]}, {m, 30, 300}];
avgX = Mean[vals[[All, 2]]]; avgXPP = Mean[vals[[All, 3]]];
maxX = Max[vals[[All, 2]]]; maxXPP = Max[vals[[All, 3]]];
Print[{"mean|diffX|=", N[avgX, 6], "mean|diffXPP|=", N[avgXPP, 6], "ratio of means=", N[avgXPP/avgX, 4]}];
Print[{"max|diffX|=", N[maxX, 6], "max|diffXPP|=", N[maxXPP, 6]}];
