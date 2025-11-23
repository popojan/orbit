#!/usr/bin/env wolframscript

Print["INVERSE TRANSFORMATION TO x-DOMAIN"];
Print[StringRepeat["=", 70]];
Print[];

Print["From proof: f(x,k) = T_{k+1}(x) - x*T_k(x) = -sin(k*theta)*sin(theta)"];
Print["Substitution: x = cos(theta), dx = -sin(theta) d(theta)"];
Print[];

Print[StringRepeat["=", 70]];
Print["STEP 1: Express sin(k*theta) in terms of x"];
Print[StringRepeat["=", 70]];
Print[];

Print["From f(x,k) = -sin(k*theta)*sin(theta):"];
Print["  sin(k*theta) = -f(x,k)/sin(theta) = -f(x,k)/sqrt(1-x^2)"];
Print[];

Print[StringRepeat["=", 70]];
Print["STEP 2: Transform Ak integral"];
Print[StringRepeat["=", 70]];
Print[];

Print["Ak = Integrate[sin(k*theta), {theta, 0, Pi}]"];
Print[];
Print["With theta: 0 -> Pi  corresponds to  x: 1 -> -1"];
Print["And d(theta) = -dx/sqrt(1-x^2)"];
Print[];
Print["Therefore:"];
Print["  Ak = Integrate[sin(k*theta(x)) * (-1/sqrt(1-x^2)), {x, 1, -1}]"];
Print["     = Integrate[-f(x,k)/sqrt(1-x^2) * (-1/sqrt(1-x^2)), {x, 1, -1}]"];
Print["     = Integrate[f(x,k)/(1-x^2), {x, 1, -1}]"];
Print["     = -Integrate[f(x,k)/(1-x^2), {x, -1, 1}]"];
Print[];

Print["So: g_A(x,k) = -f(x,k)/(1-x^2)"];
Print[];

Print[StringRepeat["=", 70]];
Print["STEP 3: Transform Bk integral"];
Print[StringRepeat["=", 70]];
Print[];

Print["Bk = Integrate[sin(k*theta)*cos(theta), {theta, 0, Pi}]"];
Print["   = Integrate[sin(k*theta)*x, {theta, 0, Pi}]"];
Print[];
Print["Therefore:"];
Print["  Bk = Integrate[-f(x,k)/sqrt(1-x^2) * x * (-1/sqrt(1-x^2)), {x, 1, -1}]"];
Print["     = Integrate[x*f(x,k)/(1-x^2), {x, 1, -1}]"];
Print["     = -Integrate[x*f(x,k)/(1-x^2), {x, -1, 1}]"];
Print[];

Print["So: g_B(x,k) = -x*f(x,k)/(1-x^2)"];
Print[];

Print[StringRepeat["=", 70]];
Print["STEP 4: Combined function for AB[k]"];
Print[StringRepeat["=", 70]];
Print[];

Print["AB[k] = (Ak - Bk)/2"];
Print["      = (1/2)*Integrate[g_A(x,k) - g_B(x,k), {x, -1, 1}]"];
Print[];
Print["g_A - g_B = -f(x,k)/(1-x^2) - (-x*f(x,k)/(1-x^2))"];
Print["          = -f(x,k)/(1-x^2) + x*f(x,k)/(1-x^2)"];
Print["          = f(x,k)*(x-1)/(1-x^2)"];
Print["          = f(x,k)*(x-1)/[(1-x)*(1+x)]"];
Print["          = -f(x,k)/(1+x)"];
Print[];

Print["Therefore: g(x,k) = -f(x,k)/(2*(1+x))"];
Print[];

Print[StringRepeat["=", 70]];
Print["USING CHEBYSHEV SECOND KIND RELATION"];
Print[StringRepeat["=", 70]];
Print[];

Print["From Mason & Handscomb:"];
Print["  f(x,k) = T_{k+1}(x) - x*T_k(x) = -(1-x^2)*U_{k-1}(x)"];
Print[];

Print["Therefore:"];
Print["  g_A(x,k) = -f(x,k)/(1-x^2) = U_{k-1}(x)"];
Print["  g_B(x,k) = -x*f(x,k)/(1-x^2) = x*U_{k-1}(x)"];
Print["  g(x,k) = -f(x,k)/(2*(1+x)) = (1-x)*U_{k-1}(x)/2"];
Print[];

Print[StringRepeat["=", 70]];
Print["VERIFICATION"];
Print[StringRepeat["=", 70]];
Print[];

Print["Testing for k=1..5:"];
Print[];

Do[
  fk = ChebyshevT[k+1, x] - x*ChebyshevT[k, x];
  uk = ChebyshevU[k-1, x];
  
  (* Verify f(x,k) = -(1-x^2)*U_{k-1}(x) *)
  relation = Simplify[fk + (1-x^2)*uk];
  
  Print["k=", k, ":"];
  Print["  f(x,", k, ") = ", fk];
  Print["  U_", k-1, "(x) = ", uk];
  Print["  f(x,k) + (1-x^2)*U_{k-1}(x) = ", relation, " (should be 0)"];
  
  (* Test g_A(x,k) *)
  gA = -fk/(1-x^2);
  gASimp = Simplify[gA];
  Print["  g_A(x,k) = -f/(1-x^2) = ", gASimp];
  Print["  Equals U_{k-1}(x)? ", Simplify[gASimp - uk] == 0];
  
  (* Test combined g(x,k) *)
  g = -fk/(2*(1+x));
  gSimp = Simplify[g];
  gExpected = (1-x)*uk/2;
  Print["  g(x,k) = -f/(2(1+x)) = ", gSimp];
  Print["  Expected (1-x)*U_{k-1}/2 = ", Simplify[gExpected]];
  Print["  Match? ", Simplify[gSimp - gExpected] == 0];
  Print[];
, {k, 1, 5}];

Print[StringRepeat["=", 70]];
Print["FINAL ANSWER"];
Print[StringRepeat["=", 70]];
Print[];

Print["The function g(x,k) such that"];
Print["  Integrate[g(x,k), {x, -1, 1}] = AB[k] = (Ak - Bk)/2"];
Print[];
Print["is:"];
Print[];
Print["  g(x,k) = -[T_{k+1}(x) - x*T_k(x)]/(2*(1+x))"];
Print[];
Print["Or equivalently:"];
Print[];
Print["  g(x,k) = (1-x)*U_{k-1}(x)/2"];
Print[];
Print["where U_{k-1}(x) is the Chebyshev polynomial of the second kind."];
Print[];

Print["DONE!"];
