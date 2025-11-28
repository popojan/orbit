(* Stickelberger: ((p-1)/2)! mod p zavisi na p mod 4 *)
(* Nase suma: A je urcena clenem pri singularite i = (p-1)/2 *)
(* Tento clen obsahuje Product[n^2 - j^2, j=1..(p-1)/2] *)

(* Pro n = p*q, n^2 - j^2 = p^2*q^2 - j^2 = (pq-j)(pq+j) *)
(* mod p: (pq-j)(pq+j) = (-j)(j) = -j^2 *)
(* Takze Product = Product[-j^2, j=1..h] = (-1)^h * (h!)^2 kde h = (p-1)/2 *)

Print["Analyza pres Stickelberger:"]
Print[""]

testCases = {{15, 3, 5}, {21, 3, 7}, {35, 5, 7}, {77, 7, 11}, {143, 11, 13}, {221, 13, 17}};

Do[
  {n, p, q} = testCases[[k]];
  h = (p - 1)/2;
  
  (* Stickelberger hodnota *)
  halfFact = Mod[h!, p];
  pMod4 = Mod[p, 4];
  
  (* Product[-j^2, j=1..h] mod p *)
  wilsonProd = Mod[(-1)^h * halfFact^2, p];
  
  (* A mod p (empiricke) *)
  S10 = Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}];
  A = Numerator[S10];
  Amodp = Mod[A, p];
  
  Print["n=", n, " (p=", p, ", q=", q, "):"];
  Print["  p mod 4 = ", pMod4];
  Print["  ((p-1)/2)! mod p = ", halfFact];
  Print["  (-1)^((p-1)/2) * (((p-1)/2)!)^2 mod p = ", wilsonProd];
  Print["  A mod p = ", Amodp];
  
  (* Zkusime najit vztah *)
  (* Clen pri singularite je Product/p, a prispiva to k A *)
  (* Ale Product = n^((p-1)) * neco, takze mod p mame jine veci *)
  
  (* Jednoduchy test: je A mod p ~ halfFact nebo jeho funkce? *)
  If[Amodp == halfFact, Print["  -> A = halfFact!"]];
  If[Amodp == Mod[-halfFact, p], Print["  -> A = -halfFact!"]];
  If[Amodp == Mod[halfFact^2, p], Print["  -> A = halfFact^2!"]];
  If[Amodp == wilsonProd, Print["  -> A = wilsonProd!"]];
  Print[""],
  {k, Length[testCases]}
]

(* Mozna vztah pres q? *)
Print["Vztah A mod p k q:"]
Do[
  {n, p, q} = testCases[[k]];
  S10 = Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}];
  A = Numerator[S10];
  Amodp = Mod[A, p];
  qModp = Mod[q, p];
  qInvModp = PowerMod[q, -1, p];
  Print["n=", n, ": A mod ", p, " = ", Amodp, ", q mod p = ", qModp, ", q^-1 mod p = ", qInvModp],
  {k, Length[testCases]}
]
