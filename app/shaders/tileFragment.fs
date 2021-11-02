in vec3 vNormal;
uniform sampler2D tileTexture; // we need a new sampler to override the native .mtl texture

vec4 color(vec4 graphicsColor, sampler2D image, vec2 uv) 
{
    vec4 baseColor = graphicsColor * texture(tileTexture, uv); 
    return baseColor;
}