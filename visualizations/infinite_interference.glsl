vec2 cmul(vec2 a, vec2 b) {
    return vec2(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
}

vec2 cdiv(vec2 a, vec2 b) {
    return cmul(a, vec2(b.x, -b.y))/pow(length(b),2.0);
}
vec2 cpow(vec2 x, float k) {
    float arg = k * atan(x.y, x.x);
    return pow(length(x),k)*vec2(cos(arg),sin(arg));
}

vec2 subnreff(in float x, in float k) {
   vec2 r = vec2(0.0, sqrt(x*x*(1.0 - x*x)));
   return cmul(cpow(vec2(-1.0,0.0),k),cdiv(cmul(r, 
    
        cpow(vec2(1.0 - 2.0*x*x,0.0) - 2.0*r,k)
      - cpow(vec2(1.0 - 2.0*x*x,0.0) + 2.0*r,k)
    ), vec2(2.0 * x,0.0)));
}

vec4 render(vec2 uv, float k) {
    vec2 y = subnreff(uv.x, k);
    return vec4(vec3(
        length(uv) <= 1.0 ? 1.0: 0.0,
        abs(y.y) > abs(uv.y) && sign(y.y) == sign(uv.y) ? 1.0 : 0.0,
        abs(y.x) > abs(uv.y) && sign(y.x) == sign(uv.y) ? 1.0 : 0.0
        ),1.0);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = 2.0 * (fragCoord/iResolution.xy-0.5);
    uv.x *= iResolution.x/iResolution.y;
    uv *= 1.1;
    float a = 2.0 * 3.141592653579 * iTime / 60.0;
    uv = vec2(uv.x*cos(a) - uv.y*sin(a), uv.x*sin(a)+uv.y*cos(a));
    
    float k = iTime;
    fragColor = 0.2*(
    render(uv, k)
    + render(uv+vec2( 1.0, 1.0)*vec2(1.0/iResolution),k)
    + render(uv+vec2( 1.0,-1.0)*vec2(1.0/iResolution),k)
    + render(uv+vec2(-1.0,-1.0)*vec2(1.0/iResolution),k)
    + render(uv+vec2(-1.0, 1.0)*vec2(1.0/iResolution),k)
    );
    
}
