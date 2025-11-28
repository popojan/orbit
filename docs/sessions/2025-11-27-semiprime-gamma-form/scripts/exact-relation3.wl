(* Exact relationship - ASCII only *)

f00[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 0, i}]/(2 i + 1), {i, 0, n}])
f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])
S10[n_] := Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}]

Print["EXACT RELATIONSHIP d00 vs d10"]
Print["=============================="]
Print[""]

Print["S10 = A/B, then:"]
Print["  f10 = B/(A-B)"]
Print["  f00 = B/(n^2*A - B)"]
Print["  den10 = A - B"]
Print["  den00 = n^2*A - B"]
Print[""]

Print["Difference: den00 - den10 = A*(n^2 - 1)"]
Print[""]

Print["Verification:"]
Do[
  s10 = S10[n];
  A = Numerator[s10];
  B = Denominator[s10];
  d00 = Denominator[f00[n]];
  d10 = Denominator[f10[n]];
  diff = d00 - d10;
  predicted = A * (n^2 - 1);
  Print["  n=", n, ": d00-d10=", diff, ", A*(n^2-1)=", predicted, ", match=", diff == predicted],
  {n, {3, 5, 7, 11, 13}}
]
Print[""]

Print["LINEAR COMBINATION -d00 + b*d10"]
Print["================================"]
Print[""]

Print["-d00 + b*d10 = -(n^2*A - B) + b*(A - B)"]
Print["            = A*(b - n^2) + B*(1 - b)"]
Print[""]

Print["Mod p (where p | n, so n^2 = 0 mod p):"]
Print["  A*b + B*(1-b) mod p"]
Print[""]

testCases = {{15, 3, 5}, {21, 3, 7}, {35, 5, 7}, {77, 7, 11}, {143, 11, 13}};

Print["Values of A, B mod factors:"]
Do[
  {n, p, q} = tc;
  s10 = S10[n];
  A = Numerator[s10];
  B = Denominator[s10];
  Print["n=", n, " (", p, "*", q, "):"];
  Print["  A mod p=", Mod[A, p], ", B mod p=", Mod[B, p]];
  Print["  A mod q=", Mod[A, q], ", B mod q=", Mod[B, q]];
  
  (* For b=-1: A*(-1) + B*2 = -A + 2B *)
  For[b = -3, b <= 3, b++,
    combo = A*b + B*(1 - b);
    gP = Mod[combo, p];
    gQ = Mod[combo, q];
    If[gP == 0 || gQ == 0,
      Print["  b=", b, ": combo mod p=", gP, ", mod q=", gQ, If[gP == 0, " <- p!", ""], If[gQ == 0, " <- q!", ""]]
    ]
  ];
  Print[""],
  {tc, testCases}
]

Print["KEY INSIGHT"]
Print["==========="]
Print[""]
Print["For factor p, need: A*b + B*(1-b) = 0 (mod p)"]
Print["  => A*b = B*(b-1) (mod p)"]
Print["  => b*(A - B) = -B (mod p)"]
Print["  => b = -B / (A - B) (mod p)"]
Print["  => b = -B / d10 (mod p)"]
Print[""]

Print["Computed optimal b:"]
Do[
  {n, p, q} = tc;
  s10 = S10[n];
  A = Numerator[s10];
  B = Denominator[s10];
  d10 = A - B;
  
  (* b = -B / d10 mod p *)
  If[GCD[d10, p] == 1,
    bOptP = Mod[-B * PowerMod[Mod[d10, p], -1, p], p];
    If[bOptP > p/2, bOptP = bOptP - p];
    Print["n=", n, ": b for factor ", p, " = ", bOptP],
    Print["n=", n, ": p divides d10, any b works for ", p]
  ];
  
  If[GCD[d10, q] == 1,
    bOptQ = Mod[-B * PowerMod[Mod[d10, q], -1, q], q];
    If[bOptQ > q/2, bOptQ = bOptQ - q];
    Print["n=", n, ": b for factor ", q, " = ", bOptQ],
    Print["n=", n, ": q divides d10, any b works for ", q]
  ],
  {tc, testCases}
]
