(* 
Half-factorial mod p - version 2
Fix the p ≡ 1 (mod 4) case
*)

(* For p ≡ 1 (mod 4), the discriminant is -4p, not -p *)
(* The sign formula involves h(-4p) *)

HalfFactorialMod[p_?PrimeQ] := Module[{h, sign, base, candidates},
  
  Off[PowerMod::root];
  
  If[Mod[p, 4] == 3,
    (* p ≡ 3 (mod 4): result is ±1 *)
    h = NumberFieldClassNumber[Sqrt[-p]];
    sign = (-1)^((h + 1)/2);
    If[sign == 1, 1, p - 1]
    ,
    (* p ≡ 1 (mod 4): result is ±√(-1) mod p *)
    (* Use h(-4p) for the sign *)
    h = NumberFieldClassNumber[Sqrt[-4 p]];
    base = PowerMod[-1, 1/2, p];  (* one of the square roots of -1 *)
    sign = (-1)^(h/2);  (* h(-4p) is always even for p ≡ 1 (mod 4) *)
    candidates = {base, p - base};
    (* Determine correct one - test empirically first *)
    If[sign == 1, Min[candidates], Max[candidates]]
  ]
]

(* Direct for verification *)
DirectHalfFactorial[p_] := Mod[((p-1)/2)!, p]

(* Debug: understand the pattern for p ≡ 1 (mod 4) *)
Print["=== Debugging p ≡ 1 (mod 4) ===\n"];
Print["p\th(-p)\th(-4p)\tdirect\tbase\tp-base\tcorrect_is"];

testPrimes1 = Select[Prime[Range[50, 150]], Mod[#, 4] == 1 &];
Do[
  direct = DirectHalfFactorial[p];
  hp = NumberFieldClassNumber[Sqrt[-p]];
  h4p = NumberFieldClassNumber[Sqrt[-4 p]];
  base = PowerMod[-1, 1/2, p];
  correctIs = If[direct == base, "base", If[direct == p - base, "p-base", "???"]];
  Print[p, "\t", hp, "\t", h4p, "\t", direct, "\t", base, "\t", p-base, "\t", correctIs];
, {p, testPrimes1}];

(* Look for pattern *)
Print["\n=== Pattern analysis ==="];
Print["Looking for: when is correct = base vs p-base?\n"];

results = Table[
  Module[{direct, hp, h4p, base, isBase},
    direct = DirectHalfFactorial[p];
    hp = NumberFieldClassNumber[Sqrt[-p]];
    h4p = NumberFieldClassNumber[Sqrt[-4 p]];
    base = PowerMod[-1, 1/2, p];
    isBase = (direct == base);
    {p, hp, h4p, Mod[hp, 4], Mod[h4p, 4], isBase}
  ],
  {p, testPrimes1}
];

Print["Testing h(-p) mod 4:"];
Print["  isBase when h(-p)≡0: ", Count[Select[results, #[[4]]==0&], r_/;r[[6]]], "/", Length[Select[results, #[[4]]==0&]]];
Print["  isBase when h(-p)≡2: ", Count[Select[results, #[[4]]==2&], r_/;r[[6]]], "/", Length[Select[results, #[[4]]==2&]]];

Print["\nTesting h(-4p) mod 4:"];
Print["  isBase when h(-4p)≡0: ", Count[Select[results, #[[5]]==0&], r_/;r[[6]]], "/", Length[Select[results, #[[5]]==0&]]];
Print["  isBase when h(-4p)≡2: ", Count[Select[results, #[[5]]==2&], r_/;r[[6]]], "/", Length[Select[results, #[[5]]==2&]]];

Print["\nTesting h(-4p)/2 mod 2:"];
h4pDiv2 = Table[{r[[5]]/2, r[[6]]}, {r, results}];
Print["  isBase when h(-4p)/2 is even: ", Count[Select[h4pDiv2, EvenQ[#[[1]]]&], r_/;r[[2]]], "/", Length[Select[h4pDiv2, EvenQ[#[[1]]]&]]];
Print["  isBase when h(-4p)/2 is odd: ", Count[Select[h4pDiv2, OddQ[#[[1]]]&], r_/;r[[2]]], "/", Length[Select[h4pDiv2, OddQ[#[[1]]]&]]];
