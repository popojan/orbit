#!/usr/bin/env wolframscript
(* Understand what Mod[a/b, 1/n] actually computes *)

Print["Understanding Mod[rational, unit fraction]\n"];

Print["For rational r and modulus m, Mod[r, m] returns:"];
Print["  r - m * Floor[r/m]\n"];

(* Test with m=3 *)
Print["Example: m=3"];
alt3 = -1/3;
modulus = 1/2;

Print["alt[3] = ", alt3];
Print["modulus = 1/(m-1)! = ", modulus];

quotient = alt3 / modulus;
Print["alt[3] / modulus = ", quotient];
Print["Floor[", quotient, "] = ", Floor[quotient]];

result = alt3 - modulus * Floor[quotient];
Print["Mod result = ", alt3, " - ", modulus, " * ", Floor[quotient]];
Print["           = ", result];
Print["Simplified = ", Numerator[result], "/", Denominator[result]);

Print["\n" <> StringRepeat["=", 60] <> "\n"];

(* General analysis *)
Print["For prime m, analyzing the Mod operation:\n"];

primes = {3, 5, 7, 11};

Do[
  Module[{altVal, modulus, quotient, floorQ, result},
    altVal = Sum[(-1)^k * k!/(2k+1), {k, 1, (m-1)/2}];
    modulus = 1/(m-1)!;

    quotient = altVal / modulus;
    floorQ = Floor[quotient];
    result = altVal - modulus * floorQ;

    Print["m=", m, ":"];
    Print["  alt[", m, "] = ", Numerator[altVal], "/", Denominator[altVal]];
    Print["  alt[", m, "] / (1/(m-1)!) = ", N[quotient, 5]];
    Print["  Floor = ", floorQ];
    Print["  Mod result = ", Numerator[result], "/", Denominator[result]];

    (* Factor the denominator *)
    Print["  Denominator factors: ", FactorInteger[Denominator[result]]];
    Print["  Verify contains m: ", MemberQ[FactorInteger[Denominator[result]][[All,1]], m]];
    Print[];
  ],
  {m, primes}
];

Print["Key insight: Floor[alt[m] × (m-1)!] is what determines the transformation"];
Print["The 'chaos' resolves because this floor operation involves (m-1)!"];

Print["\nDone!"];
