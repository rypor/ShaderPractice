#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
struct Attributes {
	float3 positionOS : POSITION;
	float2 uv : TEXCOORD0;
};

struct Interpolators {
	// Although this is clip space, it will be populated by UV position, leading to texture map effect
	float4 positionCS : SV_POSITION;

	float3 positionWS : TEXCOORD0;
	float2 uv : TEXCOORD1;
};


float4 _PaintColor;
TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex);
float4 _MainTex_ST; // Auto set by unity to Tiling and Offset values. Used in TRANSFORM_TEX to apply uv tiling

Interpolators Vertex(Attributes input) {
	Interpolators output;

	VertexPositionInputs posnInputs = GetVertexPositionInputs(input.positionOS);

	float2 uv = TRANSFORM_TEX(input.uv, _MainTex);
	output.uv = uv;
	output.positionWS = posnInputs.positionWS;

	output.positionCS = float4(0, 0, 0, 1);
	output.positionCS.xy = float2(1, _ProjectionParams.x) * (uv.xy * float2(2, 2) - float2(1, 1));

	return output;
}

float4 Fragment(Interpolators input) : SV_TARGET{

	float2 uv = input.uv;

	float4 colorSample = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv);
	 
	return colorSample;
}