pslv[nn_] := {x, y} /. First@FindInstance[x x - nn y y == 1, {x, y}, PositiveIntegers]

(* For n=61: correct c=5 gives exact solution.
   What happens with c=4, c=6, c=3, c=7? *)

n0 = 61;
{xf, yf} = pslv[n0];
Print["n = ", n0, "  fund = (", xf, ", ", yf, ")\n"];

Do[
  cn = c^2*n0; a0 = Floor[Sqrt[cn]]; r = cn - a0^2;
  z = (2a0^2 + r)/r;
  w = 2a0/r;
  delta = Denominator[z];
  
  Print["c = ", c, ":  c²n = ", cn, "  a₀ = ", a0, "  r = ", r, "  δ = ", delta];
  
  (* Compute T_m(z) for m=1,2,3 as exact rationals *)
  Do[
    xc = ChebyshevT[m, z];
    yc = c * w * ChebyshevU[m-1, z];
    If[IntegerQ[xc] && IntegerQ[yc],
      Print["  m=", m, ": x=", xc, " y=", yc, 
        " x²-ny²=", xc^2 - n0*yc^2, 
        If[xc^2-n0*yc^2==1, " ✓ PELL!", ""]],
      (* How close to integer? *)
      xfrac = FractionalPart[xc];
      yfrac = FractionalPart[yc];
      Print["  m=", m, ": x=", N[xc, 8], 
        " frac(x)=", N[Min[xfrac, 1-xfrac], 4],
        " frac(y)=", N[Min[FractionalPart[yc], 1-FractionalPart[yc]], 4],
        " δ(x)=", Denominator[xc]]],
  {m, 1, 5}];
  Print[],
{c, {1, 2, 3, 4, 5, 6, 7, 8}}];

(* Now: what if we ROUND T_m(z) to nearest integer and check Pell? *)
Print["=== ROUNDING EXPERIMENT ===\n"];
Print["Round T_m(z) to nearest integer, check if x²-ny² = 1:\n"];

Do[
  cn = c^2*n0; a0 = Floor[Sqrt[cn]]; r = cn - a0^2;
  If[r == 0, Continue[]];
  z = (2a0^2 + r)/r;
  w = 2a0/r;
  Do[
    xc = ChebyshevT[m, z];
    yc = c * w * ChebyshevU[m-1, z];
    xr = Round[xc]; yr = Round[yc];
    If[xr > 0 && yr > 0,
      pell = xr^2 - n0*yr^2;
      If[Abs[pell] <= 10,
        Print["  c=", c, " m=", m, ": Round[x]=", xr, " Round[y]=", yr,
          " x²-ny²=", pell, If[pell==1, " ✓✓✓", ""]]]],
  {m, 1, 5}],
{c, 1, 20}];

(* Try another hard n *)
Print["\n=== n = 127 (HARD): rounding with various c ===\n"];
n0 = 127; {xf, yf} = pslv[n0];
Print["fund = (", xf, ", ", yf, ")\n"];

Do[
  cn = c^2*n0; a0 = Floor[Sqrt[cn]]; r = cn - a0^2;
  If[r == 0, Continue[]];
  z = (2a0^2 + r)/r;
  w = 2a0/r;
  Do[
    xc = ChebyshevT[m, z];
    yc = c * w * ChebyshevU[m-1, z];
    xr = Round[xc]; yr = Round[yc];
    If[xr > 0 && yr > 0,
      pell = xr^2 - n0*yr^2;
      If[Abs[pell] <= 100,
        Print["  c=", c, " m=", m, ": x²-127y²=", pell,
          If[pell==1, " ✓✓✓ PELL!", ""],
          If[Abs[pell] <= 4, " (NEAR MISS!)", ""]]]],
  {m, 1, 5}],
{c, 1, 50}];
