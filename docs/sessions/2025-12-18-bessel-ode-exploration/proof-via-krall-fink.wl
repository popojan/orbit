(* DŮKAZ přes Krall-Fink formuli *)

Print["=== PROOF VIA KRALL-FINK FORMULA ===\n"];

(* Krall-Fink (1949): y_n(x) = sqrt(2/(πx)) e^{1/x} K_{n+1/2}(1/x) *)
Print["Krall-Fink formula:"];
Print["y_n(x) = sqrt(2/(πx)) · e^{1/x} · K_{n+1/2}(1/x)\n"];

(* Ověření *)
Print["Verification:"];
y[0, x_] := 1;
y[1, x_] := 1 + x;
y[n_, x_] := y[n, x] = (2 n - 1) x y[n - 1, x] + y[n - 2, x];

Table[
  yRec = y[n, x] /. x -> 2;
  yKF = Sqrt[2/(Pi 2)] Exp[1/2] BesselK[n + 1/2, 1/2] // N[#, 15] &;
  Print["n=", n, ": y_n(2) = ", yRec, ", Krall-Fink = ", yKF, 
    ", ratio = ", N[yRec/yKF, 10]];
  , {n, 0, 5}
];

Print["\n=== ASYMPTOTIC OF K_{n+1/2}(z) FOR LARGE n ==="];
Print["For large ν, fixed z:"];
Print["K_ν(z) ~ sqrt(π/2ν) · (ez/2ν)^{-ν}\n"];

Print["So K_{n+1/2}(1/x) ~ sqrt(π/(2n)) · (e/(2nx))^{-n} for large n"];
Print["                  = sqrt(π/(2n)) · (2nx/e)^n\n"];

Print["Substituting into Krall-Fink:"];
Print["y_n(x) ~ sqrt(2/(πx)) · e^{1/x} · sqrt(π/(2n)) · (2nx/e)^n"];
Print["       = sqrt(1/(nx)) · e^{1/x} · (2nx/e)^n"];
Print["       = e^{1/x} · (2x)^n · n^{n-1/2} / e^n"];
Print["       = e^{1/x} · (2x)^n · n^n / (e^n · sqrt(n))\n"];

Print["=== COMPARING WITH (2n-1)!! · x^n ==="];
Print["Stirling: (2n-1)!! = (2n)!/(2^n n!) ~ sqrt(2) · (2n/e)^n · sqrt(n)"];
Print["So (2n-1)!! ~ sqrt(2) · 2^n · n^n / e^n · sqrt(n)\n"];

Print["Therefore:"];
Print["y_n(x) / [(2n-1)!! · x^n]"];
Print["~ [e^{1/x} · (2x)^n · n^n / (e^n · sqrt(n))] / [sqrt(2) · 2^n · n^n · x^n / (e^n · sqrt(n))]"];
Print["= e^{1/x} · (2x)^n / (sqrt(2) · 2^n · x^n)"];
Print["= e^{1/x} · 2^n · x^n / (sqrt(2) · 2^n · x^n)"];
Print["= e^{1/x} / sqrt(2)  ???\n"];

Print["Hmm, off by sqrt(2). Let me recalculate more carefully...\n"];

(* Přesnější Stirling *)
Print["=== MORE CAREFUL STIRLING ==="];
Print["(2n-1)!! = 1·3·5·...·(2n-1) = (2n)! / (2^n · n!)"];
Print["Using Stirling: (2n)! ~ sqrt(4πn) (2n/e)^{2n}"];
Print["                n! ~ sqrt(2πn) (n/e)^n"];
Print["So (2n-1)!! ~ sqrt(4πn) (2n/e)^{2n} / (2^n · sqrt(2πn) (n/e)^n)"];
Print["            = sqrt(2) · (2n)^{2n} · e^n / (e^{2n} · 2^n · n^n)"];
Print["            = sqrt(2) · 4^n · n^{2n} · e^n / (e^{2n} · 2^n · n^n)"];
Print["            = sqrt(2) · 2^n · n^n / e^n\n"];

Print["So (2n-1)!! · x^n ~ sqrt(2) · (2nx)^n / e^n\n"];

Print["And y_n(x) ~ e^{1/x} · sqrt(1/(nx)) · (2nx)^n / e^n\n"];

Print["Ratio: y_n(x) / [(2n-1)!! · x^n]"];
Print["     ~ e^{1/x} · sqrt(1/(nx)) · (2nx)^n/e^n / [sqrt(2) · (2nx)^n/e^n]"];
Print["     = e^{1/x} / sqrt(2nx)\n"];

Print["This goes to 0, not e^{1/x}! The large-ν asymptotics is wrong.\n"];

Print["=== NEED DIFFERENT ASYMPTOTIC REGIME ==="];
Print["The K_ν(z) ~ sqrt(π/2ν)(ez/2ν)^{-ν} is for fixed z, large ν."];
Print["But we have z = 1/x fixed as n → ∞, which is the same regime."];
Print["Let me check numerically what ratio we actually get...\n"];

Table[
  yn = y[n, 1];
  df = (2 n - 1)!!;
  ratio = N[yn/df, 20];
  Print["n=", n, ": y_n(1)/(2n-1)!! = ", ratio];
  , {n, 50, 200, 50}
];

Print["\ne = ", N[E, 20]];

