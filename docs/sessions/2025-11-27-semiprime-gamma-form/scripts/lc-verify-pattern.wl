S10[n_] := Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}]
getA[n_] := Numerator[S10[n]]

Print["Test hypotezy: A = -q (mod p) pro p = 1 (mod 4)"]
Print[""]

primes = Select[Range[3, 47], PrimeQ];
mod1primes = Select[primes, Mod[#, 4] == 1 &];  (* 5, 13, 17, 29, 37, 41 *)

count = 0;
total = 0;

Do[
  p = mod1primes[[i]];
  Do[
    q = primes[[j]];
    If[p != q,
      n = p * q;
      A = getA[n];
      Amodp = Mod[A, p];
      predicted = Mod[-q, p];
      match = (Amodp == predicted);
      total++;
      If[match, count++];
      If[!match,
        Print["FAIL: n=", n, " p=", p, " q=", q, ": A mod p=", Amodp, " != -q=", predicted]
      ]
    ],
    {j, Length[primes]}
  ],
  {i, Length[mod1primes]}
]

Print[""]
Print["p = 1 (mod 4): ", count, "/", total, " shod = ", N[100*count/total, 4], "%"]
Print[""]

(* Ted pro p = 3 (mod 4) *)
Print["Test hypotezy pro p = 3 (mod 4): hledame vzorec"]
Print[""]

mod3primes = Select[primes, Mod[#, 4] == 3 &];  (* 3, 7, 11, 19, 23, 31, 43, 47 *)

(* Pro male p = 3: zvlastni pripady *)
(* Pro vetsi p = 3 (mod 4): zkusme A = -q * hf (mod p) *)

count3 = 0;
total3 = 0;

Do[
  p = mod3primes[[i]];
  hf = Mod[((p-1)/2)!, p];  (* = +1 nebo -1 *)
  Do[
    q = primes[[j]];
    If[p != q && p > 3,  (* vynechame p=3 *)
      n = p * q;
      A = getA[n];
      Amodp = Mod[A, p];
      (* Zkusime q * hf *)
      pred1 = Mod[q * hf, p];
      (* Zkusime -q * hf *)
      pred2 = Mod[-q * hf, p];
      (* Zkusime q *)
      pred3 = Mod[q, p];
      (* Zkusime -q *)
      pred4 = Mod[-q, p];
      
      total3++;
      matched = False;
      
      If[Amodp == pred1, 
        count3++;
        matched = True;
        (* Print["n=", n, " p=", p, ": A = q*hf"] *)
      ];
      If[!matched && Amodp == pred4,
        count3++;
        matched = True;
        (* Print["n=", n, " p=", p, ": A = -q"] *)
      ];
      If[!matched,
        Print["FAIL p=3(4): n=", n, " p=", p, " q=", q, ": A=", Amodp, 
              ", q*hf=", pred1, ", -q=", pred4, ", hf=", hf]
      ]
    ],
    {j, Length[primes]}
  ],
  {i, Length[mod3primes]}
]

Print[""]
Print["p = 3 (mod 4), p>3: ", count3, "/", total3, " shod"]
