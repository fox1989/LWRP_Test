Shader "Unlit/LightEdge"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Edge("Edge",Float)=1
        _EdgeColor("EdgeColor",Color)=(1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 noraml:NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 noraml:NORMAL;
                float3 worldPos:TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Edge;
            float4 _EdgeColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = TransformObjectToHClip(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.noraml=TransformObjectToWorldNormal(v.noraml);
                o.worldPos=TransformObjectToWorld(v.vertex);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                // sample the texture
                float3 lightDir=normalize(_MainLightPosition.xyz);
                float3 cameraDir=normalize(_WorldSpaceCameraPos.xyz-i.worldPos.xyz);
                float4 col=tex2D(_MainTex,i.uv);
                float f=  dot(cameraDir,i.noraml);
                f=1-f*_Edge;

                return lerp( col,_EdgeColor,f);
            }
            ENDHLSL
        }
    }
}
