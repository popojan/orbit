pslv[nn_] := {x, y} /. First@FindInstance[x x - nn y y == 1, {x, y}, PositiveIntegers]

Print["=== CORRECTED: y_n = c * Y, always integer! ===\n"];
Print["x² - c²n·Y² = 1  =>  x² - n·(cY)² = 1  =>  y = cY\n"];

Print["n = 7, fund = (8, 3), R = 2.769:\n"];
{xf, yf} = pslv[7]; Rf = Log[N[xf + yf*Sqrt[7], 50]];

Do[
  cn = c^2*7; a0 = Floor[Sqrt[cn]]; r = cn - a0^2;
  If[r > 0 && Denominator[(2a0^2+r)/r] <= 2,
    z = (2a0^2+r)/r; w = 2a0/r;
    Do[
      xc = ChebyshevT[m, z]; Yc = w*ChebyshevU[m-1, z];
      If[IntegerQ[xc] && IntegerQ[Yc] && xc > 0,
        yn = c * Yc; (* CORRECT: y = c*Y *)
        Rc = Log[N[xc + yn*Sqrt[7], 50]];
        k = Round[Rc/Rf];
        Print["  c=", StringPadRight[ToString[c], 4],
          " c²n=", StringPadRight[ToString[cn], 6],
          " r=", StringPadRight[ToString[r], 4],
          " m=", StringPadRight[ToString[m], 2],
          " x=", StringPadRight[ToString[xc], 10],
          " Y=", StringPadRight[ToString[Yc], 6],
          " y=cY=", StringPadRight[ToString[yn], 8],
          " k=", k];
        Break[]],
    {m, 1, 20}]],
{c, 1, 30}];

Print["\n=== SYSTEMATIC: k vs c for several n ===\n"];

Do[
  n0 = nn;
  If[IntegerQ[Sqrt[n0]], Continue[]];
  {xf, yf} = pslv[n0]; Rf = Log[N[xf + yf*Sqrt[n0], 50]];
  pairs = {};
  Do[
    cn = c^2*n0; a0 = Floor[Sqrt[cn]]; r = cn - a0^2;
    If[r > 0 && Denominator[(2a0^2+r)/r] <= 2,
      z = (2a0^2+r)/r; w = 2a0/r;
      Do[
        xc = ChebyshevT[m, z]; Yc = w*ChebyshevU[m-1, z];
        If[IntegerQ[xc] && IntegerQ[Yc] && xc > 0,
          yn = c*Yc; Rc = Log[N[xc + yn*Sqrt[n0], 50]];
          k = Round[Rc/Rf];
          AppendTo[pairs, {c, k, m}]; Break[]],
      {m, 1, 20}]],
  {c, 1, 30}];
  If[Length[pairs] > 0,
    Print["n=", StringPadRight[ToString[n0], 4],
      " fund=", {xf, yf},
      "  (c, k, m): ", pairs]],
{nn, {7, 13, 19, 21, 28, 41, 52, 67, 79, 83}}];

Print["\n=== KEY QUESTION: is k always = m? ===\n"];
(* If k = m always, then: our formula gives exactly epsilon^m,
   and m is known! So recovering epsilon = (epsilon^m)^{1/m}
   via m successive square roots (if m = 2^j) is trivial! *)
