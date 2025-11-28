(* Varianty s ruznou horni mezi produktu *)

(* Original: produkt do i *)
f10orig[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])

(* Varianta: produkt do pevneho k *)
fFixedK[n_, k_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, k}]/(2 i + 1), {i, 0, n - 1}])

(* Varianta: produkt do i+1 (posunuto) *)
fShifted[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i + 1}]/(2 i + 1), {i, 0, n - 2}])

Print["Porovnani variant pro n = 15 = 3*5:"]
Print[""]
Print["Original f10[15] = ", f10orig[15]]
Print[""]

Print["Pevne k:"]
Do[
  val = fFixedK[15, k];
  Print["  k=", k, ": ", val, " = ", N[val, 8]],
  {k, 1, 5}
]
Print[""]

Print["Posunuta mez (i+1):"]
Print["  fShifted[15] = ", fShifted[15], " = ", N[fShifted[15], 8]]
Print[""]

(* Test faktorizace na variantach *)
Print["Faktorizace pres varianty:"]
n = 15;
Do[
  val = fFixedK[n, k];
  If[Head[val] === Rational || IntegerQ[val],
    den = Denominator[val];
    g = GCD[den, n];
    If[1 < g < n,
      Print["  k=", k, ": gcd(den, 15) = ", g, " FAKTOR!"]
    ]
  ],
  {k, 1, 10}
]
