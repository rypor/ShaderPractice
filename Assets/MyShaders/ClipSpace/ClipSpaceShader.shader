// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/ClipSpaceShader"
{
    Properties
    {
        _PaintColor("Paint Color", color) = (1,0,0,0)
        _PaintPos("Paint Position", Vector) = (0,0,0,0)
        _Radius("Radius", float) = 1
        _Hardness("Hardness", float) = 0.5
        _Strength("Strength", float) = 1
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

            float4 _PaintColor;
            float3 _PaintPos;
            float _Radius;
            float _Hardness;
            float _Strength;

            struct MeshData
            {
                float4 vertexOS : POSITION;
                float2 uv0 : TEXCOORD0;      // uv coordinates channels
            };

            struct Interpolators
            {
                float4 vertexCS : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 positionWS : TEXCOORD1;
            };

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                float4 uv = float4(0, 0, UNITY_NEAR_CLIP_VALUE, 1);
                uv.xy = float2(1, _ProjectionParams.x) * (v.uv0.xy * 2 - 1);
                o.vertexCS = uv;
                o.uv = v.uv0;
                //o.vertexCS = UnityObjectToClipPos(v.vertexOS);  // local space to clip space
                
                o.positionWS = mul(unity_ObjectToWorld, v.vertexOS);

                return o;
            }

            float mask(float3 paintPosWS, float3 pixelPosWS, float radius, float hardness, float strength)
            {
                float dist = distance(paintPosWS, pixelPosWS);
                //float val = saturate(dist / radius);   // 0 to 1 if in radius, 0 outside radius
                // val *= strength;        // apply strength? not sure if necessary
                return 1 - smoothstep(radius * hardness, radius, dist);
            }

            float4 frag(Interpolators i) : SV_Target
            {
                //float4 col = float4(i.uv,0,1);
                float val = mask(_PaintPos, i.positionWS.xyz, _Radius, _Hardness, _Strength);
                float4 baseCol = float4(1, 1, 1, 1);
                float4 col = lerp(baseCol, _PaintColor, val);
                return col;
            }
            ENDCG
        }
    }
}
