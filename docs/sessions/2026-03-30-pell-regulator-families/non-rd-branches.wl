pslv[nn_] := {x, y} /. First@FindInstance[x x - nn y y == 1, {x, y}, PositiveIntegers]

(* Study non-R-D branches for d = +-8, +-16 in even-square convention *)
(* n = (2k)^2 + d, where d DOES NOT divide 8k *)

Print["================================================================"];
Print["  NON-R-D BRANCHES: n = 4k^2 + d, d !| 8k"];
Print["================================================================\n"];

(* === d = +8, k odd === *)
Print["--- d = +8, k odd (k = 2j+1) ---"];
Print["    n = 4(2j+1)^2 + 8 = 16j^2 + 16j + 12\n"];
Do[
  k = 2j+1; n = 4k^2 + 8;
  If[!IntegerQ[Sqrt[n]],
    {xa, ya} = pslv[n];
    cf = ContinuedFraction[Sqrt[n]];
    L = If[Length[cf]==2, Length[cf[[2]]], "?"];
    Print["  j=", j, "  k=", k, "  n=", n,
      "  L=", L, "  x=", xa, "  y=", ya,
      "  x/n=", N[xa/n, 6],
      "  R/ln(n)=", Round[N[Log[xa+ya*Sqrt[n]]/Log[n]], 0.001]];
  ],
{j, 0, 12}];
Print[];

(* Look for pattern in x for d=+8, k odd *)
Print["  Pattern search for d=+8, k odd:"];
Do[
  k = 2j+1; n = 4k^2 + 8;
  If[!IntegerQ[Sqrt[n]],
    {xa, ya} = pslv[n];
    Print["  k=", k, "  n=", n, "  x=", xa,
      "  x/(2n-1)=", N[xa/(2n-1),8],
      "  x/(2k^2)=", N[xa/(2k^2),8],
      "  y/k=", N[ya/k,8],
      "  y/(2k)=", N[ya/(2k),8]];
  ],
{j, 0, 15}];
Print[];

(* === d = -8, k odd === *)
Print["--- d = -8, k odd ---"];
Do[
  k = 2j+1; n = 4k^2 - 8;
  If[n > 1 && !IntegerQ[Sqrt[n]],
    {xa, ya} = pslv[n];
    cf = ContinuedFraction[Sqrt[n]];
    L = If[Length[cf]==2, Length[cf[[2]]], "?"];
    Print["  k=", k, "  n=", n,
      "  L=", L, "  x=", xa, "  y=", ya,
      "  R/ln(n)=", Round[N[Log[xa+ya*Sqrt[n]]/Log[n]], 0.001]];
  ],
{j, 1, 12}];
Print[];

(* === d = +16, three non-R-D branches === *)
Print["--- d = +16, k mod 4 = 1 ---"];
Do[
  k = 4j+1; n = 4k^2 + 16;
  If[!IntegerQ[Sqrt[n]],
    {xa, ya} = pslv[n];
    cf = ContinuedFraction[Sqrt[n]];
    L = If[Length[cf]==2, Length[cf[[2]]], "?"];
    Print["  k=", k, "  n=", n,
      "  L=", L, "  x=", xa, "  y=", ya,
      "  R/ln(n)=", Round[N[Log[xa+ya*Sqrt[n]]/Log[n]], 0.001]];
  ],
{j, 0, 8}];
Print[];

Print["--- d = +16, k mod 4 = 3 ---"];
Do[
  k = 4j+3; n = 4k^2 + 16;
  If[!IntegerQ[Sqrt[n]],
    {xa, ya} = pslv[n];
    cf = ContinuedFraction[Sqrt[n]];
    L = If[Length[cf]==2, Length[cf[[2]]], "?"];
    Print["  k=", k, "  n=", n,
      "  L=", L, "  x=", xa, "  y=", ya,
      "  R/ln(n)=", Round[N[Log[xa+ya*Sqrt[n]]/Log[n]], 0.001]];
  ],
{j, 0, 8}];
Print[];

Print["--- d = +16, k mod 4 = 2 (k even but 4 !| k) ---"];
Do[
  k = 4j+2; n = 4k^2 + 16;
  If[!IntegerQ[Sqrt[n]],
    {xa, ya} = pslv[n];
    cf = ContinuedFraction[Sqrt[n]];
    L = If[Length[cf]==2, Length[cf[[2]]], "?"];
    Print["  k=", k, "  n=", n,
      "  L=", L, "  x=", xa, "  y=", ya,
      "  R/ln(n)=", Round[N[Log[xa+ya*Sqrt[n]]/Log[n]], 0.001]];
  ],
{j, 0, 8}];
Print[];

(* Now try to find polynomial fits for the non-R-D x values *)
Print["================================================================"];
Print["  POLYNOMIAL FIT ATTEMPT for non-R-D branches"];
Print["================================================================\n"];

(* d=+8, k odd: n = 4(2j+1)^2 + 8 *)
Print["d=+8, k=2j+1:"];
xvals8 = Table[
  k = 2j+1; n = 4k^2 + 8;
  {xa, ya} = pslv[n]; {j, k, n, xa, ya},
{j, 0, 10}];
Print["  Checking if x is polynomial in k:"];
Do[
  {j0, k0, n0, x0, y0} = xvals8[[i]];
  Print["    k=", k0, "  x=", x0, "  x/k^4=", N[x0/k0^4,8],
    "  (x-1)/(2k^2)=", N[(x0-1)/(2k0^2),8],
    "  (x-1)/k^2=", N[(x0-1)/k0^2,8]];
, {i, 1, Length[xvals8]}];
Print[];

(* Try ratio of consecutive x values *)
Print["  Ratio x[j+1]/x[j]:"];
Do[
  x1 = xvals8[[i, 4]]; x2 = xvals8[[i+1, 4]];
  Print["    x[",i,"]/x[",i-1,"] = ", N[x2/x1, 8]];
, {i, 1, Length[xvals8]-1}];
Print[];

(* d=+16, k = 4j+2: *)
Print["d=+16, k=4j+2:"];
xvals16 = Table[
  k = 4j+2; n = 4k^2 + 16;
  {xa, ya} = pslv[n]; {j, k, n, xa, ya},
{j, 0, 8}];
Do[
  {j0, k0, n0, x0, y0} = xvals16[[i]];
  Print["    k=", k0, "  x=", x0,
    "  x/k^4=", N[x0/k0^4, 8],
    "  x/(2k^4)=", N[x0/(2k0^4), 8]];
, {i, 1, Length[xvals16]}];
Print[];

(* d=+16, k odd: *)
Print["d=+16, k=2j+1:"];
xvals16o = Table[
  k = 2j+1; n = 4k^2 + 16;
  {xa, ya} = pslv[n]; {j, k, n, xa, ya},
{j, 0, 8}];
Do[
  {j0, k0, n0, x0, y0} = xvals16o[[i]];
  Print["    k=", k0, "  x=", x0,
    "  x/k^6=", N[x0/k0^6, 8],
    "  x/(8k^6)=", N[x0/(8k0^6), 8]];
, {i, 1, Length[xvals16o]}];

Print[];
(* Try InterpolatingPolynomial for d=+8 k odd *)
Print["  InterpolatingPolynomial fit for d=+8, k odd:"];
pts8 = Table[{2j+1, pslv[4(2j+1)^2+8][[1]]}, {j, 0, 6}];
poly8 = InterpolatingPolynomial[pts8, k] // Expand;
Print["  x(k) = ", poly8];
Print["  Verify:"];
Do[
  k0 = 2j+1;
  xpred = poly8 /. k -> k0;
  {xa, ya} = pslv[4k0^2+8];
  Print["    k=", k0, "  pred=", xpred, "  actual=", xa, "  ", If[xpred==xa, "OK", "FAIL"]];
, {j, 7, 12}];
