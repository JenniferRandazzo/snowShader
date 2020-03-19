Shader "Custom/SnowShader"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Normal("Normal", 2D) = "white" {}
		_Occlusion("Occlusion", 2D) = "white" {}

		_SnowTex("Snow Albedo (RGB)", 2D) = "white" {}
		_SnowDirection("Snow Direction", Vector) = (0, 1, 0, 0)
		_SnowAmount("Snow Amount", Range(0,1)) = 0.1
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }
			LOD 200

			CGPROGRAM
			// Physically based Standard lighting model, and enable shadows on all light types
			#pragma surface surf Standard fullforwardshadows

			// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 3.0

			sampler2D _MainTex;
			sampler2D _SnowTex;
			sampler2D _Normal;
			sampler2D _Occlusion;

			struct Input
			{
				float2 uv_MainTex;
				float3 worldNormal;
				INTERNAL_DATA
			};
			fixed4 _Color;

			float4 _SnowDirection;
			float _SnowAmount;
				
			UNITY_INSTANCING_BUFFER_START(Props)
			UNITY_INSTANCING_BUFFER_END(Props)

			void surf(Input IN, inout SurfaceOutputStandard o)
			{
				
				fixed3 normal = UnpackNormal(tex2D(_Normal, IN.uv_MainTex));
				o.Normal = normal.rgb;

				float3 worldNormal = WorldNormalVector(IN, o.Normal);
				float snowCoverage = (dot(worldNormal, _SnowDirection) + 1) / 2; 
				snowCoverage =  1 - snowCoverage;

				float snowStrength = (snowCoverage < _SnowAmount) ;

				fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
				fixed4 snowColor = tex2D(_SnowTex, IN.uv_MainTex) * _Color;
				fixed4 occlusion = tex2D(_Occlusion, IN.uv_MainTex);
				o.Albedo = c * (1 - snowStrength) + snowColor * snowStrength;
				o.Occlusion = occlusion.r;
				o.Alpha = c.a;
			}
			ENDCG
		}
			FallBack "Diffuse"
}