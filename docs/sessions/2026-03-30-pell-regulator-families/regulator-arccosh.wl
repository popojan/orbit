(* Can we compute R directly without computing the huge integers x, y? *)
(* R = log(x + y√n) = m · log(z + √(z²-1)) = m · arccosh(z) *)

n0 = 13078849728;
a0 = Floor[Sqrt[n0]];
r = n0 - a0^2;
z = (2a0^2 + r)/r;
Print["n = ", n0];
Print["a₀ = ", a0, "  r = ", r, "  z = ", z];
Print["δ = ", Denominator[z], "\n"];

(* R = m · ArcCosh[z] — just a single ArcCosh evaluation! *)
(* No need to compute T_m(z) which has millions of digits *)

Do[
  R = m * N[ArcCosh[z], 50];
  Print["m=", m, ": R = ", R],
{m, {1, 2, 3, 6, 7, 14, 21, 42}}];

Print["\nTiming comparison:"];
(* ArcCosh method *)
{t1, r1} = AbsoluteTiming[42 * N[ArcCosh[z], 100]];
Print["  ArcCosh: ", t1*1000, "ms  R = ", r1];

(* T_m method (computing huge integers) *)
{t2, r2} = AbsoluteTiming[
  xval = ChebyshevT[42, z];
  yval = (2a0/r) * ChebyshevU[41, z];
  Log[N[xval + yval*Sqrt[n0], 100]]
];
Print["  T_42 integers: ", t2*1000, "ms  R = ", r2];
Print["  x has ", IntegerLength[xval], " digits"];

Print["\nSpeedup: ", Round[t2/t1, 0.1], "×"];

(* For comparison: how many digits of precision do we need? *)
Print["\nR to 50 digits: ", 42 * N[ArcCosh[z], 50]];
