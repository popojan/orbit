(* Experiment: f_{k+1} = α·f_k - f_{k-1}, where f_k ∈ Mat_2(F_p)   *)
(* α ∈ Mat_2(F_p), initial conditions f_0, f_1 ∈ Mat_2(F_p)        *)
(* The 2×2 is the RING — the recurrence structure is still two-term. *)

p = 7;

(* --- Helper: iterate, find period --- *)
(* Period T: smallest T>0 with (f_T, f_{T+1}) = (f_0, f_1)         *)
findPeriod[alpha_, f0_, f1_, p_, maxK_: 5000] := Catch[Module[
  {prev = f0, curr = f1, next},
  Do[
    next = Mod[alpha . curr - prev, p];
    If[curr === f0 && next === f1, Throw[k]];
    prev = curr; curr = next,
    {k, 1, maxK}
  ];
  Throw[None]
]]

orbitList[alpha_, f0_, f1_, p_, n_] := Module[
  {prev = f0, curr = f1, next, out = {f0, f1}},
  Do[
    next = Mod[alpha . curr - prev, p];
    AppendTo[out, next];
    prev = curr; curr = next,
    {n - 1}
  ];
  out
]

Print["=== Recurrence f_{k+1} = α·f_k - f_{k-1} over Mat_2(F_", p, ") ===\n"];

(* ============================================================ *)
(* PART 1: Chebyshev initial conditions f_0 = I, f_1 = α       *)
(* All f_k = U_k(α/2) are polynomials in α → COMMUTE           *)
(* ============================================================ *)
Print["========== PART 1: f_0 = I, f_1 = α (Chebyshev) ==========\n"];

(* Case 1: α = 2I — naturals on diagonal *)
Print["--- Case 1: α = 2I ---"];
a1 = 2 IdentityMatrix[2];
per1 = findPeriod[a1, IdentityMatrix[2], a1, p];
orb1 = orbitList[a1, IdentityMatrix[2], a1, p, 10];
Print["Period: ", per1];
Print["f_k diag: ", Table[orb1[[k, 1, 1]], {k, 1, 9}]];

(* Case 2: α diagonal, distinct eigenvalues *)
Print["\n--- Case 2: α = Diag(2, 3) ---"];
a2 = DiagonalMatrix[{2, 3}];
per2 = findPeriod[a2, IdentityMatrix[2], a2, p];
orb2 = orbitList[a2, IdentityMatrix[2], a2, p, 60];
Print["Period: ", per2];
Print["(1,1): ", Table[orb2[[k, 1, 1]], {k, 1, Min[20, Length[orb2]]}]];
Print["(2,2): ", Table[orb2[[k, 2, 2]], {k, 1, Min[20, Length[orb2]]}]];

(* Case 3: generic non-diagonal α *)
Print["\n--- Case 3: α = {{3,1},{2,5}} ---"];
a3 = {{3, 1}, {2, 5}};
per3 = findPeriod[a3, IdentityMatrix[2], a3, p];
orb3 = orbitList[a3, IdentityMatrix[2], a3, p, 12];
Print["Period: ", per3];
Do[Print["  f[", k - 1, "] = ", orb3[[k]]], {k, 1, Min[10, Length[orb3]]}];

(* Commutativity check: do f_k commute with each other? *)
Print["\n--- Commutativity of orbit elements (Case 3) ---"];
Print["f_k are polynomials in α, so they SHOULD commute:"];
Do[
  comm = Mod[orb3[[i]] . orb3[[j]] - orb3[[j]] . orb3[[i]], p];
  If[comm =!= {{0, 0}, {0, 0}}, Print["  [f_", i-1, ", f_", j-1, "] ≠ 0: ", comm]],
  {i, 1, 6}, {j, i + 1, 6}
];
Print["All commutators zero: ",
  And @@ Flatten[Table[
    Mod[orb3[[i]] . orb3[[j]] - orb3[[j]] . orb3[[i]], p] === {{0,0},{0,0}},
    {i, 1, 6}, {j, i+1, 6}]]
];

(* Cassini invariant *)
Print["\n--- Cassini: f_k² - f_{k-1}·f_{k+1} (Case 3) ---"];
Do[
  c = Mod[orb3[[k]] . orb3[[k]] - orb3[[k - 1]] . orb3[[k + 1]], p];
  Print["  k=", k - 1, ": ", c],
  {k, 2, Min[8, Length[orb3] - 1]}
];

(* ============================================================ *)
(* PART 2: NON-Chebyshev initial conditions                     *)
(* f_0 and f_1 NOT polynomials in α → may NOT commute           *)
(* THIS is where genuine non-commutativity appears               *)
(* ============================================================ *)
Print["\n\n========== PART 2: f_0, f_1 independent of α ==========\n"];

a3 = {{3, 1}, {2, 5}};
f0nc = {{1, 2}, {0, 1}};  (* not a polynomial in α *)
f1nc = {{0, 1}, {3, 2}};  (* not a polynomial in α *)

Print["--- α = {{3,1},{2,5}}, f_0 = {{1,2},{0,1}}, f_1 = {{0,1},{3,2}} ---"];
per3nc = findPeriod[a3, f0nc, f1nc, p];
orb3nc = orbitList[a3, f0nc, f1nc, p, 12];
Print["Period: ", per3nc];
Do[Print["  f[", k - 1, "] = ", orb3nc[[k]]], {k, 1, Min[10, Length[orb3nc]]}];

(* Commutativity check *)
Print["\n--- Commutativity of orbit elements (non-Chebyshev) ---"];
noncommCount = 0;
Do[
  comm = Mod[orb3nc[[i]] . orb3nc[[j]] - orb3nc[[j]] . orb3nc[[i]], p];
  If[comm =!= {{0, 0}, {0, 0}},
    noncommCount++;
    If[noncommCount <= 5, Print["  [f_", i-1, ", f_", j-1, "] = ", comm]]
  ],
  {i, 1, 8}, {j, i + 1, 8}
];
Print["Non-commuting pairs: ", noncommCount, " out of ", Binomial[8, 2]];

(* Cassini — will it still be constant? *)
Print["\n--- Cassini: f_k² - f_{k-1}·f_{k+1} (non-Chebyshev) ---"];
Do[
  c = Mod[orb3nc[[k]] . orb3nc[[k]] - orb3nc[[k - 1]] . orb3nc[[k + 1]], p];
  Print["  k=", k - 1, ": ", c],
  {k, 2, Min[8, Length[orb3nc] - 1]}
];

Print["\n--- Reversed: f_k² - f_{k+1}·f_{k-1} (non-Chebyshev) ---"];
Do[
  c = Mod[orb3nc[[k]] . orb3nc[[k]] - orb3nc[[k + 1]] . orb3nc[[k - 1]], p];
  Print["  k=", k - 1, ": ", c],
  {k, 2, Min[8, Length[orb3nc] - 1]}
];

(* ============================================================ *)
(* PART 3: 4×4 viewpoint                                        *)
(* ============================================================ *)
Print["\n\n========== PART 3: 4×4 transfer matrix ==========\n"];

M4 = ArrayFlatten[{
  {a3, -IdentityMatrix[2]},
  {IdentityMatrix[2], 0 IdentityMatrix[2]}
}];
Print["M (4×4) ="];
Print[MatrixForm[M4]];
Print["det(M) mod ", p, " = ", Mod[Det[M4], p]];
cp = Factor[CharacteristicPolynomial[M4, x], Modulus -> p];
Print["CharPoly mod ", p, " = ", cp];

(* Factor the char poly: if α has eigenvalues μ_i, then M4 has *)
(* eigenvalues satisfying x² - μ_i x + 1 = 0 for each μ_i    *)
cpAlpha = Factor[CharacteristicPolynomial[a3, x], Modulus -> p];
Print["CharPoly of α mod ", p, " = ", cpAlpha];
Print["\nIf α has eigenvalue μ, then M has eigenvalues from x²-μx+1=0"];
Print["Predicted: CharPoly(M) = Resultant_μ(μ²-tr·μ+det, x²-μx+1)?"];
(* Check: compose *)
predicted = PolynomialMod[
  Resultant[x^2 - mu x + 1, mu^2 - Tr[a3] mu + Det[a3], mu], p];
Print["Resultant: ", Factor[predicted, Modulus -> p]];
Print["Match: ", Factor[predicted, Modulus -> p] === cp];
