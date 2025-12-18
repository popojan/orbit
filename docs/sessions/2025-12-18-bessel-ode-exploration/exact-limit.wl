(* Přesná hodnota limity r_∞ = lim θ_n(1/2)/(2n-1)!! *)

Print["=== EXACT LIMIT CALCULATION ===\n"];

theta[0, x_] := 1;
theta[1, x_] := 1 + x;
theta[n_, x_] := theta[n, x] = (2 n - 1) theta[n - 1, x] + x^2 theta[n - 2, x];

(* Vyšší přesnost *)
Print["High precision computation:"];
r200 = N[theta[200, 1/2] / (2*200 - 1)!!, 50];
Print["r_200 = ", r200];
Print["√e    = ", N[Sqrt[E], 50]];
Print["diff  = ", r200 - N[Sqrt[E], 50]];

(* Richardsonova extrapolace *)
Print["\n=== RICHARDSON EXTRAPOLATION ==="];
rn[k_] := N[theta[k, 1/2] / (2 k - 1)!!, 40];

(* Předpokládáme r_n = L + c/n + O(1/n²) *)
(* R(n, n') = (n'·r_n' - n·r_n)/(n' - n) eliminuje c/n člen *)
rich[n1_, n2_] := (n2 rn[n2] - n1 rn[n1])/(n2 - n1);

Print["Richardson extrapolations:"];
Print["R(100,200) = ", rich[100, 200]];
Print["R(150,200) = ", rich[150, 200]];
Print["R(180,200) = ", rich[180, 200]];

(* Zkusme ještě přesnější *)
Print["\nHigher order Richardson:"];
r2[n1_, n2_, n3_] := Module[{r12, r23},
  r12 = rich[n1, n2];
  r23 = rich[n2, n3];
  (n3^2 r23 - n1^2 r12)/(n3^2 - n1^2)
];
Print["R2(100,150,200) = ", r2[100, 150, 200]];

Print["\n√e              = ", N[Sqrt[E], 40]];

(* Možná je to jiná konstanta? *)
Print["\n=== OTHER CANDIDATES ==="];
Print["√e = ", N[Sqrt[E], 20]];
Print["√(e·4/π) = ", N[Sqrt[4 E/Pi], 20]];
Print["e/√π = ", N[E/Sqrt[Pi], 20]];
Print["Γ(3/2)·√e = ", N[Gamma[3/2] Sqrt[E], 20]];

(* Generující funkce přístup *)
Print["\n=== GENERATING FUNCTION APPROACH ==="];
Print["From K_{n+1/2}(x) = √(π/2x) e^{-x} θ_n(x)/x^{n+1/2}"];
Print["we have: Σ K_{n+1/2}(x) t^n = √(π/2x) e^{-x} Σ θ_n(x) (t/x)^n / √x\n"];

Print["Sum Σ K_{n+1/2}(x) t^n might have closed form..."];

(* Zkusme sumu K_{n+1/2}(1/2) *)
Print["\nSum of K_{n+1/2}(1/2):"];
sumK = Sum[N[BesselK[n + 1/2, 1/2], 20], {n, 0, 20}];
Print["Σ_{n=0}^{20} K_{n+1/2}(1/2) = ", sumK];

(* Vzorec pro sumu? *)
Print["\n=== CONNECTION TO KNOWN SUMS ==="];
Print["We know: Σ I_n(1) = e"];
Print["Is there: Σ K_{n+1/2}(1/2) = f(e,π)?"];

