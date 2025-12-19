(* Deeper analysis - looking for characterization *)

Print["=== DEEPER ANALYSIS OF DIVIDING vs NON-DIVIDING PRIMES ===\n"];

s[0] = 1; s[1] = 7;
s[n_] := s[n] = (4 n + 2) s[n - 1] + s[n - 2];

findFirst[p_, maxN_] := SelectFirst[Range[0, maxN], Mod[s[#], p] == 0 &];

(* Get lists *)
dividing = {};
nonDividing = {};
Do[
  first = findFirst[p, 400];
  If[MissingQ[first], AppendTo[nonDividing, p], AppendTo[dividing, p]];
, {p, Prime[Range[PrimePi[300]]]}];

Print["Dividing (", Length[dividing], "): ", dividing];
Print["Non-dividing (", Length[nonDividing], "): ", nonDividing];

(* Check mod 7 pattern more carefully *)
Print["\n=== MOD 7 ANALYSIS ==="];
Print["Non-dividing mod 7:"];
nonDivMod7 = Counts[Mod[nonDividing, 7]];
Print[nonDivMod7];

Print["\nDividing mod 7:"];
divMod7 = Counts[Mod[dividing, 7]];
Print[divMod7];

(* Check A045362 pattern: p ≡ {1,2,4,5} mod 7 *)
Print["\n=== CHECK A045362 PATTERN (p ≡ {1,2,4,5} mod 7) ==="];
a045362Classes = {1, 2, 4, 5};
Print["If non-dividing = primes ≡ {1,2,4,5} mod 7:"];

nonDivIn = Select[nonDividing, MemberQ[a045362Classes, Mod[#, 7]] &];
nonDivOut = Select[nonDividing, !MemberQ[a045362Classes, Mod[#, 7]] &];
Print["  Non-dividing in {1,2,4,5} mod 7: ", Length[nonDivIn], "/", Length[nonDividing]];
Print["  Non-dividing NOT in {1,2,4,5} mod 7: ", nonDivOut];

divIn = Select[dividing, MemberQ[a045362Classes, Mod[#, 7]] &];
divOut = Select[dividing, !MemberQ[a045362Classes, Mod[#, 7]] &];
Print["  Dividing in {1,2,4,5} mod 7: ", divIn];
Print["  Dividing NOT in {1,2,4,5} mod 7: ", Length[divOut], "/", Length[dividing]];

(* Maybe the pattern is more subtle - check mod 28 = 4×7 *)
Print["\n=== MOD 28 ANALYSIS ==="];
Print["Non-dividing mod 28:"];
nonDivMod28 = Counts[Mod[nonDividing, 28]];
Print[Sort[Normal[nonDivMod28]]];

Print["\nDividing mod 28:"];
divMod28 = Counts[Mod[dividing, 28]];
Print[Sort[Normal[divMod28]]];

(* Check if it's related to quadratic form *)
Print["\n=== QUADRATIC FORM ANALYSIS ==="];
Print["Are non-dividing primes of form x² + 7y²?"];

isForm[p_, a_, b_] := AnyTrue[
  Flatten[Table[{x, y}, {x, 0, Sqrt[p/a]}, {y, 0, Sqrt[p/b]}], 1],
  a #[[1]]^2 + b #[[2]]^2 == p &
];

formX2Plus7Y2 = Select[nonDividing, isForm[#, 1, 7] &];
Print["Non-dividing of form x² + 7y²: ", formX2Plus7Y2];
Print["Count: ", Length[formX2Plus7Y2], "/", Length[nonDividing]];

(* Try x² + xy + 2y² (discriminant -7) *)
Print["\nAre non-dividing primes of form x² + xy + 2y² (disc = -7)?"];
isFormQuad[p_] := AnyTrue[
  Flatten[Table[{x, y}, {x, -Sqrt[p], Sqrt[p]}, {y, -Sqrt[p], Sqrt[p]}], 1],
  #[[1]]^2 + #[[1]] #[[2]] + 2 #[[2]]^2 == p &
];
formQuad = Select[Take[nonDividing, 20], isFormQuad];
Print["First 20 non-dividing of form x² + xy + 2y²: ", formQuad];
