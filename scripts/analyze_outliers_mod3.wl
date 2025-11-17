#!/usr/bin/env wolframscript
(* ANALYZE OUTLIERS: Why h ≠ 2? *)

Print[StringRepeat["=", 80]];
Print["OUTLIER ANALYSIS: n = p*q (mod 3) with h > 2"];
Print[StringRepeat["=", 80]];
Print[];

ClassNumber[n_] := Module[{factors},
  factors = FactorInteger[n];
  If[Max[factors[[All, 2]]] > 1, Return[Missing["NotSquareFree"]]];
  NumberFieldClassNumber[Sqrt[n]]
]

(* Outliers *)
outliers = {
  {219, 4, 3, 73},
  {291, 4, 3, 97},
  {323, 4, 17, 19},
  {235, 6, 5, 47}
};

Print["OUTLIERS:"];
Print[StringRepeat["-", 70]];

Do[
  {n, h, p, q} = outliers[[i]];

  Print["n = ", n, " = ", p, " × ", q, ": h = ", h];
  Print["  p mod 8 = ", Mod[p, 8], ", q mod 8 = ", Mod[q, 8]];

  (* Check if p or q have special class numbers *)
  hp = ClassNumber[p];
  hq = ClassNumber[q];
  Print["  h(", p, ") = ", hp];
  Print["  h(", q, ") = ", hq];

  (* Check if primes themselves have patterns *)
  Print["  p mod 4 = ", Mod[p, 4], ", q mod 4 = ", Mod[q, 4]];

  (* Check size *)
  Print["  q/p ratio = ", N[q/p, 3]];

  Print[];
  ,
  {i, Length[outliers]}
];

Print[StringRepeat["=", 80]];
Print[];

(* Compare to typical cases *)
typical = {
  {51, 2, 3, 17},
  {123, 2, 3, 41},
  {35, 2, 5, 7},
  {115, 2, 5, 23}
};

Print["TYPICAL CASES (h = 2):"];
Print[StringRepeat["-", 70]];

Do[
  {n, h, p, q} = typical[[i]];

  Print["n = ", n, " = ", p, " × ", q, ": h = ", h];

  hp = ClassNumber[p];
  hq = ClassNumber[q];
  Print["  h(", p, ") = ", hp];
  Print["  h(", q, ") = ", hq];

  Print["  q mod 4 = ", Mod[q, 4]];
  Print["  q/p ratio = ", N[q/p, 3]];

  Print[];
  ,
  {i, Length[typical]}
];

Print[StringRepeat["=", 80]];
Print[];

Print["HYPOTHESIS:"];
Print[StringRepeat["-", 60]];
Print[];
Print["Outliers have h > 2. What's different?"];
Print["  - Different h(p) or h(q)?"];
Print["  - Different q mod 4?"];
Print["  - Larger q/p ratio?"];
Print[];

(* Check q mod 4 pattern *)
Print["Checking q mod 4:"];
Print["  Outliers: 73≡1, 97≡1, 19≡3, 47≡3"];
Print["  Typical:  17≡1, 41≡1, 7≡3, 23≡3"];
Print["  -> No clear pattern"];
Print[];

Print["Checking h(q):"];
Print["  Outliers: h(73)=?, h(97)=?, h(19)=1, h(47)=?"];
Print[];

Print[StringRepeat["=", 80]];
