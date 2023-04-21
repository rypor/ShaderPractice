// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/ClipSpaceShader"
{
    Properties
    {
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct MeshData
            {
                float4 vertexOS : POSITION;
                float2 uv0 : TEXCOORD0;      // uv coordinates channels
            };

            struct Interpolators
            {
                float4 vertexCS : SV_POSITION;
                float4 vertexWS : TEXCOORD0;
                float2 uv : TEXCOORD1;
            };

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertexWS = mul(unity_ObjectToWorld, v.vertexOS);
                o.vertexCS = UnityObjectToClipPos(v.vertexOS);  // local space to clip space
                o.vertexCS.x = frac(o.vertexCS.x);
                o.uv = v.uv0;
                return o;
            }

            float4 frag(Interpolators i) : SV_Target
            {
                float4 col = float4(0,0, 0, 1);
                col.x = saturate(i.vertexCS.x);
                return col;
            }
            ENDCG
        }
    }
}
