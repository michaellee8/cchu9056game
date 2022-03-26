Shader "Unreal/M_Sky_Panning_Clouds2(MaterialInstanceDynamic_0)"
{
	Properties
	{
		_MainTex("MainTex (RGB)", 2D) = "white" {}
		Material_Texture2D_0( "T_Sky_Stars", 2D ) = "white" {}
		Material_Texture2D_1( "T_Sky_Blue", 2D ) = "white" {}
		Material_Texture2D_2( "T_Sky_Clouds_M", 2D ) = "white" {}

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

		#define NUM_TEX_COORD_INTERPOLATORS 2
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
			float4 VectorExpressions[16];
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
	Material.VectorExpressions[1] = float4(0.034046,0.072827,0.185044,1.000000);//Zenith Color
	Material.VectorExpressions[2] = float4(0.034046,0.072827,0.185044,0.000000);//(Unknown)
	Material.VectorExpressions[3] = float4(0.673802,0.674747,1.000000,1.000000);//Horizon color
	Material.VectorExpressions[4] = float4(0.673802,0.674747,1.000000,0.000000);//(Unknown)
	Material.VectorExpressions[5] = float4(0.687334,0.506979,-0.520138,1.000000);//Light direction
	Material.VectorExpressions[6] = float4(0.687334,0.506979,-0.520138,0.000000);//(Unknown)
	Material.VectorExpressions[7] = float4(0.687334,0.506979,-0.520138,0.000000);//(Unknown)
	Material.VectorExpressions[8] = float4(1.000000,1.000000,1.000000,1.000000);//Sun color
	Material.VectorExpressions[9] = float4(1.000000,1.000000,1.000000,0.000000);//(Unknown)
	Material.VectorExpressions[10] = float4(75.000000,75.000000,75.000000,0.000000);//(Unknown)
	Material.VectorExpressions[11] = float4(0.846601,0.761922,0.752507,1.000000);//Cloud color
	Material.VectorExpressions[12] = float4(0.846601,0.761922,0.752507,0.000000);//(Unknown)
	Material.VectorExpressions[13] = float4(1.000000,1.000000,1.000000,1.000000);//Overall Color
	Material.VectorExpressions[14] = float4(1.000000,1.000000,1.000000,0.000000);//(Unknown)
	Material.VectorExpressions[15] = float4(0.000000,0.000000,0.000000,0.000000);//(Unknown)
	Material.ScalarExpressions[0] = float4(0.100000,0.000000,4.392956,1.000000);//Stars brightness Sun height Horizon Falloff (Unknown)
	Material.ScalarExpressions[1] = float4(1.000000,0.000300,0.000300,3333.333252);//(Unknown) Sun Radius (Unknown) (Unknown)
	Material.ScalarExpressions[2] = float4(75.000000,2.000000,1.000000,4.000000);//Sun brightness Cloud speed Cloud opacity NoisePower2
	Material.ScalarExpressions[3] = float4(1.000000,0.000000,0.000000,0.000000);//NoisePower1 (Unknown) (Unknown) (Unknown)
}void CalcPixelMaterialInputs(in out FMaterialPixelParameters Parameters, in out FPixelMaterialInputs PixelMaterialInputs)
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
	MaterialFloat2 Local0 = (Parameters.TexCoords[1].xy * 12.00000000);
	MaterialFloat Local1 = MaterialStoreTexCoordScale(Parameters, Local0, 1);
	MaterialFloat4 Local2 = ProcessMaterialColorTextureLookup(Texture2DSampleBias(Material_Texture2D_0, Material_Texture2D_0Sampler,Local0,View.MaterialTextureMipBias));
	MaterialFloat Local3 = MaterialStoreTexSample(Parameters, Local2, 1);
	MaterialFloat3 Local4 = (Local2.rgb * Material.ScalarExpressions[0].x);
	MaterialFloat3 Local5 = (Local4 * Material.ScalarExpressions[0].y);
	MaterialFloat3 Local6 = (Material.VectorExpressions[2].rgb + Local5);
	MaterialFloat Local7 = dot(Parameters.CameraVector, MaterialFloat3(0.00000000,0.00000000,-1.00000000));
	MaterialFloat Local8 = min(max(Local7,0.00000000),1.00000000);
	MaterialFloat Local9 = (1.00000000 - Local8);
	MaterialFloat Local10 = PositiveClampedPow(Local9,Material.ScalarExpressions[0].z);
	MaterialFloat Local11 = min(max(Local10,0.00000000),1.00000000);
	MaterialFloat3 Local12 = lerp(Local6,Material.VectorExpressions[4].rgb,MaterialFloat(Local11));
	MaterialFloat Local13 = dot(Parameters.CameraVector, Material.VectorExpressions[7].rgb);
	MaterialFloat Local14 = (Local13 - 1.00000000);
	MaterialFloat Local15 = abs(Local14);
	MaterialFloat Local16 = (Local15 * Material.ScalarExpressions[1].w);
	MaterialFloat Local17 = (1.00000000 - Local16);
	MaterialFloat Local18 = (Local17 * 1.00000000);
	MaterialFloat Local19 = min(max(Local18,0.00000000),1.00000000);
	MaterialFloat3 Local20 = (Local19 * Material.VectorExpressions[10].rgb);
	MaterialFloat3 Local21 = (Local12 + Local20);
	MaterialFloat Local22 = (View.GameTime * Material.ScalarExpressions[2].y);
	MaterialFloat Local23 = (Local22 * 0.00020000);
	MaterialFloat Local24 = (Local22 * 0.00000000);
	MaterialFloat2 Local25 = (MaterialFloat2(Local23,Local24) + Parameters.TexCoords[0].xy);
	MaterialFloat Local26 = MaterialStoreTexCoordScale(Parameters, Local25, 2);
	MaterialFloat4 Local27 = ProcessMaterialColorTextureLookup(Texture2DSampleBias(Material_Texture2D_1, Material_Texture2D_1Sampler,Local25,View.MaterialTextureMipBias));
	MaterialFloat Local28 = MaterialStoreTexSample(Parameters, Local27, 2);
	MaterialFloat Local29 = (Local22 * 0.00100000);
	MaterialFloat2 Local30 = (MaterialFloat2(Local29,Local24) + Parameters.TexCoords[0].xy);
	MaterialFloat Local31 = MaterialStoreTexCoordScale(Parameters, Local30, 0);
	MaterialFloat4 Local32 = ProcessMaterialGreyscaleTextureLookup((Texture2DSampleBias(Material_Texture2D_2, Material_Texture2D_2Sampler,Local30,View.MaterialTextureMipBias)).r).rrrr;
	MaterialFloat Local33 = MaterialStoreTexSample(Parameters, Local32, 0);
	MaterialFloat Local34 = lerp(Local27.r,Local32.r,Local8);
	MaterialFloat3 Local35 = (GetWorldPosition(Parameters) - GetObjectWorldPosition(Parameters));
	MaterialFloat Local36 = (GetPrimitiveData(Parameters.PrimitiveId).ObjectWorldPositionAndRadius.w * -0.10000000);
	MaterialFloat3 Local37 = (Local35 / Local36);
	MaterialFloat Local38 = min(max(Local37.b,0.00000000),1.00000000);
	MaterialFloat Local39 = (1.00000000 - Local38);
	MaterialFloat Local40 = (Local39 * Material.ScalarExpressions[2].z);
	MaterialFloat Local41 = lerp(0.00000000,Local34,Local40);
	MaterialFloat2 Local42 = (Parameters.TexCoords[0].xy * 0.50000000);
	MaterialFloat Local43 = MaterialStoreTexCoordScale(Parameters, Local42, 0);
	MaterialFloat4 Local44 = ProcessMaterialGreyscaleTextureLookup((Texture2DSampleBias(Material_Texture2D_2, Material_Texture2D_2Sampler,Local42,View.MaterialTextureMipBias)).r).rrrr;
	MaterialFloat Local45 = MaterialStoreTexSample(Parameters, Local44, 0);
	MaterialFloat Local46 = lerp(Material.ScalarExpressions[3].x,Material.ScalarExpressions[2].w,Local44.r);
	MaterialFloat Local47 = PositiveClampedPow(Local41,Local46);
	MaterialFloat3 Local48 = (Material.VectorExpressions[12].rgb * Local47);
	MaterialFloat Local49 = (Local15 * (1.00000000 / max(0.00001000,1.29999995)));
	MaterialFloat Local50 = (1.00000000 - Local49);
	MaterialFloat Local51 = (Local50 * 1.00000000);
	MaterialFloat Local52 = min(max(Local51,0.00000000),1.00000000);
	MaterialFloat Local53 = PositiveClampedPow(Local52,10.00000000);
	MaterialFloat Local54 = min(max(Local53,0.00000000),1.00000000);
	MaterialFloat3 Local55 = (Local54 * Material.VectorExpressions[9].rgb);
	MaterialFloat Local56 = (Local47 * Local47);
	MaterialFloat Local57 = (Local56 * 0.40000001);
	MaterialFloat3 Local58 = (Local55 * Local57);
	MaterialFloat3 Local59 = (Local48 + Local58);
	MaterialFloat Local60 = min(max(Local56,0.00000000),1.00000000);
	MaterialFloat3 Local61 = lerp(Local21,Local59,MaterialFloat(Local60));
	MaterialFloat3 Local62 = (Local61 * Material.VectorExpressions[14].rgb);
	MaterialFloat3 Local63 = (Local62 * 1.50000000);
	MaterialFloat3 Local64 = lerp(Local63,Material.VectorExpressions[15].rgb,MaterialFloat(Material.ScalarExpressions[3].y));

	PixelMaterialInputs.EmissiveColor = Local64;
	PixelMaterialInputs.Opacity = 1.00000000;
	PixelMaterialInputs.OpacityMask = 1.00000000;
	PixelMaterialInputs.BaseColor = MaterialFloat3(0.00000000,0.00000000,0.00000000);
	PixelMaterialInputs.Metallic = 0.00000000;
	PixelMaterialInputs.Specular = 0.50000000;
	PixelMaterialInputs.Roughness = 0.50000000;
	PixelMaterialInputs.Anisotropy = 0.00000000;
	PixelMaterialInputs.Tangent = MaterialFloat3(1.00000000,0.00000000,0.00000000);
	PixelMaterialInputs.Subsurface = 0;
	PixelMaterialInputs.AmbientOcclusion = 1.00000000;
	PixelMaterialInputs.Refraction = 0;
	PixelMaterialInputs.PixelDepthOffset = 0.00000000;
	PixelMaterialInputs.ShadingModel = 0;


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
			//if( PixelMaterialInputs.OpacityMask < 0.333 ) discard;

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