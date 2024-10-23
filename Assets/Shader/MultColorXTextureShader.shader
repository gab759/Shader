Shader "Custom/TextureWithTintColor"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}  // Textura 2D
        _TintColor("Tint Color", Color) = (1,1,1,1)  // Color que se multiplicará con la textura
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
                sampler2D _MainTex;  // Textura 2D
                fixed4 _TintColor;   // Color definido en el inspector que se multiplicará con la textura

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

                // Fragment Shader: Muestra la textura multiplicada por el color de tinte
                fixed4 frag(v2f i) : SV_Target
                {
                    // Muestrear la textura usando las coordenadas UV interpoladas
                    fixed4 texColor = tex2D(_MainTex, i.uv);

                // Multiplicar el color de la textura por el color de tinte (_TintColor)
                return texColor * _TintColor;
            }

            ENDCG
        }
        }
            FallBack "Diffuse"
}