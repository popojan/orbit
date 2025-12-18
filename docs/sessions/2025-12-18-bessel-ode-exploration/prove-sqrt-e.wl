(* Důkaz že lim θ_n(1/2)/(2n-1)!! = √e *)

Print["=== PROVING lim θ_n(x)/(2n-1)!! = e^{x/2} ===\n"];

(* Rekurence: θ_{n+1} = (2n+1)θ_n + x²θ_{n-1} *)
(* Definujme r_n = θ_n/(2n-1)!! *)

Print["Let r_n = θ_n(x)/(2n-1)!!"];
Print["Then:"];
Print["  r_{n+1}·(2n+1)!! = (2n+1)·r_n·(2n-1)!! + x²·r_{n-1}·(2n-3)!!"];
Print["  r_{n+1} = r_n + x²·r_{n-1}/((2n-1)(2n+1))\n"];

Print["Telescoping: r_n = r_1 + Σ_{k=1}^{n-1} x²·r_{k-1}/((2k-1)(2k+1))"];
Print["As n→∞: r_∞ = r_1 + x² Σ_{k=1}^∞ r_{k-1}/((2k-1)(2k+1))\n"];

Print["For large k, r_k → r_∞, so:"];
Print["r_∞ ≈ r_1 + x²·r_∞ · Σ_{k=1}^∞ 1/((2k-1)(2k+1))"];
Print["    = r_1 + x²·r_∞ · (1/2) Σ_{k=1}^∞ (1/(2k-1) - 1/(2k+1))"];
Print["    = r_1 + x²·r_∞ · (1/2) · 1  (telescope!)"];
Print["    = r_1 + x²·r_∞/2\n"];

Print["So: r_∞(1 - x²/2) = r_1"];
Print["    r_∞ = r_1/(1 - x²/2) = 2r_1/(2 - x²)\n"];

Print["At x = 1/2:"];
Print["r_1 = θ_1(1/2)/(1)!! = (1 + 1/2)/1 = 3/2"];
Print["r_∞ = 2·(3/2)/(2 - 1/4) = 3/(7/4) = 12/7 = ", N[12/7, 20]];
Print["But √e = ", N[Sqrt[E], 20], "\n"];

Print["PROBLEM: This naive approximation gives 12/7 ≈ 1.714, not √e ≈ 1.649"];
Print["The issue: r_k doesn't converge fast enough for the approximation r_k → r_∞\n"];

Print["=== MORE CAREFUL ANALYSIS ===\n"];

(* Přesnější: exponenciální generující funkce *)
Print["Try: Let F(t,x) = Σ_{n=0}^∞ θ_n(x) t^n / (2n-1)!!"];
Print["Then the recurrence gives a PDE for F.\n"];

(* Rekurence: θ_{n+1} = (2n+1)θ_n + x²θ_{n-1} *)
(* Děleno (2n+1)!!: θ_{n+1}/(2n+1)!! = θ_n/(2n-1)!! + x²θ_{n-1}/(2n+1)!! *)

Print["Divided by (2n+1)!!: r_{n+1} = r_n + x²·r_{n-1}/((2n-1)(2n+1))"];
Print["This is NOT a standard EGF/OGF due to the (2n-1)(2n+1) factor.\n"];

(* Zkusme Laplace-like asymptotiku *)
Print["=== LAPLACE-TYPE ASYMPTOTICS ==="];
Print["θ_n(x) satisfies: x·θ'' - 2(n+x)·θ' + 2n·θ = 0"];
Print["For large n, dominant balance gives θ ~ C(x)·(2n-1)!!·f(x)^n\n"];

Print["From recursion θ_{n+1}/θ_n → 2n+1 as n→∞,"];
Print["so θ_n ~ A(x)·(2n-1)!! where A(x) is the limit we seek.\n"];

Print["Better ansatz: θ_n(x) = A(x)·(2n-1)!!·(1 + B(x)/n + O(1/n²))"];
Print["Substituting into recursion...\n"];

(* Substituujme ansatz *)
Print["θ_{n+1} = A·(2n+1)!!·(1 + B/(n+1))"];
Print["(2n+1)·θ_n = (2n+1)·A·(2n-1)!!·(1 + B/n) = A·(2n+1)!!·(1 + B/n)"];
Print["x²·θ_{n-1} = x²·A·(2n-3)!!·(1 + B/(n-1))"];
Print["           = x²·A·(2n-1)!!/(2n-1)·(1 + B/(n-1))\n"];

Print["Recursion becomes:"];
Print["A(2n+1)!!(1+B/(n+1)) = A(2n+1)!!(1+B/n) + x²A(2n-1)!!/(2n-1)·(1+B/(n-1))"];
Print["1 + B/(n+1) = 1 + B/n + x²/(2n-1)(2n+1)·(1+B/(n-1))\n"];

Print["Leading order: 1 = 1 (ok)"];
Print["O(1/n): B/(n+1) - B/n = x²/(4n²) (for large n)"];
Print["       -B/n² ≈ x²/(4n²)"];
Print["       B = -x²/4\n"];

Print["But this doesn't determine A(x)! Need more careful analysis."];

