(* Summary: ω=4 Structure and Comparison to Permutations *)

Print["╔═══════════════════════════════════════════════════════════════════╗"];
Print["║  COMPARISON: PERMUTATION SIGNS vs PRIME TUPLE SIGNATURES          ║"];
Print["╚═══════════════════════════════════════════════════════════════════╝\n"];

Print["=== PERMUTATIONS ===\n"];
Print["  Object: σ ∈ Sₙ (permutation of n elements)"];
Print["  Sign: sgn(σ) = (-1)^{#inversions}"];
Print["  Properties:"];
Print["    - Binary: sgn(σ) ∈ {+1, -1}"];
Print["    - Multiplicative: sgn(στ) = sgn(σ)·sgn(τ)"];
Print["    - Transpositions: each transposition has sgn = -1"];
Print[""];

Print["=== OUR STRUCTURE ===\n"];
Print["  Object: k = p₁·p₂·...·pω (product of ω distinct odd primes > 2)"];
Print["  Value: Σsigns(k) = #{odd primitive lobes} - #{even primitive lobes}"];
Print[""];

Print["  Level-by-level structure:\n"];

Print["  ω = 2:"];
Print["    Σsigns(pq) = 1 - 4·ε_{pq}"];
Print["    where ε_{pq} = 1 if p⁻¹ mod q is even, 0 otherwise"];
Print["    Values: {+1, -3}"];
Print["    'Sign': ε_{pq} ∈ {0, 1}"];
Print[""];

Print["  ω = 3:"];
Print["    Σsigns(p₁p₂p₃) = 11 - 4·(#inv + #b)"];
Print["    where:"];
Print["      #inv = ε₁₂ + ε₁₃ + ε₂₃ (number of 'inversions')"];
Print["      #b = |{i : bᵢ = 1}| (CRT coefficient parities)"];
Print["    'Sign': (#inv + #b) mod 2"];
Print["    → Determines Σsigns mod 8"];
Print[""];

Print["  ω = 4:"];
Print["    Σsigns(p₁p₂p₃p₄) = sumTriples - sumPairs + correction"];
Print["    where:"];
Print["      sumPairs = Σᵢ<ⱼ Σsigns(pᵢpⱼ)"];
Print["      sumTriples = Σᵢ<ⱼ<ₖ Σsigns(pᵢpⱼpₖ)"];
Print["      correction = f(ε, b₄, b₁₂₃, b₁₂₄, b₁₃₄, b₂₃₄)"];
Print["    'Sign': NOT a simple scalar! Requires full multi-level pattern."];
Print[""];

Print["=== KEY DIFFERENCE ===\n"];
Print["  Permutations: Sign is a GLOBAL PARITY (one bit)"];
Print["  Our structure: 'Sign' is a HIERARCHICAL PATTERN"];
Print[""];
Print["  For ω = 2, 3: Still reducible to a single parity"];
Print["  For ω ≥ 4: Requires full CRT structure at all levels"];
Print[""];

Print["=== CONJECTURES ===\n"];
Print["  1. Σsigns(k) ≡ 1 - 2ω (mod 4) for all ω [VERIFIED for ω ≤ 6]"];
Print["  2. Σsigns is determined by (ε-pattern, all b-patterns) [VERIFIED for ω ≤ 4]"];
Print["  3. Recursive structure: Σsigns_ω = f(Σsigns_{ω-1}, Σsigns_{ω-2}, ..., correction)"];
Print[""];

Print["=== WHY THE EXTRA COMPLEXITY? ===\n"];
Print["  CRT introduces 'carries' when reconstructing n from (a₁, ..., aω)"];
Print["  These carries create additional structure beyond simple inversions"];
Print["  The b-vector encodes parity information about CRT coefficients"];
Print["  For ω ≥ 4, interactions between b-vectors at different levels matter"];
