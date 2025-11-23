#!/usr/bin/env wolframscript

Print["FINAL COMPLETE PROOF"];
Print[StringRepeat["=", 70]];
Print[];

Print["THEOREM: For k >= 2,"];
Print["  Integrate[|T_{k+1}(x) - x*T_k(x)|, {x, -1, 1}] = 1"];
Print[];

Print[StringRepeat["=", 70]];
Print["PROOF"];
Print[StringRepeat["=", 70]];
Print[];

Print["Step 1: Simplify using Chebyshev recurrence"];
Print["-----------------------------------------------"];
Print["  T_{k+1}(x) - x*T_k(x) = x*T_k(x) - T_{k-1}(x)"];
Print[];

Print["Step 2: Trigonometric substitution"];
Print["-----------------------------------------------"];
Print["  Let x = cos(theta), dx = -sin(theta) d(theta)"];
Print["  Using T_k(cos(theta)) = cos(k*theta):"];
Print[];
Print["  x*T_k(x) - T_{k-1}(x) = cos(theta)*cos(k*theta) - cos((k-1)*theta)"];
Print["                        = [cos((k+1)*theta) + cos((k-1)*theta)]/2 - cos((k-1)*theta)"];
Print["                        = [cos((k+1)*theta) - cos((k-1)*theta)]/2"];
Print["                        = -sin(k*theta)*sin(theta)"];
Print[];

Print["Step 3: Transform the integral"];
Print["-----------------------------------------------"];
Print["  I_k = Integrate[|f(x,k)|, {x, -1, 1}]"];
Print["      = Integrate[|-sin(k*theta)*sin(theta)| * |sin(theta)|, {theta, pi, 0}]"];
Print["      = Integrate[|sin(k*theta)| * sin^2(theta), {theta, 0, pi}]"];
Print[];

Print["Step 4: Use Fourier expansion of sin^2(theta)"];
Print["-----------------------------------------------"];
Print["  sin^2(theta) = (1 - cos(2*theta))/2"];
Print[];
Print["  I_k = (1/2) * [A_k - B_k]"];
Print[];
Print["  where:"];
Print["    A_k = Integrate[|sin(k*theta)|, {theta, 0, pi}]"];
Print["    B_k = Integrate[|sin(k*theta)| * cos(2*theta), {theta, 0, pi}]"];
Print[];

Print[StringRepeat["=", 70]];
Print["LEMMA 1: A_k = 2 for all k >= 1"];
Print[StringRepeat["=", 70]];
Print[];

Print["Proof:"];
Print["  |sin(k*theta)| has period pi/k"];
Print["  Over [0, pi], it completes k half-periods"];
Print[];
Print["  A_k = Integrate[|sin(k*theta)|, {theta, 0, pi}]"];
Print["      = k * Integrate[sin(k*theta), {theta, 0, pi/k}]"];
Print["      = k * [-cos(k*theta)/k]_{0}^{pi/k}"];
Print["      = k * [(-cos(pi) + cos(0))/k]"];
Print["      = k * [(1 + 1)/k]"];
Print["      = 2"];
Print[];

Print["Verification:"];
Do[
  ak = Integrate[Abs[Sin[k*theta]], {theta, 0, Pi}];
  Print["  k=", k, ": A_", k, " = ", ak];
, {k, 1, 8}];
Print[];

Print[StringRepeat["=", 70]];
Print["LEMMA 2: B_k = 0 for all k >= 2"];
Print[StringRepeat["=", 70]];
Print[];

Print["Proof idea:"];
Print["  |sin(k*theta)| is symmetric about theta = pi/2"];
Print["  cos(2*theta) is antisymmetric about theta = pi/2"];
Print["  Their product integrates to zero"];
Print[];

Print["Detailed proof:"];
Print["  Let phi = theta - pi/2 (shift origin to pi/2)"];
Print["  Then theta = phi + pi/2"];
Print[];
Print["  |sin(k*(phi + pi/2))| = |sin(k*phi)*cos(k*pi/2) + cos(k*phi)*sin(k*pi/2)|"];
Print[];
Print["  For k even: sin(k*pi/2) = 0, so |sin(k*(phi + pi/2))| = |cos(k*phi)|"];
Print["  For k odd:  cos(k*pi/2) = 0, so |sin(k*(phi + pi/2))| = |cos(k*phi)|"];
Print[];
Print["  In both cases: |sin(k*(phi + pi/2))| is EVEN in phi"];
Print[];
Print["  cos(2*(phi + pi/2)) = cos(2*phi + pi) = -cos(2*phi)"];
Print["  This is ODD in phi"];
Print[];
Print["  Integral of EVEN * ODD over symmetric interval = 0"];
Print[];

Print["Symbolic verification:"];
Do[
  bk = Integrate[Abs[Sin[k*theta]] * Cos[2*theta], {theta, 0, Pi}];
  bkSimp = FullSimplify[bk];
  Print["  k=", k, ": B_", k, " = ", bkSimp];
, {k, 2, 10}];
Print[];

Print[StringRepeat["=", 70]];
Print["CONCLUSION"];
Print[StringRepeat["=", 70]];
Print[];

Print["For all k >= 2:"];
Print[];
Print["  I_k = (A_k - B_k)/2"];
Print["      = (2 - 0)/2"];
Print["      = 1"];
Print[];

Print["Therefore:"];
Print["  Integrate[|T_{k+1}(x) - x*T_k(x)|, {x, -1, 1}] = 1"];
Print[];

Print["Q.E.D."];
Print[];

Print[StringRepeat["=", 70]];
Print["SPECIAL CASE: k=1"];
Print[StringRepeat["=", 70]];
Print[];

Print["For k=1:"];
Print["  T_2(x) - x*T_1(x) = x^2 - 1"];
Print["  Integrate[|x^2 - 1|, {x, -1, 1}] = Integrate[1 - x^2, {x, -1, 1}]"];
Print["                                    = 4/3"];
Print[];

k = 1;
a1 = Integrate[Abs[Sin[theta]], {theta, 0, Pi}];
b1 = Integrate[Abs[Sin[theta]] * Cos[2*theta], {theta, 0, Pi}];

Print["Using the formula for k=1:"];
Print["  A_1 = ", a1];
Print["  B_1 = ", b1];
Print["  I_1 = (A_1 - B_1)/2 = (", a1, " - ", b1, ")/2 = ", (a1 - b1)/2];
Print[];

Print["This matches 4/3, confirming our formula extends to k=1"];
Print["but gives a different value."];
Print[];

Print["DONE!"];
