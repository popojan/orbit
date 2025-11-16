# Technika Odečtení Singularit - Vysvětlení

**Date:** November 17, 2025
**Question:** Co znamená "odečtení singularit" pro analytické pokračování?
**Answer:** Konkrétní příklad s L_M(s)

---

## Problém: Integral Diverguje

**Máme:**
```
L_M(s) = 1/Γ(s) ∫₀^∞ t^{s-1} K(t) dt
```

**Pro Re(s) > 1:** Integral konverguje ✓

**Pro Re(s) ≤ 1:** Integral **diverguje** kvůli chování K(t) near t=0 ✗

---

## Analýza: Kde Je Problém?

**K(t) near t=0:**
```
K(t) ~ [ζ(s)-1]/t + [konečné členy] + O(t)
```

**Singularita:** 1/t jako t→0

**Integral:**
```
∫₀^1 t^{s-1} · [ζ(s)-1]/t dt = [ζ(s)-1] ∫₀^1 t^{s-2} dt
```

**Konvergence:**
```
∫₀^1 t^{s-2} dt = [t^{s-1}/(s-1)]₀^1
```

- Pokud Re(s-1) > 0 (tedy Re(s) > 1): konverguje k 1/(s-1)
- Pokud Re(s) ≤ 1: **diverguje**!

---

## Řešení: Odečti Problematický Člen

**Idea:** Víme co způsobuje divergenci ([ζ(s)-1]/t term). **Odečteme ho ručně!**

### Krok 1: Definuj Odečítací Funkci

```
σ(t) = [ζ(s)-1]/t · χ(t)
```

kde χ(t) je "cutoff":
```
χ(t) = { 1  pro t ∈ [0,1]
       { 0  pro t > 1
```

**Účel:** Odečíst singularitu POUZE v problematické oblasti [0,1].

### Krok 2: Regularizovaný Integrand

**Původní:**
```
I(t,s) = t^{s-1} K(t)  (diverguje pro Re(s) ≤ 1)
```

**Regularizovaný:**
```
I_reg(t,s) = t^{s-1} [K(t) - σ(t)]
           = t^{s-1} [K(t) - [ζ(s)-1]/t · χ(t)]
```

**Co se stane near t=0?**
```
K(t) ~ [ζ(s)-1]/t + A₀ + A₁·t + ...
σ(t) = [ζ(s)-1]/t  (v oblasti t < 1)

K(t) - σ(t) ~ A₀ + A₁·t + ...  (singularita ZMIZELA!)
```

**Nový integrand:**
```
I_reg ~ t^{s-1} · [A₀ + A₁·t + ...]
      = A₀·t^{s-1} + A₁·t^s + ...
```

**Konvergence:**
```
∫₀^1 t^{s-1} dt konverguje pro Re(s) > 0  (ne jen Re(s) > 1!)
```

**Rozšířili jsme domain!** Re(s) > 1 → Re(s) > 0

### Krok 3: Co Jsme Odečetli?

**Integrál odečteného termu:**
```
∫₀^∞ t^{s-1} σ(t) dt = ∫₀^1 t^{s-1} · [ζ(s)-1]/t dt
                      = [ζ(s)-1]/(s-1)
```

**Tento integrál ZNÁME EXPLICITNĚ!**

### Krok 4: Rekonstrukce

**Regularizovaný integral:**
```
L_M^{reg}(s) = 1/Γ(s) ∫₀^∞ t^{s-1} [K(t) - σ(t)] dt  (konverguje pro Re(s) > 0)
```

**Původní funkce:**
```
L_M(s) = L_M^{reg}(s) + 1/Γ(s) · [ζ(s)-1]/(s-1)
```

**Co jsme získali:**
- L_M^{reg}(s) je **analytická** pro Re(s) > 0 (integral konverguje)
- Odečtený term [ζ(s)-1]/(Γ(s)(s-1)) je **známá meromorphic funkce**
- **Součet** dává L_M(s) na VĚTŠÍ oblasti než původně!

---

## Analogie: Odstranění Kamene z Cesty

**Představ si:**

**Cesta** = integrál
**Kámen** = singularita 1/t
**Cíl** = dojít dál (extend domain)

**Bez odečtení:**
```
Jdeš po cestě → narazíš na kámen (t=0) → nemůžeš dál
```

**S odečtením:**
```
1. Vidíš kámen předem
2. Přesně víš jaký je (tvar [ζ(s)-1]/t)
3. Odstraníš ho (odečteš)
4. Pokračuješ dál po hladké cestě
5. Na konci kámen vrátíš zpátky (přičteš známý term)
```

**Výsledek:** Došel jsi dál než by šlo bez odstranění!

---

## Iterace: Odečti Více Termů

**K(t) near t=0 má expansion:**
```
K(t) ~ A₋₁/t + A₀ + A₁·t + A₂·t² + ...
```

**První odečtení:** Odstraníme A₋₁/t
- Domain: Re(s) > 1 → Re(s) > 0

**Druhé odečtení:** Odstraníme i A₀ (konstantní term)
```
K(t) - A₋₁/t - A₀ ~ A₁·t + A₂·t² + ...
```

**Integrand:**
```
t^{s-1} · [A₁·t + ...] ~ A₁·t^s + ...
```

**Konvergence:** Re(s) > -1 (ještě větší domain!)

**Třetí odečtení:** A₁·t term
- Domain: Re(s) > -2

**Iterací:** Postupně rozšiřujeme domain na **celé ℂ**!

---

## Proč To Funguje?

**Klíčový princip:**

Singularita v integrálu má **známou strukturu** (rozvoj do řady).

Každý term známe **explicitně**:
- ∫₀^1 t^{s-2} dt = 1/(s-1)
- ∫₀^1 t^{s-1} dt = 1/s
- ∫₀^1 t^s dt = 1/(s+1)
- atd.

**Odečteme co umíme spočítat** → zbyde **hladší integral** → ten konverguje na větší oblasti.

**Součet:**
```
[hladký integral] + [součet známých termů] = původní funkce
              ↓                    ↓
      analytická          meromorphní
```

**Celkově:** Meromorphní pokračování!

---

## Kde Jsou Póly?

**Po odečtení termů máme:**
```
L_M(s) = L_M^{reg}(s) + [ζ(s)-1]/(Γ(s)(s-1)) + ...
```

**Póly přicházejí z odečtených termů:**
- [ζ(s)-1]/(s-1) má pól at s=1
- 1/Γ(s) má póly at s=0,-1,-2,...

**L_M^{reg}(s) je analytická** (žádné póly).

**Výsledek:** Póly L_M jsou přesně tam kde očekáváme!

---

## Praktický Příklad s Čísly

**Chceme evaluate L_M(0.5):** (Re(s) = 0.5 < 1, původní integral diverguje)

### Bez odečtení:
```
∫₀^1 t^{-0.5} · [ζ(s)-1]/t dt = [ζ(s)-1] ∫₀^1 t^{-1.5} dt → ∞  (diverguje!)
```

### S odečtením:
```
L_M(0.5) = L_M^{reg}(0.5) + [ζ(0.5)-1]/(Γ(0.5)·(-0.5))
```

**L_M^{reg}(0.5):**
```
= 1/Γ(0.5) ∫₀^∞ t^{-0.5} [K(t) - [ζ(0.5)-1]/t·χ(t)] dt
```

Tento integral **konverguje**! (singularita odstraněna)

Můžeme ho numericky spočítat: ≈ nějaká hodnota

**Odečtený term:**
```
[ζ(0.5)-1]/(Γ(0.5)·(-0.5)) = známá hodnota (ζ a Γ umíme spočítat)
```

**Součet:** L_M(0.5) = [numerický integral] + [známý term] = konečná hodnota ✓

---

## Shrnutí

**"Odečtení singularit" znamená:**

1. **Identifikuj** co způsobuje divergenci (např. 1/t)
2. **Odečti** to z integrantu
3. **Spočítej** integral odečteného termu explicitně
4. **Zůstane** hladší integral (konverguje na větší oblasti)
5. **Přičti zpátky** známý term na konci
6. **Výsledek:** Původní funkce na větším domain!

**Je to jako:**
- Chirurgický zákrok: Odstraníme problém, operujeme, vrátíme zpět
- Rozklad úlohy: Těžký integral = [snadný hladký] + [známý explicitní]

**Pro L_M(s):**
- Původně: Re(s) > 1 (Dirichlet series)
- S odečtením: Celé ℂ (meromorphic)
- Póly: s=1 (double), s=0,-1,-2,... (simple)

**Proto integral representation > Dirichlet series** pro pokračování!
