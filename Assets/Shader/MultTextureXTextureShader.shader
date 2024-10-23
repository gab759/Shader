Shader "Custom/TextureWithTexture"
{
    Properties
    {
        _MainTex1("Texture1", 2D) = "white" {}
        _MainTex2("Texture2", 2D) = "white" {}
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

            // Uniforms: Datos que se mantienen constantes durante el renderizado
            sampler2D _MainTex1;  // Textura 2D
            sampler2D _MainTex2;

            // Estructura de entrada para el vertex shader
            struct appdata
            {
                float4 vertex : POSITION;  // Posición del vértice
                float2 uv : TEXCOORD0;     // Coordenadas UV de la textura
            };

            // Estructura de salida del vertex shader y entrada al fragment shader (varyings)
            struct v2f
            {
                float2 uv : TEXCOORD0;     // Coordenadas UV interpoladas
                float4 pos : SV_POSITION;  // Posición del vértice en la pantalla
            };

            // Vertex Shader: Transforma los vértices y pasa los UV al fragment shader
            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);  // Transformación de espacio del objeto a clip-space
                o.uv = v.uv;  // Pasar las coordenadas UV al fragment shader
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // Muestrear la textura usando las coordenadas UV interpoladas
                fixed4 texColor1 = tex2D(_MainTex1, i.uv);
                fixed4 texColor2 = tex2D(_MainTex2, i.uv);

                fixed4 result = texColor1 * texColor2;
                return result;
            }

        ENDCG
        }
    }
        FallBack "Diffuse"
}
