#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
//****MAKE SURE TO remove the parameters from mainImage.
//SHADERTOY PORT FIX

uniform float depth = 5.0f;
void main() {
    float dx = distance(openfl_TextureCoordv.x, 0.5f);
    float dy = distance(openfl_TextureCoordv.y, 0.5f);
        
    float offset = (dx * .2) * dy;
        
    float dir = 0.;
    if (openfl_TextureCoordv.y <= .5) dir = 1.0;
    else dir = -1.;
        
    vec2 coords = vec2(openfl_TextureCoordv.x, openfl_TextureCoordv.y + dx * (offset * depth * dir));
    gl_FragColor = flixel_texture2D(bitmap, coords);
}