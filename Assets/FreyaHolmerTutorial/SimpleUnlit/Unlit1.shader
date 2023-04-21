Shader "Unlit/Unlit1"
{
    Properties
    {
        _Color("Color", color) = (1,1,1,1)
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


            float4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            struct MeshData // per vertex mesh data
            {
                float4 vertexOS : POSITION;   // per vertex position object space
                float3 normals : NORMAL;
                // float4 tangent : TANGENT;
                // float4 color : COLOR;
                // float2 uv0 : TEXCOORD0;      // uv coordinates channels
                // float2 uv1 : TEXCOORD1;      // uv coordinates
            };

            struct Interpolators
            {
                float4 vertexCS : SV_POSITION;    // clip space position
                //float2 uv : TEXCOORD0;          // TEXCOORD no longer refers to UV channel here, different from above vertex input
            };

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertexCS = UnityObjectToClipPos(v.vertexOS);  // local space to clip space
                //o.vertexCS = v.vertexOS;

                return o;
            }

            // float4 = Vector4 (32 bit)
            // half = (16 bit)
            // fixed = even lower precision, only good in -1 to 1

            // float4 -> half4 -> fixed4
            // float4x4 = matrix 

            float4 frag(Interpolators i) : SV_Target
            {
                return _Color;
            }
            ENDCG
        }
    }
}
