Shader "Unlit/URPNormalOutLine"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _OutLineColor("OutLineColor",Color)=(1,1,1,1)
        _OutlineWidth ("outline width", Float) = 0
    }
    SubShader
    {
        Tags { "RenderPipelin"="UniversalRenderPipeline" "IgnoreProjector"="True" }
        
           HLSLINCLUDE
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            ENDHLSL


        Pass
        {
         Tags{"LightMode"="UniversalForward"}

             Cull Front
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
        

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 normal:NORMAL;
                 float4 tangent : TANGENT;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _OutLineColor;
            float _OutlineWidth;


            v2f vert (appdata v)
            {
                v2f o;
                float4 pos = TransformObjectToHClip(v.vertex);
                float3 viewNormal = mul((float3x3)UNITY_MATRIX_IT_MV, v.tangent.xyz);

                float3 ndcNormal = normalize(TransformWViewToHClip(viewNormal.xyz)) * pos.w;//将法线变换到NDC空间
                pos.xy += 0.01 * _OutlineWidth * ndcNormal.xy;
                o.vertex = pos;

                //o.vertex = TransformObjectToHClip(v.vertex+viewNormal*_OutlineWidth*0.1);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                // sample the texture
                half4 col = tex2D(_MainTex, i.uv);
                return _OutLineColor;
            }
            ENDHLSL
        }


          Pass
        {
         Tags{"LightMode"="LightweightForward"}

            HLSLPROGRAM


             #pragma multi_compile_instancing

            //#pragma vertex LitPassVertex
            //#pragma fragment LitPassFragment

            //#include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
            //#include "Packages/com.unity.render-pipelines.universal/Shaders/LitForwardPass.hlsl"


            #pragma vertex vert
            #pragma fragment frag
            
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = TransformObjectToHClip(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                // sample the texture
                half4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDHLSL
        }
    }
}
