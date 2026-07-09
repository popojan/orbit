(* 12 -- Jan's question: quantize the wave shape AND discretize the t-domain -- could the
   sum over primes simplify within each t-bin?
   HYPOTHESES (stated before running):
   H1: FREEZING one prime works, two never: sampling at t_n = 2 Pi n/Log[p] locks prime p's
       phase (binned symbol constant); simultaneous locking of p and q needs
       Log[p]/Log[q] rational, i.e. p^a = q^b -- impossible by unique factorization.
       The ln-p frequencies' Q-linear independence IS the primes' independence.
   H2: the binned joint signal is a cut-and-project (model-set/quasicrystal) word with
       internal dimension m: subword complexity of the SUMMED symbol sequence grows
       superlinearly in window length L, with exponent increasing with m (one rotation:
       linear, Sturmian/Rote class) -- quantization does NOT compress the m-torus.
   H3: per-bin constancy is tautological and the bins shrink as primes are added:
       quantization-boundary crossings occur at rate B theta(p_m)/(2 Pi) per unit t
       (B = bins/period) -- the primorial density of SS4.1 again. *)

alpha[p_] := Log[p]/(2 Pi);
sym[t_, p_] := Floor[2 FractionalPart[t alpha[p]]];          (* B = 2 bins *)
word[ps_, delta_, nmax_] := Table[Total[sym[n delta, #] & /@ ps], {n, 1, nmax}];
complexity[w_, L_] := Length[Union[Partition[w, L, 1]]];

Print["=== H1: freeze one prime, never two ==="];
w2 = word[{2}, 2 Pi/Log[2], 2000];
Print["p=2 sampled at delta = 2Pi/Log[2]: distinct symbols ", Union[w2], "  (frozen)"];
w23 = word[{2, 3}, 2 Pi/Log[2], 2000];
Print["{2,3} at the same grid: distinct sums ", Union[w23], "  (3 still moves)"];
Print["locking both needs Log[3]/Log[2] in Q, i.e. 2^a == 3^b: impossible (unique factorization)."];

Print["\n=== H2: subword complexity of the summed symbol, m = 1, 2, 3 ==="];
delta = 0.6180339887;   (* generic step *)
Do[
  w = word[Prime[Range[m]], delta, 200000];
  cts = Table[complexity[w, L], {L, {2, 4, 6, 8, 10, 12}}];
  Print["m=", m, "  #distinct windows at L=2,4,6,8,10,12: ", cts],
  {m, {1, 2, 3}}
];
Print["one prime: linear growth (rotation coding); the sum over m primes explores the"];
Print["m-torus -- growth accelerates with m; no collapse without a rational relation."];

Print["\n=== H3: crossing rate = B theta(p_m)/(2 Pi) per unit t ==="];
Do[
  ps = Prime[Range[m]];
  w = word[ps, 0.001, 100000];   (* fine grid over t in (0,100) *)
  jumps = Count[Differences[w], x_ /; x != 0];
  Print["m=", m, "  measured jumps per unit t: ", N[jumps/100., 4],
    "  predicted 2 theta/(2 Pi) = ", N[2 Total[Log[ps]]/(2 Pi), 4]],
  {m, {2, 5, 10}}
];
