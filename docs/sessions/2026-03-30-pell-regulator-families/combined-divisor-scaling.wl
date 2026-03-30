pslv[nn_] := {x, y} /. First@FindInstance[x x - nn y y == 1, {x, y}, PositiveIntegers]

combinedSolve[n0_, cmax_] := Catch[
  Do[
    cn = c^2 * n0;
    divs = Divisors[4 cn];
    Do[
      If[r > 0 && r < cn,
        a0sq = cn - r;
        If[a0sq > 0 && IntegerQ[Sqrt[a0sq]],
          a0 = Sqrt[a0sq];
          z = (2 a0^2 + r)/r;
          If[Denominator[z] <= 2,
            Throw[{c, a0, r, z, Denominator[z]}]]]],
    {r, divs}],
  {c, 1, cmax}];
  {}
]

Print["=== COMBINED: divisor method + c scaling ===\n"];

Do[
  Nmax = nn;
  Do[
    hits = 0;
    Do[
      If[!IntegerQ[Sqrt[n0]],
        res = combinedSolve[n0, cmax];
        If[res =!= {}, hits++]],
    {n0, 2, Nmax}];
    total = Nmax - 1 - Floor[Sqrt[Nmax]];
    Print["  N=", StringPadRight[ToString[Nmax], 6],
      " c≤", StringPadRight[ToString[cmax], 3],
      " hits=", hits, "/", total,
      " = ", Round[100. hits/total, 0.1], "%"],
  {cmax, {1, 3, 7}}],
{nn, {500, 1000}}];

Print["\n=== HARD PRIMES: what c is needed? ===\n"];
Do[
  res = combinedSolve[n0, 100];
  If[res =!= {},
    {cc, a0, rr, zz, dd} = res;
    Print["  n=", n0, ": c=", cc, " a₀=", a0, " r=", rr, " δ=", dd,
      " τ(4c²n)=", Length[Divisors[4 cc^2 n0]]],
    Print["  n=", n0, ": NO HIT even with c ≤ 100"]],
{n0, {127, 193, 409, 541, 991, 31, 71, 73, 89, 97}}];
