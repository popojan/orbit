(* ::Package:: *)

(* Orbit: A collection of computational tools for mathematical explorations *)
(* This package aggregates multiple submodules for different mathematical topics *)

BeginPackage["Orbit`"];

(* Load submodules *)
Get["Orbit`Primorials`"];
Get["Orbit`SemiprimeFactorization`"];
Get["Orbit`ModularFactorials`"];
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

(* The package context is now populated with symbols from submodules *)
(* All usage messages and definitions are in the respective submodule files *)

EndPackage[];
