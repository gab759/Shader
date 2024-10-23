Shader "Custom/TextureShader"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {} // Propiedad para cargar la textura desde el inspector
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

            // Declarar las variables globales del shader
            struct appdata
            {
                float4 vertex : POSITION;  // Posición del vértice
                float2 uv : TEXCOORD0;     // Coordenadas UV para la textura
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;     // Coordenadas UV para el fragment shader
                float4 pos : SV_POSITION;  // Posición en la pantalla
            };

            // Declarar la textura que se utilizará en el material
            sampler2D _MainTex;

            // Vertex Shader: Transforma los vértices de espacio local a espacio de pantalla
            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex); // Convierte la posición del vértice en espacio de clip
                o.uv = v.uv;  // Pasa las coordenadas UV sin cambios al fragment shader
                return o;
            }

            // Fragment Shader: Aplicar la textura al fragmento
            fixed4 frag(v2f i) : SV_Target
            {
                // Muestra el color de la textura en las coordenadas UV
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }

            ENDCG
        }
    }
}