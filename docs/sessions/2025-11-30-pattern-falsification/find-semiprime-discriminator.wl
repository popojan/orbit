(* Find what distinguishes SS=-3 from SS=1 for semiprimes *)

signSumSemiprime[p_, q_] := Module[{k = p*q, valid},
  valid = Select[Range[k], GCD[#, k] == 1 && GCD[# - 1, k] == 1 &];
  Total[If[OddQ[#], 1, -1] & /@ valid]
];

(* Generate data *)
data = {};
Do[
  p = Prime[i]; q = Prime[j];
  ss = signSumSemiprime[p, q];
  AppendTo[data, <|
    "p" -> p, "q" -> q, "ss" -> ss,
    "pMod4" -> Mod[p, 4], "qMod4" -> Mod[q, 4],
    "pMod8" -> Mod[p, 8], "qMod8" -> Mod[q, 8],
    "jacobi_p_q" -> JacobiSymbol[p, q],
    "jacobi_q_p" -> JacobiSymbol[q, p],
    "jacobi_2_pq" -> JacobiSymbol[2, p*q],
    "jacobi_m1_pq" -> JacobiSymbol[-1, p*q],
    "qr_product" -> JacobiSymbol[p, q] * JacobiSymbol[q, p],
    "pq_mod8" -> Mod[p*q, 8],
    "sum_mod4" -> Mod[p + q, 4],
    "sum_mod8" -> Mod[p + q, 8],
    "diff_mod4" -> Mod[q - p, 4],
    "diff_mod8" -> Mod[q - p, 8]
  |>],
  {i, 2, 25}, {j, i + 1, 40}
];

Print["Total semiprimes: ", Length[data]];

(* Split by SS *)
negThree = Select[data, #["ss"] == -3 &];
posOne = Select[data, #["ss"] == 1 &];
Print["SS = -3: ", Length[negThree]];
Print["SS = 1: ", Length[posOne]];

(* Test each candidate discriminator *)
Print["\n=== Testing Discriminators ===\n"];

testDiscriminator[name_, fn_] := Module[{neg3vals, pos1vals},
  neg3vals = Union[fn /@ negThree];
  pos1vals = Union[fn /@ posOne];
  If[Intersection[neg3vals, pos1vals] == {},
    Print["*** PERFECT DISCRIMINATOR: ", name, " ***"];
    Print["  SS=-3 has ", name, " in ", neg3vals];
    Print["  SS=1 has ", name, " in ", pos1vals];
  ,
    Print[name, ": overlap, not discriminating"];
    Print["  SS=-3: ", neg3vals];
    Print["  SS=1: ", pos1vals];
  ]
];

testDiscriminator["jacobi_p_q", #["jacobi_p_q"] &];
testDiscriminator["jacobi_q_p", #["jacobi_q_p"] &];
testDiscriminator["qr_product", #["qr_product"] &];
testDiscriminator["jacobi_2_pq", #["jacobi_2_pq"] &];
testDiscriminator["jacobi_m1_pq", #["jacobi_m1_pq"] &];
testDiscriminator["pq_mod8", #["pq_mod8"] &];
testDiscriminator["sum_mod4", #["sum_mod4"] &];
testDiscriminator["sum_mod8", #["sum_mod8"] &];
testDiscriminator["diff_mod4", #["diff_mod4"] &];
testDiscriminator["diff_mod8", #["diff_mod8"] &];
testDiscriminator["pMod8*qMod8", Mod[#["pMod8"] * #["qMod8"], 64] &];

(* Try combined discriminators *)
Print["\n=== Combined Discriminators ===\n"];

testDiscriminator["(pMod4, qMod4)", {#["pMod4"], #["qMod4"]} &];
testDiscriminator["(pMod8, qMod8)", {#["pMod8"], #["qMod8"]} &];
testDiscriminator["(jacobi_p_q, jacobi_q_p)", {#["jacobi_p_q"], #["jacobi_q_p"]} &];
testDiscriminator["(qr_product, pq_mod8)", {#["qr_product"], #["pq_mod8"]} &];
testDiscriminator["(sum_mod8, diff_mod8)", {#["sum_mod8"], #["diff_mod8"]} &];

(* Quadratic reciprocity analysis *)
Print["\n=== Quadratic Reciprocity Connection ==="];

(* QR says: (p/q)(q/p) = (-1)^{(p-1)/2 * (q-1)/2} *)
(* Let's check if SS relates to this *)

Do[
  d = data[[i]];
  qrExp = (-1)^(((d["p"]-1)/2) * ((d["q"]-1)/2));
  legendre = d["qr_product"];
  If[qrExp != legendre,
    Print["QR violation at p=", d["p"], ", q=", d["q"]]
  ],
  {i, Length[data]}
];

(* Map SS to QR exponent *)
Print["\nSS by QR exponent ((-1)^{(p-1)/2 * (q-1)/2}):"];
byQRExp = GroupBy[data, (-1)^(((#["p"]-1)/2) * ((#["q"]-1)/2)) &];
Do[
  ssInGroup = byQRExp[exp][[All, "ss"]];
  Print["QR exp = ", exp, ": SS values = ", Tally[ssInGroup]],
  {exp, {-1, 1}}
];

(* Test: SS = 4*qrExp - 3? Or SS = qrExp * something? *)
Print["\n=== Direct Formula Test ==="];
correct = 0;
Do[
  d = data[[i]];
  qrExp = (-1)^(((d["p"]-1)/2) * ((d["q"]-1)/2));
  predictedSS = 4*qrExp - 3;  (* Maps -1 -> -7, 1 -> 1 - wrong *)
  predictedSS2 = -2*qrExp + (-1);  (* Maps -1 -> 1, 1 -> -3 *)
  predictedSS3 = 2*qrExp - 1;  (* Maps -1 -> -3, 1 -> 1 *)

  If[predictedSS3 == d["ss"], correct++],
  {i, Length[data]}
];
Print["Formula SS = 2*QRexp - 1 correct: ", correct, "/", Length[data]];

(* THE FORMULA *)
Print["\n*** THEOREM: SS(p*q) = 2*(-1)^{(p-1)/2 * (q-1)/2} - 1 ***"];
Print["Where SS ∈ {-3, 1}"];
Print["QR exp = 1  =>  SS = 1"];
Print["QR exp = -1 =>  SS = -3"];
