pslv[nn_] := {x, y} /. First@FindInstance[x x - nn y y == 1, {x, y}, PositiveIntegers]

Print["================================================================"];
Print["  d=32 EVEN k: Chebyshev works (z integer)"];
Print["================================================================\n"];

(* z = (k²+4)/4.  For k even: k=2j, z = (4j²+4)/4 = j²+1. INTEGER! *)
Print["z = (k²+4)/4 = j²+1  where k=2j\n"];

Print["Verify x = T_m(z) for all even k:"];
Do[
  k0 = 2j; n = 4k0^2+32;
  If[!IntegerQ[Sqrt[n]],
    {xa, ya} = pslv[n];
    z = j^2+1;
    found = "";
    Do[If[ChebyshevT[m, z] == xa,
      found = "T_"<>ToString[m]<>"("<>ToString[z]<>")"; Break[]],
    {m, 1, 6}];
    v2k = IntegerExponent[k0, 2];
    Print["  j=", StringPadRight[ToString[j],3],
      " k=", StringPadRight[ToString[k0],3],
      " v₂(k)=", v2k,
      " z=", StringPadRight[ToString[z],5],
      " x=", StringPadRight[ToString[xa],12],
      " ", found];
  ],
{j, 1, 16}];

Print[];
Print["Pattern: m depends on v₂(k):"];
Print["  8|k (v₂≥3): m=1  →  x = z = j²+1           (degree 2)"];
Print["  k≡4(8) (v₂=2): m=2  →  x = T₂(z) = 2z²-1   (degree 4)"];
Print["  k≡2(4) (v₂=1): m=2  →  x = T₂(z) = 2z²-1   (degree 4)\n"];

(* Explicit formulas *)
Print["Explicit: z = j²+1,  k = 2j,  n = 16j²+32\n"];
Print["  m=1 (4|j): x = j²+1,  y = j/4"];
Print["  m=2 (else): x = 2(j²+1)²-1 = 2j⁴+4j²+1,  y = j(j²+1)/2 ... let's check y"];

Do[
  j0 = j; k0 = 2j0; n = 4k0^2+32; z = j0^2+1;
  {xa, ya} = pslv[n];
  xf = 2*j0^4+4*j0^2+1;
  (* y from Chebyshev: 2*y_Pell*sqrt(n') = 2*z*w*sqrt(n') where w=k/4=j/2
     2*y = 2*z*(j/2) = z*j = j(j²+1)
     y = j(j²+1)/2 *)
  yf = j0*(j0^2+1)/2;
  If[Mod[j0, 4] != 0,
    Print["  j=",j0," k=",k0," n=",n,
      "  x=",xa, If[xa==xf," ✓"," ✗ expected "<>ToString[xf]],
      "  y=",ya, If[ya==yf," ✓"," ✗ expected "<>ToString[yf]]];
  ],
{j, 1, 12}];

(* Algebraic proof *)
Print[];
xpoly = 2*j^4+4*j^2+1;
ypoly = j*(j^2+1)/2;
npoly = 16*j^2+32;
proof = Expand[xpoly^2 - npoly*ypoly^2];
Print["Proof: x²-ny² = (2j⁴+4j²+1)² - (16j²+32)·(j(j²+1)/2)²"];
Print["     = ", proof, "  ", If[proof===1, "QED ■", "FAIL"]];

Print[];
Print["================================================================"];
Print["  d=64, k≡0(4): Chebyshev for higher d"];
Print["================================================================\n"];

(* d=64: z = (k²+16)/16. For k=4j: z = (16j²+16)/16 = j²+1. Same z! *)
Print["d=64: z = (k²+16)/16.  For k=4j: z = j²+1 (integer)\n"];

Do[
  j0 = j; k0 = 4j0; n = 4k0^2+64;
  If[n>1 && !IntegerQ[Sqrt[n]],
    {xa, ya} = pslv[n];
    z = j0^2+1;
    found = "";
    Do[If[ChebyshevT[m, z] == xa,
      found = "T_"<>ToString[m]; Break[]],
    {m, 1, 8}];
    v2k = IntegerExponent[k0, 2];
    Print["  j=", StringPadRight[ToString[j0],3],
      " k=", StringPadRight[ToString[k0],3],
      " v₂(k)=", v2k,
      " z=", StringPadRight[ToString[z],5],
      " x=", StringPadRight[ToString[xa],12],
      " ", found];
  ],
{j, 1, 12}];

Print[];
Print["================================================================"];
Print["  d=128, k≡0(8): same pattern continues"];
Print["================================================================\n"];

Print["d=128: z = (k²+32)/32.  For k=8j: z = (64j²+32)/32 = 2j²+1\n"];

Do[
  j0 = j; k0 = 8j0; n = 4k0^2+128;
  If[n>1 && !IntegerQ[Sqrt[n]],
    {xa, ya} = pslv[n];
    z = 2*j0^2+1;
    found = "";
    Do[If[ChebyshevT[m, z] == xa,
      found = "T_"<>ToString[m]; Break[]],
    {m, 1, 8}];
    Print["  j=", StringPadRight[ToString[j0],3],
      " k=", StringPadRight[ToString[k0],3],
      " z=", StringPadRight[ToString[z],5],
      " x=", StringPadRight[ToString[xa],12],
      " ", found];
  ],
{j, 1, 8}];

Print[];
Print["================================================================"];
Print["  RECURSIVE STRUCTURE"];
Print["================================================================\n"];

Print["The key observation: for d = 2^a, substituting k = 2^{a-3}·j"];
Print["always gives z = j²+c  (integer) where c depends on a."];
Print["Then T_m(z) gives the Pell solution, with m = v₂(j)-dependent.\n"];

Print["This means: for ANY d = 2^a, there exists a substitution"];
Print["k = 2^s · j that makes z integer and Chebyshev work."];
Print["The 'cost' is that we only cover k ≡ 0 (mod 2^s).\n"];

Print["Coverage per d:"];
Print["  d=8:   ALL k      (100%)"];
Print["  d=16:  ALL k      (100%)  ← boundary for full coverage"];
Print["  d=32:  k even     (50%)"];
Print["  d=64:  k≡0 mod 4  (25%)"];
Print["  d=128: k≡0 mod 8  (12.5%)"];
Print["  d=2^a: k≡0 mod 2^{a-3}  (2^{3-a} of all k)"];
