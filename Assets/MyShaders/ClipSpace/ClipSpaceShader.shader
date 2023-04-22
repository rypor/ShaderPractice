// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/ClipSpaceShader"
{
    Properties
    {
        _Z("Z", float) = 0
    }
        SubShader
    {
        Cull Off
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            float _Z;

            struct MeshData
            {
                float4 vertexOS : POSITION;
                float2 uv0 : TEXCOORD0;      // uv coordinates channels
            };

            struct Interpolators
            {
                float4 vertexCS : SV_POSITION;
                float2 uv : TEXCOORD1;
            };

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                float4 uv = float4(0, 0, UNITY_NEAR_CLIP_VALUE, 1);
                uv.xy = float2(1, _ProjectionParams.x) * (v.uv0.xy * 2 - 1);
                o.vertexCS = uv;
                o.uv = v.uv0;
                return o;
            }

            float4 frag(Interpolators i) : SV_Target
            {
                float4 col = float4(i.uv,0,1);
                return col;
            }
            ENDCG
        }
    }
}
