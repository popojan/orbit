(* Limit sumy f[n] *)

Print["==============================================================="]
Print["  LIMIT SUMY Sum[f[n], n=2..inf]"]
Print["==============================================================="]
Print[""]

f[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])

(* Vysoká přesnost *)
Print["Parciální sumy s vysokou přesností:"]
partialSums = {};
runningSum = 0;
Do[
  runningSum += f[n];
  AppendTo[partialSums, runningSum],
  {n, 2, 50}
]

Print["Sum[f[n], n=2..50] = "]
Print[N[partialSums[[-1]], 50]]
Print[""]

(* Je to nějaká známá konstanta? *)
limit = partialSums[[-1]];
Print["Porovnání se známými konstantami:"]
Print["  Pi/3 = ", N[Pi/3, 20]]
Print["  E/e = 1"]
Print["  Sqrt[6]/Pi^2 = ", N[Sqrt[6]/Pi^2, 20]]
Print["  1 + 1/Pi^2 = ", N[1 + 1/Pi^2, 20]]
Print["  Nase suma ~ ", N[limit, 20]]
Print[""]

(* Zajímavé kombinace *)
Print["Hledání kombinací:"]
diff = limit - 1;
Print["  S - 1 = ", N[diff, 20]]
Print["  (S-1)*Pi^2/6 = ", N[diff*Pi^2/6, 20]]
Print["  (S-1)*12 = ", N[diff*12, 20]]
Print["  (S-1)*12/Log[2] = ", N[diff*12/Log[2], 20]]
Print[""]

(* Přesnější limit? *)
Print["Rozdíly mezi parciálními sumami (konvergence):"]
Do[
  diff = partialSums[[n]] - partialSums[[n - 1]];
  Print["  S_", n + 1, " - S_", n, " = ", N[diff, 6], " ~ f[", n + 1, "]"],
  {n, 10, 15}
]
Print[""]

Print["Exponenta poklesu (log|f[n]|/log(n)):"]
Do[
  fn = f[n];
  expo = Log[Abs[fn]]/Log[n];
  Print["  n=", n, ": exponent ~ ", N[expo, 4]],
  {n, 5, 15}
]
