Shader "Coursework/FragmentDistortion"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        // custom properties: range, then default value
        _scale("scale", range(0.1, 1.5)) = 1 
        _c1("c1", range(-0.1, 3)) = 1
        _c2("c2", range(-0.1, 3)) = 0
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

            float _scale;
            float _c1;
            float _c2;

            float2 forwardRadial(float2 uv)
            {
                // p : ensure range is -1 to 1 instead of 0 to 1
                // https://forum.unity.com/threads/center-uv-co-ordinates-glsl-cg-hlsl.452233/#post-2929008
                float2 p = ((uv.xy * 2) - 1);

                // cartesian --> polar
                float theta = atan2(p.y, p.x);

                // r : undistorted radius, polar coordinates form
                float r = sqrt((p.x * p.x) + (p.y * p.y));

                // f : function to distort the radius (Brown’s simplified Forward radial transform)
                float f_r = r + (_c1 * pow(r, 3)) + (_c2 * pow(r, 5));

                // polar --> cartesian, applying new radius value
                p.x = f_r * cos(theta);
                p.y = f_r * sin(theta);

                // on return:
                // 1) scale the effect
                // 2) undo range adjustments done by p in first step
                return ((_scale * p + 1) / 2);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return tex2D(_MainTex, forwardRadial(i.uv));

                //fixed4 col = tex2D(_MainTex, i.uv);
                //// IN.texcoord ??? 

                ////https://www.reddit.com/r/gamedev/comments/1whbjp/help_with_understanding_this_polar_to_cartesian/
                ////float theta = i.texcoord.x * 2.0 * PI;
                ////float r = i.texcoord.y;

                //// just invert the colors
                //col.rgb = 1 - col.rgb;
                //return col;
            }
            ENDCG
        }
    }
}
