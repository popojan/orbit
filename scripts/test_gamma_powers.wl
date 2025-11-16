#!/usr/bin/env wolframscript
(*
  Quick test: Try different powers of gamma factor
*)

Print["Testing different gamma factor powers\n"];

TailZeta[s_?NumericQ, m_Integer] := Zeta[s] - Sum[k^(-s), {k, 1, m-1}];
ComputeLM[s_?NumericQ, nMax_Integer : 200] :=
  N[Zeta[s] * (Zeta[s] - 1) - Sum[TailZeta[s, j]/j^s, {j, 2, nMax}], 30];

(* Test point *)
s = 1.5 + 5.0*I;
s1 = 1 - s;
Ls = ComputeLM[s, 200];
Ls1 = ComputeLM[s1, 200];

(* Base factor *)
BaseGamma[s_] := Pi^(-s/2) * Gamma[s/2];

Print["Testing γ(s) = [π^(-s/2) Γ(s/2)]^α for different α:\n"];
Print[StringRepeat["-", 60]];
Print["α\t|ratio|\t\t\tMatch?"];
Print[StringRepeat["-", 60]];

powers = {0.5, 1, 1.5, 2, 2.5, 3};

Do[
  gamma = BaseGamma[s]^alpha;
  gamma1 = BaseGamma[s1]^alpha;

  left = gamma * Ls;
  right = gamma1 * Ls1;
  ratio = Abs[left/right];

  match = Abs[ratio - 1] < 0.01;

  Print[N[alpha, 3], "\t", N[ratio, 10], "\t", If[match, "✓", "✗"]];
  ,
  {alpha, powers}
];

Print["\n"];
Print["If none match with integer/simple α, FR might be more complex."];
