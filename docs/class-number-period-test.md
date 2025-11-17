# Class Number vs Period Test

**Date**: 2025-11-17
**Status**: 🔬 NUMERICAL (94 primes < 500)

---

## Result

**Class number parity does NOT explain period divisibility.**

**Finding:**
```
p ≡ 3 (mod 8): ALL h(p) odd (25/25)
p ≡ 7 (mod 8): ALL h(p) odd (25/25)
```

**BUT:** h(p) mod 4 correlates with period LENGTH (not divisibility):
```
p ≡ 7, h ≡ 3 (mod 4): mean period = 4.0  (shorter!)
p ≡ 7, h ≡ 1 (mod 4): mean period = 13.5 (longer)

Examples: p=79,223,359 all have h=3, period=4
```

**Conclusion:**
- Period divisibility rule is NOT from h(p) mod 2
- Mechanism must be elsewhere (Rédei symbols, unit structure, 2-adic properties)
- h(p) mod 4 may affect MAGNITUDE but not DIVISIBILITY

**Reference**: `scripts/test_class_number_period_connection.wl`

---

🤖 Generated with Claude Code
