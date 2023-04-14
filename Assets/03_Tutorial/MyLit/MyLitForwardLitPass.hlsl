// URP Library gives functions such as Object Space to clip space converters etc
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

// Populated by Input Assembler automatically, using Semantic (ie: POSITION)
struct Attributes {
	float3 positionOS : POSITION; // Position, OS = Object Space
	float2 uv : TEXCOORD0; // Material Texture UVs
};

struct Interpolators {
	float4 positionCS : SV_POSITION;	// Semantic signals that this contains clip space vertex position

	// Retains value from vetex stage, except rasterizer interpolates them between verticies.
	float2 uv : TEXCOORD0;
};



float4 _ColorTint; // Auto Synchronized with variable of same name in shader

//Textures
TEXTURE2D(_ColorMap); SAMPLER(sampler_ColorMap);
//TEXTURE2D is a macro running on _ColorMap. Makes Shaders platform independent
float4 _ColorMap_ST; // Auto set by unity to Tiling and Offset values. Used in TRANSFORM_TEX to apply uv tiling



// Vertex function runs once per vertex. Do more in this and less in fragment, to save resources
Interpolators Vertex(Attributes input) {
	Interpolators output;
	// From URP/ShaderLib/ShaderVariablesFunctions.hlsl
	VertexPositionInputs posnInputs = GetVertexPositionInputs(input.positionOS);

	// pass position/orientation data to frag func
	output.positionCS = posnInputs.positionCS;
	output.uv = TRANSFORM_TEX(input.uv, _ColorMap); // TRANSFORM_TEX applies uv scaling and offset

	return output;
}

// Rasterizer Averages values throughout triangle, each point is weighted average of 3 vertices


// Fragment function runs once per pixel
// input has now been modified, and now contains pixel position on screen instead of clip space position
float4 Fragment(Interpolators input) : SV_TARGET{	// SV_TARGET lets pipeline know we are returning final pixel color
													// Semantic applied to function auto applies to return type
	
	float2 uv = input.uv;

	// Sample Texture at specific point
	float4 colorSample = SAMPLE_TEXTURE2D(_ColorMap, sampler_ColorMap, uv);

	return colorSample * _ColorTint; // component wise
}