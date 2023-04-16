
struct Attributes {
	float3 positionOS : POSITION;
};

struct Interpolators {
	float3 positionCS : SV_POSITION;
};

Interpolators Vertex(Attributes input) {
	Interpolators output;

	VertexPositionInputs posnInputs = GetVertexPositionInputs(input.positionOS);
	output.positionCS = posnInputs.positionCS;

	return output;
}

float4 Fragment(Interpolators input) : SV_TARGET{
	return 0;
}