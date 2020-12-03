 qShader "Unlit/YuanShen_"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _LightMap ("_LightMap", 2D) = "white" {}

        _ShadowColor("_ShadowColor",Color) = (0.2,0.2,0.2,0.2)

        _DiffuseThreshold("_DiffuseThreshold",Float)  =0
        _SpecularThreshold("_SpecularThreshold",Float) =0.8
        _SpecularScale("_SpecularScale",Float) =1
        _SpecularColor("_SpecularColor",Color) = (1,1,1,1)
        
        _Outline("Thick of Outline",Float) = 0.01
		_Factor("Factor",range(0,1)) = 0.5
		_OutColor("OutColor",color) = (0,0,0,0)

        // [KeywordEnum(GGX,Kelemen)] Spec("Specular Mode",Float) = 1

        [KeywordEnum(None,LightMap_R,LightMap_G,LightMap_B,LightMap_A,UV,UV2,VertexColor,BaseColor)] _TestMode("_TestMode",Int) = 0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "LightMode"="ForwardBase" "Queue" = "Geometry"}
        Cull Off
        Pass
        {

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma fullforwardshadows
            #pragma multi_compile_fwdbase
            
            #include "UnityCG.cginc"
			#include "Lighting.cginc"
            #include "UnityGlobalIllumination.cginc"
            #include "AutoLight.cginc"

            sampler2D _MainTex,_LightMap;

            float4 _ShadowColor,_SpecularColor;

            int _TestMode;
            float _DiffuseThreshold,_SpecularThreshold,_SpecularScale;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                float4 tangent :TANGENT;
                float3 normal : NORMAL;
                float4 vertexColor : Color;
            };

            struct v2f
            {
                float4 pos          : SV_POSITION; // 必须命名为pos ，因为 TRANSFER_VERTEX_TO_FRAGMENT 是这么命名的，为了正确地获取到Shadow
                float2 uv           : TEXCOORD0;
                float3 tangent      : TEXCOORD1;
                float3 bitangent    : TEXCOORD2; 
                float3 normal       : TEXCOORD3; 
                float3 worldPosition: TEXCOORD4;
                float3 localPosition : TEXCOORD5;
                float3 localNormal  : TEXCOORD6;
                float3 vertexColor  : TEXCOORD7;
                LIGHTING_COORDS(8,9)
                float2 uv2          : TEXCOORD10;

            };

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.uv2 = v.uv2;
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPosition = mul(unity_ObjectToWorld,v.vertex);
                o.localPosition = v.vertex.xyz;
                o.tangent = UnityObjectToWorldDir(v.tangent);
                o.bitangent = cross(o.normal,o.tangent) * v.tangent.w;
                o.localNormal = v.normal;
                o.vertexColor = v.vertexColor;

                TRANSFER_VERTEX_TO_FRAGMENT(o);
                
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {

                //Variable
                float3 T = normalize(cross(i.normal ,i.tangent));
                float3 N = normalize(i.normal);
                float3 B = normalize( cross(N,T));
                // float3 B = normalize( i.bitangent);
                float3 L = normalize( UnityWorldSpaceLightDir(i.worldPosition.xyz));
                float3 V = normalize( UnityWorldSpaceViewDir(i.worldPosition.xyz));
                float3 H = normalize(V+L);
                float2 uv = i.uv;
                uv.y = 1-uv.y;  //uv颠倒了,如果在 Csv2Obj阶段已经反转了，这里就不需要再转了
                float2 uv2 = i.uv2;

                // return float4(uv2,0,0);
                float3 vertexColor = i.vertexColor;
                // return vertexColor.xyzz;
                float HV = dot(H,V);
                float NV = dot(N,V);
                float NL = dot(N,L);
                float NH = dot(N,H);

/*==========================Texture ==========================*/

                float3 FinalColor = 0;
                float4 BaseColor = tex2D(_MainTex,uv);

                float4 LightMap = tex2D(_LightMap,uv);
                // return BaseColor.xyzz;
                int mode = 1;
                if(_TestMode == mode++)
                    return LightMap.r;
                if(_TestMode ==mode++)
                    return LightMap.g; //阴影 Mask
                if(_TestMode ==mode++)
                    return LightMap.b; //漫反射 Mask
                if(_TestMode ==mode++)
                    return LightMap.a; //漫反射 Mask
                if(_TestMode ==mode++)
                    return float4(uv,0,0); //uv
                if(_TestMode ==mode++)
                    return float4(uv2,0,0); //uv2
                if(_TestMode ==mode++)
                    return vertexColor.xyzz; //vertexColor
                if(_TestMode ==mode++)
                    return BaseColor.xyzz; //BaseColor

/*==========================Diffuse ==========================*/

                float wrapLight = 0.5*NL+0.5;
                float3 light = 1;

                if(NL +_DiffuseThreshold*0.1  <LightMap.g )
                {
                    light = _ShadowColor.rgb;
                }
                else
                {
                    light =1;
                }

                // light *= BaseColor.g;

                float3 Diffuse = (BaseColor ) * light    ;

/*==========================Spedular ==========================*/
                float3 Specular =0;
                float SpecularValue  =pow(saturate(NH),BaseColor.r);
                if(SpecularValue>_SpecularThreshold*0.1)
                {
                    Specular = _SpecularColor* LightMap.b*_SpecularScale;
                }

                float3 Emission =0;

                FinalColor = Diffuse + Specular +Emission;
                
                return float4(FinalColor,1);
            }
            ENDCG
        }

        pass 
		{//处理光照前的pass渲染
			Tags{ "LightMode" = "Always" }
			Cull Front
			ZWrite On
			CGPROGRAM
			#pragma multi_compile_fog
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			float _Outline;
			float _Factor;
			fixed4 _OutColor;
 
			struct v2f 
			{
				float4 pos:SV_POSITION;
				UNITY_FOG_COORDS(0)
			};
 
			v2f vert(appdata_full v) 
			{
				v2f o;
				float3 dir = normalize(v.vertex.xyz);
				float3 dir2 = v.normal;
				float D = dot(dir,dir2);
				dir = dir * sign(D);
				dir = dir * _Factor + dir2 * (1 - _Factor);
				v.vertex.xyz += dir * _Outline*0.001;
				o.pos = UnityObjectToClipPos(v.vertex);
				UNITY_TRANSFER_FOG(o, o.pos);
				return o;
			}
 
			float4 frag(v2f i) :COLOR
			{
				float4 c = _OutColor;
				UNITY_APPLY_FOG(i.fogCoord, c);
				return c;
			}
			ENDCG
		}
    }
}