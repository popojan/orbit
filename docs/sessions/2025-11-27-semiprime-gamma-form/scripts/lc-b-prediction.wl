S10[n_] := Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}]
getA[n_] := Numerator[S10[n]]

Print["Verifikace: b = +/- q^(-1) (mod p)"]
Print[""]

primes = Select[Range[3, 31], PrimeQ];
semis = {};

Do[
  p = primes[[i]];
  q = primes[[j]];
  If[p < q,
    n = p * q;
    A = getA[n];
    
    (* Skutecne b *)
    bActual = PowerMod[-A, -1, p];
    If[bActual > p/2, bActual = bActual - p];
    
    (* Predikce z q^-1 *)
    qInv = PowerMod[q, -1, p];
    bPred1 = Mod[qInv, p];  (* pokud A = -q *)
    bPred2 = Mod[-qInv, p]; (* pokud A = q *)
    If[bPred1 > p/2, bPred1 = bPred1 - p];
    If[bPred2 > p/2, bPred2 = bPred2 - p];
    
    match = (bActual == bPred1 || bActual == bPred2);
    
    Print["n=", n, " (", p, "*", q, "): b_actual=", bActual, 
          ", q^-1=", qInv, " (", If[bActual == bPred1, "match +", 
                                    If[bActual == bPred2, "match -", "NO MATCH"]], ")"]
  ],
  {i, 1, 5}, {j, i+1, 6}
]

Print[""]
Print["VYZNAM: Kdybychom znali p, mohli bychom spocitat b = +/- q^(-1) mod p"]
Print["Ale q = n/p, takze b = +/- (n/p)^(-1) = +/- p/n mod p = +/- p * n^(-1) mod p"]
Print[""]

(* Overme *)
Print["Test: b = +/- p * n^(-1) (mod p)?"]
Do[
  p = primes[[i]];
  q = primes[[j]];
  If[p < q,
    n = p * q;
    A = getA[n];
    bActual = PowerMod[-A, -1, p];
    If[bActual > p/2, bActual = bActual - p];
    
    (* p * n^(-1) mod p = ? *)
    (* n = pq, n^(-1) mod p neexistuje! (n = 0 mod p) *)
    (* Takze tento pristup nefunguje *)
  ],
  {i, 1, 3}, {j, i+1, 4}
]
Print["  n = 0 (mod p), takze n^(-1) mod p neexistuje")
Print[""]

Print["Zaver: Vzorec A = +/- q (mod p) vysvetluje, proc b je funkci q mod p,"]
Print["       ale stale potrebujeme znat p k vypoctu b.")
