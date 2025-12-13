#!/usr/bin/env wolframscript
(* Rigorózní důkaz tranzitivity {silver, copper, inv} na Q⁺ *)
(* Date: 2025-12-13 *)
(* Key result: L = cicsis, R = csisii (projektivně) *)

(* --- Maticová reprezentace Möbiových transformací --- *)
(* (ax+b)/(cx+d) <-> [[a,b],[c,d]] v PSL_2 *)

mSilver = {{-1, 1}, {1, 1}};   (* silver(x) = (1-x)/(1+x) *)
mCopper = {{-1, 1}, {0, 1}};   (* copper(x) = 1-x *)
mInv = {{0, 1}, {1, 0}};       (* inv(x) = 1/x *)

(* Calkin-Wilf generátory *)
mL = {{1, 0}, {1, 1}};         (* L(x) = x/(1+x) *)
mR = {{1, 1}, {0, 1}};         (* R(x) = x+1 *)

(* --- Hlavní výpočet --- *)

(* L = cicsis *)
Lcalc = mCopper.mInv.mCopper.mSilver.mInv.mSilver;

(* R = csisii *)
Rcalc = mCopper.mSilver.mInv.mSilver.mInv.mInv;

(* --- Verifikace --- *)

If[$ScriptCommandLine =!= {},
  Print["=== RIGORÓZNÍ DŮKAZ TRANZITIVITY ===\n"];

  Print["Maticová reprezentace:"];
  Print["  silver: ", mSilver];
  Print["  copper: ", mCopper];
  Print["  inv:    ", mInv];
  Print[""];

  Print["Calkin-Wilf generátory:"];
  Print["  L = ", mL, "  (x -> x/(1+x))"];
  Print["  R = ", mR, "  (x -> x+1)"];
  Print[""];

  Print["Výpočet L = cicsis:"];
  Print["  copper.inv.copper.silver.inv.silver = ", Lcalc];
  Print["  = 2 * ", mL, " (projektivně ekvivalentní)"];
  Print[""];

  Print["Výpočet R = csisii:"];
  Print["  copper.silver.inv.silver.inv.inv = ", Rcalc];
  Print["  = 2 * ", mR, " (projektivně ekvivalentní)"];
  Print[""];

  Print["=== VĚTA ==="];
  Print["⟨silver, copper, inv⟩ působí TRANZITIVNĚ na Q⁺."];
  Print[""];
  Print["DŮKAZ:"];
  Print["1. L = cicsis, R = csisii (projektivně)"];
  Print["2. Calkin-Wilf (2000): ⟨L, R⟩ je tranzitivní na Q⁺"];
  Print["3. ⟨L, R⟩ ⊆ ⟨silver, copper, inv⟩"];
  Print["4. Tedy ⟨silver, copper, inv⟩ je tranzitivní. ∎"];
];
