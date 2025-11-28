(* Analyze denominator differences for varying starting index i *)

Print["==============================================================="]
Print["  UNIT FRACTION FORMULA: STARTING INDEX PATTERNS"]
Print["==============================================================="]
Print[""]

(* Formula: f[n, startI] = -1/(1 - Sum[Product[n^2-j^2, {j,1,i}]/(2i+1), {i, startI, Infinity}]) *)

f[n_, startI_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, startI, Infinity}])

Print["1. DENOMINATORS FOR DIFFERENT STARTING i"]
Print["==============================================================="]
Print[""]

Do[
  Print["n = ", n, ":"];
  prevDen = None;
  Do[
    r = f[n, startI];
    den = Denominator[r];
    num = Numerator[r];
    diff = If[prevDen === None, "---", prevDen - den];
    Print["  i>=", startI, ": ", num, "/", den, "   diff from prev: ", diff];
    prevDen = den,
    {startI, 0, n}
  ];
  Print[""],
  {n, {3, 5, 7, 11}}
]

Print["2. PATTERN IN DIFFERENCES"]
Print["==============================================================="]
Print[""]

(* Let's focus on the differences and factor them *)
Do[
  Print["n = ", n, ":"];
  diffs = {};
  prevDen = Denominator[f[n, 0]];
  Do[
    den = Denominator[f[n, startI]];
    diff = prevDen - den;
    AppendTo[diffs, diff];
    Print["  d[", startI-1, "] - d[", startI, "] = ", diff, " = ", FactorInteger[diff]];
    prevDen = den,
    {startI, 1, n}
  ];
  Print[""],
  {n, {3, 5, 7}}
]

Print["3. WHAT IS THE i-th TERM?"]
Print["==============================================================="]
Print[""]

(* The difference d[i-1] - d[i] should equal the i-th term of the sum times common denom *)
(* T[i] = Product[n^2-j^2, {j,1,i}] / (2i+1) *)

T[n_, i_] := Product[n^2 - j^2, {j, 1, i}]/(2 i + 1)

Do[
  Print["n = ", n, ":"];
  Do[
    ti = T[n, i];
    Print["  T[", i, "] = ", ti, " = ", Numerator[ti], "/", Denominator[ti]];,
    {i, 0, 5}
  ];
  Print[""],
  {n, {3, 5}}
]

Print["4. RELATIONSHIP BETWEEN CONSECUTIVE DIFFERENCES"]
Print["==============================================================="]
Print[""]

(* Hypothesis: d[k] - d[k+1] = T[k] * (common denominator structure) *)
(* Let's check if differences have a multiplicative pattern *)

Do[
  Print["n = ", n, ":"];
  diffs = Table[
    Denominator[f[n, startI - 1]] - Denominator[f[n, startI]],
    {startI, 1, n - 1}
  ];
  ratios = Table[diffs[[k + 1]]/diffs[[k]], {k, 1, Length[diffs] - 1}];
  Print["  Differences: ", diffs];
  Print["  Ratios d[k+1]/d[k]: ", ratios];
  
  (* Compare to n^2 - k^2 pattern *)
  expectedRatios = Table[(n^2 - (k+1)^2) * (2k + 1) / (2k + 3), {k, 1, Length[ratios]}];
  Print["  Expected (n^2-(k+1)^2)(2k+1)/(2k+3): ", expectedRatios];
  Print["  Match: ", ratios == expectedRatios];
  Print[""],
  {n, {5, 7}}
]

Print["5. CLOSED FORM FOR DIFFERENCES"]
Print["==============================================================="]
Print[""]

Print["The k-th difference (d[k-1] - d[k]) relates to T[k] = Product[n^2-j^2]//(2k+1)"]
Print[""]

(* Let's verify: d[k-1] - d[k] = ? *)
n = 5;
Print["For n = 5:"];
Do[
  dPrev = Denominator[f[n, k - 1]];
  dCurr = Denominator[f[n, k]];
  diff = dPrev - dCurr;
  tk = Product[n^2 - j^2, {j, 1, k}];  (* numerator of T[k] without the 2k+1 *)
  Print["  k=", k, ": diff=", diff, ", Prod[n^2-j^2]^k=", tk, ", diff/tk = ", diff/tk],
  {k, 1, 4}
]
Print[""]

Print["6. THE FIRST DIFFERENCE IS ALWAYS n^2"]
Print["==============================================================="]
Print[""]

Print["Verifying d[0] - d[1] = n^2:"];
Do[
  d0 = Denominator[f[n, 0]];
  d1 = Denominator[f[n, 1]];
  diff = d0 - d1;
  Print["  n=", n, ": d[0]-d[1] = ", diff, " = ", n, "^2 = ", n^2, " Match: ", diff == n^2],
  {n, {3, 5, 7, 11, 13}}
]
