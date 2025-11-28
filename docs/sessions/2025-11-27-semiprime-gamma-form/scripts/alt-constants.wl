s = 91066911079434401364706972161062066528/100000000000000000000000000000000000000;

Print["Alternujici suma s = ", N[s, 25]]
Print[""]

Print["Hledani vztahu ke konstantam:"]
Print["  1 - s = ", N[1 - s, 20]]
Print["  s - 1 = ", N[s - 1, 20]]
Print["  1/s = ", N[1/s, 20]]
Print["  s^2 = ", N[s^2, 20]]
Print[""]

Print["Kombinace s Pi:"]
Print["  s * Pi = ", N[s * Pi, 20]]
Print["  s / Pi = ", N[s / Pi, 20]]
Print["  s + 1/Pi = ", N[s + 1/Pi, 20]]
Print[""]

Print["Kombinace s e:"]
Print["  s * E = ", N[s * E, 20]]
Print["  s + 1/E = ", N[s + 1/E, 20]]
Print["  E - 2*s = ", N[E - 2*s, 20]]
Print[""]

Print["Kombinace s ln(2):"]
Print["  s + ln(2) = ", N[s + Log[2], 20]]
Print["  s - ln(2) = ", N[s - Log[2], 20]]
Print["  s / ln(2) = ", N[s / Log[2], 20]]
Print[""]

Print["Jednoduche zlomky:"]
Print["  s * 11 = ", N[s * 11, 15]]
Print["  s * 10 = ", N[s * 10, 15]]
Print["  s * 9 = ", N[s * 9, 15]]
Print["  1 - s blizko 1/11? ", N[1/(1-s), 15]]
Print["  1 - s blizko 1/10? nope, 1/(1-s) = ", N[1/(1-s), 15]]
Print[""]

Print["Gamma/factorial vztahy:"]
Print["  Gamma[1/2] = Sqrt[Pi] = ", N[Sqrt[Pi], 15]]
Print["  s * Sqrt[Pi] = ", N[s * Sqrt[Pi], 15]]
