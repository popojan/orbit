#!/usr/bin/env wolframscript
(* Explore connection between mutual recurrence and our product *)

Print["=== MUTUAL RECURRENCE CONNECTION ===\n"];

Print["Known identity (Mason & Handscomb):"];
Print["  T_{k+1}(x) - x*T_k(x) = -(1-x^2)*U_{k-1}(x)"];
Print["\n"];

Print["Our product: T_n(x+1) * [U_m(x+1) - U_{m-1}(x+1)]"];
Print["\n"];

Print["Question: Can we use mutual recurrence to derive coefficient recurrence?"];
Print["\n"];

(* Verify mutual recurrence *)
Print["Part 1: Verify mutual recurrence for k=1..5\n"];

Do[
  lhs = ChebyshevT[k+1, x] - x * ChebyshevT[k, x] // Expand;
  rhs = -(1-x^2) * ChebyshevU[k-1, x] // Expand;

  match = (lhs == rhs);
  Print["k=", k, ": ", If[match, "MATCH", "DIFFER"]];
  If[!match,
    Print["  LHS: ", lhs];
    Print["  RHS: ", rhs];
  ];
, {k, 1, 5}];

Print["\n"];

Print["Part 2: Analyze U_m - U_{m-1} structure\n"];

(* For specific m, look at U_m - U_{m-1} *)
Do[
  um = ChebyshevU[m, x] // Expand;
  umm1 = ChebyshevU[m-1, x] // Expand;
  diff = Expand[um - umm1];

  Print["m=", m, ": U_m - U_{m-1} = ", diff];

  (* Check if it relates to T polynomials *)
  (* Try to express as combination of T_k *)
  Do[
    tk = ChebyshevT[k, x] // Expand;
    If[diff == tk || diff == -tk,
      Print["  = ", If[diff == tk, "", "-"], "T_", k];
    ];
  , {k, 0, m+2}];

, {m, 1, 4}];

Print["\n"];

Print["Part 3: Product T_n * (U_m - U_{m-1}) analysis\n"];

(* For k=4 (n=2, m=2) *)
k = 4;
n = Ceiling[k/2];
m = Floor[k/2];

Print["k=", k, " (n=", n, ", m=", m, ")\n"];

tn = ChebyshevT[n, x];
deltaU = ChebyshevU[m, x] - ChebyshevU[m-1, x];

Print["T_", n, "(x) = ", tn // Expand];
Print["U_", m, "(x) - U_", m-1, "(x) = ", deltaU // Expand];
Print["\n"];

(* Compute product *)
product = Expand[tn * deltaU];
Print["Product = ", product];
Print["\n"];

(* Try to use mutual recurrence *)
Print["Part 4: Connection to shifted argument\n"];

Print["For x+1 substitution:"];
Print["  T_{k+1}(x+1) - (x+1)*T_k(x+1) = -(1-(x+1)^2)*U_{k-1}(x+1)"];
Print["                                  = -(1-x^2-2x-1)*U_{k-1}(x+1)"];
Print["                                  = -(−x^2-2x)*U_{k-1}(x+1)"];
Print["                                  = x(x+2)*U_{k-1}(x+1)"];
Print["\n"];

(* Verify *)
k_test = 3;
lhs_shifted = ChebyshevT[k_test+1, x+1] - (x+1)*ChebyshevT[k_test, x+1] // Expand;
rhs_shifted = x*(x+2)*ChebyshevU[k_test-1, x+1] // Expand;

Print["Verification for k=", k_test, ":"];
Print["  LHS: ", lhs_shifted];
Print["  RHS: ", rhs_shifted];
Print["  Match: ", lhs_shifted == rhs_shifted];
Print["\n"];

Print["=== KEY INSIGHT ==="];
Print["The shifted mutual recurrence gives:"];
Print["  T_{k+1}(x+1) - (x+1)*T_k(x+1) = x(x+2)*U_{k-1}(x+1)"];
Print["\n"];
Print["This connects T and U at shifted argument!"];
Print["\n"];
Print["For our product T_n(x+1) * [U_m(x+1) - U_{m-1}(x+1)],"];
Print["maybe we can use similar recurrence relations?"];
