Shader "Custom/CombinedTextureShader"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
        _NormalMap("Normal Map", 2D) = "bump" {}
        _SpecularMap("Specular Map", 2D) = "white" {}
        _HeightMap("Height Map", 2D) = "black" {}
        _OcclusionMap("Occlusion Map", 2D) = "white" {}
        _EmissionMap("Emission Map", 2D) = "black" {}

        _SpecularPower("Specular Power", Range(1, 128)) = 16
        _HeightScale("Height Scale", Range(0.0, 0.1)) = 0.05
        _OcclusionStrength("Occlusion Strength", Range(0, 1)) = 1.0
        _EmissionStrength("Emission Strength", Range(0, 10)) = 1.0
        _EmissionColor("Emission Color", Color) = (1, 1, 1, 1)
        _LightColor("Light Color", Color) = (1, 1, 1, 1)
        _LightDirection("Light Direction", Vector) = (0, 0, -1)
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 200

            Pass
            {
                CGPROGRAM
                #pragma target 3.0
                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"

                sampler2D _MainTex;
                sampler2D _NormalMap;
                sampler2D _SpecularMap;
                sampler2D _HeightMap;
                sampler2D _OcclusionMap;
                sampler2D _EmissionMap;

                float _SpecularPower;
                float _HeightScale;
                float _OcclusionStrength;
                float _EmissionStrength;
                float4 _EmissionColor;
                float4 _LightColor;
                float3 _LightDirection;

                struct appdata
                {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                    float2 uv : TEXCOORD0;
                };

                struct v2f
                {
                    float4 pos : SV_POSITION;
                    float2 uv : TEXCOORD0;
                    float3 worldPos : TEXCOORD1;
                    float3 worldNormal : TEXCOORD2;
                };

                v2f vert(appdata v)
                {
                    v2f o;

                    float height = tex2Dlod(_HeightMap, float4(v.uv, 0, 0)).r * _HeightScale;
                    float3 displacedPosition = v.vertex.xyz + v.normal * height;

                    o.pos = UnityObjectToClipPos(float4(displacedPosition, 1.0));
                    o.uv = v.uv;
                    o.worldPos = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1.0)).xyz;
                    o.worldNormal = normalize(mul((float3x3)unity_ObjectToWorld, v.normal));

                    return o;
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    fixed4 baseColor = tex2D(_MainTex, i.uv);

                fixed3 normalTex = UnpackNormal(tex2D(_NormalMap, i.uv));
                fixed3 worldNormal = normalize(i.worldNormal + normalTex);

                fixed3 lightDir = normalize(_LightDirection);

                float specular = tex2D(_SpecularMap, i.uv).r;
                fixed3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                fixed3 reflectDir = reflect(-lightDir, worldNormal);
                float specFactor = pow(max(dot(viewDir, reflectDir), 0.0), _SpecularPower) * specular;

                float occlusion = tex2D(_OcclusionMap, i.uv).r * _OcclusionStrength;
                occlusion = lerp(1.0, occlusion, _OcclusionStrength);

                float3 emission = tex2D(_EmissionMap, i.uv).rgb * _EmissionColor.rgb * _EmissionStrength;

                float3 finalColor = baseColor.rgb * occlusion;
                finalColor += specFactor * _LightColor.rgb;
                finalColor += emission;

                return float4(finalColor, baseColor.a);
            }
            ENDCG
        }
        }

            FallBack "Diffuse"
}