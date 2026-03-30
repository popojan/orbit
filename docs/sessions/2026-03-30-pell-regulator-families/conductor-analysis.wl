pslv[nn_] := {x, y} /. First@FindInstance[x x - nn y y == 1, {x, y}, PositiveIntegers]

(* The conductor f of the order Z[c*sqrt(n)] inside the maximal order O_K
   of Q(sqrt(n)) determines the index [O_K* : Z[c*sqrt(n)]*].
   
   For n squarefree: O_K = Z[(1+sqrt(n))/2] if n≡1 mod 4, else Z[sqrt(n)].
   The order Z[c*sqrt(n)] has conductor f = 2c if n≡1 mod 4, else f = c.
   
   The index of unit groups relates to Euler's totient of f (roughly). *)

sqfree[n_] := Module[{f = FactorInteger[n]}, Times @@ (Power @@@ ({#1, Mod[#2, 2]} & @@@ f))]
conductor[n_, c_] := Module[{nsf = sqfree[n], disc},
  (* Fundamental discriminant *)
  If[Mod[nsf, 4] == 1, 2c, c]
]

cases = {};
Do[
  If[IntegerQ[Sqrt[n0]], Continue[]];
  {xf, yf} = pslv[n0];
  Rf = Log[N[xf + yf*Sqrt[n0], 50]];
  Do[
    cn = c^2*n0; a0 = Floor[Sqrt[cn]]; r = cn - a0^2;
    If[r > 0 && Denominator[(2a0^2+r)/r] <= 2,
      z = (2a0^2+r)/r; w = 2a0/r;
      Catch[Do[
        xc = ChebyshevT[m, z]; Yc = w*ChebyshevU[m-1, z];
        If[IntegerQ[xc] && IntegerQ[Yc] && xc > 0,
          yn = c*Yc; Rc = Log[N[xc + yn*Sqrt[n0], 50]];
          k = Round[Rc/Rf];
          nsf = sqfree[n0];
          f = conductor[n0, c];
          nmod4 = Mod[nsf, 4];
          AppendTo[cases, {n0, c, k, m, k/m, f, nmod4, nsf}];
          Throw[True]],
      {m, 1, 20}]]],
  {c, 1, 15}],
{n0, 2, 500}];

Print["=== CONDUCTOR ANALYSIS ===\n"];

(* Split by k/m value *)
Do[
  label = rat;
  sub = Select[cases, Abs[#[[5]] - rat] < 0.02 &];
  If[Length[sub] >= 5,
    fvals = #[[6]] & /@ sub;
    nmod4 = #[[7]] & /@ sub;
    Print["k/m ≈ ", rat, " (", Length[sub], " cases):"];
    Print["  conductor f: ", Tally[fvals] // SortBy[-#[[2]]&] // Short];
    Print["  n_sf mod 4:  ", Tally[nmod4]];
    (* Is f always a specific value? *)
    Print["  f mod 3:     ", Tally[Mod[fvals, 3]]];
    Print["  f mod 2:     ", Tally[Mod[fvals, 2]]];
    Print[]],
{rat, {1, 1/3, 1/2, 2/3, 3/2, 2, 3}}];

Print["=== KEY TEST: does k/m = k_theory / m? ===\n"];
Print["Theory: for order of conductor f, the unit index is"];
Print["  h(f) = f * prod_{p|f}(1 - (D/p)/p) / [O_K* : Z*]"];
Print["where D is the fundamental discriminant.\n"];

(* For each case: compute the theoretical unit index *)
Print["  n    c    f    k    m    k/m    n_sf mod4"];
Print["  ----+----+----+----+----+------+--------"];
Do[
  {n0, c0, k0, m0, rat, f0, nm4, nsf} = e;
  If[rat != 1 && c0 <= 5 && n0 <= 100,
    Print["  ", StringPadRight[ToString[n0],5],
      StringPadRight[ToString[c0],4],
      StringPadRight[ToString[f0],4],
      StringPadRight[ToString[k0],4],
      StringPadRight[ToString[m0],4],
      StringPadRight[ToString[N[rat,3]],7],
      nsf, " mod4=", nm4]],
{e, cases}];

Print["\n=== SIMPLE PREDICTOR SEARCH ===\n"];

(* For all m=3 cases: what distinguishes k=1 from k=3? *)
m3 = Select[cases, #[[4]] == 3 &];
m3k1 = Select[m3, #[[3]] == 1 &]; (* k/m = 1/3 *)
m3k3 = Select[m3, #[[3]] == 3 &]; (* k/m = 1 *)

Print["m=3 cases: ", Length[m3], " total"];
Print["  k=1 (k/m=1/3): ", Length[m3k1]];
Print["  k=3 (k/m=1):   ", Length[m3k3]];
Print[];

(* What's different? *)
Print["k=1 (k/m=1/3): n mod 4 distribution:"];
Print["  ", Tally[Mod[#[[1]], 4] & /@ m3k1]];
Print["  n_sf mod 4: ", Tally[#[[8]] & /@ m3k1 // (Mod[#, 4] &)]];
Print["  c values: ", Tally[#[[2]] & /@ m3k1] // SortBy[-#[[2]]&] // Short];

Print["\nk=3 (k/m=1): n mod 4 distribution:"];
Print["  ", Tally[Mod[#[[1]], 4] & /@ m3k3]];
Print["  n_sf mod 4: ", Tally[#[[8]] & /@ m3k3 // (Mod[#, 4] &)]];
Print["  c values: ", Tally[#[[2]] & /@ m3k3] // SortBy[-#[[2]]&] // Short];

(* Is it n_sf mod 4 == 1? *)
Print["\n=== HYPOTHESIS: k/m = 1/3 iff n_squarefree ≡ 1 mod 4 AND m=3? ===\n"];
m3_nsf1 = Select[m3, Mod[#[[8]], 4] == 1 &];
m3_nsf23 = Select[m3, Mod[#[[8]], 4] != 1 &];
Print["n_sf ≡ 1 mod 4: k values = ", Tally[#[[3]] & /@ m3_nsf1] // SortBy[-#[[2]]&]];
Print["n_sf ≡ 2,3 mod 4: k values = ", Tally[#[[3]] & /@ m3_nsf23] // SortBy[-#[[2]]&]];
