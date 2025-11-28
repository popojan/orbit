(* Exact relationship between d00 and d10 *)

Print["==============================================================="]
Print["  PRESNY VZTAH d00 vs d10"]
Print["==============================================================="]
Print[""]

f00[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 0, i}]/(2 i + 1), {i, 0, n}])
f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])
S00[n_] := Sum[Product[n^2 - j^2, {j, 0, i}]/(2 i + 1), {i, 0, n}]
S10[n_] := Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}]

(* Vime S00 = n^2 * S10 *)
Print["Overeni S00 = n^2 * S10:"]
Do[
  Print["  n=", n, ": S00/S10 = ", S00[n]/S10[n], " = n^2 = ", n^2, "? ", S00[n]/S10[n] == n^2],
  {n, {3, 5, 7}}
]
Print[""]

(* f00 = -1/(1 - S00) = -1/(1 - n^2 S10) *)
(* f10 = -1/(1 - S10) *)

(* Necht S10 = A/B v nejnizsich termech *)
(* Pak 1 - S10 = (B - A)/B *)
(* f10 = -B/(B-A) *)
(* Takze num10 = B, den10 = A - B (pokud A > B) nebo num10 = -B, den10 = B - A *)

Print["Kontrola struktury f10:")
Do[
  s10 = S10[n];
  numS = Numerator[s10];
  denS = Denominator[s10];
  oneMinusS = 1 - s10;
  f = f10[n];
  Print["  n=", n, ": S10 = ", numS, "/", denS, ", 1-S10 = ", oneMinusS, ", f10 = ", f],
  {n, {3, 5}}
]
Print[""]

(* Pro n=3: S10 = 35/3, 1 - S10 = -32/3, f10 = -1/(-32/3) = 3/32 *)
(* num10 = 3, den10 = 32 *)

(* Pro n=5: S10 = 46629/5, 1 - S10 = -46624/5, f10 = 5/46624 *)

Print["Vzorec pro f00:")
Print["  f00 = -1/(1 - n^2 * S10)")
Print["      = -1/(1 - n^2 * A/B)   kde S10 = A/B")
Print["      = -1/((B - n^2 A)/B)")
Print["      = -B/(B - n^2 A)")
Print["      = B/(n^2 A - B)")
Print[""]

Print["Overeni:")
Do[
  s10 = S10[n];
  A = Numerator[s10];
  B = Denominator[s10];
  predicted = B / (n^2 * A - B);
  actual = f00[n];
  Print["  n=", n, ": predicted = ", predicted, ", actual = ", actual, ", match = ", predicted == actual],
  {n, {3, 5, 7}}
]
Print[""]

Print["Takze:")
Print["  f10 = B/(A - B)   (kde A > B)")
Print["  f00 = B/(n^2 A - B)")
Print["")
Print["  num10 = B (resp. jeho delitel)")
Print["  den10 = A - B")
Print["  num00 = B (resp. jeho delitel)")
Print["  den00 = n^2 A - B")
Print[""]

Print["Rozdil denominatoru:")
Print["  den00 - den10 = (n^2 A - B) - (A - B) = n^2 A - A = A(n^2 - 1)")
Print[""]

Print["Overeni:")
Do[
  s10 = S10[n];
  A = Numerator[s10];
  B = Denominator[s10];
  d00 = Denominator[f00[n]];
  d10 = Denominator[f10[n]];
  predicted = A * (n^2 - 1);
  actual = d00 - d10;
  Print["  n=", n, ": d00-d10 = ", actual, ", A*(n^2-1) = ", predicted, ", match = ", actual == predicted],
  {n, {3, 5, 7, 11}}
]
Print[""]

Print["==============================================================="]
Print["  LINEÁRNÍ KOMBINACE"]
Print["==============================================================="]
Print[""]

Print["d00 = n^2 A - B")
Print["d10 = A - B")
Print["-d00 + b*d10 = -(n^2 A - B) + b(A - B)")
Print["             = -n^2 A + B + bA - bB")
Print["             = A(-n^2 + b) + B(1 - b)")
Print["             = A(b - n^2) + B(1 - b)")
Print[""]

Print["Pro gcd(..., n) > 1, modulo p (kde p | n):")
Print["  A(b - n^2) + B(1 - b) mod p")
Print["  = A*b + B - B*b (mod p)   [protoze n^2 = 0 mod p]")
Print["  = A*b + B(1 - b) (mod p)")
Print[""]

Print["Hodnoty A, B mod p:")
testCases = {{15, 3, 5}, {21, 3, 7}, {35, 5, 7}, {77, 7, 11}, {143, 11, 13}};
Do[
  {n, p, q} = tc;
  s10 = S10[n];
  A = Numerator[s10];
  B = Denominator[s10];
  Print["n=", n, " (", p, "*", q, "):"];
  Print["  A = ", A, ", B = ", B];
  Print["  A mod ", p, " = ", Mod[A, p], ", B mod ", p, " = ", Mod[B, p]];
  Print["  A mod ", q, " = ", Mod[A, q], ", B mod ", q, " = ", Mod[B, q]];
  
  (* Pro b = -1: A*(-1) + B*(1-(-1)) = -A + 2B *)
  combo = -A + 2*B;
  Print["  b=-1: -A + 2B = ", combo, " mod ", p, " = ", Mod[combo, p], ", mod ", q, " = ", Mod[combo, q]];
  
  (* Pro b = -2: A*(-2) + B*(1-(-2)) = -2A + 3B *)
  combo2 = -2*A + 3*B;
  Print["  b=-2: -2A + 3B = ", combo2, " mod ", p, " = ", Mod[combo2, p], ", mod ", q, " = ", Mod[combo2, q]];
  Print[""],
  {tc, testCases}
]
