#version 330
#ifdef GL_ARB_shading_language_420pack
#extension GL_ARB_shading_language_420pack : require
#endif

uniform sampler2D ImageTexture;

in vec3 wnormal;
in vec2 texCoord;
out vec4 fragColor[3];
in vec4 wvpposition;
in vec4 prevwvpposition;

vec2 octahedronWrap(vec2 v)
{
    return (vec2(1.0) - abs(v.yx)) * vec2((v.x >= 0.0) ? 1.0 : (-1.0), (v.y >= 0.0) ? 1.0 : (-1.0));
}

float packFloat(float f1, float f2)
{
    return floor(f1 * 100.0) + min(f2, 0.9900000095367431640625);
}

float packFloat2(float f1, float f2)
{
    return floor(f1 * 255.0) + min(f2, 0.9900000095367431640625);
}

void main()
{
    vec3 n = normalize(wnormal);
    vec4 ImageTexture_store = texture(ImageTexture, texCoord);
    vec3 _80 = pow(ImageTexture_store.xyz, vec3(2.2000000476837158203125));
    ImageTexture_store = vec4(_80.x, _80.y, _80.z, ImageTexture_store.w);
    vec3 ImageTexture_Color_res = ImageTexture_store.xyz;
    vec3 basecol = ImageTexture_Color_res;
    float roughness = 0.0;
    float metallic = 0.0;
    float occlusion = 1.0;
    float specular = 0.0;
    n /= vec3((abs(n.x) + abs(n.y)) + abs(n.z));
    vec2 _112;
    if (n.z >= 0.0)
    {
        _112 = n.xy;
    }
    else
    {
        _112 = octahedronWrap(n.xy);
    }
    n = vec3(_112.x, _112.y, n.z);
    fragColor[0] = vec4(n.xy, packFloat(metallic, roughness), 0.0);
    fragColor[1] = vec4(basecol, packFloat2(occlusion, specular));
    vec2 posa = ((wvpposition.xy / vec2(wvpposition.w)) * 0.5) + vec2(0.5);
    vec2 posb = ((prevwvpposition.xy / vec2(prevwvpposition.w)) * 0.5) + vec2(0.5);
    vec2 _181 = vec2(posa - posb);
    fragColor[2] = vec4(_181.x, _181.y, fragColor[2].z, fragColor[2].w);
}

