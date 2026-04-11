<< Orbit`

(* Guess the nature of F(z) = Sum a(n,n) z^n for slope 3/2 *)
(* Test: is F algebraic? Or only D-finite (holonomic)? *)

nMax = 150;
a = Join[{1}, Table[BeattyBallotCount[2/3, {n, n}], {n, 1, nMax}]];
(* a[[1]] = a(0) = 1, a[[n+1]] = a(n) for n >= 1 *)

Print["First 15 terms: ", a[[1 ;; 15]]];
Print[""];

(* === Test 1: Is F(z) algebraic? === *)
(* Find P(z, w) = Sum c_{i,j} z^i w^j such that P(z, F(z)) = 0 *)
(* This means: for each n, [z^n] P(z, F(z)) = 0 *)

(* Compute F^j coefficients via convolution *)
fPow[0] = Table[If[n == 0, 1, 0], {n, 0, nMax}];
fPow[1] = a;
fPow[j_] := fPow[j] = Table[Sum[fPow[j - 1][[k + 1]] a[[n - k + 1]], {k, 0, n}], {n, 0, nMax}];

Print["=== Algebraic equation test ==="];
Do[
  (* unknowns: c[i,j] for i=0..dz, j=0..dw *)
  nUnk = (dz + 1)(dw + 1);
  If[nUnk > nMax, Continue[]];

  (* equations: [z^n] Sum c[i,j] z^i F^j = 0 for n = 0..nUnk *)
  mat = Table[
    Flatten@Table[
      If[n - i >= 0, fPow[j][[n - i + 1]], 0],
      {j, 0, dw}, {i, 0, dz}
    ],
    {n, 0, nUnk}
  ];

  ns = NullSpace[mat];
  If[Length[ns] > 0,
    Print["dw=", dw, " dz=", dz, ": NullSpace dim = ", Length[ns]];
    (* verify on remaining coefficients *)
    cvec = ns[[1]];
    nVerify = Min[nMax, nUnk + 30];
    maxResid = Max@Table[
      Abs[Sum[
        cvec[[(dz + 1) j + i + 1]] If[n - i >= 0, fPow[j][[n - i + 1]], 0],
        {j, 0, dw}, {i, 0, dz}
      ]],
      {n, nUnk + 1, nVerify}
    ];
    Print["  Verification residual (n=", nUnk + 1, "..", nVerify, "): ", maxResid];
    If[maxResid == 0, Print["  *** ALGEBRAIC! ***"]];
  ];,
  {dw, 2, 6}, {dz, 1, 25}
];

Print["\n=== ODE test (D-finite) ==="];
(* Find ODE: Sum_{i=0}^r p_i(z) F^(i)(z) = 0 where p_i are polynomials *)
(* Equivalent: Sum_{i=0}^r Sum_{j=0}^d c[i,j] n^j (n-1)...(n-i+1) a[n] = 0 *)
(* Or use the recurrence form: Sum c[i,j] (n+j) a[n+i] = 0 *)

(* Holonomic recurrence: Sum_{i=0}^r p_i(n) a(n+i) = 0 *)
(* where p_i(n) is polynomial of degree d in n *)
Do[
  nUnk = (ord + 1)(deg + 1);
  If[nUnk + ord > nMax, Continue[]];

  mat = Table[
    Flatten@Table[
      n^j * a[[n + i + 1]],  (* a(n+i) * n^j *)
      {i, 0, ord}, {j, 0, deg}
    ],
    {n, 0, nUnk}
  ];

  ns = NullSpace[mat];
  If[Length[ns] > 0,
    (* verify *)
    cvec = ns[[1]];
    nVerify = Min[nMax - ord, nUnk + 20];
    maxResid = Max@Table[
      Abs[Sum[
        cvec[[(deg + 1) i + j + 1]] n^j a[[n + i + 1]],
        {i, 0, ord}, {j, 0, deg}
      ]],
      {n, nUnk + 1, nVerify}
    ];
    If[maxResid == 0,
      Print["ord=", ord, " deg=", deg, ": HOLONOMIC RECURRENCE FOUND"];
      (* Print the recurrence *)
      rec = Sum[
        cvec[[(deg + 1) i + j + 1]] Symbol["n"]^j Symbol["a"][Symbol["n"] + i],
        {i, 0, ord}, {j, 0, deg}
      ];
      Print["  ", rec, " = 0"];
      Break[];
    ];
  ];,
  {ord, 1, 6}, {deg, 1, 8}
];
