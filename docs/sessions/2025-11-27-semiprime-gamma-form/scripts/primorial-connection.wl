Hn[n_] := Sum[1/(2 i + 1), {i, 0, n - 1}]
Primorial[m_] := Product[Prime[i], {i, 1, PrimePi[m]}]
OddPrimorial[m_] := Product[Prime[i], {i, 2, PrimePi[m]}]  (* bez 2 *)

Print["Spojeni Hn s primorialem:"]
Print[""]

Do[
  n = {15, 21, 35, 77}[[i]];
  hn = Hn[n];
  hnDen = Denominator[hn];
  
  (* Licha prvocisla do 2n-1 *)
  maxOdd = 2*n - 1;
  oddPrim = OddPrimorial[maxOdd];
  
  Print["n=", n, ":"];
  Print["  2n-1 = ", maxOdd];
  Print["  OddPrimorial[", maxOdd, "] = ", oddPrim];
  Print["  Denominator[Hn] = ", hnDen];
  Print["  Pomer: ", hnDen / oddPrim];
  Print["  hnDen / oddPrim = ", FactorInteger[hnDen / oddPrim]];
  Print[""],
  {i, 4}
]

(* Klic: Hn = Sum[1/(2i+1)] ma jmenovatel ktery je nasobek primorialu *)
Print["Klic: Hn ma jmenovatel = OddPrimorial * (extra mocniny)"]
Print[""]

(* Jak to souvisi s nasi faktorizaci? *)
Print["Souvislost s faktorizaci:"]
Print["  Pro n = pq, kde p,q licha prvocisla < 2n-1:"]
Print["  Oba p i q deli jmenovatel Hn!")
Print["  Proto potrebujeme 'prekryt' tyto faktory v Pk.")
Print[""]

(* Primorial formule pro prvociselnost *)
Print["Pripomenuti: Primorial ve Wilson formuli"]
Print["  Primorial(m)/2 je jmenovatel sumy (-1)^i * i! / (2i+1)")
Print["  Viz half-factorial-numerator-theorem.tex")
