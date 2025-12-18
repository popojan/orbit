(* Asymptotika K_ν(x) pro velké ν *)

Print["=== ASYMPTOTIC K_ν(x) FOR LARGE ν ===\n"];

(* Známá asymptotika: K_ν(x) ~ √(π/2ν) (ex/2ν)^{-ν} pro velké ν, fixní x *)
Print["Standard asymptotic for large ν, fixed x:"];
Print["K_ν(x) ~ √(π/2ν) · (ex/2ν)^{-ν} · (1 + O(1/ν))\n"];

(* Pro K_{n+1/2}(1/2): *)
Print["For K_{n+1/2}(1/2), ν = n + 1/2 ≈ n:"];
Print["K_{n+1/2}(1/2) ~ √(π/2n) · (e·(1/2)/(2n))^{-n}"];
Print["              = √(π/2n) · (4n/e)^n"];
Print["              = √(π/2n) · 4^n · n^n / e^n\n"];

(* Porovnejme s θ_n representací *)
Print["From θ representation:"];
Print["K_{n+1/2}(1/2) = √π · e^{-1/2} · θ_n(1/2) · 2^{n+1/2} / (1/2)^{n+1/2}"];
Print["              = √π · e^{-1/2} · θ_n(1/2) · 2^{n+1/2} · 2^{n+1/2}"];
Print["              = √π · e^{-1/2} · θ_n(1/2) · 2^{2n+1}"];
Print["              = 2√π · θ_n(1/2) · 4^n / √e\n"];

(* Rovnost: *)
Print["Equating:"];
Print["√(π/2n) · 4^n · n^n / e^n = 2√π · θ_n(1/2) · 4^n / √e"];
Print["√(1/2n) · n^n / e^n = 2 · θ_n(1/2) / √e"];
Print["θ_n(1/2) = √e · √(1/2n) · n^n / (2e^n)"];
Print["         = √(e/8n) · n^n / e^n"];
Print["         = √(e/8n) · (n/e)^n\n"];

(* Stirling: n! ~ √(2πn)(n/e)^n, so (2n-1)!! ~ √(2/π) 2^n (n-1/2)^n *)
Print["Stirling for (2n-1)!!:");
Print["(2n-1)!! = (2n)!/(2^n n!) ~ √(2/π) · 2^n · n^n\n"];

Print["So θ_n(1/2)/(2n-1)!! ~ [√(e/8n) · (n/e)^n] / [√(2/π) · 2^n · n^n]"];
Print["                     = √(eπ/16n) · (n/e)^n / (2^n · n^n)"];
Print["                     = √(eπ/16n) · 1 / (2e)^n\n"];

Print["This goes to 0 for large n! Something is wrong...\n"];

(* Přepočítejme pečlivěji *)
Print["=== CAREFUL RECALCULATION ==="];

(* K_{n+1/2}(x) pro poloceločíselný řád má přesný vzorec *)
Print["For half-integer order:"];
Print["K_{n+1/2}(x) = √(π/2x) · e^{-x} · Σ_{k=0}^n (n+k)!/(k!(n-k)!) · (2x)^{-k}\n"];

(* At x = 1/2: *)
Print["At x = 1/2:"];
Print["K_{n+1/2}(1/2) = √π · e^{-1/2} · Σ_{k=0}^n (n+k)!/(k!(n-k)!) · 1^{-k}"];
Print["              = √(π/e) · Σ_{k=0}^n (n+k)!/(k!(n-k)!)"];
Print["              = √(π/e) · θ_n(1)   where θ_n(1) = y_n(1) (Bessel poly at 1)\n"];

(* Počkej, tohle není θ_n(1/2)! *)
Print["WAIT: This is θ_n(1), not θ_n(1/2)!"];
Print["Let me recalculate the K formula more carefully...\n"];

(* K_{n+1/2}(x) = √(π/2x) e^{-x} Σ (n+k)!/(k!(n-k)!) (2x)^{-k} *)
Print["K_{n+1/2}(x) = √(π/2x) e^{-x} Σ_{k=0}^n (n+k)!/(k!(n-k)!) (2x)^{-k}"];
Print["Let me verify numerically:\n"];

Table[
  exact = N[BesselK[n + 1/2, 1/2], 15];
  formula = N[Sqrt[Pi] Exp[-1/2] Sum[(n + k)!/((k)! (n - k)!), {k, 0, n}], 15];
  Print["n=", n, ": exact=", exact, ", formula=", formula, ", ratio=", exact/formula];
  , {n, 0, 4}
];

Print["\nThe formula sum is y_n(1) = θ_n(1), NOT θ_n(1/2)!"];
Print["So: K_{n+1/2}(1/2) = √(π/e) · y_n(1)"];
Print["And y_n(1) ~ √e · (2n-1)!! implies K_{n+1/2}(1/2) ~ √π · (2n-1)!!"];

