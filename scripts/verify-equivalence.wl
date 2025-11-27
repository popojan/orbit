(* Verify equivalence of three forms for the semiprime formula *)

(* Form 1: Product of differences of squares *)
form1[n_, i_] := Product[n^2 - j^2, {j, 1, i}]

(* Form 2: Factorial form *)
form2[n_, i_] := (n + i)! / (n * (n - i - 1)!)

(* Form 3: Pochhammer form *)
form3[n_, i_] := (-1)^i * Pochhammer[1 - n, i] * Pochhammer[1 + n, i]

(* Test equivalence *)
Print["Testing equivalence for n = 15, 21, 35, 77, 143 (semiprimes)"]
Print[""]

Do[
  Print["n = ", n, ":"];
  Do[
    v1 = form1[n, i];
    v2 = form2[n, i];
    v3 = form3[n, i];
    ok = (v1 == v2 == v3);
    Print["  i=", i, ": ", v1, " | all equal: ", ok],
    {i, 1, 4}
  ];
  Print[""],
  {n, {15, 21, 35, 77, 143}}
]

(* One-liner version for quick check *)
Print["=== One-liner verification ==="]
Print[And @@ Flatten @ Table[
  Product[n^2 - j^2, {j, 1, i}] == (n+i)!/(n*(n-i-1)!) == (-1)^i * Pochhammer[1-n,i] * Pochhammer[1+n,i],
  {n, 10, 50}, {i, 1, Min[5, n-2]}
]]
