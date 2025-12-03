(* Symbolic ContourIntegrate with multiple poles *)

betaExplicit[n_] := (n - Cos[Pi/n]/Sin[Pi/n])/(4n)
B[n_, k_] := 1 + betaExplicit[n] * Cos[(2k - 1) Pi/n]

Print["=== SYMBOLIC CONTOUR INTEGRATE - MULTIPLE POLES ==="];
Print[""];

(* Single pole works *)
Print["SINGLE POLE (n=1/2):"];
result1 = ContourIntegrate[B[z, 1], z \[Element] Circle[{1/2, 0}, 1/10]];
Print["Result: ", result1 // FullSimplify];
Print["Expected: 2πi × (1/(8π)) = i/4"];
Print[""];

(* Two poles *)
Print["TWO POLES (n=1/2 and n=1/3):"];
result2 = ContourIntegrate[B[z, 1], z \[Element] Circle[{5/12, 0}, 1/6]];
Print["Result: ", result2 // FullSimplify];
Print["Expected: 2πi(1/(8π) - 1/(12π)) = i/12 = ", N[I/12]];
Print[""];

(* Three poles *)
Print["THREE POLES (n=1/2, 1/3, 1/4):"];
result3 = ContourIntegrate[B[z, 1], z \[Element] Circle[{3/8, 0}, 1/5]];
Print["Result: ", result3 // FullSimplify];
Print["Expected: ", 2 Pi I (1/(8 Pi) - 1/(12 Pi) + 1/(16 Pi)) // FullSimplify];
Print[""];

(* Four poles *)
Print["FOUR POLES (n=1/2, 1/3, 1/4, 1/5):"];
(* Center around 3/10, radius to include all *)
result4 = ContourIntegrate[B[z, 1], z \[Element] Circle[{3/10, 0}, 1/4]];
Print["Result: ", result4 // FullSimplify];
Print[""];

(* Can we go to more? *)
Print["FIVE POLES:"];
result5 = ContourIntegrate[B[z, 1], z \[Element] Circle[{1/4, 0}, 3/10]];
Print["Result: ", result5 // FullSimplify];
Print[""];

Print["=== SHIFTED CIRCLE (many poles) ==="];
Print["Circle centered at 1/2, r=0.4 (encloses m>=3 poles)"];
result6 = ContourIntegrate[B[z, 1], z \[Element] Circle[{1/2, 0}, 2/5]];
Print["Result: ", result6 // FullSimplify];
