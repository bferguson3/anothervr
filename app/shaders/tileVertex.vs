out vec3 vNormal;

vec4 position(mat4 projection, mat4 transform, vec4 vertex) 
{
    vNormal = lovrNormal;
    return projection * transform * tileLocs[lovrInstanceID] * vertex;
}