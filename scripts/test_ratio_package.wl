(* Test if Ratio` package loads and works *)

Print["Testing Ratio` package..."];
Print[""];

<< Ratio`

Print["Package loaded. Testing RawFractions:"];
Print[""];

(* Simple test *)
testFraction = 7/12;
Print["Input: ", testFraction];
Print[""];

result = RawFractions[testFraction];
Print["RawFractions output: ", result];
Print[""];

(* Check if it's a function or just returned symbolically *)
Print["Head of result: ", Head[result]];
Print[""];

(* Try evaluating *)
Print["Trying to evaluate: ", result // N];
Print[""];

(* Try with actual computation *)
Print["Testing with -83/105:"];
raw = RawFractions[-83/105];
Print["  Result: ", raw];
Print["  Type: ", Head[raw]];
Print[""];

(* Check what functions are available *)
Print["Available functions from Ratio`:"];
Print[Names["Ratio`*"]];
Print[""];
