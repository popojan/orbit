# Finite Abelian Groups Quick Course
## From Products to Primary Decomposition

**Goal:** Understand when group factorizations are isomorphic, with application to (Z/nZ)*
**Approach:** Socratic questions within each chapter
**Commitment:** Minimal theory, maximal insight

---

## Structure

1. **Motivation - When are factorizations "the same"?**
2. **Cyclic groups and their products**
3. **The Primary Decomposition Theorem**
4. **Application: Multiplicative groups (Z/nZ)***
5. **Case study: The 77-structure of Euler's e**

---

## Chapter 1: Motivation - When Are Factorizations "The Same"?

### The Question

Consider the number 60 = 2² × 3 × 5.

We can write products of cyclic groups with order 60:
- C₆₀ (one cyclic group)
- C₂ × C₃₀
- C₆ × C₁₀
- C₄ × C₁₅
- C₂ × C₂ × C₁₅

**Socratic Question 1:**
Are all of these the "same" group? If you pick any factorization of 60, do you get an isomorphic group?
*Hint: Think about what properties would distinguish them.*

---

### A Distinguishing Property

**Key observation:** In a group G, the **maximum order** of any element is an invariant.

- In C₆₀: max order = 60 (the generator has order 60)
- In C₆ × C₁₀: max order = ?

**Socratic Question 2:**
What's the maximum order of an element in C₆ × C₁₀?
*Hint: An element (a, b) has order lcm(ord(a), ord(b)).*

---

### Computing Maximum Order

In C₆ × C₁₀:
- Element (a, b) where a ∈ C₆, b ∈ C₁₀
- Order of (a, b) = lcm(ord(a), ord(b))
- Maximum possible: lcm(6, 10) = 30

So max order in C₆ × C₁₀ is **30**, not 60!

**Conclusion:** C₆₀ ≇ C₆ × C₁₀ (they have different max orders)

**Socratic Question 3:**
Is C₆ × C₁₀ isomorphic to C₂ × C₃₀? What are their max orders?
*Hint: Compute lcm(2, 30).*

---

### Two Classes Emerge

For order 60, groups split into two non-isomorphic classes:

| Class | Example | Max order |
|-------|---------|-----------|
| A | C₆₀, C₄ × C₁₅ | 60 |
| B | C₂ × C₃₀, C₆ × C₁₀ | 30 |

**Socratic Question 4:**
What's the key difference between Class A and Class B?
*Hint: Look at the power of 2 in the factorization.*

---

## Chapter 2: Cyclic Groups and Their Products

### When Is a Product Cyclic?

**Theorem:** Cₘ × Cₙ is cyclic if and only if gcd(m, n) = 1.

When gcd(m, n) = 1: Cₘ × Cₙ ≅ Cₘₙ

Examples:
- C₂ × C₃ ≅ C₆ (gcd = 1) ✓
- C₄ × C₃ ≅ C₁₂ (gcd = 1) ✓
- C₂ × C₄ ≇ C₈ (gcd = 2) ✗

**Socratic Question 5:**
Is C₆ × C₁₀ cyclic? What about C₆ × C₇?
*Hint: Compute gcd(6, 10) and gcd(6, 7).*

---

### Proof Sketch

**Why Cₘ × Cₙ ≅ Cₘₙ when gcd(m, n) = 1:**

Let g = (a, b) where a generates Cₘ and b generates Cₙ.
- ord(g) = lcm(m, n) = mn (since gcd = 1)
- So g generates a cyclic group of order mn
- That's all of Cₘ × Cₙ!

**Why it fails when gcd(m, n) > 1:**
- lcm(m, n) < mn
- No element has order mn
- Group cannot be cyclic

**Socratic Question 6:**
In C₂ × C₄, what's the maximum order of any element? List all element orders.
*Hint: C₂ = {0, 1}, C₄ = {0, 1, 2, 3}. Compute order of each (a, b).*

---

### Element Orders in C₂ × C₄

| Element | Order in C₂ | Order in C₄ | Order in C₂ × C₄ |
|---------|-------------|-------------|-------------------|
| (0, 0) | 1 | 1 | 1 |
| (0, 1) | 1 | 4 | 4 |
| (0, 2) | 1 | 2 | 2 |
| (0, 3) | 1 | 4 | 4 |
| (1, 0) | 2 | 1 | 2 |
| (1, 1) | 2 | 4 | 4 |
| (1, 2) | 2 | 2 | 2 |
| (1, 3) | 2 | 4 | 4 |

Max order = 4, not 8. So C₂ × C₄ ≇ C₈.

**Socratic Question 7:**
How many elements of order 2 does C₂ × C₄ have? How many does C₈ have?
*Hint: This is another invariant distinguishing groups.*

---

## Chapter 3: The Primary Decomposition Theorem

### The Fundamental Theorem

**Theorem (Fundamental Theorem of Finite Abelian Groups):**

Every finite abelian group G is isomorphic to a product of cyclic groups of prime power order:

$$G \cong C_{p_1^{a_1}} \times C_{p_2^{a_2}} \times \cdots \times C_{p_k^{a_k}}$$

This decomposition is **unique** (up to reordering).

**Socratic Question 8:**
What's the primary decomposition of C₆?
*Hint: 6 = 2 × 3, and gcd(2, 3) = 1.*

---

### Examples

**C₆:** 6 = 2 × 3
- C₆ ≅ C₂ × C₃ (primary decomposition)

**C₁₂:** 12 = 4 × 3 = 2² × 3
- C₁₂ ≅ C₄ × C₃ (primary decomposition)

**C₆ × C₁₀:**
- C₆ = C₂ × C₃
- C₁₀ = C₂ × C₅
- Combined: C₂ × C₃ × C₂ × C₅ = **C₂ × C₂ × C₃ × C₅**

**Socratic Question 9:**
What's the primary decomposition of C₆₀? Compare with C₆ × C₁₀.
*Hint: 60 = 4 × 15 or 60 = 6 × 10. Factor into prime powers.*

---

### The Key Insight

**C₆₀:**
- 60 = 2² × 3 × 5
- C₆₀ ≅ C₄ × C₃ × C₅ (primary decomposition)

**C₆ × C₁₀:**
- C₆ × C₁₀ = C₂ × C₃ × C₂ × C₅ = C₂ × C₂ × C₃ × C₅

Compare the **2-primary parts**:
- C₆₀ has C₄
- C₆ × C₁₀ has C₂ × C₂

These are different! So C₆₀ ≇ C₆ × C₁₀.

**Socratic Question 10:**
Two groups of order 60 are isomorphic if and only if their primary decompositions match. How many non-isomorphic abelian groups of order 60 are there?
*Hint: The 3-part and 5-part are forced. Only the 2-part varies.*

---

### Counting Groups of Order 60

60 = 2² × 3 × 5

- **2-part (order 4):** C₄ or C₂ × C₂ (two choices)
- **3-part (order 3):** C₃ (only choice)
- **5-part (order 5):** C₅ (only choice)

Total: **2 non-isomorphic abelian groups of order 60**

| Group | 2-part | Primary decomposition |
|-------|--------|----------------------|
| Type A | C₄ | C₄ × C₃ × C₅ |
| Type B | C₂ × C₂ | C₂ × C₂ × C₃ × C₅ |

**Socratic Question 11:**
How many non-isomorphic abelian groups of order 72 = 2³ × 3² are there?
*Hint: Count partitions of the exponents.*

---

## Chapter 4: Multiplicative Groups (Z/nZ)*

### Definition

The **multiplicative group** (Z/nZ)* consists of integers mod n that are coprime to n, under multiplication.

Example: (Z/8Z)* = {1, 3, 5, 7} (four elements coprime to 8)

**Socratic Question 12:**
What is |(Z/12Z)*|? List its elements.
*Hint: Find all k ∈ {1,...,11} with gcd(k, 12) = 1.*

---

### Euler's Totient Function

|(Z/nZ)*| = φ(n) (Euler's totient function)

For prime p: φ(p) = p - 1
For prime power: φ(pᵏ) = pᵏ - pᵏ⁻¹ = pᵏ⁻¹(p - 1)
Multiplicative: φ(mn) = φ(m)φ(n) when gcd(m,n) = 1

Example: φ(12) = φ(4)φ(3) = 2 × 2 = 4

**Socratic Question 13:**
Compute φ(77).
*Hint: 77 = 7 × 11, both prime.*

---

### Structure Theorem for (Z/nZ)*

**Chinese Remainder Theorem (for groups):**

If n = p₁^{a₁} × p₂^{a₂} × ··· × pₖ^{aₖ}, then:

$$(Z/nZ)^* \cong (Z/p_1^{a_1}Z)^* \times (Z/p_2^{a_2}Z)^* \times \cdots$$

For **odd prime p**: (Z/pᵏZ)* ≅ C_{φ(pᵏ)} (cyclic!)

For **p = 2**:
- (Z/2Z)* ≅ C₁
- (Z/4Z)* ≅ C₂
- (Z/2ᵏZ)* ≅ C₂ × C_{2^{k-2}} for k ≥ 3

**Socratic Question 14:**
What is the structure of (Z/7Z)*?
*Hint: 7 is an odd prime, φ(7) = 6.*

---

### Example: (Z/77Z)*

77 = 7 × 11

By CRT:
$$(Z/77Z)^* \cong (Z/7Z)^* \times (Z/11Z)^*$$

Now:
- (Z/7Z)* ≅ C₆ (since 7 is prime, φ(7) = 6)
- (Z/11Z)* ≅ C₁₀ (since 11 is prime, φ(11) = 10)

So:
$$(Z/77Z)^* \cong C_6 \times C_{10}$$

**Socratic Question 15:**
Is (Z/77Z)* cyclic? What's its primary decomposition?
*Hint: Check gcd(6, 10) and decompose each factor.*

---

### (Z/77Z)* in Detail

C₆ × C₁₀:
- gcd(6, 10) = 2 ≠ 1, so NOT cyclic
- Max order = lcm(6, 10) = 30

Primary decomposition:
- C₆ = C₂ × C₃
- C₁₀ = C₂ × C₅
- C₆ × C₁₀ = C₂ × C₂ × C₃ × C₅

**Invariant factor form:**
- gcd(6, 10) = 2
- lcm(6, 10) = 30
- C₆ × C₁₀ ≅ **C₂ × C₃₀**

**Socratic Question 16:**
Verify: C₂ × C₃₀ and C₂ × C₂ × C₃ × C₅ are the same group. Check element counts of each order.
*Hint: Both have order 60. Count elements of order 1, 2, 3, 5, 6, 10, 15, 30.*

---

## Chapter 5: Case Study - The 77-Structure of Euler's e

### The Connection

The continued fraction convergents to Euler's e involve a sequence sₙ satisfying:
- s₀ = 1, s₁ = 7
- sₙ = (4n + 2)sₙ₋₁ + sₙ₋₂

This sequence has remarkable divisibility properties related to 7 and 11!

**Socratic Question 17:**
s₁ = 7 and s₃ = 1001 = 7 × 11 × 13. Why might 7 and 11 be special here?
*Hint: Look at the initial conditions and early terms.*

---

### Divisibility Patterns

**Theorem:**
- 7 | sₙ ⟺ n ≡ 1, 3 (mod 7)
- 11 | sₙ ⟺ n ≡ 3, 5 (mod 11)

These can be proved by analyzing sₙ mod 7 and sₙ mod 11.

**Socratic Question 18:**
When does 77 | sₙ? Use the Chinese Remainder Theorem.
*Hint: Need both 7 | sₙ AND 11 | sₙ.*

---

### The CRT Solution

77 | sₙ requires:
- n ≡ 1 or 3 (mod 7), AND
- n ≡ 3 or 5 (mod 11)

By CRT, solve each combination:

| n mod 7 | n mod 11 | n mod 77 |
|---------|----------|----------|
| 1 | 3 | 36 |
| 1 | 5 | 71 |
| 3 | 3 | 3 |
| 3 | 5 | 38 |

**Result:** 77 | sₙ ⟺ n ≡ 3, 36, 38, 71 (mod 77)

**Socratic Question 19:**
The sequence sₙ mod 77 has period 44 = 4 × 11. But the zeros have period 77 = 7 × 11. What's the common factor?
*Hint: Look at which prime appears in both.*

---

### The Bridge: Prime 11

- Sequence period: 44 = 4 × **11**
- Zero period: 77 = 7 × **11**
- Group structure: (Z/77Z)* contains C₁₀ from (Z/11Z)*

The prime **11** is the bridge connecting:
1. The multiplicative structure C₁₀ = C₂ × C₅
2. The sequence periodicity (factor of 11)
3. The zero positions (period 77 = 7 × 11)

**Socratic Question 20:**
The group (Z/77Z)* ≅ C₂ × C₃₀ has 24 elements of order 30. Why 24?
*Hint: Count using the primary decomposition C₂ × C₂ × C₃ × C₅.*

---

### Final Calculation

Elements of order 30 in C₂ × C₂ × C₃ × C₅:

Order 30 = 2 × 3 × 5. Need lcm of component orders = 30.

Valid combinations where lcm = 30:
- (C₂ component, C₂ component, C₃ component, C₅ component)
- Need: max 2-order ≥ 1, 3-order = 3, 5-order = 5
- Count: 3 × 2 × 4 = 24 ✓

(The 3 comes from choosing which pattern in C₂ × C₂ gives order 2.)

---

## Summary

### Key Theorems

1. **Primary Decomposition:** Every finite abelian group decomposes uniquely into cyclic groups of prime power order.

2. **Isomorphism Test:** Two abelian groups are isomorphic iff their primary decompositions match.

3. **Product Rule:** Cₘ × Cₙ ≅ Cₘₙ iff gcd(m, n) = 1.

4. **CRT for Groups:** (Z/mnZ)* ≅ (Z/mZ)* × (Z/nZ)* when gcd(m,n) = 1.

### The 77 Connection to e

The arithmetic of Euler's e encodes the prime structure 77 = 7 × 11 through:
- Initial condition s₁ = 7
- Early term s₃ = 1001 = 7 × 11 × 13
- Group (Z/77Z)* ≅ C₂ × C₃₀ governing the divisibility patterns

---

## Exercises

1. Find all non-isomorphic abelian groups of order 36.
2. Determine the structure of (Z/100Z)*.
3. Prove that (Z/pZ)* is cyclic for any prime p.
4. Find the period of sₙ mod 7 and mod 11 separately.
5. Verify that sₙ mod 77 has period 44 by direct computation.

---

## Notes

**Created:** 2025-12-19
**Status:** Complete
**Connection:** Session `2025-12-18-bessel-ode-exploration` (77-structure of e)
