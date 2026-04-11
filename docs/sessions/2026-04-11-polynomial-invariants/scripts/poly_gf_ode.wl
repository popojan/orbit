<< Orbit`

(* Find holonomic recurrence for a(n) = BeattyBallotCount[2/3, {n,n}] *)

nMax = 200;
a = Table[BeattyBallotCount[2/3, {n, n}], {n, 1, nMax}];
(* a[[n]] = count for (n,n), indexed from 1 *)

Print["First 12 terms: ", a[[1 ;; 12]]];
Print[""];

(* Holonomic recurrence: Sum_{i=0}^{ord} p_i(n) * a(n+i) = 0 *)
(* where p_i(n) = Sum_{j=0}^{deg} c[i,j] * n^j *)

Print["=== Searching for holonomic recurrence ==="];
found = False;
Do[
  nUnk = (ord + 1)(deg + 1);
  nEqs = nMax - ord;
  If[nUnk >= nEqs, Continue[]];

  (* Build matrix: row n gives the equation for shift n *)
  (* Use n = 1, 2, ..., nEqs *)
  mat = Table[
    Flatten@Table[n^j * a[[n + i]], {i, 0, ord}, {j, 0, deg}],
    {n, 1, nEqs}
  ];

  ns = NullSpace[mat];
  If[Length[ns] > 0,
    cvec = ns[[1]];

    (* Verify: check a few values *)
    ok = True;
    Do[
      val = Sum[cvec[[(deg + 1) i + j + 1]] n^j a[[n + i]], {i, 0, ord}, {j, 0, deg}];
      If[val != 0, ok = False; Break[]];,
      {n, 1, nEqs}
    ];

    If[ok,
      Print["*** ord=", ord, " deg=", deg, ": RECURRENCE FOUND (dim ", Length[ns], ") ***"];

      (* Print the recurrence *)
      Do[
        cv = ns[[idx]];
        terms = {};
        Do[
          coeff = Sum[cv[[(deg + 1) i + j + 1]] nn^j, {j, 0, deg}];
          coeff = Expand[coeff];
          If[coeff =!= 0,
            AppendTo[terms, ToString[coeff] <> " * a(n+" <> ToString[i] <> ")"];
          ];,
          {i, 0, ord}
        ];
        Print["  Recurrence ", idx, ": ", StringRiffle[terms, " + "], " = 0"];,
        {idx, 1, Min[Length[ns], 3]}
      ];
      Print[""];
      found = True;
      Break[];
    ];
  ];,
  {ord, 1, 8}, {deg, 0, 6}
];

If[!found, Print["No recurrence found up to ord=8, deg=6"]];

(* Also test for integer slope k=2 as control *)
Print["=== Control: slope 2 (known algebraic) ==="];
a2 = Table[BeattyBallotCount[1/2, {n, n}], {n, 1, nMax}];
Do[
  nUnk = (ord + 1)(deg + 1);
  nEqs = nMax - ord;
  If[nUnk >= nEqs, Continue[]];
  mat = Table[
    Flatten@Table[n^j * a2[[n + i]], {i, 0, ord}, {j, 0, deg}],
    {n, 1, nEqs}
  ];
  ns = NullSpace[mat];
  If[Length[ns] > 0,
    ok = AllTrue[
      Table[Sum[ns[[1, (deg+1)i+j+1]] n^j a2[[n+i]], {i,0,ord}, {j,0,deg}], {n, 1, nEqs}],
      # == 0 &
    ];
    If[ok,
      Print["k=2: ord=", ord, " deg=", deg];
      cv = ns[[1]];
      terms = {};
      Do[
        coeff = Expand[Sum[cv[[(deg+1)i+j+1]] nn^j, {j, 0, deg}]];
        If[coeff =!= 0, AppendTo[terms, ToString[coeff] <> " * a(n+" <> ToString[i] <> ")"]];,
        {i, 0, ord}
      ];
      Print["  ", StringRiffle[terms, " + "], " = 0"];
      Break[];
    ];
  ];,
  {ord, 1, 4}, {deg, 0, 4}
];
