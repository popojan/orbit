(* C (speculative, bounded): is the PRIME-frequency structure dynamically
   special in a quasiperiodic transfer cocycle -- i.e. does integrality
   (Q-independence of log p, additive closure = log-integers) make the Lyapunov
   exponent behave specially vs GENERIC frequencies of matched amplitudes?

   If integrality does nothing here, "integrality forces reality via the cocycle"
   has no mechanism -> humble fallback to A/B.

   Schrodinger cocycle on a chain: T_n(en) = {{en - V_n, -1},{1,0}}, det 1,
   V_n = sum_p a_p cos(n omega_p + phi_p),  a_p = log(p)/p^sigma  (explicit-
   formula amplitudes).  omega_p = log p (PRIME) vs generic frequencies (CONTROL).

   PRE-REGISTERED PREDICTION: L is amplitude-driven (~ sum a_p^2), so
   L_prime ~ L_generic; the sigma=1/2 balance comes from sum p^{-2sigma}, not
   the frequencies. FALSIFIED if L_prime differs systematically from L_generic,
   or prime shows special spectral gaps at log-integer energies. *)

SeedRandom[42];
nprimes = 30;
prs = Prime[Range[nprimes]];
freqP = N[Log[prs]];                                  (* prime frequencies log p *)
freqG = Sort[N[RandomReal[{Log[2], Log[prs[[-1]]]}, nprimes]]];  (* generic, matched range *)
phases = N[RandomReal[{0, 2 Pi}, nprimes]];
Print["primes up to ", prs[[-1]], ";  ", nprimes, " frequencies"];
Print["freq range log p: ", N[{freqP[[1]], freqP[[-1]]}, 4]];

ampl[sig_] := N[Log[prs]/prs^sig];

(* top Lyapunov exponent of the transfer cocycle, with renormalization *)
lyap[freqs_, sig_, en_, nsteps_] := Module[{a = ampl[sig], Vv, v = {1., 0.}, s = 0., pot, nr},
  Vv = Table[Sum[a[[j]] Cos[n freqs[[j]] + phases[[j]]], {j, nprimes}], {n, nsteps}];
  Do[pot = Vv[[n]];
     v = {(en - pot) v[[1]] - v[[2]], v[[1]]};
     nr = Sqrt[v.v]; s += Log[nr]; v = v/nr,
   {n, nsteps}];
  s/nsteps];

nst = 20000;
Print["\n=== L(en=0) vs sigma : PRIME vs GENERIC (matched amplitudes) ==="];
Print[" sigma | L_prime | L_generic | ratio"];
Do[With[{lp = lyap[freqP, sig, 0., nst], lg = lyap[freqG, sig, 0., nst]},
   Print["  ", PaddedForm[N[sig, 3], {4, 2}], " | ",
     PaddedForm[N[lp, 4], {7, 5}], " | ", PaddedForm[N[lg, 4], {7, 5}], " | ",
     PaddedForm[N[lp/lg, 3], {5, 3}]]],
  {sig, {0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 1.0}}];

Print["\n=== Lyapunov spectrum L(en) at sigma=1/2 : PRIME vs GENERIC ==="];
Print[" en  | L_prime | L_generic   (look for prime-special gaps where L jumps)"];
Do[With[{lp = lyap[freqP, 0.5, en, nst], lg = lyap[freqG, 0.5, en, nst]},
   Print["  ", PaddedForm[N[en, 3], {5, 2}], " | ",
     PaddedForm[N[lp, 4], {7, 5}], " | ", PaddedForm[N[lg, 4], {7, 5}]]],
  {en, Range[-4, 4, 1]}];

(* targeted: do gaps open at log-integer energies for prime but not generic? *)
Print["\n=== probe energies near log-integers (the prime beat lattice) ==="];
Print[" en=log(m) | m | L_prime | L_generic"];
Do[With[{en = N[Log[m]], lp = 0, lg = 0},
   With[{lp2 = lyap[freqP, 0.5, N[Log[m]], nst], lg2 = lyap[freqG, 0.5, N[Log[m]], nst]},
    Print["  ", PaddedForm[N[Log[m], 4], {6, 4}], " | ", PaddedForm[m, 3], " | ",
      PaddedForm[N[lp2, 4], {7, 5}], " | ", PaddedForm[N[lg2, 4], {7, 5}]]]],
  {m, {2, 3, 4, 5, 6, 7, 8, 9, 10}}];

Print["\nVERDICT criterion: if L_prime ~ L_generic throughout (ratio ~1, no",
   " prime-special gaps) => integrality is NOT dynamically special here =>",
   " C has no mechanism => humble fallback to A/B. Systematic difference or",
   " prime-only gaps at log-integers => C has legs."];
Print["DONE."];
