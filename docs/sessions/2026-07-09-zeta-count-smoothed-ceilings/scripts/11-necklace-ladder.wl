(* 11 -- Jan's observation: (1/Sqrt[p])(FractionalPart[xp[-t,p]] + 1/2) is "quite similar"
   to waveXX -- can a tweak make the sharp FractionalPart copy the smooth wave exactly?
   HYPOTHESES (stated before running):
   H1: Jan's object is exactly the k=1 rung (M_1(r) = r = 1/Sqrt[p] -- his amplitude is
       the right one) of the exact NECKLACE LADDER, obtained from the cyclotomic identity
       1 - r z = Prod_k (1 - z^k)^{M_k(r)} (Metropolis-Rota; attribution recalled) by
       taking (1/Pi) Arg on |z| = 1:
         waveXX[t,p,r] == Sum_k M_k(r) ({k t Log[p]/(2 Pi)} - 1/2),
         M_k(r) = (1/k) Sum_{d|k} MoebiusMu[k/d] r^d   (necklace polynomials).
       Moebius inversion on harmonics: the sharp sawtooth at frequency k carries overtones
       with weights 1/i, the smooth wave needs r^j/j.
   H2: the ladder converges SLOWLY: M_k(r) ~ MoebiusMu[k] r/k for k with no small divisors
       (smooth k get large corrections since r is not tiny) -- 1/k with Moebius signs, NOT
       geometric, because the k=1 saw overshoots EVERY overtone by ~r/j and each rung k
       repairs only O(r/k). Convergence is conditional/oscillatory.
   H3: consequence for the counter: substituting the ladder into Sum_p reintroduces sharp
       staircases at ALL prime-power frequencies Log[p^k] -- exactly undoing script 03's
       tower resummation -- with weights M_k(p^{-1/2}) ~ -p^{-1/2}/k at prime k, LARGER
       than the explicit formula's Lambda(n)/(Sqrt[n] Log[n]) = p^{-k/2}/k. One smooth
       atom per prime <-> sharp atoms at all its powers; sharp AND few is not available. *)

waveXX[t_, p_, r_] := 1/Pi ArcCot[Cot[t Log[p]] - Csc[t Log[p]]/r];
mk[k_, r_] := (1/k) Sum[MoebiusMu[k/d] r^d, {d, Divisors[k]}];
saw[u_] := FractionalPart[u] - 1/2;   (* u > 0 here *)
ladder[t_, p_, r_, K_] := Sum[mk[k, r] saw[k t Log[p]/(2 Pi)], {k, K}];

Print["=== H1: rung weights; Jan's amplitude = M_1 ==="];
Print["M_k(1/Sqrt[2]) k=1..6: ", N[Table[mk[k, 1/Sqrt[2]], {k, 6}], 4]];
xp[t_, p_] := t Log[p]/(2 Pi);
jan[t_, p_] := (1/Sqrt[p]) (FractionalPart[xp[-t, p]] + 1/2);
Print["Jan's object + M_1 saw[xp[t,p]] (0 expected; his -t flips the sign): ",
  Table[N[jan[t0, 2] + mk[1, 1/Sqrt[2]] saw[xp[t0, 2]], 3], {t0, {17.3, 23.9, 11.1}}]];

Print["\n=== H1: the ladder converges to waveXX ==="];
Do[
  tgt = waveXX[t0, 2, 1/Sqrt[2]];
  Print["t=", t0, "  waveXX=", N[tgt, 6], "   |ladder err| at K=1,2,5,20,100,1000: ",
    Table[N[Abs[ladder[t0, 2, 1/Sqrt[2], K] - tgt], 3], {K, {1, 2, 5, 20, 100, 1000}}]],
  {t0, {17.3, 23.9}}
];

Print["\n=== H2: slow, Moebius-modulated decay of the rungs ==="];
Print["k=101 (prime), 102 (=2*3*17, smooth), 103 (prime):  {M_k, mu(k) r/k}: ",
  N[Table[{mk[k, 1/Sqrt[2]], MoebiusMu[k]/Sqrt[2]/k}, {k, {101, 102, 103}}], 3]];
Print["prime-k rungs decay like -r/k (1/k, not geometric); smooth k deviate (higher"];
Print["necklace terms matter at r = 1/Sqrt[2]): M_102 tiny by cancellation, not by decay."];

Print["\n=== H3: weight comparison at n = p^k vs explicit formula p^{-k/2}/k ==="];
(* CORRECTED after first run: the blanket claim "necklace weights larger" is FALSE at
   p=2 small k -- r^2 = 1/2 makes (1 - r^2) = r^2, giving accidental coincidences at
   k = 3, 4 and a SMALLER rung at k = 2. The honest statement is asymptotic (k prime:
   |M_k| ~ p^{-1/2}/k >> p^{-k/2}/k) and immediate for larger p. *)
Do[
  With[{r = N[1/Sqrt[p]]},
    Print["p=", p, "  {|M_k|, p^{-k/2}/k} at k=2,3,5: ",
      Table[N[{Abs[mk[k, r]], p^(-k/2)/k}, 4], {k, {2, 3, 5}}]]],
  {p, {2, 101}}
];
Print["p=2: k=2 rung SMALLER, k=3,4 exact coincidences (r^2=1/2 accident); k=5 on: larger."];
Print["p=101: domination immediate (k=2 already 10x). Asymptotically the sharp ladder pays"];
Print["1/k-decaying weights at all powers -- strictly heavier than Lambda(n)/(Sqrt[n] Log n)."];
