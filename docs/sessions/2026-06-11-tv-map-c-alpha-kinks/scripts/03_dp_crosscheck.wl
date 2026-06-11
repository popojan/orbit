(* 03_dp_crosscheck.wl -- validate exactCVal one-sided values against the
   BeattyBallotCount DP (ground truth), 2026-06-11.
   Critical adversarial check: the apparent left-discontinuity of C at 3/2
   (left limit ~0.2246 vs C(3/2)=0.25185) could be a phase-convention
   artifact of the boundary system. DP decides.
   exactCVal predictions: C(34/23)=0.2237489 (below 3/2), C(35/23)=0.2527158
   (above 3/2), C(3/2)=0.2518482. *)
<< Orbit`

est[seq_List] := Module[{n = Length[seq], pts},
  pts = Table[{1.0/k, N[seq[[k]] Sqrt[Pi k]/4^k, 20]}, {k, n - 30, n}];
  Fit[pts, {1, x}, x] /. x -> 0];

Do[
  Module[{p = pq[[1]], q = pq[[2]], seq},
    seq = Table[BeattyBallotCount[q/p, {n, n}], {n, 1, 350}];
    Print[p, "/", q, "  DP estimate C = ", NumberForm[est[seq], 8]]],
  {pq, {{34, 23}, {35, 23}, {3, 2}}}];
