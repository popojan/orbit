(* Analyze: HOW do primitive lobes distribute to give different c? *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];
primLobes[k_] := Select[Range[2, k-1], isPrimitiveLobe[#, k] &];

(* For p1*p2*p3, each primitive lobe n must satisfy:
   - gcd(n-1, p1*p2*p3) = 1: n ≢ 1 (mod pi) for all i
   - gcd(n, p1*p2*p3) = 1: n ≢ 0 (mod pi) for all i
*)

Print["=== Compare two numbers with same parity signature but different c ==="];

(* From earlier: {2, 1, 2, 3, 1, 3} has both c=0 and c=1 *)
(* 105 = 3×5×7 has c=0 *)
(* 1581 = 3×17×31 has c=1 *)

k1 = 105; k2 = 1581;
Print["\nk = ", k1, " = 3×5×7, c=0:"];
lobes1 = primLobes[k1];
Print["  #primLobes = ", Length[lobes1]];
Print["  Lobes (mod 2): ", Tally[Mod[lobes1, 2]]];
Print["  signSum = ", signSum[k1]];

Print["\nk = ", k2, " = 3×17×31, c=1:"];
lobes2 = primLobes[k2];
Print["  #primLobes = ", Length[lobes2]];
Print["  Lobes (mod 2): ", Tally[Mod[lobes2, 2]]];
Print["  signSum = ", signSum[k2]];

(* Look at CRT structure *)
Print["\n=== CRT coset analysis ==="];

(* For k = p1*p2*p3, primitive lobes avoid n ≡ 0,1 (mod pi) for each i *)
(* CRT: residue (a1, a2, a3) mod (p1, p2, p3) where ai ∉ {0, 1} *)

crtClass[n_, {p1_, p2_, p3_}] := {Mod[n, p1], Mod[n, p2], Mod[n, p3]};

Print["\nFor k=105 = 3×5×7:"];
Print["Primitive lobe CRT classes:"];
classes1 = crtClass[#, {3, 5, 7}] & /@ lobes1;
Print[Tally[classes1]];

Print["\nFor k=1581 = 3×17×31:"];
Print["Sample of primitive lobe CRT classes (first 20):"];
classes2 = crtClass[#, {3, 17, 31}] & /@ lobes2;
Print[Take[Tally[classes2], UpTo[20]]];

(* Maybe: count per CRT class with sign *)
signedCRT[n_, ps_] := {(-1)^(n-1), crtClass[n, ps]};

Print["\n=== Signed contribution per CRT class ==="];
Print["k=105:"];
contrib1 = Tally[signedCRT[#, {3, 5, 7}] & /@ lobes1];
grouped1 = GroupBy[contrib1, #[[1, 2]] &, Total[#[[1, 1]] * #[[2]] & /@ #] &];
Print["Total contribution by class: ", grouped1];
Print["Sum = ", Total[Values[grouped1]]];

Print["\nk=1581:"];
contrib2 = Tally[signedCRT[#, {3, 17, 31}] & /@ lobes2];
grouped2 = GroupBy[contrib2, #[[1, 2]] &, Total[#[[1, 1]] * #[[2]] & /@ #] &];
Print["Sample of class contributions: ", Take[Normal[grouped2], UpTo[10]]];
Print["Sum = ", Total[Values[grouped2]]];

(* Compare the class (2, *, *) contributions *)
Print["\n=== Focus on residue classes mod p1=3 ==="];
Print["k=105: class (2,*,*) sum = ", Total[Select[Normal[grouped1], #[[1, 1]] == 2 &][[All, 2]]]];
Print["k=1581: class (2,*,*) sum = ", Total[Select[Normal[grouped2], #[[1, 1]] == 2 &][[All, 2]]]];
