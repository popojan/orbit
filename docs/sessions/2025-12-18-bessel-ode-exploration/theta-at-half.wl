(* θ_n(1/2) a spojení s e *)

Print["=== θ_n AT x = 1/2 ===\n"];

(* Definice θ_n přes rekurenci *)
theta[0, x_] := 1;
theta[1, x_] := 1 + x;
theta[n_, x_] := theta[n, x] = (2 n - 1) theta[n - 1, x] + x^2 theta[n - 2, x];

Print["θ_n(1/2) values:"];
Table[
  val = theta[n, 1/2];
  Print["θ_", n, "(1/2) = ", val, " = ", N[val, 10]];
  , {n, 0, 8}
];

(* K_{n+1/2}(1/2) přes θ *)
Print["\n=== K_{n+1/2}(1/2) via θ_n ==="];
Print["K_{n+1/2}(x) = sqrt(π/2x) e^{-x} θ_n(x) / x^{n+1/2}\n"];

Table[
  kExact = N[BesselK[n + 1/2, 1/2], 15];
  kViaTheta = N[Sqrt[Pi] Exp[-1/2] theta[n, 1/2] / (1/2)^(n + 1/2), 15];
  Print["K_{", n, "+1/2}(1/2) = ", kExact];
  Print["  via θ: ", kViaTheta];
  Print["  ratio: ", kExact/kViaTheta];
  , {n, 0, 3}
];

(* Poměry θ_{n+1}/θ_n při x=1/2 *)
Print["\n=== RATIO θ_{n+1}/θ_n at x=1/2 ==="];
Table[
  ratio = theta[n + 1, 1/2] / theta[n, 1/2] // N;
  Print["θ_", n + 1, "/θ_", n, " at x=1/2 = ", ratio];
  , {n, 0, 7}
];

(* Limitní chování *)
Print["\n=== ASYMPTOTIC: θ_n(x) for large n ==="];
Print["From recurrence θ_{n+1} = (2n+1)θ_n + x²θ_{n-1}"];
Print["For large n: θ_{n+1}/θ_n → 2n+1 (dominant term)\n"];

Print["Product: θ_n(x) ~ x² · 1·3·5·...·(2n-1) = x² (2n-1)!! for large n"];
Print["Actually: θ_n(1/2) grows like (2n-1)!!\n"];

Table[
  thetaVal = theta[n, 1/2] // N;
  doubleFactorial = (2 n - 1)!! // N;
  ratio = thetaVal / doubleFactorial;
  Print["θ_", n, "(1/2) = ", thetaVal, ", (2n-1)!! = ", doubleFactorial, ", ratio = ", ratio];
  , {n, 1, 6}
];

(* KLÍČ: jak θ_n souvisí s e? *)
Print["\n=== KEY: Connection to e ==="];
Print["At x=1/2: K_{n+1/2}(1/2) = sqrt(π) e^{-1/2} · θ_n(1/2) · 2^{n+1/2}"];
Print["         = sqrt(π/e) · θ_n(1/2) · 2^{n+1/2}\n"];

Print["So e^{1/2} appears directly in K_{n+1/2}(1/2)!"];
Print["sqrt(e) = ", N[Sqrt[E], 15]];
Print["sqrt(π/e) = ", N[Sqrt[Pi/E], 15]];

(* Produkt K_{n-1/2} K_{n+1/2} *)
Print["\n=== Product K_{n-1/2}(1/2) · K_{n+1/2}(1/2) ==="];
Table[
  prod = N[BesselK[n - 1/2, 1/2] BesselK[n + 1/2, 1/2], 15];
  Print["n=", n, ": K_{", n - 1/2, "}·K_{", n + 1/2, "} = ", prod];
  , {n, 1, 5}
];

Print["\nThese products involve π/e · θ_{n-1}·θ_n · 2^{2n}"];

