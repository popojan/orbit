\p 50
{
  my(n=13078849728, c=5);
  my(cn = c^2*n);
  my(a0 = sqrtint(cn), r = cn - a0^2);
  printf("c^2*n = %d\n", cn);
  printf("a0 = %d, r = %d\n", a0, r);
  printf("z = %s, delta = %d\n", (2*a0^2+r)/r, denominator((2*a0^2+r)/r));
  printf("r | 2*a0? %d\n", (2*a0) % r == 0);
  printf("arccosh(6649) = %.30f\n", acosh(6649.0));
  printf("42 * arccosh(6649) = %.30f\n", 42*acosh(6649.0));
  my(R = quadregulator(4*n));
  printf("R_field(n) = %.30f\n", R);
  printf("norm(fund.unit) = %d\n", norm(quadunit(4*n)));
  my(Rpell = if(norm(quadunit(4*n)) < 0, 2*R, R));
  printf("R_pell(n) = %.30f\n", Rpell);
  printf("R_pell / arccosh(6649) = %.15f\n", Rpell / acosh(6649.0));
  printf("R_pell / (42*arccosh(6649)) = %.15f\n", Rpell / (42*acosh(6649.0)));
}
