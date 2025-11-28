(* Half-Factorial Numerator Theorem: *)
(* n = (-1)^((m+1)/2) * ((m-1)/2)! (mod m) *)
(* Pro p = 1 (mod 4): n = -halfFact! (mod p), n^2 = -1 (mod p) *)
(* Pro p = 3 (mod 4): n = +halfFact! (mod p), n = +/- 1 (mod p) *)

S10[n_] := Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}]
getA[n_] := Numerator[S10[n]]

Print["Porovnani A mod p s half-factorial predikci:"]
Print[""]

testCases = {{15, 3, 5}, {21, 3, 7}, {35, 5, 7}, {55, 5, 11}, {77, 7, 11}, 
             {91, 7, 13}, {143, 11, 13}, {187, 11, 17}, {221, 13, 17}};

Do[
  {n, p, q} = testCases[[k]];
  
  (* Skutecne A mod p *)
  A = getA[n];
  Amodp = Mod[A, p];
  
  (* Half-factorial predikce *)
  halfFact = Mod[((p-1)/2)!, p];
  pMod4 = Mod[p, 4];
  signFactor = (-1)^((p+1)/2);
  hfPrediction = Mod[signFactor * halfFact, p];
  
  (* Pro nas vzorec: A mod p by melo souviset s q a half-factorial *)
  (* Zkusime ruzne kombinace *)
  qModp = Mod[q, p];
  
  (* Test: A = q * halfFact ? *)
  test1 = Mod[q * halfFact, p];
  (* Test: A = q * hfPrediction ? *)
  test2 = Mod[q * hfPrediction, p];
  (* Test: A = q^(-1) * halfFact ? *)
  qInv = PowerMod[q, -1, p];
  test3 = Mod[qInv * halfFact, p];
  test4 = Mod[qInv * hfPrediction, p];
  (* Test: A = q^2 * halfFact ? *)
  test5 = Mod[q^2 * halfFact, p];
  
  match = Which[
    Amodp == test1, "q*hf",
    Amodp == test2, "q*(-1)^((p+1)/2)*hf",
    Amodp == test3, "q^-1*hf", 
    Amodp == test4, "q^-1*(-1)^((p+1)/2)*hf",
    Amodp == test5, "q^2*hf",
    Amodp == Mod[-test1, p], "-q*hf",
    Amodp == Mod[-test2, p], "-q*(-1)^((p+1)/2)*hf",
    Amodp == Mod[-test3, p], "-q^-1*hf",
    Amodp == Mod[-test4, p], "-q^-1*(-1)^((p+1)/2)*hf",
    True, "?"
  ];
  
  Print["n=", n, " p=", p, " (mod4=", pMod4, "):"];
  Print["  A mod p = ", Amodp];
  Print["  halfFact = ", halfFact, ", signedHF = ", hfPrediction];
  Print["  q mod p = ", qModp, ", q^-1 mod p = ", qInv];
  Print["  tests: q*hf=", test1, ", q^-1*hf=", test3, ", q*signedHF=", test2];
  Print["  MATCH: ", match];
  Print[""],
  {k, Length[testCases]}
]
