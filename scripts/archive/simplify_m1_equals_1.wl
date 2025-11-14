#!/usr/bin/env wolframscript
(* Simplify nested Chebyshev formula when m1=1 *)

sqrttrf[nn_,n_,m_]:=(n^2+nn)/(2 n)+(n^2-nn)/(2 n)*ChebyshevU[m-1,Sqrt[nn/(-n^2+nn)]]/ChebyshevU[m+1,Sqrt[nn/(-n^2+nn)]]//Simplify;
sym[nn_,n_,m_]:=Module[{x=sqrttrf[nn,n,m]},nn/(2 x)+x/2];
nestqrt[nn_,n_,{m1_,m2_}]:=Nest[sym[nn,#,m1]&,n,m2];

Print["Simplifying nestqrt[nn, n, {1, m2}] for various m2:"];
Print[""];

Print["m2=1: ", nestqrt[nn, n, {1, 1}] // Simplify];
Print[""];

Print["m2=2: ", nestqrt[nn, n, {1, 2}] // Simplify];
Print[""];

Print["m2=3: ", nestqrt[nn, n, {1, 3}] // Simplify];
