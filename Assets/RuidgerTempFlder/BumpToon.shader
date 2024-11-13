Shader "Custom/BumpToon"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _RampTex ("Ramp Texture", 2D) = "white" {}
        _MainTex ("Texture", 2D) = "white" {}
        _Normal ("Normal", 2D) = "white" {}
        _BumpAmount ("BumpAmount", Range(-10,10)) = 0
        _OutlineColor ("Outline Color", Color) = (0, 0, 0, 1)
        _Outline("Outline Width", Range(.002, 1)) = 0.005
        
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf ToonRamp
        #pragma surface surf Lambert

        float4 _Color;
        sampler2D _RampTex;
        sampler2D _Normal;
        half _BumpAmount;
        float4 LightingToonRamp (SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
            float diff = dot(s.Normal, lightDir);
            float h = diff * 0.5 +0.5;
            float2 rh = h;
            float3 ramp = tex2D(_RampTex, rh).rgb;

            float4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * (ramp);
            c.a = s.Alpha;
            return c;
        }

        struct Input
        {
         float2 uv_MainTex;
            float2 uv_Normal;
            
            
        };
        sampler2D _MainTex;
        

        void surf (Input IN, inout SurfaceOutput o)
        {
         o.Albedo = _Color + tex2D(_MainTex, IN.uv_MainTex).rgb;
            o.Normal =UnpackNormal(tex2D(_Normal, IN.uv_Normal));
            o.Normal *= float3 (_BumpAmount, _BumpAmount, 1);
        }
        ENDCG
Pass
{
    Cull Front
    CGPROGRAM
    #pragma vertex vert
    #pragma fragment frag

    #include "UnityCG.cginc"

    struct appdata
        {
            float4 vertex : POSITION;
            float3 normal: NORMAL;
        };

    struct v2f
    {
        float4 pos : SV_POSITION;
        fixed4 color : COLOR;
        
    };

    float _Outline;
    float4 _OutlineColor;

    v2f vert(appdata v)
    {
        v2f o;
        o.pos = UnityObjectToClipPos(v.vertex);

        float3 norm = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));
        float2 offset = TransformViewToProjection(norm.xy);

        o.pos.xy += offset * o.pos.z * _Outline;
        o.color = _OutlineColor;
        return o;
    }

    fixed4 frag(v2f i) : SV_Target {
return i.color;
    }
    ENDCG
}
    }
    Fallback "Diffuse"
}
