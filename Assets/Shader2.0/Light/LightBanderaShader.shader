Shader "Custom/BanderaWithLighting"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _WaveStrength("Wave Strength", Float) = 0.5
        _WindSpeed("Wind Speed", Float) = 1.0
        _SpecularColor("Specular Color", Color) = (1, 1, 1, 1) // Color de luz especular
        _Shininess("Shininess", Range(1.0, 100.0)) = 20.0 
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

                sampler2D _MainTex;
                float _WaveStrength;
                float _WindSpeed;
                float4 _MainTex_ST;
                float4 _SpecularColor;
                float _Shininess;

                struct appdata
                {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                    float2 uv : TEXCOORD0;
                };

                struct v2f
                {
                    float2 uv : TEXCOORD0;   
                    float4 pos : SV_POSITION; 
                    float3 worldPos : TEXCOORD1; 
                    float3 worldNormal : TEXCOORD2;
                };

                v2f vert(appdata v)
                {
                    v2f o;

                    float time = _Time.y * _WindSpeed;

                    float wave = sin(v.vertex.x * 5.0 + time) * _WaveStrength;

                    v.vertex.z += wave;

                    o.pos = UnityObjectToClipPos(v.vertex);

                    o.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;

                    o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                    o.worldNormal = normalize(mul((float3x3)unity_ObjectToWorld, v.normal));

                    return o;
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    float4 texColor = tex2D(_MainTex, i.uv);

                    float3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * texColor.rgb;

                    float3 lightDir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos);
                    float NdotL = max(0, dot(i.worldNormal, lightDir));
                    float3 diffuse = texColor.rgb * _LightColor0.rgb * NdotL;

                    float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                    float3 halfDir = normalize(lightDir + viewDir);
                    float NdotH = max(0, dot(i.worldNormal, halfDir));
                    float specularFactor = pow(NdotH, _Shininess);
                    float3 specular = _SpecularColor.rgb * _LightColor0.rgb * specularFactor;

                    float3 finalColor = ambient + diffuse + specular;

                    return float4(finalColor, texColor.a);
                }
                ENDCG
            }
        }

            FallBack "Diffuse"
}