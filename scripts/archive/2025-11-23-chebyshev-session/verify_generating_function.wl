#!/usr/bin/env wolframscript

Print["GENERATING FUNCTION - RIGOROUS VERIFICATION"];
Print[StringRepeat["=", 70]];
Print[];

(* Closed form definition *)
ABclosed[k_] := 1/k /; OddQ[k];
ABclosed[k_] := -(1/2)*(1/(k+1) + 1/(k-1)) /; EvenQ[k];

Print[StringRepeat["=", 70]];
Print["STEP 1: DERIVE G(z) FROM INTEGRALS"];
Print[StringRepeat["=", 70]];
Print[];

Print["Starting from:"];
Print["  AB[k] = (1/2)[∫₀^π sin(kθ) dθ - ∫₀^π sin(kθ)cos(θ) dθ]"];
Print[];

Print["G(z) = Σ_{k=1}^∞ AB[k]·z^k"];
Print["     = (1/2) ∫₀^π [Σ z^k sin(kθ)] [1 - cos(θ)] dθ"];
Print[];

Print["Using: Σ_{k=1}^∞ z^k sin(kθ) = z·sin(θ)/(1 - 2z·cos(θ) + z²)"];
Print[];

Print["Therefore:"];
Print["  G(z) = (1/2) ∫₀^π [1-cos(θ)]·z·sin(θ)/(1-2z·cos(θ)+z²) dθ"];
Print[];

Print[StringRepeat["=", 70]];
Print["STEP 2: SYMBOLIC INTEGRATION ATTEMPT"];
Print[StringRepeat["=", 70]];
Print[];

Print["Trying to integrate symbolically..."];
Print[];

integrand = (1 - Cos[theta]) * z * Sin[theta] / (1 - 2*z*Cos[theta] + z^2);

Print["Integrand: ", integrand];
Print[];

(* Try symbolic integration *)
Print["Integrate for general z:"];
result = Integrate[integrand, {theta, 0, Pi}, Assumptions -> 0 < z < 1];
Print["  Result: ", result];
Print[];

If[Head[result] === Integrate,
  Print["  → Cannot solve symbolically for general z"],
  Print["  → SUCCESS! Closed form exists"]
];
Print[];

Print[StringRepeat["=", 70]];
Print["STEP 3: SPECIFIC VALUES"];
Print[StringRepeat["=", 70]];
Print[];

Print["Computing G(z) for specific z values:"];
Print[];

zValues = {1/10, 1/5, 1/4, 1/3, 1/2, 2/3, 3/4, 4/5, 9/10};

Do[
  (* Via integral *)
  gIntegral = NIntegrate[(1 - Cos[theta]) * z * Sin[theta] / 
                         (1 - 2*z*Cos[theta] + z^2), 
                         {theta, 0, Pi}, WorkingPrecision -> 20];
  
  (* Via direct sum *)
  gDirect = Sum[ABclosed[k] * z^k, {k, 1, 200}] // N;
  
  (* Error *)
  error = Abs[gIntegral - gDirect];
  
  Print["z = ", z, ":"];
  Print["  Integral: ", gIntegral];
  Print["  Direct:   ", gDirect];
  Print["  Error:    ", error];
  Print[];
, {z, zValues}];

Print[StringRepeat["=", 70]];
Print["STEP 4: SYMBOLIC INTEGRATION FOR SPECIFIC z"];
Print[StringRepeat["=", 70]];
Print[];

Print["Trying z = 1/2 symbolically:"];
Print[];

integrand12 = (1 - Cos[theta]) * (1/2) * Sin[theta] / (1 - Cos[theta] + 1/4);
Print["Integrand: ", integrand12];

integrand12Simp = Simplify[integrand12];
Print["Simplified: ", integrand12Simp];

result12 = Integrate[integrand12Simp, {theta, 0, Pi}];
Print["Integral: ", result12];
Print["Numerical: ", N[result12, 20]];
Print[];

Print[StringRepeat["=", 70]];
Print["STEP 5: ONE-LINER FOR WOLFRAM"];
Print[StringRepeat["=", 70]];
Print[];

Print["Copy-paste for Wolfram:"];
Print[];
Print["(* Definition *)"];
Print["AB[k_] := 1/k /; OddQ[k];"];
Print["AB[k_] := -(1/2)(1/(k+1) + 1/(k-1)) /; EvenQ[k];"];
Print[];
Print["(* Direct sum *)"];
Print["G[z_] := Sum[AB[k]*z^k, {k, 1, 100}]"];
Print[];
Print["(* Integral representation *)"];
Print["GInt[z_?NumericQ] := NIntegrate[(1-Cos[θ])*z*Sin[θ]/(1-2z*Cos[θ]+z^2), {θ,0,π}]"];
Print[];
Print["(* Test *)"];
Print["G[1/2]"];
Print["GInt[1/2]"];
Print[];

Print[StringRepeat["=", 70]];
Print["STEP 6: CAN WE FIND TRUE CLOSED FORM?"];
Print[StringRepeat["=", 70]];
Print[];

Print["Checking if G(z) has closed form in terms of elementary functions..."];
Print[];

Print["Trying substitution u = tan(θ/2):"];
Print["  1 - cos(θ) = 2u²/(1+u²)"];
Print["  sin(θ) = 2u/(1+u²)"];
Print["  dθ = 2du/(1+u²)"];
Print["  θ: 0→π ⇒ u: 0→∞"];
Print[];

(* This would require extensive algebra - skip for now *)
Print["(Detailed calculation omitted - requires significant algebra)"];
Print[];

Print["DONE!"];
