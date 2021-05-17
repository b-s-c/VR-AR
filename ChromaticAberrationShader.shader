Shader "Coursework/ChromaticAberrationShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        // custom properties
        _rOffsetX("Red offset x", range(-0.25, 0.25)) = 0.02
        _rOffsetY("Red offset y", range(-0.25, 0.25)) = 0.00
        _gOffsetX("Green offset x", range(-0.25, 0.25)) = 0.00
        _gOffsetY("Green offset y", range(-0.25, 0.25)) = 0.00
        _bOffsetX("Blue offset x", range(-0.25, 0.25)) = -0.02
        _bOffsetY("Blue offset y", range(-0.25, 0.25)) = 0.00
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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;

            float _rOffsetX;
            float _rOffsetY;
            float _gOffsetX;
            float _gOffsetY;
            float _bOffsetX;
            float _bOffsetY;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                col.r = tex2D(_MainTex, i.uv + float2(_rOffsetX, _rOffsetY)).r;
                col.g = tex2D(_MainTex, i.uv + float2(_bOffsetX, _bOffsetY)).g;
                col.b = tex2D(_MainTex, i.uv + float2(_gOffsetX, _gOffsetY)).b;

                return col;
            }
            ENDCG
        }
    }
}
