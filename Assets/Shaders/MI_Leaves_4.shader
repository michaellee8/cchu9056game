Shader "Unreal/MI_Leaves_4"
{
	Properties
	{
		_MainTex("MainTex (RGB)", 2D) = "white" {}
		Material_Texture2D_0( "NormalMap", 2D ) = "white" {}
		Material_Texture2D_1( "ColorMap_Summer", 2D ) = "white" {}
		Material_Texture2D_2( "ColorMap_Autumn", 2D ) = "white" {}
		Material_Texture2D_3( "ColorMap_Variation", 2D ) = "white" {}
		Material_Texture2D_4( "OpacityMap", 2D ) = "white" {}

		View_BufferSizeAndInvSize( "View_BufferSizeAndInvSize", Vector ) = ( 1920,1080,0.00052, 0.00092 )//1920,1080,1/1920, 1/1080
	}
	SubShader 
	{
		 Tags { "RenderType" = "Opaque" }
		//BLEND_ON Tags { "RenderType" = "Transparent"  "Queue" = "Transparent" }
		
		//Blend SrcAlpha OneMinusSrcAlpha
		Cull Off

		CGPROGRAM

		#include "UnityPBSLighting.cginc"
		 #pragma surface surf Standard vertex:vert addshadow
		//BLEND_ON #pragma surface surf Standard vertex:vert alpha:fade addshadow
		
		#pragma target 5.0

		#define NUM_TEX_COORD_INTERPOLATORS 1
		#define NUM_CUSTOM_VERTEX_INTERPOLATORS 0

		struct Input
		{
			//float3 Normal;
			float2 uv_MainTex : TEXCOORD0;
			float2 uv2_Material_Texture2D_0 : TEXCOORD1;
			//float2 uv2_MainTex : TEXCOORD1;
			float4 color : COLOR;
			float4 tangent;
			//float4 normal;
			float3 viewDir;
			float4 screenPos;
			float3 worldPos;
			//float3 worldNormal;
			float3 normal2;
			INTERNAL_DATA
		};
		void vert( inout appdata_full i, out Input o )
		{
			float3 p_normal = mul( float4( i.normal, 0.0f ), unity_WorldToObject );
			//half4 p_tangent = mul( unity_ObjectToWorld,i.tangent );

			//half3 normal_input = normalize( p_normal.xyz );
			//half3 tangent_input = normalize( p_tangent.xyz );
			//half3 binormal_input = cross( p_normal.xyz,tangent_input.xyz ) * i.tangent.w;
			UNITY_INITIALIZE_OUTPUT( Input, o );

			//o.worldNormal = p_normal;
			o.normal2 = p_normal;
			o.tangent = i.tangent;
			//o.binormal_input = binormal_input;
		}
		uniform sampler2D _MainTex;
		/*
		struct SurfaceOutputStandard
		{
		fixed3 Albedo;		// base (diffuse or specular) color
		fixed3 Normal;		// tangent space normal, if written
		half3 Emission;
		half Metallic;		// 0=non-metal, 1=metal
		// Smoothness is the user facing name, it should be perceptual smoothness but user should not have to deal with it.
		// Everywhere in the code you meet smoothness it is perceptual smoothness
		half Smoothness;	// 0=rough, 1=smooth
		half Occlusion;		// occlusion (default 1)
		fixed Alpha;		// alpha for transparencies
		};
		*/


		#define Texture2D sampler2D
		#define TextureCube samplerCUBE
		#define SamplerState int
		//struct Material
		//{
			//samplers start
			uniform sampler2D    Material_Texture2D_0;
			uniform SamplerState Material_Texture2D_0Sampler;
			uniform sampler2D    Material_Texture2D_1;
			uniform SamplerState Material_Texture2D_1Sampler;
			uniform sampler2D    Material_Texture2D_2;
			uniform SamplerState Material_Texture2D_2Sampler;
			uniform sampler2D    Material_Texture2D_3;
			uniform SamplerState Material_Texture2D_3Sampler;
			uniform sampler2D    Material_Texture2D_4;
			uniform SamplerState Material_Texture2D_4Sampler;
			
		//};
		struct MaterialStruct
		{
			float4 VectorExpressions[6];
			float4 ScalarExpressions[6];
		};
		struct ViewStruct
		{
			float GameTime;
			float MaterialTextureMipBias;
			SamplerState MaterialTextureBilinearWrapedSampler;
			SamplerState MaterialTextureBilinearClampedSampler;
			float4 PrimitiveSceneData[ 40 ];
			float2 TemporalAAParams;
			float2 ViewRectMin;
			float4 ViewSizeAndInvSize;
			float MaterialTextureDerivativeMultiply;
		};
		struct ResolvedViewStruct
		{
			float3 WorldCameraOrigin;
			float4 ScreenPositionScaleBias;
			float4x4 TranslatedWorldToView;
			float4x4 TranslatedWorldToCameraView;
			float4x4 ViewToTranslatedWorld;
			float4x4 CameraViewToTranslatedWorld;
		};
		struct PrimitiveStruct
		{
			float4x4 WorldToLocal;
			float4x4 LocalToWorld;
		};

		ViewStruct View;
		ResolvedViewStruct ResolvedView;
		PrimitiveStruct Primitive;
		uniform float4 View_BufferSizeAndInvSize;
		uniform int Material_Wrap_WorldGroupSettings;		

		#include "UnrealCommon.cginc"

		MaterialStruct Material;void InitializeExpressions()
{
	Material.VectorExpressions[0] = float4(0.000000,0.000000,0.000000,0.000000);//SelectionColor
	Material.VectorExpressions[1] = float4(0.000000,0.000000,0.000000,0.000000);//(Unknown)
	Material.VectorExpressions[2] = float4(1.000000,1.000000,1.000000,1.000000);//(Unknown)
	Material.VectorExpressions[3] = float4(1.000000,1.000000,1.000000,1.000000);//(Unknown)
	Material.VectorExpressions[4] = float4(1.000000,1.000000,1.000000,0.000000);//TintColor
	Material.VectorExpressions[5] = float4(1.000000,1.000000,1.000000,0.000000);//(Unknown)
	Material.ScalarExpressions[0] = float4(1.000000,0.000000,0.030000,1.000000);//NormalAmount (Unknown) ColorVariationAmount_Summer ForceAutoSeasons
	Material.ScalarExpressions[1] = float4(0.000000,0.000000,0.050000,1.000000);//Autumn IgnoreSeasonsToggle ColorVariationAmount_Autumn ColorVariationTiling
	Material.ScalarExpressions[2] = float4(0.000000,0.250000,0.250000,0.250000);//ColorVariationAmount SpecularAmount RoughnessAmount TranslucencyAmount
	Material.ScalarExpressions[3] = float4(0.000000,0.000000,0.000000,0.000000);//Spring SpringOverride Summer Winter
	Material.ScalarExpressions[4] = float4(2.000000,1.000000,2.000000,0.750000);//WindForce WindToggle (Unknown) LeavesThickness
	Material.ScalarExpressions[5] = float4(0.000000,1.000000,0.000000,0.000000);//__SubsurfaceProfile AOExponent (Unknown) (Unknown)
}struct MaterialCollection0Type
{
	float4 Vectors[2];
};
MaterialCollection0Type MaterialCollection0;
void Initialize_MaterialCollection0()
{
	MaterialCollection0.Vectors[0] = float4(0.140000,0.000000,7370666391109632.000000,0.000000);//WindSpeed,,,
	MaterialCollection0.Vectors[1] = float4(0.000000,0.000000,0.000000,0.000000);//SeasonsBlend
}
void CalcPixelMaterialInputs(in out FMaterialPixelParameters Parameters, in out FPixelMaterialInputs PixelMaterialInputs)
{
	float3 WorldNormalCopy = Parameters.WorldNormal;

	// Initial calculations (required for Normal)
	MaterialFloat Local0 = MaterialStoreTexCoordScale(Parameters, Parameters.TexCoords[0].xy, 6);
	MaterialFloat4 Local1 = UnpackNormalMap(Texture2DSample(Material_Texture2D_0, GetMaterialSharedSampler(Material_Texture2D_0Sampler,View.MaterialTextureBilinearWrapedSampler),Parameters.TexCoords[0].xy));
	MaterialFloat Local2 = MaterialStoreTexSample(Parameters, Local1, 6);
	MaterialFloat3 Local3 = lerp(MaterialFloat3(0.00000000,0.00000000,1.00000000),Local1.rgb,MaterialFloat(Material.ScalarExpressions[0].x));

	// The Normal is a special case as it might have its own expressions and also be used to calculate other inputs, so perform the assignment here
	PixelMaterialInputs.Normal = Local3;


	// Note that here MaterialNormal can be in world space or tangent space
	float3 MaterialNormal = GetMaterialNormal(Parameters, PixelMaterialInputs);

#if MATERIAL_TANGENTSPACENORMAL
#if SIMPLE_FORWARD_SHADING
	Parameters.WorldNormal = float3(0, 0, 1);
#endif

#if FEATURE_LEVEL >= FEATURE_LEVEL_SM4
	// Mobile will rely on only the final normalize for performance
	MaterialNormal = normalize(MaterialNormal);
#endif

	// normalizing after the tangent space to world space conversion improves quality with sheared bases (UV layout to WS causes shrearing)
	// use full precision normalize to avoid overflows
	Parameters.WorldNormal = TransformTangentNormalToWorld(Parameters.TangentToWorld, MaterialNormal);

#else //MATERIAL_TANGENTSPACENORMAL

	Parameters.WorldNormal = normalize(MaterialNormal);

#endif //MATERIAL_TANGENTSPACENORMAL

#if MATERIAL_TANGENTSPACENORMAL
	// flip the normal for backfaces being rendered with a two-sided material
	Parameters.WorldNormal *= Parameters.TwoSidedSign;
#endif

	Parameters.ReflectionVector = ReflectionAboutCustomWorldNormal(Parameters, Parameters.WorldNormal, false);

#if !PARTICLE_SPRITE_FACTORY
	Parameters.Particle.MotionBlurFade = 1.0f;
#endif // !PARTICLE_SPRITE_FACTORY

	// Now the rest of the inputs
	MaterialFloat3 Local4 = lerp(MaterialFloat3(0.00000000,0.00000000,0.00000000),Material.VectorExpressions[1].rgb,MaterialFloat(Material.ScalarExpressions[0].y));
	MaterialFloat3 Local5 = (MaterialFloat3(100.00000000,10.00000000,1.00000000) * GetPerInstanceRandom(Parameters));
	MaterialFloat3 Local6 = (GetObjectWorldPosition(Parameters) * 0.01000000);
	MaterialFloat3 Local7 = (Local5 + Local6);
	MaterialFloat3 Local8 = frac(Local7);
	MaterialFloat Local9 = dot(Local8.rg, Local8.gb);
	MaterialFloat Local10 = (-0.50000000 + Local9);
	MaterialFloat Local11 = (Local10 * 2.00000000);
	MaterialFloat Local12 = (Material.ScalarExpressions[0].z * Local11);
	MaterialFloat Local13 = dot(Local8, Local8);
	MaterialFloat Local14 = sqrt(Local13);
	MaterialFloat3 Local15 = (Local8 / Local14);
	MaterialFloat3 Local16 = (Local12 * Local15);
	MaterialFloat Local17 = MaterialStoreTexCoordScale(Parameters, Parameters.TexCoords[0].xy, 4);
	MaterialFloat4 Local18 = ProcessMaterialColorTextureLookup(Texture2DSample(Material_Texture2D_1, GetMaterialSharedSampler(Material_Texture2D_1Sampler,View.MaterialTextureBilinearWrapedSampler),Parameters.TexCoords[0].xy));
	MaterialFloat Local19 = MaterialStoreTexSample(Parameters, Local18, 4);
	MaterialFloat Local20 = MaterialStoreTexCoordScale(Parameters, Parameters.TexCoords[0].xy, 5);
	MaterialFloat4 Local21 = ProcessMaterialColorTextureLookup(Texture2DSample(Material_Texture2D_2, GetMaterialSharedSampler(Material_Texture2D_2Sampler,View.MaterialTextureBilinearWrapedSampler),Parameters.TexCoords[0].xy));
	MaterialFloat Local22 = MaterialStoreTexSample(Parameters, Local21, 5);
	MaterialFloat4 Local23 = MaterialCollection0.Vectors[1];
	MaterialFloat Local24 = lerp(Material.ScalarExpressions[1].x,Local23.rgba.b,Material.ScalarExpressions[0].w);
	MaterialFloat3 Local25 = lerp(Local18.rgb,Local21.rgb,MaterialFloat(Local24));
	MaterialFloat3 Local26 = lerp(Local25,Local18.rgb,MaterialFloat(Material.ScalarExpressions[1].y));
	MaterialFloat3 Local27 = (Local16 + Local26);
	MaterialFloat Local28 = (Material.ScalarExpressions[1].z * Local11);
	MaterialFloat3 Local29 = (Local28 * Local15);
	MaterialFloat3 Local30 = (Local29 + Local26);
	MaterialFloat3 Local31 = lerp(Local27,Local30,MaterialFloat(Local24));
	MaterialFloat3 Local32 = (GetWorldPosition(Parameters) - GetObjectWorldPosition(Parameters));
	MaterialFloat Local33 = dot(Local32, Local32);
	MaterialFloat Local34 = sqrt(Local33);
	MaterialFloat3 Local35 = (Local32 / Local34);
	MaterialFloat3 Local36 = (Local35 * Material.VectorExpressions[3].rgb);
	MaterialFloat3 Local37 = (MaterialFloat3(0.00000000,0.00000000,0.00000000) + Local36);
	MaterialFloat Local38 = MaterialStoreTexCoordScale(Parameters, Local37.rb, 3);
	MaterialFloat4 Local39 = ProcessMaterialColorTextureLookup(Texture2DSample(Material_Texture2D_3, GetMaterialSharedSampler(Material_Texture2D_3Sampler,View.MaterialTextureBilinearWrapedSampler),Local37.rb));
	MaterialFloat Local40 = MaterialStoreTexSample(Parameters, Local39, 3);
	MaterialFloat Local41 = MaterialStoreTexCoordScale(Parameters, Local37.gb, 3);
	MaterialFloat4 Local42 = ProcessMaterialColorTextureLookup(Texture2DSample(Material_Texture2D_3, GetMaterialSharedSampler(Material_Texture2D_3Sampler,View.MaterialTextureBilinearWrapedSampler),Local37.gb));
	MaterialFloat Local43 = MaterialStoreTexSample(Parameters, Local42, 3);
	MaterialFloat Local44 = dot(Local35, MaterialFloat3(1.00000000,0.00000000,0.00000000));
	MaterialFloat Local45 = abs(Local44);
	MaterialFloat Local46 = (2.00000000 * Local45);
	MaterialFloat Local47 = min(max(Local46,0.00000000),1.00000000);
	MaterialFloat Local48 = PositiveClampedPow(Local47,16.00000000);
	MaterialFloat Local49 = (Local48 * 0.50000000);
	MaterialFloat Local50 = (Local45 + -0.50000000);
	MaterialFloat Local51 = (Local50 * 2.00000000);
	MaterialFloat Local52 = min(max(Local51,0.00000000),1.00000000);
	MaterialFloat Local53 = (1.00000000 - Local52);
	MaterialFloat Local54 = PositiveClampedPow(Local53,16.00000000);
	MaterialFloat Local55 = (1.00000000 - Local54);
	MaterialFloat Local56 = (Local55 * 0.50000000);
	MaterialFloat Local57 = (0.50000000 + Local56);
	MaterialFloat Local58 = (Local55 * 500.00000000);
	MaterialFloat Local59 = min(max(Local58,0.00000000),1.00000000);
	MaterialFloat Local60 = lerp(Local49,Local57,Local59);
	MaterialFloat3 Local61 = lerp(Local39.rgb,Local42.rgb,MaterialFloat(Local60));
	MaterialFloat Local62 = MaterialStoreTexCoordScale(Parameters, Local37.rg, 3);
	MaterialFloat4 Local63 = ProcessMaterialColorTextureLookup(Texture2DSample(Material_Texture2D_3, GetMaterialSharedSampler(Material_Texture2D_3Sampler,View.MaterialTextureBilinearWrapedSampler),Local37.rg));
	MaterialFloat Local64 = MaterialStoreTexSample(Parameters, Local63, 3);
	MaterialFloat Local65 = dot(Local35, MaterialFloat3(0.00000000,0.00000000,1.00000000));
	MaterialFloat Local66 = abs(Local65);
	MaterialFloat Local67 = (2.00000000 * Local66);
	MaterialFloat Local68 = min(max(Local67,0.00000000),1.00000000);
	MaterialFloat Local69 = PositiveClampedPow(Local68,16.00000000);
	MaterialFloat Local70 = (Local69 * 0.50000000);
	MaterialFloat Local71 = (Local66 + -0.50000000);
	MaterialFloat Local72 = (Local71 * 2.00000000);
	MaterialFloat Local73 = min(max(Local72,0.00000000),1.00000000);
	MaterialFloat Local74 = (1.00000000 - Local73);
	MaterialFloat Local75 = PositiveClampedPow(Local74,16.00000000);
	MaterialFloat Local76 = (1.00000000 - Local75);
	MaterialFloat Local77 = (Local76 * 0.50000000);
	MaterialFloat Local78 = (0.50000000 + Local77);
	MaterialFloat Local79 = (Local76 * 500.00000000);
	MaterialFloat Local80 = min(max(Local79,0.00000000),1.00000000);
	MaterialFloat Local81 = lerp(Local70,Local78,Local80);
	MaterialFloat3 Local82 = lerp(Local61,Local63.rgb,MaterialFloat(Local81));
	MaterialFloat3 Local83 = (Local31 * Local82);
	MaterialFloat3 Local84 = (Local83 + Local82);
	MaterialFloat3 Local85 = lerp(Local31,Local84,MaterialFloat(Material.ScalarExpressions[2].x));
	MaterialFloat3 Local86 = lerp(Local31,Local85,MaterialFloat(Local24));
	MaterialFloat3 Local87 = (Local86 * Material.VectorExpressions[5].rgb);
	MaterialFloat4 Local88 = ProcessMaterialColorTextureLookup(Texture2DSample(Material_Texture2D_4, GetMaterialSharedSampler(Material_Texture2D_4Sampler,View.MaterialTextureBilinearWrapedSampler),Parameters.TexCoords[0].xy));
	MaterialFloat Local89 = MaterialStoreTexSample(Parameters, Local88, 4);
	MaterialFloat Local90 = lerp(Material.ScalarExpressions[3].x,Local23.rgba.r,Material.ScalarExpressions[0].w);
	MaterialFloat Local91 = (Local90 * Material.ScalarExpressions[3].y);
	MaterialFloat Local92 = lerp(Local88.r,0.00000000,Local91);
	MaterialFloat Local93 = lerp(Material.ScalarExpressions[3].z,Local23.rgba.g,Material.ScalarExpressions[0].w);
	MaterialFloat Local94 = (Local93 * 0.00000000);
	MaterialFloat Local95 = lerp(Local92,0.00000000,Local94);
	MaterialFloat Local96 = (Local24 * 0.00000000);
	MaterialFloat Local97 = lerp(Local95,0.00000000,Local96);
	MaterialFloat Local98 = lerp(Material.ScalarExpressions[3].w,Local23.rgba.a,Material.ScalarExpressions[0].w);
	MaterialFloat Local99 = (Local98 * 1.00000000);
	MaterialFloat Local100 = lerp(Local97,0.00000000,Local99);
	MaterialFloat Local101 = lerp(Local100,Local88.r,Material.ScalarExpressions[1].y);
	MaterialFloat Local127 = (Local3.r + Material.ScalarExpressions[4].w);
	MaterialFloat3 Local128 = (Local87 * Local127);
	MaterialFloat3 Local129 = lerp(Local128,MaterialFloat3(0.00000000,0.00000000,0.00000000),MaterialFloat(Local23.rgba.a));
	MaterialFloat3 Local130 = PositiveClampedPow(Parameters.VertexColor.rgb,Material.ScalarExpressions[5].y);

	PixelMaterialInputs.EmissiveColor = Local4;
	PixelMaterialInputs.Opacity = Material.ScalarExpressions[2].w;
	PixelMaterialInputs.OpacityMask = Local101;
	PixelMaterialInputs.BaseColor = Local87;
	PixelMaterialInputs.Metallic = 0.00000000;
	PixelMaterialInputs.Specular = Material.ScalarExpressions[2].y;
	PixelMaterialInputs.Roughness = Material.ScalarExpressions[2].z;
	PixelMaterialInputs.Anisotropy = 0.00000000;
	PixelMaterialInputs.Tangent = MaterialFloat3(1.00000000,0.00000000,0.00000000);
	PixelMaterialInputs.Subsurface = MaterialFloat4(Local129,Material.ScalarExpressions[5].x);
	PixelMaterialInputs.AmbientOcclusion = Local130;
	PixelMaterialInputs.Refraction = 0;
	PixelMaterialInputs.PixelDepthOffset = 0.00000000;
	PixelMaterialInputs.ShadingModel = 6;


#if MATERIAL_USES_ANISOTROPY
	Parameters.WorldTangent = CalculateAnisotropyTangent(Parameters, PixelMaterialInputs);
#else
	Parameters.WorldTangent = 0;
#endif
}

		void surf( Input In, inout SurfaceOutputStandard o )
		{
			InitializeExpressions();
	Initialize_MaterialCollection0();


			float3 Z3 = float3( 0, 0, 0 );
			float4 Z4 = float4( 0, 0, 0, 0 );

			float3 UnrealWorldPos = float3( In.worldPos.x, In.worldPos.y, In.worldPos.z );
			
			float3 UnrealNormal = In.normal2;

			FMaterialPixelParameters Parameters;
			#if NUM_TEX_COORD_INTERPOLATORS > 0			
				Parameters.TexCoords[ 0 ] = float2( In.uv_MainTex.x, In.uv_MainTex.y );
			#endif
			#if NUM_TEX_COORD_INTERPOLATORS > 1
				Parameters.TexCoords[ 1 ] = float2( In.uv2_Material_Texture2D_0.x, In.uv2_Material_Texture2D_0.y );
			#endif
			#if NUM_TEX_COORD_INTERPOLATORS > 2
			for( int i = 2; i < NUM_TEX_COORD_INTERPOLATORS; i++ )
			{
				Parameters.TexCoords[ i ] = float2( In.uv_MainTex.x, In.uv_MainTex.y );
			}
			#endif
			Parameters.VertexColor = In.color;
			Parameters.WorldNormal = UnrealNormal;
			Parameters.ReflectionVector = half3( 0, 0, 1 );
			//Parameters.CameraVector = normalize( _WorldSpaceCameraPos.xyz - UnrealWorldPos.xyz );
			Parameters.CameraVector = mul( ( float3x3 )unity_CameraToWorld, float3( 0, 0, 1 ) ) * -1;
			Parameters.LightVector = half3( 0, 0, 0 );
			float4 screenpos = In.screenPos;
			screenpos /= screenpos.w;
			//screenpos.y = 1 - screenpos.y;
			Parameters.SvPosition = float4( screenpos.x, screenpos.y, 0, 0 );
			Parameters.ScreenPosition = Parameters.SvPosition;

			Parameters.UnMirrored = 1;

			Parameters.TwoSidedSign = 1;
			

			float3 InWorldNormal = UnrealNormal;
			float4 InTangent = In.tangent;
			float4 tangentWorld = float4( UnityObjectToWorldDir( InTangent.xyz ), InTangent.w );
			tangentWorld.xyz = normalize( tangentWorld.xyz );
			float3x3 OriginalTangentToWorld = CreateTangentToWorldPerVertex( InWorldNormal, tangentWorld.xyz, tangentWorld.w );
			Parameters.TangentToWorld = OriginalTangentToWorld;
			//Parameters.TangentToWorld = float3x3( Z3, Z3, Z3 );

			//WorldAlignedTexturing in UE relies on the fact that coords there are 100x larger, prepare values for that
			//but watch out for any computation that might get skewed as a side effect
			UnrealWorldPos = UnrealWorldPos * 100;
			UnrealWorldPos = UnrealWorldPos.xzy;
			Parameters.TangentToWorld[ 0 ] = Parameters.TangentToWorld[ 0 ].xzy;
			Parameters.TangentToWorld[ 1 ] = Parameters.TangentToWorld[ 1 ].xzy;
			Parameters.TangentToWorld[ 2 ] = Parameters.TangentToWorld[ 2 ].xzy;//WorldAligned texturing uses normals that think Z is up

			//Parameters.TangentToWorld = half3x3( float3( 1, 1, 1 ), float3( 1, 1, 1 ), UnrealNormal.xyz );
			Parameters.AbsoluteWorldPosition = UnrealWorldPos;
			Parameters.WorldPosition_CamRelative = UnrealWorldPos;
			Parameters.WorldPosition_NoOffsets = UnrealWorldPos;

			Parameters.WorldPosition_NoOffsets_CamRelative = Parameters.WorldPosition_CamRelative;
			Parameters.LightingPositionOffset = float3( 0, 0, 0 );

			Parameters.AOMaterialMask = 0;

			Parameters.Particle.RelativeTime = 0;
			Parameters.Particle.MotionBlurFade;
			Parameters.Particle.Random = 0;
			Parameters.Particle.Velocity = half4( 1, 1, 1, 1 );
			Parameters.Particle.Color = half4( 1, 1, 1, 1 );
			Parameters.Particle.TranslatedWorldPositionAndSize = float4( UnrealWorldPos, 0 );
			Parameters.Particle.MacroUV = half4(0,0,1,1);
			Parameters.Particle.DynamicParameter = half4(0,0,0,0);
			Parameters.Particle.LocalToWorld = float4x4( Z4, Z4, Z4, Z4 );
			Parameters.Particle.Size = float2(1,1);
			Parameters.TexCoordScalesParams = float2( 0, 0 );
			Parameters.PrimitiveId = 0;

			FPixelMaterialInputs PixelMaterialInputs = ( FPixelMaterialInputs)0;
			PixelMaterialInputs.Normal = float3( 0, 0, 1 );
			PixelMaterialInputs.ShadingModel = 0;

			//Extra
			View.GameTime = _Time.y;// _Time is (t/20, t, t*2, t*3)
			View.MaterialTextureMipBias = 0.0;
			View.TemporalAAParams = float2( 0, 0 );
			View.ViewRectMin = float2( 0, 0 );
			View.ViewSizeAndInvSize = View_BufferSizeAndInvSize;
			View.MaterialTextureDerivativeMultiply = 1.0f;
			for( int i2 = 0; i2 < 40; i2++ )
				View.PrimitiveSceneData[ i2 ] = float4( 0, 0, 0, 0 );

			uint PrimitiveBaseOffset = Parameters.PrimitiveId * PRIMITIVE_SCENE_DATA_STRIDE;
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 0 ] = unity_ObjectToWorld[ 0 ];//LocalToWorld
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 1 ] = unity_ObjectToWorld[ 1 ];//LocalToWorld
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 2 ] = unity_ObjectToWorld[ 2 ];//LocalToWorld
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 3 ] = unity_ObjectToWorld[ 3 ];//LocalToWorld
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 6 ] = unity_WorldToObject[ 0 ];//WorldToLocal
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 7 ] = unity_WorldToObject[ 1 ];//WorldToLocal
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 8 ] = unity_WorldToObject[ 2 ];//WorldToLocal
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 9 ] = unity_WorldToObject[ 3 ];//WorldToLocal
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 10 ] = unity_WorldToObject[ 0 ];//PreviousLocalToWorld
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 11 ] = unity_WorldToObject[ 1 ];//PreviousLocalToWorld
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 12 ] = unity_WorldToObject[ 2 ];//PreviousLocalToWorld
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 13 ] = unity_WorldToObject[ 3 ];//PreviousLocalToWorld

			ResolvedView.WorldCameraOrigin = _WorldSpaceCameraPos.xyz;
			ResolvedView.ScreenPositionScaleBias = float4( 1, 1, 0, 0 );
			ResolvedView.TranslatedWorldToView = unity_MatrixV;
			ResolvedView.TranslatedWorldToCameraView = unity_MatrixV;
			ResolvedView.ViewToTranslatedWorld = unity_MatrixInvV;
			ResolvedView.CameraViewToTranslatedWorld = unity_MatrixInvV;
			Primitive.WorldToLocal = unity_WorldToObject;
			Primitive.LocalToWorld = unity_ObjectToWorld;
			CalcPixelMaterialInputs( Parameters, PixelMaterialInputs );

			#define HAS_WORLDSPACE_NORMAL 0
			#if HAS_WORLDSPACE_NORMAL
				PixelMaterialInputs.Normal = mul( PixelMaterialInputs.Normal, (MaterialFloat3x3)( transpose( OriginalTangentToWorld ) ) );
			#endif

			//Debug
			//PixelMaterialInputs.BaseColor = Texture2DSample( Material_Texture2D_1, Material_Texture2D_1Sampler, Parameters.TexCoords[ 0 ].xy );

			o.Albedo = PixelMaterialInputs.BaseColor.rgb;
			o.Alpha = PixelMaterialInputs.Opacity;
			if( PixelMaterialInputs.OpacityMask < 0.333 ) discard;

			o.Metallic = PixelMaterialInputs.Metallic;
			o.Smoothness = 1.0 - PixelMaterialInputs.Roughness;
			o.Normal = normalize( PixelMaterialInputs.Normal );
			o.Emission = PixelMaterialInputs.EmissiveColor.rgb;
			o.Occlusion = PixelMaterialInputs.AmbientOcclusion;

			//BLEND_ADDITIVE o.Alpha = ( o.Emission.r + o.Emission.g + o.Emission.b ) / 3;
		}
		ENDCG
	}
	Fallback "Diffuse"
}