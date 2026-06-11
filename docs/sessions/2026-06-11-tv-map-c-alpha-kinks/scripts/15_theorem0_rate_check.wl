(* 15_theorem0_rate_check.wl -- sanity check of Theorem 0 (2026-06-11).
   Theorem 0: a_alpha(n)/binom(2n-1, n-1) -> sigma(alpha) = 2 C(alpha),
   with error O(log^2 n / n).
   Check at alpha = 3/2 where C is known exactly (0.251848165836...):
   the scaled error n * (P_n - sigma) should grow at most ~log^2 n. *)
<< Orbit`

sigma32 = 2*0.25184816583628646291455836446820018953;

Do[
  Module[{a, pn, err},
    a = BeattyBallotCount[2/3, {n, n}];
    pn = N[a/Binomial[2 n - 1, n - 1], 20];
    err = pn - sigma32;
    Print["n=", n, "  P_n = ", NumberForm[pn, 10],
      "  err = ", NumberForm[N[err, 4], 4],
      "  n*err = ", NumberForm[N[n err, 4], 4]]],
  {n, {50, 100, 200, 400, 800}}];
