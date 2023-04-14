//Written in Shader Lab
Shader "rypor/MyLit"{

	//Subshaders : Different code for different pipelines
	SubShader{
		// Tags apply to this subshader
		Tags{"RenderPipeline" = "UniversalPipeline"}

		//Each Pass has its own vertex/fragment functions
		Pass{
			Name "ForwardLit" // For Debugging
			Tags{"LightMode" = "UniversalForward"} // "UniversalForward is the main lighting pass"


			//Rendering Pipeline:
			//	Input Assembler
			//  Vertex Func
			//	Rasterizer
			//	Fragment Func
			//  Presentation

			HLSLPROGRAM
			#pragma vertex Vertex
			#pragma fragment Fragment

			#include "MyLitForwardLitPass.hlsl"
			ENDHLSL
		}
	}
}