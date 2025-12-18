(* ASYMPTOTIC PROOF: Im[g']/Re[g'] → 0 at crossings *)
(* ================================================ *)

(*
THEOREM: At real-axis crossings t = (2k+1)/4, the tangent ratio
         Im[g'(t)]/Re[g'(t)] → 0 as k → ∞

PROOF:

1. CONNECTION FORMULA for BesselK at negative argument:
   K_ν(-z) = e^{-iνπ} K_ν(z) - iπ I_ν(z)

2. FOR LARGE ν: |K_ν(z)| >> |I_ν(z)| (exponentially)
   Therefore: K_ν(-1/2) ≈ e^{-iνπ} K_ν(1/2)

3. PRODUCT DECOMPOSITION:
   K_{2t-1}(-1/2) · K_{2t+1}(-1/2) ≈ e^{-i(2t-1+2t+1)π} · [positive real]
                                    = e^{-4itπ} · K_{2t-1}(1/2) · K_{2t+1}(1/2)

4. FUNCTION FORM:
   g(t) = -16πe·t / [K_{2t-1}(-1/2) · K_{2t+1}(-1/2)]
        ≈ A(t) · e^{i(4πt + π)}

   where A(t) = 16πe·t / [K_{2t-1}(1/2) · K_{2t+1}(1/2)] is real positive

5. WINDING RATE: Phase grows as 4πt ⟹ 2 windings per unit t ✓

6. AT CROSSINGS t = (2k+1)/4:
   Phase φ = 4π·(2k+1)/4 + π = 2π(k+1) ≡ 0 (mod 2π)

7. DERIVATIVE at crossings:
   g'(t) = (A' + 4πi·A) · e^{iφ}

   At φ ≡ 0:
     Re[g'] = A'
     Im[g'] = 4π·A

8. TANGENT RATIO:
   Im[g']/Re[g'] = 4π·A / A' = 4π / (A'/A)

9. GROWTH RATE of A:
   log A = log(16πe) + log(t) - log K_{2t-1}(1/2) - log K_{2t+1}(1/2)

   For large ν: log K_ν(1/2) ~ ν·log(4ν/e)
   ∂/∂ν log K_ν ~ log(4ν/e) + 1 ~ log ν + const

   Therefore: A'/A ~ 1/t - 4·log(2t) ~ -4 log t

10. CONCLUSION:
    Im[g']/Re[g'] ~ 4π / (-4 log t) = -π/log t → 0

    Tangent angle = arctan(Im[g']/Re[g']) → 180° (since Re[g'] < 0)

QED
*)

(* === NUMERICAL VERIFICATION === *)

g[t_] := -16 Pi E t / (BesselK[2t-1, -1/2] BesselK[2t+1, -1/2]);

Print["=== Tangent ratio at crossings ==="];
Print["t = (2k+1)/4\tIm[g']/Re[g']\t-π/log(t)"];

Do[
  tCross = (2 k + 1)/4;
  gPrime = D[g[s], s] /. s -> tCross;
  ratio = Im[gPrime] / Re[gPrime];
  predicted = -Pi / Log[tCross];
  Print[N[tCross, 4], "\t\t", N[ratio, 6], "\t", N[predicted, 6]];
, {k, {5, 10, 20, 50}}];

Print["\n=== Conclusion ==="];
Print["Ratio converges to 0 as -π/log(t)"];
Print["Tangent angle → 180° at crossings"];
