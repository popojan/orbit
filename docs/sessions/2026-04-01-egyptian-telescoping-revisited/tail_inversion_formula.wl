(* Practical use of the tail inversion formula *)
(* T_N(s) = (1/v²)^s [Zeta[s, 1+u/v] - Σ_k=1^N 1/(u/v+k)^s] *)

Print["=== TAIL INVERSION FORMULA: Praktické Použití ===\n"];

(* Setup *)
n = 77;
u = 7;
v = 11;

tail[m_] := 1/(n + v^2*m)

Print["n = ", n, " = ", u, " × ", v];
Print["tail_m = 1/(", n, " + ", v^2, "m)\n"];

(* Define the inversion formula *)
tailPartialSum[s_, N_] := (1/v^2)^s * (
  Zeta[s, 1 + u/v] - Sum[1/(u/v + k)^s, {k, 1, N}]
);

Print["Inverzní formule: T_N(s) = (1/v²)^s [ζ(s, 1+u/v) - Σ_{k=1}^N 1/(u/v+k)^s]\n"];

(* Example: Different split points *)
Print["=== Příklad: Tail suma pro různá N (s=2) ===\n"];
Print["N    Numericky (m→∞)   Formule (Zeta)   Chyba"];
Print[StringRepeat["-", 60]];

splits = {1, 2, 3, 5, 10, 20};

For[idx = 1, idx <= Length[splits], idx++,
  N_val = splits[[idx]];

  (* Numerické: přímý součet do m=100 *)
  numeric = Sum[tail[m]^2, {m, N_val+1, 100}] // N;

  (* Formule: Zeta *)
  formula = tailPartialSum[2, N_val] // N;

  error = Abs[numeric - formula];

  Print[
    ToString[N_val] <> "     ",
    NumberForm[numeric, {15, 10}],
    "  ",
    NumberForm[formula, {15, 10}],
    "  ",
    NumberForm[error, {8, 1}]
  ]
];

Print["\n\n=== Praktický Případ: n=77, split v m=5 ===\n"];

N_split = 5;
s = 2;

(* Truncated sum (prvních 5 termů) *)
S_5 = Sum[tail[m], {m, 1, N_split}] // N;

(* Zbytek (tail) *)
T_5_numeric = Sum[tail[m], {m, N_split+1, 100}] // N;
T_5_formula = tailPartialSum[1, N_split] // N;

(* Součet (měl by se rovnat 1/77) *)
total = S_5 + T_5_numeric;

Print["Truncated sum S_5 = Σ_{m=1}^5 tail_m = ", NumberForm[S_5, {15, 12}]];
Print["Tail sum T_5 (numericky) = ", NumberForm[T_5_numeric, {15, 12}]];
Print["Tail sum T_5 (formule) = ", NumberForm[T_5_formula, {15, 12}]];
Print["Součet = ", NumberForm[total, {15, 12}]];
Print["1/77 = ", NumberForm[1/77 // N, {15, 12}]];
Print["Chyba = ", NumberForm[Abs[total - 1/77], {8, 2}]];

Print["\n\n=== Výhody Formule ===\n"];
Print["1. Numericky PŘESNÁ: nepotřebujeme dlouhé sumy"];
Print["2. Analyticky ČISTÁ: jde skrz Zetu (speciální funkce)"];
Print["3. UNIVERZÁLNÍ: funguje pro libovolné s ≥ 2"];
Print["4. EFEKTIVNÍ: 1 Zeta evaluation + N termů vs. sumace do ∞"];

Print["\n\n=== Teoretická Hluboká Myšlenka ===\n"];
Print["Místo aby tailů jednotkových zlomků byly 'jen' čísla,"];
Print["jsou vlastně 'kusy' Riemannovy zety!"];
Print[""];
Print["Pokud víme, jak se změní tail pod mocněním:"];
Print["  T_N(1) = diverguje"];
Print["  T_N(2) = ψ'(...)/v^4"];
Print["  T_N(3) = ψ''(...)/v^6"];
Print[""];
Print["Pak máme otevřeni dveře do analytického světa:"];
Print["  - Komplexní s → analytické pokračování"];
Print["  - Póly a rezidua → struktura tailů"];
Print["  - Funkcionální rovnice ζ → symetrie tailů"];

Print["\n=== ZÁVĚR ==="];
Print["Tailů jednotkových zlomků = evaluace Hurwitzovy zety"];
Print["Jejich mocniny = evaluace polygamma funkcí"];
Print["Částečné součty = Zeta − konečná korekce"];
Print["Toto PROPOJUJE:"];
Print["  → Egyptian fractions"];
Print["  → Analytic number theory"];
Print["  → Special functions (ζ, ψ, Γ)"];
