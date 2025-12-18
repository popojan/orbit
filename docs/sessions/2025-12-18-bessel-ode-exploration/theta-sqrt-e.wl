(* Je limita θ_n(1/2)/(2n-1)!! = sqrt(e)? *)

Print["=== IS lim θ_n(1/2)/(2n-1)!! = √e? ===\n"];

theta[0, x_] := 1;
theta[1, x_] := 1 + x;
theta[n_, x_] := theta[n, x] = (2 n - 1) theta[n - 1, x] + x^2 theta[n - 2, x];

Print["n\tθ_n(1/2)/(2n-1)!!\t\tsqrt(e)"];
Print["--------------------------------------------------------"];
Table[
  ratio = N[theta[n, 1/2] / (2 n - 1)!!, 20];
  sqrtE = N[Sqrt[E], 20];
  diff = ratio - sqrtE;
  Print[n, "\t", ratio, "\t", sqrtE, "\tdiff=", diff];
  , {n, 1, 15}
];

Print["\n√e = ", N[Sqrt[E], 20]];

(* Asymptotická analýza *)
Print["\n=== ASYMPTOTIC ANALYSIS ==="];
Print["θ_{n+1}(x) = (2n+1)θ_n(x) + x²θ_{n-1}(x)"];
Print["Let r_n = θ_n(x)/(2n-1)!!"];
Print["Then: r_{n+1}·(2n+1)!! = (2n+1)·r_n·(2n-1)!! + x²·r_{n-1}·(2n-3)!!\n"];
Print["      r_{n+1} = r_n + x²·r_{n-1}/(2n-1)(2n+1)\n"];

Print["For large n, this becomes: r_{n+1} ≈ r_n + x²·r_∞/(4n²)"];
Print["So r_n converges to r_∞ with corrections O(1/n).\n"];

(* Numerický limit *)
Print["Numerical extrapolation of limit:"];
ratios = Table[N[theta[n, 1/2] / (2 n - 1)!!, 30], {n, 10, 50}];
Print["r_50 = ", Last[ratios]];
Print["√e   = ", N[Sqrt[E], 30]];
Print["Difference r_50 - √e = ", Last[ratios] - N[Sqrt[E], 30]];

(* Pokud konverguje k sqrt(e), pak: *)
Print["\n=== IF the limit is √e, THEN: ==="];
Print["θ_n(1/2) ~ √e · (2n-1)!! for large n"];
Print["This means K_{n+1/2}(1/2) ~ √(π/e) · √e · (2n-1)!! · 2^{n+1/2}"];
Print["                         = √π · (2n-1)!! · 2^{n+1/2}"];
Print["\nSo e cancels out in the leading asymptotics!"];
Print["But e re-enters through subleading corrections.\n"];

(* Explicitně: konvergence k sqrt(e)? *)
Print["=== TRYING TO PROVE lim = √e ==="];
Print["Consider generating function for θ_n:\n"];

(* GF: Σ θ_n t^n = ? *)
Print["From recursion: θ_{n+1} = (2n+1)θ_n + x²θ_{n-1}"];
Print["Let G(t) = Σ θ_n t^n. Multiply by t^{n+1} and sum...\n"];

(* Zkusíme vyřešit ODE symbolicky *)
Print["Alternative: θ_n satisfies x·θ'' - 2(n+x)·θ' + 2n·θ = 0"];
Print["At x=1/2: (1/2)·θ'' - 2(n+1/2)·θ' + 2n·θ = 0"];
Print["         θ'' - (4n+2)·θ' + 4n·θ = 0"];
Print["Characteristic: r² - (4n+2)r + 4n = 0"];
Print["r = (4n+2 ± sqrt((4n+2)² - 16n))/2 = (4n+2 ± sqrt(16n² + 16n + 4 - 16n))/2"];
Print["  = (4n+2 ± sqrt(16n² + 4))/2 = (4n+2 ± 2sqrt(4n² + 1))/2"];
Print["  = 2n+1 ± sqrt(4n² + 1)"];

