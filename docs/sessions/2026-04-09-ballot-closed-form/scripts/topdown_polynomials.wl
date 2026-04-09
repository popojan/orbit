(* TOP-DOWN: Polynomial structure of corrections across semi-convergents *)
(* delta_j(p) is polynomial in p of degree d = j - q1 - 1 *)
(* Constrained by: leading coeff = -B'/d!, last row = -(k-1)*B(p,q) *)

vLin[pp_, ww_, jj_] := (pp - ww jj)/pp Binomial[pp + jj - 1, jj]
B[n_, k_] := If[k == 0, 1, Binomial[n + k - 1, k]/n]

pathsRat[pp_, qq_, jj_] := Module[{S, dp},
  If[jj == 0, Return[1]]; If[jj < 0, Return[0]];
  S = Table[Min[Floor[qq x/pp], jj], {x, 1, pp}];
  If[jj > S[[pp]], Return[0]];
  dp = Table[0, {pp}, {jj + 1}];
  Do[Do[If[y <= S[[x]],
    dp[[x, y + 1]] = If[x == 1 && y == 0, 1, 0] +
      If[x > 1 && y <= S[[x - 1]], dp[[x - 1, y + 1]], 0] +
      If[y > 0, dp[[x, y]], 0]],
    {y, 0, Min[jj, S[[x]]]}], {x, 1, pp}];
  dp[[pp, jj + 1]]
]

ww = 2;
p0 = 2; q0 = 1; p1 = 9; q1 = 4; p2 = 38; q2 = 17;
Bp = B[p0 + p1, q0 + q1]; (* B(11,5) = 273 = B' *)

Print["B' = B(11,5) = ", Bp];
Print[""];

(* === Compute corrections at semi-convergent positions k=1..6 === *)
Print["=== Corrections at semi-convergent positions ==="];
corrections = <||>;
Do[
  p = p0 + k p1; q = q0 + k q1;
  corr = Table[pathsRat[p, q, j] - vLin[p, ww, j], {j, 0, q}];
  corrections[k] = corr;
  first = FirstPosition[corr, x_ /; x =!= 0];
  Print["k=", k, " p=", p, " q=", q, " first_corr=",
    If[first === Missing["NotFound"], "none", first[[1]] - 1]],
  {k, 1, 6}];
Print[""];

(* === Fit polynomials for each j === *)
Print["=== Polynomial coefficients (falling factorial basis) ==="];
Print["delta_j(p) for fixed j, varying p = 11,20,29,38,47,56"];
Print[""];

allPolys = {};
Do[
  j = jj;
  d = j - q1 - 1;
  If[d < 0, Continue[]];

  (* Collect data points *)
  pts = {};
  Do[
    p = p0 + k p1; q = q0 + k q1;
    If[j > q || j >= Length[corrections[k]], Continue[]];
    AppendTo[pts, {p, corrections[k][[j + 1]]}],
    {k, 2, 6}];

  If[Length[pts] < d + 1, Continue[]];

  (* Fit polynomial of degree d *)
  poly = InterpolatingPolynomial[pts[[1 ;; d + 1]], pp];
  poly = Expand[poly];
  AppendTo[allPolys, {j, d, poly}];

  (* Extract coefficients *)
  coeffs = Table[Coefficient[poly, pp, i], {i, d, 0, -1}];

  (* Verify on all data points *)
  verified = True;
  Do[{p, dd} = pts[[i]]; pred = poly /. pp -> p;
    If[pred =!= dd, verified = False],
    {i, d + 2, Length[pts]}];

  Print["j=", j, " d=", d, ":"];
  Print["  poly = ", poly];
  Print["  coeffs (high to low) = ", coeffs];
  Print["  leading = ", coeffs[[1]], " = -B'/", d!, " ? ",
    coeffs[[1]] === -Bp/d!];
  If[d >= 1,
    Print["  sub-leading = ", coeffs[[2]]]];
  Print["  verified on all points: ", verified];
  Print[""],
  {jj, q1 + 1, q1 + 8}];

(* === Express polynomial in the BALLOT BASIS === *)
(* Instead of power basis p^d, try the falling factorial basis: *)
(* (p-c1)(p-c2)...(p-c_d) for suitable constants c_i *)
(* The natural choice: c_i related to semi-convergent positions *)
Print["=== Ballot basis: polynomial in terms of (p - p0 - k*p1) ==="];
Print["Since delta_j = 0 at k=1 (p = p0+p1 = 11), p=11 is always a root"];
Print[""];

Do[
  {j, d, poly} = allPolys[[i]];
  If[d < 1, Continue[]];

  (* Check that p=11 is a root *)
  val11 = poly /. pp -> 11;
  Print["j=", j, " d=", d, ": poly(11)=", val11,
    If[val11 === 0, " (root!)", " (NOT root)"]];

  (* Factor out (p-11) *)
  If[val11 === 0,
    reduced = Cancel[poly / (pp - 11)];
    reduced = Expand[reduced];
    Print["  poly/(p-11) = ", reduced];

    (* Is p=20 also a root? *)
    val20 = reduced /. pp -> 20;
    Print["  reduced(20) = ", val20,
      If[val20 === 0, " (root!)", ""]];

    If[d >= 2 && val20 === 0,
      reduced2 = Cancel[reduced / (pp - 20)];
      reduced2 = Expand[reduced2];
      Print["  poly/((p-11)(p-20)) = ", reduced2];

      val29 = reduced2 /. pp -> 29;
      Print["  reduced2(29) = ", val29,
        If[val29 === 0, " (root!)", ""]]
    ]
  ];
  Print[""],
  {i, 1, Length[allPolys]}];

(* === The DUAL observation === *)
(* delta_j(p) vanishes at p = p0+p1 = 11 (first semi-convergent) *)
(* So delta_j(p) = (p - 11) * Q_j(p) for some polynomial Q *)
(* And Q_j is degree d-1 *)
(* *)
(* For j=q1+1 (d=0): delta is constant = -B(11,5). NOT zero at p=11! *)
(* Wait: delta_j(p0+p1) should be zero because v is exact at k=1 *)
(* But j=q1+1 = 5 and at k=1 (p=11, q=5): v_5(11) is the LAST entry *)
(* v_5(11) = B(11,5) = 273 *)
(* v_5^lin(11) = (11-10)/11 * C(15,5) = 1/11 * 3003 = 273 *)
(* So delta_5(11) = 273 - 273 = 0! *)
Print["=== Verifying delta_j(11) = 0 for all j ==="];
Do[
  p = 11; q = 5;
  If[j > q, Print["  j=", j, ": beyond range"]; Continue[]];
  vA = pathsRat[p, q, j];
  vU = vLin[p, ww, j];
  Print["  j=", j, ": v=", vA, " v_lin=", vU, " delta=", vA - vU],
  {j, 0, 5}];
Print[""];

(* So for j <= 5 (= q at k=1), delta_j(11) = 0. *)
(* For j > 5: j is beyond the range at k=1, so no data point. *)
(* The polynomial at degree d uses points k=2,...,d+1. *)
(* At k=1 (p=11), j=5 is the max height. For j >= 6, there's no value. *)
(* So the polynomials for j >= 6 do NOT necessarily have p=11 as root. *)

(* === Alternative: express in BINOMIAL basis C(p, d) === *)
Print["=== Binomial basis C(p+c, d) ==="];
Do[
  {j, d, poly} = allPolys[[i]];
  (* Try: is poly = a * C(p+c, d) for some a, c? *)
  If[d == 0,
    Print["j=", j, " d=0: const = ", poly /. pp -> 0];
    Continue[]];

  (* For degree 1: a*p + b = a*(p + b/a) *)
  (* For degree 2: try C(p+c, 2) = (p+c)(p+c-1)/2 *)
  (* General: try -B'/(d!) * C(p+c, d) and find c *)
  lead = -Bp/Factorial[d];
  If[d == 1,
    c1 = Expand[(poly - lead pp) / lead];
    Print["j=", j, " d=1: poly = ", lead, " * (p + ", c1, ")"];
    Print["  = -B'/1! * (p + ", c1, ")"]
  ];
  If[d == 2,
    Print["j=", j, " d=2: poly = ", poly];
    (* Try: -B'/2! * (p - r1)(p - r2) *)
    roots = pp /. Solve[poly == 0, pp];
    Print["  roots: ", roots]
  ];
  If[d >= 3,
    Print["j=", j, " d=", d, ": leading=", Coefficient[poly, pp, d],
      " = -B'/", d, "! = ", lead]
  ],
  {i, 1, Length[allPolys]}];
Print[""];

(* === Direct: show the sub-leading coefficients === *)
Print["=== Sub-leading coefficient pattern ==="];
Print["Polynomial: delta_j(p) = Sum_{i=0}^{d} c_i * p^i"];
Print["c_d = -B'/d! (known)"];
Print["c_{d-1} = ?"];
Print[""];
Do[
  {j, d, poly} = allPolys[[i]];
  If[d < 1, Continue[]];
  lead = Coefficient[poly, pp, d];
  sublead = Coefficient[poly, pp, d - 1];
  Print["j=", j, " d=", d, ": c_d=", lead,
    " c_{d-1}=", sublead, " ratio=", sublead/lead],
  {i, 1, Length[allPolys]}];
