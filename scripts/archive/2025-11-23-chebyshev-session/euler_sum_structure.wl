#!/usr/bin/env wolframscript

Print["EULER SUM STRUCTURE VIA ODD/EVEN DECOMPOSITION"];
Print[StringRepeat["=", 70]];
Print[];

(* Define AB using original integrals *)
ABintegral[k_] := Module[{ak, bk},
  ak = Integrate[Sin[k*theta], {theta, 0, Pi}];
  bk = Integrate[Sin[k*theta]*Cos[theta], {theta, 0, Pi}];
  Simplify[(ak - bk)/2]
];

(* Closed form *)
ABclosed[k_] := 1/k /; OddQ[k];
ABclosed[k_] := -(1/2)*(1/(k+1) + 1/(k-1)) /; EvenQ[k];

Print[StringRepeat["=", 70]];
Print["DIRECTION 1: TOTAL SUM VIA ODD ONLY"];
Print[StringRepeat["=", 70]];
Print[];

Print["Odd terms:"];
Print["  Σ_{m=0}^∞ AB[2m+1] = Σ_{m=0}^∞ 1/(2m+1)"];
Print[];

Print["Even terms:"];
Print["  AB[2m] = -(1/(2m+1) + 1/(2m-1))/2"];
Print[];
Print["  Σ_{m=1}^∞ AB[2m] = -(1/2) Σ_{m=1}^∞ [1/(2m+1) + 1/(2m-1)]"];
Print[];

Print["Expanding even sum:"];
Print["  Σ_{m=1}^∞ 1/(2m-1) = 1 + 1/3 + 1/5 + ... = Σ_{m=0}^∞ 1/(2m+1)"];
Print["  Σ_{m=1}^∞ 1/(2m+1) = 1/3 + 1/5 + ... = Σ_{m=0}^∞ 1/(2m+1) - 1"];
Print[];

Print["Therefore:"];
Print["  Even sum = -(1/2)[Σ_{m=0}^∞ 1/(2m+1) + Σ_{m=0}^∞ 1/(2m+1) - 1]"];
Print["           = -(1/2)[2·Σ_{m=0}^∞ 1/(2m+1) - 1]"];
Print["           = -Σ_{m=0}^∞ 1/(2m+1) + 1/2"];
Print[];

Print["TOTAL SUM:"];
Print["  Σ AB[k] = Σ_{m=0}^∞ 1/(2m+1) + [-Σ_{m=0}^∞ 1/(2m+1) + 1/2]"];
Print["          = 1/2"];
Print[];

Print["Verification with partial sums:"];
Do[
  sum = N[Sum[ABclosed[k], {k, 1, n}], 10];
  Print["  N=", n, ": Σ AB[k] = ", sum, " (distance from 1/2: ", Abs[sum - 0.5], ")"];
, {n, {10, 20, 50, 100, 200, 500}}];
Print[];

Print["CONCLUSION: Σ_{k=1}^∞ AB[k] = 1/2 (Cesàro/oscillating convergence)"];
Print[];

Print[StringRepeat["=", 70]];
Print["DIRECTION 2: INTEGRAL REPRESENTATION OF SUM"];
Print[StringRepeat["=", 70]];
Print[];

Print["Using original definition:"];
Print["  AB[k] = (1/2)[∫₀^π sin(kθ) dθ - ∫₀^π sin(kθ)cos(θ) dθ]"];
Print[];

Print["Sum over k:"];
Print["  Σ_{k=1}^N AB[k] = (1/2) ∫₀^π [Σ_{k=1}^N sin(kθ) - cos(θ)·Σ_{k=1}^N sin(kθ)] dθ"];
Print["                  = (1/2) ∫₀^π [1 - cos(θ)]·[Σ_{k=1}^N sin(kθ)] dθ"];
Print[];

Print["Dirichlet kernel:"];
Print["  D_N(θ) = Σ_{k=1}^N sin(kθ) = [sin((N+1/2)θ) - sin(θ/2)] / [2sin(θ/2)]"];
Print[];

Print["Therefore:"];
Print["  Σ AB[k] = (1/2) ∫₀^π [1 - cos(θ)]·D_N(θ) dθ"];
Print[];

Print["As N → ∞, D_N(θ) → π·δ(θ) (Dirichlet kernel → delta function)"];
Print["But [1-cos(θ)] vanishes at θ=0, so we need careful analysis"];
Print[];

Print[StringRepeat["=", 70]];
Print["DIRECTION 3: GENERATING FUNCTION VIA INTEGRALS"];
Print[StringRepeat["=", 70]];
Print[];

Print["Define: G(z) = Σ_{k=1}^∞ AB[k]·z^k"];
Print[];

Print["Using integral form:"];
Print["  G(z) = (1/2) Σ_{k=1}^∞ z^k [∫₀^π sin(kθ) dθ - ∫₀^π sin(kθ)cos(θ) dθ]"];
Print["       = (1/2) ∫₀^π [Σ_{k=1}^∞ z^k sin(kθ)] [1 - cos(θ)] dθ"];
Print[];

Print["Fourier series sum:"];
Print["  Σ_{k=1}^∞ z^k sin(kθ) = Im[Σ_{k=1}^∞ z^k e^{ikθ}]"];
Print["                         = Im[z·e^{iθ}/(1 - z·e^{iθ})]"];
Print[];

Print["For |z| < 1:"];
Print["  Σ z^k sin(kθ) = z·sin(θ) / [1 - 2z·cos(θ) + z^2]"];
Print[];

Print["Therefore:"];
Print["  G(z) = (1/2) ∫₀^π [1-cos(θ)]·[z·sin(θ)/(1-2z·cos(θ)+z^2)] dθ"];
Print[];

Print["Computing G(1/2):"];
gHalf = (1/2)*NIntegrate[(1-Cos[theta])*((1/2)*Sin[theta])/(1-2*(1/2)*Cos[theta]+(1/2)^2), 
                          {theta, 0, Pi}];
Print["  G(1/2) = ", gHalf];
Print[];

Print["Compare to direct sum:"];
gHalfDirect = Sum[ABclosed[k]*(1/2)^k, {k, 1, 100}] // N;
Print["  Direct: ", gHalfDirect];
Print["  Match? ", Abs[gHalf - gHalfDirect] < 0.0001];
Print[];

Print[StringRepeat["=", 70]];
Print["DIRECTION 4: ALTERNATING SUM"];
Print[StringRepeat["=", 70]];
Print[];

Print["Σ (-1)^k AB[k] = -AB[1] + AB[2] - AB[3] + AB[4] - ..."];
Print[];

Print["Odd terms (k=2m+1): -AB[2m+1] = -1/(2m+1)"];
Print["Even terms (k=2m): +AB[2m] = -(1/(2m+1) + 1/(2m-1))/2"];
Print[];

Print["Partial sums:"];
Do[
  altSum = Sum[(-1)^k * ABclosed[k], {k, 1, n}] // N;
  Print["  N=", n, ": Σ (-1)^k AB[k] = ", altSum];
, {n, {10, 20, 50, 100}}];
Print[];

Print["Pattern: appears to diverge (unbounded negative)"];
Print[];

Print["DONE!"];
