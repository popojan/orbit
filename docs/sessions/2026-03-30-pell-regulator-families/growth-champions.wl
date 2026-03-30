pslv[nn_] := {x, y} /. First@FindInstance[x x - nn y y == 1, {x, y}, PositiveIntegers]

Print["=== GROWTH CHAMPIONS: largest x relative to n ===\n"];
Print["For j=1 (minimal k), m = 2^ceil((a-4)/2):\n"];

Print[StringPadRight["a",4],
  StringPadRight["d=2^a",8],
  StringPadRight["k",6],
  StringPadRight["n",12],
  StringPadRight["m",5],
  StringPadRight["x",30],
  "log(x)/log(n)"];
Print[StringJoin[Table["-",{80}]]];

Do[
  a = aa;
  s = Ceiling[(a-3)/2];
  k0 = 2^s; (* j=1 *)
  n = 4 k0^2 + 2^a;
  z = k0^2/2^(a-3) + 1;
  (* Find m *)
  mFound = 0;
  Do[
    xc = ChebyshevT[m, z];
    yc = k0*ChebyshevU[m-1, z]/2^(a-2);
    If[IntegerQ[xc] && IntegerQ[yc],
      mFound = m; Break[]],
  {m, 1, 128}];
  If[mFound > 0,
    xval = ChebyshevT[mFound, z];
    ratio = N[Log[xval]/Log[n], 6];
    xstr = If[xval < 10^15, ToString[xval],
      ToString[NumberForm[N[xval,4], {4,0}]]];
    Print[StringPadRight[ToString[a],4],
      StringPadRight[ToString[2^a],8],
      StringPadRight[ToString[k0],6],
      StringPadRight[ToString[n],12],
      StringPadRight[ToString[mFound],5],
      StringPadRight[xstr,30],
      ratio];
  ],
{aa, 3, 20}];

Print["\n=== INTERPRETATION ===\n"];
Print["x ~ n^m asymptotically. The ratio log(x)/log(n) -> m.\n"];
Print["Champions (j=1) are the SMALLEST n at each m level:\n"];

Print["  m=1:  x ~ n      (Richaud-Degert, trivial)"];
Print["  m=2:  x ~ n^2    (e.g. n=12: x=7, or n=44: x=199)"];
Print["  m=3:  x ~ n^3    (e.g. n=20: x=9, n=52: x=649)"];
Print["  m=4:  x ~ n^4    (e.g. n=128: x=577)"];
Print["  m=8:  x ~ n^8    (e.g. n=512: x=665857)"];
Print["  m=16: x ~ n^16   (e.g. n=2048: x=886731088897)"];
Print["  m=32: x ~ n^32   (e.g. n=8192: x has 24 digits!)"];
Print["  m=64: x ~ n^64   (e.g. n=32768: x has 49 digits!)"];

Print["\nThe 'most interesting' n are those where the Pell solution"];
Print["is exponentially large relative to n, yet computable in O(1)"];
Print["via a single Chebyshev evaluation T_m(z) at a small integer z.\n"];

Print["=== EXPLICIT CHAMPIONS ===\n"];
Print["These are the n values where our formula gives the MOST"];
Print["compression: huge x from tiny (a, k, m, z).\n"];

Do[
  a = aa;
  s = Ceiling[(a-3)/2];
  k0 = 2^s; n = 4k0^2+2^a;
  z = k0^2/2^(a-3)+1;
  mFound = 0;
  Do[xc = ChebyshevT[m, z]; yc = k0*ChebyshevU[m-1, z]/2^(a-2);
    If[IntegerQ[xc]&&IntegerQ[yc], mFound=m; Break[]], {m,1,128}];
  If[mFound >= 4,
    xval = ChebyshevT[mFound, z];
    digits = IntegerLength[xval];
    Print["  n = ", n, " = 4*",k0,"^2+",2^a,
      ":  z=",z,", m=",mFound,
      "  =>  x has ",digits," digits  (n has ", IntegerLength[n], ")"];
  ],
{aa, 6, 20}];
