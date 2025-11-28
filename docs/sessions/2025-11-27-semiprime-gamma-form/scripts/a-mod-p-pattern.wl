(* Pattern in A mod p *)

S10[n_] := Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}]

Print["A MOD p PATTERN"]
Print["==============="]
Print[""]

Print["A = Sum of (n^2-1)(n^2-4)...(n^2-i^2)/(2i+1) * n"]
Print[""]
Print["Mod p (where p | n, so n = 0):"]
Print["  Each term T[i]*n = n * (-j^2 products) / (2i+1)")
Print["                   = 0 * (...) = 0 (mod p)")
Print[""]
Print["Wait, that gives A = 0 mod p, which contradicts data!"]
Print[""]

Print["Let me recalculate S10 more carefully..."]
Print[""]

n = 15;
p = 3;
s10 = S10[n];
A = Numerator[s10];
B = Denominator[s10];
Print["n=15, p=3: A=", A, ", B=", B]
Print["A mod 3 = ", Mod[A, 3]]
Print[""]

Print["Individual terms:"]
Do[
  term = Product[n^2 - j^2, {j, 1, i}]/(2 i + 1);
  Print["  T[", i, "] = ", term, " = ", Numerator[term], "/", Denominator[term]],
  {i, 0, 5}
]
Print[""]

Print["Sum with common denominator:"]
Print["S10 = A/B where A and B might have common factors with n"]
Print[""]

(* Let's compute A directly *)
terms = Table[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}];
totalSum = Total[terms];
Print["S10 = ", totalSum]
Print["Numerator = ", Numerator[totalSum]]
Print["Denominator = ", Denominator[totalSum]]
Print[""]

Print["THE KEY: S10 = A/n, not A/1 !"]
Print["So A mod p is not the same as (sum of terms) mod p"]
Print[""]

Print["A/n = S10, so A = n * S10"]
Print[""]

aOverN = totalSum;
aValue = Numerator[aOverN] * n / Denominator[aOverN];
Print["A = ", aValue]
Print["Matches previous A? ", aValue == A]
Print[""]

Print["PATTERN IN A mod p:"]
Print["==================="]
Print[""]

semiprimes = {{15, 3, 5}, {21, 3, 7}, {35, 5, 7}, {55, 5, 11}, 
              {77, 7, 11}, {91, 7, 13}, {119, 7, 17}, {143, 11, 13}};

Do[
  {n, p, q} = tc;
  s10 = S10[n];
  A = Numerator[s10];
  
  AmodP = Mod[A, p];
  AmodQ = Mod[A, q];
  
  (* -1/A mod p *)
  invP = If[GCD[AmodP, p] == 1, PowerMod[AmodP, -1, p], "N/A"];
  invQ = If[GCD[AmodQ, q] == 1, PowerMod[AmodQ, -1, q], "N/A"];
  
  Print["n=", n, " (", p, "*", q, "): A mod ", p, "=", AmodP, 
        ", A mod ", q, "=", AmodQ,
        " -> -A^-1: ", If[invP === "N/A", "N/A", Mod[-invP, p]], ", ", 
        If[invQ === "N/A", "N/A", Mod[-invQ, q]]],
  {tc, semiprimes}
]
Print[""]

Print["OBSERVATION: A mod p is often 1, 2, 3, or 4"]
Print["This makes -A^-1 mod p small (= p-1, (p-1)/2, etc.)"]
Print[""]

Print["WHY IS A mod p SMALL?"]
Print["====================="]
Print[""]

Print["S10 involves sums of factorials squared divided by odds"]
Print["For p|n, the terms involve (-j^2) products mod p"]
Print["These accumulate to small residues due to cancellations"]
