#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_COLOR_SHADER

varying vec4 vertTexCoord;

float rnd(vec2 x)
{
    int n = int(x.x * 40.0 + x.y * 6400.0);
    n = (n << 13) ^ n;
    return 1.0 - float( (n * (n * n * 15731 + 789221) + 1376312589) & 0x7fffffff) / 1073741824.0;
}

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}
void main(void) {
vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
float v =rand(p);
  gl_FragColor = vec4(v,v,v, 0.1);
}
