Shader "rypor/02_Tutorial_Shader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BaseColor("Base Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100


        HLSLINCLUDE
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

        CBUFFER_START(UnityPerMaterial)
            float4 _BaseColor;
        CBUFFER_END

        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);


        struct VertexInput
        {
            // Type Name : Semantic
            float4 position : POSITION;     // POSITION = ?Vertex Position?
            float2 uv : TEXCOORD0;          // TEXCOORD0 = Texture Coordinate
        };

        struct VertexOutput
        {
            float4 position : SV_POSITION;  // SV_POSITION = Pixel Position
            float2 uv : TEXCOORD0;
        };

        ENDHLSL

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            VertexOutput vert(VertexInput i)
            {
                VertexOutput o;
                // Convert each vertex from object space to clip space: 
                //      Object Space = 3d relative to center of object,
                //      Clip Space = 2d screen space relative to camera
                o.position = TransformObjectToHClip(i.position.xyz);
                o.uv = i.uv;
                return o;
            }

            // After Vertex Shader, remaining visible triangles are split using "Rasterization" into fragments
            // frag runs on every fragment (pixel), returning final color
            float4 frag(VertexOutput i) : SV_Target
            {
                float4 baseTex = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv);
                return baseTex * _BaseColor;
            }

            ENDHLSL
        }
    }
}
