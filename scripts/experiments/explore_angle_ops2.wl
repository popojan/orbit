#!/usr/bin/env wolframscript
(* More careful exploration with concrete values *)

op[p_, q_] := (p - q)/(1 + p q)
mul[k_, a_] := (I (-I - a)^k - (I - a)^k - I (-I + a)^k + (I + a)^k)/
               ((-I - a)^k - I (I - a)^k + (-I + a)^k - I (I + a)^k)

Print["=== DERIVING THE FORMULA ===\n"]

(* Let's understand where mul[k,a] comes from *)
(* If z = 1 + ia, then arg(z) = arctan(a) *)
(* So z^k should give arg = k*arctan(a) *)
(* And we want to extract tan(arg) from z^k *)

Print["For z = 1 + ia, we have:"];
Print["arg(z) = arctan(a/1) = arctan(a)"];
Print["z^k = (1+ia)^k has arg(z^k) = k*arctan(a)"];
Print[""];

Print["The formula uses four terms: (I±a)^k and (-I±a)^k"];
Print["This looks like extracting Im/Re from a combination"];
Print[""];

(* Let's verify the double-angle formula *)
Print["=== DOUBLE ANGLE: tan(2θ) = 2tan(θ)/(1-tan²(θ)) ===\n"];

testVals = {1/2, 1/3, 2/3, 3/4, 5/7};
Do[
  a = val;
  expected = 2*a/(1 - a^2);
  computed = mul[2, a];
  Print["a = ", a, ": expected = ", expected, ", computed = ", computed,
        ", match = ", Simplify[expected - computed] == 0];
, {val, testVals}]

Print["\n=== TRIPLE ANGLE: tan(3θ) = (3tan(θ)-tan³(θ))/(1-3tan²(θ)) ===\n"];

Do[
  a = val;
  expected = (3*a - a^3)/(1 - 3*a^2);
  computed = mul[3, a];
  Print["a = ", a, ": expected = ", expected, ", computed = ", computed,
        ", match = ", Simplify[expected - computed] == 0];
, {val, testVals}]

Print["\n=== ADDITION FORMULA: tan(mθ + nθ) using op ===\n"];

(* Test if op[mul[m,a], mul[n,a]] = mul[m+n, a] *)
testPairs = {{2, 3}, {3, 4}, {1, 2}, {2, 5}};
Do[
  {m, n} = pair;
  a = 1/3; (* Use specific value *)
  left = op[mul[m, a], mul[n, a]];
  right = mul[m + n, a];
  Print["op[mul[", m, ",a], mul[", n, ",a]] = ", left];
  Print["mul[", m+n, ",a] = ", right];
  Print["Match: ", Abs[left - right] < 10^-10];
  Print[""];
, {pair, testPairs}]

Print["=== COMPOSITION: mul[k, mul[m, a]] = mul[k*m, a]? ===\n"];

(* This should be true! *)
testPairs2 = {{2, 2}, {2, 3}, {3, 3}};
Do[
  {k, m} = pair;
  a = 1/3;
  left = mul[k, mul[m, a]];
  right = mul[k*m, a];
  Print["mul[", k, ", mul[", m, ", ", a, "]] = ", left];
  Print["mul[", k*m, ", ", a, "] = ", right];
  Print["Match: ", Abs[left - right] < 10^-10];
  Print[""];
, {pair, testPairs2}]

Print["=== RATIONAL CONSTRUCTIBILITY ===\n"];

(* If tan(θ) is rational, all tan(kθ) are rational (if defined) *)
Print["Starting from tan(θ) = 2/3:"];
a = 2/3;
Do[
  result = mul[k, a];
  Print["tan(", k, "θ) = ", result, " (exact: ", Simplify[result], ")"];
, {k, 1, 8}]

Print["\n=== EXTRACTING THE PATTERN ===\n"];

(* Let's expand mul[k, a] for small k manually *)
Print["Expanding mul[k, x] for small k:"];
Do[
  expr = Simplify[mul[k, x]];
  Print["k = ", k, ": ", expr];
, {k, 1, 5}]

Print["\n=== NUMERATORS AND DENOMINATORS ===\n"];

(* For rational a, track numerator/denominator patterns *)
a = 1/2;
Print["With a = 1/2, tracking num/den:"];
Do[
  result = mul[k, a];
  If[Head[result] === Rational,
    Print["k = ", k, ": ", Numerator[result], "/", Denominator[result]];
  ,
    Print["k = ", k, ": ", result];
  ];
, {k, 1, 10}]
