(* Look for the pattern more carefully *)

DirectHalfFactorial[p_] := Mod[((p-1)/2)!, p]

(* For p ≡ 1 (mod 4), there are two square roots of -1: i and p-i where i < p/2 *)
(* Let's call i the "canonical" one (smaller) *)

Print["=== Looking for pattern in p ≡ 1 (mod 4) ===\n"];
Print["p\th\th%8\tcanon_i\tdirect\tis_canon?\th/2 odd?"];

testPrimes1 = Select[Prime[Range[50, 200]], Mod[#, 4] == 1 &];

results = Table[
  Module[{direct, h, base, canonical, isCanon, hDiv2Odd},
    direct = DirectHalfFactorial[p];
    h = NumberFieldClassNumber[Sqrt[-p]];
    base = PowerMod[-1, 1/2, p];
    canonical = Min[base, p - base];  (* smaller square root of -1 *)
    isCanon = (direct == canonical) || (direct == p - canonical && direct < p/2);
    (* Actually just check if direct < p/2 *)
    hDiv2Odd = OddQ[h/2];
    {p, h, Mod[h, 8], canonical, direct, direct == canonical, hDiv2Odd}
  ],
  {p, testPrimes1}
];

Do[
  r = results[[i]];
  Print[r[[1]], "\t", r[[2]], "\t", r[[3]], "\t", r[[4]], "\t", r[[5]], "\t", 
        If[r[[6]], "yes", "no"], "\t\t", If[r[[7]], "odd", "even"]];
, {i, Length[results]}];

(* Check correlation between "direct == canonical" and h/2 parity *)
Print["\n=== Correlation Analysis ==="];
isCanonical = results[[All, 6]];
hDiv2IsOdd = results[[All, 7]];

Print["When h/2 is odd:  direct=canonical ", Count[Select[results, #[[7]]&], r_/;r[[6]]], "/", Count[results, r_/;r[[7]]]];
Print["When h/2 is even: direct=canonical ", Count[Select[results, !#[[7]]&], r_/;r[[6]]], "/", Count[results, r_/;!r[[7]]]];

(* Try: is direct = canonical iff h ≡ 2 (mod 4)? *)
Print["\n=== Testing h mod 4 ==="];
Print["h ≡ 0 (mod 4): direct=canonical ", Count[Select[results, Mod[#[[2]],4]==0&], r_/;r[[6]]], "/", Length[Select[results, Mod[#[[2]],4]==0&]]];
Print["h ≡ 2 (mod 4): direct=canonical ", Count[Select[results, Mod[#[[2]],4]==2&], r_/;r[[6]]], "/", Length[Select[results, Mod[#[[2]],4]==2&]]];

(* Maybe it depends on the specific value of canonical mod something? *)
Print["\n=== Testing canonical mod 4 ==="];
Do[
  r = results[[i]];
  canonMod4 = Mod[r[[4]], 4];
  Print["p=", r[[1]], " canon=", r[[4]], " mod4=", canonMod4, " direct=", r[[5]], " isCanon=", r[[6]]];
, {i, 1, 10}];

(* Ultimate test: is there ANY simple formula? *)
Print["\n=== Brute force pattern search ==="];
(* direct/canonical relationship vs various functions of h and p *)
Table[
  r = results[[i]];
  p = r[[1]]; h = r[[2]]; canonical = r[[4]]; direct = r[[5]];
  (* Test: direct = canonical * (-1)^f(h) for some f *)
  ratio = If[direct == canonical, 1, -1];  (* since (p-canonical) = -canonical mod p up to sign *)
  {p, h, Mod[h, 8], ratio, (-1)^(h/2), (-1)^((h-2)/4)}
, {i, 1, 15}] // TableForm
