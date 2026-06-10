(* H1/H2 test: truncated propagation kernel K(m -> d) of the R7 phase
   recursion equals the uniform ballot value v_{d-m+1}(p1 - w m), and
   equals an independent direct DP below the uniform staircase
   S(x) = Floor[qres x / P], P = (q1-m) w + 1, qres = q1 - m. *)

vLin[p_, w_, j_] := (p - w j)/p Binomial[p + j - 1, j]

(* n-fold prefix sum, n = 0 is identity *)
propagate[vec_, n_, dMax_] := Table[
  Sum[Binomial[dp - dpp + n - 1, dp - dpp] * vec[[dpp + 1]], {dpp, 0, dp}],
  {dp, 0, dMax}]

(* Kernel: unit injection at row index m-1 in phase m, propagated through
   the phase recurrence (pad -> L^1 -> inject -> L^{w-1}; last phase L^0) *)
kernelK[w_, q1_, m_] := Module[{vec = {}},
  Do[
    vec = Append[vec, 0];
    vec = propagate[vec, 1, mm - 1];
    If[mm == m, vec[[mm]] = vec[[mm]] + 1];
    If[mm < q1 && w > 1, vec = propagate[vec, w - 1, mm - 1]],
    {mm, 1, q1}];
  vec]

(* Independent direct DP: monotone paths from (1,0) weakly below
   S(x) = Floor[qq x / pp]; returns state vector at x = pp *)
directDP[pp_, qq_] := Module[{vec = {1}, sPrev = 0, sCur},
  Do[
    sCur = Floor[qq x / pp];
    vec = If[sCur == sPrev,
      propagate[vec, 1, sCur],
      propagate[Append[vec, 0], 1, sCur]];
    sPrev = sCur,
    {x, 2, pp}];
  vec]

Print["================================================================"];
Print["H1: K(m->d) == vLin[p1 - w m, w, d-m+1]"];
Print["H2: K(m->.) == directDP[(q1-m) w + 1, q1-m]"];
Print["================================================================"];

failH1 = {}; failH2 = {}; nChecks1 = 0; nChecks2 = 0;

Do[
  p1 = q1 w + 1;
  Do[
    kk = kernelK[w, q1, m];
    (* H1: endpoint entries *)
    Do[
      jj = d - m + 1;
      expected = vLin[p1 - w m, w, jj];
      actual = kk[[d + 1]];
      nChecks1++;
      If[actual =!= expected,
        AppendTo[failH1, {w, q1, m, d, actual, expected}]],
      {d, m - 1, q1 - 1}];
    (* entries below injection row must vanish *)
    Do[
      If[kk[[d + 1]] =!= 0,
        AppendTo[failH1, {w, q1, m, d, kk[[d + 1]], 0}]],
      {d, 0, m - 2}];
    (* H2: compare with independent staircase DP (relative heights) *)
    If[m < q1,
      dd = directDP[(q1 - m) w + 1, q1 - m];
      nChecks2++;
      If[kk[[m ;; q1]] =!= dd,
        AppendTo[failH2, {w, q1, m, kk[[m ;; q1]], dd}]]],
    {m, 1, q1}],
  {w, 1, 5}, {q1, 2, 8}];

Print["H1 checks: ", nChecks1, ", failures: ", Length[failH1]];
If[failH1 =!= {}, Print["  first failures: ", Take[failH1, UpTo[5]]]];
Print["H2 checks: ", nChecks2, ", failures: ", Length[failH2]];
If[failH2 =!= {}, Print["  first failures: ", Take[failH2, UpTo[5]]]];

Print[""];
Print["Verdict H1: ", If[failH1 === {}, "CONFIRMED", "FALSIFIED"]];
Print["Verdict H2: ", If[failH2 === {}, "CONFIRMED", "FALSIFIED"]];

(* Full reassembly cross-check: linearity + kernel vs original R7 sum,
   numeric d0, s sweep, exact arithmetic *)
r7[d0_, w_, p1_, d_, s_] := Sum[
  vLin[p1 - w m, w, d - m + 1] * Binomial[d0 - 2 + m (w + 1) - s, m w - 1],
  {m, 1, d + 1}]

tCreate[d0_, w_, m_, s_] := Binomial[m w - 1 + d0 + m - 1 - s, d0 + m - 1 - s]

failR = {}; nChecksR = 0;
Do[
  p1 = q1 w + 1;
  Do[
    lhs = Sum[tCreate[d0, w, m, s] * kernelK[w, q1, m][[d + 1]], {m, 1, d + 1}];
    rhs = r7[d0, w, p1, d, s];
    nChecksR++;
    If[Simplify[lhs - rhs] =!= 0, AppendTo[failR, {w, q1, d0, s, d}]],
    {d, 0, q1 - 1}, {d0, 2, 5}, {s, 0, 2}],
  {w, 1, 3}, {q1, 2, 6}];

Print[""];
Print["Reassembly checks: ", nChecksR, ", failures: ", Length[failR]];
If[failR =!= {}, Print["  first failures: ", Take[failR, UpTo[5]]]];
Print["Verdict reassembly: ", If[failR === {}, "CONFIRMED", "FALSIFIED"]];
Print[""];
Print["===== DONE ====="];
