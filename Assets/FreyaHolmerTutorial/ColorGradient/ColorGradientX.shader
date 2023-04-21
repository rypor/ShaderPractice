Shader "Unlit/Unlit1"
{
    Properties
    {
        _ColorA("ColorA", color) = (1,1,1,1)
        _ColorB("ColorB", color) = (0,0,0,0)
        _ColorStart("Color Start", Range(0,1)) = 0
        _ColorEnd("Color End", Range(0,1)) = 1
        //_Scale("Scale", float) = 1.0
        //_Offset("Offset", float) = 0.0
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"


            //float _Offset;
            //float _Scale;

            float _ColorStart;
            float _ColorEnd;

            float4 _ColorA;
            float4 _ColorB;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            struct MeshData // per vertex mesh data
            {
                float4 vertexOS : POSITION;   // per vertex position object space
                float3 normalOS : NORMAL;
                // float4 tangent : TANGENT;
                // float4 color : COLOR;
                float2 uv0 : TEXCOORD0;      // uv coordinates channels
                // float2 uv1 : TEXCOORD1;      // uv coordinates
            };

            struct Interpolators
            {
                float4 vertexCS : SV_POSITION;    // clip space position
                float2 uv : TEXCOORD0;          // TEXCOORD no longer refers to UV channel here, different from above vertex input
                float3 normal : TEXCOORD1;
            };

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertexCS = UnityObjectToClipPos(v.vertexOS);  // local space to clip space
                //o.vertexCS = v.vertexOS;

                // o.normal = v.normalOS;
                //o.normal = mul((float3x3) unity_ObjectToWorld, v.normalOS); // or 
                o.normal = UnityObjectToWorldNormal(v.normalOS);
                //o.uv = (v.uv0 + float2(_Offset, _Offset)) * _Scale ;
                o.uv = v.uv0;

                return o;
            }

            // float4 = Vector4 (32 bit)
            // half = (16 bit)
            // fixed = even lower precision, only good in -1 to 1

            // float4 -> half4 -> fixed4
            // float4x4 = matrix 

            float InverseLerp(float start, float end, float input)
            {
                return (input - start) / (end - start);
            }

            float4 frag(Interpolators i) : SV_Target
            {
                // return float4(i.normal, 1);
                // return float4(i.uv, 0, 1);
                // return lerp(_ColorA, _ColorB, i.uv.x);

                float t = InverseLerp(_ColorStart, _ColorEnd, i.uv.x);
                //return frac(t); // frac returns decimal part of a float
                t = saturate(t); // Clamps 0 to 1. Horrible Name
                //return frac(t);

                return lerp(_ColorA, _ColorB, t);
                // return i.uv.x;
            }
            ENDCG
        }
    }
}
