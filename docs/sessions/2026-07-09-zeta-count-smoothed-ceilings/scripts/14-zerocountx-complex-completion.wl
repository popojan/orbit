(* 14 -- Jan's ZeroCountX (SS4.2.6): in the exact Riemann-von Mangoldt counter, replace
   (1/Pi) Im[Log Zeta[1/2 + I t]] by the complex (I/Pi) Log[Zeta[1/2 - I t]] -- do the
   two zeta evaluations subtract?
   HYPOTHESES (stated before running):
   H1: ZeroCountX[t] == ZeroCount[t] + (I/Pi) Log[Abs[Zeta[1/2 + I t]]]
       (conjugate trick: Log Zeta[1/2 - I t] = Conjugate[Log Zeta[1/2 + I t]],
        valid except at isolated t where zeta(1/2+it) is negative real -- there the
        principal branches both give +Pi and Re X jumps by -2).
   H2: hence Re[X] - ZeroCount == 0 identically (the two zeta evaluations DO subtract,
       exactly, in the Re channel), and
       Re[X] - Im[X] - ZeroCount == -(1/Pi) Log[Abs[Zeta[1/2 + I t]]]
       (Jan's combination = pure modulus half; +infinity spikes AT the zeros).
   H3: sanity: ZeroCount is the exact RvM staircase on this window: Round[ZeroCount]
       counts zeros correctly just left/right of gamma_1..gamma_3. *)
ZeroCount[t_] := 1/Pi Im[LogGamma[1/4 + (I t)/2]] - t/(2 Pi) Log[Pi] +
   1/Pi Im[Log[Zeta[1/2 + I t]]] + 1;
ZeroCountX[t_] := 1/Pi Im[LogGamma[1/4 + (I t)/2]] - t/(2 Pi) Log[Pi] +
   I/Pi Log[Zeta[1/2 - I t]] + 1;

grid = Range[10.013, 44.987, 0.037];
a1 = Table[Re[ZeroCountX[t]] - ZeroCount[t], {t, grid}];
a2 = Table[(Re[#] - Im[#] &[ZeroCountX[t]]) - ZeroCount[t] +
    (1/Pi) Log[Abs[Zeta[1/2 + I t]]], {t, grid}];
Print["H2a: max |Re X - ZeroCount| on ", Length[grid], " pts: ", Max[Abs[a1]]];
Print["H2b: max |(Re-Im)X - ZeroCount + (1/Pi)Log|zeta|| : ", Max[Abs[a2]]];

Print["H1 Im part: max |Im X - (1/Pi)Log|zeta||: ",
  Max @ Table[Abs[Im[ZeroCountX[t]] - (1/Pi) Log[Abs[Zeta[1/2 + I t]]]], {t, grid}]];

Print["H3: staircase check around zeros:"];
Do[Print["  t=", t, "  ZeroCount=", N[ZeroCount[t], 6], "  Round=", Round[ZeroCount[t]]],
  {t, {14.0, 14.3, 20.9, 21.1, 24.9, 25.1}}];

(* exceptional points: zeta(1/2+it) negative real -> Arg = +Pi both branches *)
negreal = Select[grid, Abs[Arg[Zeta[1/2 + I #]] ] > Pi - 0.05 &];
Print["grid points with Arg zeta near +-Pi (candidate 2-jumps): ", Length[negreal],
  If[Length[negreal] > 0, {"; Re X - ZeroCount there: ",
    Table[N[Re[ZeroCountX[t]] - ZeroCount[t], 3], {t, negreal}]}, ""]];
