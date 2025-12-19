(* Find all primes up to 200 that divide some s_n *)
(* Then analyze for patterns *)

Print["Finding primes that divide s_n..."];

(* Compute s_n mod p *)
sModP[p_, maxN_] := Module[{s0 = Mod[1, p], s1 = Mod[7, p], s2, n},
  If[s0 == 0, Return[0]];
  If[s1 == 0, Return[1]];
  Do[
    s2 = Mod[(4 n + 2) * s1 + s0, p];
    If[s2 == 0, Return[n]];
    s0 = s1; s1 = s2;
  , {n, 2, maxN}];
  -1  (* not found *)
];

(* Test primes up to 200 *)
primes = Prime[Range[PrimePi[200]]];
results = {};
Do[
  firstN = sModP[p, 500];
  AppendTo[results, {p, firstN}];
, {p, primes}];

dividing = Select[results, #[[2]] >= 0 &];
notDividing = Select[results, #[[2]] == -1 &];

Print["\n=== PRIMES THAT DIVIDE s_n (up to 200) ==="];
Print["Count: ", Length[dividing]];
Print["Primes: ", dividing[[All, 1]]];

Print["\n=== PRIMES THAT DON'T DIVIDE s_n ==="];
Print["Count: ", Length[notDividing]];
Print["Primes: ", notDividing[[All, 1]]];

(* Analyze dividing primes *)
dividingPrimes = dividing[[All, 1]];

Print["\n=== ANALYSIS OF DIVIDING PRIMES ==="];

(* Check mod 3 *)
Print["\nMod 3:"];
Print["  p ≡ 0: ", Select[dividingPrimes, Mod[#, 3] == 0 &]];
Print["  p ≡ 1: ", Select[dividingPrimes, Mod[#, 3] == 1 &]];
Print["  p ≡ 2: ", Select[dividingPrimes, Mod[#, 3] == 2 &]];

(* Check mod 4 *)
Print["\nMod 4:"];
Print["  p ≡ 1: ", Select[dividingPrimes, Mod[#, 4] == 1 &]];
Print["  p ≡ 3: ", Select[dividingPrimes, Mod[#, 4] == 3 &]];

(* Check mod 6 *)
Print["\nMod 6:"];
Print["  p ≡ 1: ", Select[dividingPrimes, Mod[#, 6] == 1 &]];
Print["  p ≡ 5: ", Select[dividingPrimes, Mod[#, 6] == 5 &]];

(* Check mod 7 *)
Print["\nMod 7:"];
Do[
  subset = Select[dividingPrimes, Mod[#, 7] == r &];
  If[Length[subset] > 0, Print["  p ≡ ", r, ": ", subset]];
, {r, 0, 6}];

(* Check mod 12 *)
Print["\nMod 12:"];
Do[
  subset = Select[dividingPrimes, Mod[#, 12] == r &];
  If[Length[subset] > 0, Print["  p ≡ ", r, ": ", subset]];
, {r, 1, 11}];

(* Check if related to quadratic residues *)
Print["\n=== QUADRATIC RESIDUE ANALYSIS ==="];

(* Is -1 a QR mod p? (p ≡ 1 mod 4) *)
qr1 = Select[dividingPrimes, Mod[#, 4] == 1 &];
qr3 = Select[dividingPrimes, Mod[#, 4] == 3 &];
Print["p ≡ 1 (mod 4) [−1 is QR]: ", qr1];
Print["p ≡ 3 (mod 4) [−1 is NQR]: ", qr3];

(* Check Legendre symbol (2|p) *)
Print["\nLegendre (2|p):"];
Print["  (2|p) = +1: ", Select[dividingPrimes, JacobiSymbol[2, #] == 1 &]];
Print["  (2|p) = -1: ", Select[dividingPrimes, JacobiSymbol[2, #] == -1 &]];

(* Check Legendre symbol (3|p) *)
Print["\nLegendre (3|p):"];
Print["  (3|p) = +1: ", Select[dividingPrimes, JacobiSymbol[3, #] == 1 &]];
Print["  (3|p) = -1: ", Select[dividingPrimes, JacobiSymbol[3, #] == -1 &]];

(* Check Legendre symbol (7|p) *)
Print["\nLegendre (7|p):"];
Print["  (7|p) = +1: ", Select[dividingPrimes, JacobiSymbol[7, #] == 1 &]];
Print["  (7|p) = -1: ", Select[dividingPrimes, JacobiSymbol[7, #] == -1 &]];

(* Density *)
Print["\n=== DENSITY ==="];
Print["Dividing / Total up to 200: ", Length[dividing], "/", Length[primes],
      " = ", N[Length[dividing]/Length[primes], 4]];

(* OEIS lookup - print sequence for manual check *)
Print["\n=== SEQUENCE FOR OEIS ==="];
Print[dividingPrimes];

(* Look at gaps in dividing primes *)
Print["\n=== GAP ANALYSIS ==="];
gaps = Differences[dividingPrimes];
Print["Gaps: ", gaps];
Print["Gap counts: ", Counts[gaps]];
