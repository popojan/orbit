(* Use symbolic Residue to compute sum directly *)
(* This avoids numerical integration entirely! *)

betaExplicit[n_] := (n - Cos[Pi/n]/Sin[Pi/n])/(4n)
B[n_, k_] := 1 + betaExplicit[n] * Cos[(2k - 1) Pi/n]

Print["=== SYMBOLIC RESIDUE COMPUTATION ==="];
Print[""];

(* Residue of β at n = 1/m *)
Print["Residue pattern:"];
Do[
  res = Residue[betaExplicit[n], {n, 1/m}] // FullSimplify;
  Print["Res[β, n=1/", m, "] = ", res],
  {m, 1, 6}
];

Print[""];
Print["Pattern: Res[β, n=1/m] = 1/(4πm)"];
Print[""];

(* Now the full B(n,k) residue including cos factor *)
Print["=== FULL B(n,k) RESIDUE ==="];
Print[""];

fullResidue[m_, k_] := Residue[B[n, k], {n, 1/m}]

Print["k = 1:"];
Do[
  res = fullResidue[m, 1] // FullSimplify;
  resN = N[res, 10];
  expected = (-1)^m / (4 Pi m);
  Print["m = ", m, ": Res = ", res, " = ", resN, 
        " (expected (-1)^m/(4πm) = ", N[expected, 10], ")"],
  {m, 1, 6}
];

Print[""];
Print["=== VERIFICATION: RESIDUE INCLUDES ALTERNATING SIGN ==="];
Print[""];

(* cos((2k-1)π/n) at n = 1/m evaluates to cos((2k-1)mπ) = (-1)^{(2k-1)m} *)
(* For k = 1: cos(π/n) at n = 1/m is cos(mπ) = (-1)^m *)

Print["cos(π/n) at n = 1/m:"];
Do[
  val = Cos[Pi m] // FullSimplify;
  Print["m = ", m, ": cos(", m, "π) = ", val],
  {m, 1, 6}
];

Print[""];
Print["=== SUM OF RESIDUES = η(s)/(4π) ==="];
Print[""];

(* Sum: Σ Res[n^{s-1} B(n,k), n=1/m] for m = 1, 2, 3, ... *)
(* = Σ (1/m)^{s-1} * Res[B, n=1/m] *)
(* = Σ (1/m)^{s-1} * (-1)^m / (4πm) *)
(* = Σ (-1)^m / (4π m^s) *)
(* = -η(s) / (4π) *)

s = 1;
partialSum[N0_] := Sum[
  Residue[(n)^(s-1) * B[n, 1], {n, 1/m}],
  {m, 1, N0}
];

Print["Partial sums of residues vs -η(1)/(4π):"];
Print["Expected: ", N[-Log[2]/(4 Pi), 15]];
Do[
  ps = partialSum[N0] // N;
  Print["N = ", N0, ": Σ Res = ", ps],
  {N0, {5, 10, 20, 50, 100}}
];

Print[""];
Print["=== SYMBOLIC CLOSED FORM ==="];
Print[""];

(* Infinite sum *)
infiniteSum = Sum[(-1)^m / (4 Pi m), {m, 1, Infinity}];
Print["Σ_{m=1}^∞ (-1)^m / (4πm) = ", infiniteSum // FullSimplify];
Print["= ", N[infiniteSum, 15]];
Print["-η(1)/(4π) = ", N[-Log[2]/(4 Pi), 15]];
