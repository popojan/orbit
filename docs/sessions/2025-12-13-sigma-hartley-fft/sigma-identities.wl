(* sigma-identities.wl
   Key identities connecting silver involution to Hartley/FFT
   2025-12-13 *)

(* Silver involution *)
sigma[x_] := (1 - x)/(1 + x);

(* Copper involution *)
kappa[x_] := 1 - x;

(* === FUNDAMENTAL IDENTITIES === *)

(* 1. Hyperbolic to Exponential *)
(* sigma(tanh(t)) = e^(-2t) *)
hyperbolicIdentity = Simplify[sigma[Tanh[t]] - Exp[-2 t]] === 0;

(* 2. Trigonometric to Unit Circle *)
(* sigma(i tan(theta)) = e^(-2i theta) *)
trigIdentity = Simplify[sigma[I Tan[theta]] - Exp[-2 I theta]] === 0;

(* 3. Angle Reflection *)
(* sigma(tan(theta)) = tan(pi/4 - theta) *)
(* This is reflection around theta = pi/8 *)

(* === FIXED POINT === *)

(* Fixed point of sigma: sqrt(2) - 1 = tan(pi/8) *)
fixedPointSigma = Simplify[sigma[Sqrt[2] - 1] - (Sqrt[2] - 1)] === 0;

(* === ALGEBRAIC STRUCTURE === *)

(* Composition sigma o kappa *)
sigmaKappa[x_] := sigma[kappa[x]] // Simplify;
(* Result: x/(2-x) - hyperbolic shift *)

(* Powers of sigma o kappa *)
(* (sigma kappa)^n (x) = x / (2^n - (2^n - 1)x) *)
powerFormula[n_Integer, x_] := x / (2^n - (2^n - 1) x);

(* In logit coordinates y = x/(1-x): *)
(* sigma o kappa corresponds to y -> 2y *)
logit[x_] := x/(1 - x);
invLogit[y_] := y/(1 + y);

(* === VERIFICATION === *)

Print["=== Verifying Identities ==="];
Print[""];
Print["1. sigma(tanh(t)) = e^(-2t): ", hyperbolicIdentity];
Print["2. sigma(i tan(theta)) = e^(-2i theta): ", trigIdentity];
Print["3. Fixed point sqrt(2)-1: ", fixedPointSigma];
Print[""];

Print["=== Composition sigma o kappa ==="];
Print["sigma(kappa(x)) = ", sigmaKappa[x]];
Print[""];

Print["=== Powers (sigma kappa)^n ==="];
Do[
  comp = Nest[sigmaKappa, x, n] // Simplify;
  formula = powerFormula[n, x] // Simplify;
  Print["n=", n, ": ", comp, " = ", formula, " (match: ", comp === formula, ")"],
{n, 1, 5}];
Print[""];

Print["=== Logit Coordinates ==="];
Print["In y = x/(1-x) coordinates:"];
xVal = 1/5;
yBefore = logit[xVal];
xAfter = sigmaKappa[xVal];
yAfter = logit[xAfter];
Print["  x = ", xVal, " -> y = ", yBefore];
Print["  sigma(kappa(x)) = ", xAfter, " -> y = ", yAfter];
Print["  Ratio: ", yAfter/yBefore, " (should be 2)"];
