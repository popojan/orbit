#!/usr/bin/env wolframscript
(* ::Package:: *)

(* Explore and simplify the recursive primorial formulation *)

Print["=== RECURSIVE FORMULATION ANALYSIS ===\n"];

(* Original recursive formulation *)
RecurseState[{n_, a_, b_}] := {n + 1, b, b + (a - b)*(n + 1/(3 + 2*n))};

InitialState = {0, 0, 1};

PrimorialFromState[{n_, a_, b_}] := 2 * Denominator[-1 + b];

(* Iterate h times *)
IterateState[h_] := Nest[RecurseState, InitialState, h];

(* === PART 1: Verify it works === *)
Print["=== VERIFICATION ===\n"];

TestRecursive[m_] := Module[{h, state, result, expected},
  h = Floor[(m - 1)/2];
  state = IterateState[h];
  result = PrimorialFromState[state];
  expected = Times @@ Prime @ Range @ PrimePi[m];

  Print["m = ", m, ", h = ", h];
  Print["Final state: ", state];
  Print["Computed: ", result];
  Print["Expected: ", expected];
  Print["Match: ", If[result == expected, "✓ YES", "✗ NO"]];
  Print[""];
];

Do[TestRecursive[m], {m, {7, 11, 13, 17}}];

(* === PART 2: Symbolic iteration === *)
Print["=== SYMBOLIC ITERATION ===\n"];

Print["Starting from {n, a, b} = {0, 0, 1}:\n"];

(* Track first few iterations symbolically *)
SymbolicIterate[steps_] := Module[{state, history},
  state = InitialState;
  history = {state};

  Do[
    state = RecurseState[state];
    AppendTo[history, state],
    {i, steps}
  ];

  history
];

history = SymbolicIterate[8];

Print["n\ta\tb"];
Print[StringRepeat["-", 80]];
Do[
  Print[state[[1]], "\t", state[[2]], "\t", state[[3]]],
  {state, history}
];
Print["\n"];

(* === PART 3: Analyze the b sequence === *)
Print["=== ANALYZING THE b SEQUENCE ===\n"];

Print["The b values are the key - primorial = 2*Denominator[b-1]\n"];

bSequence = history[[All, 3]];

Print["b[0] = ", bSequence[[1]]];
Do[
  Print["b[", i-1, "] = ", bSequence[[i]],
    " = ", If[i <= 5, FullSimplify[bSequence[[i]]], "..."]]
  ,
  {i, 2, Min[8, Length[bSequence]]}
];
Print["\n"];

(* Try to find pattern *)
Print["Checking if b[n] has a closed form...\n"];

Do[
  Module[{b = bSequence[[i]], simplified},
    simplified = FullSimplify[b];
    If[i <= 5,
      Print["b[", i-1, "] simplified: ", simplified];
      Print["   Numerator: ", Numerator[simplified]];
      Print["   Denominator: ", Denominator[simplified]];
      Print[""];
    ]
  ],
  {i, 2, Min[6, Length[bSequence]]}
];

(* === PART 4: Recurrence relation analysis === *)
Print["=== RECURRENCE RELATION ===\n"];

Print["The recurrence is:"];
Print["  a[n+1] = b[n]"];
Print["  b[n+1] = b[n] + (a[n] - b[n]) * (n + 1/(3 + 2*n))"];
Print[""];
Print["Simplifying b[n+1]:"];
Print["  b[n+1] = b[n] + (a[n] - b[n]) * (n + 1/(3+2n))"];
Print["         = b[n] + a[n]*(n + 1/(3+2n)) - b[n]*(n + 1/(3+2n))"];
Print["         = b[n]*(1 - n - 1/(3+2n)) + a[n]*(n + 1/(3+2n))"];
Print[""];

(* Simplify the coefficient of b[n] *)
coeff1 = 1 - n - 1/(3 + 2*n);
coeff1Simplified = FullSimplify[coeff1];
Print["Coefficient of b[n]: ", coeff1, " = ", coeff1Simplified];

(* Simplify the coefficient of a[n] *)
coeff2 = n + 1/(3 + 2*n);
coeff2Simplified = FullSimplify[coeff2];
Print["Coefficient of a[n]: ", coeff2, " = ", coeff2Simplified];
Print["\n"];

Print["So: b[n+1] = b[n] * (", coeff1Simplified, ") + a[n] * (", coeff2Simplified, ")"];
Print["    a[n+1] = b[n]"];
Print["\n"];

(* === PART 5: Matrix formulation === *)
Print["=== MATRIX FORMULATION ===\n"];

Print["We can write this as a matrix recurrence:\n"];
Print["[a[n+1]]   [   0              1        ] [a[n]]"];
Print["[b[n+1]] = [(n+1/(3+2n))  1-n-1/(3+2n)] [b[n]]"];
Print["\n"];

MatrixAt[n_] := {{0, 1}, {n + 1/(3 + 2*n), 1 - n - 1/(3 + 2*n)}};

Print["First few matrices:\n"];
Do[
  Module[{mat = MatrixAt[n]},
    Print["M[", n, "] = ", MatrixForm[mat]];
    Print["     = ", MatrixForm[FullSimplify[mat]]];
    Print[""];
  ],
  {n, 0, 3}
];

(* Product of matrices *)
Print["The state after h steps is given by the product:\n"];
Print["[a[h]]   M[h-1] * M[h-2] * ... * M[1] * M[0] * [0]"];
Print["[b[h]] =                                        [1]"];
Print["\n"];

(* Compute product for small h *)
ComputeMatrixProduct[h_] := Module[{product, result},
  product = IdentityMatrix[2];
  Do[product = MatrixAt[i].product, {i, 0, h-1}];
  result = product.{0, 1};
  {FullSimplify[result[[1]]], FullSimplify[result[[2]]]}
];

Print["Computing matrix products:\n"];
Do[
  Module[{ab = ComputeMatrixProduct[h]},
    Print["h = ", h, ": a = ", ab[[1]], ", b = ", ab[[2]]];
  ],
  {h, 1, 5}
];
Print["\n"];

(* === PART 6: Connection to explicit sum === *)
Print["=== CONNECTION TO EXPLICIT SUM ===\n"];

Print["The explicit formula is:"];
Print["  Primorial(m) = Denominator[1/2 * Sum[(-1)^k * k!/(2k+1), {k, 1, h}]]"];
Print[""];
Print["The recursive formula gives:"];
Print["  Primorial(m) = 2 * Denominator[b[h] - 1]"];
Print[""];
Print["Testing if b[h] = 1/2 * Sum[(-1)^k * k!/(2k+1), {k, 1, h}] + 1:"];
Print[""];

TestConnection[h_] := Module[{explicitSum, stateB, match, ratio},
  explicitSum = 1/2 * Sum[(-1)^k * (k!)/(2*k + 1), {k, 1, h}];
  stateB = IterateState[h][[3]];
  match = FullSimplify[stateB - 1 - explicitSum] == 0;
  ratio = FullSimplify[(stateB - 1) / explicitSum];

  Print["h = ", h];
  Print["  Explicit sum:     ", explicitSum];
  Print["  b[h] - 1:         ", stateB - 1];
  Print["  Ratio:            ", ratio];
  Print["  Match (b=S+1):    ", If[match, "✓ YES", "✗ NO"]];
  Print[""];
];

Do[TestConnection[h], {h, 1, 6}];

(* Test the alternative connection: b[h] = 2 * explicit_sum + 1 *)
Print["Testing alternative: b[h] = 2 * Sum + 1:"];
Print[""];

TestConnection2[h_] := Module[{explicitSum, stateB, match},
  explicitSum = 1/2 * Sum[(-1)^k * (k!)/(2*k + 1), {k, 1, h}];
  stateB = IterateState[h][[3]];
  match = FullSimplify[stateB - 1 - 2*explicitSum] == 0;

  Print["h = ", h];
  Print["  2 * Explicit sum: ", 2*explicitSum];
  Print["  b[h] - 1:         ", stateB - 1];
  Print["  Match (b=2S+1):   ", If[match, "✓ YES", "✗ NO"]];
  Print[""];
];

Do[TestConnection2[h], {h, 1, 6}];

(* === PART 7: Simplify the recurrence === *)
Print["=== ATTEMPTING SIMPLIFICATION ===\n"];

Print["Can we simplify n + 1/(3+2n)?\n"];

expr = n + 1/(3 + 2*n);
Print["Original: ", expr];
Print["Together: ", Together[expr]];
Print["FullSimplify: ", FullSimplify[expr]];
simplified = Together[expr];
Print["\nSimplified form: ", simplified];
Print["  = (n*(3+2n) + 1)/(3+2n)"];
Print["  = (3n + 2n² + 1)/(3+2n)"];
Print["  = (2n² + 3n + 1)/(2n+3)"];

(* Factor numerator *)
numer = 2*n^2 + 3*n + 1;
Print["\nNumerator factors as: ", Factor[numer]];
Print["  = (2n+1)(n+1)"];
Print["\nSo: n + 1/(3+2n) = (2n+1)(n+1)/(2n+3)"];
Print["\n");

(* Alternative form *)
Print["Therefore the recurrence becomes:");
Print["  a[n+1] = b[n]"];
Print["  b[n+1] = b[n] + (a[n] - b[n]) * (2n+1)(n+1)/(2n+3)"];
Print["\n"];

(* === PART 8: Look for generating function === *)
Print["=== GENERATING FUNCTION APPROACH ===\n"];

Print["Define B(x) = Sum[b[n] * x^n, {n, 0, ∞}]"];
Print["From the recurrence, can we find a functional equation for B(x)?\n"];

Print["This requires more advanced techniques (differential equations, etc.)"];
Print["Leaving for future investigation...\n"];

Print["=== ANALYSIS COMPLETE ==="];
