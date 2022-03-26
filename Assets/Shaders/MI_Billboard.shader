Shader "Unreal/MI_Billboard"
{
	Properties
	{
		_MainTex("MainTex (RGB)", 2D) = "white" {}
		Material_Texture2D_0( "T_AtlasNoise01_BC", 2D ) = "white" {}
		Material_Texture2D_1( "T_TreeTop", 2D ) = "white" {}
		Material_Texture2D_2( "ColorMap_Variation", 2D ) = "white" {}

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
			
		//};
		struct MaterialStruct
		{
			float4 VectorExpressions[12];
			float4 ScalarExpressions[3];
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
	Material.VectorExpressions[2] = float4(0.551513,0.666667,0.058364,1.000000);//ColorTint_Summer
	Material.VectorExpressions[3] = float4(0.551513,0.666667,0.058364,0.000000);//(Unknown)
	Material.VectorExpressions[4] = float4(1.000000,1.000000,1.000000,1.000000);//ColorTint_Spring
	Material.VectorExpressions[5] = float4(1.000000,1.000000,1.000000,0.000000);//(Unknown)
	Material.VectorExpressions[6] = float4(0.338542,0.098837,0.048041,1.000000);//ColorTint_Autumn
	Material.VectorExpressions[7] = float4(0.338542,0.098837,0.048041,0.000000);//(Unknown)
	Material.VectorExpressions[8] = float4(1.000000,1.000000,1.000000,1.000000);//(Unknown)
	Material.VectorExpressions[9] = float4(1.000000,1.000000,1.000000,1.000000);//(Unknown)
	Material.VectorExpressions[10] = float4(1.000000,1.000000,1.000000,0.000000);//TintColor
	Material.VectorExpressions[11] = float4(1.000000,1.000000,1.000000,0.000000);//(Unknown)
	Material.ScalarExpressions[0] = float4(0.000000,1.000000,0.000000,0.000000);//(Unknown) ForceAutoSeasons Spring HasSpringFruits
	Material.ScalarExpressions[1] = float4(0.030000,0.000000,0.000000,1.000000);//GlobalColorVariationAmount Autumn ForeverLeaves (Unknown)
	Material.ScalarExpressions[2] = float4(1.000000,0.000000,0.000000,0.000000);//ColorVariationTiling ColorVariationAmount Winter (Unknown)
}struct MaterialCollection0Type
{
	float4 Vectors[2];
};
MaterialCollection0Type MaterialCollection0;
void Initialize_MaterialCollection0()
{
	MaterialCollection0.Vectors[0] = float4(0.140000,0.000000,0.000000,0.000000);//WindSpeed,,,
	MaterialCollection0.Vectors[1] = float4(0.000000,0.000000,0.000000,0.000000);//SeasonsBlend
}
void CalcPixelMaterialInputs(in out FMaterialPixelParameters Parameters, in out FPixelMaterialInputs PixelMaterialInputs)
{
	float3 WorldNormalCopy = Parameters.WorldNormal;

	// Initial calculations (required for Normal)

	// The Normal is a special case as it might have its own expressions and also be used to calculate other inputs, so perform the assignment here
	PixelMaterialInputs.Normal = MaterialFloat3(0.00000000,0.00000000,1.00000000);


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
	MaterialFloat3 Local0 = lerp(MaterialFloat3(0.00000000,0.00000000,0.00000000),Material.VectorExpressions[1].rgb,MaterialFloat(Material.ScalarExpressions[0].x));
	MaterialFloat2 Local1 = (Parameters.TexCoords[0].xy * 10.00000000);
	MaterialFloat Local2 = MaterialStoreTexCoordScale(Parameters, Local1, 2);
	MaterialFloat4 Local3 = ProcessMaterialColorTextureLookup(Texture2DSampleBias(Material_Texture2D_0, Material_Texture2D_0Sampler,Local1,View.MaterialTextureMipBias));
	MaterialFloat Local4 = MaterialStoreTexSample(Parameters, Local3, 2);
	MaterialFloat3 Local5 = (Local3.rgb * Material.VectorExpressions[3].rgb);
	MaterialFloat3 Local6 = (Local5 * Material.VectorExpressions[3].rgb);
	MaterialFloat3 Local7 = (Local3.rgb * Material.VectorExpressions[5].rgb);
	MaterialFloat Local8 = MaterialStoreTexCoordScale(Parameters, Parameters.TexCoords[0].xy, 3);
	MaterialFloat4 Local9 = ProcessMaterialLinearColorTextureLookup(Texture2DSampleBias(Material_Texture2D_1, Material_Texture2D_1Sampler,Parameters.TexCoords[0].xy,View.MaterialTextureMipBias));
	MaterialFloat Local10 = MaterialStoreTexSample(Parameters, Local9, 3);
	MaterialFloat3 Local11 = (Local7 * Local9.r);
	MaterialFloat4 Local12 = MaterialCollection0.Vectors[1];
	MaterialFloat Local13 = lerp(Material.ScalarExpressions[0].z,Local12.rgba.r,Material.ScalarExpressions[0].y);
	MaterialFloat Local14 = (Local13 * Material.ScalarExpressions[0].w);
	MaterialFloat3 Local15 = lerp(Local6,Local11,MaterialFloat(Local14));
	MaterialFloat3 Local16 = (MaterialFloat3(100.00000000,10.00000000,1.00000000) * GetPerInstanceRandom(Parameters));
	MaterialFloat3 Local17 = (GetObjectWorldPosition(Parameters) * 0.01000000);
	MaterialFloat3 Local18 = (Local16 + Local17);
	MaterialFloat3 Local19 = frac(Local18);
	MaterialFloat Local20 = dot(Local19.rg, Local19.gb);
	MaterialFloat Local21 = (-0.50000000 + Local20);
	MaterialFloat Local22 = (Local21 * 2.00000000);
	MaterialFloat Local23 = (Material.ScalarExpressions[1].x * Local22);
	MaterialFloat Local24 = dot(Local19, Local19);
	MaterialFloat Local25 = sqrt(Local24);
	MaterialFloat3 Local26 = (Local19 / Local25);
	MaterialFloat3 Local27 = (Local23 * Local26);
	MaterialFloat3 Local28 = (Local9.r * Material.VectorExpressions[7].rgb);
	MaterialFloat3 Local29 = (Local27 + Local28);
	MaterialFloat Local30 = lerp(Material.ScalarExpressions[1].y,Local12.rgba.b,Material.ScalarExpressions[0].y);
	MaterialFloat Local31 = (Local30 * Material.ScalarExpressions[1].w);
	MaterialFloat3 Local32 = lerp(Local15,Local29,MaterialFloat(Local31));
	MaterialFloat3 Local33 = (GetWorldPosition(Parameters) - GetObjectWorldPosition(Parameters));
	MaterialFloat Local34 = dot(Local33, Local33);
	MaterialFloat Local35 = sqrt(Local34);
	MaterialFloat3 Local36 = (Local33 / Local35);
	MaterialFloat3 Local37 = (Local36 * Material.VectorExpressions[9].rgb);
	MaterialFloat3 Local38 = (MaterialFloat3(0.00000000,0.00000000,0.00000000) + Local37);
	MaterialFloat Local39 = MaterialStoreTexCoordScale(Parameters, Local38.rb, 1);
	MaterialFloat4 Local40 = ProcessMaterialColorTextureLookup(Texture2DSample(Material_Texture2D_2, GetMaterialSharedSampler(Material_Texture2D_2Sampler,View.MaterialTextureBilinearWrapedSampler),Local38.rb));
	MaterialFloat Local41 = MaterialStoreTexSample(Parameters, Local40, 1);
	MaterialFloat Local42 = MaterialStoreTexCoordScale(Parameters, Local38.gb, 1);
	MaterialFloat4 Local43 = ProcessMaterialColorTextureLookup(Texture2DSample(Material_Texture2D_2, GetMaterialSharedSampler(Material_Texture2D_2Sampler,View.MaterialTextureBilinearWrapedSampler),Local38.gb));
	MaterialFloat Local44 = MaterialStoreTexSample(Parameters, Local43, 1);
	MaterialFloat Local45 = dot(Local36, MaterialFloat3(1.00000000,0.00000000,0.00000000));
	MaterialFloat Local46 = abs(Local45);
	MaterialFloat Local47 = (2.00000000 * Local46);
	MaterialFloat Local48 = min(max(Local47,0.00000000),1.00000000);
	MaterialFloat Local49 = PositiveClampedPow(Local48,16.00000000);
	MaterialFloat Local50 = (Local49 * 0.50000000);
	MaterialFloat Local51 = (Local46 + -0.50000000);
	MaterialFloat Local52 = (Local51 * 2.00000000);
	MaterialFloat Local53 = min(max(Local52,0.00000000),1.00000000);
	MaterialFloat Local54 = (1.00000000 - Local53);
	MaterialFloat Local55 = PositiveClampedPow(Local54,16.00000000);
	MaterialFloat Local56 = (1.00000000 - Local55);
	MaterialFloat Local57 = (Local56 * 0.50000000);
	MaterialFloat Local58 = (0.50000000 + Local57);
	MaterialFloat Local59 = (Local56 * 500.00000000);
	MaterialFloat Local60 = min(max(Local59,0.00000000),1.00000000);
	MaterialFloat Local61 = lerp(Local50,Local58,Local60);
	MaterialFloat3 Local62 = lerp(Local40.rgb,Local43.rgb,MaterialFloat(Local61));
	MaterialFloat Local63 = MaterialStoreTexCoordScale(Parameters, Local38.rg, 1);
	MaterialFloat4 Local64 = ProcessMaterialColorTextureLookup(Texture2DSample(Material_Texture2D_2, GetMaterialSharedSampler(Material_Texture2D_2Sampler,View.MaterialTextureBilinearWrapedSampler),Local38.rg));
	MaterialFloat Local65 = MaterialStoreTexSample(Parameters, Local64, 1);
	MaterialFloat Local66 = dot(Local36, MaterialFloat3(0.00000000,0.00000000,1.00000000));
	MaterialFloat Local67 = abs(Local66);
	MaterialFloat Local68 = (2.00000000 * Local67);
	MaterialFloat Local69 = min(max(Local68,0.00000000),1.00000000);
	MaterialFloat Local70 = PositiveClampedPow(Local69,16.00000000);
	MaterialFloat Local71 = (Local70 * 0.50000000);
	MaterialFloat Local72 = (Local67 + -0.50000000);
	MaterialFloat Local73 = (Local72 * 2.00000000);
	MaterialFloat Local74 = min(max(Local73,0.00000000),1.00000000);
	MaterialFloat Local75 = (1.00000000 - Local74);
	MaterialFloat Local76 = PositiveClampedPow(Local75,16.00000000);
	MaterialFloat Local77 = (1.00000000 - Local76);
	MaterialFloat Local78 = (Local77 * 0.50000000);
	MaterialFloat Local79 = (0.50000000 + Local78);
	MaterialFloat Local80 = (Local77 * 500.00000000);
	MaterialFloat Local81 = min(max(Local80,0.00000000),1.00000000);
	MaterialFloat Local82 = lerp(Local71,Local79,Local81);
	MaterialFloat3 Local83 = lerp(Local62,Local64.rgb,MaterialFloat(Local82));
	MaterialFloat3 Local84 = (Local32 * Local83);
	MaterialFloat3 Local85 = (Local84 + Local83);
	MaterialFloat3 Local86 = lerp(Local32,Local85,MaterialFloat(Material.ScalarExpressions[2].y));
	MaterialFloat3 Local87 = (Local86 * Material.VectorExpressions[11].rgb);
	MaterialFloat Local88 = lerp(Material.ScalarExpressions[2].z,Local12.rgba.a,Material.ScalarExpressions[0].y);
	MaterialFloat Local89 = (Local88 * Material.ScalarExpressions[1].w);
	MaterialFloat Local90 = lerp(Local9.g,Local9.b,Local89);

	PixelMaterialInputs.EmissiveColor = Local0;
	PixelMaterialInputs.Opacity = 1.00000000;
	PixelMaterialInputs.OpacityMask = Local90;
	PixelMaterialInputs.BaseColor = Local87;
	PixelMaterialInputs.Metallic = 0.00000000;
	PixelMaterialInputs.Specular = 0.50000000;
	PixelMaterialInputs.Roughness = 1.00000000;
	PixelMaterialInputs.Anisotropy = 0.00000000;
	PixelMaterialInputs.Tangent = MaterialFloat3(1.00000000,0.00000000,0.00000000);
	PixelMaterialInputs.Subsurface = 0;
	PixelMaterialInputs.AmbientOcclusion = 1.00000000;
	PixelMaterialInputs.Refraction = 0;
	PixelMaterialInputs.PixelDepthOffset = 0.00000000;
	PixelMaterialInputs.ShadingModel = 1;


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