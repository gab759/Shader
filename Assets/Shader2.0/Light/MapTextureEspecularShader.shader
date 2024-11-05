Shader "Custom/TextureWithSpecular"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {} // Textura base
        _Color("Color Tint", Color) = (1,1,1,1) // Color base multiplicador
        _SpecularColor("Specular Color", Color) = (1, 1, 1, 1) // Color de la luz especular
        _Shininess("Shininess", Range(1.0, 100.0)) = 20.0 // Intensidad del brillo especular
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 200

            Pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag

                #include "UnityCG.cginc"
                #include "Lighting.cginc"

                struct appdata
                {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                    float2 uv : TEXCOORD0; // Coordenadas UV para la textura
                };

                struct v2f
                {
                    float4 pos : SV_POSITION;
                    float3 worldNormal : TEXCOORD0;
                    float3 worldPos : TEXCOORD1;
                    float2 uv : TEXCOORD2;
                };

                sampler2D _MainTex;
                float4 _Color;
                float4 _SpecularColor;
                float _Shininess;

                v2f vert(appdata v)
                {
                    v2f o;
                    o.pos = UnityObjectToClipPos(v.vertex);
                    o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                    o.worldNormal = normalize(mul((float3x3)unity_ObjectToWorld, v.normal));
                    o.uv = v.uv; // Pasar coordenadas UV al fragment shader
                    return o;
                }

                float4 frag(v2f i) : SV_Target
                {
                    // Obtener el color de la textura y aplicar el tinte de color
                    float4 texColor = tex2D(_MainTex, i.uv) * _Color;

                    // Calcular la iluminación difusa
                    float3 lightDir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos);
                    float NdotL = max(0, dot(i.worldNormal, lightDir));
                    float3 diffuse = texColor.rgb * _LightColor0.rgb * NdotL;

                    // Calcular el brillo especular (Blinn-Phong)
                    float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                    float3 halfDir = normalize(lightDir + viewDir);
                    float NdotH = max(0, dot(i.worldNormal, halfDir));
                    float specularFactor = pow(NdotH, _Shininess);
                    float3 specular = _SpecularColor.rgb * _LightColor0.rgb * specularFactor;

                    // Combinar difusa y especular
                    float3 finalColor = diffuse + specular;

                    return float4(finalColor, texColor.a);
                }
                ENDCG
            }
        }
            FallBack "Diffuse"
}