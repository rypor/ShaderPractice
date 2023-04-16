
struct Attributes {
	float3 positionOS : POSITION;
	float3 normalOS : NORMAL;
};

struct Interpolators {
	float3 positionCS : SV_POSITION;
};


float3 _LightDirection;	// URP provided

float4 GetShadowCasterPositionCS(float3 positionWS, float3 normalWS) {
	float3 lightDirectionWS = _LightDirection;
	float4 positionCS = TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, lightDirectionWS));
											// ApplyShadowBias from unity library

#if UNITY_REVERSED_Z
	positionCS.z = min(positionCS.z, UNIITY_NEAR_CLIP_VALUE);	// prevents us from overstepping clip bounds, which leads to
#else															// stuff disappearing out of camera view
	positionCS.z = max(positionCS.z, UNIITY_NEAR_CLIP_VALUE);
#endif

	return positionCS;
}



Interpolators Vertex(Attributes input) {
	Interpolators output;

	VertexPositionInputs posnInputs = GetVertexPositionInputs(input.positionOS);
	VertexNormalInputs normInputs = GetVertexNormalInputs(input.normalOS);
	output.positionCS = GetShadowCasterPositionCS(posnInputs.positionWS, normInputs.normalWS);

	return output;
}

// Return zero, because shadowmap is calculated as part of clip space, in the form of depth. Rasterization stores depth in a depth buffer.
// Depth buffer is later used for shadowmap creation.
float4 Fragment(Interpolators input) : SV_TARGET{
	return 0;
}