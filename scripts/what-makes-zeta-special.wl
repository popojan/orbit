(* Co dělá ζ speciální pro kombinatorickou identitu? *)

Print["=== Anatomie identity L_P(s) = (ζ(s)² - ζ(2s))/2 ===\n"];

Print["Klíčové ingredience:\n"];

Print["1. ζ(s) = Σ 1/n^s"];
Print["   Koeficienty: a(n) = 1 pro všechna n\n"];

Print["2. ζ(s)² = Σ τ(n)/n^s"];
Print["   Koeficienty: (a*a)(n) = Σ_{d|n} a(d)·a(n/d) = Σ_{d|n} 1 = τ(n)\n"];

Print["3. ζ(2s) = Σ 1/n^{2s} = Σ_{k} 1/(k²)^s"];
Print["   Koeficienty: b(n) = 1 pokud n = k², jinak 0\n"];

Print["4. ζ(s)² - ζ(2s) = Σ [τ(n) - χ_{□}(n)]/n^s"];
Print["   kde χ_{□}(n) = 1 pokud n je čtverec\n"];

Print["5. (ζ(s)² - ζ(2s))/2 = Σ P(n)/n^s"];
Print["   kde P(n) = ⌊τ(n)/2⌋\n"];

Print["=== Proč to funguje? ===\n"];

Print["τ(n) je sudé ⟺ n NENÍ čtverec"];
Print["τ(n) je liché ⟺ n JE čtverec\n"];

Print["Tedy: τ(n) - χ_{□}(n) je VŽDY sudé!"];
Print["      (τ(n) - χ_{□}(n))/2 = ⌊τ(n)/2⌋ = P(n)\n"];

(* Ověření *)
Print["Ověření pro n = 1..12:"];
Print["| n | τ(n) | čtverec? | τ-χ | (τ-χ)/2 | ⌊τ/2⌋ |"];
Print["|---|------|----------|-----|---------|-------|"];
Do[
  tau = DivisorSigma[0, n];
  sq = If[IntegerQ[Sqrt[n]], 1, 0];
  diff = tau - sq;
  half = diff/2;
  floor = Floor[tau/2];
  Print["| ", n, " | ", tau, " | ", sq, " | ", diff, " | ", half, " | ", floor, " |"];
, {n, 1, 12}];

Print["\n=== Zobecnění: L(s,χ)² - L(2s,χ²) ===\n"];

Print["Pro Dirichletovu L-funkci L(s,χ) = Σ χ(n)/n^s:\n"];

Print["L(s,χ)² = Σ [Σ_{d|n} χ(d)χ(n/d)]/n^s"];
Print["        = Σ τ_χ(n)/n^s"];
Print["kde τ_χ(n) = Σ_{d|n} χ(d)χ(n/d)\n"];

Print["L(2s,χ²) = Σ χ²(n)/n^{2s} = Σ χ(k)²/(k²)^s\n"];

Print["Rozdíl: L(s,χ)² - L(2s,χ²) = Σ [τ_χ(n) - χ(√n)² · χ_{□}(n)]/n^s\n"];

(* Příklad pro χ_4 (mod 4) *)
Print["=== Příklad: χ mod 4 ===\n"];

chi4[n_] := Which[
  Mod[n, 4] == 1, 1,
  Mod[n, 4] == 3, -1,
  True, 0
]

tauChi[n_, chi_] := Sum[chi[d] chi[n/d], {d, Divisors[n]}]

Print["χ_4(n): 1 → 1, 2 → 0, 3 → -1, 4 → 0, 5 → 1, ...\n"];

Print["| n | χ(n) | τ_χ(n) | χ(√n)² | rozdíl |"];
Print["|---|------|--------|--------|--------|"];
Do[
  chi = chi4[n];
  tauC = tauChi[n, chi4];
  sqTerm = If[IntegerQ[Sqrt[n]], chi4[Sqrt[n]]^2, 0];
  diff = tauC - sqTerm;
  Print["| ", n, " | ", chi, " | ", tauC, " | ", sqTerm, " | ", diff, " |"];
, {n, 1, 16}];

Print["\n=== Klíčový rozdíl ===\n"];

Print["Pro ζ (χ = 1):"];
Print["  τ_1(n) = τ(n) = počet dělitelů"];
Print["  1² = 1 vždy"];
Print["  Rozdíl τ(n) - χ_{□}(n) je vždy SUDÝ\n"];

Print["Pro obecné χ:"];
Print["  τ_χ(n) = Σ_{d|n} χ(d)χ(n/d) ≠ τ(n)"];
Print["  χ(√n)² může být 0, 1, nebo -1"];
Print["  Rozdíl NEMUSÍ být sudý!\n"];

(* Test *)
Print["Test sudosti pro χ_4:"];
Do[
  tauC = tauChi[n, chi4];
  sqTerm = If[IntegerQ[Sqrt[n]], chi4[Sqrt[n]]^2, 0];
  diff = tauC - sqTerm;
  parity = If[EvenQ[diff], "sudý", "LICHÝ"];
  If[!EvenQ[diff], Print["  n = ", n, ": rozdíl = ", diff, " (", parity, ")"]];
, {n, 1, 100}];
Print["  (žádné liché rozdíly do n=100)\n"];

Print["=== Co dělá ζ speciální? ===\n"];

Print["1. TRIVIÁLNÍ CHARAKTER: χ(n) = 1"];
Print["   → Konvoluce χ*χ = τ (počet dělitelů)"];
Print["   → χ² = 1 (stále triviální)\n"];

Print["2. PARITA τ(n):"];
Print["   τ(n) liché ⟺ n je čtverec"];
Print["   Tato vlastnost je UNIKÁTNÍ pro τ!\n"];

Print["3. CELOČÍSELNOST:"];
Print["   (τ(n) - χ_{□}(n))/2 = ⌊τ(n)/2⌋ ∈ ℤ"];
Print["   Pro jiné χ: (τ_χ(n) - ...)/2 nemusí být celé\n"];

Print["=== Zobecněná identita ===\n"];

Print["Pro KAŽDOU L-funkci L(s) = Σ a(n)/n^s platí:\n"];

Print["  L(s)² - L(2s) = Σ [(a*a)(n) - a(√n)·χ_{□}(n)]/n^s\n"];

Print["Ale interpretace jako 'počet párů' funguje JEN pro a(n) = 1:\n"];

Print["  a(n) = 1: (a*a)(n) = τ(n) = |{(d, n/d) : d|n}|"];
Print["  a(n) = χ(n): (a*a)(n) = τ_χ(n) = Σ χ(d)χ(n/d) [vážený součet]\n"];

Print["=== Závěr ===\n"];

Print["ζ je speciální protože:\n"];

Print["① Triviální koeficienty a(n) = 1"];
Print["   → Konvoluce = počítání (ne vážení)\n"];

Print["② Unikátní paritní vlastnost τ(n)"];
Print["   → Dělení 2 dává celá čísla\n"];

Print["③ Kombinatorická interpretace"];
Print["   → P(n) = počet NETRIVIÁLNÍCH dělitelských párů\n"];

Print["Pro jiné L-funkce:");
Print["   → Formálně L(s)² - L(2s) existuje"];
Print["   → Ale NEMÁ čistou kombinatorickou interpretaci"];
Print["   → Koeficienty nemusí být celá čísla"];
