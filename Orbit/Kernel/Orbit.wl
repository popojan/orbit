(* ::Package:: *)

(* Orbit: A collection of computational tools for mathematical explorations *)
(* This package aggregates multiple submodules for different mathematical topics *)

BeginPackage["Orbit`"];

(* Load submodules *)
Get["Orbit`Primorials`"];
Get["Orbit`SemiprimeFactorization`"];
Get["Orbit`ModularFactorials`"];
Get["Orbit`PellEquation`"];
Get["Orbit`SquareRootRationalizations`"];
Get["Orbit`ChebyshevIntegralTheorem`"];
Get["Orbit`LegacyPolynomials`"];
Get["Orbit`EgyptianFractions`"];
Get["Orbit`CunninghamRepresentation`"];
Get["Orbit`CircFunctions`"];
Get["Orbit`CyclotomicFFT`"];
Get["Orbit`MoebiusInvolutions`"];
Get["Orbit`FibonacciFractions`"];
Get["Orbit`SignCosineIdentities`"];
Get["Orbit`EulerEConvergents`"];
Get["Orbit`PiConvergents`"];
Get["Orbit`LogarithmIntervals`"];
Get["Orbit`FunctionIntervals`"];
Get["Orbit`GoldilocksEncoding`"];
Get["Orbit`FareyBits`"];
Get["Orbit`ChebyshevDisk`"];
Get["Orbit`PellCompactEncoding`"];
Get["Orbit`PellChebyshevSolve`"];
(* PellFactorBase requires PARI/GP — load manually: Get["Orbit`PellFactorBase`"] *)
Get["Orbit`SuccessorOrbit`"];

EndPackage[];
