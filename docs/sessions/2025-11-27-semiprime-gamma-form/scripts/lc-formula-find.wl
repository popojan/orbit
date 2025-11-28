S10[n_] := Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}]
getA[n_] := Numerator[S10[n]]

(* Hledame vzorec: A = f(q, halfFact, p) mod p *)
(* kde f je jednoducha funkce *)

Print["Systematicke hledani vzorce A mod p:"]
Print[""]

(* Vetsí dataset *)
primes = Select[Range[3, 29], PrimeQ];
data = {};

Do[
  p = primes[[i]];
  q = primes[[j]];
  If[p != q,
    n = p * q;
    A = getA[n];
    Amodp = Mod[A, p];
    halfP = (p-1)/2;
    hf = Mod[halfP!, p];
    pMod4 = Mod[p, 4];
    qMod = Mod[q, p];
    
    AppendTo[data, {n, p, q, Amodp, hf, pMod4, qMod}]
  ],
  {i, Length[primes]}, {j, Length[primes]}
];

(* Pro p = 3 (mod 4), halfFact = +/-1 *)
Print["p = 3 (mod 4) pripady:"]
mod3data = Select[data, #[[6]] == 3 &];
Do[
  {n, p, q, Amodp, hf, pMod4, qMod} = mod3data[[k]];
  (* hf = +1 nebo p-1 *)
  predicted = Mod[qMod * hf, p];
  match = (Amodp == predicted);
  If[!match,
    Print["n=", n, " p=", p, ": A=", Amodp, " != q*hf=", predicted, " (hf=", hf, ", q=", qMod, ")"]
  ],
  {k, Length[mod3data]}
]
Print["  Vsechny shody: ", AllTrue[mod3data, Mod[#[[7]] * #[[5]], #[[2]]] == #[[4]] &]]
Print[""]

(* Pro p = 1 (mod 4), halfFact^2 = -1 *)
Print["p = 1 (mod 4) pripady:"]
mod1data = Select[data, #[[6]] == 1 &];
Do[
  {n, p, q, Amodp, hf, pMod4, qMod} = mod1data[[k]];
  (* Zkusime ruzne formule *)
  t1 = Mod[qMod * hf, p];
  t2 = Mod[-qMod * hf, p];
  t3 = Mod[qMod * hf^2, p];  (* = -qMod mod p *)
  t4 = Mod[qMod^2 * hf, p];
  qInv = PowerMod[qMod, -1, p];
  t5 = Mod[qInv * hf, p];
  
  Print["n=", n, " p=", p, ": A=", Amodp, 
        ", q*hf=", t1, ", -q*hf=", t2, ", -q=", Mod[-qMod, p],
        ", q^2*hf=", t4],
  {k, Min[10, Length[mod1data]]}
]
Print[""]

(* Zkusme univerzalni vzorec *)
Print["Test univerzalniho vzorce: A = q * (-1)^((p-1)/2) * hf^2 / something"]
Do[
  {n, p, q, Amodp, hf, pMod4, qMod} = data[[k]];
  halfP = (p-1)/2;
  signP = (-1)^halfP;
  hf2 = Mod[hf^2, p];  (* = (-1)^((p+1)/2) mod p by Stickelberger *)
  
  predicted = Mod[qMod * signP * hf2, p];
  If[Amodp != predicted && k <= 15,
    Print["n=", n, " p=", p, ": A=", Amodp, ", predicted=", predicted]
  ],
  {k, Length[data]}
]
