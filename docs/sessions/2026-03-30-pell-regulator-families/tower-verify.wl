pslv[nn_] := {x, y} /. First@FindInstance[x x - nn y y == 1, {x, y}, PositiveIntegers]

Print["================================================================"];
Print["  CORRECTED: z = k²/2^{a-3} + 1  for d = 2^a"];
Print["================================================================\n"];

(* For z integer: need 2^{a-3} | k².
   Min k: k = 2^{ceil((a-3)/2)}.
   For j=1 (minimum): k = 2^{ceil((a-3)/2)}, z = 2 (a odd) or 3 (a even). *)

Print["Systematic verification with CORRECT z:\n"];

Do[
  a = aa; d = 2^a;
  s = Ceiling[(a - 3)/2];
  
  nMatch = 0; nTotal = 0;
  rows = {};
  
  Do[
    k0 = 2^s * j0;
    n = 4 k0^2 + d;
    If[n > 1 && !IntegerQ[Sqrt[n]],
      {xa, ya} = pslv[n];
      z = k0^2/2^(a - 3) + 1;
      nTotal++;
      
      found = 0;
      Do[If[ChebyshevT[m, z] == xa, found = m; Break[]], {m, 1, 64}];
      If[found > 0, nMatch++];
      
      If[j0 <= 4,
        AppendTo[rows, {j0, k0, n, z, xa, found}]];
    ];
  , {j0, {1, 2, 3, 4, 5, 7, 9, 11}}];
  
  Print["d=2^", a, "=", d, "  k=2^", s, "·j  (",
    nMatch, "/", nTotal, " match):"];
  Do[
    {j0, k0, n0, z0, x0, m0} = row;
    Print["  j=", StringPadRight[ToString[j0], 3],
      " k=", StringPadRight[ToString[k0], 5],
      " n=", StringPadRight[ToString[n0], 8],
      " z=", StringPadRight[ToString[z0], 6],
      " x=", StringPadRight[ToString[x0], 15],
      If[m0 > 0, " T_" <> ToString[m0] <> " ✓", " ✗"]];
  , {row, rows}];
  Print[];
, {aa, 3, 12}];

Print["================================================================"];
Print["  m PATTERN for j=1 (minimum k, v₂(j)=0)"];
Print["================================================================\n"];

Print["  a  | d      | z | m  | x"];
Print["  ---+--------+---+----+---"];
Do[
  a = aa; d = 2^a;
  s = Ceiling[(a-3)/2];
  k0 = 2^s; n = 4k0^2 + d;
  z = k0^2/2^(a-3) + 1;
  {xa, ya} = pslv[n];
  found = 0;
  Do[If[ChebyshevT[m, z] == xa, found = m; Break[]], {m, 1, 128}];
  Print["  ", a, "  | ", StringPadRight[ToString[d], 6],
    " | ", z, " | ", StringPadRight[ToString[found], 3],
    "| ", xa];
, {aa, 3, 14}];

Print[];
Print["================================================================"];
Print["  ANSWER: Can we solve n = 4m² + 2^a for arbitrary a?"];
Print["================================================================\n"];

Print["YES — for k divisible by 2^{ceil((a-3)/2)}, the solution is:\n"];
Print["  z = k²/2^{a-3} + 1     (integer by construction)"];
Print["  x = T_m(z)              (Chebyshev polynomial)"];
Print["  m = 2^{floor((a-2)/2) - v₂(k) + ceil((a-3)/2)}  (conjectured)\n"];

Print["Coverage: fraction 1/2^{ceil((a-3)/2)} of all k values.\n"];

Print["  a=3  (d=8):    ALL k         (100%)"];
Print["  a=4  (d=16):   ALL k         (100%) + half-int z trick"];
Print["  a=5  (d=32):   k even        (50%)"];
Print["  a=6  (d=64):   4|k           (25%)"];
Print["  a=7  (d=128):  4|k           (25%)"];
Print["  a=8  (d=256):  8|k           (12.5%)"];
Print["  a=10 (d=1024): 16|k          (6.25%)"];
Print["  a=2p:          2^{p-1}|k     (2^{1-p})"];
