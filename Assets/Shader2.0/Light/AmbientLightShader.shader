Shader "Custom/TextureAmbientLightShader"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
        _AmbientColor("Ambient Color", Color) = (0.5, 0.5, 0.5, 1)
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 100

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
                    float2 uv : TEXCOORD0;
                };

                struct v2f
                {
                    float4 pos : SV_POSITION;
                    float2 uv : TEXCOORD0;
                };

                sampler2D _MainTex;
                float4 _AmbientColor; // Color de luz ambiental

                v2f vert(appdata v)
                {
                    v2f o;
                    o.pos = UnityObjectToClipPos(v.vertex);
                    o.uv = v.uv; 
                    return o;
                }

                float4 frag(v2f i) : SV_Target
                {
                    float4 texColor = tex2D(_MainTex, i.uv);

                    // Aplicación de la luz ambiental
                    float3 ambient = texColor.rgb * _AmbientColor.rgb;

                    return float4(ambient, texColor.a);
                }
                ENDCG
            }
        }
            FallBack "Diffuse"
}