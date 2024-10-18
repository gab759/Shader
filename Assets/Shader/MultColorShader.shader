Shader "Unlit/EjemploDeShaderGabriel"
{
    Properties
    {
        _MainColorA ("colorA", Color) = (1,0,0,1)
        _MainColorB ("colorB", Color) = (1,0,0,1)
        _Blend ("Factor", Range(0,1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                
            };

            struct v2f
            {
                
                float4 vertex : SV_POSITION;
            };

           fixed4 _MainColorA;
           fixed4 _MainColorB;
           fixed _Blend;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target 
            {
                
                return lerp(_MainColorA,_MainColorB,_Blend);
            }
            ENDCG
        }
    }
}
