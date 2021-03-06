
uniform vec4 liteColor;

uniform vec4 ambience;

in vec3 Normal;
in vec3 FragmentPos;
uniform vec3 lightPos;

uniform vec3 viewPos;
uniform float specularStrength;
uniform float metallic;

vec4 color(vec4 graphicsColor, sampler2D image, vec2 uv) 
{    
    //diffuse
    vec3 norm = normalize(Normal);
    vec3 lightDir = normalize(lightPos - FragmentPos);
    float diff = max(dot(norm, lightDir), 0.0);
    vec4 diffuse = diff * liteColor;
    
    //specular - ENABLED
    vec3 viewDir = normalize(viewPos - FragmentPos);
    vec3 reflectDir = reflect(-lightDir, norm);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), metallic);
    vec4 specular = specularStrength * spec * liteColor;
    //vec4 specular = vec4(1.0, 1.0, 1.0, 1.0);

    vec4 baseColor = graphicsColor * texture(image, uv);            
    //vec4 objectColor = baseColor * vertexColor;

    return baseColor * (ambience + diffuse + specular);
}
