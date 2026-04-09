(* Test if v_j = (p - w*j)/p * C(p+j-1, j) holds universally *)
(* at ALL semi-convergent positions, and find where it breaks *)

Needs["Orbit`"];

Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]
Ballot[n_, k_] := If[k == 0, 1, Binomial[n + k - 1, k]/n]

(* Compute state vectors via transfer matrices *)
stateVectors[alpha_, xMax_] := Module[
  {v = {1}, m = 0, prevS = 0, curS, results = <||>},
  results[1] = {0, {1}};
  Do[curS = Floor[x/alpha];
    If[curS == prevS, v = Lmat[m] . v,
      v = Lmat[m + 1] . Append[v, 0]; m++];
    prevS = curS; results[x] = {m, v}, {x, 2, xMax}];
  results
]

(* Candidate formula *)
vFormula[p_, w_, j_] := (p - w j)/p Binomial[p + j - 1, j]

(* === Test for Pi = [3; 7, 15, 1, 292, ...] === *)
Print["============================================"];
Print["  Alpha = Pi, w = 3, q1 = 7"];
Print["============================================"];
data = stateVectors[Pi, 200];

(* All semi-convergent numerators for Pi up to 200: *)
(* Level 1: {3,4,7,10,13,16,19,22} *)
(* Level 2: {25,47,69,91,113,135,157,179} *)
semiConvPi = {3, 4, 7, 10, 13, 16, 19, 22, 25, 47, 69, 91, 113, 135, 157, 179};

Do[
  {m, v} = data[p];
  w = 3;
  maxJ = Length[v] - 1;
  lastOK = -1;
  firstBad = None;
  Do[
    actual = v[[j + 1]];
    predicted = vFormula[p, w, j];
    If[actual === predicted,
      lastOK = j,
      If[firstBad === None,
        firstBad = j;
        diff = actual - predicted]],
    {j, 0, maxJ}];
  Print["p=", p, " m=", m,
    " formula OK for j=0..", lastOK, "/", maxJ,
    If[firstBad =!= None,
      StringJoin[" | BREAKS at j=", ToString[firstBad],
        " (diff=", ToString[diff], ")"],
      " | ALL MATCH"]],
  {p, semiConvPi}];
Print[""];

(* === Detailed view of where formula breaks === *)
Print["=== Breakdown at j=8 for several level-2 positions ==="];
w = 3;
Do[
  {m, v} = data[p];
  If[Length[v] > 8,
    actual = v[[9]]; (* j=8, 1-indexed *)
    predicted = vFormula[p, w, 8];
    diff = actual - predicted;
    Print["p=", p, " j=8: actual=", actual, " formula=", predicted,
      " diff=", diff,
      " diff/B(25,8)=", diff/Ballot[25, 8] // Simplify]],
  {p, {47, 69, 91, 113, 135}}];
Print[""];

(* === Test for Sqrt[2] = [1; 2, 2, 2, ...] === *)
Print["============================================"];
Print["  Alpha = Sqrt[2], w = 1, q1 = 2"];
Print["============================================"];
data2 = stateVectors[Sqrt[2], 100];

(* Convergents of Sqrt[2]: 1/1, 3/2, 7/5, 17/12, 41/29, 99/70 *)
(* Semi-conv between 1 and 3: {2} *)
(* Semi-conv between 3 and 7: {4, 5} semi? Actually CF [1;2,2,...] *)
(* p0=1,q0=1; p1=3,q1=2; semi-conv between: (1+j*1)/(1+j*0)=1+j... no *)
(* Actually: between p0/q0=1/1 and p1/q1=3/2, semi-conv = (p_{-1}+j*p_0)/(q_{-1}+j*q_0) *)
(* p_{-1}=1, q_{-1}=0, so semi-conv = (1+j)/(j) which makes sense for j=1: 2/1 *)
(* So semi-conv numerator is 2, then p1=3. *)
(* Between p1=3 and p2=7: semi-conv = (p0+j*p1)/(q0+j*q1) = (1+3j)/(1+2j) *)
(* j=1: 4/3 *)
(* p2=7 *)
(* Between p2=7 and p3=17: semi-conv = (p1+j*p2)/(q1+j*q2) = (3+7j)/(2+5j) *)
(* j=1: 10/7 *)
(* p3=17 *)

semiConvSqrt2 = {1, 2, 3, 4, 7, 10, 17, 24, 41, 58, 99};
Do[
  If[KeyExistsQ[data2, p],
    {m, v} = data2[p];
    w = 1;
    maxJ = Length[v] - 1;
    lastOK = -1;
    firstBad = None;
    Do[
      actual = v[[j + 1]];
      predicted = vFormula[p, w, j];
      If[actual === predicted, lastOK = j,
        If[firstBad === None, firstBad = j; diff = actual - predicted]],
      {j, 0, maxJ}];
    Print["p=", p, " m=", m,
      " formula OK for j=0..", lastOK, "/", maxJ,
      If[firstBad =!= None,
        StringJoin[" | BREAKS at j=", ToString[firstBad],
          " (diff=", ToString[diff], ")"], " | ALL MATCH"]],
    Print["p=", p, " -- beyond range"]],
  {p, semiConvSqrt2}];
Print[""];

(* === Test for Sqrt[5] = [2; 4, 4, 4, ...] === *)
Print["============================================"];
Print["  Alpha = Sqrt[5], w = 2, q1 = 4"];
Print["============================================"];
data5 = stateVectors[Sqrt[5], 200];

(* CF of Sqrt[5] = [2; 4, 4, 4, ...] *)
(* p0=2, q0=1; p1=9, q1=4; p2=38, q2=17 *)
(* Level 1 semi-conv: 3,5,7 then p1=9 *)
(* Level 2 semi-conv: (2+9j)/(1+4j) for j=1,2,3: 11/5, 20/9, 29/13; then p2=38 *)
semiConvSqrt5 = {2, 3, 5, 7, 9, 11, 20, 29, 38, 47, 56, 65, 74, 83};
Do[
  If[KeyExistsQ[data5, p],
    {m, v} = data5[p];
    w = 2;
    maxJ = Length[v] - 1;
    lastOK = -1;
    firstBad = None;
    Do[
      actual = v[[j + 1]];
      predicted = vFormula[p, w, j];
      If[actual === predicted, lastOK = j,
        If[firstBad === None, firstBad = j; diff = actual - predicted]],
      {j, 0, maxJ}];
    Print["p=", p, " m=", m,
      " formula OK for j=0..", lastOK, "/", maxJ,
      If[firstBad =!= None,
        StringJoin[" | BREAKS at j=", ToString[firstBad],
          " (diff=", ToString[diff], ")"], " | ALL MATCH"]],
    Print["p=", p, " -- beyond range"]],
  {p, semiConvSqrt5}];
Print[""];

(* === Test for GoldenRatio = [1; 1, 1, 1, ...] === *)
Print["============================================"];
Print["  Alpha = GoldenRatio, w = 1, q1 = 1"];
Print["============================================"];
dataGR = stateVectors[GoldenRatio, 100];

(* All convergent numerators are Fibonacci: 1,2,3,5,8,13,21,34,55,89 *)
(* No semi-convergents (all a_k = 1) *)
semiConvGR = {1, 2, 3, 5, 8, 13, 21, 34, 55, 89};
Do[
  If[KeyExistsQ[dataGR, p],
    {m, v} = dataGR[p];
    w = 1;
    maxJ = Length[v] - 1;
    lastOK = -1;
    firstBad = None;
    Do[
      actual = v[[j + 1]];
      predicted = vFormula[p, w, j];
      If[actual === predicted, lastOK = j,
        If[firstBad === None, firstBad = j; diff = actual - predicted]],
      {j, 0, maxJ}];
    Print["p=", p, " m=", m,
      " formula OK for j=0..", lastOK, "/", maxJ,
      If[firstBad =!= None,
        StringJoin[" | BREAKS at j=", ToString[firstBad],
          " (diff=", ToString[diff], ")"], " | ALL MATCH"]],
    Print["p=", p, " -- beyond range"]],
  {p, semiConvGR}];
Print[""];

(* === Key question: does the formula always work for j <= q1? === *)
Print["=== SUMMARY: Formula range vs q1 ==="];
Print["Pi (w=3, q1=7): breaks at j=8 for level-2 positions"];
Print["Sqrt[2] (w=1, q1=2): check output above"];
Print["Sqrt[5] (w=2, q1=4): check output above"];
Print["GoldenRatio (w=1, q1=1): all a_k=1, no level-2"];
