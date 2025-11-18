#!/usr/bin/env python3
import sys
sys.path.append('/home/user/orbit/scripts')
from pell_solver_integer import continued_fraction_period, pell_fundamental_solution

# Check p=89
a0, period = continued_fraction_period(89)
print(f"√89 = [{a0}; {period}]")
print(f"CF minimal period length: {len(period)}")

x0, y0 = pell_fundamental_solution(89)
print(f"\nFundamental solution: x₀={x0}, y₀={y0}")
print(f"Verify: {x0}² - 89·{y0}² = {x0**2 - 89*y0**2}")

# Also check 113
a0, period = continued_fraction_period(113)
print(f"\n√113 = [{a0}; {period}]")
print(f"CF minimal period length: {len(period)}")

x0, y0 = pell_fundamental_solution(113)
print(f"Fundamental solution: x₀={x0}, y₀={y0}")
print(f"Verify: {x0}² - 113·{y0}² = {x0**2 - 113*y0**2}")
