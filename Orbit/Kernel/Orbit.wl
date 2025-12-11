(* ::Package:: *)

(* Orbit: A collection of computational tools for mathematical explorations *)
(* This package aggregates multiple submodules for different mathematical topics *)

BeginPackage["Orbit`"];

(* Load submodules *)
Get["Orbit`PrimeOrbits`"];
Get["Orbit`Primorials`"];
Get["Orbit`SemiprimeFactorization`"];
Get["Orbit`ModularFactorials`"];
Get["Orbit`SquareRootRationalizations`"];
Get["Orbit`ChebyshevIntegralTheorem`"];
Get["Orbit`ChebyshevZeta`"];
Get["Orbit`LegacyPolynomials`"];
Get["Orbit`EgyptianFractions`"];
Get["Orbit`CunninghamRepresentation`"];
Get["Orbit`CircFunctions`"];
Get["Orbit`CyclotomicFFT`"];

(* The package context is now populated with symbols from submodules *)
(* All usage messages and definitions are in the respective submodule files *)

EndPackage[];
