Shader "Coursework/MeshShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _c1("c1", range(-0.5, 1)) = -0.05
        _c2("c2", range(-0.5, 1)) = 0
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float _c1;
            float _c2;

            v2f vert (appdata v)
            {
                // test
                //v.vertex.z += 2;

                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                // cartesian --> polar
                float theta = atan2(o.vertex.y, o.vertex.x);
                float r = sqrt((o.vertex.x * o.vertex.x) + (o.vertex.y * o.vertex.y));

                // f : function to distort the radius (Brown’s simplified Forward radial transform)
                float f_r = r + (_c1 * pow(r, 3)) + (_c2 * pow(r, 5));

                // polar --> cartesian, applying new radius value
                o.vertex.x = f_r * cos(theta);
                o.vertex.y = f_r * sin(theta);

                return o;
            }

            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
