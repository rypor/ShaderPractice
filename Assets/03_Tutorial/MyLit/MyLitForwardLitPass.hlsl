// URP Library gives functions such as Object Space to clip space converters etc
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

// Populated by Input Assembler automatically, using Semantic (ie: POSITION)
struct Attributes {
	float3 positionOS : POSITION; // Position, OS = Object Space
};

struct Interpolators {
	float4 positionCS : SV_POSITION;	// Semantic signals that this contains clip space vertex position
};

float4 _ColorTint; // Auto Synchronized with variable of same name in shader

// Vertex function runs once per vertex
Interpolators Vertex(Attributes input) {
	Interpolators output;
	// From URP/ShaderLib/ShaderVariablesFunctions.hlsl
	VertexPositionInputs posnInputs = GetVertexPositionInputs(input.positionOS);

	// pass position/orientation data to frag func
	output.positionCS = posnInputs.positionCS;

	return output;
}

// Fragment function runs once per pixel
// input has now been modified, and now contains pixel position on screen instead of clip space position
float4 Fragment(Interpolators input) : SV_TARGET{	// SV_TARGET lets pipeline know we are returning final pixel color
													// Semantic applied to function auto applies to return type
	
	return _ColorTint;
}