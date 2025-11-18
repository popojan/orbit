#!/usr/bin/env python3
"""
Improved scatter plot with three categories based on factorization type
"""

import numpy as np
import matplotlib.pyplot as plt
import pickle

def is_prime(n):
    if n < 2:
        return False
    if n == 2:
        return True
    if n % 2 == 0:
        return False
    for i in range(3, int(np.sqrt(n)) + 1, 2):
        if n % i == 0:
            return False
    return True

def is_prime_power(n):
    """Check if n = p^k for some prime p and k >= 2"""
    if n < 4:
        return False

    # Try all potential bases up to sqrt(n)
    for p in range(2, int(n**0.5) + 1):
        if not is_prime(p):
            continue

        # Check if n is a power of p
        temp = n
        while temp > 1:
            if temp == p:
                return True
            if temp % p != 0:
                break
            temp //= p

        if temp == 1:
            return True

    return False

# Load data
with open('cache/optimal_exponents.pkl', 'rb') as f:
    data = pickle.load(f)

results = data['results']

# Categorize
primes = []
prime_powers = []
other_composites = []

for n, info in results.items():
    if not info['has_minimum'] or info['s_opt'] is None:
        continue

    s_opt = info['s_opt']

    if info['is_prime']:
        primes.append((n, s_opt))
    elif is_prime_power(n):
        prime_powers.append((n, s_opt))
    else:
        other_composites.append((n, s_opt))

# Create plot
fig, ax = plt.subplots(figsize=(14, 8))

# Plot each category
if prime_powers:
    n_pp, s_pp = zip(*prime_powers)
    ax.scatter(n_pp, s_pp, c='orange', s=60, alpha=0.7, marker='s',
              label=f'Prime powers p^k (k≥2): {len(n_pp)}', edgecolors='black', linewidth=0.5)

if primes:
    n_p, s_p = zip(*primes)
    ax.scatter(n_p, s_p, c='red', s=50, alpha=0.7, marker='o',
              label=f'Primes: {len(n_p)}', edgecolors='black', linewidth=0.5)

if other_composites:
    n_oc, s_oc = zip(*other_composites)
    ax.scatter(n_oc, s_oc, c='blue', s=40, alpha=0.5, marker='^',
              label=f'Other composites: {len(n_oc)}', edgecolors='black', linewidth=0.3)

# Horizontal lines for visual separation
ax.axhline(y=3.5, color='gray', linestyle='--', alpha=0.5, linewidth=1.5,
          label='Threshold (illustrative)')

ax.set_xlabel('n', fontsize=13)
ax.set_ylabel('$s^*(n)$ [optimal exponent]', fontsize=13)
ax.set_title('Optimal Exponent Distribution by Factorization Type\n' +
             'Three distinct groups: prime powers (lowest), primes (medium), other composites (highest)',
             fontsize=14, pad=15)
ax.legend(fontsize=11, loc='upper right', framealpha=0.95)
ax.grid(True, alpha=0.3)
ax.set_ylim(0.5, 5.5)

plt.tight_layout()
plt.savefig('visualizations/optimal-exponents-three-groups.pdf', dpi=300, bbox_inches='tight')
print("✓ Saved: visualizations/optimal-exponents-three-groups.pdf")

# Print statistics
print()
print("=" * 70)
print("STATISTICS BY CATEGORY")
print("=" * 70)
print()

print(f"Prime powers (p^k, k≥2): {len(prime_powers)}")
if prime_powers:
    s_vals = [s for n, s in prime_powers]
    print(f"  s* range: [{min(s_vals):.3f}, {max(s_vals):.3f}]")
    print(f"  Mean: {np.mean(s_vals):.3f}")
    print(f"  Examples: {sorted([n for n, s in prime_powers[:10]])}")
print()

print(f"Primes: {len(primes)}")
if primes:
    s_vals = [s for n, s in primes]
    print(f"  s* range: [{min(s_vals):.3f}, {max(s_vals):.3f}]")
    print(f"  Mean: {np.mean(s_vals):.3f}")
print()

print(f"Other composites: {len(other_composites)}")
if other_composites:
    s_vals = [s for n, s in other_composites]
    print(f"  s* range: [{min(s_vals):.3f}, {max(s_vals):.3f}]")
    print(f"  Mean: {np.mean(s_vals):.3f}")
    # Show some low s* examples
    low_s_examples = sorted(other_composites, key=lambda x: x[1])[:10]
    print(f"  Lowest s* examples: {[(n, f'{s:.2f}') for n, s in low_s_examples]}")
print()

print("=" * 70)
print("INTERPRETATION")
print("=" * 70)
print()
print("s*(n) kóduje 'faktorizační strukturu':")
print("  • Prime powers (orange): nejčistší struktura → nejnižší s*")
print("  • Primes (red): žádný exact hit → střední s*")
print("  • Other composites (blue): složitější faktorizace → nejvyšší s*")
print()
