#!/usr/bin/env wolframscript
(*
Analyze connection to prime mod 4
*)

Print["=" * 70];
Print["PRIME MOD 4 ANALYSIS"];
Print["=" * 70];
Print[];

testPrimes = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61};

data = Table[
  Module[{sol, x, y, xMod, xIsMinusOne, mod4},
    sol = Solve[x^2 - p*y^2 == 1 && x > 0 && y > 0 && x < 10^15, {x, y}, Integers];
    If[Length[sol] > 0,
      {x, y} = {x, y} /. sol[[1]];
      xMod = Mod[x, p];
      xIsMinusOne = (xMod == p - 1);
      mod4 = Mod[p, 4];
      {p, mod4, x, xMod, xIsMinusOne}
    ,
      {p, "?", "no sol", "?", False}
    ]
  ],
  {p, testPrimes}
];

Print["p\tp mod 4\tx\tx mod p\tx==-1?"];
Print["-" * 70];
Do[
  {p, mod4, x, xMod, isMinusOne} = row;
  Print[p, "\t", mod4, "\t", x, "\t", xMod, "\t", isMinusOne];
  ,
  {row, data}
];

Print[];
Print["=" * 70];
Print["CORRELATION ANALYSIS"];
Print["=" * 70];
Print[];

mod1 = Select[data, #[[2]] == 1 &];
mod3 = Select[data, #[[2]] == 3 &];

Print["Primes p == 1 (mod 4): ", mod1[[All, 1]]];
Print["  x == -1 (mod p): ", Select[mod1, #[[5]] == True &][[All, 1]]];
Print["  x == +1 (mod p): ", Select[mod1, #[[5]] == False && #[[4]] == 1 &][[All, 1]]];
Print[];

Print["Primes p == 3 (mod 4): ", mod3[[All, 1]]];
Print["  x == -1 (mod p): ", Select[mod3, #[[5]] == True &][[All, 1]]];
Print["  x == +1 (mod p): ", Select[mod3, #[[4]] == 1 &][[All, 1]]];
Print[];

(* Check correlation *)
mod1MinusOne = Length[Select[mod1, #[[5]] == True &]];
mod1Total = Length[mod1];
mod3MinusOne = Length[Select[mod3, #[[5]] == True &]];
mod3Total = Length[mod3];

Print["SUMMARY:"];
Print["  p == 1 (mod 4): ", mod1MinusOne, " / ", mod1Total, " have x == -1"];
Print["  p == 3 (mod 4): ", mod3MinusOne, " / ", mod3Total, " have x == -1"];
Print[];

Print["=" * 70];
