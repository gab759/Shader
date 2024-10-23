Shader "Custom/BanderaShader"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}  
        _WaveStrength("Wave Strength", Float) = 0.5
        _WindSpeed("Wind Speed", Float) = 1.0
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

                // Propiedades
                sampler2D _MainTex;     
                float _WaveStrength; 
                float _WindSpeed; 
                float4 _MainTex_ST;

                // Estructura de entrada para el vertex shader
                struct appdata
                {
                    float4 vertex : POSITION; 
                    float2 uv : TEXCOORD0; 
                };

                // Estructura de salida del vertex shader y entrada al fragment shader
                struct v2f
                {
                    float2 uv : TEXCOORD0;     // Coordenadas UV interpoladas
                    float4 pos : SV_POSITION;  // Posición del vértice en la pantalla
                };

                // Vertex Shader: Deforma los vértices para simular el movimiento de una bandera
                v2f vert(appdata v)
                {
                    v2f o;

                    // Convertir el tiempo global a una variable local del shader
                    float time = _Time.y * _WindSpeed;

                    // Desplazar los vértices en la dirección Y (altura) basados en una onda senoidal que varía con el tiempo
                    float wave = sin(v.vertex.x * 5.0 + time) * _WaveStrength;

                    // Modificar la posición del vértice en el eje Z para simular el viento
                    v.vertex.z += wave;

                    // Aplicar la transformación al clip-space
                    o.pos = UnityObjectToClipPos(v.vertex);

                    // Transformar las coordenadas UV de manera manual (sin usar TRANSFORM_TEX)
                    o.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;

                    return o;
                }

                // Fragment Shader: Renderiza la textura sobre la bandera
                fixed4 frag(v2f i) : SV_Target
                {
                    // Muestrear la textura usando las coordenadas UV interpoladas
                    fixed4 texColor = tex2D(_MainTex, i.uv);
                    return texColor;
                }

                ENDCG
            }
        }
            FallBack "Diffuse"
}
