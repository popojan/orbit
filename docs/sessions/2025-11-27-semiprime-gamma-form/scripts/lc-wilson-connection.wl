(* A mod p je urceno clenem pri i = (p-1)/2 *)
(* Term = Product[n^2 - j^2, j=1..(p-1)/2] / p *)

(* Pro n = p*q: *)
(* n^2 - j^2 = (pq)^2 - j^2 = p^2*q^2 - j^2 = -j^2 (mod p) *)
(* Product[-j^2, j=1..(p-1)/2] = (-1)^((p-1)/2) * ((p-1)/2)!^2 *)
(* = (-1)^((p-1)/2) * ((-1)^((p+1)/2) / (-1)) by Wilson *)
(* = (-1)^((p-1)/2) * (-1)^((p-1)/2) = (-1)^(p-1) = 1 *)

Print["Wilsonovsky clen:"]
Print[""]

testPrimes = {7, 11, 13, 17, 19, 23};
Do[
  p = testPrimes[[k]];
  halfP = (p - 1)/2;
  
  (* Product[n^2 - j^2, j=1..halfP] mod p pro n = 0 mod p *)
  (* = Product[-j^2, j=1..halfP] mod p *)
  (* = (-1)^halfP * (halfP!)^2 mod p *)
  
  halfFact = Mod[halfP!, p];
  wilson = Mod[(-1)^halfP * halfFact^2, p];
  
  Print["p = ", p, ":"];
  Print["  (p-1)/2 = ", halfP];
  Print["  ((p-1)/2)! mod p = ", halfFact];
  Print["  (-1)^((p-1)/2) * ((p-1)/2)!^2 mod p = ", wilson];
  
  (* Overeni pres Wilson: (p-1)! = -1 mod p *)
  (* ((p-1)/2)!^2 * (-1)^((p-1)/2) = (p-1)! * something = -1 * something *)
  Print["  Overeni: (p-1)! mod p = ", Mod[(p-1)!, p]],
  {k, Length[testPrimes]}
]
Print[""]

(* Nyni pro konkretni semiprime *)
Print["Pro n = 77 = 7 * 11:"]
n = 77;
p = 7; halfP = 3;
q = 11; halfQ = 5;

(* Clen pri i = (p-1)/2 pro faktor p *)
termP = Product[n^2 - j^2, {j, 1, halfP}] / (2*halfP + 1);
Print["  Term at i=3 (for p=7): ", termP]
Print["  numerator mod 7: ", Mod[Numerator[termP], 7]]
Print[""]

(* Souvislost s A mod p *)
S10 = Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}];
A = Numerator[S10];
Print["  A = ", A]
Print["  A mod 7 = ", Mod[A, 7]]
Print["  A mod 11 = ", Mod[A, 11]]
Print[""]

(* Co je A mod p presne? *)
(* Soucet az do singularity je 0 mod p *)
(* Na singularite pridame term/p kde term = Product[n^2-j^2] *)
Print["Predikce A mod p:"]
Do[
  p = {7, 11}[[k]];
  halfP = (p - 1)/2;
  
  (* Clen pri singularite: num / (2*halfP + 1) = num / p *)
  numAtSing = Product[n^2 - j^2, {j, 1, halfP}];
  (* numAtSing mod p^2 / p = (numAtSing / p) mod p *)
  quotient = numAtSing / p;
  predA = Mod[quotient, p];
  actualA = Mod[A, p];
  
  Print["  p = ", p, ":"];
  Print["    num at singularity = ", numAtSing];
  Print["    quotient = num/p = ", quotient];
  Print["    quotient mod p = ", predA];
  Print["    actual A mod p = ", actualA];
  Print["    match: ", predA == actualA],
  {k, 2}
]
