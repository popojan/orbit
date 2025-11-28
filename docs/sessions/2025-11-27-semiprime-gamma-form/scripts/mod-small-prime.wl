(* Zkusime pocitat S10[n] mod male prvocislo m *)
(* Cil: detekovat singularitu bez plneho vypoctu *)

(* Problem: deleni (2i+1) neni definovane kdyz gcd(2i+1, m) > 1 *)

(* Ale: muzeme sledovat KDE nastane problem! *)

Print["Detekce singularity mod m:"]
Print[""]

n = 77;  (* = 7 * 11 *)
Print["n = 77 = 7 * 11"]
Print[""]

(* Pro m = 13 (koprime k n) *)
m = 13;
Print["Test mod m = ", m, " (koprime k n):"]
Do[
  term = Product[Mod[n^2 - j^2, m], {j, 1, i}];
  denom = 2*i + 1;
  gcdDenom = GCD[denom, m];
  
  If[gcdDenom > 1,
    Print["  i=", i, ": 2i+1=", denom, " nedelitelne mod ", m, " (gcd=", gcdDenom, ")"]
  ,
    denomInv = PowerMod[denom, -1, m];
    contrib = Mod[term * denomInv, m];
    Print["  i=", i, ": term=", term, ", contrib=", contrib]
  ],
  {i, 0, 15}
]
Print[""]

(* Pro m = 7 (faktor n!) *)
m = 7;
Print["Test mod m = ", m, " (faktor n!):"]
Do[
  term = Product[Mod[n^2 - j^2, m], {j, 1, i}];
  denom = 2*i + 1;
  gcdDenom = GCD[denom, m];
  
  If[gcdDenom > 1,
    Print["  i=", i, ": SINGULARITA! 2i+1=", denom, " = 0 mod ", m]
  ,
    denomInv = PowerMod[denom, -1, m];
    contrib = Mod[term * denomInv, m];
    (* Print["  i=", i, ": term=", term, ", contrib=", contrib] *)
  ],
  {i, 0, 10}
]
Print[""]

(* KLIC: singularita pri i=(m-1)/2 pro faktor m! *)
Print["KLIC: Singularita nastane pri i = (p-1)/2 pro faktor p|n"]
Print["  Pro n=77, p=7: singularita pri i = 3")
Print["  Pro n=77, q=11: singularita pri i = 5")
Print["")
Print["Takze: zkusime vsechna licha m a hledame kde 2i+1 = m deli n")
Print["  To je presne TRIAL DIVISION!")
