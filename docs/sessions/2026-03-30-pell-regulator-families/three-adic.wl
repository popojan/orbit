pslv[nn_] := {x, y} /. First@FindInstance[x x - nn y y == 1, {x, y}, PositiveIntegers]

Print["=== 3-ADIC STRUCTURE OF PELL SOLUTIONS ===\n"];
Print["Family: n = k^2 + 3, k not divisible by 3\n"];

Print["Looking for 3-adic patterns in x and y:\n"];
Do[
  If[Mod[k0, 3] != 0,
    n = k0^2 + 3;
    If[!IntegerQ[Sqrt[n]],
      {xa, ya} = pslv[n];
      (* 3-adic valuations *)
      v3x = IntegerExponent[xa, 3];
      v3y = IntegerExponent[ya, 3];
      Print["  k=", StringPadRight[ToString[k0], 4],
        " n=", StringPadRight[ToString[n], 6],
        " x=", StringPadRight[ToString[xa], 15],
        " y=", StringPadRight[ToString[ya], 12],
        " v3(x)=", v3x, " v3(y)=", v3y,
        " x mod 3=", Mod[xa, 3],
        " x mod 9=", Mod[xa, 9]];
    ]],
{k0, 1, 20}];

Print["\n=== LUCAS SEQUENCES with Q=3 ===\n"];
Print["V_n(P,3)^2 - (P^2-12)*U_n(P,3)^2 = 4*3^n\n"];

(* Define Lucas V_n(P, Q) and U_n(P, Q) *)
lucV[0, p_, q_] := 2;
lucV[1, p_, q_] := p;
lucV[n_, p_, q_] := lucV[n, p, q] = p*lucV[n-1, p, q] - q*lucV[n-2, p, q];

lucU[0, p_, q_] := 0;
lucU[1, p_, q_] := 1;
lucU[n_, p_, q_] := lucU[n, p, q] = p*lucU[n-1, p, q] - q*lucU[n-2, p, q];

(* For n_target = P^2-12 with P integer: n = P^2-12.
   Try P=4: n=4. P=5: n=13. P=6: n=24. P=7: n=37. *)

Print["For Q=3, P integer: n_target = P^2 - 12\n"];
Do[
  pp = p0; ntarg = pp^2 - 12;
  If[ntarg > 1 && !IntegerQ[Sqrt[ntarg]],
    {xa, ya} = pslv[ntarg];
    Print["  P=",pp," n=",ntarg,": Pell x=",xa,", y=",ya];
    (* Check: can we extract from Lucas? *)
    Do[
      vn = lucV[m, pp, 3]; un = lucU[m, pp, 3];
      (* V^2 - n*U^2 = 4*3^m. So (V/2)^2 - n*(U/2)^2 = 3^m *)
      (* For Pell: need V^2 - n*U^2 = 4, i.e., 3^m = 1, impossible for m>0 *)
      (* BUT: V_{m1} * V_{m2} - n * U_{m1} * U_{m2} gives combinatorial options *)
      (* Actually: if 3|V_m and 3|U_m, then V_m/3^{m/2} might work *)
      xc = vn/(2); yc = un/(2);
      If[IntegerQ[xc] && IntegerQ[yc] && xc^2 - ntarg*yc^2 == 1,
        Print["    m=",m,": V/2=",xc," U/2=",yc," Pell ✓"]; Break[]];
      (* Try dividing by 3^{m/2} *)
      If[EvenQ[m],
        xc2 = vn/(2*3^(m/2)); yc2 = un/(2*3^(m/2));
        (* Then xc2^2 - ntarg*yc2^2 = 1 iff V^2-n*U^2=4*3^m AND scaling *)
        (* Actually: (V/(2*3^{m/2}))^2 - n*(U/(2*3^{m/2}))^2 = 1 iff
           V^2 - n*U^2 = 4*3^m, which is the identity. So:
           xc2^2 - ntarg*yc2^2 = 1 automatically IF xc2, yc2 integer *)
        If[IntegerQ[xc2] && IntegerQ[yc2] && xc2 > 0,
          Print["    m=",m,": V/(2*3^{m/2})=",xc2,
            " U/(2*3^{m/2})=",yc2," Pell: ",xc2^2-ntarg*yc2^2];
          Break[]]],
    {m, 1, 30}];
  ],
{p0, 4, 12}];

Print["\n=== KEY TEST: does 3^{m/2} divide V_m(P, 3)? ===\n"];

pp = 5; (* n = 13 *)
Print["P=5, Q=3, n=13:"];
Do[
  vn = lucV[m, pp, 3]; un = lucU[m, pp, 3];
  If[EvenQ[m],
    v3v = IntegerExponent[vn, 3];
    v3u = IntegerExponent[un, 3];
    needed = m/2;
    Print["  m=",StringPadRight[ToString[m],3],
      " V=",StringPadRight[ToString[vn],15],
      " v3(V)=",v3v," need=",needed+IntegerExponent[2,3],
      "  U=",StringPadRight[ToString[un],12],
      " v3(U)=",v3u,
      If[v3v >= needed && v3u >= needed, "  BOTH OK!", ""]]],
{m, 2, 20, 2}];

Print["\n=== ALTERNATIVE: composition in the field ===\n"];

(* For n = k^2 + 3 with 3∤k:
   The R-D unit for the FIELD (when k^2+3 is in a field with R-D structure
   via a different decomposition) could serve as base.
   
   k^2 + 3 = (k-1)^2 + (2k+2). R-D when (2k+2)|4(k-1), i.e., (k+1)|2(k-1).
   2(k-1) = 2(k+1) - 4, so (k+1)|4. k in {0,1,3}.
   
   k^2 + 3 = (k+1)^2 + (-2k+2). Not useful (negative r with k>1).
   
   So generically: NO alternative R-D decomposition. *)

Print["For n = k^2+3, 3∤k: no alternative R-D decomposition exists."];
Print["The CF period grows unpredictably with k."];
Print["These are genuinely 'hard' Pell instances.\n"];

(* But wait: what about n = 9k^2 + 3 = 3(3k^2+1)? *)
Print["=== ALTERNATIVE FAMILY: n = 9k^2 + 3 = 3(3k^2+1) ===\n"];
Print["Here a_0 = 3k, r = 3, and 3|4*(3k) = 12k always. R-D!\n"];

Do[
  n = 9k0^2 + 3;
  If[!IntegerQ[Sqrt[n]],
    xrd = (18k0^2 + 3)/3;
    yrd = 6k0/3;
    {xa, ya} = pslv[n];
    Print["  k=",k0," n=",n,
      " R-D: x=",xrd," y=",yrd,
      " fund: ",{xa,ya},
      " match: ",xa==xrd && ya==yrd]],
{k0, 1, 8}];

Print["\n=== WHAT ABOUT n = 9k^2 + 12 (d=12, r=3 in a₀=3k)? ===\n"];
Do[
  a0 = 3k0; n = a0^2 + 12;
  If[!IntegerQ[Sqrt[n]],
    xrd = (2*a0^2+12)/12;
    yrd = 2*a0/12;
    {xa,ya} = pslv[n];
    Print["  k=",k0," a0=",a0," n=",n,
      " x_RD=",xrd," y_RD=",yrd,
      " fund=",{xa,ya},
      " match: ", xa==xrd&&ya==yrd]],
{k0, 1, 8}];

Print["\nNow: n = (3k+1)^2 + 12 and n = (3k+2)^2 + 12 (non-R-D for r=12):"];
Do[
  a0 = 3k0+1; n = a0^2+12;
  If[!IntegerQ[Sqrt[n]],
    {xa,ya} = pslv[n];
    Print["  a0=",a0," n=",n," x=",xa," y=",ya,
      " x/a0^2=",N[xa/a0^2,4]]],
{k0, 0, 5}];
