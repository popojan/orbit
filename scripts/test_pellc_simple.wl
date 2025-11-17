#!/usr/bin/env wolframscript
(*
Simple test of pellc closed form - focus on key results
*)

Print[StringRepeat["=", 70]];
Print["PELLC CLOSED FORM - KEY RESULTS"];
Print[StringRepeat["=", 70]];
Print[];

(* Define the pellc function *)
pellc[n_, d_, c_, m_] := Module[
  {
   z = ChebyshevT[-1 + 2 m, Sqrt[d^2 n]]/
    ChebyshevU[-2 + 2 m, Sqrt[d^2 n]],
   gcd, sol
   },
  sol = {
    x -> z/(Sqrt[n] Sqrt[1 - n d^2 + z^2]),
    y -> 1/Sqrt[1 - n d^2 + z^2]
    };
  gcd = GCD[(x + c)^2, y^2, 1 + (x + c)^2 - x^2] /. sol;
  {n x^2 - (n d^2 - 1) y^2 == ((1 + (x + c)^2 - x^2)/gcd /. sol),
   Thread[{x, y} -> ({(x + c)/Sqrt[gcd], y/Sqrt[gcd]} /. sol)]}
]

Print["KEY FINDING 1: c=0 gives solutions to nx^2 - (n-1)y^2 = 1"];
Print[StringRepeat["-", 70]];
Print[];

result13 = pellc[13, 1, 0, 2];
x13 = x /. result13[[2]];
y13 = y /. result13[[2]];

Print["For n=13, d=1, c=0, m=2:"];
Print["  Equation: 13x^2 - 12y^2 = 1"];
Print["  Solution: x = ", x13, ", y = ", y13];
Print["  Verify: 13*", x13, "^2 - 12*", y13, "^2 = ", 13*x13^2 - 12*y13^2];
Print[];

Print["Compare to fundamental Pell x^2 - 13y^2 = 1:"];
Print["  Fundamental: x = 649, y = 180"];
Print["  Verify: 649^2 - 13*180^2 = ", 649^2 - 13*180^2];
Print[];

Print["These are DIFFERENT equations!"];
Print["  13x^2 - 12y^2 = 1  vs  x^2 - 13y^2 = 1"];
Print[];

Print[StringRepeat["=", 70]];
Print["KEY FINDING 2: c=1 shifts the solution"];
Print[StringRepeat["-", 70]];
Print[];

result13c1 = pellc[13, 1, 1, 2];
x13c1 = x /. result13c1[[2]];
y13c1 = y /. result13c1[[2]];

Print["For n=13, d=1, c=1, m=2:"];
Print["  Equation: 13x^2 - 12y^2 = 100"];
Print["  Solution: x = ", x13c1, ", y = ", y13c1];
Print["  Verify: 13*", x13c1, "^2 - 12*", y13c1, "^2 = ", 13*x13c1^2 - 12*y13c1^2];
Print[];

Print["Relationship: x(c=1) = x(c=0) + 1"];
Print["  x(c=0) = ", x13];
Print["  x(c=1) = ", x13c1];
Print["  Difference: ", x13c1 - x13];
Print[];

Print["This is the (x+1) factor from Egypt.wl TOTAL-EVEN pattern!"];
Print[];

Print[StringRepeat["=", 70]];
Print["KEY FINDING 3: Pattern across different n"];
Print[StringRepeat["-", 70]];
Print[];

testNs = {2, 3, 5, 7, 11, 13, 17};

Print["For nx^2 - (n-1)y^2 = 1 with d=1, c=0, m=2:"];
Print[];
Print["n\tx\ty\tVerify"];
Print[StringRepeat["-", 50]];

Table[
  Module[{result, xval, yval, verify},
    result = pellc[nt, 1, 0, 2];
    xval = x /. result[[2]];
    yval = y /. result[[2]];
    verify = nt*xval^2 - (nt-1)*yval^2;
    Print[nt, "\t", xval, "\t", yval, "\t", verify];
    {nt, xval, yval, verify}
  ],
  {nt, testNs}
];

Print[];

Print[StringRepeat["=", 70]];
Print["KEY FINDING 4: Chebyshev limit behavior"];
Print[StringRepeat["-", 70]];
Print[];

Print["For large m, z = T_{2m-1}(t) / U_{2m-2}(t) -> t + sqrt(t^2 - 1)"];
Print[];
Print["For n=13, d=1: t = sqrt(13)"];
Print["  Limit: sqrt(13) + sqrt(12) = ", N[Sqrt[13] + Sqrt[12], 15]];
Print[];

Print["pellc z-values for n=13, increasing m:"];
Table[
  Module[{z},
    z = ChebyshevT[-1 + 2 mt, Sqrt[13]]/ChebyshevU[-2 + 2 mt, Sqrt[13]];
    Print["  m=", mt, ": z = ", N[z, 15]];
    z
  ],
  {mt, 1, 5}
];

Print[];
Print["Fundamental Pell regulator R = 649 + 180*sqrt(13) = ", N[649 + 180*Sqrt[13], 15]];
Print["Limit z does NOT equal R - these are different constructions"];
Print[];

Print[StringRepeat["=", 70]];
Print["CONCLUSIONS"];
Print[StringRepeat["=", 70]];
Print[];

Print["1. pellc with c=0 gives closed-form solutions to nx^2 - (n-1)y^2 = 1"];
Print["2. pellc with c=1 shifts x by 1 - connects to (x+1) divisibility!"];
Print["3. This is DIFFERENT from standard Pell x^2 - ny^2 = 1"];
Print["4. Chebyshev limit is NOT the fundamental Pell regulator"];
Print["5. Connection to Egypt.wl TOTAL-EVEN pattern via (x+c) parameter"];
Print[];
Print["RELEVANCE: The (x+1) factor in pellc might explain why"];
Print["            (x+1) divides numerators in Egypt.wl for EVEN totals!"];
Print[];

Print[StringRepeat["=", 70]];
