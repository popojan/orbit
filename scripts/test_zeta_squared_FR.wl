#!/usr/bin/env wolframscript
(* TEST: Does zeta^2 have functional equation? *)

Print[StringRepeat["=", 80]];
Print["FUNCTIONAL EQUATION FOR ZETA^2"];
Print[StringRepeat["=", 80]];
Print[];

Print["Testing: gamma_zeta2(s) * zeta^2(s) = gamma_zeta2(1-s) * zeta^2(1-s)"];
Print[];
Print["where gamma_zeta2(s) = pi^s Gamma((1-s)/2)^2 / Gamma(s/2)^2"];
Print[];

testPoints = {
  0.5 + 5*I,
  0.5 + 10*I,
  2 + 3*I,
  3 + 0*I
};

Print["s                  LHS                  RHS                  Ratio"];
Print[StringRepeat["-", 80]];

Do[
  s = testPoints[[i]];

  (* Gamma factor for zeta^2 *)
  gammaZeta2S = Pi^s * (Gamma[(1-s)/2])^2 / (Gamma[s/2])^2;
  gammaZeta2OneMinusS = Pi^(1-s) * (Gamma[s/2])^2 / (Gamma[(1-s)/2])^2;

  (* Zeta squared *)
  zetaSq = Zeta[s]^2;
  zetaOneMinusSq = Zeta[1-s]^2;

  lhs = gammaZeta2S * zetaSq;
  rhs = gammaZeta2OneMinusS * zetaOneMinusSq;

  ratio = lhs / rhs;

  Print[
    StringPadRight[ToString[N[s, 4]], 19],
    StringPadRight[ToString[N[lhs, 6]], 21],
    StringPadRight[ToString[N[rhs, 6]], 21],
    N[ratio, 6]
  ];
  ,
  {i, Length[testPoints]}
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

Print["ANALYSIS:"];
Print[StringRepeat["-", 60]];
Print[];
Print["From ζ(s) FR: ξ(s) = π^{-s/2} Γ(s/2) ζ(s) = ξ(1-s)"];
Print[];
Print["Inverting: ζ(s) = π^{s/2} Γ(s/2)^{-1} ξ(s)"];
Print[];
Print["Squaring: ζ²(s) = π^s Γ(s/2)^{-2} ξ²(s)"];
Print[];
Print["For ζ²(s) to have FR with γ_ζ²(s), we need:"];
Print["  γ_ζ²(s) ζ²(s) = γ_ζ²(1-s) ζ²(1-s)"];
Print[];
Print["Substituting:"];
Print["  γ_ζ²(s) π^s Γ(s/2)^{-2} ξ²(s) = γ_ζ²(1-s) π^{1-s} Γ((1-s)/2)^{-2} ξ²(s)"];
Print[];
Print["Since ξ²(s) cancels:"];
Print["  γ_ζ²(s) π^s Γ(s/2)^{-2} = γ_ζ²(1-s) π^{1-s} Γ((1-s)/2)^{-2}"];
Print[];
Print["Rearranging:"];
Print["  γ_ζ²(s) / γ_ζ²(1-s) = π^{1-2s} Γ(s/2)^{-2} / Γ((1-s)/2)^{-2}"];
Print["                       = π^{1-2s} [Γ((1-s)/2) / Γ(s/2)]²"];
Print[];

Print[StringRepeat["=", 80]];
Print[];

Print["IMPLICATION FOR L_M(s):"];
Print[StringRepeat["-", 60]];
Print[];
Print["L_M(s) = ζ²(s) - ζ(s) - Σ H_{j-1}(s)/j^s"];
Print[];
Print["Since ζ²(s) and ζ(s) have DIFFERENT gamma factors,"];
Print["L_M(s) is a LINEAR COMBINATION of functions with different FRs."];
Print[];
Print["For L_M to have FR, the tail Σ H_{j-1}(s)/j^s would need to"];
Print["exactly cancel the mismatch between ζ² and ζ terms."];
Print[];
Print["This seems HIGHLY UNLIKELY unless there's hidden structure.");
Print[];

Print[StringRepeat["=", 80]];
Print[];

Print["NEXT STEP: Test the tail term"];
Print[StringRepeat["-", 60]];
Print[];
Print["Define: T(s) = Σ_{j=2}^∞ H_{j-1}(s)/j^s"];
Print[];
Print["Then: L_M(s) = ζ(s)[ζ(s)-1] - T(s)"];
Print[];
Print["For FR to exist:");
Print["  γ(s)·[ζ²(s) - ζ(s) - T(s)] = γ(1-s)·[ζ²(1-s) - ζ(1-s) - T(1-s)]"];
Print[];
Print["Does T(s) have special FR properties that could make this work?"];
Print[];

Print[StringRepeat["=", 80]];
