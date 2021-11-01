in vec3 vNormal;
uniform sampler2D newImage; // we need a new sampler to override the native .mtl texture

vec4 color(vec4 graphicsColor, sampler2D image, vec2 uv) 
{
    vec4 baseColor = graphicsColor * texture(newImage, uv); 
    return baseColor;
}