<< Orbit`

(* Result 2 formula: v_j(n) = (n - w*j)/n * Binomial[n+j-1, j] *)
vLin[n_, w_, j_] := (n - w j)/n Binomial[n + j - 1, j]

(* For Pi: w=3, q1=7, p1=22, p2=333 *)
w = 3; q1 = 7; p1 = 22; p2 = 333;

(* The user's polynomial: interpolating the row at height q1, positions p1..p2 *)
row = BeattyBallotCount[Pi, All, {p2, q1}];
data = Drop[row, p1 - 1];  (* positions p1 through p2 *)

Print["Length of data: ", Length[data]];
Print["First few values: ", Take[data, 5]];
Print[""];

(* Check: does vLin match every single data point? *)
predicted = Table[vLin[n, w, q1], {n, p1, p2}];
Print["Result 2 matches ALL ", p2 - p1 + 1, " points: ", data === predicted];
Print[""];

(* The closed form as polynomial in shifted variable x = n - p1 + 1 *)
(* v_q1(n) = (n - w*q1)/n * Binomial[n+q1-1, q1] *)
(* With n = x + p1 - 1 = x + 21: *)
(* v_7(x+21) = x/(x+21) * Binomial[x+27, 7] *)
(* = x * (x+27)(x+26)(x+25)(x+24)(x+23)(x+22) / 7! *)

poly = x Product[x + p1 + i, {i, 0, q1 - 2}] / q1!;
Print["Closed-form polynomial:"];
Print["  ", Expand[poly]];
Print[""];

(* Verify the polynomial matches data *)
polyVals = Table[poly /. x -> k, {k, 1, Length[data]}];
Print["Polynomial matches all data: ", polyVals === data];
Print[""];

(* Now look at the Newton form coefficients *)
interp = InterpolatingPolynomial[Take[data, q1 + 1], x];
Print["Newton form (from first ", q1 + 1, " points):"];
Print["  ", interp];
Print[""];

(* Identify the coefficients *)
Print["=== Coefficient analysis ==="];
Print["Constant = v_7(22) = ", vLin[22, 3, 7]];
Print["  = Ballot(22, 7) = Binomial[28,7]/22 = ", Binomial[28, 7]/22];
Print["Leading coeff = 1/7! = ", 1/Factorial[7]];
Print[""];

(* The roots of the polynomial *)
Print["=== Roots of poly (in shifted x) ==="];
roots = x /. Solve[poly == 0, x];
Print["  ", roots];
Print["  i.e. positions n = ", roots + p1 - 1];
Print[""];

(* Check: is this special to Pi? Try Sqrt[5] *)
Print["=== Same test for Sqrt[5], k=3 ==="];
alpha2 = Sqrt[5];
convs2 = Convergents[alpha2, 3];
Print["Convergents: ", convs2];
{a2, b2} = Take[convs2, -2];
w2 = Floor[alpha2]; q12 = Denominator[a2]; p12 = Numerator[a2]; p22 = Numerator[b2];
Print["w=", w2, " q1=", q12, " p1=", p12, " p2=", p22];

row2 = BeattyBallotCount[alpha2, All, {p22, q12}];
data2 = Drop[row2, p12 - 1];
predicted2 = Table[vLin[n, w2, q12], {n, p12, p22}];
Print["Result 2 matches all points: ", data2 === predicted2];

poly2 = x Product[x + p12 + i, {i, 0, q12 - 2}] / q12!;
polyVals2 = Table[poly2 /. x -> k, {k, 1, Length[data2]}];
Print["Polynomial matches all data: ", polyVals2 === data2];
Print[""];

(* And for Sqrt[2], k=3 *)
Print["=== Same test for Sqrt[2], k=3 ==="];
alpha3 = Sqrt[2];
convs3 = Convergents[alpha3, 3];
Print["Convergents: ", convs3];
{a3, b3} = Take[convs3, -2];
w3 = Floor[alpha3]; q13 = Denominator[a3]; p13 = Numerator[a3]; p23 = Numerator[b3];
Print["w=", w3, " q1=", q13, " p1=", p13, " p2=", p23];

row3 = BeattyBallotCount[alpha3, All, {p23, q13}];
data3 = Drop[row3, p13 - 1];
predicted3 = Table[vLin[n, w3, q13], {n, p13, p23}];
Print["Result 2 matches all points: ", data3 === predicted3];

poly3 = x Product[x + p13 + i, {i, 0, q13 - 2}] / q13!;
polyVals3 = Table[poly3 /. x -> k, {k, 1, Length[data3]}];
Print["Polynomial matches all data: ", polyVals3 === data3];
