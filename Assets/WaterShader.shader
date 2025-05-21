Shader "Custom/WaterShader"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" { }
        _ReflectionTex ("Reflection (RGB)", 2D) = "black" { }
        _NormalMap ("Normal Map", 2D) = "bump" { }
        _WaveSpeed ("Wave Speed", Float) = 0.5
        _WaveHeight ("Wave Height", Float) = 0.1
        _WaveDirection ("Wave Direction", Vector) = (1, 0, 0, 0)
        _TintColor ("Tint Color", Color) = (0.2, 0.4, 0.6, 1)
    }

    SubShader
    {
        Tags { "Queue" = "Background" }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata_t
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
            };

            float _WaveSpeed;
            float _WaveHeight;
            float4 _WaveDirection;
            float4 _TintColor;
            sampler2D _MainTex;
            sampler2D _ReflectionTex;
            sampler2D _NormalMap;

            v2f vert(appdata_t v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = v.normal;

                // Animate the waves with a simple sine function
                v.vertex.y += sin(v.vertex.x * _WaveDirection.x + _Time.y * _WaveSpeed) * _WaveHeight;
                o.pos = UnityObjectToClipPos(v.vertex);

                return o;
            }

            half4 frag(v2f i) : SV_Target
            {
                // Sample the base texture and reflection texture
                half4 mainColor = tex2D(_MainTex, i.uv);
                half4 reflectionColor = tex2D(_ReflectionTex, i.uv);
                half3 normal = tex2D(_NormalMap, i.uv).rgb;

                // Simple water reflection effect
                float reflectAmount = max(0.0, dot(i.normal, float3(0, 1, 0)));

                // Combine the base color with reflection and tint
                half4 finalColor = lerp(mainColor, reflectionColor, reflectAmount);
                finalColor *= _TintColor;

                return finalColor;
            }

            ENDCG
        }
    }
}
