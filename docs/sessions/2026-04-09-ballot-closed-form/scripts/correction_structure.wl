(* Explore the correction structure for j > q1 *)
(* Hypothesis: correction might have recursive ballot structure *)

Needs["Orbit`"];

Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]
Ballot[n_, k_] := If[k == 0, 1, Binomial[n + k - 1, k]/n]

stateVectors[alpha_, xMax_] := Module[
  {v = {1}, m = 0, prevS = 0, curS, results = <||>},
  results[1] = {0, {1}};
  Do[curS = Floor[x/alpha];
    If[curS == prevS, v = Lmat[m] . v,
      v = Lmat[m + 1] . Append[v, 0]; m++];
    prevS = curS; results[x] = {m, v}, {x, 2, xMax}];
  results
]

vLinear[p_, w_, j_] := (p - w j)/p Binomial[p + j - 1, j]

(* === Pi: corrections at j=8,...,14 for several level-2 positions === *)
Print["=== Pi: Corrections for j > q1=7 ==="];
Print[""];
data = stateVectors[Pi, 200];

(* Level-2 positions with enough height *)
positions = {47, 69, 91, 113, 135, 157, 179};
w = 3;

(* Compute correction = actual - linear formula *)
Print["j \t corr(p=47) \t corr(p=69) \t corr(p=91) \t constant?"];
Do[
  corrs = {};
  Do[
    {m, v} = data[p];
    If[j < Length[v],
      actual = v[[j + 1]];
      predicted = vLinear[p, w, j];
      AppendTo[corrs, actual - predicted],
      AppendTo[corrs, "---"]],
    {p, positions}];
  isConstant = (Length[Union[Select[corrs, IntegerQ]]] <= 1);
  Print["j=", j, "\t", corrs[[1]], "\t", corrs[[2]], "\t", corrs[[3]],
    "\t", If[isConstant, "YES", "NO"]],
  {j, 7, 20}];
Print[""];

(* === The correction sequence for Pi (from p=179, which has height 56) === *)
Print["=== Full correction sequence for Pi (using p=179) ==="];
{m179, v179} = data[179];
corrSeq = Table[
  v179[[j + 1]] - vLinear[179, 3, j],
  {j, 0, Min[30, Length[v179] - 1]}];
Print["Corrections j=0..30:"];
Do[Print["  j=", j, " corr=", corrSeq[[j + 1]]], {j, 0, 20}];
Print[""];

(* === Do the corrections themselves follow a ballot-like formula? === *)
(* At j=q1+1 = 8: correction = -B(25, 8) = -420732 *)
(* Hypothesis: corrections for j=8,...,14 might be: *)
(*   corr(j) = -vLinear(p', w, j-q1-1) where p' = p0+p1 = 25? *)
(*   or: corr(j) = -(p'-w*(j-q1-1))/p' * C(p'+j-q1-2, j-q1-1) *)

Print["=== Testing recursive hypothesis ==="];
Print["corr(j) =? -(25 - 3*(j-8))/25 * C(25+(j-8)-1, j-8) for j=8..14"];
Print["i.e., corr(j) =? -vLinear(25, 3, j-8)"];
Do[
  j2 = j - 8; (* shifted index *)
  predicted = -vLinear[25, 3, j2];
  actual = corrSeq[[j + 1]];
  Print["  j=", j, " (j2=", j2, "): corr=", actual,
    " -vLinear(25,3,", j2, ")=", predicted,
    If[actual === predicted, " MATCH", " DIFFER"]],
  {j, 8, 15}];
Print[""];

(* === Alternative: maybe the corrections use the FULL formula with p'=25, w=3 === *)
(* But only up to j2 = q1 = 7 again? === *)
Print["=== Is the correction range also q1? ==="];
Do[
  j2 = j - 8;
  predicted = -vLinear[25, 3, j2];
  actual = corrSeq[[j + 1]];
  diff2 = actual - predicted;
  Print["  j=", j, " (j2=", j2, "): corr=", actual,
    " pred=", predicted, " diff2=", diff2],
  {j, 8, 22}];
Print[""];

(* === What about a two-level formula? === *)
(* v_j = vLinear(p, w, j) + sum of corrections from each "level" *)
(* Level 0: vLinear(p, 3, j) for j=0..q1=7 *)
(* Level 1: -vLinear(25, 3, j-8) for j=8..14? And then another level? *)

(* === Check: what is B(p', q') for the second correction break? === *)
Print["=== Looking for second correction break ==="];
Print["Corrections at j=15 and j=16:"];
Print["  j=15: ", corrSeq[[16]]];
Print["  j=16: ", corrSeq[[17]]];

(* If the correction at j=8..14 follows vLinear(25, 3, .), then at j=15 *)
(* (which is j2=7), it should still work. At j=16 (j2=8), it might break *)
(* with a second-order correction involving the NEXT semi-convergent *)

(* Level-2 semi-convergents of Pi: 25/8, 47/15, 69/22, ... *)
(* The "level 3" would involve p1+p2 = 22+333=355, q1+q2=7+106=113 *)
(* But that's far beyond our data. *)

(* Let's check within our range using Pi more carefully. *)
(* Between 25/8 and 47/15, the structure is the SAME as between p0=3 and p1=22 *)
(* but at a higher level. The "inner CF" of 25/8 has [3;7,...] structure. *)

(* Actually, let me think about this differently. *)
(* The correction sequence from j=8 onward is the STATE VECTOR of a sub-problem. *)
(* What sub-problem? *)

Print[""];
Print["=== Correction sequence as state vector ==="];
corrFromJ8 = Table[corrSeq[[j + 1]], {j, 8, Min[30, Length[corrSeq] - 1]}];
Print["Corrections from j=8: ", Take[corrFromJ8, Min[15, Length[corrFromJ8]]]];
Print[""];
Print["Negated: ", -Take[corrFromJ8, Min[15, Length[corrFromJ8]]]];
Print[""];

(* These negated corrections should be a state vector for some sub-problem *)
(* Compare with the state vector at x=25 *)
{m25, v25} = data[25];
Print["State at x=25: ", v25];
Print[""];

(* The state at x=25 has 8 entries. The corrections from j=8 have many entries. *)
(* Maybe the corrections are NOT the state vector at 25, but something else. *)

(* === Simpler test: Golden Ratio === *)
Print["=== GoldenRatio correction structure ==="];
dataGR = stateVectors[GoldenRatio, 100];
(* q1 = 1, breaks at j=2 with diff=-2=B(3,2) *)
(* Convergents: 1/1, 2/1, 3/2, 5/3, 8/5, 13/8, 21/13, 34/21, 55/34, 89/55 *)

{m89, v89} = dataGR[89];
corrGR = Table[v89[[j + 1]] - vLinear[89, 1, j], {j, 0, Min[30, Length[v89] - 1]}];
Print["GR corrections j=0..20:"];
Do[Print["  j=", j, " corr=", corrGR[[j + 1]]], {j, 0, 20}];
Print[""];

(* For GR: q1=1, first break at j=2 with -2=-B(3,2) *)
(* q2=1 (CF [1;1,1,...] all partial quotients 1) *)
(* So the correction should break again at j=3? with -B(next semi-conv)? *)
(* Since there are no semi-convergents for GR, the "levels" are just convergents *)
(* p0=1, p1=2, p2=3, p3=5, p4=8, ... *)

(* Level 0: formula for j=0..q1=1 *)
(* Level 1: correction = -B(p0+p1, q0+q1) = -B(3,2) = -2 for j=2 *)
(* Level 2: second correction at j=3 involving -B(p1+p2, q1+q2) = -B(5,3) = -7 ? *)

Print["Testing GR level-2 correction:"];
Print["corr(2) = ", corrGR[[3]], " expected -B(3,2) = ", -Ballot[3, 2]];
Print["corr(3) = ", corrGR[[4]],
  " -vLinear(3,1,1) + ??? = ", -vLinear[3, 1, 1]];

(* If correction at j>=2 is -vLinear(3,1,j-2), then: *)
Do[
  j2 = j - 2;
  pred = -vLinear[3, 1, j2];
  Print["j=", j, " corr=", corrGR[[j + 1]], " -vLinear(3,1,", j2, ")=", pred,
    " diff2=", corrGR[[j + 1]] - pred],
  {j, 2, 8}];
Print[""];

(* === Sqrt[5] correction structure === *)
Print["=== Sqrt[5] correction structure ==="];
data5 = stateVectors[Sqrt[5], 200];
{m83, v83} = data5[83];
corrS5 = Table[v83[[j + 1]] - vLinear[83, 2, j], {j, 0, Min[25, Length[v83] - 1]}];
Print["Sqrt5 corrections j=0..25:"];
Do[Print["  j=", j, " corr=", corrS5[[j + 1]]], {j, 0, 20}];
Print[""];

(* q1=4, first break at j=5 with -273=-B(11,5) *)
(* Level-1 correction: -vLinear(11, 2, j-5) for j=5,...,8? *)
Do[
  j2 = j - 5;
  pred = -vLinear[11, 2, j2];
  Print["j=", j, " (j2=", j2, "): corr=", corrS5[[j + 1]],
    " -vLinear(11,2,", j2, ")=", pred,
    If[corrS5[[j + 1]] === pred, " MATCH", " diff=" <> ToString[corrS5[[j + 1]] - pred]]],
  {j, 5, 15}];
