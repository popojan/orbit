(* DENOMINATOR TEST: is 13 level-1 specific, and 55 the level-2 analogue? *)
(* For sqrt(5) = [2; 4, 4, 4, ...]:                                     *)
(*   Level 1: denom = (a2-1)*q1 + q0 = 3*4+1 = 13                      *)
(*   Level 2: denom = (a3-1)*q2 + q1 = 3*17+4 = 55 (PREDICTION)        *)

vLin[pp_, ww_, jj_] := (pp - ww jj)/pp Binomial[pp + jj - 1, jj]

pathsRat[pp_, qq_, jj_] := Module[{S, dp},
  If[jj == 0, Return[1]]; If[jj < 0, Return[0]];
  S = Table[Min[Floor[qq x/pp], jj], {x, 1, pp}];
  If[jj > S[[pp]], Return[0]];
  dp = Table[0, {pp}, {jj + 1}];
  Do[Do[If[y <= S[[x]],
    dp[[x, y + 1]] = If[x == 1 && y == 0, 1, 0] +
      If[x > 1 && y <= S[[x - 1]], dp[[x - 1, y + 1]], 0] +
      If[y > 0, dp[[x, y]], 0]],
    {y, 0, Min[jj, S[[x]]]}], {x, 1, pp}];
  dp[[pp, jj + 1]]
]

B[n_, k_] := If[k == 0, 1, Binomial[n + k - 1, k]/n];
ww = 2;
p0 = 2; q0 = 1; p1 = 9; q1 = 4; p2 = 38; q2 = 17; p3 = 161; q3 = 72;

(* === LEVEL 1: verify 13 across batches === *)
Print["===== LEVEL 1: denominator 13 across batches ====="];
Bp1 = B[p0 + p1, q0 + q1]; (* B(11,5) = 273 *)
Print["B' = B(11,5) = ", Bp1];
Print["Predicted denominator: (a2-1)*q1+q0 = ", (4 - 1) q1 + q0, " = 13"];
Print[""];

(* Polynomial corrections delta_j(p) for j=q1+1+d at positions p=p0+k*p1 *)
(* Test k=2..8 (spans batches 1 and 2) *)
Print["Polynomial sub-leading ratios c_{d-1}/c_d:"];
Do[
  j = q1 + 1 + d;
  pts = {};
  Do[
    p = p0 + k p1; q = q0 + k q1;
    If[j > q, Continue[]];
    vA = pathsRat[p, q, j]; vU = vLin[p, ww, j];
    AppendTo[pts, {p, vA - vU}],
    {k, 2, 8}];
  If[Length[pts] >= d + 1,
    poly = InterpolatingPolynomial[pts[[1 ;; d + 1]], pp];
    poly = Expand[poly];
    lead = Coefficient[poly, pp, d];
    sublead = If[d >= 1, Coefficient[poly, pp, d - 1], "n/a"];
    ratio = If[d >= 1, sublead/lead, "n/a"];
    (* Verify on all points *)
    ok = True;
    Do[{p, dd} = pts[[i]]; If[(poly /. pp -> p) =!= dd, ok = False],
      {i, d + 2, Length[pts]}];
    Print["  d=", d, " j=", j, ": ratio=", ratio,
      "  denom=", If[Head[ratio] === Rational, Denominator[ratio], "int"],
      "  verified=", ok, " (", Length[pts], " pts)"]],
  {d, 0, 5}];
Print[""];

(* === LEVEL 2: compute corrections at level-2 heights === *)
Print["===== LEVEL 2: testing denominator 55 ====="];
Bp2 = B[p1 + p2, q1 + q2]; (* B(47,21) *)
Print["B'_2 = B(47,21) = ", Bp2];
Print["Predicted denominator: (a3-1)*q2+q1 = ", (4 - 1) q2 + q1, " = 55"];
Print[""];

(* Level-2 semi-convergent positions: p1+k*p2 for k=1..a3-1=1..3 *)
(* Positions: 47, 85, 123. Convergent at 161. *)
(* Heights of interest: j = q1+q2+1+d = 22+d for d=0,1,2,... *)

Print["Computing state vectors at level-2 semi-convergent positions..."];
Print["(positions 47, 85, 123, 161 with q up to 72)"];
Print[""];

level2positions = Table[{p1 + k p2, q1 + k q2}, {k, 1, 4}];
(* {{47,21}, {85,38}, {123,55}, {161,72}} *)

Do[
  {p, q} = level2positions[[i]];
  Print["  p=", p, " q=", q, " computing..."],
  {i, 1, 4}];
Print[""];

(* Corrections at level-2 heights *)
Print["Polynomial corrections at level-2 heights (j = q1+q2+1+d):"];
Do[
  j = q1 + q2 + 1 + d; (* heights 22, 23, 24, ... *)
  pts = {};
  Do[
    {p, q} = level2positions[[i]];
    If[j > q, Continue[]];
    vA = pathsRat[p, q, j]; vU = vLin[p, ww, j];
    AppendTo[pts, {p, vA - vU}],
    {i, 2, 4}]; (* skip k=1 since corrections might be 0 there *)
  If[Length[pts] >= d + 1 && d >= 1,
    poly = InterpolatingPolynomial[pts[[1 ;; d + 1]], pp];
    poly = Expand[poly];
    lead = Coefficient[poly, pp, d];
    sublead = Coefficient[poly, pp, d - 1];
    ratio = sublead/lead;
    Print["  d=", d, " j=", j, ": lead=", lead,
      "  ratio c_{d-1}/c_d = ", ratio,
      "  denom = ", If[Head[ratio] === Rational, Denominator[ratio], "int"]],
    If[d == 0 && Length[pts] >= 1,
      Print["  d=0 j=", j, ": constant = ", pts[[1, 2]],
        " = -B'_2 = ", -Bp2, "? ", pts[[1, 2]] === -Bp2]]],
  {d, 0, 5}];
Print[""];

(* === COMPARISON === *)
Print["===== COMPARISON ====="];
Print["Level 1: denominator = (a-1)*q1+q0 = 3*4+1 = 13"];
Print["Level 2: denominator = (a-1)*q2+q1 = 3*17+4 = 55 (if pattern holds)"];
Print[""];
Print["Pattern: at each level k, denominator = (a_{k+1}-1)*q_k + q_{k-1}"];
Print["= q at the PENULTIMATE semi-convergent of the current batch"];
Print[""];
Print["For sqrt(5) = [2; 4,4,4,...]:"];
Print["  Level 1: ", 3 q1 + q0, " = ", 13];
Print["  Level 2: ", 3 q2 + q1, " = ", 55];
Print["  Level 3: ", 3 q3 + q2, " = ", 3*72+17, " = 233"];
Print["  These are q_{k+1} - q_k: ", q2 - q1, ", ", q3 - q2, ", ", (4 q3 + q2) - q3];
