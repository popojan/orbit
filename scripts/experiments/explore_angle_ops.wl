#!/usr/bin/env wolframscript
(* Exploration of algebraic tangent operations *)

(* Define the operations *)
op[p_, q_] := (p - q)/(1 + p q) (* Tan[ArcTan[p]-ArcTan[q]] *)
iop[r_, p_] := op[p, r]
sin[x_] := x/Sqrt[1 + x^2]
cos[x_] := 1/Sqrt[1 + x^2]
sinop[p_, q_] := (p - q)/(Sqrt[1 + p^2] Sqrt[1 + q^2])
cosop[p_, q_] := (1 + p q)/(Sqrt[1 + p^2] Sqrt[1 + q^2])
mul[k_, a_] := (I (-I - a)^k - (I - a)^k - I (-I + a)^k + (I + a)^k)/
               ((-I - a)^k - I (I - a)^k + (-I + a)^k - I (I + a)^k)

Print["=== VERIFICATION: Does mul[k,a] = Tan[k*ArcTan[a]]? ===\n"]

(* Test for various k and a values *)
testCases = {
  {2, 1}, {2, 2}, {2, 1/2},
  {3, 1}, {3, 2}, {3, 1/3},
  {4, 1}, {5, 1}, {6, 1}
};

Do[
  {k, a} = testCase;
  algebraic = mul[k, a];
  transcendental = Tan[k*ArcTan[a]];
  diff = Simplify[algebraic - transcendental];
  Print["mul[", k, ", ", a, "] = ", algebraic];
  Print["Tan[", k, "*ArcTan[", a, "]] = ", transcendental];
  Print["Difference: ", diff];
  Print["Match: ", Simplify[diff] == 0, "\n"];
, {testCase, testCases}]

Print["\n=== EXPLORING STRUCTURE ===\n"]

(* Look at mul[k, a] for small k symbolically *)
Print["mul[1, a] = ", Simplify[mul[1, a]]];
Print["mul[2, a] = ", Simplify[mul[2, a]]];
Print["mul[3, a] = ", Simplify[mul[3, a]]];
Print["mul[4, a] = ", Simplify[mul[4, a]]];
Print["mul[5, a] = ", Simplify[mul[5, a]]];

Print["\n=== SPECIAL VALUES ===\n"]

(* tan(π/4) = 1, so tan(k*π/4) should be algebraic *)
Print["Multiples of π/4 (a=1):"];
Do[
  Print["tan(", k, "π/4) = mul[", k, ", 1] = ", mul[k, 1]];
, {k, 1, 8}]

Print["\n=== RATIONAL TANGENT VALUES ===\n"]

(* If tan(θ) is rational, what about tan(kθ)? *)
Print["Starting from tan(θ) = 1/2:"];
Do[
  Print["tan(", k, "θ) = mul[", k, ", 1/2] = ", mul[k, 1/2]];
, {k, 1, 6}]

Print["\n=== CONNECTION TO CHEBYSHEV? ===\n"]

(* Chebyshev: Tn(cos(θ)) = cos(nθ), Un(cos(θ)) = sin((n+1)θ)/sin(θ) *)
(* Our parametrization: x = tan(θ) *)
(* Let's see if we can express mul[k,a] using Chebyshev-like recurrence *)

Print["Recurrence check:"];
Print["tan(2θ) from tan(θ): 2a/(1-a²) = ", Simplify[2*a/(1-a^2)]];
Print["mul[2, a] = ", Simplify[mul[2, a]]];
Print["Match: ", Simplify[mul[2, a] - 2*a/(1-a^2)] == 0];

Print["\n=== COMPOSITION PROPERTIES ===\n"]

(* Does mul[k, mul[m, a]] = mul[k*m, a]? *)
Print["Testing composition: mul[2, mul[3, a]] vs mul[6, a]"];
comp1 = Simplify[mul[2, mul[3, a]]];
comp2 = Simplify[mul[6, a]];
Print["mul[2, mul[3, a]] = ", comp1];
Print["mul[6, a] = ", comp2];
Print["Match: ", Simplify[comp1 - comp2] == 0];

Print["\n=== ADDITION FORMULA ===\n"]

(* Can we get tan(mθ + nθ) from tan(mθ) and tan(nθ)? *)
Print["Testing: op[mul[2,a], mul[3,a]] vs mul[5,a]"];
sum1 = Simplify[op[mul[2,a], mul[3,a]]];
sum2 = Simplify[mul[5,a]];
Print["op[mul[2,a], mul[3,a]] = ", sum1];
Print["mul[5,a] = ", sum2];
Print["Match: ", Simplify[sum1 - sum2] == 0];
