(* Try to find closed form for #{odd} - #{even} *)
(* Key: n mod 2 = (a1*c1 + a2*c2 + a3*c3) mod 2 *)

Print["=== Analyzing the parity structure ===\n"];

Do[
  p1 = 5; p2 = pr2; p3 = pr3;
  If[p1 < p2 < p3,
    k = p1 p2 p3;

    (* CRT coefficients *)
    c1 = p2 p3 * PowerMod[p2 p3, -1, p1];
    c2 = p1 p3 * PowerMod[p1 p3, -1, p2];
    c3 = p1 p2 * PowerMod[p1 p2, -1, p3];

    (* Parities of ci *)
    b1 = Mod[c1, 2];
    b2 = Mod[c2, 2];
    b3 = Mod[c3, 2];

    (* n mod 2 = b1*a1 + b2*a2 + b3*a3 mod 2 *)
    Print["5*", p2, "*", p3, ": (b1,b2,b3) = (", b1, ",", b2, ",", b3, ")"];
  ],
  {pr2, Prime[Range[4, 10]]},
  {pr3, Prime[Range[5, 12]]}
];

Print["\n=== Key insight ==="];
Print["Since all primes > 2 are odd, M_i = k/p_i is always odd."];
Print["So c_i mod 2 = (M_i * e_i) mod 2 = e_i mod 2"];
Print["where e_i = M_i^{-1} mod p_i"];

Print["\n=== Let's compute the count directly ==="];

(* For a specific example, count by parity *)
p1 = 5; p2 = 11; p3 = 17;
k = p1 p2 p3;
c1 = p2 p3 * PowerMod[p2 p3, -1, p1];
c2 = p1 p3 * PowerMod[p1 p3, -1, p2];
c3 = p1 p2 * PowerMod[p1 p2, -1, p3];

(* In this case, (b1, b2, b3) = (1, 1, 1), so n mod 2 = (a1 + a2 + a3) mod 2 *)
Print["\nFor 5*11*17: n mod 2 = (a1 + a2 + a3) mod 2"];

(* Count signatures by (a1+a2+a3) mod 2, separating "primitive" condition *)
oddSum = 0; evenSum = 0;
Do[
  If[GCD[a1, p1] == 1 && GCD[a2, p2] == 1 && GCD[a3, p3] == 1,
    n = Mod[a1 c1 + a2 c2 + a3 c3, k];
    If[GCD[n - 1, k] == 1,
      parity = Mod[a1 + a2 + a3, 2];
      If[parity == 1, oddSum++, evenSum++]
    ]
  ],
  {a1, 1, p1 - 1},
  {a2, 1, p2 - 1},
  {a3, 1, p3 - 1}
];

Print["Odd sum count: ", oddSum];
Print["Even sum count: ", evenSum];
Print["Difference: ", oddSum - evenSum];

(* The primitive condition GCD(n-1, k) = 1 is the tricky part *)
(* Let's see what n-1 looks like in terms of CRT *)
Print["\n=== Analyzing n-1 condition ==="];
Print["n = a1*c1 + a2*c2 + a3*c3 mod k"];
Print["n - 1 mod p1 = a1*c1 - 1 mod p1 = a1*(p2*p3)*(p2*p3)^{-1} - 1 mod p1 = a1 - 1 mod p1"];
Print["Similarly, n - 1 mod pi = ai - 1 mod pi"];
Print["So GCD(n-1, k) = 1 iff a1 != 1 (mod p1) AND a2 != 1 (mod p2) AND a3 != 1 (mod p3)"];

(* Verify this *)
Print["\n=== Verify: primitive means ai != 1 for all i ==="];
violations = 0;
Do[
  If[GCD[a1, p1] == 1 && GCD[a2, p2] == 1 && GCD[a3, p3] == 1,
    n = Mod[a1 c1 + a2 c2 + a3 c3, k];
    primitive = GCD[n - 1, k] == 1;
    noOnes = (a1 != 1) && (a2 != 1) && (a3 != 1);
    If[primitive != noOnes, violations++]
  ],
  {a1, 1, p1 - 1},
  {a2, 1, p2 - 1},
  {a3, 1, p3 - 1}
];
Print["Violations: ", violations];

(* So primitive signatures are exactly those with:
   - ai in {2, ..., pi-1} for all i (coprime to pi and != 1)
   And parity is (a1 + a2 + a3) mod 2 when all ci are odd *)

Print["\n=== Simplified counting ==="];
Print["Primitive: ai in {2, ..., pi-1} for all i"];
Print["For p1=5: a1 in {2,3,4} -> 3 choices"];
Print["For p2=11: a2 in {2,...,10} -> 9 choices"];
Print["For p3=17: a3 in {2,...,16} -> 15 choices"];
Print["Total primitive: 3 * 9 * 15 = ", 3*9*15];

(* Actually verify *)
total = 0;
Do[
  If[(a1 >= 2 && a1 <= p1-1) && (a2 >= 2 && a2 <= p2-1) && (a3 >= 2 && a3 <= p3-1),
    total++
  ],
  {a1, 1, p1 - 1},
  {a2, 1, p2 - 1},
  {a3, 1, p3 - 1}
];
Print["Verified total: ", total];
