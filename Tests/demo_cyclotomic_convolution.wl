(* Demo: Fully Rational FFT — Convolution & Deconvolution

   Why CyclotomicFFT?
   Standard FFT uses floating-point complex numbers. CyclotomicFFT keeps
   everything in ℚ(ζₙ) — exact rational arithmetic, no rounding errors.

   This demo shows the full pipeline:
   1. Forward DFT (rational)
   2. Pointwise multiply in frequency domain (convolution)
   3. Pointwise divide in frequency domain (deconvolution)
   4. Inverse DFT (rational)

   All intermediate values are exact rationals. No floats anywhere.
*)

<< Orbit`

(* === Signal Setup — length 5 forces ℚ(ζ₅) === *)
(* ζ₅ = e^(2πi/5), minimal polynomial z⁴+z³+z²+z+1 over ℚ *)
(* Elements are a + bζ + cζ² + dζ³ — NOT expressible as a+bi *)
(* Inverses require extended GCD mod Φ₅, not just conjugation *)
a = {1, 2, 3, 4, 5};
b = {2, 1, 0, 3, 1};

Print["=== Fully Rational Convolution ==="];
Print["a = ", a];
Print["b = ", b];

(* === Forward DFT — all coefficients are rational === *)
fa = CyclotomicDFT[a];
fb = CyclotomicDFT[b];

Print["\nDFT(a) coefficients (all rational):"];
Print["  ", CyclotomicCoeffs /@ fa];

Print["\nDFT(b) coefficients (all rational):"];
Print["  ", CyclotomicCoeffs /@ fb];

(* === Convolution: pointwise multiply in frequency domain === *)
fab = MapThread[CyclotomicMultiply, {fa, fb}];

Print["\nDFT(a) * DFT(b) coefficients:"];
Print["  ", CyclotomicCoeffs /@ fab];

(* === Inverse DFT — back to rationals === *)
conv = CyclotomicToRational /@ CyclotomicInverseDFT[fab];

Print["\nCircular convolution a*b = ", conv];
Print["Verify vs ListConvolve:    ", ListConvolve[a, b, 1]];

(* === Deconvolution: recover a from a*b by dividing out b === *)
Print["\n=== Deconvolution (new!) ==="];
Print["Given conv = a*b and b, recover a via frequency-domain division."];

recovered = MapThread[CyclotomicDivide, {fab, fb}];
aBack = CyclotomicToRational /@ CyclotomicInverseDFT[recovered];

Print["\nRecovered a = ", aBack];
Print["Original  a = ", a];
Print["Match: ", aBack === a];

(* === Inverse in ℚ(ζ₅) — this is where it gets interesting === *)
(* In ℚ(ζ₄) = ℚ(i), inverse is just conjugate/norm — trivial.
   In ℚ(ζ₅), elements have 4 rational coefficients and no simple
   conjugation trick. You'd need to solve in a degree-4 extension.
   CyclotomicInverse handles this generically via extended GCD mod Φ₅. *)
Print["\n=== Multiplicative Inverse in ℚ(ζ₅) ==="];
elem = CyclotomicElement[5, {1, 2, 0, -1}];  (* 1 + 2ζ - ζ³ *)
inv = CyclotomicInverse[elem];
Print["Element:    ", CyclotomicCoeffs[elem], "  (= 1 + 2\[Zeta] - \[Zeta]^3)"];
Print["Inverse:    ", CyclotomicCoeffs[inv], "  (try computing this by hand!)"];
Print["Product:    ", CyclotomicCoeffs[CyclotomicMultiply[elem, inv]]];
Print["Should be:  {1, 0, 0, 0}"];
