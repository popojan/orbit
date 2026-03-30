pslv[nn_] := {x, y} /. First@FindInstance[x x - nn y y == 1, {x, y}, PositiveIntegers]

(* Get the degree-6 polynomial for d=+16, k odd *)
Print["=== d=+16, k odd: degree-6 x polynomial ===\n"];

(* All k odd together *)
xdata = Table[k0=2j+1; n=4k0^2+16; If[k0>1&&!IntegerQ[Sqrt[n]], {k0, pslv[n][[1]]}, Nothing], {j,1,12}];
pts = {#[[1]], #[[2]]}& /@ xdata;
polyx = InterpolatingPolynomial[pts[[;;7]], k] // Expand;
Print["x(k) = ", polyx];
Print["     = ", Collect[polyx, k]];

(* Factor or simplify *)
Print["Factored: ", Factor[polyx]];
Print[];

(* Same for y *)
ydata = Table[k0=2j+1; n=4k0^2+16; If[k0>1&&!IntegerQ[Sqrt[n]], {k0, pslv[n][[2]]}, Nothing], {j,1,12}];
ptsy = {#[[1]], #[[2]]}& /@ ydata;
polyy = InterpolatingPolynomial[ptsy[[;;7]], k] // Expand;
Print["y(k) = ", polyy];
Print["     = ", Collect[polyy, k]];
Print["Factored: ", Factor[polyy]];
Print[];

(* Verify *)
Print["Verify formula:"];
Do[
  {k0, xa} = xdata[[i]];
  ya = ydata[[i, 2]];
  xp = polyx /. k -> k0;
  yp = polyy /. k -> k0;
  n = 4k0^2 + 16;
  Print["  k=", k0, "  x=", xa, "  xpoly=", xp,
    "  y=", ya, "  ypoly=", yp,
    "  ", If[xa==xp && ya==yp, "OK", "FAIL"]];
, {i, 1, Length[xdata]}];

(* Algebraic proof *)
Print[];
Print["Algebraic verification:"];
n = 4k^2 + 16;
residual = Expand[polyx^2 - n * polyy^2];
Print["x^2 - n*y^2 = ", residual];
Print["Simplified: ", Simplify[residual]];
Print[];

(* Now d=-16, k odd *)
Print["=== d=-16, k odd ===\n"];
xdata2 = Table[k0=2j+1; n=4k0^2-16; If[n>1&&!IntegerQ[Sqrt[n]], {k0, pslv[n][[1]]}, Nothing], {j,2,12}];
ydata2 = Table[k0=2j+1; n=4k0^2-16; If[n>1&&!IntegerQ[Sqrt[n]], {k0, pslv[n][[2]]}, Nothing], {j,2,12}];

If[Length[xdata2] >= 7,
  ptsx2 = {#[[1]], #[[2]]}& /@ xdata2;
  ptsy2 = {#[[1]], #[[2]]}& /@ ydata2;
  polyx2 = InterpolatingPolynomial[ptsx2[[;;7]], k] // Expand;
  polyy2 = InterpolatingPolynomial[ptsy2[[;;7]], k] // Expand;
  Print["x(k) = ", Collect[polyx2, k]];
  Print["Factored: ", Factor[polyx2]];
  Print["y(k) = ", Collect[polyy2, k]];
  Print["Factored: ", Factor[polyy2]];
  Print[];
  n2 = 4k^2 - 16;
  res2 = Expand[polyx2^2 - n2 * polyy2^2];
  Print["x^2 - n*y^2 = ", Simplify[res2]];
  Print[];
  Do[{k0, xa} = xdata2[[i]]; ya = ydata2[[i,2]];
    xp = polyx2 /. k -> k0; yp = polyy2 /. k -> k0;
    Print["  k=",k0,"  x=",xa,"  xpoly=",xp,"  y=",ya,"  ypoly=",yp,
      "  ",If[xa==xp&&ya==yp,"OK","FAIL"]];
  , {i, 1, Length[xdata2]}];
];

Print[];
Print["================================================================"];
Print["  COMPLETE FAMILY CHART"];
Print["================================================================\n"];

Print["┌────────┬────────────┬────┬──────────────────────────────────────────┐"];
Print["│ d      │ condition  │ L  │ x formula                                │"];
Print["├────────┼────────────┼────┼──────────────────────────────────────────┤"];
Print["│ any r  │ r|2a₀      │ ≤2 │ (2a₀²+r)/r           (degree 2 in a₀)  │"];
Print["│ +8     │ k odd      │ 8  │ 2k⁴+4k²+1            (degree 4)        │"];
Print["│ -8     │ k odd      │ 8  │ 2k⁴-4k²+1            (degree 4)        │"];
Print["│ +16    │ k≡2 mod 4  │ 8  │ k⁴/2+2k²+1           (degree 4)        │"];
Print["│ -16    │ k≡2 mod 4  │ 8  │ k⁴/2-2k²+1           (degree 4)        │"];
Print["│ +16    │ k odd      │ 14 │ (degree 6 polynomial) │"];
Print["│ -16    │ k odd      │ 14 │ (degree 6 polynomial) │"];
Print["└────────┴────────────┴────┴──────────────────────────────────────────┘"];
