Shader "Unlit/URPNormalOutLineYuanShen"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _OutLineColor("OutLineColor",Color)=(1,1,1,1)
        _OutlineWidth ("outline width", Float) = 0
        _Specular("Specular",Float)=0
        _Shadow("Shadow",Float)=0
        _Shadow2("Shadow2",Float)=0

        _Normal("Noraml",2D)="white"{}
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
                float3 normal:NORMAL;
                
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = TransformObjectToHClip(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                //o.uv.y=1-o.uv.y;
                o.normal=TransformObjectToWorldNormal(v.normal);
                o.worldPos=v.vertex;
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                // sample the texture
                half4 col = tex2D(_MainTex, i.uv);
                half4 noraml = tex2D(_Normal, i.uv);
                half3 worldLightDir = normalize(_MainLightPosition.xyz);


                float halfLambert=dot(i.normal,worldLightDir)*0.5+0.5;

                if(halfLambert>_Shadow)
                {
                    halfLambert=1;
                }else if(halfLambert>_Shadow2)
                {
                    halfLambert=0.8;
                }else
                {
                    halfLambert=0.4;
                }

               float3 worldPos= TransformObjectToWorld(i.worldPos).xyz;


                float3 cameraDir=normalize(_WorldSpaceCameraPos.xyz-worldPos.xyz);

                float3 Sdir=normalize(worldLightDir+cameraDir);

                float  s=max(0,dot(Sdir,i.normal));
                //s=pow(s,_Specular);

                s=s>_Specular*0.1?s:0;
                s*=0.5;
                //float high=dot(i.normal,_)


                //halfLambert=halfLambert>0.5?1:0.8;

                return col*halfLambert+s;
            }
            ENDHLSL
        }
    }
}
