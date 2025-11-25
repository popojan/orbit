(* Domain analysis: Hyperbolic vs Factorial *)

Print["=== DOMAIN ANALYSIS ===\n"];

Print["LHS: Cosh[(1+2k)·ArcSinh[√(x/2)]]"];
Print["RHS: (√2·√(2+x)) · (1/2 + Σ 2^(i-1)·x^i·(k+i)!/((k-i)!·(2i)!))\n"];

Print["=== LHS DOMAIN ===\n"];
Print["ArcSinh[z] defined for all z ∈ ℂ"];
Print["√(x/2) requires: x/2 ≥ 0 → x ≥ 0"];
Print["Cosh[w] defined for all w ∈ ℂ"];
Print["\nLHS domain: x ≥ 0 (real), k ∈ ℤ\n"];

Print["=== RHS DOMAIN ===\n"];
Print["√(2+x) requires: 2+x ≥ 0 → x ≥ -2"];
Print["Factorials (k+i)! require: k+i ≥ 0"];
Print["Factorials (k-i)! require: k-i ≥ 0"];
Print["\nFor i ∈ {1,...,k}:"];
Print["  k+i ≥ 0 always true for k ≥ 1"];
Print["  k-i ≥ 0 requires: k ≥ i, satisfied by i ≤ k"];
Print["\nRHS domain: x ≥ -2 (real), k ≥ 1 (positive integer)\n"];

Print["=== OVERLAP ===\n"];
Print["Both defined: x ≥ 0, k ∈ ℕ⁺"];
Print["\nBut where does EQUALITY hold?\n"];

Print["=== TESTING BOUNDARY ===\n"];

<< Orbit`

(* Test at boundary values *)
testCases = {
  {0, 1},   (* x=0, k=1 *)
  {0, 3},   (* x=0, k=3 *)
  {1, 1},   (* x=1, k=1 *)
  {2, 2},   (* x=2, k=2 *)
  {10, 3}   (* x=10, k=3 *)
};

Print["Test cases (x, k):"];
Do[
  {x, k} = test;
  
  (* LHS *)
  arg = (1 + 2*k) * ArcSinh[Sqrt[x/2]];
  coshVal = Cosh[arg];
  lhs = coshVal;
  
  (* RHS (without prefactor for now) *)
  facSum = Sum[2^(i-1) * x^i * Factorial[k+i] / (Factorial[k-i] * Factorial[2*i]), 
               {i, 1, k}];
  rhsCore = 1/2 + facSum;
  rhs = Sqrt[2] * Sqrt[2 + x] * rhsCore;
  
  (* Compare *)
  match = Abs[lhs - rhs] < 10^-10;
  
  Print["(x=", x, ", k=", k, "):"];
  Print["  LHS = ", N[lhs, 15]];
  Print["  RHS = ", N[rhs, 15]];
  Print["  Match: ", match];
  If[!match,
    Print["  ERROR: ", Abs[lhs - rhs]]
  ];
  Print[""],
  {test, testCases}
];

Print["=== NEGATIVE x? ===\n"];
Print["LHS for x=-1, k=1 (outside √(x/2) domain):"];
Print["  ArcSinh[√(-1/2)] = ArcSinh[i/√2] = complex"];
Print["  Cosh[complex] = complex value\n"];

Print["Can we extend to x ∈ [-2, 0) via analytic continuation?"];
Print["RHS is well-defined for x ∈ [-2, 0), but x^i with odd i gives negative values.\n"];

Print["Testing x=-1, k=1 (if implementable):"];
x = -1;
k = 1;
(* RHS can be evaluated *)
facSum = Sum[2^(i-1) * x^i * Factorial[k+i] / (Factorial[k-i] * Factorial[2*i]), 
             {i, 1, k}];
rhsCore = 1/2 + facSum;
rhs = Sqrt[2] * Sqrt[2 + x] * rhsCore;
Print["  RHS = ", N[rhs]];
Print["  (LHS complex, not testing)\n"];

Print["=== EXTENSION TO k=0? ===\n"];
Print["Factorial form: sum from i=1 to k"];
Print["For k=0: empty sum → 1/2"];
Print["  RHS = √2·√(2+x)·(1/2) = √(2+x)/√2\n"];

Print["LHS for k=0:"];
Print["  Cosh[(1+0)·ArcSinh[√(x/2)]] = Cosh[ArcSinh[√(x/2)]]"];
x = 10;
lhsK0 = Cosh[ArcSinh[Sqrt[x/2]]];
rhsK0 = Sqrt[2+x]/Sqrt[2];
Print["  x=10: LHS = ", N[lhsK0], ", RHS = ", N[rhsK0]];
Print["  Match: ", Abs[lhsK0 - rhsK0] < 10^-10, "\n"];

Print["=== SUMMARY ===\n"];
Print["Identity holds for: x ≥ 0, k ∈ ℕ (including k=0!)"];
Print["LHS classical domain: all x ≥ 0"];
Print["RHS factorial domain: x ≥ -2, but negative x gives different behavior"];
Print["Practical domain for equality: x ≥ 0, k ≥ 0"];

