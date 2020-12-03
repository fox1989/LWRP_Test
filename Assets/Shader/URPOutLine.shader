Shader "Unlit/URPOutLine"
{
  Properties
    {
        [HideInInspector]_MainTex("Base (RGB)", 2D) = "white" {}
        _Rate("Rate", Float) = 0.5
        _Strength("Strength", Float) = 0.7
        _OutLineColor("OutLineColor",Color)=(1,1,1,1)
    }
    SubShader
    {
        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag
        

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);

            TEXTURE2D(_CameraDepthTexture);
            SAMPLER(sampler_CameraDepthTexture);
            float4 _CameraDepthTexture_TexelSize;
            float4 _OutLineColor;
            float _Rate;
            float _Strength;

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 vertex : SV_POSITION;
                float2 uv[10] : TEXCOORD0;
             
            };

            Varyings vert(Attributes input)
            {
                Varyings output;

                VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
                output.vertex = vertexInput.positionCS;
                output.uv[9]=input.uv;

                // output.uv[0] = input.uv + _CameraDepthTexture_TexelSize.xy * half2(-1, -1) * _Rate;
                // output.uv[1] = input.uv + _CameraDepthTexture_TexelSize.xy * half2(0, -1) * _Rate;
                // output.uv[2] = input.uv + _CameraDepthTexture_TexelSize.xy * half2(1, -1) * _Rate;
                // output.uv[3] = input.uv + _CameraDepthTexture_TexelSize.xy * half2(-1, 0) * _Rate;
                // output.uv[4] = input.uv + _CameraDepthTexture_TexelSize.xy * half2(0, 0) * _Rate;
                // output.uv[5] = input.uv + _CameraDepthTexture_TexelSize.xy * half2(1, 0) * _Rate;
                // output.uv[6] = input.uv + _CameraDepthTexture_TexelSize.xy * half2(-1, 1) * _Rate;
                // output.uv[7] = input.uv + _CameraDepthTexture_TexelSize.xy * half2(0, 1) * _Rate;
                // output.uv[8] = input.uv + _CameraDepthTexture_TexelSize.xy * half2(1, 1) * _Rate;

                return output;
            }

            float4 frag(Varyings input) : SV_Target
            {



                float tdepth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, sampler_CameraDepthTexture, input.uv[9]);
                _Rate*=tdepth*50;

                input.uv[0] = input.uv[9] + _CameraDepthTexture_TexelSize.xy * half2(-1, -1) * _Rate;
                input.uv[1] = input.uv[9] + _CameraDepthTexture_TexelSize.xy * half2(0, -1) * _Rate;
                input.uv[2] = input.uv[9] + _CameraDepthTexture_TexelSize.xy * half2(1, -1) * _Rate;
                input.uv[3] = input.uv[9] + _CameraDepthTexture_TexelSize.xy * half2(-1, 0) * _Rate;
                input.uv[4] = input.uv[9] + _CameraDepthTexture_TexelSize.xy * half2(0, 0) * _Rate;
                input.uv[5] = input.uv[9] + _CameraDepthTexture_TexelSize.xy * half2(1, 0) * _Rate;
                input.uv[6] = input.uv[9] + _CameraDepthTexture_TexelSize.xy * half2(-1, 1) * _Rate;
                input.uv[7] = input.uv[9] + _CameraDepthTexture_TexelSize.xy * half2(0, 1) * _Rate;
                input.uv[8] = input.uv[9] + _CameraDepthTexture_TexelSize.xy * half2(1, 1) * _Rate;

                
                
                const half Gx[9] = {
                    -1,  0,  1,
                    -2,  0,  2,
                    -1,  0,  1
                };

                const half Gy[9] = {
                    -1, -2, -1,
                    0,  0,  0,
                    1,  2,  1
                };

                float edgeY = 0;
                float edgeX = 0;    
                float luminance = 0;

                float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, input.uv[4]);

                for (int i = 0; i < 9; i++) {
                    float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, sampler_CameraDepthTexture, input.uv[i]);
                    luminance = LinearEyeDepth(depth, _ZBufferParams) *10*depth;
                    edgeX += luminance * Gx[i];
                    edgeY += luminance * Gy[i];
                }

                float edge = (1 - abs(edgeX) - abs(edgeY));
                edge = saturate(edge);

                return lerp(_OutLineColor * _Strength, color, edge);
            }

            ENDHLSL
        }
    }
    FallBack "Diffuse"
}
