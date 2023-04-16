// URP Library gives functions such as Object Space to clip space converters etc
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

// Populated by Input Assembler automatically, using Semantic (ie: POSITION)
struct Attributes {
	float3 positionOS : POSITION; // Position, OS = Object Space
	float3 normalOS : NORMAL;
	float2 uv : TEXCOORD0; // Material Texture UVs
};

struct Interpolators {
	float4 positionCS : SV_POSITION;	// Semantic signals that this contains clip space vertex position

	// Retains value from vetex stage, except rasterizer interpolates them between verticies.
	float2 uv : TEXCOORD0;
	float3 normalWS : TEXCOORD1; // Any Field tagged TEXCOORD- will be interpolated by Rasterizer
	float3 positionWS : TEXCOORD2;
};



float4 _ColorTint; // Auto Synchronized with variable of same name in shader

//Textures
TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex);
//TEXTURE2D is a macro running on _MainTex. Makes Shaders platform independent
float4 _MainTex_ST; // Auto set by unity to Tiling and Offset values. Used in TRANSFORM_TEX to apply uv tiling

float _Smoothness;


// Vertex function runs once per vertex. Do more in this and less in fragment, to save resources
Interpolators Vertex(Attributes input) {
	Interpolators output;
	// From URP/ShaderLib/ShaderVariablesFunctions.hlsl
	VertexPositionInputs posnInputs = GetVertexPositionInputs(input.positionOS);
	VertexNormalInputs normInputs = GetVertexNormalInputs(input.normalOS);

	// pass position/orientation data to frag func
	output.positionCS = posnInputs.positionCS;
	output.uv = TRANSFORM_TEX(input.uv, _MainTex); // TRANSFORM_TEX applies uv scaling and offset
	output.normalWS = normInputs.normalWS;
	// Vertices on corners are duplicated for each normal vector, therefore only one normal vector per vertice
	output.positionWS = posnInputs.positionWS;

	return output;
}

// Rasterizer Averages values throughout triangle, each point is weighted average of 3 vertices


// Fragment function runs once per pixel
// input has now been modified, and now contains pixel position on screen instead of clip space position
float4 Fragment(Interpolators input) : SV_TARGET{	// SV_TARGET lets pipeline know we are returning final pixel color
													// Semantic applied to function auto applies to return type
	
	float2 uv = input.uv;

	// Sample Texture at specific point
	float4 colorSample = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv);


	InputData lightingInput = (InputData)0;	// 0 after struct sets all values in struct to 0
	lightingInput.positionWS = input.positionWS;
	lightingInput.viewDirectionWS = GetWorldSpaceNormalizeViewDir(input.positionWS);

	// Shadowmapping - distance of every closest fragment to lightsource is stored in a texture red map. By comparing our frag
	//			distance to the shadow map distance, we know if this frag is closest and therefore should be lit. Done by unity automatically.
	//		Enabled using Pragma in shader file
	lightingInput.shadowCoord = TransformWorldToShadowCoord(input.positionWS);

	lightingInput.normalWS = normalize(input.normalWS); // Rasterizer interpolates vectors component wise.
														// Can lead to non-normal vector lengths, fix here

	SurfaceData surfaceInput = (SurfaceData)0;
	surfaceInput.albedo = colorSample.rgb * _ColorTint.rgb;
	surfaceInput.alpha = colorSample.a * _ColorTint.a;
	surfaceInput.specular = 1;	// See Shader file for define variable enabling specular
	surfaceInput.smoothness = _Smoothness;

	// Built-in lighting calculation method
	return UniversalFragmentBlinnPhong(lightingInput, surfaceInput);
	//return colorSample * _ColorTint; // component wise
}