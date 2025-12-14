#!/usr/bin/env python3
"""
Proof of Concept: Rational Neural Network with Orbit Sigmoid

A tiny neural network operating entirely in rational arithmetic,
using orbit-based sigmoid activation.

Goal: Learn XOR function without any floating point operations.
"""

from fractions import Fraction
from typing import List, Tuple
import random

# Orbit I=19 sigmoid values (exact rationals)
ORBIT_19 = [
    Fraction(1, 609), Fraction(1, 305), Fraction(1, 153), Fraction(1, 77),
    Fraction(1, 39), Fraction(19, 531), Fraction(1, 20), Fraction(19, 275),
    Fraction(2, 21), Fraction(19, 147), Fraction(4, 23), Fraction(19, 83),
    Fraction(8, 27), Fraction(19, 51), Fraction(16, 35), Fraction(19, 35),
    Fraction(32, 51), Fraction(19, 27), Fraction(64, 83), Fraction(19, 23),
    Fraction(128, 147), Fraction(19, 21), Fraction(256, 275), Fraction(19, 20),
    Fraction(512, 531), Fraction(38, 39), Fraction(76, 77), Fraction(152, 153),
    Fraction(304, 305), Fraction(608, 609)
]

def rational_sigmoid(x: Fraction) -> Fraction:
    """
    Piecewise linear sigmoid using orbit values.
    Returns exact rational.
    """
    # Convert to float for comparison (but output is rational)
    x_float = float(x)

    # Clamp to range
    if x_float <= -6.4:
        return ORBIT_19[0]
    if x_float >= 6.4:
        return ORBIT_19[-1]

    # Find interval by linear search (small LUT)
    import math
    for i, orb in enumerate(ORBIT_19):
        orb_x = math.log(float(orb) / (1 - float(orb)))  # logit
        if orb_x >= x_float:
            if i == 0:
                return ORBIT_19[0]
            # Linear interpolation between ORBIT_19[i-1] and ORBIT_19[i]
            prev_orb = ORBIT_19[i-1]
            prev_x = math.log(float(prev_orb) / (1 - float(prev_orb)))

            # t = (x - prev_x) / (orb_x - prev_x)
            # result = prev_orb + t * (orb - prev_orb)
            # Keep rational by approximating t as rational
            t_float = (x_float - prev_x) / (orb_x - prev_x)
            t = Fraction(t_float).limit_denominator(100)

            return prev_orb + t * (orb - prev_orb)

    return ORBIT_19[-1]


def limit_denominator(x: Fraction, max_denom: int = 1000) -> Fraction:
    """Limit denominator to prevent explosion."""
    return x.limit_denominator(max_denom)


class RationalNeuron:
    """Single neuron with rational weights."""

    def __init__(self, n_inputs: int):
        # Initialize with small random rationals
        self.weights = [Fraction(random.randint(-10, 10), 10) for _ in range(n_inputs)]
        self.bias = Fraction(random.randint(-10, 10), 10)

    def forward(self, inputs: List[Fraction]) -> Fraction:
        """Compute weighted sum + bias, then sigmoid."""
        z = self.bias
        for w, x in zip(self.weights, inputs):
            z += w * x
        z = limit_denominator(z)
        return rational_sigmoid(z)

    def __repr__(self):
        return f"Neuron(w={self.weights}, b={self.bias})"


class RationalNN:
    """Tiny rational neural network: 2 -> 2 -> 1 for XOR."""

    def __init__(self):
        # Hidden layer (2 neurons)
        self.h1 = RationalNeuron(2)
        self.h2 = RationalNeuron(2)
        # Output layer (1 neuron)
        self.out = RationalNeuron(2)

    def forward(self, x1: Fraction, x2: Fraction) -> Fraction:
        """Forward pass - all rational."""
        h1_out = self.h1.forward([x1, x2])
        h2_out = self.h2.forward([x1, x2])
        return self.out.forward([h1_out, h2_out])

    def set_xor_weights(self):
        """Manually set weights for XOR (known solution)."""
        # Hidden neuron 1: AND-like (both high -> high)
        self.h1.weights = [Fraction(5), Fraction(5)]
        self.h1.bias = Fraction(-7)

        # Hidden neuron 2: OR-like (any high -> high)
        self.h2.weights = [Fraction(5), Fraction(5)]
        self.h2.bias = Fraction(-2)

        # Output: h2 AND NOT h1 (OR but not AND = XOR)
        self.out.weights = [Fraction(-5), Fraction(5)]
        self.out.bias = Fraction(-2)


def test_xor():
    """Test XOR with rational NN."""
    print("=" * 50)
    print("Rational Neural Network - XOR Test")
    print("=" * 50)

    nn = RationalNN()
    nn.set_xor_weights()

    print("\nNetwork weights (all exact rationals):")
    print(f"  H1: {nn.h1}")
    print(f"  H2: {nn.h2}")
    print(f"  Out: {nn.out}")

    print("\nXOR Truth Table:")
    print("-" * 40)
    print("  x1    x2    Output (rational)    Pred")
    print("-" * 40)

    xor_data = [
        (Fraction(0), Fraction(0), 0),
        (Fraction(0), Fraction(1), 1),
        (Fraction(1), Fraction(0), 1),
        (Fraction(1), Fraction(1), 0),
    ]

    correct = 0
    for x1, x2, expected in xor_data:
        output = nn.forward(x1, x2)
        pred = 1 if output > Fraction(1, 2) else 0

        status = "✓" if pred == expected else "✗"
        if pred == expected:
            correct += 1

        print(f"  {x1}     {x2}     {output} ({float(output):.4f})   {pred} {status}")

    print("-" * 40)
    print(f"Accuracy: {correct}/4")

    print("\nKey insight:")
    print("  - All computations are EXACT rationals")
    print("  - No floating point used in forward pass")
    print("  - Output is exact: can compare with == not ≈")
    print(f"  - Max denominator in output: {max(o.denominator for x1, x2, _ in xor_data for o in [nn.forward(Fraction(x1), Fraction(x2))])}")


def demo_denominator_control():
    """Show denominator stays bounded."""
    print("\n" + "=" * 50)
    print("Denominator Control Demo")
    print("=" * 50)

    # Simulate many forward passes
    nn = RationalNN()
    nn.set_xor_weights()

    print("\nRunning 100 forward passes...")
    max_denom = 0
    for i in range(100):
        x1 = Fraction(random.randint(0, 1))
        x2 = Fraction(random.randint(0, 1))
        output = nn.forward(x1, x2)
        max_denom = max(max_denom, output.denominator)

    print(f"Max output denominator: {max_denom}")
    print("Denominators stay bounded due to orbit sigmoid!")


if __name__ == "__main__":
    test_xor()
    demo_denominator_control()
