(* CF of algebraic C(k) = smallest positive root of (1-x)^{k+1} = 1-2x
   For integer slopes k = 2..10, C(k) is algebraic of degree k.
   What do their CFs look like? *)

Print["=== CF OF ALGEBRAIC C(k) ===\n"];

Do[
  (* Solve (1-x)^{k+1} = 1-2x *)
  roots = x /. Solve[(1 - x)^(kk + 1) == 1 - 2 x && 0 < x < 1/2, x];

  If[Length[roots] == 0,
    Print["k = ", kk, ": no root in (0, 1/2)"];
    Continue[]
  ];

  ck = Min[roots];
  ckN = N[ck, 200];

  (* Minimal polynomial *)
  minPoly = MinimalPolynomial[ck, x];

  (* CF - compute many terms *)
  cf = ContinuedFraction[ckN, 80];

  Print["k = ", kk];
  Print["  C(", kk, ") = ", InputForm[ck]];
  Print["  MinPoly = ", minPoly];
  Print["  Degree  = ", Exponent[minPoly, x]];
  Print["  Numeric = ", NumberForm[ckN, 30]];
  Print["  CF[1..40] = ", cf[[1 ;; Min[40, Length[cf]]]]];

  (* Check for periodicity *)
  cfTail = cf[[2 ;;]]; (* remove integer part, which is 0 *)
  Do[
    If[p <= Length[cfTail]/2,
      chunk1 = cfTail[[1 ;; p]];
      chunk2 = cfTail[[p + 1 ;; 2 p]];
      If[chunk1 === chunk2,
        Print["  PERIODIC with period ", p, ": ", chunk1];
        Break[]
      ];
    ];,
    {p, 1, Min[35, Floor[Length[cfTail]/2]]}
  ];
  Print[];,

  {kk, 2, 10}
];

(* Special attention to k=2: C(2) = (3-sqrt(5))/2 = 1/phi^2 *)
Print["=== SPECIAL: k=2 ==="];
Print["C(2) = (3-sqrt(5))/2 = 1/phi^2"];
Print["CF of 1/phi^2: ", ContinuedFraction[N[(3 - Sqrt[5])/2, 100], 40]];
Print["CF of phi: ", ContinuedFraction[N[GoldenRatio, 100], 40]];
Print["CF of 1/phi: ", ContinuedFraction[N[1/GoldenRatio, 100], 40]];
