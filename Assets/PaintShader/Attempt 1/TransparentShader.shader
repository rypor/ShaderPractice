Shader "Unlit/TransparentShader"
{
    Properties
    {
    }
    SubShader
    {
        Pass
        {
            HLSLPROGRAM
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #pragma vertex Vertex
            #pragma fragment Fragment

            struct Attributes {
                float3 positionOS : POSITION;
            };

            struct Interpolators {
                float4 positionCS : SV_POSITION;
                float3 screenPos : TEXCOORD0;
            };

            Interpolators Vertex(Attributes input) {
                Interpolators output;

                output.positionCS = mul(UNITY_MATRIX_MVP, input.positionOS);
                output.screenPos = output.positionCS.xyw;

                return output;
            }

            float4 Fragment(Interpolators input) : SV_TARGET{
                return float4(1,1,1,1);
            }

            ENDHLSL
        }
    }
}
