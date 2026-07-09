(* follow-up to 05/H4: HYPOTHESIS (stated before running): the finite-m RMS-optimal sigma
   is a truncation/regularization artifact sitting ABOVE 1/2 and drifting toward 1/2 as m
   grows: sigma_opt(20) > sigma_opt(50) > sigma_opt(168). *)
waveXX[x_, p_, r_] := 1/Pi ArcCot[Cot[x Log@p] - Csc[x Log@p]/r];
nt7[t_] := t/(2 Pi) Log[t/(2 Pi E)] + 7/8;
kmax = 300;
gams = Table[N[Im[ZetaZero[k]], 20], {k, kmax}];
sigmaCount[t_, m_, sig_] := nt7[t] + Sum[waveXX[t, Prime[j], Prime[j]^-sig], {j, m}];
Do[
  rmsl = Table[{sig, Sqrt[Mean[Table[(sigmaCount[gams[[k]], m, sig] - (k - 1/2))^2, {k, kmax}]]]},
     {sig, 0.50, 0.80, 0.025}];
  best = First[SortBy[rmsl, Last]];
  Print["m=", m, "  sigma_opt=", best[[1]], "  RMS_opt=", N[best[[2]], 4],
    "  (RMS at 0.5: ", N[Sqrt[Mean[Table[(sigmaCount[gams[[k]], m, 0.5] - (k - 1/2))^2, {k, kmax}]]], 4], ")"],
  {m, {20, 50, 168}}
]
