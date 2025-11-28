(* Singularity detection = factor finding! *)

Print["==============================================================="]
Print["  SINGULARITA V MOD ARITMETICE = FAKTOR"]
Print["==============================================================="]
Print[""]

Print["Pro n = p*q, hledáme i kde gcd(2i+1, n) > 1:"]
Print[""]

Do[
  factors = FactorInteger[n][[;;, 1]];
  p = factors[[1]];
  q = factors[[2]];
  
  Print["n = ", n, " = ", p, "*", q];
  Print["  Wilson body: (", p, "-1)/2 = ", (p - 1)/2, ", (", q, "-1)/2 = ", (q - 1)/2];
  
  (* Najdi singularity *)
  Do[
    g = GCD[2 i + 1, n];
    If[g > 1 && g < n,
      Print["  Singularita i=", i, ": gcd(", 2 i + 1, ", ", n, ") = ", g, " <- FAKTOR!"]
    ],
    {i, 1, 20}
  ];
  Print[""],
  {n, {15, 21, 35, 77, 143, 187}}
]

Print["==============================================================="]
Print["  ALGORITMUS: HLEDEJ SINGULARITY V 2i+1"]
Print["==============================================================="]
Print[""]

Print["Pro nalezení faktorů n stačí:"]
Print["  For i = 1, 2, 3, ..."]
Print["    g = gcd(2i+1, n)"]
Print["    If g > 1: FAKTOR = g"]
Print[""]

Print["Složitost: O(sqrt(n)) gcd výpočtů"]
Print["Každý gcd: O(log n)")  
Print["Celkem: O(sqrt(n) * log n)")
Print[""]

Print["SROVNÁNÍ:"]
Print["  Trial division: O(sqrt(n)) dělení")
Print["  Naše metoda:    O(sqrt(n) * log n) gcd")
Print["  Trial division vyhrává!")
Print[""]

Print["ALE: Naše metoda testuje jen LICHÁ čísla 2i+1!")
Print["     To je 2x méně testů než všechna čísla 1..sqrt(n)")
Print[""]

Print["ÚPRAVA trial division pro lichá:"]
Print["  Testuj 3, 5, 7, 9, 11, ... do sqrt(n)")
Print["  = O(sqrt(n)/2) testů")
Print[""]

Print["Takže obě metody mají zhruba stejnou složitost,")
Print["ale trial division je jednodušší.")
Print[""]

Print["==============================================================="]
Print["  JE TOHLE EKVIVALENTNÍ TRIAL DIVISION?"]
Print["==============================================================="]
Print[""]

Print["gcd(2i+1, n) > 1 <==> n mod (2i+1) = 0 nebo (2i+1) mod n > 1 s gcd>1")
Print["Pro 2i+1 < n: gcd(2i+1, n) > 1 <==> (2i+1) | n")
Print["")
Print["To JE trial division lichými čísly!")
Print["")
Print["Naše 'unit fraction' metoda redukuje na trial division.")
