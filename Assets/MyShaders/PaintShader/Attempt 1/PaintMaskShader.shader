
// This shader aims to create a mask texture
Shader "rypor/PaintMaskShader"
{
    Properties
    {
        [Header(Controlled by code)]
        [MainTexture] _MainTex("Color", 2D) = "white" {}
        _PaintColor ("Paint Color", Color) = (0, 0, 0, 0)
    }
    SubShader
    {
        Cull Off ZWrite Off ZTest Off   // Cull allows shader to run on all triangles, not just ones visible to viewer
                                        // ZWrite/ZTest disables updating depth buffer, since we don't need it. Small Optimization

        Pass
        {
            Name "PaintMask"

            HLSLPROGRAM

            #pragma vertex Vertex
            #pragma fragment Fragment

            #include "PaintMaskPass.hlsl"

            ENDHLSL
        }
    }
}
