#!/usr/bin/env python3
test_primes = [89, 113, 523, 1327, 31397]

for p in test_primes:
    mod4 = p % 4
    mod8 = p % 8
    print(f"p = {p:5d}:  p ≡ {mod4} (mod 4),  p ≡ {mod8} (mod 8)")
