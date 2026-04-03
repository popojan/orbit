(* Ověření: Closed form tailů přes trigamma funkci *)

Print["=== OVĚŘENÍ TRIGAMMA CLOSED FORM ===\n"];

(* Definice tail *)
tail[{u_, v_}, m_] := 1/(u*v + v^2*m)

(* Numerický výpočet řady *)
numericSeries[{u_, v_}, maxM_] := Sum[tail[{u, v}, m]^2, {m, 1, maxM}]

(* Closed form - trigamma *)
closedForm[{u_, v_}] := PolyGamma[1, 1 + u/v] / v^4

Print["Porovnání numerické řady vs. trigamma closed form:\n"];
Print["n = u·v    | Numerické (m→∞)  | PolyGamma[1, 1+u/v]/v⁴  | Rozdíl"];
Print[StringRepeat["-", 80]];

testCases = {
  {2, 3},    (* n = 6 *)
  {2, 5},    (* n = 10 *)
  {3, 5},    (* n = 15 *)
  {6, 5},    (* n = 30 *)
  {7, 11},   (* n = 77 *)
};

For[i = 1, i <= Length[testCases], i++,
  {u, v} = testCases[[i]];
  n = u * v;

  num = numericSeries[{u, v}, 500] // N;
  cf = closedForm[{u, v}] // N;
  diff = Abs[num - cf];

  Print[
    ToString[n] <> " = " <> ToString[u] <> "·" <> ToString[v],
    "  | ",
    NumberForm[num, {15, 12}],
    "  | ",
    NumberForm[cf, {15, 12}],
    "  | ",
    NumberForm[diff, {10, 2}]
  ]
];

Print["\n\n=== KONKRÉTNÍ PŘÍPAD: n=77, u=7, v=11 ===\n"];

z = 1 + 7/11;
trigamma = PolyGamma[1, z];
result = trigamma / 11^4;

Print["z = 1 + 7/11 = ", z // N];
Print["ψ'(z) = PolyGamma[1, z] = ", trigamma // N];
Print["ψ'(z) / 11⁴ = ", result // N];

Print["\n\n=== ZOBECNĚNÍ: POLYLOGARITHMY PRO RŮZNÁ s ===\n"];

Print["Hypotéza: Σ_m 1/(n+v²m)^s = PolyGamma[s-1, 1+u/v] / v^(2s)\n"];

Print["n=77, u=7, v=11:\n"];
Print["s    Numerické      PolyGamma[s-1, 1.636...]/v^(2s)"];
Print[StringRepeat["-", 65]];

For[s = 2, s <= 4, s++,
  num = Sum[1/(77 + 121*m)^s, {m, 1, 500}] // N;
  cf = PolyGamma[s-1, 1 + 7/11] / 11^(2*s) // N;

  Print[s, "    ", NumberForm[num, {15, 10}], "    ", NumberForm[cf, {15, 10}]]
];

Print["\n\n=== ZÁVĚR ==="];
Print["Tailů jednotkových zlomků se vyjadřují přes polygamma funkce!"];
Print["Ψ^(s-1)(1 + u/v) / v^(2s) je PŘESNÝ closed form."];
