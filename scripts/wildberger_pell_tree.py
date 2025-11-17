#!/usr/bin/env python3
"""
Wildberger's Integer-Only Pell Equation Algorithm with Tree Structure Analysis

Reference: https://cs.uwaterloo.ca/journals/JIS/VOL13/Wildberger/wildberger2.pdf

Explores connection between:
- Wildberger tree structure (L/R binary path)
- Stern-Brocot tree (continued fractions)
- Primal forest M(d) function

Author: Jan Popelka
Date: 2025-11-17
"""

import math
from typing import Dict, List, Tuple, Optional
from dataclasses import dataclass
from collections import defaultdict


@dataclass
class PellSolution:
    """Represents a Pell equation solution"""
    x: int
    y: int
    d: int
    norm: int  # x² - d*y²

    def check(self) -> int:
        """Verify norm: should be ±1 or ±d"""
        return self.x**2 - self.d * self.y**2

    def __str__(self):
        return f"({self.x}, {self.y})"


@dataclass
class IntermediateSolution:
    """Intermediate solution found during tree traversal"""
    solution: PellSolution
    depth: int
    path: List[str]
    solution_type: str  # "NegativePell", "Fundamental", etc.


def pellsol(d: int) -> PellSolution:
    """
    Wildberger's algorithm for fundamental solution of x² - dy² = 1

    Original Wolfram code:
    pellsol[d_] := Module[
      { a = 1, b = 0, c = -d, t, u = 1, v = 0, r = 0, s = 1},
      While[t = a + b + b + c; If[t > 0,
        a = t; b += c; u += v; r += s,
        b += a; c = t; v += u; s += r];
        Not[a == 1 && b == 0 && c == -d]
      ]; {x -> u, y -> r} ]
    """
    a, b, c = 1, 0, -d
    u, v, r, s = 1, 0, 0, 1

    while True:
        t = a + b + b + c
        if t > 0:
            # Right branch
            a = t
            b += c
            u += v
            r += s
        else:
            # Left branch
            b += a
            c = t
            v += u
            s += r

        # Check termination: back to (1, 0, -d)
        if a == 1 and b == 0 and c == -d:
            break

    return PellSolution(x=u, y=r, d=d, norm=u**2 - d*r**2)


def pellsol_with_path(d: int) -> Dict:
    """
    Enhanced version: track L/R path sequence
    """
    a, b, c = 1, 0, -d
    u, v, r, s = 1, 0, 0, 1
    path = []

    while True:
        t = a + b + b + c
        if t > 0:
            # Right branch
            path.append("R")
            a = t
            b += c
            u += v
            r += s
        else:
            # Left branch
            path.append("L")
            b += a
            c = t
            v += u
            s += r

        # Check termination
        if a == 1 and b == 0 and c == -d:
            break

    sol = PellSolution(x=u, y=r, d=d, norm=u**2 - d*r**2)

    return {
        "solution": sol,
        "path": path,
        "path_string": "".join(path),
        "length": len(path),
        "palindrome": path == path[::-1]
    }


def pellsol_with_intermediate(d: int) -> Dict:
    """
    CRITICAL: Track intermediate solutions (negative Pell x² - dy² = -1)

    Negative Pell solution exists iff continued fraction period is odd.
    When it exists, it appears at exactly half-depth of fundamental solution.
    """
    a, b, c = 1, 0, -d
    u, v, r, s = 1, 0, 0, 1
    path = []
    intermediate_solutions = []

    step = 0
    while True:
        t = a + b + b + c
        if t > 0:
            # Right branch
            path.append("R")
            a = t
            b += c
            u += v
            r += s
        else:
            # Left branch
            path.append("L")
            b += a
            c = t
            v += u
            s += r

        step += 1

        # Check for intermediate solutions
        # Key: invariant is a*c - b², track this!
        invariant = a * c - b * b
        norm = u**2 - d*r**2

        # Negative Pell occurs when invariant = +d (flipped sign)
        if invariant == d:
            # Check if this is actually solving x² - dy² = -1
            if norm == -1:
                intermediate_solutions.append(IntermediateSolution(
                    solution=PellSolution(x=u, y=r, d=d, norm=norm),
                    depth=step,
                    path=path.copy(),
                    solution_type="NegativePell"
                ))

        # Check termination: back to starting invariant -d
        if a == 1 and b == 0 and c == -d:
            # Fundamental: x² - dy² = 1
            intermediate_solutions.append(IntermediateSolution(
                solution=PellSolution(x=u, y=r, d=d, norm=norm),
                depth=step,
                path=path.copy(),
                solution_type="Fundamental"
            ))
            break

    # Final solution
    sol = PellSolution(x=u, y=r, d=d, norm=u**2 - d*r**2)

    return {
        "solution": sol,
        "path": path,
        "path_string": "".join(path),
        "length": len(path),
        "palindrome": path == path[::-1],
        "intermediate_solutions": intermediate_solutions
    }


# ============================================================================
# Primal Forest Connection
# ============================================================================

def M_function(n: int) -> int:
    """
    M(n) from primal forest: count of divisors d with 2 ≤ d ≤ √n

    This is the number of "trees" at position n in primal forest visualization.
    Primes have M(p) = 0 (clear view).
    """
    if n < 4:
        return 0

    sqrt_n = math.isqrt(n)
    count = 0
    for d in range(2, sqrt_n + 1):
        if n % d == 0:
            count += 1
    return count


def divisor_count(n: int) -> int:
    """Total number of divisors (for reference)"""
    count = 0
    sqrt_n = math.isqrt(n)
    for d in range(1, sqrt_n + 1):
        if n % d == 0:
            count += 2 if d * d != n else 1
    return count


def is_prime(n: int) -> bool:
    """Simple primality test"""
    if n < 2:
        return False
    if n == 2:
        return True
    if n % 2 == 0:
        return False
    for i in range(3, math.isqrt(n) + 1, 2):
        if n % i == 0:
            return False
    return True


# ============================================================================
# Analysis Functions
# ============================================================================

def analyze_intermediate_solutions(d_max: int) -> Dict:
    """
    Analyze which d values have negative Pell solutions

    Key question: Is there correlation between:
    - Having negative Pell solution
    - Primality of d
    - M(d) value (primal forest complexity)
    """
    has_neg_pell = []
    no_neg_pell = []

    print("=== Intermediate Solutions Analysis ===\n")

    for d in range(2, d_max + 1):
        # Skip perfect squares
        sqrt_d = math.isqrt(d)
        if sqrt_d * sqrt_d == d:
            continue

        data = pellsol_with_intermediate(d)

        # Find negative Pell solutions
        neg_pell = [s for s in data["intermediate_solutions"]
                    if s.solution_type == "NegativePell"]

        info = {
            "d": d,
            "is_prime": is_prime(d),
            "M_d": M_function(d),
            "path_length": data["length"],
            "has_negative_pell": len(neg_pell) > 0,
            "intermediate_solutions": data["intermediate_solutions"]
        }

        if neg_pell:
            has_neg_pell.append(info)
        else:
            no_neg_pell.append(info)

    # Statistics
    print(f"d values with negative Pell solution: {len(has_neg_pell)} / {len(has_neg_pell) + len(no_neg_pell)}")
    print(f"d values WITHOUT negative Pell: {len(no_neg_pell)}")
    print()

    # Show examples with negative Pell
    print("Examples with negative Pell (x² - dy² = -1):")
    for info in has_neg_pell[:10]:
        d = info["d"]
        neg_sol = [s for s in info["intermediate_solutions"]
                   if s.solution_type == "NegativePell"][0]
        fund_sol = [s for s in info["intermediate_solutions"]
                    if s.solution_type == "Fundamental"][0]

        print(f"  d={d} {'(prime)' if info['is_prime'] else '(composite)'}")
        print(f"    Negative Pell at depth {neg_sol.depth}: {neg_sol.solution} (check: {neg_sol.solution.check()})")
        print(f"    Fundamental at depth {fund_sol.depth}: {fund_sol.solution} (check: {fund_sol.solution.check()})")
        print(f"    Depth ratio: {fund_sol.depth / neg_sol.depth:.2f}")
        print(f"    M(d) = {info['M_d']}")
    print()

    # Check depth ratio = 2 property
    if has_neg_pell:
        ratios = []
        for info in has_neg_pell:
            neg_sol = [s for s in info["intermediate_solutions"]
                       if s.solution_type == "NegativePell"][0]
            fund_sol = [s for s in info["intermediate_solutions"]
                        if s.solution_type == "Fundamental"][0]
            ratios.append(fund_sol.depth / neg_sol.depth)

        print("Depth ratio (Fundamental / NegativePell):")
        print(f"  Mean: {sum(ratios) / len(ratios):.3f}")
        print(f"  All equal to 2? {all(r == 2 for r in ratios)}")
        print()

    # Pattern analysis
    print("d values with negative Pell (first 30):")
    print(" ", [info["d"] for info in has_neg_pell[:30]])
    print("d values WITHOUT negative Pell (first 30):")
    print(" ", [info["d"] for info in no_neg_pell[:30]])
    print()

    return {
        "has_neg_pell": has_neg_pell,
        "no_neg_pell": no_neg_pell
    }


def compare_prime_composite_paths(d_max: int):
    """
    Compare Wildberger path lengths for prime vs composite d
    """
    prime_paths = []
    composite_paths = []

    for d in range(2, d_max + 1):
        sqrt_d = math.isqrt(d)
        if sqrt_d * sqrt_d == d:
            continue

        data = pellsol_with_path(d)

        if is_prime(d):
            prime_paths.append((d, data["length"]))
        else:
            composite_paths.append((d, data["length"]))

    print("=== Path Length vs. Primality ===\n")
    if prime_paths:
        avg_prime = sum(l for _, l in prime_paths) / len(prime_paths)
        print(f"Prime d: mean path length = {avg_prime:.2f}")
    if composite_paths:
        avg_composite = sum(l for _, l in composite_paths) / len(composite_paths)
        print(f"Composite d: mean path length = {avg_composite:.2f}")
    print()


def explore_M_function_connection(d_max: int):
    """
    Hypothesis: Is Pell path length correlated with M(d)?

    M(d) measures factorization complexity (primal forest).
    Path length measures continued fraction / Pell complexity.
    """
    data = []

    for d in range(2, d_max + 1):
        sqrt_d = math.isqrt(d)
        if sqrt_d * sqrt_d == d:
            continue

        pell_data = pellsol_with_path(d)
        m_d = M_function(d)

        data.append({
            "d": d,
            "M_d": m_d,
            "path_length": pell_data["length"],
            "is_prime": is_prime(d)
        })

    print("=== M(d) vs. Wildberger Path Length ===\n")
    print("M(d) = count of divisors in [2,√d] (primal forest)")
    print()

    # Group by M(d) value
    by_m = defaultdict(list)
    for item in data:
        by_m[item["M_d"]].append(item["path_length"])

    print("Average path length by M(d):")
    for m in sorted(by_m.keys())[:10]:
        avg_length = sum(by_m[m]) / len(by_m[m])
        print(f"  M(d)={m}: avg path = {avg_length:.2f} (n={len(by_m[m])})")
    print()

    # Specific examples
    print("Examples (d, M(d), path_length, prime?):")
    for item in data[:20]:
        print(f"  d={item['d']:3d}: M={item['M_d']}, path={item['path_length']:2d}, "
              f"{'PRIME' if item['is_prime'] else 'composite'}")
    print()


def analyze_path_patterns(d_max: int):
    """
    Analyze L/R pattern structure
    """
    patterns = defaultdict(int)
    palindrome_count = 0
    total = 0

    for d in range(2, d_max + 1):
        sqrt_d = math.isqrt(d)
        if sqrt_d * sqrt_d == d:
            continue

        data = pellsol_with_path(d)
        patterns[data["path_string"]] += 1
        if data["palindrome"]:
            palindrome_count += 1
        total += 1

    print("=== Path Pattern Analysis ===\n")
    print(f"Total unique paths for d ∈ [2,{d_max}]: {len(patterns)}")
    print()

    # Most common paths
    print("Most common paths:")
    sorted_patterns = sorted(patterns.items(), key=lambda x: -x[1])
    for path, count in sorted_patterns[:10]:
        print(f"  {path}: {count} times")
    print()

    print(f"Palindromic paths: {palindrome_count} / {total} ({100*palindrome_count/total:.1f}%)")
    print()


# ============================================================================
# Main Execution
# ============================================================================

def main():
    print("╔═══════════════════════════════════════════════════════════════╗")
    print("║  Wildberger Pell Algorithm: Tree Structure Exploration       ║")
    print("╚═══════════════════════════════════════════════════════════════╝")
    print()

    # Test original algorithm
    print("=== Testing Original Algorithm ===\n")
    for d in [2, 3, 5, 7, 11, 13]:
        sqrt_d = math.isqrt(d)
        if sqrt_d * sqrt_d == d:
            continue

        sol = pellsol(d)
        print(f"d={d}: (x,y) = {sol}, check: {sol.check()} == 1")
    print()

    # Analyze path structure
    print("=== Path Structure Analysis ===\n")
    print(f"{'d':>3} {'x':>6} {'y':>6} {'Path Len':>9} {'L/R Sequence':>20} {'Palindrome?':>11}")
    print("-" * 70)

    for d in range(2, 21):
        sqrt_d = math.isqrt(d)
        if sqrt_d * sqrt_d == d:
            continue

        data = pellsol_with_path(d)
        sol = data["solution"]
        path_str = data["path_string"][:20] + ("..." if len(data["path_string"]) > 20 else "")

        print(f"{d:3d} {sol.x:6d} {sol.y:6d} {data['length']:9d} {path_str:>20} "
              f"{'YES' if data['palindrome'] else 'NO':>11}")
    print()

    # Run explorations
    d_max = 100
    print(f"Running explorations for d ≤ {d_max}...\n")

    analyze_path_patterns(d_max)
    compare_prime_composite_paths(d_max)
    explore_M_function_connection(d_max)

    # CRITICAL: Analyze intermediate solutions (negative Pell)
    print("=== INTERMEDIATE SOLUTIONS (Negative Pell x²-dy²=-1) ===\n")
    interm_results = analyze_intermediate_solutions(d_max)

    print("\n" + "="*70)
    print("Analysis complete!")


if __name__ == "__main__":
    main()
