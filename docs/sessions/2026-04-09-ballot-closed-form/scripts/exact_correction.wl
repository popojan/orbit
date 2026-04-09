(* Find exact form of correction polynomials *)
(* Key insight: v_j(p) = paths under rational staircase floor[qx/p] *)
(* where q = q0 + j2*q1 for the j2-th level-2 semi-convergent *)
(* So v_j depends on p AND q, and q varies with p! *)

Needs["Orbit`"];

Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]
vLinear[p_, w_, j_] := (p - w j)/p Binomial[p + j - 1, j]
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

(* === Rational staircase path count === *)
(* Compute paths from (1,0) to (p, j) under floor[qx/p] directly *)
pathsRational[p_, q_, j_] := Module[{S, dp},
  If[j == 0, Return[1]];
  S = Table[Min[Floor[q x/p], j], {x, 1, p}];
  If[j > S[[p]], Return[0]];
  dp = Table[0, {p}, {j + 1}];
  Do[Do[
    If[y <= S[[x]],
      dp[[x, y + 1]] =
        If[x == 1 && y == 0, 1, 0] +
        If[x > 1 && y <= S[[x - 1]], dp[[x - 1, y + 1]], 0] +
        If[y > 0, dp[[x, y]], 0]],
    {y, 0, Min[j, S[[x]]]}], {x, 1, p}];
  dp[[p, j + 1]]
]

(* === Verify: paths under rational staircase = paths under irrational staircase === *)
Print["=== Verification: rational = irrational at semi-convergent positions ==="];
data = stateVectors[Pi, 100];
(* Semi-conv 47/15: floor[x/Pi] = floor[15x/47] for x=1..46 *)
Do[
  {m, v} = data[47];
  vjIrr = v[[j + 1]];
  vjRat = pathsRational[47, 15, j];
  If[vjIrr =!= vjRat,
    Print["MISMATCH at j=", j, ": irr=", vjIrr, " rat=", vjRat]],
  {j, 0, 14}];
Print["All match for 47/15 (j=0..14)."];
Print[""];

(* === Now: compute v_j(p, q) for many (p, q) pairs === *)
(* For Pi, the semi-convergents are p/q = (3+22k)/(1+7k) *)
(* Key: both p and q vary! q = 1+7k, p = 3+22k = 22/7 * q + 1/7 *)
(* So p = p1/q1 * q + (p0*q1 - p1*q0)/q1 = 22/7 * q + 1/7 *)
(* Equivalently: p = (22q+1)/7, which is integer for q = 1+7k *)

Print["=== Exact v_j(p,q) for Pi semi-convergents ==="];
Print[""];

(* Compute v_j for several semi-convergents and express correction *)
piSemiConv = Table[{3 + 22 k, 1 + 7 k}, {k, 1, 12}];
w = 3; q1 = 7;

(* For each j, collect {p, q, correction} triples *)
Do[
  Print["--- j = ", j, " ---"];
  triples = {};
  Do[
    {p, q} = pq;
    vj = pathsRational[p, q, j];
    lin = vLinear[p, w, j];
    corr = vj - lin;
    AppendTo[triples, {p, q, corr, vj}],
    {pq, piSemiConv}];

  (* Show the correction, and test if it depends on q as well as p *)
  Do[Print["  p=", triples[[i, 1]], " q=", triples[[i, 2]],
    " corr=", triples[[i, 3]]], {i, 1, Min[6, Length[triples]]}];

  (* Key test: is correction a polynomial in p alone, or in p and q? *)
  (* Since q = (p-3)/22 * 7 + 1 = (7p-21+22)/22 = (7p+1)/22, *)
  (* p and q are linearly related. So polynomial in p = polynomial in q. *)
  Print[""],
  {j, 8, 12}];

(* === Express correction in the BINOMIAL basis C(p+j-1, j) === *)
(* v_j(p,q) = f(p,q) * C(p+j-1, j) / p *)
(* The linear formula: f = p - wj *)
(* The correction adds: delta_f = corr * p / C(p+j-1, j) *)
Print["=== Factor f(p) where v_j = f(p)/p * C(p+j-1, j) ==="];
Print[""];
Do[
  Print["--- j = ", j, " ---"];
  Do[
    {p, q} = piSemiConv[[i]];
    vj = pathsRational[p, q, j];
    binom = Binomial[p + j - 1, j];
    f = vj * p / binom;
    fLinear = p - w j;
    Print["  p=", p, " q=", q, " f(p)=", f,
      " linear=", fLinear, " diff=", f - fLinear],
    {i, 1, Min[6, Length[piSemiConv]]}];
  Print[""],
  {j, 0, 12}];

(* === Try: v_j(p) for GENERIC rational p/q (not just Pi semi-conv) === *)
(* Use several different rational staircases to check universality *)
Print["=== v_j for generic rational p/q with same CF structure ==="];
Print[""];

(* CF [3; 7] gives p/q with floor = 3 and 7 sub-stairs *)
(* Any p/q = [3; 7, ...] = (22k + r)/(7k + s) for various k, r, s *)
(* Let's try p/q = 47/15 = [3; 7, 1] and 69/22 = [3; 7, 2] *)
(* Also try p/q with CF [3; 7] exactly: p/q = 22/7 *)
(* And CF [3; 8]: p/q = 25/8 *)

Print["v_j for p/q = 22/7 (CF = [3; 7]):"];
Do[
  vj = pathsRational[22, 7, j];
  lin = vLinear[22, 3, j];
  Print["  j=", j, " v=", vj, " linear=", lin, " diff=", vj - lin],
  {j, 0, 7}];
Print[""];

Print["v_j for p/q = 25/8 (CF = [3; 8]):"];
Do[
  vj = pathsRational[25, 8, j];
  lin = vLinear[25, 3, j];
  Print["  j=", j, " v=", vj, " linear=", lin, " diff=", vj - lin],
  {j, 0, 8}];
Print[""];

Print["v_j for p/q = 47/15 (CF = [3; 7, 1]):"];
Do[
  vj = pathsRational[47, 15, j];
  lin = vLinear[47, 3, j];
  Print["  j=", j, " v=", vj, " linear=", lin, " diff=", vj - lin],
  {j, 0, 14}];
Print[""];

(* === CRUCIAL TEST: does the correction depend on the CF of p/q? === *)
(* Compare two fractions with the SAME q1=7 but different higher CF: *)
(* 47/15 = [3; 7, 1] vs 50/16 = [3; 7, ... ]? *)
(* Actually 50/16 = 25/8, gcd=2. Let's use 53/17 = [3; 8, 1, ...] *)
Print["=== Comparing different CF structures ==="];
Print[""];

(* All fractions with floor = 3: *)
fracs = {{22, 7}, {25, 8}, {47, 15}, {50, 16}};
(* Wait, gcd(50,16)=2, not coprime. Use: *)
fracs = {{22, 7}, {25, 8}, {47, 15}, {69, 22}, {28, 9}, {31, 10}, {34, 11}};

Do[
  {p, q} = pq;
  If[GCD[p, q] != 1, Continue[]];
  cf = ContinuedFraction[p/q];
  Print["p/q = ", p, "/", q, " CF = ", cf];
  Do[
    vj = pathsRational[p, q, j];
    lin = vLinear[p, 3, j];
    Print["  j=", j, " v=", vj, " lin=", lin, " diff=", vj - lin],
    {j, 0, Min[q, 10]}];
  Print[""],
  {pq, fracs}];

(* === Key: paths under floor[qx/p] as function of (p,q,j) === *)
(* For p/q = [a0; a1, ...], the first a1 stairs have width a0.     *)
(* For j <= a1: v_j = (p-a0*j)/p * C(p+j-1, j) (uniform formula)  *)
(* For j = a1+1: correction = -B(next convergent parameters)       *)

(* The "next convergent" for p/q = [a0; a1, a2, ...] is:           *)
(* p'/q' where p' and q' relate to the CF remainders               *)

(* For p/q = [3; 7, 1] = 47/15:                                    *)
(* CF: a0=3, a1=7, a2=1                                            *)
(* Convergents: 3/1, 22/7, 47/15                                   *)
(* The "first correction" comes from the a1=7 transition            *)
(* At j=8: correction should be -B(p-a0*a1, q-a1) ??              *)

Print["=== Correction in terms of CF parameters ==="];
Print[""];
(* For 47/15 = [3; 7, 1]: *)
(* p0/q0 = 3/1, p1/q1 = 22/7 *)
(* The correction at j=q1+1=8 is -B(p-p1, q-q1) = -B(25, 8) *)
Print["47/15: p-p1=", 47-22, " q-q1=", 15-7, " B=", Ballot[25, 8]];
Print["corr(47, 8) = ", pathsRational[47, 15, 8] - vLinear[47, 3, 8]];
Print[""];

(* For 69/22 = [3; 7, 2]: *)
(* p0=3, q0=1, p1=22, q1=7 *)
Print["69/22: p-p1=", 69-22, " q-q1=", 22-7, " B=", Ballot[47, 15]];
Print["corr(69, 8) = ", pathsRational[69, 22, 8] - vLinear[69, 3, 8]];
Print["Hmm, B(47,15) = ", Ballot[47, 15], " vs corr = ", pathsRational[69, 22, 8] - vLinear[69, 3, 8]];
Print[""];

(* Different idea: correction = -B(p0+p1, q0+q1) always? *)
(* For 47/15: p0+p1 = 25, q0+q1 = 8. B(25,8) = 420732 *)
(* For 69/22: same p0, p1 (from Pi CF). B(25,8) = 420732 *)
(* These are the SAME because p0, p1, q0, q1 come from the IRRATIONAL's CF, *)
(* not from the rational p/q itself! *)

(* But wait: for a generic rational p/q (not a semi-convergent of Pi), *)
(* the "p0, p1" would be the convergents of p/q's OWN CF. *)

(* Let's test: for 28/9 = [3; 8, ... ]: *)
Print["28/9 = ", ContinuedFraction[28/9]]; (* [3; 8] ? *)
Print["Convergents: 3/1, 28/9"];
Print["q1 = 9 from [3; 9] -- wait, 28/9 = 3 + 1/9, so CF = [3; 9]");
Print["corr at j=10: ", pathsRational[28, 9, 10] - vLinear[28, 3, 10]];
(* p0=3, q0=1, p1=28, q1=9 for this rational. correction should be -B(31, 10)? *)
Print["But 28/9 has no further terms (exact rational), so correction at j=q+1 doesn't apply"];
Print[""];

(* Let's test 31/10 = [3; 10] ? No: 31/10 = 3 + 1/10, CF = [3; 10] *)
cf31 = ContinuedFraction[31/10];
Print["31/10 CF = ", cf31, " — 2-term CF, q1=10"];
(* For exact rational p/q = [a0; a1], there's no correction needed: *)
(* the staircase is uniform (width a0) for the first a1 stairs, *)
(* then a final stair of different width. *)
(* The formula v_j = (p-a0*j)/p * C(p+j-1, j) should work for j <= a1 *)
(* And for j = a1+1 = q: v_q = B(p,q) — exact! *)

(* So for 2-term CF rationals: formula works for ALL j! *)
(* The corrections only appear for 3+ term CF rationals. *)

Print["=== Testing: 2-term CF rationals have NO correction ==="];
Do[
  p = a0 * a1 + 1; q = a1;
  allOK = True;
  Do[
    vj = pathsRational[p, q, j];
    lin = vLinear[p, a0, j];
    If[vj =!= lin, allOK = False; Print["  FAIL: ", p, "/", q, " j=", j]],
    {j, 0, q}];
  If[allOK, Print["  ", p, "/", q, " = [", a0, "; ", a1, "]: ALL OK (j=0..", q, ")"]],
  {a0, {2, 3, 4}}, {a1, {3, 5, 7, 10}}];
Print[""];

(* === For 3-term CF: p/q = [a0; a1, a2] === *)
Print["=== 3-term CF rationals: correction structure ==="];
(* [3; 7, 1] = 22+3/7+1 = 25/8... no. *)
(* [a0; a1, a2] = a0 + 1/(a1 + 1/a2) = (a0*a1*a2 + a0 + a2)/(a1*a2 + 1) *)
Do[
  p = a0 a1 a2 + a0 + a2;
  q = a1 a2 + 1;
  If[GCD[p, q] != 1, Continue[]];
  (* Inner convergents: p0/q0 = a0/1, p1/q1 = (a0*a1+1)/a1 *)
  p0 = a0; q0 = 1;
  p1 = a0 a1 + 1; q1Inner = a1;
  corr = pathsRational[p, q, q1Inner + 1] - vLinear[p, a0, q1Inner + 1];
  bExpected = -Ballot[p0 + p1, q0 + q1Inner];
  Print["[", a0, ";", a1, ",", a2, "] = ", p, "/", q,
    " q1=", q1Inner,
    " corr(j=", q1Inner + 1, ")=", corr,
    " -B(", p0 + p1, ",", q0 + q1Inner, ")=", bExpected,
    If[corr === bExpected, " MATCH", " DIFFER"]],
  {a0, {2, 3}}, {a1, {3, 5, 7}}, {a2, {1, 2, 3}}];
