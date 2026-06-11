(* 07_dp_limit_validation.wl -- validate extrapolated left limits via DP
   at K=50 extension points (2026-06-11).
   Adversarial check on the K<=7 ladders: a slow second decay mode
   (lambda ~ 0.99 per K) would be invisible at K<=7 and would inflate J.
   Geometric-fit predictions for x at K=50 (essentially = left limit):
     19/13: x = 953/652,  predicted C ~ 0.220975
     14/13: x = 701/651,  predicted C ~ 0.05854-0.05862
     16/13: x = 811/659,  predicted C ~ 0.140991-0.141003
   If DP returns values ~7e-4 BELOW these predictions, a slow mode exists
   and the J values are overestimates. *)
<< Orbit`

est[seq_List] := Module[{n = Length[seq], pts},
  pts = Table[{1.0/k, N[seq[[k]] Sqrt[Pi k]/4^k, 20]}, {k, n - 30, n}];
  Fit[pts, {1, x}, x] /. x -> 0];

Do[
  Module[{p = pq[[1]], q = pq[[2]], seq},
    seq = Table[BeattyBallotCount[q/p, {n, n}], {n, 1, 350}];
    Print[p, "/", q, " = ", N[p/q, 8], "  DP C = ", NumberForm[est[seq], 8]]],
  {pq, {{953, 652}, {701, 651}, {811, 659}}}];
