Shader "Unlit/URPLowPoly"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _OutLineColor("OutLineColor",Color)=(1,1,1,1)
        _OutlineWidth ("outline width", Float) = 0
        _Specular("Specular",Float)=0
        _Shadow("Shadow",Float)=0
        _Shadow2("Shadow2",Float)=0
        _SpecularColor("SpecularColor",Color)=(1,1,1,1)
        _Normal("Noraml",2D)="white"{}
        _AOTex("AOTex",2D)="white"{}
        _AO("AO",Float)=1

       _ReceiveShadows("Receive Shadows", Float) = 1.0
    }
    SubShader
    {
        Tags{"RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "IgnoreProjector" = "True"}
         
          Pass
         {
            Tags{"LightMode"="LightweightForward"}
            HLSLPROGRAM


             #pragma multi_compile_instancing

            //#pragma vertex LitPassVertex
            //#pragma fragment LitPassFragment

            //#include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
            //#include "Packages/com.unity.render-pipelines.universal/Shaders/LitForwardPass.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _SHADOWS_SOFT
			//#pragma multi_compile _ Anti_Aliasing_ON



            #pragma vertex vert
            #pragma fragment frag
            
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                float3 normal:NORMAL;
                
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD3;
                float4 vertex : SV_POSITION;
                float3 normal:NORMAL;
                float3 worldPos:TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float  _Specular;
            sampler2D _Normal;
            float _Shadow;
            float _Shadow2;
            float4 _SpecularColor;

            float _AO;
            float _ReceiveShadows;

            sampler2D _AOTex;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = TransformObjectToHClip(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                //o.uv.y=1-o.uv.y;
                o.normal=TransformObjectToWorldNormal(v.normal);
                o.worldPos=TransformObjectToWorld(v.vertex).xyz;
                o.uv2=v.uv2;
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                // sample the texture
                half4 col = tex2D(_MainTex, i.uv);
                half4 noraml = tex2D(_Normal, i.uv);

                half4 ao = tex2D(_AOTex, i.uv2);

                half3 worldLightDir = normalize(_MainLightPosition.xyz);


                float halfLambert=dot(i.normal,worldLightDir)*0.5+0.5;

          

               float3 worldPos= i.worldPos;


                float3 cameraDir=normalize(_WorldSpaceCameraPos.xyz-worldPos.xyz);

                float3 Sdir=normalize(worldLightDir+cameraDir);

                float  s=max(0,dot(Sdir,i.normal));
                s=pow(s,_Specular);

                //s=s>_Specular*0.1?s:0;
                //s*=_Specular*0.1;
                //float high=dot(i.normal,_)
                ao*=_AO;

                ao=saturate(ao);

                //halfLambert=halfLambert>0.5?1:0.8;

                float4 SHADOW_COORDS = TransformWorldToShadowCoord(worldPos);
 
				Light mainLight = GetMainLight(SHADOW_COORDS);
				half shadow =mainLight.shadowAttenuation+_ReceiveShadows; //MainLightRealtimeShadow(SHADOW_COORDS);
                shadow=shadow>1?1:shadow;
                float4 reCol=col*halfLambert*ao+s*_SpecularColor;
                reCol.xyz*=shadow;

                return reCol;
            }
            ENDHLSL
        }





        Pass
        {
            Name "ShadowCaster"
            Tags{"LightMode" = "ShadowCaster"}

            ZWrite On
            ZTest LEqual
            Cull[_Cull]

            HLSLPROGRAM
            // Required to compile gles 2.0 with standard srp library
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature _ALPHATEST_ON

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing
            #pragma shader_feature _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

            #pragma vertex ShadowPassVertex
            #pragma fragment ShadowPassFragment

            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/ShadowCasterPass.hlsl"
            ENDHLSL
        }
    }
     FallBack "Hidden/Universal Render Pipeline/FallbackError"
}
