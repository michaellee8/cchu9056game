Shader "Unreal/Color_001"
{
	Properties
	{
		_MainTex("MainTex (RGB)", 2D) = "white" {}
		Material_Texture2D_0( "NormalMap", 2D ) = "white" {}
		Material_Texture2D_1( "LuminanceFilterMap", 2D ) = "white" {}
		Material_Texture2D_2( "ColorMap", 2D ) = "white" {}
		Material_Texture2D_3( "TintColorMask", 2D ) = "white" {}
		Material_Texture2D_4( "MetallicMap", 2D ) = "white" {}
		Material_Texture2D_5( "RoughnessMap", 2D ) = "white" {}

		View_BufferSizeAndInvSize( "View_BufferSizeAndInvSize", Vector ) = ( 1920,1080,0.00052, 0.00092 )//1920,1080,1/1920, 1/1080
	}
	SubShader 
	{
		 Tags { "RenderType" = "Opaque" }
		//BLEND_ON Tags { "RenderType" = "Transparent"  "Queue" = "Transparent" }
		
		//Blend SrcAlpha OneMinusSrcAlpha
		//Cull Off

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
			uniform sampler2D    Material_Texture2D_5;
			uniform SamplerState Material_Texture2D_5Sampler;
			
		//};
		struct MaterialStruct
		{
			float4 VectorExpressions[14];
			float4 ScalarExpressions[4];
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
	Material.VectorExpressions[1] = float4(1.000000,1.000000,1.000000,1.000000);//LuminanceFilter
	Material.VectorExpressions[2] = float4(1.000000,1.000000,1.000000,0.000000);//(Unknown)
	Material.VectorExpressions[3] = float4(0.000000,0.000000,0.000000,0.000000);//(Unknown)
	Material.VectorExpressions[4] = float4(0.760525,0.760525,0.760525,1.000000);//TintColor
	Material.VectorExpressions[5] = float4(0.760525,0.760525,0.760525,0.000000);//(Unknown)
	Material.VectorExpressions[6] = float4(0.000000,0.000000,0.000000,0.000000);//UVSpeed
	Material.VectorExpressions[7] = float4(0.000000,0.000000,0.000000,0.000000);//(Unknown)
	Material.VectorExpressions[8] = float4(0.000000,0.000000,0.000000,0.000000);//(Unknown)
	Material.VectorExpressions[9] = float4(0.000000,0.000000,1.000000,1.000000);//UVOffsetAndScale
	Material.VectorExpressions[10] = float4(0.000000,0.000000,1.000000,0.000000);//(Unknown)
	Material.VectorExpressions[11] = float4(0.000000,0.000000,1.000000,1.000000);//(Unknown)
	Material.VectorExpressions[12] = float4(0.000000,0.000000,0.000000,0.000000);//(Unknown)
	Material.VectorExpressions[13] = float4(1.000000,1.000000,0.000000,0.000000);//(Unknown)
	Material.ScalarExpressions[0] = float4(0.000000,1.000000,6200.000000,0.000000);//UVRotation NormalMapAmount ColorTemperature LuminanceAmount
	Material.ScalarExpressions[1] = float4(0.000000,0.000000,2.000000,1.000000);//(Unknown) MetallicAmount RoughnessAmount (Unknown)
	Material.ScalarExpressions[2] = float4(1.000000,1.000000,0.000000,0.000000);//(Unknown) (Unknown) AlphaOpacityMask (Unknown)
	Material.ScalarExpressions[3] = float4(0.000000,1.000000,0.000000,0.000000);//(Unknown) (Unknown) (Unknown) (Unknown)
}
MaterialFloat2 CustomExpression1(FMaterialVertexParameters Parameters,MaterialFloat Angle)
{
float s;
float c;
sincos(Angle, s, c);
return float2(s,c);
}

MaterialFloat2 CustomExpression0(FMaterialPixelParameters Parameters,MaterialFloat Angle)
{
float s;
float c;
sincos(Angle, s, c);
return float2(s,c);
}
void CalcPixelMaterialInputs(in out FMaterialPixelParameters Parameters, in out FPixelMaterialInputs PixelMaterialInputs)
{
	float3 WorldNormalCopy = Parameters.WorldNormal;

	// Initial calculations (required for Normal)
	MaterialFloat2 Local34 = CustomExpression0(Parameters,Material.ScalarExpressions[0].x);
	MaterialFloat Local35 = (Local34.r * -1.00000000);
	MaterialFloat Local36 = MaterialStoreTexCoordScale(Parameters, Parameters.TexCoords[0].xy, 0);
	MaterialFloat4 Local37 = UnpackNormalMap(Texture2DSample(Material_Texture2D_0, GetMaterialSharedSampler(Material_Texture2D_0Sampler,View.MaterialTextureBilinearWrapedSampler),Parameters.TexCoords[0].xy));
	MaterialFloat Local38 = MaterialStoreTexSample(Parameters, Local37, 0);
	MaterialFloat3 Local39 = (MaterialFloat3(MaterialFloat2(Local34.g,Local35),0.00000000) * Local37.rgb.r);
	MaterialFloat3 Local40 = (MaterialFloat3(MaterialFloat2(Local34.r,Local34.g),0.00000000) * Local37.rgb.g);
	MaterialFloat3 Local41 = (Local39 + Local40);
	MaterialFloat3 Local42 = (MaterialFloat3(0.00000000,0.00000000,1.00000000) * Local37.rgb.b);
	MaterialFloat3 Local43 = (Local42 + MaterialFloat3(0.00000000,0.00000000,0.00000000));
	MaterialFloat3 Local44 = (Local41 + Local43);
	MaterialFloat2 Local45 = (Local44.rg * Parameters.TwoSidedSign);
	MaterialFloat3 Local46 = lerp(MaterialFloat3(0.00000000,0.00000000,1.00000000),MaterialFloat3(Local45,Local44.b),MaterialFloat(Material.ScalarExpressions[0].y));

	// The Normal is a special case as it might have its own expressions and also be used to calculate other inputs, so perform the assignment here
	PixelMaterialInputs.Normal = Local46;


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
	MaterialFloat Local47 = MaterialStoreTexCoordScale(Parameters, Parameters.TexCoords[0].xy, 1);
	MaterialFloat4 Local48 = ProcessMaterialColorTextureLookup(Texture2DSample(Material_Texture2D_1, GetMaterialSharedSampler(Material_Texture2D_1Sampler,View.MaterialTextureBilinearWrapedSampler),Parameters.TexCoords[0].xy));
	MaterialFloat Local49 = MaterialStoreTexSample(Parameters, Local48, 1);
	MaterialFloat3 Local50 = MaterialExpressionBlackBody(Material.ScalarExpressions[0].z);
	MaterialFloat Local51 = dot(Local50, Local50);
	MaterialFloat Local52 = sqrt(Local51);
	MaterialFloat3 Local53 = (Local50 / Local52);
	MaterialFloat3 Local54 = (Material.VectorExpressions[2].rgb * Local53);
	MaterialFloat3 Local55 = (Material.ScalarExpressions[0].w * Local54);
	MaterialFloat3 Local56 = (Local48.rgb * Local55);
	MaterialFloat3 Local57 = lerp(Local56,Material.VectorExpressions[3].rgb,MaterialFloat(Material.ScalarExpressions[1].x));
	MaterialFloat Local58 = MaterialStoreTexCoordScale(Parameters, Parameters.TexCoords[0].xy, 2);
	MaterialFloat4 Local59 = ProcessMaterialColorTextureLookup(Texture2DSample(Material_Texture2D_2, GetMaterialSharedSampler(Material_Texture2D_2Sampler,View.MaterialTextureBilinearWrapedSampler),Parameters.TexCoords[0].xy));
	MaterialFloat Local60 = MaterialStoreTexSample(Parameters, Local59, 2);
	MaterialFloat3 Local61 = (Local59.rgb * Material.VectorExpressions[5].rgb);
	MaterialFloat Local62 = MaterialStoreTexCoordScale(Parameters, Parameters.TexCoords[0].xy, 3);
	MaterialFloat4 Local63 = ProcessMaterialLinearColorTextureLookup(Texture2DSample(Material_Texture2D_3, GetMaterialSharedSampler(Material_Texture2D_3Sampler,View.MaterialTextureBilinearWrapedSampler),Parameters.TexCoords[0].xy));
	MaterialFloat Local64 = MaterialStoreTexSample(Parameters, Local63, 3);
	MaterialFloat3 Local65 = lerp(Local59.rgb,Local61,Local63.rgb);
	MaterialFloat Local66 = MaterialStoreTexCoordScale(Parameters, Parameters.TexCoords[0].xy, 5);
	MaterialFloat4 Local67 = ProcessMaterialLinearColorTextureLookup(Texture2DSample(Material_Texture2D_4, GetMaterialSharedSampler(Material_Texture2D_4Sampler,View.MaterialTextureBilinearWrapedSampler),Parameters.TexCoords[0].xy));
	MaterialFloat Local68 = MaterialStoreTexSample(Parameters, Local67, 5);
	MaterialFloat Local69 = (Local67.r * Material.ScalarExpressions[1].y);
	MaterialFloat Local70 = MaterialStoreTexCoordScale(Parameters, Parameters.TexCoords[0].xy, 6);
	MaterialFloat4 Local71 = ProcessMaterialLinearColorTextureLookup(Texture2DSample(Material_Texture2D_5, GetMaterialSharedSampler(Material_Texture2D_5Sampler,View.MaterialTextureBilinearWrapedSampler),Parameters.TexCoords[0].xy));
	MaterialFloat Local72 = MaterialStoreTexSample(Parameters, Local71, 6);
	MaterialFloat3 Local73 = lerp(MaterialFloat3(0.00000000,0.00000000,0.00000000),Local71.rgb,MaterialFloat(Material.ScalarExpressions[1].w));
	MaterialFloat3 Local74 = lerp(Local73,MaterialFloat3(1.00000000,1.00000000,1.00000000),MaterialFloat(Material.ScalarExpressions[2].y));
	MaterialFloat Local75 = lerp(1.00000000,Local59.a,Material.ScalarExpressions[2].z);

	PixelMaterialInputs.EmissiveColor = Local57;
	PixelMaterialInputs.Opacity = 1.00000000;
	PixelMaterialInputs.OpacityMask = Local75;
	PixelMaterialInputs.BaseColor = Local65;
	PixelMaterialInputs.Metallic = Local69;
	PixelMaterialInputs.Specular = 0.50000000;
	PixelMaterialInputs.Roughness = Local74;
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