//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Legacy Shaders/Specular" {
Properties {
 _Color ("Main Color", Color) = (1,1,1,1)
 _SpecColor ("Specular Color", Color) = (0.5,0.5,0.5,1)
 _Shininess ("Shininess", Range(0.01,1)) = 0.078125
 _MainTex ("Base (RGB) Gloss (A)", 2D) = "white" { }
}
SubShader { 
 LOD 300
 Tags { "RenderType"="Opaque" }
 Pass {
  Name "FORWARD"
  Tags { "LIGHTMODE"="ForwardBase" "SHADOWSUPPORT"="true" "RenderType"="Opaque" }
  GpuProgramID 6902
Program "vp" {
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
"!!GLSL#version 120

#ifdef VERTEX
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHC;

uniform mat4 _Object2World;
uniform mat4 _World2Object;
uniform vec4 _MainTex_ST;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
void main ()
{
  vec4 v_1;
  v_1.x = _World2Object[0].x;
  v_1.y = _World2Object[1].x;
  v_1.z = _World2Object[2].x;
  v_1.w = _World2Object[3].x;
  vec4 v_2;
  v_2.x = _World2Object[0].y;
  v_2.y = _World2Object[1].y;
  v_2.z = _World2Object[2].y;
  v_2.w = _World2Object[3].y;
  vec4 v_3;
  v_3.x = _World2Object[0].z;
  v_3.y = _World2Object[1].z;
  v_3.z = _World2Object[2].z;
  v_3.w = _World2Object[3].z;
  vec3 tmpvar_4;
  tmpvar_4 = normalize(((
    (v_1.xyz * gl_Normal.x)
   + 
    (v_2.xyz * gl_Normal.y)
  ) + (v_3.xyz * gl_Normal.z)));
  vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  vec3 x2_6;
  vec3 x1_7;
  x1_7.x = dot (unity_SHAr, tmpvar_5);
  x1_7.y = dot (unity_SHAg, tmpvar_5);
  x1_7.z = dot (unity_SHAb, tmpvar_5);
  vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_4.xyzz * tmpvar_4.yzzx);
  x2_6.x = dot (unity_SHBr, tmpvar_8);
  x2_6.y = dot (unity_SHBg, tmpvar_8);
  x2_6.z = dot (unity_SHBb, tmpvar_8);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_4;
  xlv_TEXCOORD2 = (_Object2World * gl_Vertex).xyz;
  xlv_TEXCOORD3 = ((x2_6 + (unity_SHC.xyz * 
    ((tmpvar_4.x * tmpvar_4.x) - (tmpvar_4.y * tmpvar_4.y))
  )) + x1_7);
}


#endif
#ifdef FRAGMENT
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _LightColor0;
uniform vec4 _SpecColor;
uniform sampler2D _MainTex;
uniform vec4 _Color;
uniform float _Shininess;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
void main ()
{
  vec4 c_1;
  vec3 tmpvar_2;
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  tmpvar_2 = (tmpvar_3.xyz * _Color.xyz);
  vec4 c_4;
  vec4 c_5;
  c_5.xyz = (((tmpvar_2 * _LightColor0.xyz) * max (0.0, 
    dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)
  )) + ((_LightColor0.xyz * _SpecColor.xyz) * (
    pow (max (0.0, dot (xlv_TEXCOORD1, normalize(
      (_WorldSpaceLightPos0.xyz + normalize((_WorldSpaceCameraPos - xlv_TEXCOORD2)))
    ))), (_Shininess * 128.0))
   * tmpvar_3.w)));
  c_5.w = (tmpvar_3.w * _Color.w);
  c_4.w = c_5.w;
  c_4.xyz = (c_5.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  c_1.xyz = c_4.xyz;
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 4 [_Object2World] 3
Matrix 7 [_World2Object] 3
Matrix 0 [glstate_matrix_mvp]
Vector 17 [_MainTex_ST]
Vector 12 [unity_SHAb]
Vector 11 [unity_SHAg]
Vector 10 [unity_SHAr]
Vector 15 [unity_SHBb]
Vector 14 [unity_SHBg]
Vector 13 [unity_SHBr]
Vector 16 [unity_SHC]
"vs_2_0
def c18, 1, 0, 0, 0
dcl_position v0
dcl_normal v1
dcl_texcoord v2
dp4 oPos.x, c0, v0
dp4 oPos.y, c1, v0
dp4 oPos.z, c2, v0
dp4 oPos.w, c3, v0
mad oT0.xy, v2, c17, c17.zwzw
dp4 oT2.x, c4, v0
dp4 oT2.y, c5, v0
dp4 oT2.z, c6, v0
mul r0.xyz, v1.y, c8
mad r0.xyz, c7, v1.x, r0
mad r0.xyz, c9, v1.z, r0
nrm r1.xyz, r0
mul r0.x, r1.y, r1.y
mad r0.x, r1.x, r1.x, -r0.x
mul r2, r1.yzzx, r1.xyzz
dp4 r3.x, c13, r2
dp4 r3.y, c14, r2
dp4 r3.z, c15, r2
mad r0.xyz, c16, r0.x, r3
mov r1.w, c18.x
dp4 r2.x, c10, r1
dp4 r2.y, c11, r1
dp4 r2.z, c12, r1
mov oT1.xyz, r1
add oT3.xyz, r0, r2

"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 192
Vector 176 [_MainTex_ST]
ConstBuffer "UnityLighting" 720
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
root12:aaadaaaa
eefiecedglpcpknadddbhbbkmdncfaikjmniiggcabaaaaaaaaahaaaaadaaaaaa
cmaaaaaaceabaaaameabaaaaejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaimaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaaimaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcdeafaaaaeaaaabaaenabaaaafjaaaaaeegiocaaaaaaaaaaa
amaaaaaafjaaaaaeegiocaaaabaaaaaacnaaaaaafjaaaaaeegiocaaaacaaaaaa
bdaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaalaaaaaaogikcaaaaaaaaaaaalaaaaaadiaaaaaibcaabaaaaaaaaaaa
akbabaaaacaaaaaaakiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaaaaaaaaaa
akbabaaaacaaaaaaakiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaaaaaaaaaa
akbabaaaacaaaaaaakiacaaaacaaaaaabcaaaaaadiaaaaaibcaabaaaabaaaaaa
bkbabaaaacaaaaaabkiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaa
bkbabaaaacaaaaaabkiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaa
bkbabaaaacaaaaaabkiacaaaacaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaa
acaaaaaackiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaa
acaaaaaackiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaa
acaaaaaackiacaaaacaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaafhccabaaa
acaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaak
hccabaaaadaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
abaaaaaadiaaaaahbcaabaaaabaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaa
dcaaaaakbcaabaaaabaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaia
ebaaaaaaabaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaa
aaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaabaaaaaacjaaaaaaegaobaaa
acaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaabaaaaaackaaaaaaegaobaaa
acaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaabaaaaaaclaaaaaaegaobaaa
acaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaabaaaaaacmaaaaaaagaabaaa
abaaaaaaegacbaaaadaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadp
bbaaaaaibcaabaaaacaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaaaaaaaaaa
bbaaaaaiccaabaaaacaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaaaaaaaaaa
bbaaaaaiecaabaaaacaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaaaaaaaaaa
aaaaaaahhccabaaaaeaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadoaaaaab
"
}
SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 192
Vector 176 [_MainTex_ST]
ConstBuffer "UnityLighting" 720
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityPerDraw" 2
"vs_4_0_level_9_1
root12:aaadaaaa
eefiecedafbknmkfnkgdginmccinheeemkfkgbhjabaaaaaaaaakaaaaaeaaaaaa
daaaaaaacmadaaaagiaiaaaagaajaaaaebgpgodjpeacaaaapeacaaaaaaacpopp
jmacaaaafiaaaaaaaeaaceaaaaaafeaaaaaafeaaaaaaceaaabaafeaaaaaaalaa
abaaabaaaaaaaaaaabaacgaaahaaacaaaaaaaaaaacaaaaaaaeaaajaaaaaaaaaa
acaaamaaahaaanaaaaaaaaaaaaaaaaaaaaacpoppfbaaaaafbeaaapkaaaaaiadp
aaaaaaaaaaaaaaaaaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaacia
acaaapjabpaaaaacafaaadiaadaaapjaaeaaaaaeaaaaadoaadaaoejaabaaoeka
abaaookaafaaaaadaaaaahiaaaaaffjaaoaaoekaaeaaaaaeaaaaahiaanaaoeka
aaaaaajaaaaaoeiaaeaaaaaeaaaaahiaapaaoekaaaaakkjaaaaaoeiaaeaaaaae
acaaahoabaaaoekaaaaappjaaaaaoeiaafaaaaadaaaaabiaacaaaajabbaaaaka
afaaaaadaaaaaciaacaaaajabcaaaakaafaaaaadaaaaaeiaacaaaajabdaaaaka
afaaaaadabaaabiaacaaffjabbaaffkaafaaaaadabaaaciaacaaffjabcaaffka
afaaaaadabaaaeiaacaaffjabdaaffkaacaaaaadaaaaahiaaaaaoeiaabaaoeia
afaaaaadabaaabiaacaakkjabbaakkkaafaaaaadabaaaciaacaakkjabcaakkka
afaaaaadabaaaeiaacaakkjabdaakkkaacaaaaadaaaaahiaaaaaoeiaabaaoeia
ceaaaaacabaaahiaaaaaoeiaafaaaaadaaaaabiaabaaffiaabaaffiaaeaaaaae
aaaaabiaabaaaaiaabaaaaiaaaaaaaibafaaaaadacaaapiaabaacjiaabaakeia
ajaaaaadadaaabiaafaaoekaacaaoeiaajaaaaadadaaaciaagaaoekaacaaoeia
ajaaaaadadaaaeiaahaaoekaacaaoeiaaeaaaaaeaaaaahiaaiaaoekaaaaaaaia
adaaoeiaabaaaaacabaaaiiabeaaaakaajaaaaadacaaabiaacaaoekaabaaoeia
ajaaaaadacaaaciaadaaoekaabaaoeiaajaaaaadacaaaeiaaeaaoekaabaaoeia
abaaaaacabaaahoaabaaoeiaacaaaaadadaaahoaaaaaoeiaacaaoeiaafaaaaad
aaaaapiaaaaaffjaakaaoekaaeaaaaaeaaaaapiaajaaoekaaaaaaajaaaaaoeia
aeaaaaaeaaaaapiaalaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaamaaoeka
aaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaac
aaaaammaaaaaoeiappppaaaafdeieefcdeafaaaaeaaaabaaenabaaaafjaaaaae
egiocaaaaaaaaaaaamaaaaaafjaaaaaeegiocaaaabaaaaaacnaaaaaafjaaaaae
egiocaaaacaaaaaabdaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaaalaaaaaadiaaaaai
bcaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaacaaaaaabaaaaaaadiaaaaai
ccaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaacaaaaaabbaaaaaadiaaaaai
ecaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaacaaaaaabcaaaaaadiaaaaai
bcaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaacaaaaaabaaaaaaadiaaaaai
ccaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaacaaaaaabbaaaaaadiaaaaai
ecaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaacaaaaaabcaaaaaaaaaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaacaaaaaabcaaaaaaaaaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
dgaaaaafhccabaaaacaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaa
fgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegacbaaaabaaaaaadiaaaaahbcaabaaaabaaaaaabkaabaaaaaaaaaaa
bkaabaaaaaaaaaaadcaaaaakbcaabaaaabaaaaaaakaabaaaaaaaaaaaakaabaaa
aaaaaaaaakaabaiaebaaaaaaabaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaa
aaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaabaaaaaa
cjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaabaaaaaa
ckaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaabaaaaaa
claaaaaaegaobaaaacaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaabaaaaaa
cmaaaaaaagaabaaaabaaaaaaegacbaaaadaaaaaadgaaaaaficaabaaaaaaaaaaa
abeaaaaaaaaaiadpbbaaaaaibcaabaaaacaaaaaaegiocaaaabaaaaaacgaaaaaa
egaobaaaaaaaaaaabbaaaaaiccaabaaaacaaaaaaegiocaaaabaaaaaachaaaaaa
egaobaaaaaaaaaaabbaaaaaiecaabaaaacaaaaaaegiocaaaabaaaaaaciaaaaaa
egaobaaaaaaaaaaaaaaaaaahhccabaaaaeaaaaaaegacbaaaabaaaaaaegacbaaa
acaaaaaadoaaaaabejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaa
oaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaaabaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaaadaaaaaa
afaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaaapaaaaaa
ojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdejfeejepeo
aafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepemepfcaakl
epfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
imaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
"!!GLSL#version 120

#ifdef VERTEX
uniform vec4 _ProjectionParams;
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHC;

uniform mat4 _Object2World;
uniform mat4 _World2Object;
uniform vec4 _MainTex_ST;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 v_2;
  v_2.x = _World2Object[0].x;
  v_2.y = _World2Object[1].x;
  v_2.z = _World2Object[2].x;
  v_2.w = _World2Object[3].x;
  vec4 v_3;
  v_3.x = _World2Object[0].y;
  v_3.y = _World2Object[1].y;
  v_3.z = _World2Object[2].y;
  v_3.w = _World2Object[3].y;
  vec4 v_4;
  v_4.x = _World2Object[0].z;
  v_4.y = _World2Object[1].z;
  v_4.z = _World2Object[2].z;
  v_4.w = _World2Object[3].z;
  vec3 tmpvar_5;
  tmpvar_5 = normalize(((
    (v_2.xyz * gl_Normal.x)
   + 
    (v_3.xyz * gl_Normal.y)
  ) + (v_4.xyz * gl_Normal.z)));
  vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  vec3 x2_7;
  vec3 x1_8;
  x1_8.x = dot (unity_SHAr, tmpvar_6);
  x1_8.y = dot (unity_SHAg, tmpvar_6);
  x1_8.z = dot (unity_SHAb, tmpvar_6);
  vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_5.xyzz * tmpvar_5.yzzx);
  x2_7.x = dot (unity_SHBr, tmpvar_9);
  x2_7.y = dot (unity_SHBg, tmpvar_9);
  x2_7.z = dot (unity_SHBb, tmpvar_9);
  vec4 o_10;
  vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_1 * 0.5);
  vec2 tmpvar_12;
  tmpvar_12.x = tmpvar_11.x;
  tmpvar_12.y = (tmpvar_11.y * _ProjectionParams.x);
  o_10.xy = (tmpvar_12 + tmpvar_11.w);
  o_10.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_5;
  xlv_TEXCOORD2 = (_Object2World * gl_Vertex).xyz;
  xlv_TEXCOORD3 = ((x2_7 + (unity_SHC.xyz * 
    ((tmpvar_5.x * tmpvar_5.x) - (tmpvar_5.y * tmpvar_5.y))
  )) + x1_8);
  xlv_TEXCOORD4 = o_10;
}


#endif
#ifdef FRAGMENT
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _LightColor0;
uniform vec4 _SpecColor;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _Color;
uniform float _Shininess;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD4;
void main ()
{
  vec4 c_1;
  vec3 tmpvar_2;
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  tmpvar_2 = (tmpvar_3.xyz * _Color.xyz);
  vec3 tmpvar_4;
  tmpvar_4 = (_LightColor0.xyz * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x);
  vec4 c_5;
  vec4 c_6;
  c_6.xyz = (((tmpvar_2 * tmpvar_4) * max (0.0, 
    dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)
  )) + ((tmpvar_4 * _SpecColor.xyz) * (
    pow (max (0.0, dot (xlv_TEXCOORD1, normalize(
      (_WorldSpaceLightPos0.xyz + normalize((_WorldSpaceCameraPos - xlv_TEXCOORD2)))
    ))), (_Shininess * 128.0))
   * tmpvar_3.w)));
  c_6.w = (tmpvar_3.w * _Color.w);
  c_5.w = c_6.w;
  c_5.xyz = (c_6.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  c_1.xyz = c_5.xyz;
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 4 [_Object2World] 3
Matrix 7 [_World2Object] 3
Matrix 0 [glstate_matrix_mvp]
Vector 19 [_MainTex_ST]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Vector 14 [unity_SHAb]
Vector 13 [unity_SHAg]
Vector 12 [unity_SHAr]
Vector 17 [unity_SHBb]
Vector 16 [unity_SHBg]
Vector 15 [unity_SHBr]
Vector 18 [unity_SHC]
"vs_2_0
def c20, 1, 0.5, 0, 0
dcl_position v0
dcl_normal v1
dcl_texcoord v2
mad oT0.xy, v2, c19, c19.zwzw
dp4 oT2.x, c4, v0
dp4 oT2.y, c5, v0
dp4 oT2.z, c6, v0
mul r0.xyz, v1.y, c8
mad r0.xyz, c7, v1.x, r0
mad r0.xyz, c9, v1.z, r0
nrm r1.xyz, r0
mul r0.x, r1.y, r1.y
mad r0.x, r1.x, r1.x, -r0.x
mul r2, r1.yzzx, r1.xyzz
dp4 r3.x, c15, r2
dp4 r3.y, c16, r2
dp4 r3.z, c17, r2
mad r0.xyz, c18, r0.x, r3
mov r1.w, c20.x
dp4 r2.x, c12, r1
dp4 r2.y, c13, r1
dp4 r2.z, c14, r1
mov oT1.xyz, r1
add oT3.xyz, r0, r2
dp4 r0.y, c1, v0
mul r1.x, r0.y, c10.x
mul r1.w, r1.x, c20.y
dp4 r0.x, c0, v0
dp4 r0.w, c3, v0
mul r1.xz, r0.xyww, c20.y
mad oT4.xy, r1.z, c11.zwzw, r1.xwzw
dp4 r0.z, c2, v0
mov oPos, r0
mov oT4.zw, r0

"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 192
Vector 176 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 144
Vector 80 [_ProjectionParams]
ConstBuffer "UnityLighting" 720
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
root12:aaaeaaaa
eefiecedlhndficbopdfnnkidnaijhoagnacmdodabaaaaaamaahaaaaadaaaaaa
cmaaaaaaceabaaaanmabaaaaejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahaiaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
nmafaaaaeaaaabaahhabaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaae
egiocaaaadaaaaaabdaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadpccabaaaafaaaaaagiaaaaac
afaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaf
pccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaaalaaaaaadiaaaaai
bcaabaaaabaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaabaaaaaaadiaaaaai
ccaabaaaabaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaabbaaaaaadiaaaaai
ecaabaaaabaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaabcaaaaaadiaaaaai
bcaabaaaacaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaabaaaaaaadiaaaaai
ccaabaaaacaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaabbaaaaaadiaaaaai
ecaabaaaacaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaabcaaaaaaaaaaaaah
hcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadiaaaaaibcaabaaa
acaaaaaackbabaaaacaaaaaackiacaaaadaaaaaabaaaaaaadiaaaaaiccaabaaa
acaaaaaackbabaaaacaaaaaackiacaaaadaaaaaabbaaaaaadiaaaaaiecaabaaa
acaaaaaackbabaaaacaaaaaackiacaaaadaaaaaabcaaaaaaaaaaaaahhcaabaaa
abaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaabaaaaaahicaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaa
abaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaa
dgaaaaafhccabaaaacaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaacaaaaaa
fgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaacaaaaaadcaaaaak
hcaabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaa
acaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegacbaaaacaaaaaadiaaaaahbcaabaaaacaaaaaabkaabaaaabaaaaaa
bkaabaaaabaaaaaadcaaaaakbcaabaaaacaaaaaaakaabaaaabaaaaaaakaabaaa
abaaaaaaakaabaiaebaaaaaaacaaaaaadiaaaaahpcaabaaaadaaaaaajgacbaaa
abaaaaaaegakbaaaabaaaaaabbaaaaaibcaabaaaaeaaaaaaegiocaaaacaaaaaa
cjaaaaaaegaobaaaadaaaaaabbaaaaaiccaabaaaaeaaaaaaegiocaaaacaaaaaa
ckaaaaaaegaobaaaadaaaaaabbaaaaaiecaabaaaaeaaaaaaegiocaaaacaaaaaa
claaaaaaegaobaaaadaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaa
cmaaaaaaagaabaaaacaaaaaaegacbaaaaeaaaaaadgaaaaaficaabaaaabaaaaaa
abeaaaaaaaaaiadpbbaaaaaibcaabaaaadaaaaaaegiocaaaacaaaaaacgaaaaaa
egaobaaaabaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaacaaaaaachaaaaaa
egaobaaaabaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaacaaaaaaciaaaaaa
egaobaaaabaaaaaaaaaaaaahhccabaaaaeaaaaaaegacbaaaacaaaaaaegacbaaa
adaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaa
afaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadp
aaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaafaaaaaakgaobaaaaaaaaaaa
aaaaaaahdccabaaaafaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLSL#version 120

#ifdef VERTEX
uniform vec4 unity_4LightPosX0;
uniform vec4 unity_4LightPosY0;
uniform vec4 unity_4LightPosZ0;
uniform vec4 unity_4LightAtten0;
uniform vec4 unity_LightColor[8];
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHC;

uniform mat4 _Object2World;
uniform mat4 _World2Object;
uniform vec4 _MainTex_ST;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = (_Object2World * gl_Vertex).xyz;
  vec4 v_2;
  v_2.x = _World2Object[0].x;
  v_2.y = _World2Object[1].x;
  v_2.z = _World2Object[2].x;
  v_2.w = _World2Object[3].x;
  vec4 v_3;
  v_3.x = _World2Object[0].y;
  v_3.y = _World2Object[1].y;
  v_3.z = _World2Object[2].y;
  v_3.w = _World2Object[3].y;
  vec4 v_4;
  v_4.x = _World2Object[0].z;
  v_4.y = _World2Object[1].z;
  v_4.z = _World2Object[2].z;
  v_4.w = _World2Object[3].z;
  vec3 tmpvar_5;
  tmpvar_5 = normalize(((
    (v_2.xyz * gl_Normal.x)
   + 
    (v_3.xyz * gl_Normal.y)
  ) + (v_4.xyz * gl_Normal.z)));
  vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  vec3 x2_7;
  vec3 x1_8;
  x1_8.x = dot (unity_SHAr, tmpvar_6);
  x1_8.y = dot (unity_SHAg, tmpvar_6);
  x1_8.z = dot (unity_SHAb, tmpvar_6);
  vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_5.xyzz * tmpvar_5.yzzx);
  x2_7.x = dot (unity_SHBr, tmpvar_9);
  x2_7.y = dot (unity_SHBg, tmpvar_9);
  x2_7.z = dot (unity_SHBb, tmpvar_9);
  vec3 col_10;
  vec4 ndotl_11;
  vec4 lengthSq_12;
  vec4 tmpvar_13;
  tmpvar_13 = (unity_4LightPosX0 - tmpvar_1.x);
  vec4 tmpvar_14;
  tmpvar_14 = (unity_4LightPosY0 - tmpvar_1.y);
  vec4 tmpvar_15;
  tmpvar_15 = (unity_4LightPosZ0 - tmpvar_1.z);
  lengthSq_12 = (tmpvar_13 * tmpvar_13);
  lengthSq_12 = (lengthSq_12 + (tmpvar_14 * tmpvar_14));
  lengthSq_12 = (lengthSq_12 + (tmpvar_15 * tmpvar_15));
  ndotl_11 = (tmpvar_13 * tmpvar_5.x);
  ndotl_11 = (ndotl_11 + (tmpvar_14 * tmpvar_5.y));
  ndotl_11 = (ndotl_11 + (tmpvar_15 * tmpvar_5.z));
  vec4 tmpvar_16;
  tmpvar_16 = max (vec4(0.0, 0.0, 0.0, 0.0), (ndotl_11 * inversesqrt(lengthSq_12)));
  ndotl_11 = tmpvar_16;
  vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * (1.0/((1.0 + 
    (lengthSq_12 * unity_4LightAtten0)
  ))));
  col_10 = (unity_LightColor[0].xyz * tmpvar_17.x);
  col_10 = (col_10 + (unity_LightColor[1].xyz * tmpvar_17.y));
  col_10 = (col_10 + (unity_LightColor[2].xyz * tmpvar_17.z));
  col_10 = (col_10 + (unity_LightColor[3].xyz * tmpvar_17.w));
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_5;
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = (((x2_7 + 
    (unity_SHC.xyz * ((tmpvar_5.x * tmpvar_5.x) - (tmpvar_5.y * tmpvar_5.y)))
  ) + x1_8) + col_10);
}


#endif
#ifdef FRAGMENT
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _LightColor0;
uniform vec4 _SpecColor;
uniform sampler2D _MainTex;
uniform vec4 _Color;
uniform float _Shininess;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
void main ()
{
  vec4 c_1;
  vec3 tmpvar_2;
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  tmpvar_2 = (tmpvar_3.xyz * _Color.xyz);
  vec4 c_4;
  vec4 c_5;
  c_5.xyz = (((tmpvar_2 * _LightColor0.xyz) * max (0.0, 
    dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)
  )) + ((_LightColor0.xyz * _SpecColor.xyz) * (
    pow (max (0.0, dot (xlv_TEXCOORD1, normalize(
      (_WorldSpaceLightPos0.xyz + normalize((_WorldSpaceCameraPos - xlv_TEXCOORD2)))
    ))), (_Shininess * 128.0))
   * tmpvar_3.w)));
  c_5.w = (tmpvar_3.w * _Color.w);
  c_4.w = c_5.w;
  c_4.xyz = (c_5.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  c_1.xyz = c_4.xyz;
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 8 [_Object2World] 3
Matrix 11 [_World2Object] 3
Matrix 4 [glstate_matrix_mvp]
Vector 25 [_MainTex_ST]
Vector 17 [unity_4LightAtten0]
Vector 14 [unity_4LightPosX0]
Vector 15 [unity_4LightPosY0]
Vector 16 [unity_4LightPosZ0]
Vector 0 [unity_LightColor0]
Vector 1 [unity_LightColor1]
Vector 2 [unity_LightColor2]
Vector 3 [unity_LightColor3]
Vector 20 [unity_SHAb]
Vector 19 [unity_SHAg]
Vector 18 [unity_SHAr]
Vector 23 [unity_SHBb]
Vector 22 [unity_SHBg]
Vector 21 [unity_SHBr]
Vector 24 [unity_SHC]
"vs_2_0
def c26, 1, 0, 0, 0
dcl_position v0
dcl_normal v1
dcl_texcoord v2
dp4 oPos.x, c4, v0
dp4 oPos.y, c5, v0
dp4 oPos.z, c6, v0
dp4 oPos.w, c7, v0
mad oT0.xy, v2, c25, c25.zwzw
mul r0.xyz, v1.y, c12
mad r0.xyz, c11, v1.x, r0
mad r0.xyz, c13, v1.z, r0
nrm r1.xyz, r0
mul r0.x, r1.y, r1.y
mad r0.x, r1.x, r1.x, -r0.x
mul r2, r1.yzzx, r1.xyzz
dp4 r3.x, c21, r2
dp4 r3.y, c22, r2
dp4 r3.z, c23, r2
mad r0.xyz, c24, r0.x, r3
mov r1.w, c26.x
dp4 r2.x, c18, r1
dp4 r2.y, c19, r1
dp4 r2.z, c20, r1
add r0.xyz, r0, r2
dp4 r2.y, c9, v0
add r3, -r2.y, c15
mul r4, r1.y, r3
mul r3, r3, r3
dp4 r2.x, c8, v0
add r5, -r2.x, c14
mad r4, r5, r1.x, r4
mad r3, r5, r5, r3
dp4 r2.z, c10, v0
add r5, -r2.z, c16
mov oT2.xyz, r2
mad r2, r5, r1.z, r4
mov oT1.xyz, r1
mad r1, r5, r5, r3
rsq r3.x, r1.x
rsq r3.y, r1.y
rsq r3.z, r1.z
rsq r3.w, r1.w
mov r4.x, c26.x
mad r1, r1, c17, r4.x
mul r2, r2, r3
max r2, r2, c26.y
rcp r3.x, r1.x
rcp r3.y, r1.y
rcp r3.z, r1.z
rcp r3.w, r1.w
mul r1, r2, r3
mul r2.xyz, r1.y, c1
mad r2.xyz, c0, r1.x, r2
mad r1.xyz, c2, r1.z, r2
mad r1.xyz, c3, r1.w, r1
add oT3.xyz, r0, r1

"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 192
Vector 176 [_MainTex_ST]
ConstBuffer "UnityLighting" 720
Vector 32 [unity_4LightPosX0]
Vector 48 [unity_4LightPosY0]
Vector 64 [unity_4LightPosZ0]
Vector 80 [unity_4LightAtten0]
Vector 96 [unity_LightColor0]
Vector 112 [unity_LightColor1]
Vector 128 [unity_LightColor2]
Vector 144 [unity_LightColor3]
Vector 160 [unity_LightColor4]
Vector 176 [unity_LightColor5]
Vector 192 [unity_LightColor6]
Vector 208 [unity_LightColor7]
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
root12:aaadaaaa
eefiecedmcafebnfdahffilkippfemammonknpfeabaaaaaammajaaaaadaaaaaa
cmaaaaaaceabaaaameabaaaaejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaimaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaaimaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcaaaiaaaaeaaaabaaaaacaaaafjaaaaaeegiocaaaaaaaaaaa
amaaaaaafjaaaaaeegiocaaaabaaaaaacnaaaaaafjaaaaaeegiocaaaacaaaaaa
bdaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagiaaaaacagaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaalaaaaaaogikcaaaaaaaaaaaalaaaaaadiaaaaaibcaabaaaaaaaaaaa
akbabaaaacaaaaaaakiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaaaaaaaaaa
akbabaaaacaaaaaaakiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaaaaaaaaaa
akbabaaaacaaaaaaakiacaaaacaaaaaabcaaaaaadiaaaaaibcaabaaaabaaaaaa
bkbabaaaacaaaaaabkiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaa
bkbabaaaacaaaaaabkiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaa
bkbabaaaacaaaaaabkiacaaaacaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaa
acaaaaaackiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaa
acaaaaaackiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaa
acaaaaaackiacaaaacaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaafhccabaaa
acaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
abaaaaaadgaaaaafhccabaaaadaaaaaaegacbaaaabaaaaaadiaaaaahicaabaaa
abaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaakicaabaaaabaaaaaa
akaabaaaaaaaaaaaakaabaaaaaaaaaaadkaabaiaebaaaaaaabaaaaaadiaaaaah
pcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaa
adaaaaaaegiocaaaabaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaa
adaaaaaaegiocaaaabaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaa
adaaaaaaegiocaaaabaaaaaaclaaaaaaegaobaaaacaaaaaadcaaaaakhcaabaaa
acaaaaaaegiccaaaabaaaaaacmaaaaaapgapbaaaabaaaaaaegacbaaaadaaaaaa
dgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaadaaaaaa
egiocaaaabaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaaadaaaaaa
egiocaaaabaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaaadaaaaaa
egiocaaaabaaaaaaciaaaaaaegaobaaaaaaaaaaaaaaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaaegacbaaaadaaaaaaaaaaaaajpcaabaaaadaaaaaafgafbaia
ebaaaaaaabaaaaaaegiocaaaabaaaaaaadaaaaaadiaaaaahpcaabaaaaeaaaaaa
fgafbaaaaaaaaaaaegaobaaaadaaaaaadiaaaaahpcaabaaaadaaaaaaegaobaaa
adaaaaaaegaobaaaadaaaaaaaaaaaaajpcaabaaaafaaaaaaagaabaiaebaaaaaa
abaaaaaaegiocaaaabaaaaaaacaaaaaaaaaaaaajpcaabaaaabaaaaaakgakbaia
ebaaaaaaabaaaaaaegiocaaaabaaaaaaaeaaaaaadcaaaaajpcaabaaaaeaaaaaa
egaobaaaafaaaaaaagaabaaaaaaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaa
aaaaaaaaegaobaaaabaaaaaakgakbaaaaaaaaaaaegaobaaaaeaaaaaadcaaaaaj
pcaabaaaadaaaaaaegaobaaaafaaaaaaegaobaaaafaaaaaaegaobaaaadaaaaaa
dcaaaaajpcaabaaaabaaaaaaegaobaaaabaaaaaaegaobaaaabaaaaaaegaobaaa
adaaaaaaeeaaaaafpcaabaaaadaaaaaaegaobaaaabaaaaaadcaaaaanpcaabaaa
abaaaaaaegaobaaaabaaaaaaegiocaaaabaaaaaaafaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpaoaaaaakpcaabaaaabaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpegaobaaaabaaaaaadiaaaaahpcaabaaaaaaaaaaa
egaobaaaaaaaaaaaegaobaaaadaaaaaadeaaaaakpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadiaaaaahpcaabaaa
aaaaaaaaegaobaaaabaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiccaaaabaaaaaaahaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaabaaaaaaagaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaabaaaaaaaiaaaaaakgakbaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaajaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaaaaaaaaahhccabaaaaeaaaaaaegacbaaaaaaaaaaa
egacbaaaacaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 192
Vector 176 [_MainTex_ST]
ConstBuffer "UnityLighting" 720
Vector 32 [unity_4LightPosX0]
Vector 48 [unity_4LightPosY0]
Vector 64 [unity_4LightPosZ0]
Vector 80 [unity_4LightAtten0]
Vector 96 [unity_LightColor0]
Vector 112 [unity_LightColor1]
Vector 128 [unity_LightColor2]
Vector 144 [unity_LightColor3]
Vector 160 [unity_LightColor4]
Vector 176 [unity_LightColor5]
Vector 192 [unity_LightColor6]
Vector 208 [unity_LightColor7]
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityPerDraw" 2
"vs_4_0_level_9_1
root12:aaadaaaa
eefiecedgeanciieifejiedjbjcdaabdhbneplogabaaaaaajaaoaaaaaeaaaaaa
daaaaaaapaaeaaaapiamaaaapaanaaaaebgpgodjliaeaaaaliaeaaaaaaacpopp
feaeaaaageaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaabaagaaaaaaaalaa
abaaabaaaaaaaaaaabaaacaaaiaaacaaaaaaaaaaabaacgaaahaaakaaaaaaaaaa
acaaaaaaaeaabbaaaaaaaaaaacaaamaaahaabfaaaaaaaaaaaaaaaaaaaaacpopp
fbaaaaafbmaaapkaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacafaaaaia
aaaaapjabpaaaaacafaaaciaacaaapjabpaaaaacafaaadiaadaaapjaaeaaaaae
aaaaadoaadaaoejaabaaoekaabaaookaafaaaaadaaaaabiaacaaaajabjaaaaka
afaaaaadaaaaaciaacaaaajabkaaaakaafaaaaadaaaaaeiaacaaaajablaaaaka
afaaaaadabaaabiaacaaffjabjaaffkaafaaaaadabaaaciaacaaffjabkaaffka
afaaaaadabaaaeiaacaaffjablaaffkaacaaaaadaaaaahiaaaaaoeiaabaaoeia
afaaaaadabaaabiaacaakkjabjaakkkaafaaaaadabaaaciaacaakkjabkaakkka
afaaaaadabaaaeiaacaakkjablaakkkaacaaaaadaaaaahiaaaaaoeiaabaaoeia
ceaaaaacabaaahiaaaaaoeiaafaaaaadaaaaabiaabaaffiaabaaffiaaeaaaaae
aaaaabiaabaaaaiaabaaaaiaaaaaaaibafaaaaadacaaapiaabaacjiaabaakeia
ajaaaaadadaaabiaanaaoekaacaaoeiaajaaaaadadaaaciaaoaaoekaacaaoeia
ajaaaaadadaaaeiaapaaoekaacaaoeiaaeaaaaaeaaaaahiabaaaoekaaaaaaaia
adaaoeiaabaaaaacabaaaiiabmaaaakaajaaaaadacaaabiaakaaoekaabaaoeia
ajaaaaadacaaaciaalaaoekaabaaoeiaajaaaaadacaaaeiaamaaoekaabaaoeia
acaaaaadaaaaahiaaaaaoeiaacaaoeiaafaaaaadacaaahiaaaaaffjabgaaoeka
aeaaaaaeacaaahiabfaaoekaaaaaaajaacaaoeiaaeaaaaaeacaaahiabhaaoeka
aaaakkjaacaaoeiaaeaaaaaeacaaahiabiaaoekaaaaappjaacaaoeiaacaaaaad
adaaapiaacaaffibadaaoekaafaaaaadaeaaapiaabaaffiaadaaoeiaafaaaaad
adaaapiaadaaoeiaadaaoeiaacaaaaadafaaapiaacaaaaibacaaoekaaeaaaaae
aeaaapiaafaaoeiaabaaaaiaaeaaoeiaaeaaaaaeadaaapiaafaaoeiaafaaoeia
adaaoeiaacaaaaadafaaapiaacaakkibaeaaoekaabaaaaacacaaahoaacaaoeia
aeaaaaaeacaaapiaafaaoeiaabaakkiaaeaaoeiaabaaaaacabaaahoaabaaoeia
aeaaaaaeabaaapiaafaaoeiaafaaoeiaadaaoeiaahaaaaacadaaabiaabaaaaia
ahaaaaacadaaaciaabaaffiaahaaaaacadaaaeiaabaakkiaahaaaaacadaaaiia
abaappiaabaaaaacaeaaabiabmaaaakaaeaaaaaeabaaapiaabaaoeiaafaaoeka
aeaaaaiaafaaaaadacaaapiaacaaoeiaadaaoeiaalaaaaadacaaapiaacaaoeia
bmaaffkaagaaaaacadaaabiaabaaaaiaagaaaaacadaaaciaabaaffiaagaaaaac
adaaaeiaabaakkiaagaaaaacadaaaiiaabaappiaafaaaaadabaaapiaacaaoeia
adaaoeiaafaaaaadacaaahiaabaaffiaahaaoekaaeaaaaaeacaaahiaagaaoeka
abaaaaiaacaaoeiaaeaaaaaeabaaahiaaiaaoekaabaakkiaacaaoeiaaeaaaaae
abaaahiaajaaoekaabaappiaabaaoeiaacaaaaadadaaahoaaaaaoeiaabaaoeia
afaaaaadaaaaapiaaaaaffjabcaaoekaaeaaaaaeaaaaapiabbaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaapiabdaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapia
beaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaaammaaaaaoeiappppaaaafdeieefcaaaiaaaaeaaaabaaaaacaaaa
fjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaaeegiocaaaabaaaaaacnaaaaaa
fjaaaaaeegiocaaaacaaaaaabdaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
hcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
hccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagiaaaaacagaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaaalaaaaaa
diaaaaaibcaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaacaaaaaabaaaaaaa
diaaaaaiccaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaacaaaaaabbaaaaaa
diaaaaaiecaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaacaaaaaabcaaaaaa
diaaaaaibcaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaacaaaaaabaaaaaaa
diaaaaaiccaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaacaaaaaabbaaaaaa
diaaaaaiecaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaacaaaaaabcaaaaaa
aaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaai
bcaabaaaabaaaaaackbabaaaacaaaaaackiacaaaacaaaaaabaaaaaaadiaaaaai
ccaabaaaabaaaaaackbabaaaacaaaaaackiacaaaacaaaaaabbaaaaaadiaaaaai
ecaabaaaabaaaaaackbabaaaacaaaaaackiacaaaacaaaaaabcaaaaaaaaaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaadgaaaaafhccabaaaacaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaa
abaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaafhccabaaaadaaaaaaegacbaaa
abaaaaaadiaaaaahicaabaaaabaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaa
dcaaaaakicaabaaaabaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaadkaabaia
ebaaaaaaabaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaa
aaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaabaaaaaacjaaaaaaegaobaaa
acaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaabaaaaaackaaaaaaegaobaaa
acaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaabaaaaaaclaaaaaaegaobaaa
acaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaabaaaaaacmaaaaaapgapbaaa
abaaaaaaegacbaaaadaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadp
bbaaaaaibcaabaaaadaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaaaaaaaaaa
bbaaaaaiccaabaaaadaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaaaaaaaaaa
bbaaaaaiecaabaaaadaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaaaaaaaaaa
aaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaaaaaaaaaj
pcaabaaaadaaaaaafgafbaiaebaaaaaaabaaaaaaegiocaaaabaaaaaaadaaaaaa
diaaaaahpcaabaaaaeaaaaaafgafbaaaaaaaaaaaegaobaaaadaaaaaadiaaaaah
pcaabaaaadaaaaaaegaobaaaadaaaaaaegaobaaaadaaaaaaaaaaaaajpcaabaaa
afaaaaaaagaabaiaebaaaaaaabaaaaaaegiocaaaabaaaaaaacaaaaaaaaaaaaaj
pcaabaaaabaaaaaakgakbaiaebaaaaaaabaaaaaaegiocaaaabaaaaaaaeaaaaaa
dcaaaaajpcaabaaaaeaaaaaaegaobaaaafaaaaaaagaabaaaaaaaaaaaegaobaaa
aeaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaabaaaaaakgakbaaaaaaaaaaa
egaobaaaaeaaaaaadcaaaaajpcaabaaaadaaaaaaegaobaaaafaaaaaaegaobaaa
afaaaaaaegaobaaaadaaaaaadcaaaaajpcaabaaaabaaaaaaegaobaaaabaaaaaa
egaobaaaabaaaaaaegaobaaaadaaaaaaeeaaaaafpcaabaaaadaaaaaaegaobaaa
abaaaaaadcaaaaanpcaabaaaabaaaaaaegaobaaaabaaaaaaegiocaaaabaaaaaa
afaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpaoaaaaakpcaabaaa
abaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpegaobaaaabaaaaaa
diaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaadaaaaaadeaaaaak
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaaabaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaabaaaaaaahaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaabaaaaaaagaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaaiaaaaaa
kgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
abaaaaaaajaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaahhccabaaa
aeaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaadoaaaaabejfdeheopaaaaaaa
aiaaaaaaaiaaaaaamiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaa
nbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaacaaaaaaahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
adaaaaaaapadaaaaoaaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaa
oaaaaaaaacaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaa
aaaaaaaaadaaaaaaagaaaaaaapaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
ahaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaa
feeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaaaiaaaaaa
iaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaa
acaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaa
imaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklkl"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLSL#version 120

#ifdef VERTEX
uniform vec4 _ProjectionParams;
uniform vec4 unity_4LightPosX0;
uniform vec4 unity_4LightPosY0;
uniform vec4 unity_4LightPosZ0;
uniform vec4 unity_4LightAtten0;
uniform vec4 unity_LightColor[8];
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHC;

uniform mat4 _Object2World;
uniform mat4 _World2Object;
uniform vec4 _MainTex_ST;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * gl_Vertex).xyz;
  vec4 v_3;
  v_3.x = _World2Object[0].x;
  v_3.y = _World2Object[1].x;
  v_3.z = _World2Object[2].x;
  v_3.w = _World2Object[3].x;
  vec4 v_4;
  v_4.x = _World2Object[0].y;
  v_4.y = _World2Object[1].y;
  v_4.z = _World2Object[2].y;
  v_4.w = _World2Object[3].y;
  vec4 v_5;
  v_5.x = _World2Object[0].z;
  v_5.y = _World2Object[1].z;
  v_5.z = _World2Object[2].z;
  v_5.w = _World2Object[3].z;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(((
    (v_3.xyz * gl_Normal.x)
   + 
    (v_4.xyz * gl_Normal.y)
  ) + (v_5.xyz * gl_Normal.z)));
  vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = tmpvar_6;
  vec3 x2_8;
  vec3 x1_9;
  x1_9.x = dot (unity_SHAr, tmpvar_7);
  x1_9.y = dot (unity_SHAg, tmpvar_7);
  x1_9.z = dot (unity_SHAb, tmpvar_7);
  vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_6.xyzz * tmpvar_6.yzzx);
  x2_8.x = dot (unity_SHBr, tmpvar_10);
  x2_8.y = dot (unity_SHBg, tmpvar_10);
  x2_8.z = dot (unity_SHBb, tmpvar_10);
  vec3 col_11;
  vec4 ndotl_12;
  vec4 lengthSq_13;
  vec4 tmpvar_14;
  tmpvar_14 = (unity_4LightPosX0 - tmpvar_2.x);
  vec4 tmpvar_15;
  tmpvar_15 = (unity_4LightPosY0 - tmpvar_2.y);
  vec4 tmpvar_16;
  tmpvar_16 = (unity_4LightPosZ0 - tmpvar_2.z);
  lengthSq_13 = (tmpvar_14 * tmpvar_14);
  lengthSq_13 = (lengthSq_13 + (tmpvar_15 * tmpvar_15));
  lengthSq_13 = (lengthSq_13 + (tmpvar_16 * tmpvar_16));
  ndotl_12 = (tmpvar_14 * tmpvar_6.x);
  ndotl_12 = (ndotl_12 + (tmpvar_15 * tmpvar_6.y));
  ndotl_12 = (ndotl_12 + (tmpvar_16 * tmpvar_6.z));
  vec4 tmpvar_17;
  tmpvar_17 = max (vec4(0.0, 0.0, 0.0, 0.0), (ndotl_12 * inversesqrt(lengthSq_13)));
  ndotl_12 = tmpvar_17;
  vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * (1.0/((1.0 + 
    (lengthSq_13 * unity_4LightAtten0)
  ))));
  col_11 = (unity_LightColor[0].xyz * tmpvar_18.x);
  col_11 = (col_11 + (unity_LightColor[1].xyz * tmpvar_18.y));
  col_11 = (col_11 + (unity_LightColor[2].xyz * tmpvar_18.z));
  col_11 = (col_11 + (unity_LightColor[3].xyz * tmpvar_18.w));
  vec4 o_19;
  vec4 tmpvar_20;
  tmpvar_20 = (tmpvar_1 * 0.5);
  vec2 tmpvar_21;
  tmpvar_21.x = tmpvar_20.x;
  tmpvar_21.y = (tmpvar_20.y * _ProjectionParams.x);
  o_19.xy = (tmpvar_21 + tmpvar_20.w);
  o_19.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_6;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (((x2_8 + 
    (unity_SHC.xyz * ((tmpvar_6.x * tmpvar_6.x) - (tmpvar_6.y * tmpvar_6.y)))
  ) + x1_9) + col_11);
  xlv_TEXCOORD4 = o_19;
}


#endif
#ifdef FRAGMENT
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _LightColor0;
uniform vec4 _SpecColor;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _Color;
uniform float _Shininess;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD4;
void main ()
{
  vec4 c_1;
  vec3 tmpvar_2;
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  tmpvar_2 = (tmpvar_3.xyz * _Color.xyz);
  vec3 tmpvar_4;
  tmpvar_4 = (_LightColor0.xyz * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x);
  vec4 c_5;
  vec4 c_6;
  c_6.xyz = (((tmpvar_2 * tmpvar_4) * max (0.0, 
    dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)
  )) + ((tmpvar_4 * _SpecColor.xyz) * (
    pow (max (0.0, dot (xlv_TEXCOORD1, normalize(
      (_WorldSpaceLightPos0.xyz + normalize((_WorldSpaceCameraPos - xlv_TEXCOORD2)))
    ))), (_Shininess * 128.0))
   * tmpvar_3.w)));
  c_6.w = (tmpvar_3.w * _Color.w);
  c_5.w = c_6.w;
  c_5.xyz = (c_6.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  c_1.xyz = c_5.xyz;
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 8 [_Object2World] 3
Matrix 11 [_World2Object] 3
Matrix 4 [glstate_matrix_mvp]
Vector 27 [_MainTex_ST]
Vector 14 [_ProjectionParams]
Vector 15 [_ScreenParams]
Vector 19 [unity_4LightAtten0]
Vector 16 [unity_4LightPosX0]
Vector 17 [unity_4LightPosY0]
Vector 18 [unity_4LightPosZ0]
Vector 0 [unity_LightColor0]
Vector 1 [unity_LightColor1]
Vector 2 [unity_LightColor2]
Vector 3 [unity_LightColor3]
Vector 22 [unity_SHAb]
Vector 21 [unity_SHAg]
Vector 20 [unity_SHAr]
Vector 25 [unity_SHBb]
Vector 24 [unity_SHBg]
Vector 23 [unity_SHBr]
Vector 26 [unity_SHC]
"vs_2_0
def c28, 1, 0, 0.5, 0
dcl_position v0
dcl_normal v1
dcl_texcoord v2
mad oT0.xy, v2, c27, c27.zwzw
mul r0.xyz, v1.y, c12
mad r0.xyz, c11, v1.x, r0
mad r0.xyz, c13, v1.z, r0
nrm r1.xyz, r0
mul r0.x, r1.y, r1.y
mad r0.x, r1.x, r1.x, -r0.x
mul r2, r1.yzzx, r1.xyzz
dp4 r3.x, c23, r2
dp4 r3.y, c24, r2
dp4 r3.z, c25, r2
mad r0.xyz, c26, r0.x, r3
mov r1.w, c28.x
dp4 r2.x, c20, r1
dp4 r2.y, c21, r1
dp4 r2.z, c22, r1
add r0.xyz, r0, r2
dp4 r2.y, c9, v0
add r3, -r2.y, c17
mul r4, r1.y, r3
mul r3, r3, r3
dp4 r2.x, c8, v0
add r5, -r2.x, c16
mad r4, r5, r1.x, r4
mad r3, r5, r5, r3
dp4 r2.z, c10, v0
add r5, -r2.z, c18
mov oT2.xyz, r2
mad r2, r5, r1.z, r4
mov oT1.xyz, r1
mad r1, r5, r5, r3
rsq r3.x, r1.x
rsq r3.y, r1.y
rsq r3.z, r1.z
rsq r3.w, r1.w
mov r4.x, c28.x
mad r1, r1, c19, r4.x
mul r2, r2, r3
max r2, r2, c28.y
rcp r3.x, r1.x
rcp r3.y, r1.y
rcp r3.z, r1.z
rcp r3.w, r1.w
mul r1, r2, r3
mul r2.xyz, r1.y, c1
mad r2.xyz, c0, r1.x, r2
mad r1.xyz, c2, r1.z, r2
mad r1.xyz, c3, r1.w, r1
add oT3.xyz, r0, r1
dp4 r0.y, c5, v0
mul r1.x, r0.y, c14.x
mul r1.w, r1.x, c28.z
dp4 r0.x, c4, v0
dp4 r0.w, c7, v0
mul r1.xz, r0.xyww, c28.z
mad oT4.xy, r1.z, c15.zwzw, r1.xwzw
dp4 r0.z, c6, v0
mov oPos, r0
mov oT4.zw, r0

"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 192
Vector 176 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 144
Vector 80 [_ProjectionParams]
ConstBuffer "UnityLighting" 720
Vector 32 [unity_4LightPosX0]
Vector 48 [unity_4LightPosY0]
Vector 64 [unity_4LightPosZ0]
Vector 80 [unity_4LightAtten0]
Vector 96 [unity_LightColor0]
Vector 112 [unity_LightColor1]
Vector 128 [unity_LightColor2]
Vector 144 [unity_LightColor3]
Vector 160 [unity_LightColor4]
Vector 176 [unity_LightColor5]
Vector 192 [unity_LightColor6]
Vector 208 [unity_LightColor7]
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
root12:aaaeaaaa
eefiecedkicpldpfkldihjclfgjbldkidoobckhpabaaaaaaimakaaaaadaaaaaa
cmaaaaaaceabaaaanmabaaaaejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahaiaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
kiaiaaaaeaaaabaackacaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaae
egiocaaaadaaaaaabdaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadpccabaaaafaaaaaagiaaaaac
ahaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaf
pccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaaalaaaaaadiaaaaai
bcaabaaaabaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaabaaaaaaadiaaaaai
ccaabaaaabaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaabbaaaaaadiaaaaai
ecaabaaaabaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaabcaaaaaadiaaaaai
bcaabaaaacaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaabaaaaaaadiaaaaai
ccaabaaaacaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaabbaaaaaadiaaaaai
ecaabaaaacaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaabcaaaaaaaaaaaaah
hcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadiaaaaaibcaabaaa
acaaaaaackbabaaaacaaaaaackiacaaaadaaaaaabaaaaaaadiaaaaaiccaabaaa
acaaaaaackbabaaaacaaaaaackiacaaaadaaaaaabbaaaaaadiaaaaaiecaabaaa
acaaaaaackbabaaaacaaaaaackiacaaaadaaaaaabcaaaaaaaaaaaaahhcaabaaa
abaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaabaaaaaahicaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaa
abaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaa
dgaaaaafhccabaaaacaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaacaaaaaa
fgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaacaaaaaadcaaaaak
hcaabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaa
acaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegacbaaaacaaaaaadgaaaaafhccabaaaadaaaaaaegacbaaaacaaaaaa
diaaaaahicaabaaaacaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaadcaaaaak
icaabaaaacaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadkaabaiaebaaaaaa
acaaaaaadiaaaaahpcaabaaaadaaaaaajgacbaaaabaaaaaaegakbaaaabaaaaaa
bbaaaaaibcaabaaaaeaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaaadaaaaaa
bbaaaaaiccaabaaaaeaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaaadaaaaaa
bbaaaaaiecaabaaaaeaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaaadaaaaaa
dcaaaaakhcaabaaaadaaaaaaegiccaaaacaaaaaacmaaaaaapgapbaaaacaaaaaa
egacbaaaaeaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaaaaaaiadpbbaaaaai
bcaabaaaaeaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaaabaaaaaabbaaaaai
ccaabaaaaeaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaaabaaaaaabbaaaaai
ecaabaaaaeaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaaabaaaaaaaaaaaaah
hcaabaaaadaaaaaaegacbaaaadaaaaaaegacbaaaaeaaaaaaaaaaaaajpcaabaaa
aeaaaaaafgafbaiaebaaaaaaacaaaaaaegiocaaaacaaaaaaadaaaaaadiaaaaah
pcaabaaaafaaaaaafgafbaaaabaaaaaaegaobaaaaeaaaaaadiaaaaahpcaabaaa
aeaaaaaaegaobaaaaeaaaaaaegaobaaaaeaaaaaaaaaaaaajpcaabaaaagaaaaaa
agaabaiaebaaaaaaacaaaaaaegiocaaaacaaaaaaacaaaaaaaaaaaaajpcaabaaa
acaaaaaakgakbaiaebaaaaaaacaaaaaaegiocaaaacaaaaaaaeaaaaaadcaaaaaj
pcaabaaaafaaaaaaegaobaaaagaaaaaaagaabaaaabaaaaaaegaobaaaafaaaaaa
dcaaaaajpcaabaaaabaaaaaaegaobaaaacaaaaaakgakbaaaabaaaaaaegaobaaa
afaaaaaadcaaaaajpcaabaaaaeaaaaaaegaobaaaagaaaaaaegaobaaaagaaaaaa
egaobaaaaeaaaaaadcaaaaajpcaabaaaacaaaaaaegaobaaaacaaaaaaegaobaaa
acaaaaaaegaobaaaaeaaaaaaeeaaaaafpcaabaaaaeaaaaaaegaobaaaacaaaaaa
dcaaaaanpcaabaaaacaaaaaaegaobaaaacaaaaaaegiocaaaacaaaaaaafaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpaoaaaaakpcaabaaaacaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpegaobaaaacaaaaaadiaaaaah
pcaabaaaabaaaaaaegaobaaaabaaaaaaegaobaaaaeaaaaaadeaaaaakpcaabaaa
abaaaaaaegaobaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
diaaaaahpcaabaaaabaaaaaaegaobaaaacaaaaaaegaobaaaabaaaaaadiaaaaai
hcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaacaaaaaaahaaaaaadcaaaaak
hcaabaaaacaaaaaaegiccaaaacaaaaaaagaaaaaaagaabaaaabaaaaaaegacbaaa
acaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaaiaaaaaakgakbaaa
abaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaa
ajaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaaaaaaaaahhccabaaaaeaaaaaa
egacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaa
afaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaafaaaaaakgakbaaaabaaaaaa
mgaabaaaabaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 192
Vector 176 [_MainTex_ST]
ConstBuffer "UnityLighting" 720
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityShadows" 416
Matrix 128 [unity_World2Shadow0]
Matrix 192 [unity_World2Shadow1]
Matrix 256 [unity_World2Shadow2]
Matrix 320 [unity_World2Shadow3]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityShadows" 2
BindCB  "UnityPerDraw" 3
"vs_4_0_level_9_1
root12:aaaeaaaa
eefiecedoodhfbficggnbkagjemmnhbpkmjbnpggabaaaaaaaiamaaaaaeaaaaaa
daaaaaaanaadaaaafiakaaaafaalaaaaebgpgodjjiadaaaajiadaaaaaaacpopp
deadaaaageaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaabaagaaaaaaaalaa
abaaabaaaaaaaaaaabaacgaaahaaacaaaaaaaaaaacaaaiaaaeaaajaaaaaaaaaa
adaaaaaaaeaaanaaaaaaaaaaadaaamaaahaabbaaaaaaaaaaaaaaaaaaaaacpopp
fbaaaaafbiaaapkaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacafaaaaia
aaaaapjabpaaaaacafaaaciaacaaapjabpaaaaacafaaadiaadaaapjaaeaaaaae
aaaaadoaadaaoejaabaaoekaabaaookaafaaaaadaaaaahiaaaaaffjabcaaoeka
aeaaaaaeaaaaahiabbaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaahiabdaaoeka
aaaakkjaaaaaoeiaaeaaaaaeacaaahoabeaaoekaaaaappjaaaaaoeiaafaaaaad
aaaaabiaacaaaajabfaaaakaafaaaaadaaaaaciaacaaaajabgaaaakaafaaaaad
aaaaaeiaacaaaajabhaaaakaafaaaaadabaaabiaacaaffjabfaaffkaafaaaaad
abaaaciaacaaffjabgaaffkaafaaaaadabaaaeiaacaaffjabhaaffkaacaaaaad
aaaaahiaaaaaoeiaabaaoeiaafaaaaadabaaabiaacaakkjabfaakkkaafaaaaad
abaaaciaacaakkjabgaakkkaafaaaaadabaaaeiaacaakkjabhaakkkaacaaaaad
aaaaahiaaaaaoeiaabaaoeiaceaaaaacabaaahiaaaaaoeiaafaaaaadaaaaabia
abaaffiaabaaffiaaeaaaaaeaaaaabiaabaaaaiaabaaaaiaaaaaaaibafaaaaad
acaaapiaabaacjiaabaakeiaajaaaaadadaaabiaafaaoekaacaaoeiaajaaaaad
adaaaciaagaaoekaacaaoeiaajaaaaadadaaaeiaahaaoekaacaaoeiaaeaaaaae
aaaaahiaaiaaoekaaaaaaaiaadaaoeiaabaaaaacabaaaiiabiaaaakaajaaaaad
acaaabiaacaaoekaabaaoeiaajaaaaadacaaaciaadaaoekaabaaoeiaajaaaaad
acaaaeiaaeaaoekaabaaoeiaabaaaaacabaaahoaabaaoeiaacaaaaadadaaahoa
aaaaoeiaacaaoeiaafaaaaadaaaaapiaaaaaffjabcaaoekaaeaaaaaeaaaaapia
bbaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiabdaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiabeaaoekaaaaappjaaaaaoeiaafaaaaadabaaapiaaaaaffia
akaaoekaaeaaaaaeabaaapiaajaaoekaaaaaaaiaabaaoeiaaeaaaaaeabaaapia
alaaoekaaaaakkiaabaaoeiaaeaaaaaeaeaaapoaamaaoekaaaaappiaabaaoeia
afaaaaadaaaaapiaaaaaffjaaoaaoekaaeaaaaaeaaaaapiaanaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaapiaapaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapia
baaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaaammaaaaaoeiappppaaaafdeieefciaagaaaaeaaaabaakaabaaaa
fjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaaeegiocaaaabaaaaaacnaaaaaa
fjaaaaaeegiocaaaacaaaaaaamaaaaaafjaaaaaeegiocaaaadaaaaaabdaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaa
adaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaa
aeaaaaaagfaaaaadpccabaaaafaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaaalaaaaaadiaaaaai
bcaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaabaaaaaaadiaaaaai
ccaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaabbaaaaaadiaaaaai
ecaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaabcaaaaaadiaaaaai
bcaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaabaaaaaaadiaaaaai
ccaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaabbaaaaaadiaaaaai
ecaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaabcaaaaaaaaaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaadaaaaaabaaaaaaadiaaaaaiccaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaadaaaaaabbaaaaaadiaaaaaiecaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaadaaaaaabcaaaaaaaaaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
dgaaaaafhccabaaaacaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaa
fgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegacbaaaabaaaaaadiaaaaahbcaabaaaabaaaaaabkaabaaaaaaaaaaa
bkaabaaaaaaaaaaadcaaaaakbcaabaaaabaaaaaaakaabaaaaaaaaaaaakaabaaa
aaaaaaaaakaabaiaebaaaaaaabaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaa
aaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaabaaaaaa
cjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaabaaaaaa
ckaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaabaaaaaa
claaaaaaegaobaaaacaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaabaaaaaa
cmaaaaaaagaabaaaabaaaaaaegacbaaaadaaaaaadgaaaaaficaabaaaaaaaaaaa
abeaaaaaaaaaiadpbbaaaaaibcaabaaaacaaaaaaegiocaaaabaaaaaacgaaaaaa
egaobaaaaaaaaaaabbaaaaaiccaabaaaacaaaaaaegiocaaaabaaaaaachaaaaaa
egaobaaaaaaaaaaabbaaaaaiecaabaaaacaaaaaaegiocaaaabaaaaaaciaaaaaa
egaobaaaaaaaaaaaaaaaaaahhccabaaaaeaaaaaaegacbaaaabaaaaaaegacbaaa
acaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaa
anaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaamaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
pcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaacaaaaaaajaaaaaadcaaaaak
pcaabaaaabaaaaaaegiocaaaacaaaaaaaiaaaaaaagaabaaaaaaaaaaaegaobaaa
abaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaacaaaaaaakaaaaaakgakbaaa
aaaaaaaaegaobaaaabaaaaaadcaaaaakpccabaaaafaaaaaaegiocaaaacaaaaaa
alaaaaaapgapbaaaaaaaaaaaegaobaaaabaaaaaadoaaaaabejfdeheopaaaaaaa
aiaaaaaaaiaaaaaamiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaa
nbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaacaaaaaaahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
adaaaaaaapadaaaaoaaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaa
oaaaaaaaacaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaa
aaaaaaaaadaaaaaaagaaaaaaapaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
ahaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaa
feeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaaaiaaaaaa
jiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaa
acaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaa
keaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaaaeaaaaaa
aaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklkl"
}
SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 192
Vector 176 [_MainTex_ST]
ConstBuffer "UnityLighting" 720
Vector 32 [unity_4LightPosX0]
Vector 48 [unity_4LightPosY0]
Vector 64 [unity_4LightPosZ0]
Vector 80 [unity_4LightAtten0]
Vector 96 [unity_LightColor0]
Vector 112 [unity_LightColor1]
Vector 128 [unity_LightColor2]
Vector 144 [unity_LightColor3]
Vector 160 [unity_LightColor4]
Vector 176 [unity_LightColor5]
Vector 192 [unity_LightColor6]
Vector 208 [unity_LightColor7]
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityShadows" 416
Matrix 128 [unity_World2Shadow0]
Matrix 192 [unity_World2Shadow1]
Matrix 256 [unity_World2Shadow2]
Matrix 320 [unity_World2Shadow3]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityShadows" 2
BindCB  "UnityPerDraw" 3
"vs_4_0_level_9_1
root12:aaaeaaaa
eefiecedemkkhdnamoaknnmogkgkgliimlkmloelabaaaaaajibaaaaaaeaaaaaa
daaaaaaajeafaaaaoiaoaaaaoaapaaaaebgpgodjfmafaaaafmafaaaaaaacpopp
omaeaaaahaaaaaaaagaaceaaaaaagmaaaaaagmaaaaaaceaaabaagmaaaaaaalaa
abaaabaaaaaaaaaaabaaacaaaiaaacaaaaaaaaaaabaacgaaahaaakaaaaaaaaaa
acaaaiaaaeaabbaaaaaaaaaaadaaaaaaaeaabfaaaaaaaaaaadaaamaaahaabjaa
aaaaaaaaaaaaaaaaaaacpoppfbaaaaafcaaaapkaaaaaiadpaaaaaaaaaaaaaaaa
aaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaciaacaaapjabpaaaaac
afaaadiaadaaapjaaeaaaaaeaaaaadoaadaaoejaabaaoekaabaaookaafaaaaad
aaaaabiaacaaaajabnaaaakaafaaaaadaaaaaciaacaaaajaboaaaakaafaaaaad
aaaaaeiaacaaaajabpaaaakaafaaaaadabaaabiaacaaffjabnaaffkaafaaaaad
abaaaciaacaaffjaboaaffkaafaaaaadabaaaeiaacaaffjabpaaffkaacaaaaad
aaaaahiaaaaaoeiaabaaoeiaafaaaaadabaaabiaacaakkjabnaakkkaafaaaaad
abaaaciaacaakkjaboaakkkaafaaaaadabaaaeiaacaakkjabpaakkkaacaaaaad
aaaaahiaaaaaoeiaabaaoeiaceaaaaacabaaahiaaaaaoeiaafaaaaadaaaaabia
abaaffiaabaaffiaaeaaaaaeaaaaabiaabaaaaiaabaaaaiaaaaaaaibafaaaaad
acaaapiaabaacjiaabaakeiaajaaaaadadaaabiaanaaoekaacaaoeiaajaaaaad
adaaaciaaoaaoekaacaaoeiaajaaaaadadaaaeiaapaaoekaacaaoeiaaeaaaaae
aaaaahiabaaaoekaaaaaaaiaadaaoeiaabaaaaacabaaaiiacaaaaakaajaaaaad
acaaabiaakaaoekaabaaoeiaajaaaaadacaaaciaalaaoekaabaaoeiaajaaaaad
acaaaeiaamaaoekaabaaoeiaacaaaaadaaaaahiaaaaaoeiaacaaoeiaafaaaaad
acaaahiaaaaaffjabkaaoekaaeaaaaaeacaaahiabjaaoekaaaaaaajaacaaoeia
aeaaaaaeacaaahiablaaoekaaaaakkjaacaaoeiaaeaaaaaeacaaahiabmaaoeka
aaaappjaacaaoeiaacaaaaadadaaapiaacaaffibadaaoekaafaaaaadaeaaapia
abaaffiaadaaoeiaafaaaaadadaaapiaadaaoeiaadaaoeiaacaaaaadafaaapia
acaaaaibacaaoekaaeaaaaaeaeaaapiaafaaoeiaabaaaaiaaeaaoeiaaeaaaaae
adaaapiaafaaoeiaafaaoeiaadaaoeiaacaaaaadafaaapiaacaakkibaeaaoeka
abaaaaacacaaahoaacaaoeiaaeaaaaaeacaaapiaafaaoeiaabaakkiaaeaaoeia
abaaaaacabaaahoaabaaoeiaaeaaaaaeabaaapiaafaaoeiaafaaoeiaadaaoeia
ahaaaaacadaaabiaabaaaaiaahaaaaacadaaaciaabaaffiaahaaaaacadaaaeia
abaakkiaahaaaaacadaaaiiaabaappiaabaaaaacaeaaabiacaaaaakaaeaaaaae
abaaapiaabaaoeiaafaaoekaaeaaaaiaafaaaaadacaaapiaacaaoeiaadaaoeia
alaaaaadacaaapiaacaaoeiacaaaffkaagaaaaacadaaabiaabaaaaiaagaaaaac
adaaaciaabaaffiaagaaaaacadaaaeiaabaakkiaagaaaaacadaaaiiaabaappia
afaaaaadabaaapiaacaaoeiaadaaoeiaafaaaaadacaaahiaabaaffiaahaaoeka
aeaaaaaeacaaahiaagaaoekaabaaaaiaacaaoeiaaeaaaaaeabaaahiaaiaaoeka
abaakkiaacaaoeiaaeaaaaaeabaaahiaajaaoekaabaappiaabaaoeiaacaaaaad
adaaahoaaaaaoeiaabaaoeiaafaaaaadaaaaapiaaaaaffjabkaaoekaaeaaaaae
aaaaapiabjaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiablaaoekaaaaakkja
aaaaoeiaaeaaaaaeaaaaapiabmaaoekaaaaappjaaaaaoeiaafaaaaadabaaapia
aaaaffiabcaaoekaaeaaaaaeabaaapiabbaaoekaaaaaaaiaabaaoeiaaeaaaaae
abaaapiabdaaoekaaaaakkiaabaaoeiaaeaaaaaeaeaaapoabeaaoekaaaaappia
abaaoeiaafaaaaadaaaaapiaaaaaffjabgaaoekaaeaaaaaeaaaaapiabfaaoeka
aaaaaajaaaaaoeiaaeaaaaaeaaaaapiabhaaoekaaaaakkjaaaaaoeiaaeaaaaae
aaaaapiabiaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoeka
aaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefcemajaaaaeaaaabaa
fdacaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaaeegiocaaaabaaaaaa
cnaaaaaafjaaaaaeegiocaaaacaaaaaaamaaaaaafjaaaaaeegiocaaaadaaaaaa
bdaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadpccabaaaafaaaaaagiaaaaacagaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaaalaaaaaa
diaaaaaibcaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaabaaaaaaa
diaaaaaiccaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaabbaaaaaa
diaaaaaiecaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaabcaaaaaa
diaaaaaibcaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaabaaaaaaa
diaaaaaiccaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaabbaaaaaa
diaaaaaiecaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaabcaaaaaa
aaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaai
bcaabaaaabaaaaaackbabaaaacaaaaaackiacaaaadaaaaaabaaaaaaadiaaaaai
ccaabaaaabaaaaaackbabaaaacaaaaaackiacaaaadaaaaaabbaaaaaadiaaaaai
ecaabaaaabaaaaaackbabaaaacaaaaaackiacaaaadaaaaaabcaaaaaaaaaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaadgaaaaafhccabaaaacaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaa
abaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegacbaaaabaaaaaadgaaaaafhccabaaaadaaaaaaegacbaaa
abaaaaaadiaaaaahicaabaaaabaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaa
dcaaaaakicaabaaaabaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaadkaabaia
ebaaaaaaabaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaa
aaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaabaaaaaacjaaaaaaegaobaaa
acaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaabaaaaaackaaaaaaegaobaaa
acaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaabaaaaaaclaaaaaaegaobaaa
acaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaabaaaaaacmaaaaaapgapbaaa
abaaaaaaegacbaaaadaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadp
bbaaaaaibcaabaaaadaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaaaaaaaaaa
bbaaaaaiccaabaaaadaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaaaaaaaaaa
bbaaaaaiecaabaaaadaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaaaaaaaaaa
aaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaaaaaaaaaj
pcaabaaaadaaaaaafgafbaiaebaaaaaaabaaaaaaegiocaaaabaaaaaaadaaaaaa
diaaaaahpcaabaaaaeaaaaaafgafbaaaaaaaaaaaegaobaaaadaaaaaadiaaaaah
pcaabaaaadaaaaaaegaobaaaadaaaaaaegaobaaaadaaaaaaaaaaaaajpcaabaaa
afaaaaaaagaabaiaebaaaaaaabaaaaaaegiocaaaabaaaaaaacaaaaaaaaaaaaaj
pcaabaaaabaaaaaakgakbaiaebaaaaaaabaaaaaaegiocaaaabaaaaaaaeaaaaaa
dcaaaaajpcaabaaaaeaaaaaaegaobaaaafaaaaaaagaabaaaaaaaaaaaegaobaaa
aeaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaabaaaaaakgakbaaaaaaaaaaa
egaobaaaaeaaaaaadcaaaaajpcaabaaaadaaaaaaegaobaaaafaaaaaaegaobaaa
afaaaaaaegaobaaaadaaaaaadcaaaaajpcaabaaaabaaaaaaegaobaaaabaaaaaa
egaobaaaabaaaaaaegaobaaaadaaaaaaeeaaaaafpcaabaaaadaaaaaaegaobaaa
abaaaaaadcaaaaanpcaabaaaabaaaaaaegaobaaaabaaaaaaegiocaaaabaaaaaa
afaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpaoaaaaakpcaabaaa
abaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpegaobaaaabaaaaaa
diaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaadaaaaaadeaaaaak
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaaabaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaabaaaaaaahaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaabaaaaaaagaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaaiaaaaaa
kgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
abaaaaaaajaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaahhccabaaa
aeaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiocaaaacaaaaaaajaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaacaaaaaa
aiaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaa
egiocaaaacaaaaaaakaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaadcaaaaak
pccabaaaafaaaaaaegiocaaaacaaaaaaalaaaaaapgapbaaaaaaaaaaaegaobaaa
abaaaaaadoaaaaabejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaa
oaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaaabaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaaadaaaaaa
afaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaaapaaaaaa
ojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdejfeejepeo
aafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepemepfcaakl
epfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
keaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaahaiaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" }
"!!GLSL#version 120

#ifdef VERTEX
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHC;

uniform mat4 _Object2World;
uniform mat4 _World2Object;
uniform vec4 unity_FogParams;
uniform vec4 _MainTex_ST;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying float xlv_TEXCOORD5;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 v_2;
  v_2.x = _World2Object[0].x;
  v_2.y = _World2Object[1].x;
  v_2.z = _World2Object[2].x;
  v_2.w = _World2Object[3].x;
  vec4 v_3;
  v_3.x = _World2Object[0].y;
  v_3.y = _World2Object[1].y;
  v_3.z = _World2Object[2].y;
  v_3.w = _World2Object[3].y;
  vec4 v_4;
  v_4.x = _World2Object[0].z;
  v_4.y = _World2Object[1].z;
  v_4.z = _World2Object[2].z;
  v_4.w = _World2Object[3].z;
  vec3 tmpvar_5;
  tmpvar_5 = normalize(((
    (v_2.xyz * gl_Normal.x)
   + 
    (v_3.xyz * gl_Normal.y)
  ) + (v_4.xyz * gl_Normal.z)));
  vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  vec3 x2_7;
  vec3 x1_8;
  x1_8.x = dot (unity_SHAr, tmpvar_6);
  x1_8.y = dot (unity_SHAg, tmpvar_6);
  x1_8.z = dot (unity_SHAb, tmpvar_6);
  vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_5.xyzz * tmpvar_5.yzzx);
  x2_7.x = dot (unity_SHBr, tmpvar_9);
  x2_7.y = dot (unity_SHBg, tmpvar_9);
  x2_7.z = dot (unity_SHBb, tmpvar_9);
  float tmpvar_10;
  tmpvar_10 = (unity_FogParams.x * tmpvar_1.z);
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_5;
  xlv_TEXCOORD2 = (_Object2World * gl_Vertex).xyz;
  xlv_TEXCOORD3 = ((x2_7 + (unity_SHC.xyz * 
    ((tmpvar_5.x * tmpvar_5.x) - (tmpvar_5.y * tmpvar_5.y))
  )) + x1_8);
  xlv_TEXCOORD5 = exp2((-(tmpvar_10) * tmpvar_10));
}


#endif
#ifdef FRAGMENT
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 unity_FogColor;
uniform vec4 _LightColor0;
uniform vec4 _SpecColor;
uniform sampler2D _MainTex;
uniform vec4 _Color;
uniform float _Shininess;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying float xlv_TEXCOORD5;
void main ()
{
  vec4 c_1;
  vec3 tmpvar_2;
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  tmpvar_2 = (tmpvar_3.xyz * _Color.xyz);
  vec4 c_4;
  vec4 c_5;
  c_5.xyz = (((tmpvar_2 * _LightColor0.xyz) * max (0.0, 
    dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)
  )) + ((_LightColor0.xyz * _SpecColor.xyz) * (
    pow (max (0.0, dot (xlv_TEXCOORD1, normalize(
      (_WorldSpaceLightPos0.xyz + normalize((_WorldSpaceCameraPos - xlv_TEXCOORD2)))
    ))), (_Shininess * 128.0))
   * tmpvar_3.w)));
  c_5.w = (tmpvar_3.w * _Color.w);
  c_4.w = c_5.w;
  c_4.xyz = (c_5.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  c_1.xyz = mix (unity_FogColor.xyz, c_4.xyz, vec3(clamp (xlv_TEXCOORD5, 0.0, 1.0)));
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 4 [_Object2World] 3
Matrix 7 [_World2Object] 3
Matrix 0 [glstate_matrix_mvp]
Vector 18 [_MainTex_ST]
Vector 17 [unity_FogParams]
Vector 12 [unity_SHAb]
Vector 11 [unity_SHAg]
Vector 10 [unity_SHAr]
Vector 15 [unity_SHBb]
Vector 14 [unity_SHBg]
Vector 13 [unity_SHBr]
Vector 16 [unity_SHC]
"vs_2_0
def c19, 1, 0, 0, 0
dcl_position v0
dcl_normal v1
dcl_texcoord v2
dp4 oPos.x, c0, v0
dp4 oPos.y, c1, v0
dp4 oPos.w, c3, v0
mad oT0.xy, v2, c18, c18.zwzw
dp4 oT2.x, c4, v0
dp4 oT2.y, c5, v0
dp4 oT2.z, c6, v0
mul r0.xyz, v1.y, c8
mad r0.xyz, c7, v1.x, r0
mad r0.xyz, c9, v1.z, r0
nrm r1.xyz, r0
mul r0.x, r1.y, r1.y
mad r0.x, r1.x, r1.x, -r0.x
mul r2, r1.yzzx, r1.xyzz
dp4 r3.x, c13, r2
dp4 r3.y, c14, r2
dp4 r3.z, c15, r2
mad r0.xyz, c16, r0.x, r3
mov r1.w, c19.x
dp4 r2.x, c10, r1
dp4 r2.y, c11, r1
dp4 r2.z, c12, r1
mov oT1.xyz, r1
add oT3.xyz, r0, r2
dp4 r0.x, c2, v0
mul r0.y, r0.x, c17.x
mov oPos.z, r0.x
mul r0.x, r0.y, -r0.y
exp oT5.x, r0.x

"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 192
Vector 176 [_MainTex_ST]
ConstBuffer "UnityLighting" 720
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
ConstBuffer "UnityFog" 32
Vector 16 [unity_FogParams]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityPerDraw" 2
BindCB  "UnityFog" 3
"vs_4_0
root12:aaaeaaaa
eefiecedcanjkpjgnoelplikadleljpmilfmclkmabaaaaaajmahaaaaadaaaaaa
cmaaaaaaceabaaaanmabaaaaejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaakeaaaaaaafaaaaaaaaaaaaaaadaaaaaaabaaaaaaaealaaaakeaaaaaa
abaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaa
adaaaaaaadaaaaaaahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
liafaaaaeaaaabaagoabaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaae
egiocaaaabaaaaaacnaaaaaafjaaaaaeegiocaaaacaaaaaabdaaaaaafjaaaaae
egiocaaaadaaaaaaacaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadeccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagiaaaaac
aeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaf
pccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaackaabaaa
aaaaaaaaakiacaaaadaaaaaaabaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaa
aaaaaaaaakaabaiaebaaaaaaaaaaaaaabjaaaaafeccabaaaabaaaaaaakaabaaa
aaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
alaaaaaaogikcaaaaaaaaaaaalaaaaaadiaaaaaibcaabaaaaaaaaaaaakbabaaa
acaaaaaaakiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaaaaaaaaaaakbabaaa
acaaaaaaakiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaaaaaaaaaaakbabaaa
acaaaaaaakiacaaaacaaaaaabcaaaaaadiaaaaaibcaabaaaabaaaaaabkbabaaa
acaaaaaabkiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaabkbabaaa
acaaaaaabkiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaabkbabaaa
acaaaaaabkiacaaaacaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaacaaaaaa
ckiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaacaaaaaa
ckiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaacaaaaaa
ckiacaaaacaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
aaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaafhccabaaaacaaaaaa
egacbaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaa
adaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaa
diaaaaahbcaabaaaabaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaak
bcaabaaaabaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaiaebaaaaaa
abaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaa
bbaaaaaibcaabaaaadaaaaaaegiocaaaabaaaaaacjaaaaaaegaobaaaacaaaaaa
bbaaaaaiccaabaaaadaaaaaaegiocaaaabaaaaaackaaaaaaegaobaaaacaaaaaa
bbaaaaaiecaabaaaadaaaaaaegiocaaaabaaaaaaclaaaaaaegaobaaaacaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaabaaaaaacmaaaaaaagaabaaaabaaaaaa
egacbaaaadaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaai
bcaabaaaacaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaai
ccaabaaaacaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaai
ecaabaaaacaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaaaaaaaaaaaaaaaaah
hccabaaaaeaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 192
Vector 176 [_MainTex_ST]
ConstBuffer "UnityLighting" 720
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
ConstBuffer "UnityFog" 32
Vector 16 [unity_FogParams]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityPerDraw" 2
BindCB  "UnityFog" 3
"vs_4_0_level_9_1
root12:aaaeaaaa
eefiecedjcmabmmgeiegbkbcmgcanbmjmcombmccabaaaaaaneakaaaaaeaaaaaa
daaaaaaageadaaaaceajaaaabmakaaaaebgpgodjcmadaaaacmadaaaaaaacpopp
miacaaaageaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaabaagaaaaaaaalaa
abaaabaaaaaaaaaaabaacgaaahaaacaaaaaaaaaaacaaaaaaaeaaajaaaaaaaaaa
acaaamaaahaaanaaaaaaaaaaadaaabaaabaabeaaaaaaaaaaaaaaaaaaaaacpopp
fbaaaaafbfaaapkaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacafaaaaia
aaaaapjabpaaaaacafaaaciaacaaapjabpaaaaacafaaadiaadaaapjaaeaaaaae
aaaaadoaadaaoejaabaaoekaabaaookaafaaaaadaaaaahiaaaaaffjaaoaaoeka
aeaaaaaeaaaaahiaanaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaahiaapaaoeka
aaaakkjaaaaaoeiaaeaaaaaeacaaahoabaaaoekaaaaappjaaaaaoeiaafaaaaad
aaaaabiaacaaaajabbaaaakaafaaaaadaaaaaciaacaaaajabcaaaakaafaaaaad
aaaaaeiaacaaaajabdaaaakaafaaaaadabaaabiaacaaffjabbaaffkaafaaaaad
abaaaciaacaaffjabcaaffkaafaaaaadabaaaeiaacaaffjabdaaffkaacaaaaad
aaaaahiaaaaaoeiaabaaoeiaafaaaaadabaaabiaacaakkjabbaakkkaafaaaaad
abaaaciaacaakkjabcaakkkaafaaaaadabaaaeiaacaakkjabdaakkkaacaaaaad
aaaaahiaaaaaoeiaabaaoeiaceaaaaacabaaahiaaaaaoeiaafaaaaadaaaaabia
abaaffiaabaaffiaaeaaaaaeaaaaabiaabaaaaiaabaaaaiaaaaaaaibafaaaaad
acaaapiaabaacjiaabaakeiaajaaaaadadaaabiaafaaoekaacaaoeiaajaaaaad
adaaaciaagaaoekaacaaoeiaajaaaaadadaaaeiaahaaoekaacaaoeiaaeaaaaae
aaaaahiaaiaaoekaaaaaaaiaadaaoeiaabaaaaacabaaaiiabfaaaakaajaaaaad
acaaabiaacaaoekaabaaoeiaajaaaaadacaaaciaadaaoekaabaaoeiaajaaaaad
acaaaeiaaeaaoekaabaaoeiaabaaaaacabaaahoaabaaoeiaacaaaaadadaaahoa
aaaaoeiaacaaoeiaafaaaaadaaaaapiaaaaaffjaakaaoekaaeaaaaaeaaaaapia
ajaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaalaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiaamaaoekaaaaappjaaaaaoeiaafaaaaadabaaabiaaaaakkia
beaaaakaafaaaaadabaaabiaabaaaaiaabaaaaibaoaaaaacaaaaaeoaabaaaaia
aeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeia
ppppaaaafdeieefcliafaaaaeaaaabaagoabaaaafjaaaaaeegiocaaaaaaaaaaa
amaaaaaafjaaaaaeegiocaaaabaaaaaacnaaaaaafjaaaaaeegiocaaaacaaaaaa
bdaaaaaafjaaaaaeegiocaaaadaaaaaaacaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadeccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaa
aeaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaibcaabaaa
aaaaaaaackaabaaaaaaaaaaaakiacaaaadaaaaaaabaaaaaadiaaaaaibcaabaaa
aaaaaaaaakaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaabjaaaaafeccabaaa
abaaaaaaakaabaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaaalaaaaaadiaaaaaibcaabaaa
aaaaaaaaakbabaaaacaaaaaaakiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaa
aaaaaaaaakbabaaaacaaaaaaakiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaa
aaaaaaaaakbabaaaacaaaaaaakiacaaaacaaaaaabcaaaaaadiaaaaaibcaabaaa
abaaaaaabkbabaaaacaaaaaabkiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaa
abaaaaaabkbabaaaacaaaaaabkiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaa
abaaaaaabkbabaaaacaaaaaabkiacaaaacaaaaaabcaaaaaaaaaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaa
ckbabaaaacaaaaaackiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaa
ckbabaaaacaaaaaackiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaa
ckbabaaaacaaaaaackiacaaaacaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaf
hccabaaaacaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaa
aaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
acaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhccabaaaadaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaahbcaabaaaabaaaaaabkaabaaaaaaaaaaabkaabaaa
aaaaaaaadcaaaaakbcaabaaaabaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaa
akaabaiaebaaaaaaabaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaa
egakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaabaaaaaacjaaaaaa
egaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaabaaaaaackaaaaaa
egaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaabaaaaaaclaaaaaa
egaobaaaacaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaabaaaaaacmaaaaaa
agaabaaaabaaaaaaegacbaaaadaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaa
aaaaiadpbbaaaaaibcaabaaaacaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaa
aaaaaaaabbaaaaaiccaabaaaacaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaa
aaaaaaaabbaaaaaiecaabaaaacaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaa
aaaaaaaaaaaaaaahhccabaaaaeaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
doaaaaabejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
apaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaoaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaaabaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaaapaaaaaaojaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdejfeejepeoaafeebeo
ehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheo
laaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaa
apaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaa
afaaaaaaaaaaaaaaadaaaaaaabaaaaaaaealaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" }
"!!GLSL#version 120

#ifdef VERTEX
uniform vec4 _ProjectionParams;
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHC;

uniform mat4 _Object2World;
uniform mat4 _World2Object;
uniform vec4 unity_FogParams;
uniform vec4 _MainTex_ST;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD4;
varying float xlv_TEXCOORD5;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 v_2;
  v_2.x = _World2Object[0].x;
  v_2.y = _World2Object[1].x;
  v_2.z = _World2Object[2].x;
  v_2.w = _World2Object[3].x;
  vec4 v_3;
  v_3.x = _World2Object[0].y;
  v_3.y = _World2Object[1].y;
  v_3.z = _World2Object[2].y;
  v_3.w = _World2Object[3].y;
  vec4 v_4;
  v_4.x = _World2Object[0].z;
  v_4.y = _World2Object[1].z;
  v_4.z = _World2Object[2].z;
  v_4.w = _World2Object[3].z;
  vec3 tmpvar_5;
  tmpvar_5 = normalize(((
    (v_2.xyz * gl_Normal.x)
   + 
    (v_3.xyz * gl_Normal.y)
  ) + (v_4.xyz * gl_Normal.z)));
  vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  vec3 x2_7;
  vec3 x1_8;
  x1_8.x = dot (unity_SHAr, tmpvar_6);
  x1_8.y = dot (unity_SHAg, tmpvar_6);
  x1_8.z = dot (unity_SHAb, tmpvar_6);
  vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_5.xyzz * tmpvar_5.yzzx);
  x2_7.x = dot (unity_SHBr, tmpvar_9);
  x2_7.y = dot (unity_SHBg, tmpvar_9);
  x2_7.z = dot (unity_SHBb, tmpvar_9);
  vec4 o_10;
  vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_1 * 0.5);
  vec2 tmpvar_12;
  tmpvar_12.x = tmpvar_11.x;
  tmpvar_12.y = (tmpvar_11.y * _ProjectionParams.x);
  o_10.xy = (tmpvar_12 + tmpvar_11.w);
  o_10.zw = tmpvar_1.zw;
  float tmpvar_13;
  tmpvar_13 = (unity_FogParams.x * tmpvar_1.z);
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_5;
  xlv_TEXCOORD2 = (_Object2World * gl_Vertex).xyz;
  xlv_TEXCOORD3 = ((x2_7 + (unity_SHC.xyz * 
    ((tmpvar_5.x * tmpvar_5.x) - (tmpvar_5.y * tmpvar_5.y))
  )) + x1_8);
  xlv_TEXCOORD4 = o_10;
  xlv_TEXCOORD5 = exp2((-(tmpvar_13) * tmpvar_13));
}


#endif
#ifdef FRAGMENT
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 unity_FogColor;
uniform vec4 _LightColor0;
uniform vec4 _SpecColor;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _Color;
uniform float _Shininess;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD4;
varying float xlv_TEXCOORD5;
void main ()
{
  vec4 c_1;
  vec3 tmpvar_2;
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  tmpvar_2 = (tmpvar_3.xyz * _Color.xyz);
  vec3 tmpvar_4;
  tmpvar_4 = (_LightColor0.xyz * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x);
  vec4 c_5;
  vec4 c_6;
  c_6.xyz = (((tmpvar_2 * tmpvar_4) * max (0.0, 
    dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)
  )) + ((tmpvar_4 * _SpecColor.xyz) * (
    pow (max (0.0, dot (xlv_TEXCOORD1, normalize(
      (_WorldSpaceLightPos0.xyz + normalize((_WorldSpaceCameraPos - xlv_TEXCOORD2)))
    ))), (_Shininess * 128.0))
   * tmpvar_3.w)));
  c_6.w = (tmpvar_3.w * _Color.w);
  c_5.w = c_6.w;
  c_5.xyz = (c_6.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  c_1.xyz = mix (unity_FogColor.xyz, c_5.xyz, vec3(clamp (xlv_TEXCOORD5, 0.0, 1.0)));
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 4 [_Object2World] 3
Matrix 7 [_World2Object] 3
Matrix 0 [glstate_matrix_mvp]
Vector 20 [_MainTex_ST]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Vector 19 [unity_FogParams]
Vector 14 [unity_SHAb]
Vector 13 [unity_SHAg]
Vector 12 [unity_SHAr]
Vector 17 [unity_SHBb]
Vector 16 [unity_SHBg]
Vector 15 [unity_SHBr]
Vector 18 [unity_SHC]
"vs_2_0
def c21, 1, 0.5, 0, 0
dcl_position v0
dcl_normal v1
dcl_texcoord v2
mad oT0.xy, v2, c20, c20.zwzw
dp4 oT2.x, c4, v0
dp4 oT2.y, c5, v0
dp4 oT2.z, c6, v0
mul r0.xyz, v1.y, c8
mad r0.xyz, c7, v1.x, r0
mad r0.xyz, c9, v1.z, r0
nrm r1.xyz, r0
mul r0.x, r1.y, r1.y
mad r0.x, r1.x, r1.x, -r0.x
mul r2, r1.yzzx, r1.xyzz
dp4 r3.x, c15, r2
dp4 r3.y, c16, r2
dp4 r3.z, c17, r2
mad r0.xyz, c18, r0.x, r3
mov r1.w, c21.x
dp4 r2.x, c12, r1
dp4 r2.y, c13, r1
dp4 r2.z, c14, r1
mov oT1.xyz, r1
add oT3.xyz, r0, r2
dp4 r0.y, c1, v0
mul r1.x, r0.y, c10.x
mul r1.w, r1.x, c21.y
dp4 r0.x, c0, v0
dp4 r0.w, c3, v0
mul r1.xz, r0.xyww, c21.y
mad oT4.xy, r1.z, c11.zwzw, r1.xwzw
dp4 r0.z, c2, v0
mul r1.x, r0.z, c19.x
mul r1.x, r1.x, -r1.x
exp oT5.x, r1.x
mov oPos, r0
mov oT4.zw, r0

"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 192
Vector 176 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 144
Vector 80 [_ProjectionParams]
ConstBuffer "UnityLighting" 720
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
ConstBuffer "UnityFog" 32
Vector 16 [unity_FogParams]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityFog" 4
"vs_4_0
root12:aaafaaaa
eefiecedgohjhbcioikhccnipmlnodmcibeeejekabaaaaaaeiaiaaaaadaaaaaa
cmaaaaaaceabaaaapeabaaaaejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaabaaaaaaaealaaaalmaaaaaa
abaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaa
adaaaaaaadaaaaaaahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
ahaiaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcemagaaaaeaaaabaa
jdabaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaa
bdaaaaaafjaaaaaeegiocaaaaeaaaaaaacaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadeccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaa
aeaaaaaagfaaaaadpccabaaaafaaaaaagiaaaaacafaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaibcaabaaaabaaaaaackaabaaaaaaaaaaaakiacaaaaeaaaaaa
abaaaaaadiaaaaaibcaabaaaabaaaaaaakaabaaaabaaaaaaakaabaiaebaaaaaa
abaaaaaabjaaaaafeccabaaaabaaaaaaakaabaaaabaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaa
alaaaaaadiaaaaaibcaabaaaabaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaa
baaaaaaadiaaaaaiccaabaaaabaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaa
bbaaaaaadiaaaaaiecaabaaaabaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaa
bcaaaaaadiaaaaaibcaabaaaacaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaa
baaaaaaadiaaaaaiccaabaaaacaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaa
bbaaaaaadiaaaaaiecaabaaaacaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaa
bcaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
diaaaaaibcaabaaaacaaaaaackbabaaaacaaaaaackiacaaaadaaaaaabaaaaaaa
diaaaaaiccaabaaaacaaaaaackbabaaaacaaaaaackiacaaaadaaaaaabbaaaaaa
diaaaaaiecaabaaaacaaaaaackbabaaaacaaaaaackiacaaaadaaaaaabcaaaaaa
aaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaabaaaaaah
icaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaa
abaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaa
egacbaaaabaaaaaadgaaaaafhccabaaaacaaaaaaegacbaaaabaaaaaadiaaaaai
hcaabaaaacaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
hcaabaaaacaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
acaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaacaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaadaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaacaaaaaadiaaaaahbcaabaaaacaaaaaa
bkaabaaaabaaaaaabkaabaaaabaaaaaadcaaaaakbcaabaaaacaaaaaaakaabaaa
abaaaaaaakaabaaaabaaaaaaakaabaiaebaaaaaaacaaaaaadiaaaaahpcaabaaa
adaaaaaajgacbaaaabaaaaaaegakbaaaabaaaaaabbaaaaaibcaabaaaaeaaaaaa
egiocaaaacaaaaaacjaaaaaaegaobaaaadaaaaaabbaaaaaiccaabaaaaeaaaaaa
egiocaaaacaaaaaackaaaaaaegaobaaaadaaaaaabbaaaaaiecaabaaaaeaaaaaa
egiocaaaacaaaaaaclaaaaaaegaobaaaadaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaacaaaaaacmaaaaaaagaabaaaacaaaaaaegacbaaaaeaaaaaadgaaaaaf
icaabaaaabaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaadaaaaaaegiocaaa
acaaaaaacgaaaaaaegaobaaaabaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaa
acaaaaaachaaaaaaegaobaaaabaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaa
acaaaaaaciaaaaaaegaobaaaabaaaaaaaaaaaaahhccabaaaaeaaaaaaegacbaaa
acaaaaaaegacbaaaadaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaa
akiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaa
aceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaafaaaaaa
kgaobaaaaaaaaaaaaaaaaaahdccabaaaafaaaaaakgakbaaaabaaaaaamgaabaaa
abaaaaaadoaaaaab"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" "VERTEXLIGHT_ON" }
"!!GLSL#version 120

#ifdef VERTEX
uniform vec4 unity_4LightPosX0;
uniform vec4 unity_4LightPosY0;
uniform vec4 unity_4LightPosZ0;
uniform vec4 unity_4LightAtten0;
uniform vec4 unity_LightColor[8];
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHC;

uniform mat4 _Object2World;
uniform mat4 _World2Object;
uniform vec4 unity_FogParams;
uniform vec4 _MainTex_ST;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying float xlv_TEXCOORD5;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * gl_Vertex).xyz;
  vec4 v_3;
  v_3.x = _World2Object[0].x;
  v_3.y = _World2Object[1].x;
  v_3.z = _World2Object[2].x;
  v_3.w = _World2Object[3].x;
  vec4 v_4;
  v_4.x = _World2Object[0].y;
  v_4.y = _World2Object[1].y;
  v_4.z = _World2Object[2].y;
  v_4.w = _World2Object[3].y;
  vec4 v_5;
  v_5.x = _World2Object[0].z;
  v_5.y = _World2Object[1].z;
  v_5.z = _World2Object[2].z;
  v_5.w = _World2Object[3].z;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(((
    (v_3.xyz * gl_Normal.x)
   + 
    (v_4.xyz * gl_Normal.y)
  ) + (v_5.xyz * gl_Normal.z)));
  vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = tmpvar_6;
  vec3 x2_8;
  vec3 x1_9;
  x1_9.x = dot (unity_SHAr, tmpvar_7);
  x1_9.y = dot (unity_SHAg, tmpvar_7);
  x1_9.z = dot (unity_SHAb, tmpvar_7);
  vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_6.xyzz * tmpvar_6.yzzx);
  x2_8.x = dot (unity_SHBr, tmpvar_10);
  x2_8.y = dot (unity_SHBg, tmpvar_10);
  x2_8.z = dot (unity_SHBb, tmpvar_10);
  vec3 col_11;
  vec4 ndotl_12;
  vec4 lengthSq_13;
  vec4 tmpvar_14;
  tmpvar_14 = (unity_4LightPosX0 - tmpvar_2.x);
  vec4 tmpvar_15;
  tmpvar_15 = (unity_4LightPosY0 - tmpvar_2.y);
  vec4 tmpvar_16;
  tmpvar_16 = (unity_4LightPosZ0 - tmpvar_2.z);
  lengthSq_13 = (tmpvar_14 * tmpvar_14);
  lengthSq_13 = (lengthSq_13 + (tmpvar_15 * tmpvar_15));
  lengthSq_13 = (lengthSq_13 + (tmpvar_16 * tmpvar_16));
  ndotl_12 = (tmpvar_14 * tmpvar_6.x);
  ndotl_12 = (ndotl_12 + (tmpvar_15 * tmpvar_6.y));
  ndotl_12 = (ndotl_12 + (tmpvar_16 * tmpvar_6.z));
  vec4 tmpvar_17;
  tmpvar_17 = max (vec4(0.0, 0.0, 0.0, 0.0), (ndotl_12 * inversesqrt(lengthSq_13)));
  ndotl_12 = tmpvar_17;
  vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * (1.0/((1.0 + 
    (lengthSq_13 * unity_4LightAtten0)
  ))));
  col_11 = (unity_LightColor[0].xyz * tmpvar_18.x);
  col_11 = (col_11 + (unity_LightColor[1].xyz * tmpvar_18.y));
  col_11 = (col_11 + (unity_LightColor[2].xyz * tmpvar_18.z));
  col_11 = (col_11 + (unity_LightColor[3].xyz * tmpvar_18.w));
  float tmpvar_19;
  tmpvar_19 = (unity_FogParams.x * tmpvar_1.z);
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_6;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (((x2_8 + 
    (unity_SHC.xyz * ((tmpvar_6.x * tmpvar_6.x) - (tmpvar_6.y * tmpvar_6.y)))
  ) + x1_9) + col_11);
  xlv_TEXCOORD5 = exp2((-(tmpvar_19) * tmpvar_19));
}


#endif
#ifdef FRAGMENT
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 unity_FogColor;
uniform vec4 _LightColor0;
uniform vec4 _SpecColor;
uniform sampler2D _MainTex;
uniform vec4 _Color;
uniform float _Shininess;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying float xlv_TEXCOORD5;
void main ()
{
  vec4 c_1;
  vec3 tmpvar_2;
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  tmpvar_2 = (tmpvar_3.xyz * _Color.xyz);
  vec4 c_4;
  vec4 c_5;
  c_5.xyz = (((tmpvar_2 * _LightColor0.xyz) * max (0.0, 
    dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)
  )) + ((_LightColor0.xyz * _SpecColor.xyz) * (
    pow (max (0.0, dot (xlv_TEXCOORD1, normalize(
      (_WorldSpaceLightPos0.xyz + normalize((_WorldSpaceCameraPos - xlv_TEXCOORD2)))
    ))), (_Shininess * 128.0))
   * tmpvar_3.w)));
  c_5.w = (tmpvar_3.w * _Color.w);
  c_4.w = c_5.w;
  c_4.xyz = (c_5.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  c_1.xyz = mix (unity_FogColor.xyz, c_4.xyz, vec3(clamp (xlv_TEXCOORD5, 0.0, 1.0)));
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 8 [_Object2World] 3
Matrix 11 [_World2Object] 3
Matrix 4 [glstate_matrix_mvp]
Vector 26 [_MainTex_ST]
Vector 17 [unity_4LightAtten0]
Vector 14 [unity_4LightPosX0]
Vector 15 [unity_4LightPosY0]
Vector 16 [unity_4LightPosZ0]
Vector 25 [unity_FogParams]
Vector 0 [unity_LightColor0]
Vector 1 [unity_LightColor1]
Vector 2 [unity_LightColor2]
Vector 3 [unity_LightColor3]
Vector 20 [unity_SHAb]
Vector 19 [unity_SHAg]
Vector 18 [unity_SHAr]
Vector 23 [unity_SHBb]
Vector 22 [unity_SHBg]
Vector 21 [unity_SHBr]
Vector 24 [unity_SHC]
"vs_2_0
def c27, 1, 0, 0, 0
dcl_position v0
dcl_normal v1
dcl_texcoord v2
dp4 oPos.x, c4, v0
dp4 oPos.y, c5, v0
dp4 oPos.w, c7, v0
mad oT0.xy, v2, c26, c26.zwzw
mul r0.xyz, v1.y, c12
mad r0.xyz, c11, v1.x, r0
mad r0.xyz, c13, v1.z, r0
nrm r1.xyz, r0
mul r0.x, r1.y, r1.y
mad r0.x, r1.x, r1.x, -r0.x
mul r2, r1.yzzx, r1.xyzz
dp4 r3.x, c21, r2
dp4 r3.y, c22, r2
dp4 r3.z, c23, r2
mad r0.xyz, c24, r0.x, r3
mov r1.w, c27.x
dp4 r2.x, c18, r1
dp4 r2.y, c19, r1
dp4 r2.z, c20, r1
add r0.xyz, r0, r2
dp4 r2.y, c9, v0
add r3, -r2.y, c15
mul r4, r1.y, r3
mul r3, r3, r3
dp4 r2.x, c8, v0
add r5, -r2.x, c14
mad r4, r5, r1.x, r4
mad r3, r5, r5, r3
dp4 r2.z, c10, v0
add r5, -r2.z, c16
mov oT2.xyz, r2
mad r2, r5, r1.z, r4
mov oT1.xyz, r1
mad r1, r5, r5, r3
rsq r3.x, r1.x
rsq r3.y, r1.y
rsq r3.z, r1.z
rsq r3.w, r1.w
mov r4.x, c27.x
mad r1, r1, c17, r4.x
mul r2, r2, r3
max r2, r2, c27.y
rcp r3.x, r1.x
rcp r3.y, r1.y
rcp r3.z, r1.z
rcp r3.w, r1.w
mul r1, r2, r3
mul r2.xyz, r1.y, c1
mad r2.xyz, c0, r1.x, r2
mad r1.xyz, c2, r1.z, r2
mad r1.xyz, c3, r1.w, r1
add oT3.xyz, r0, r1
dp4 r0.x, c6, v0
mul r0.y, r0.x, c25.x
mov oPos.z, r0.x
mul r0.x, r0.y, -r0.y
exp oT5.x, r0.x

"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 192
Vector 176 [_MainTex_ST]
ConstBuffer "UnityLighting" 720
Vector 32 [unity_4LightPosX0]
Vector 48 [unity_4LightPosY0]
Vector 64 [unity_4LightPosZ0]
Vector 80 [unity_4LightAtten0]
Vector 96 [unity_LightColor0]
Vector 112 [unity_LightColor1]
Vector 128 [unity_LightColor2]
Vector 144 [unity_LightColor3]
Vector 160 [unity_LightColor4]
Vector 176 [unity_LightColor5]
Vector 192 [unity_LightColor6]
Vector 208 [unity_LightColor7]
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
ConstBuffer "UnityFog" 32
Vector 16 [unity_FogParams]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityPerDraw" 2
BindCB  "UnityFog" 3
"vs_4_0
root12:aaaeaaaa
eefiecedmgmcigkjpkfphfloaebknmeppkedokceabaaaaaagiakaaaaadaaaaaa
cmaaaaaaceabaaaanmabaaaaejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaakeaaaaaaafaaaaaaaaaaaaaaadaaaaaaabaaaaaaaealaaaakeaaaaaa
abaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaa
adaaaaaaadaaaaaaahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
ieaiaaaaeaaaabaacbacaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaae
egiocaaaabaaaaaacnaaaaaafjaaaaaeegiocaaaacaaaaaabdaaaaaafjaaaaae
egiocaaaadaaaaaaacaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadeccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagiaaaaac
agaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaf
pccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaackaabaaa
aaaaaaaaakiacaaaadaaaaaaabaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaa
aaaaaaaaakaabaiaebaaaaaaaaaaaaaabjaaaaafeccabaaaabaaaaaaakaabaaa
aaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
alaaaaaaogikcaaaaaaaaaaaalaaaaaadiaaaaaibcaabaaaaaaaaaaaakbabaaa
acaaaaaaakiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaaaaaaaaaaakbabaaa
acaaaaaaakiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaaaaaaaaaaakbabaaa
acaaaaaaakiacaaaacaaaaaabcaaaaaadiaaaaaibcaabaaaabaaaaaabkbabaaa
acaaaaaabkiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaabkbabaaa
acaaaaaabkiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaabkbabaaa
acaaaaaabkiacaaaacaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaacaaaaaa
ckiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaacaaaaaa
ckiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaacaaaaaa
ckiacaaaacaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
aaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaafhccabaaaacaaaaaa
egacbaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
acaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaa
dgaaaaafhccabaaaadaaaaaaegacbaaaabaaaaaadiaaaaahicaabaaaabaaaaaa
bkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaakicaabaaaabaaaaaaakaabaaa
aaaaaaaaakaabaaaaaaaaaaadkaabaiaebaaaaaaabaaaaaadiaaaaahpcaabaaa
acaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaa
egiocaaaabaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaa
egiocaaaabaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaa
egiocaaaabaaaaaaclaaaaaaegaobaaaacaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaabaaaaaacmaaaaaapgapbaaaabaaaaaaegacbaaaadaaaaaadgaaaaaf
icaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaadaaaaaaegiocaaa
abaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaa
abaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaa
abaaaaaaciaaaaaaegaobaaaaaaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaaegacbaaaadaaaaaaaaaaaaajpcaabaaaadaaaaaafgafbaiaebaaaaaa
abaaaaaaegiocaaaabaaaaaaadaaaaaadiaaaaahpcaabaaaaeaaaaaafgafbaaa
aaaaaaaaegaobaaaadaaaaaadiaaaaahpcaabaaaadaaaaaaegaobaaaadaaaaaa
egaobaaaadaaaaaaaaaaaaajpcaabaaaafaaaaaaagaabaiaebaaaaaaabaaaaaa
egiocaaaabaaaaaaacaaaaaaaaaaaaajpcaabaaaabaaaaaakgakbaiaebaaaaaa
abaaaaaaegiocaaaabaaaaaaaeaaaaaadcaaaaajpcaabaaaaeaaaaaaegaobaaa
afaaaaaaagaabaaaaaaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaaaaaaaaaa
egaobaaaabaaaaaakgakbaaaaaaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaa
adaaaaaaegaobaaaafaaaaaaegaobaaaafaaaaaaegaobaaaadaaaaaadcaaaaaj
pcaabaaaabaaaaaaegaobaaaabaaaaaaegaobaaaabaaaaaaegaobaaaadaaaaaa
eeaaaaafpcaabaaaadaaaaaaegaobaaaabaaaaaadcaaaaanpcaabaaaabaaaaaa
egaobaaaabaaaaaaegiocaaaabaaaaaaafaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaiadpaoaaaaakpcaabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaiadpegaobaaaabaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaegaobaaaadaaaaaadeaaaaakpcaabaaaaaaaaaaaegaobaaaaaaaaaaa
aceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadiaaaaahpcaabaaaaaaaaaaa
egaobaaaabaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiccaaaabaaaaaaahaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
abaaaaaaagaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaabaaaaaaaiaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaajaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaaaaaaaaahhccabaaaaeaaaaaaegacbaaaaaaaaaaaegacbaaa
acaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 192
Vector 176 [_MainTex_ST]
ConstBuffer "UnityLighting" 720
Vector 32 [unity_4LightPosX0]
Vector 48 [unity_4LightPosY0]
Vector 64 [unity_4LightPosZ0]
Vector 80 [unity_4LightAtten0]
Vector 96 [unity_LightColor0]
Vector 112 [unity_LightColor1]
Vector 128 [unity_LightColor2]
Vector 144 [unity_LightColor3]
Vector 160 [unity_LightColor4]
Vector 176 [unity_LightColor5]
Vector 192 [unity_LightColor6]
Vector 208 [unity_LightColor7]
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
ConstBuffer "UnityFog" 32
Vector 16 [unity_FogParams]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityPerDraw" 2
BindCB  "UnityFog" 3
"vs_4_0_level_9_1
root12:aaaeaaaa
eefiecedjelhaeicablfcacgobnidngnohbpalmkabaaaaaageapaaaaaeaaaaaa
daaaaaaaciafaaaaleanaaaakmaoaaaaebgpgodjpaaeaaaapaaeaaaaaaacpopp
iaaeaaaahaaaaaaaagaaceaaaaaagmaaaaaagmaaaaaaceaaabaagmaaaaaaalaa
abaaabaaaaaaaaaaabaaacaaaiaaacaaaaaaaaaaabaacgaaahaaakaaaaaaaaaa
acaaaaaaaeaabbaaaaaaaaaaacaaamaaahaabfaaaaaaaaaaadaaabaaabaabmaa
aaaaaaaaaaaaaaaaaaacpoppfbaaaaafbnaaapkaaaaaiadpaaaaaaaaaaaaaaaa
aaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaciaacaaapjabpaaaaac
afaaadiaadaaapjaaeaaaaaeaaaaadoaadaaoejaabaaoekaabaaookaafaaaaad
aaaaabiaacaaaajabjaaaakaafaaaaadaaaaaciaacaaaajabkaaaakaafaaaaad
aaaaaeiaacaaaajablaaaakaafaaaaadabaaabiaacaaffjabjaaffkaafaaaaad
abaaaciaacaaffjabkaaffkaafaaaaadabaaaeiaacaaffjablaaffkaacaaaaad
aaaaahiaaaaaoeiaabaaoeiaafaaaaadabaaabiaacaakkjabjaakkkaafaaaaad
abaaaciaacaakkjabkaakkkaafaaaaadabaaaeiaacaakkjablaakkkaacaaaaad
aaaaahiaaaaaoeiaabaaoeiaceaaaaacabaaahiaaaaaoeiaafaaaaadaaaaabia
abaaffiaabaaffiaaeaaaaaeaaaaabiaabaaaaiaabaaaaiaaaaaaaibafaaaaad
acaaapiaabaacjiaabaakeiaajaaaaadadaaabiaanaaoekaacaaoeiaajaaaaad
adaaaciaaoaaoekaacaaoeiaajaaaaadadaaaeiaapaaoekaacaaoeiaaeaaaaae
aaaaahiabaaaoekaaaaaaaiaadaaoeiaabaaaaacabaaaiiabnaaaakaajaaaaad
acaaabiaakaaoekaabaaoeiaajaaaaadacaaaciaalaaoekaabaaoeiaajaaaaad
acaaaeiaamaaoekaabaaoeiaacaaaaadaaaaahiaaaaaoeiaacaaoeiaafaaaaad
acaaahiaaaaaffjabgaaoekaaeaaaaaeacaaahiabfaaoekaaaaaaajaacaaoeia
aeaaaaaeacaaahiabhaaoekaaaaakkjaacaaoeiaaeaaaaaeacaaahiabiaaoeka
aaaappjaacaaoeiaacaaaaadadaaapiaacaaffibadaaoekaafaaaaadaeaaapia
abaaffiaadaaoeiaafaaaaadadaaapiaadaaoeiaadaaoeiaacaaaaadafaaapia
acaaaaibacaaoekaaeaaaaaeaeaaapiaafaaoeiaabaaaaiaaeaaoeiaaeaaaaae
adaaapiaafaaoeiaafaaoeiaadaaoeiaacaaaaadafaaapiaacaakkibaeaaoeka
abaaaaacacaaahoaacaaoeiaaeaaaaaeacaaapiaafaaoeiaabaakkiaaeaaoeia
abaaaaacabaaahoaabaaoeiaaeaaaaaeabaaapiaafaaoeiaafaaoeiaadaaoeia
ahaaaaacadaaabiaabaaaaiaahaaaaacadaaaciaabaaffiaahaaaaacadaaaeia
abaakkiaahaaaaacadaaaiiaabaappiaabaaaaacaeaaabiabnaaaakaaeaaaaae
abaaapiaabaaoeiaafaaoekaaeaaaaiaafaaaaadacaaapiaacaaoeiaadaaoeia
alaaaaadacaaapiaacaaoeiabnaaffkaagaaaaacadaaabiaabaaaaiaagaaaaac
adaaaciaabaaffiaagaaaaacadaaaeiaabaakkiaagaaaaacadaaaiiaabaappia
afaaaaadabaaapiaacaaoeiaadaaoeiaafaaaaadacaaahiaabaaffiaahaaoeka
aeaaaaaeacaaahiaagaaoekaabaaaaiaacaaoeiaaeaaaaaeabaaahiaaiaaoeka
abaakkiaacaaoeiaaeaaaaaeabaaahiaajaaoekaabaappiaabaaoeiaacaaaaad
adaaahoaaaaaoeiaabaaoeiaafaaaaadaaaaapiaaaaaffjabcaaoekaaeaaaaae
aaaaapiabbaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiabdaaoekaaaaakkja
aaaaoeiaaeaaaaaeaaaaapiabeaaoekaaaaappjaaaaaoeiaafaaaaadabaaabia
aaaakkiabmaaaakaafaaaaadabaaabiaabaaaaiaabaaaaibaoaaaaacaaaaaeoa
abaaaaiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaamma
aaaaoeiappppaaaafdeieefcieaiaaaaeaaaabaacbacaaaafjaaaaaeegiocaaa
aaaaaaaaamaaaaaafjaaaaaeegiocaaaabaaaaaacnaaaaaafjaaaaaeegiocaaa
acaaaaaabdaaaaaafjaaaaaeegiocaaaadaaaaaaacaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadeccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagiaaaaacagaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
bcaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaaadaaaaaaabaaaaaadiaaaaai
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaabjaaaaaf
eccabaaaabaaaaaaakaabaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaaalaaaaaadiaaaaai
bcaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaacaaaaaabaaaaaaadiaaaaai
ccaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaacaaaaaabbaaaaaadiaaaaai
ecaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaacaaaaaabcaaaaaadiaaaaai
bcaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaacaaaaaabaaaaaaadiaaaaai
ccaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaacaaaaaabbaaaaaadiaaaaai
ecaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaacaaaaaabcaaaaaaaaaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaacaaaaaabcaaaaaaaaaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
dgaaaaafhccabaaaacaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaa
fgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegacbaaaabaaaaaadgaaaaafhccabaaaadaaaaaaegacbaaaabaaaaaa
diaaaaahicaabaaaabaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaak
icaabaaaabaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaadkaabaiaebaaaaaa
abaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaa
bbaaaaaibcaabaaaadaaaaaaegiocaaaabaaaaaacjaaaaaaegaobaaaacaaaaaa
bbaaaaaiccaabaaaadaaaaaaegiocaaaabaaaaaackaaaaaaegaobaaaacaaaaaa
bbaaaaaiecaabaaaadaaaaaaegiocaaaabaaaaaaclaaaaaaegaobaaaacaaaaaa
dcaaaaakhcaabaaaacaaaaaaegiccaaaabaaaaaacmaaaaaapgapbaaaabaaaaaa
egacbaaaadaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaai
bcaabaaaadaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaai
ccaabaaaadaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaai
ecaabaaaadaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaaaaaaaaaaaaaaaaah
hcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaaaaaaaaajpcaabaaa
adaaaaaafgafbaiaebaaaaaaabaaaaaaegiocaaaabaaaaaaadaaaaaadiaaaaah
pcaabaaaaeaaaaaafgafbaaaaaaaaaaaegaobaaaadaaaaaadiaaaaahpcaabaaa
adaaaaaaegaobaaaadaaaaaaegaobaaaadaaaaaaaaaaaaajpcaabaaaafaaaaaa
agaabaiaebaaaaaaabaaaaaaegiocaaaabaaaaaaacaaaaaaaaaaaaajpcaabaaa
abaaaaaakgakbaiaebaaaaaaabaaaaaaegiocaaaabaaaaaaaeaaaaaadcaaaaaj
pcaabaaaaeaaaaaaegaobaaaafaaaaaaagaabaaaaaaaaaaaegaobaaaaeaaaaaa
dcaaaaajpcaabaaaaaaaaaaaegaobaaaabaaaaaakgakbaaaaaaaaaaaegaobaaa
aeaaaaaadcaaaaajpcaabaaaadaaaaaaegaobaaaafaaaaaaegaobaaaafaaaaaa
egaobaaaadaaaaaadcaaaaajpcaabaaaabaaaaaaegaobaaaabaaaaaaegaobaaa
abaaaaaaegaobaaaadaaaaaaeeaaaaafpcaabaaaadaaaaaaegaobaaaabaaaaaa
dcaaaaanpcaabaaaabaaaaaaegaobaaaabaaaaaaegiocaaaabaaaaaaafaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpaoaaaaakpcaabaaaabaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpegaobaaaabaaaaaadiaaaaah
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaadaaaaaadeaaaaakpcaabaaa
aaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
diaaaaahpcaabaaaaaaaaaaaegaobaaaabaaaaaaegaobaaaaaaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaabaaaaaaahaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaabaaaaaaagaaaaaaagaabaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaaiaaaaaakgakbaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaa
ajaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaahhccabaaaaeaaaaaa
egacbaaaaaaaaaaaegacbaaaacaaaaaadoaaaaabejfdeheopaaaaaaaaiaaaaaa
aiaaaaaamiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apadaaaaoaaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaa
acaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaa
adaaaaaaagaaaaaaapaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaa
apaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffied
epepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadamaaaakeaaaaaaafaaaaaaaaaaaaaaadaaaaaaabaaaaaa
aealaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklkl"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" "VERTEXLIGHT_ON" }
"!!GLSL#version 120

#ifdef VERTEX
uniform vec4 _ProjectionParams;
uniform vec4 unity_4LightPosX0;
uniform vec4 unity_4LightPosY0;
uniform vec4 unity_4LightPosZ0;
uniform vec4 unity_4LightAtten0;
uniform vec4 unity_LightColor[8];
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHC;

uniform mat4 _Object2World;
uniform mat4 _World2Object;
uniform vec4 unity_FogParams;
uniform vec4 _MainTex_ST;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD4;
varying float xlv_TEXCOORD5;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * gl_Vertex).xyz;
  vec4 v_3;
  v_3.x = _World2Object[0].x;
  v_3.y = _World2Object[1].x;
  v_3.z = _World2Object[2].x;
  v_3.w = _World2Object[3].x;
  vec4 v_4;
  v_4.x = _World2Object[0].y;
  v_4.y = _World2Object[1].y;
  v_4.z = _World2Object[2].y;
  v_4.w = _World2Object[3].y;
  vec4 v_5;
  v_5.x = _World2Object[0].z;
  v_5.y = _World2Object[1].z;
  v_5.z = _World2Object[2].z;
  v_5.w = _World2Object[3].z;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(((
    (v_3.xyz * gl_Normal.x)
   + 
    (v_4.xyz * gl_Normal.y)
  ) + (v_5.xyz * gl_Normal.z)));
  vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = tmpvar_6;
  vec3 x2_8;
  vec3 x1_9;
  x1_9.x = dot (unity_SHAr, tmpvar_7);
  x1_9.y = dot (unity_SHAg, tmpvar_7);
  x1_9.z = dot (unity_SHAb, tmpvar_7);
  vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_6.xyzz * tmpvar_6.yzzx);
  x2_8.x = dot (unity_SHBr, tmpvar_10);
  x2_8.y = dot (unity_SHBg, tmpvar_10);
  x2_8.z = dot (unity_SHBb, tmpvar_10);
  vec3 col_11;
  vec4 ndotl_12;
  vec4 lengthSq_13;
  vec4 tmpvar_14;
  tmpvar_14 = (unity_4LightPosX0 - tmpvar_2.x);
  vec4 tmpvar_15;
  tmpvar_15 = (unity_4LightPosY0 - tmpvar_2.y);
  vec4 tmpvar_16;
  tmpvar_16 = (unity_4LightPosZ0 - tmpvar_2.z);
  lengthSq_13 = (tmpvar_14 * tmpvar_14);
  lengthSq_13 = (lengthSq_13 + (tmpvar_15 * tmpvar_15));
  lengthSq_13 = (lengthSq_13 + (tmpvar_16 * tmpvar_16));
  ndotl_12 = (tmpvar_14 * tmpvar_6.x);
  ndotl_12 = (ndotl_12 + (tmpvar_15 * tmpvar_6.y));
  ndotl_12 = (ndotl_12 + (tmpvar_16 * tmpvar_6.z));
  vec4 tmpvar_17;
  tmpvar_17 = max (vec4(0.0, 0.0, 0.0, 0.0), (ndotl_12 * inversesqrt(lengthSq_13)));
  ndotl_12 = tmpvar_17;
  vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * (1.0/((1.0 + 
    (lengthSq_13 * unity_4LightAtten0)
  ))));
  col_11 = (unity_LightColor[0].xyz * tmpvar_18.x);
  col_11 = (col_11 + (unity_LightColor[1].xyz * tmpvar_18.y));
  col_11 = (col_11 + (unity_LightColor[2].xyz * tmpvar_18.z));
  col_11 = (col_11 + (unity_LightColor[3].xyz * tmpvar_18.w));
  vec4 o_19;
  vec4 tmpvar_20;
  tmpvar_20 = (tmpvar_1 * 0.5);
  vec2 tmpvar_21;
  tmpvar_21.x = tmpvar_20.x;
  tmpvar_21.y = (tmpvar_20.y * _ProjectionParams.x);
  o_19.xy = (tmpvar_21 + tmpvar_20.w);
  o_19.zw = tmpvar_1.zw;
  float tmpvar_22;
  tmpvar_22 = (unity_FogParams.x * tmpvar_1.z);
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_6;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (((x2_8 + 
    (unity_SHC.xyz * ((tmpvar_6.x * tmpvar_6.x) - (tmpvar_6.y * tmpvar_6.y)))
  ) + x1_9) + col_11);
  xlv_TEXCOORD4 = o_19;
  xlv_TEXCOORD5 = exp2((-(tmpvar_22) * tmpvar_22));
}


#endif
#ifdef FRAGMENT
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 unity_FogColor;
uniform vec4 _LightColor0;
uniform vec4 _SpecColor;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _Color;
uniform float _Shininess;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD4;
varying float xlv_TEXCOORD5;
void main ()
{
  vec4 c_1;
  vec3 tmpvar_2;
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  tmpvar_2 = (tmpvar_3.xyz * _Color.xyz);
  vec3 tmpvar_4;
  tmpvar_4 = (_LightColor0.xyz * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x);
  vec4 c_5;
  vec4 c_6;
  c_6.xyz = (((tmpvar_2 * tmpvar_4) * max (0.0, 
    dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)
  )) + ((tmpvar_4 * _SpecColor.xyz) * (
    pow (max (0.0, dot (xlv_TEXCOORD1, normalize(
      (_WorldSpaceLightPos0.xyz + normalize((_WorldSpaceCameraPos - xlv_TEXCOORD2)))
    ))), (_Shininess * 128.0))
   * tmpvar_3.w)));
  c_6.w = (tmpvar_3.w * _Color.w);
  c_5.w = c_6.w;
  c_5.xyz = (c_6.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  c_1.xyz = mix (unity_FogColor.xyz, c_5.xyz, vec3(clamp (xlv_TEXCOORD5, 0.0, 1.0)));
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 8 [_Object2World] 3
Matrix 11 [_World2Object] 3
Matrix 4 [glstate_matrix_mvp]
Vector 28 [_MainTex_ST]
Vector 14 [_ProjectionParams]
Vector 15 [_ScreenParams]
Vector 19 [unity_4LightAtten0]
Vector 16 [unity_4LightPosX0]
Vector 17 [unity_4LightPosY0]
Vector 18 [unity_4LightPosZ0]
Vector 27 [unity_FogParams]
Vector 0 [unity_LightColor0]
Vector 1 [unity_LightColor1]
Vector 2 [unity_LightColor2]
Vector 3 [unity_LightColor3]
Vector 22 [unity_SHAb]
Vector 21 [unity_SHAg]
Vector 20 [unity_SHAr]
Vector 25 [unity_SHBb]
Vector 24 [unity_SHBg]
Vector 23 [unity_SHBr]
Vector 26 [unity_SHC]
"vs_2_0
def c29, 1, 0, 0.5, 0
dcl_position v0
dcl_normal v1
dcl_texcoord v2
mad oT0.xy, v2, c28, c28.zwzw
mul r0.xyz, v1.y, c12
mad r0.xyz, c11, v1.x, r0
mad r0.xyz, c13, v1.z, r0
nrm r1.xyz, r0
mul r0.x, r1.y, r1.y
mad r0.x, r1.x, r1.x, -r0.x
mul r2, r1.yzzx, r1.xyzz
dp4 r3.x, c23, r2
dp4 r3.y, c24, r2
dp4 r3.z, c25, r2
mad r0.xyz, c26, r0.x, r3
mov r1.w, c29.x
dp4 r2.x, c20, r1
dp4 r2.y, c21, r1
dp4 r2.z, c22, r1
add r0.xyz, r0, r2
dp4 r2.y, c9, v0
add r3, -r2.y, c17
mul r4, r1.y, r3
mul r3, r3, r3
dp4 r2.x, c8, v0
add r5, -r2.x, c16
mad r4, r5, r1.x, r4
mad r3, r5, r5, r3
dp4 r2.z, c10, v0
add r5, -r2.z, c18
mov oT2.xyz, r2
mad r2, r5, r1.z, r4
mov oT1.xyz, r1
mad r1, r5, r5, r3
rsq r3.x, r1.x
rsq r3.y, r1.y
rsq r3.z, r1.z
rsq r3.w, r1.w
mov r4.x, c29.x
mad r1, r1, c19, r4.x
mul r2, r2, r3
max r2, r2, c29.y
rcp r3.x, r1.x
rcp r3.y, r1.y
rcp r3.z, r1.z
rcp r3.w, r1.w
mul r1, r2, r3
mul r2.xyz, r1.y, c1
mad r2.xyz, c0, r1.x, r2
mad r1.xyz, c2, r1.z, r2
mad r1.xyz, c3, r1.w, r1
add oT3.xyz, r0, r1
dp4 r0.y, c5, v0
mul r1.x, r0.y, c14.x
mul r1.w, r1.x, c29.z
dp4 r0.x, c4, v0
dp4 r0.w, c7, v0
mul r1.xz, r0.xyww, c29.z
mad oT4.xy, r1.z, c15.zwzw, r1.xwzw
dp4 r0.z, c6, v0
mul r1.x, r0.z, c27.x
mul r1.x, r1.x, -r1.x
exp oT5.x, r1.x
mov oPos, r0
mov oT4.zw, r0

"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 192
Vector 176 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 144
Vector 80 [_ProjectionParams]
ConstBuffer "UnityLighting" 720
Vector 32 [unity_4LightPosX0]
Vector 48 [unity_4LightPosY0]
Vector 64 [unity_4LightPosZ0]
Vector 80 [unity_4LightAtten0]
Vector 96 [unity_LightColor0]
Vector 112 [unity_LightColor1]
Vector 128 [unity_LightColor2]
Vector 144 [unity_LightColor3]
Vector 160 [unity_LightColor4]
Vector 176 [unity_LightColor5]
Vector 192 [unity_LightColor6]
Vector 208 [unity_LightColor7]
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
ConstBuffer "UnityFog" 32
Vector 16 [unity_FogParams]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityFog" 4
"vs_4_0
root12:aaafaaaa
eefiecedonlkbeodhfgjcjlnapnfnpjchhkdjpeoabaaaaaabealaaaaadaaaaaa
cmaaaaaaceabaaaapeabaaaaejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaabaaaaaaaealaaaalmaaaaaa
abaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaa
adaaaaaaadaaaaaaahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
ahaiaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcbiajaaaaeaaaabaa
egacaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaa
bdaaaaaafjaaaaaeegiocaaaaeaaaaaaacaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadeccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaa
aeaaaaaagfaaaaadpccabaaaafaaaaaagiaaaaacahaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaibcaabaaaabaaaaaackaabaaaaaaaaaaaakiacaaaaeaaaaaa
abaaaaaadiaaaaaibcaabaaaabaaaaaaakaabaaaabaaaaaaakaabaiaebaaaaaa
abaaaaaabjaaaaafeccabaaaabaaaaaaakaabaaaabaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaa
alaaaaaadiaaaaaibcaabaaaabaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaa
baaaaaaadiaaaaaiccaabaaaabaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaa
bbaaaaaadiaaaaaiecaabaaaabaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaa
bcaaaaaadiaaaaaibcaabaaaacaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaa
baaaaaaadiaaaaaiccaabaaaacaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaa
bbaaaaaadiaaaaaiecaabaaaacaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaa
bcaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
diaaaaaibcaabaaaacaaaaaackbabaaaacaaaaaackiacaaaadaaaaaabaaaaaaa
diaaaaaiccaabaaaacaaaaaackbabaaaacaaaaaackiacaaaadaaaaaabbaaaaaa
diaaaaaiecaabaaaacaaaaaackbabaaaacaaaaaackiacaaaadaaaaaabcaaaaaa
aaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaabaaaaaah
icaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaa
abaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaa
egacbaaaabaaaaaadgaaaaafhccabaaaacaaaaaaegacbaaaabaaaaaadiaaaaai
hcaabaaaacaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
hcaabaaaacaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
acaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaadaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaacaaaaaadgaaaaafhccabaaaadaaaaaa
egacbaaaacaaaaaadiaaaaahicaabaaaacaaaaaabkaabaaaabaaaaaabkaabaaa
abaaaaaadcaaaaakicaabaaaacaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaa
dkaabaiaebaaaaaaacaaaaaadiaaaaahpcaabaaaadaaaaaajgacbaaaabaaaaaa
egakbaaaabaaaaaabbaaaaaibcaabaaaaeaaaaaaegiocaaaacaaaaaacjaaaaaa
egaobaaaadaaaaaabbaaaaaiccaabaaaaeaaaaaaegiocaaaacaaaaaackaaaaaa
egaobaaaadaaaaaabbaaaaaiecaabaaaaeaaaaaaegiocaaaacaaaaaaclaaaaaa
egaobaaaadaaaaaadcaaaaakhcaabaaaadaaaaaaegiccaaaacaaaaaacmaaaaaa
pgapbaaaacaaaaaaegacbaaaaeaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaa
aaaaiadpbbaaaaaibcaabaaaaeaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaa
abaaaaaabbaaaaaiccaabaaaaeaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaa
abaaaaaabbaaaaaiecaabaaaaeaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaa
abaaaaaaaaaaaaahhcaabaaaadaaaaaaegacbaaaadaaaaaaegacbaaaaeaaaaaa
aaaaaaajpcaabaaaaeaaaaaafgafbaiaebaaaaaaacaaaaaaegiocaaaacaaaaaa
adaaaaaadiaaaaahpcaabaaaafaaaaaafgafbaaaabaaaaaaegaobaaaaeaaaaaa
diaaaaahpcaabaaaaeaaaaaaegaobaaaaeaaaaaaegaobaaaaeaaaaaaaaaaaaaj
pcaabaaaagaaaaaaagaabaiaebaaaaaaacaaaaaaegiocaaaacaaaaaaacaaaaaa
aaaaaaajpcaabaaaacaaaaaakgakbaiaebaaaaaaacaaaaaaegiocaaaacaaaaaa
aeaaaaaadcaaaaajpcaabaaaafaaaaaaegaobaaaagaaaaaaagaabaaaabaaaaaa
egaobaaaafaaaaaadcaaaaajpcaabaaaabaaaaaaegaobaaaacaaaaaakgakbaaa
abaaaaaaegaobaaaafaaaaaadcaaaaajpcaabaaaaeaaaaaaegaobaaaagaaaaaa
egaobaaaagaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaaacaaaaaaegaobaaa
acaaaaaaegaobaaaacaaaaaaegaobaaaaeaaaaaaeeaaaaafpcaabaaaaeaaaaaa
egaobaaaacaaaaaadcaaaaanpcaabaaaacaaaaaaegaobaaaacaaaaaaegiocaaa
acaaaaaaafaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpaoaaaaak
pcaabaaaacaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpegaobaaa
acaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaaegaobaaaaeaaaaaa
deaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaacaaaaaaegaobaaa
abaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaaabaaaaaaegiccaaaacaaaaaa
ahaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaaagaaaaaaagaabaaa
abaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaa
aiaaaaaakgakbaaaabaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaacaaaaaaajaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaaaaaaaaah
hccabaaaaeaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaaiccaabaaa
aaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaa
abaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadp
dgaaaaafmccabaaaafaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaafaaaaaa
kgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 192
Vector 176 [_MainTex_ST]
ConstBuffer "UnityLighting" 720
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityShadows" 416
Matrix 128 [unity_World2Shadow0]
Matrix 192 [unity_World2Shadow1]
Matrix 256 [unity_World2Shadow2]
Matrix 320 [unity_World2Shadow3]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
ConstBuffer "UnityFog" 32
Vector 16 [unity_FogParams]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityShadows" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityFog" 4
"vs_4_0_level_9_1
root12:aaafaaaa
eefiecednfapifofhbhadiiooihodeimdhgbnjbkabaaaaaanmamaaaaaeaaaaaa
daaaaaaaaiaeaaaabealaaaaamamaaaaebgpgodjnaadaaaanaadaaaaaaacpopp
gaadaaaahaaaaaaaagaaceaaaaaagmaaaaaagmaaaaaaceaaabaagmaaaaaaalaa
abaaabaaaaaaaaaaabaacgaaahaaacaaaaaaaaaaacaaaiaaaeaaajaaaaaaaaaa
adaaaaaaaeaaanaaaaaaaaaaadaaamaaahaabbaaaaaaaaaaaeaaabaaabaabiaa
aaaaaaaaaaaaaaaaaaacpoppfbaaaaafbjaaapkaaaaaiadpaaaaaaaaaaaaaaaa
aaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaciaacaaapjabpaaaaac
afaaadiaadaaapjaaeaaaaaeaaaaadoaadaaoejaabaaoekaabaaookaafaaaaad
aaaaahiaaaaaffjabcaaoekaaeaaaaaeaaaaahiabbaaoekaaaaaaajaaaaaoeia
aeaaaaaeaaaaahiabdaaoekaaaaakkjaaaaaoeiaaeaaaaaeacaaahoabeaaoeka
aaaappjaaaaaoeiaafaaaaadaaaaabiaacaaaajabfaaaakaafaaaaadaaaaacia
acaaaajabgaaaakaafaaaaadaaaaaeiaacaaaajabhaaaakaafaaaaadabaaabia
acaaffjabfaaffkaafaaaaadabaaaciaacaaffjabgaaffkaafaaaaadabaaaeia
acaaffjabhaaffkaacaaaaadaaaaahiaaaaaoeiaabaaoeiaafaaaaadabaaabia
acaakkjabfaakkkaafaaaaadabaaaciaacaakkjabgaakkkaafaaaaadabaaaeia
acaakkjabhaakkkaacaaaaadaaaaahiaaaaaoeiaabaaoeiaceaaaaacabaaahia
aaaaoeiaafaaaaadaaaaabiaabaaffiaabaaffiaaeaaaaaeaaaaabiaabaaaaia
abaaaaiaaaaaaaibafaaaaadacaaapiaabaacjiaabaakeiaajaaaaadadaaabia
afaaoekaacaaoeiaajaaaaadadaaaciaagaaoekaacaaoeiaajaaaaadadaaaeia
ahaaoekaacaaoeiaaeaaaaaeaaaaahiaaiaaoekaaaaaaaiaadaaoeiaabaaaaac
abaaaiiabjaaaakaajaaaaadacaaabiaacaaoekaabaaoeiaajaaaaadacaaacia
adaaoekaabaaoeiaajaaaaadacaaaeiaaeaaoekaabaaoeiaabaaaaacabaaahoa
abaaoeiaacaaaaadadaaahoaaaaaoeiaacaaoeiaafaaaaadaaaaapiaaaaaffja
bcaaoekaaeaaaaaeaaaaapiabbaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapia
bdaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiabeaaoekaaaaappjaaaaaoeia
afaaaaadabaaapiaaaaaffiaakaaoekaaeaaaaaeabaaapiaajaaoekaaaaaaaia
abaaoeiaaeaaaaaeabaaapiaalaaoekaaaaakkiaabaaoeiaaeaaaaaeaeaaapoa
amaaoekaaaaappiaabaaoeiaafaaaaadaaaaapiaaaaaffjaaoaaoekaaeaaaaae
aaaaapiaanaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaapaaoekaaaaakkja
aaaaoeiaaeaaaaaeaaaaapiabaaaoekaaaaappjaaaaaoeiaafaaaaadabaaabia
aaaakkiabiaaaakaafaaaaadabaaabiaabaaaaiaabaaaaibaoaaaaacaaaaaeoa
abaaaaiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaamma
aaaaoeiappppaaaafdeieefcaeahaaaaeaaaabaambabaaaafjaaaaaeegiocaaa
aaaaaaaaamaaaaaafjaaaaaeegiocaaaabaaaaaacnaaaaaafjaaaaaeegiocaaa
acaaaaaaamaaaaaafjaaaaaeegiocaaaadaaaaaabdaaaaaafjaaaaaeegiocaaa
aeaaaaaaacaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaa
fpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
dccabaaaabaaaaaagfaaaaadeccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadpccabaaa
afaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaibcaabaaa
aaaaaaaackaabaaaaaaaaaaaakiacaaaaeaaaaaaabaaaaaadiaaaaaibcaabaaa
aaaaaaaaakaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaabjaaaaafeccabaaa
abaaaaaaakaabaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaaalaaaaaadiaaaaaibcaabaaa
aaaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaabaaaaaaadiaaaaaiccaabaaa
aaaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaabbaaaaaadiaaaaaiecaabaaa
aaaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaabcaaaaaadiaaaaaibcaabaaa
abaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaabaaaaaaadiaaaaaiccaabaaa
abaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaabbaaaaaadiaaaaaiecaabaaa
abaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaabcaaaaaaaaaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaa
ckbabaaaacaaaaaackiacaaaadaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaa
ckbabaaaacaaaaaackiacaaaadaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaa
ckbabaaaacaaaaaackiacaaaadaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaf
hccabaaaacaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaa
aaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
adaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhccabaaaadaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaahbcaabaaaabaaaaaabkaabaaaaaaaaaaabkaabaaa
aaaaaaaadcaaaaakbcaabaaaabaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaa
akaabaiaebaaaaaaabaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaa
egakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaabaaaaaacjaaaaaa
egaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaabaaaaaackaaaaaa
egaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaabaaaaaaclaaaaaa
egaobaaaacaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaabaaaaaacmaaaaaa
agaabaaaabaaaaaaegacbaaaadaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaa
aaaaiadpbbaaaaaibcaabaaaacaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaa
aaaaaaaabbaaaaaiccaabaaaacaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaa
aaaaaaaabbaaaaaiecaabaaaacaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaa
aaaaaaaaaaaaaaahhccabaaaaeaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaanaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaipcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiocaaaacaaaaaaajaaaaaadcaaaaakpcaabaaa
abaaaaaaegiocaaaacaaaaaaaiaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaa
dcaaaaakpcaabaaaabaaaaaaegiocaaaacaaaaaaakaaaaaakgakbaaaaaaaaaaa
egaobaaaabaaaaaadcaaaaakpccabaaaafaaaaaaegiocaaaacaaaaaaalaaaaaa
pgapbaaaaaaaaaaaegaobaaaabaaaaaadoaaaaabejfdeheopaaaaaaaaiaaaaaa
aiaaaaaamiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apadaaaaoaaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaa
acaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaa
adaaaaaaagaaaaaaapaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaa
apaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffied
epepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadamaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaabaaaaaa
aealaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaalmaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaalmaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahaiaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}
SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 192
Vector 176 [_MainTex_ST]
ConstBuffer "UnityLighting" 720
Vector 32 [unity_4LightPosX0]
Vector 48 [unity_4LightPosY0]
Vector 64 [unity_4LightPosZ0]
Vector 80 [unity_4LightAtten0]
Vector 96 [unity_LightColor0]
Vector 112 [unity_LightColor1]
Vector 128 [unity_LightColor2]
Vector 144 [unity_LightColor3]
Vector 160 [unity_LightColor4]
Vector 176 [unity_LightColor5]
Vector 192 [unity_LightColor6]
Vector 208 [unity_LightColor7]
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityShadows" 416
Matrix 128 [unity_World2Shadow0]
Matrix 192 [unity_World2Shadow1]
Matrix 256 [unity_World2Shadow2]
Matrix 320 [unity_World2Shadow3]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
ConstBuffer "UnityFog" 32
Vector 16 [unity_FogParams]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityShadows" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityFog" 4
"vs_4_0_level_9_1
root12:aaafaaaa
eefiecednodjampciepephankfoaclklajajkbgeabaaaaaagmbbaaaaaeaaaaaa
daaaaaaammafaaaakeapaaaajmbaaaaaebgpgodjjeafaaaajeafaaaaaaacpopp
biafaaaahmaaaaaaahaaceaaaaaahiaaaaaahiaaaaaaceaaabaahiaaaaaaalaa
abaaabaaaaaaaaaaabaaacaaaiaaacaaaaaaaaaaabaacgaaahaaakaaaaaaaaaa
acaaaiaaaeaabbaaaaaaaaaaadaaaaaaaeaabfaaaaaaaaaaadaaamaaahaabjaa
aaaaaaaaaeaaabaaabaacaaaaaaaaaaaaaaaaaaaaaacpoppfbaaaaafcbaaapka
aaaaiadpaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaac
afaaaciaacaaapjabpaaaaacafaaadiaadaaapjaaeaaaaaeaaaaadoaadaaoeja
abaaoekaabaaookaafaaaaadaaaaabiaacaaaajabnaaaakaafaaaaadaaaaacia
acaaaajaboaaaakaafaaaaadaaaaaeiaacaaaajabpaaaakaafaaaaadabaaabia
acaaffjabnaaffkaafaaaaadabaaaciaacaaffjaboaaffkaafaaaaadabaaaeia
acaaffjabpaaffkaacaaaaadaaaaahiaaaaaoeiaabaaoeiaafaaaaadabaaabia
acaakkjabnaakkkaafaaaaadabaaaciaacaakkjaboaakkkaafaaaaadabaaaeia
acaakkjabpaakkkaacaaaaadaaaaahiaaaaaoeiaabaaoeiaceaaaaacabaaahia
aaaaoeiaafaaaaadaaaaabiaabaaffiaabaaffiaaeaaaaaeaaaaabiaabaaaaia
abaaaaiaaaaaaaibafaaaaadacaaapiaabaacjiaabaakeiaajaaaaadadaaabia
anaaoekaacaaoeiaajaaaaadadaaaciaaoaaoekaacaaoeiaajaaaaadadaaaeia
apaaoekaacaaoeiaaeaaaaaeaaaaahiabaaaoekaaaaaaaiaadaaoeiaabaaaaac
abaaaiiacbaaaakaajaaaaadacaaabiaakaaoekaabaaoeiaajaaaaadacaaacia
alaaoekaabaaoeiaajaaaaadacaaaeiaamaaoekaabaaoeiaacaaaaadaaaaahia
aaaaoeiaacaaoeiaafaaaaadacaaahiaaaaaffjabkaaoekaaeaaaaaeacaaahia
bjaaoekaaaaaaajaacaaoeiaaeaaaaaeacaaahiablaaoekaaaaakkjaacaaoeia
aeaaaaaeacaaahiabmaaoekaaaaappjaacaaoeiaacaaaaadadaaapiaacaaffib
adaaoekaafaaaaadaeaaapiaabaaffiaadaaoeiaafaaaaadadaaapiaadaaoeia
adaaoeiaacaaaaadafaaapiaacaaaaibacaaoekaaeaaaaaeaeaaapiaafaaoeia
abaaaaiaaeaaoeiaaeaaaaaeadaaapiaafaaoeiaafaaoeiaadaaoeiaacaaaaad
afaaapiaacaakkibaeaaoekaabaaaaacacaaahoaacaaoeiaaeaaaaaeacaaapia
afaaoeiaabaakkiaaeaaoeiaabaaaaacabaaahoaabaaoeiaaeaaaaaeabaaapia
afaaoeiaafaaoeiaadaaoeiaahaaaaacadaaabiaabaaaaiaahaaaaacadaaacia
abaaffiaahaaaaacadaaaeiaabaakkiaahaaaaacadaaaiiaabaappiaabaaaaac
aeaaabiacbaaaakaaeaaaaaeabaaapiaabaaoeiaafaaoekaaeaaaaiaafaaaaad
acaaapiaacaaoeiaadaaoeiaalaaaaadacaaapiaacaaoeiacbaaffkaagaaaaac
adaaabiaabaaaaiaagaaaaacadaaaciaabaaffiaagaaaaacadaaaeiaabaakkia
agaaaaacadaaaiiaabaappiaafaaaaadabaaapiaacaaoeiaadaaoeiaafaaaaad
acaaahiaabaaffiaahaaoekaaeaaaaaeacaaahiaagaaoekaabaaaaiaacaaoeia
aeaaaaaeabaaahiaaiaaoekaabaakkiaacaaoeiaaeaaaaaeabaaahiaajaaoeka
abaappiaabaaoeiaacaaaaadadaaahoaaaaaoeiaabaaoeiaafaaaaadaaaaapia
aaaaffjabkaaoekaaeaaaaaeaaaaapiabjaaoekaaaaaaajaaaaaoeiaaeaaaaae
aaaaapiablaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiabmaaoekaaaaappja
aaaaoeiaafaaaaadabaaapiaaaaaffiabcaaoekaaeaaaaaeabaaapiabbaaoeka
aaaaaaiaabaaoeiaaeaaaaaeabaaapiabdaaoekaaaaakkiaabaaoeiaaeaaaaae
aeaaapoabeaaoekaaaaappiaabaaoeiaafaaaaadaaaaapiaaaaaffjabgaaoeka
aeaaaaaeaaaaapiabfaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiabhaaoeka
aaaakkjaaaaaoeiaaeaaaaaeaaaaapiabiaaoekaaaaappjaaaaaoeiaafaaaaad
abaaabiaaaaakkiacaaaaakaafaaaaadabaaabiaabaaaaiaabaaaaibaoaaaaac
aaaaaeoaabaaaaiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaac
aaaaammaaaaaoeiappppaaaafdeieefcnaajaaaaeaaaabaaheacaaaafjaaaaae
egiocaaaaaaaaaaaamaaaaaafjaaaaaeegiocaaaabaaaaaacnaaaaaafjaaaaae
egiocaaaacaaaaaaamaaaaaafjaaaaaeegiocaaaadaaaaaabdaaaaaafjaaaaae
egiocaaaaeaaaaaaacaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadeccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaad
pccabaaaafaaaaaagiaaaaacagaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
bcaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaaaeaaaaaaabaaaaaadiaaaaai
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaabjaaaaaf
eccabaaaabaaaaaaakaabaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaaalaaaaaadiaaaaai
bcaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaabaaaaaaadiaaaaai
ccaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaabbaaaaaadiaaaaai
ecaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaabcaaaaaadiaaaaai
bcaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaabaaaaaaadiaaaaai
ccaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaabbaaaaaadiaaaaai
ecaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaabcaaaaaaaaaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaadaaaaaabaaaaaaadiaaaaaiccaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaadaaaaaabbaaaaaadiaaaaaiecaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaadaaaaaabcaaaaaaaaaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
dgaaaaafhccabaaaacaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaa
fgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegacbaaaabaaaaaadgaaaaafhccabaaaadaaaaaaegacbaaaabaaaaaa
diaaaaahicaabaaaabaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaak
icaabaaaabaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaadkaabaiaebaaaaaa
abaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaa
bbaaaaaibcaabaaaadaaaaaaegiocaaaabaaaaaacjaaaaaaegaobaaaacaaaaaa
bbaaaaaiccaabaaaadaaaaaaegiocaaaabaaaaaackaaaaaaegaobaaaacaaaaaa
bbaaaaaiecaabaaaadaaaaaaegiocaaaabaaaaaaclaaaaaaegaobaaaacaaaaaa
dcaaaaakhcaabaaaacaaaaaaegiccaaaabaaaaaacmaaaaaapgapbaaaabaaaaaa
egacbaaaadaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaai
bcaabaaaadaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaai
ccaabaaaadaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaai
ecaabaaaadaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaaaaaaaaaaaaaaaaah
hcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaaaaaaaaajpcaabaaa
adaaaaaafgafbaiaebaaaaaaabaaaaaaegiocaaaabaaaaaaadaaaaaadiaaaaah
pcaabaaaaeaaaaaafgafbaaaaaaaaaaaegaobaaaadaaaaaadiaaaaahpcaabaaa
adaaaaaaegaobaaaadaaaaaaegaobaaaadaaaaaaaaaaaaajpcaabaaaafaaaaaa
agaabaiaebaaaaaaabaaaaaaegiocaaaabaaaaaaacaaaaaaaaaaaaajpcaabaaa
abaaaaaakgakbaiaebaaaaaaabaaaaaaegiocaaaabaaaaaaaeaaaaaadcaaaaaj
pcaabaaaaeaaaaaaegaobaaaafaaaaaaagaabaaaaaaaaaaaegaobaaaaeaaaaaa
dcaaaaajpcaabaaaaaaaaaaaegaobaaaabaaaaaakgakbaaaaaaaaaaaegaobaaa
aeaaaaaadcaaaaajpcaabaaaadaaaaaaegaobaaaafaaaaaaegaobaaaafaaaaaa
egaobaaaadaaaaaadcaaaaajpcaabaaaabaaaaaaegaobaaaabaaaaaaegaobaaa
abaaaaaaegaobaaaadaaaaaaeeaaaaafpcaabaaaadaaaaaaegaobaaaabaaaaaa
dcaaaaanpcaabaaaabaaaaaaegaobaaaabaaaaaaegiocaaaabaaaaaaafaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpaoaaaaakpcaabaaaabaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpegaobaaaabaaaaaadiaaaaah
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaadaaaaaadeaaaaakpcaabaaa
aaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
diaaaaahpcaabaaaaaaaaaaaegaobaaaabaaaaaaegaobaaaaaaaaaaadiaaaaai
hcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaabaaaaaaahaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaabaaaaaaagaaaaaaagaabaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaaiaaaaaakgakbaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaa
ajaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaahhccabaaaaeaaaaaa
egacbaaaaaaaaaaaegacbaaaacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaa
acaaaaaaajaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaacaaaaaaaiaaaaaa
agaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaa
acaaaaaaakaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpccabaaa
afaaaaaaegiocaaaacaaaaaaalaaaaaapgapbaaaaaaaaaaaegaobaaaabaaaaaa
doaaaaabejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
apaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaoaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaaabaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaaapaaaaaaojaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdejfeejepeoaafeebeo
ehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheo
miaaaaaaahaaaaaaaiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaa
apaaaaaalmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaa
afaaaaaaaaaaaaaaadaaaaaaabaaaaaaaealaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklkl"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
Vector 4 [_Color]
Vector 2 [_LightColor0]
Float 5 [_Shininess]
Vector 3 [_SpecColor]
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
SetTexture 0 [_MainTex] 2D 0
"ps_2_0
def c6, 0, 128, 1, 0
dcl t0.xy
dcl_pp t1.xyz
dcl t2.xyz
dcl_pp t3.xyz
dcl_2d s0
texld_pp r0, t0, s0
add r1.xyz, -t2, c0
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mad_pp r1.xyz, r1, r1.w, c1
nrm_pp r2.xyz, r1
dp3_pp r1.x, t1, r2
max r2.x, r1.x, c6.x
mov r1.y, c6.y
mul r1.x, r1.y, c5.x
pow r3.w, r2.x, r1.x
mul r0.w, r0.w, r3.w
mul_pp r0.xyz, r0, c4
mov r1.xyz, c2
mul r1.xyz, r1, c3
mul r1.xyz, r0.w, r1
dp3_pp r0.w, t1, c1
max_pp r1.w, r0.w, c6.x
mul_pp r2.xyz, r0, c2
mad_pp r1.xyz, r2, r1.w, r1
mad_pp r0.xyz, r0, t3, r1
mov_pp r0.w, c6.z
mov_pp oC0, r0

"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
SetTexture 0 [_MainTex] 2D 0
ConstBuffer "$Globals" 192
Vector 96 [_LightColor0]
Vector 112 [_SpecColor]
Vector 144 [_Color]
Float 160 [_Shininess]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
"ps_4_0
root12:abadabaa
eefiecedejfljipgipoodkjleppkpnbbfeklcglkabaaaaaagaaeaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcfiadaaaaeaaaaaaangaaaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaa
fjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaa
fkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gcbaaaadhcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaa
aaaaaaajhcaabaaaaaaaaaaaegbcbaiaebaaaaaaadaaaaaaegiccaaaabaaaaaa
aeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaah
icaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaacaaaaaaegacbaaa
aaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaa
cpaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaaiccaabaaaaaaaaaaa
akiacaaaaaaaaaaaakaaaaaaabeaaaaaaaaaaaeddiaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaabkaabaaaaaaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaadkaabaaa
abaaaaaadiaaaaaiocaabaaaaaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaa
ajaaaaaadiaaaaajhcaabaaaabaaaaaaegiccaaaaaaaaaaaagaaaaaaegiccaaa
aaaaaaaaahaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaaibcaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaa
aaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaa
diaaaaaihcaabaaaacaaaaaajgahbaaaaaaaaaaaegiccaaaaaaaaaaaagaaaaaa
dcaaaaajhcaabaaaabaaaaaaegacbaaaacaaaaaaagaabaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaajhccabaaaaaaaaaaajgahbaaaaaaaaaaaegbcbaaaaeaaaaaa
egacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab
"
}
SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
SetTexture 0 [_MainTex] 2D 0
ConstBuffer "$Globals" 192
Vector 96 [_LightColor0]
Vector 112 [_SpecColor]
Vector 144 [_Color]
Float 160 [_Shininess]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
"ps_4_0_level_9_1
root12:abadabaa
eefiecedjicdmdilojfhefnhhfcbikeeokgjkmcbabaaaaaaieagaaaaaeaaaaaa
daaaaaaafaacaaaalaafaaaafaagaaaaebgpgodjbiacaaaabiacaaaaaaacpppp
maabaaaafiaaaaaaaeaaciaaaaaafiaaaaaafiaaabaaceaaaaaafiaaaaaaaaaa
aaaaagaaacaaaaaaaaaaaaaaaaaaajaaacaaacaaaaaaaaaaabaaaeaaabaaaeaa
aaaaaaaaacaaaaaaabaaafaaaaaaaaaaaaacppppfbaaaaafagaaapkaaaaaaaaa
aaaaaaedaaaaiadpaaaaaaaabpaaaaacaaaaaaiaaaaaahlabpaaaaacaaaaaaia
abaachlabpaaaaacaaaaaaiaacaaahlabpaaaaacaaaaaaiaadaachlabpaaaaac
aaaaaajaaaaiapkaecaaaaadaaaacpiaaaaaoelaaaaioekaacaaaaadabaaahia
acaaoelbaeaaoekaaiaaaaadabaaaiiaabaaoeiaabaaoeiaahaaaaacabaaaiia
abaappiaaeaaaaaeabaachiaabaaoeiaabaappiaafaaoekaceaaaaacacaachia
abaaoeiaaiaaaaadabaacbiaabaaoelaacaaoeiaalaaaaadacaaabiaabaaaaia
agaaaakaabaaaaacabaaaciaagaaffkaafaaaaadabaaabiaabaaffiaadaaaaka
caaaaaadadaaaiiaacaaaaiaabaaaaiaafaaaaadaaaaaiiaaaaappiaadaappia
afaaaaadaaaachiaaaaaoeiaacaaoekaabaaaaacabaaahiaaaaaoekaafaaaaad
abaaahiaabaaoeiaabaaoekaafaaaaadabaaahiaaaaappiaabaaoeiaaiaaaaad
aaaaciiaabaaoelaafaaoekaalaaaaadabaaciiaaaaappiaagaaaakaafaaaaad
acaachiaaaaaoeiaaaaaoekaaeaaaaaeabaachiaacaaoeiaabaappiaabaaoeia
aeaaaaaeaaaachiaaaaaoeiaadaaoelaabaaoeiaabaaaaacaaaaciiaagaakkka
abaaaaacaaaicpiaaaaaoeiappppaaaafdeieefcfiadaaaaeaaaaaaangaaaaaa
fjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaa
fjaaaaaeegiocaaaacaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaajhcaabaaaaaaaaaaaegbcbaia
ebaaaaaaadaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaa
egiccaaaacaaaaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaabaaaaaahbcaabaaa
aaaaaaaaegbcbaaaacaaaaaaegacbaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaaiccaabaaaaaaaaaaaakiacaaaaaaaaaaaakaaaaaaabeaaaaa
aaaaaaeddiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaa
bjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaadkaabaaaabaaaaaadiaaaaaiocaabaaaaaaaaaaa
agajbaaaabaaaaaaagijcaaaaaaaaaaaajaaaaaadiaaaaajhcaabaaaabaaaaaa
egiccaaaaaaaaaaaagaaaaaaegiccaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaa
abaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaabaaaaaaibcaabaaaaaaaaaaa
egbcbaaaacaaaaaaegiccaaaacaaaaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaajgahbaaa
aaaaaaaaegiccaaaaaaaaaaaagaaaaaadcaaaaajhcaabaaaabaaaaaaegacbaaa
acaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaajhccabaaaaaaaaaaa
jgahbaaaaaaaaaaaegbcbaaaaeaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaa
aaaaaaaaabeaaaaaaaaaiadpdoaaaaabejfdeheojiaaaaaaafaaaaaaaiaaaaaa
iaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaa
acaaaaaaahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaa
imaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
caaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgf
heaaklkl"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
Vector 4 [_Color]
Vector 2 [_LightColor0]
Float 5 [_Shininess]
Vector 3 [_SpecColor]
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
SetTexture 0 [_ShadowMapTexture] 2D 0
SetTexture 1 [_MainTex] 2D 1
"ps_2_0
def c6, 0, 128, 1, 0
dcl t0.xy
dcl_pp t1.xyz
dcl t2.xyz
dcl_pp t3.xyz
dcl_pp t4
dcl_2d s0
dcl_2d s1
texld_pp r0, t0, s1
texldp_pp r1, t4, s0
add r2.xyz, -t2, c0
dp3 r2.w, r2, r2
rsq r2.w, r2.w
mad_pp r2.xyz, r2, r2.w, c1
nrm_pp r3.xyz, r2
dp3_pp r1.y, t1, r3
max r2.x, r1.y, c6.x
mov r1.y, c6.y
mul r1.y, r1.y, c5.x
pow r3.x, r2.x, r1.y
mul r0.w, r0.w, r3.x
mul_pp r0.xyz, r0, c4
mul_pp r1.xyz, r1.x, c2
mul r2.xyz, r1, c3
mul_pp r1.xyz, r0, r1
mul r2.xyz, r0.w, r2
dp3_pp r0.w, t1, c1
max_pp r1.w, r0.w, c6.x
mad_pp r1.xyz, r1, r1.w, r2
mad_pp r0.xyz, r0, t3, r1
mov_pp r0.w, c6.z
mov_pp oC0, r0

"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_ShadowMapTexture] 2D 0
ConstBuffer "$Globals" 192
Vector 96 [_LightColor0]
Vector 112 [_SpecColor]
Vector 144 [_Color]
Float 160 [_Shininess]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
"ps_4_0
root12:acadacaa
eefiecedppolopemoakpbfagmabmgfgdhimhgoeiabaaaaaapiaeaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcniadaaaa
eaaaaaaapgaaaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaaeegiocaaa
abaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaa
gcbaaaadlcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaa
aaaaaaajhcaabaaaaaaaaaaaegbcbaiaebaaaaaaadaaaaaaegiccaaaabaaaaaa
aeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaah
icaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaacaaaaaaegacbaaa
aaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaa
cpaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaaiccaabaaaaaaaaaaa
akiacaaaaaaaaaaaakaaaaaaabeaaaaaaaaaaaeddiaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaabkaabaaaaaaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaadkaabaaa
abaaaaaadiaaaaaiocaabaaaaaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaa
ajaaaaaaaoaaaaahdcaabaaaabaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
aaaaaaaadiaaaaaihcaabaaaabaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaa
agaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaa
ahaaaaaadiaaaaahhcaabaaaabaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaa
diaaaaahhcaabaaaacaaaaaaagaabaaaaaaaaaaaegacbaaaacaaaaaabaaaaaai
bcaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaaaaaaaaadeaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaadcaaaaajhcaabaaa
abaaaaaaegacbaaaabaaaaaaagaabaaaaaaaaaaaegacbaaaacaaaaaadcaaaaaj
hccabaaaaaaaaaaajgahbaaaaaaaaaaaegbcbaaaaeaaaaaaegacbaaaabaaaaaa
dgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 15 [_ShadowMapTexture] 2D 15
ConstBuffer "$Globals" 192
Vector 96 [_LightColor0]
Vector 112 [_SpecColor]
Vector 144 [_Color]
Float 160 [_Shininess]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityShadows" 416
Vector 384 [_LightShadowData]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityShadows" 3
"ps_4_0_level_9_1
root12:baaebaaa
eefiecedbmlefbfgfmdepecckefdeoodolmlciikabaaaaaamiahaaaaafaaaaaa
deaaaaaakeacaaaammagaaaanmagaaaajeahaaaaebgpgodjgiacaaaagiacaaaa
aaacppppaaacaaaagiaaaaaaafaacmaaaaaagiaaaaaagiaaacaaceaaaaaagiaa
apapaaaaaaaaabaaaaaaagaaacaaaaaaaaaaaaaaaaaaajaaacaaacaaaaaaaaaa
abaaaeaaabaaaeaaaaaaaaaaacaaaaaaabaaafaaaaaaaaaaadaabiaaabaaagaa
aaaaaaaaaaacppppfbaaaaafahaaapkaaaaaiadpaaaaaaaaaaaaaaedaaaaaaaa
bpaaaaacaaaaaaiaaaaaahlabpaaaaacaaaaaaiaabaachlabpaaaaacaaaaaaia
acaaahlabpaaaaacaaaaaaiaadaachlabpaaaaacaaaaaaiaaeaacplabpaaaaac
aaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapkaecaaaaadaaaacpiaaaaaoela
abaioekaecaaaaadabaacpiaaeaaoelaaaaioekaacaaaaadacaaahiaacaaoelb
aeaaoekaaiaaaaadacaaaiiaacaaoeiaacaaoeiaahaaaaacacaaaiiaacaappia
aeaaaaaeacaachiaacaaoeiaacaappiaafaaoekaceaaaaacadaachiaacaaoeia
aiaaaaadabaacciaabaaoelaadaaoeiaalaaaaadacaaabiaabaaffiaahaaffka
abaaaaacadaaafiaahaaoekaafaaaaadabaaaciaadaakkiaadaaaakacaaaaaad
adaaaciaacaaaaiaabaaffiaafaaaaadaaaaaiiaaaaappiaadaaffiaafaaaaad
aaaachiaaaaaoeiaacaaoekabcaaaaaeacaacbiaabaaaaiaadaaaaiaagaaaaka
afaaaaadabaachiaacaaaaiaaaaaoekaafaaaaadacaaahiaabaaoeiaabaaoeka
afaaaaadabaachiaaaaaoeiaabaaoeiaafaaaaadacaaahiaaaaappiaacaaoeia
aiaaaaadaaaaciiaabaaoelaafaaoekaalaaaaadabaaciiaaaaappiaahaaffka
aeaaaaaeabaachiaabaaoeiaabaappiaacaaoeiaaeaaaaaeaaaachiaaaaaoeia
adaaoelaabaaoeiaabaaaaacaaaaciiaahaaaakaabaaaaacaaaicpiaaaaaoeia
ppppaaaafdeieefccaaeaaaaeaaaaaaaaiabaaaafjaaaaaeegiocaaaaaaaaaaa
alaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
abaaaaaafjaaaaaeegiocaaaadaaaaaabjaaaaaafkaaaaadaagabaaaaaaaaaaa
fkaiaaadaagabaaaapaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaapaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaad
hcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaaj
hcaabaaaaaaaaaaaegbcbaiaebaaaaaaadaaaaaaegiccaaaabaaaaaaaeaaaaaa
baaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgapbaaaaaaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaacaaaaaaegacbaaaaaaaaaaa
deaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaaiccaabaaaaaaaaaaaakiacaaa
aaaaaaaaakaaaaaaabeaaaaaaaaaaaeddiaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaabkaabaaaaaaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaadkaabaaaabaaaaaa
diaaaaaiocaabaaaaaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaaajaaaaaa
ehaaaaalbcaabaaaabaaaaaaegbabaaaafaaaaaaaghabaaaapaaaaaaaagabaaa
apaaaaaackbabaaaafaaaaaaaaaaaaajccaabaaaabaaaaaaakiacaiaebaaaaaa
adaaaaaabiaaaaaaabeaaaaaaaaaiadpdcaaaaakbcaabaaaabaaaaaaakaabaaa
abaaaaaabkaabaaaabaaaaaaakiacaaaadaaaaaabiaaaaaadiaaaaaihcaabaaa
abaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaaagaaaaaadiaaaaaihcaabaaa
acaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaa
abaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaahhcaabaaaacaaaaaa
agaabaaaaaaaaaaaegacbaaaacaaaaaabaaaaaaibcaabaaaaaaaaaaaegbcbaaa
acaaaaaaegiccaaaacaaaaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaaaaaaaaaadcaaaaajhcaabaaaabaaaaaaegacbaaaabaaaaaa
agaabaaaaaaaaaaaegacbaaaacaaaaaadcaaaaajhccabaaaaaaaaaaajgahbaaa
aaaaaaaaegbcbaaaaeaaaaaaegacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaiadpdoaaaaabfdegejdaaiaaaaaaiaaaaaaaaaaaaaaaejfdeheo
laaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaa
apaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaakeaaaaaa
abaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaaacaaaaaaaaaaaaaa
adaaaaaaadaaaaaaahahaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
ahahaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklkl"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" }
Vector 5 [_Color]
Vector 3 [_LightColor0]
Float 6 [_Shininess]
Vector 4 [_SpecColor]
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [unity_FogColor]
SetTexture 0 [_MainTex] 2D 0
"ps_2_0
def c7, 0, 128, 1, 0
dcl t0.xy
dcl_pp t1.xyz
dcl t2.xyz
dcl_pp t3.xyz
dcl t5.x
dcl_2d s0
texld_pp r0, t0, s0
add r1.xyz, -t2, c0
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mad_pp r1.xyz, r1, r1.w, c1
nrm_pp r2.xyz, r1
dp3_pp r1.x, t1, r2
max r2.x, r1.x, c7.x
mov r1.y, c7.y
mul r1.x, r1.y, c6.x
pow r3.w, r2.x, r1.x
mul r0.w, r0.w, r3.w
mul_pp r0.xyz, r0, c5
mov r1.xyz, c3
mul r1.xyz, r1, c4
mul r1.xyz, r0.w, r1
dp3_pp r0.w, t1, c1
max_pp r1.w, r0.w, c7.x
mul_pp r2.xyz, r0, c3
mad_pp r1.xyz, r2, r1.w, r1
mad_pp r0.xyz, r0, t3, r1
mov_sat r0.w, t5.x
lrp_pp r1.xyz, r0.w, r0, c2
mov r1.w, c7.z
mov_pp oC0, r1

"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" }
SetTexture 0 [_MainTex] 2D 0
ConstBuffer "$Globals" 192
Vector 96 [_LightColor0]
Vector 112 [_SpecColor]
Vector 144 [_Color]
Float 160 [_Shininess]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityFog" 32
Vector 0 [unity_FogColor]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityFog" 3
"ps_4_0
root12:abaeabaa
eefiecedkabhkimolhfdpflkeagdlkbhlcepognpabaaaaaapeaeaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaafaaaaaaaaaaaaaaadaaaaaaabaaaaaa
aeaeaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcneadaaaa
eaaaaaaapfaaaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaaeegiocaaa
abaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaa
adaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadecbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaajhcaabaaaaaaaaaaa
egbcbaiaebaaaaaaadaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaa
aaaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaabaaaaaah
bcaabaaaaaaaaaaaegbcbaaaacaaaaaaegacbaaaaaaaaaaadeaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaadiaaaaaiccaabaaaaaaaaaaaakiacaaaaaaaaaaaakaaaaaa
abeaaaaaaaaaaaeddiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaa
aaaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadkaabaaaabaaaaaadiaaaaaiocaabaaa
aaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaaajaaaaaadiaaaaajhcaabaaa
abaaaaaaegiccaaaaaaaaaaaagaaaaaaegiccaaaaaaaaaaaahaaaaaadiaaaaah
hcaabaaaabaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaabaaaaaaibcaabaaa
aaaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaaaaaaaaadeaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaa
jgahbaaaaaaaaaaaegiccaaaaaaaaaaaagaaaaaadcaaaaajhcaabaaaabaaaaaa
egacbaaaacaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaajhcaabaaa
aaaaaaaajgahbaaaaaaaaaaaegbcbaaaaeaaaaaaegacbaaaabaaaaaaaaaaaaaj
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaiaebaaaaaaadaaaaaaaaaaaaaa
dgcaaaaficaabaaaaaaaaaaackbabaaaabaaaaaadcaaaaakhccabaaaaaaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaadaaaaaaaaaaaaaadgaaaaaf
iccabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" }
SetTexture 0 [_MainTex] 2D 0
ConstBuffer "$Globals" 192
Vector 96 [_LightColor0]
Vector 112 [_SpecColor]
Vector 144 [_Color]
Float 160 [_Shininess]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityFog" 32
Vector 0 [unity_FogColor]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityFog" 3
"ps_4_0_level_9_1
root12:abaeabaa
eefiecedmibkhecnfofoidcpnnafbcnalcelfkfdabaaaaaaeeahaaaaaeaaaaaa
daaaaaaahmacaaaafiagaaaabaahaaaaebgpgodjeeacaaaaeeacaaaaaaacpppp
oaabaaaageaaaaaaafaaciaaaaaageaaaaaageaaabaaceaaaaaageaaaaaaaaaa
aaaaagaaacaaaaaaaaaaaaaaaaaaajaaacaaacaaaaaaaaaaabaaaeaaabaaaeaa
aaaaaaaaacaaaaaaabaaafaaaaaaaaaaadaaaaaaabaaagaaaaaaaaaaaaacpppp
fbaaaaafahaaapkaaaaaaaaaaaaaaaedaaaaiadpaaaaaaaabpaaaaacaaaaaaia
aaaaahlabpaaaaacaaaaaaiaabaachlabpaaaaacaaaaaaiaacaaahlabpaaaaac
aaaaaaiaadaachlabpaaaaacaaaaaajaaaaiapkaecaaaaadaaaacpiaaaaaoela
aaaioekaacaaaaadabaaahiaacaaoelbaeaaoekaaiaaaaadabaaaiiaabaaoeia
abaaoeiaahaaaaacabaaaiiaabaappiaaeaaaaaeabaachiaabaaoeiaabaappia
afaaoekaceaaaaacacaachiaabaaoeiaaiaaaaadabaacbiaabaaoelaacaaoeia
alaaaaadacaaabiaabaaaaiaahaaaakaabaaaaacabaaaciaahaaffkaafaaaaad
abaaabiaabaaffiaadaaaakacaaaaaadadaaaiiaacaaaaiaabaaaaiaafaaaaad
aaaaaiiaaaaappiaadaappiaafaaaaadaaaachiaaaaaoeiaacaaoekaabaaaaac
abaaahiaaaaaoekaafaaaaadabaaahiaabaaoeiaabaaoekaafaaaaadabaaahia
aaaappiaabaaoeiaaiaaaaadaaaaciiaabaaoelaafaaoekaalaaaaadabaaciia
aaaappiaahaaaakaafaaaaadacaachiaaaaaoeiaaaaaoekaaeaaaaaeabaachia
acaaoeiaabaappiaabaaoeiaaeaaaaaeaaaachiaaaaaoeiaadaaoelaabaaoeia
abaaaaacaaaabiiaaaaakklabcaaaaaeabaachiaaaaappiaaaaaoeiaagaaoeka
abaaaaacabaaciiaahaakkkaabaaaaacaaaicpiaabaaoeiappppaaaafdeieefc
neadaaaaeaaaaaaapfaaaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaae
egiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaae
egiocaaaadaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadecbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaa
aeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaajhcaabaaa
aaaaaaaaegbcbaiaebaaaaaaadaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaah
icaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgapbaaaaaaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
baaaaaahbcaabaaaaaaaaaaaegbcbaaaacaaaaaaegacbaaaaaaaaaaadeaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaadiaaaaaiccaabaaaaaaaaaaaakiacaaaaaaaaaaa
akaaaaaaabeaaaaaaaaaaaeddiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
bkaabaaaaaaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaaj
pcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
diaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaadkaabaaaabaaaaaadiaaaaai
ocaabaaaaaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaaajaaaaaadiaaaaaj
hcaabaaaabaaaaaaegiccaaaaaaaaaaaagaaaaaaegiccaaaaaaaaaaaahaaaaaa
diaaaaahhcaabaaaabaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaabaaaaaai
bcaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaaaaaaaaadeaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaadiaaaaaihcaabaaa
acaaaaaajgahbaaaaaaaaaaaegiccaaaaaaaaaaaagaaaaaadcaaaaajhcaabaaa
abaaaaaaegacbaaaacaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaaj
hcaabaaaaaaaaaaajgahbaaaaaaaaaaaegbcbaaaaeaaaaaaegacbaaaabaaaaaa
aaaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaiaebaaaaaaadaaaaaa
aaaaaaaadgcaaaaficaabaaaaaaaaaaackbabaaaabaaaaaadcaaaaakhccabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaadaaaaaaaaaaaaaa
dgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaabejfdeheolaaaaaaa
agaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
keaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaakeaaaaaaafaaaaaa
aaaaaaaaadaaaaaaabaaaaaaaeaeaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaa
acaaaaaaahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaa
keaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
caaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgf
heaaklkl"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" }
Vector 5 [_Color]
Vector 3 [_LightColor0]
Float 6 [_Shininess]
Vector 4 [_SpecColor]
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [unity_FogColor]
SetTexture 0 [_ShadowMapTexture] 2D 0
SetTexture 1 [_MainTex] 2D 1
"ps_2_0
def c7, 0, 128, 1, 0
dcl t0.xy
dcl_pp t1.xyz
dcl t2.xyz
dcl_pp t3.xyz
dcl_pp t4
dcl t5.x
dcl_2d s0
dcl_2d s1
texld_pp r0, t0, s1
texldp_pp r1, t4, s0
add r2.xyz, -t2, c0
dp3 r2.w, r2, r2
rsq r2.w, r2.w
mad_pp r2.xyz, r2, r2.w, c1
nrm_pp r3.xyz, r2
dp3_pp r1.y, t1, r3
max r2.x, r1.y, c7.x
mov r1.y, c7.y
mul r1.y, r1.y, c6.x
pow r3.x, r2.x, r1.y
mul r0.w, r0.w, r3.x
mul_pp r0.xyz, r0, c5
mul_pp r1.xyz, r1.x, c3
mul r2.xyz, r1, c4
mul_pp r1.xyz, r0, r1
mul r2.xyz, r0.w, r2
dp3_pp r0.w, t1, c1
max_pp r1.w, r0.w, c7.x
mad_pp r1.xyz, r1, r1.w, r2
mad_pp r0.xyz, r0, t3, r1
mov_sat r0.w, t5.x
lrp_pp r1.xyz, r0.w, r0, c2
mov_pp r1.w, c7.z
mov_pp oC0, r1

"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_ShadowMapTexture] 2D 0
ConstBuffer "$Globals" 192
Vector 96 [_LightColor0]
Vector 112 [_SpecColor]
Vector 144 [_Color]
Float 160 [_Shininess]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityFog" 32
Vector 0 [unity_FogColor]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityFog" 3
"ps_4_0
root12:acaeacaa
eefiecedpanjgmnhbehjlkopgalkpbemjigkkpceabaaaaaaimafaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaabaaaaaa
aeaeaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalmaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
apalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcfeaeaaaaeaaaaaaabfabaaaa
fjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaa
fjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaaabaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadecbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
hcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadlcbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaajhcaabaaaaaaaaaaa
egbcbaiaebaaaaaaadaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaa
aaaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaabaaaaaah
bcaabaaaaaaaaaaaegbcbaaaacaaaaaaegacbaaaaaaaaaaadeaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaadiaaaaaiccaabaaaaaaaaaaaakiacaaaaaaaaaaaakaaaaaa
abeaaaaaaaaaaaeddiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaa
aaaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadkaabaaaabaaaaaadiaaaaaiocaabaaa
aaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaaajaaaaaaaoaaaaahdcaabaaa
abaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaaefaaaaajpcaabaaaabaaaaaa
egaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaadiaaaaaihcaabaaa
abaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaaagaaaaaadiaaaaaihcaabaaa
acaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaa
abaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaahhcaabaaaacaaaaaa
agaabaaaaaaaaaaaegacbaaaacaaaaaabaaaaaaibcaabaaaaaaaaaaaegbcbaaa
acaaaaaaegiccaaaacaaaaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaaaaaaaaaadcaaaaajhcaabaaaabaaaaaaegacbaaaabaaaaaa
agaabaaaaaaaaaaaegacbaaaacaaaaaadcaaaaajhcaabaaaaaaaaaaajgahbaaa
aaaaaaaaegbcbaaaaeaaaaaaegacbaaaabaaaaaaaaaaaaajhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegiccaiaebaaaaaaadaaaaaaaaaaaaaadgcaaaaficaabaaa
aaaaaaaackbabaaaabaaaaaadcaaaaakhccabaaaaaaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaaegiccaaaadaaaaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 15 [_ShadowMapTexture] 2D 15
ConstBuffer "$Globals" 192
Vector 96 [_LightColor0]
Vector 112 [_SpecColor]
Vector 144 [_Color]
Float 160 [_Shininess]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
ConstBuffer "UnityShadows" 416
Vector 384 [_LightShadowData]
ConstBuffer "UnityFog" 32
Vector 0 [unity_FogColor]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityShadows" 3
BindCB  "UnityFog" 4
"ps_4_0_level_9_1
root12:baafbaaa
eefiecedlageblkhaaanalijnilgihmhhippfbedabaaaaaaiiaiaaaaafaaaaaa
deaaaaaanaacaaaaheahaaaaieahaaaafeaiaaaaebgpgodjjeacaaaajeacaaaa
aaacppppcaacaaaaheaaaaaaagaacmaaaaaaheaaaaaaheaaacaaceaaaaaaheaa
apapaaaaaaaaabaaaaaaagaaacaaaaaaaaaaaaaaaaaaajaaacaaacaaaaaaaaaa
abaaaeaaabaaaeaaaaaaaaaaacaaaaaaabaaafaaaaaaaaaaadaabiaaabaaagaa
aaaaaaaaaeaaaaaaabaaahaaaaaaaaaaaaacppppfbaaaaafaiaaapkaaaaaiadp
aaaaaaaaaaaaaaedaaaaaaaabpaaaaacaaaaaaiaaaaaahlabpaaaaacaaaaaaia
abaachlabpaaaaacaaaaaaiaacaaahlabpaaaaacaaaaaaiaadaachlabpaaaaac
aaaaaaiaaeaacplabpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapka
ecaaaaadaaaacpiaaaaaoelaabaioekaecaaaaadabaacpiaaeaaoelaaaaioeka
acaaaaadacaaahiaacaaoelbaeaaoekaaiaaaaadacaaaiiaacaaoeiaacaaoeia
ahaaaaacacaaaiiaacaappiaaeaaaaaeacaachiaacaaoeiaacaappiaafaaoeka
ceaaaaacadaachiaacaaoeiaaiaaaaadabaacciaabaaoelaadaaoeiaalaaaaad
acaaabiaabaaffiaaiaaffkaabaaaaacadaaafiaaiaaoekaafaaaaadabaaacia
adaakkiaadaaaakacaaaaaadadaaaciaacaaaaiaabaaffiaafaaaaadaaaaaiia
aaaappiaadaaffiaafaaaaadaaaachiaaaaaoeiaacaaoekabcaaaaaeacaacbia
abaaaaiaadaaaaiaagaaaakaafaaaaadabaachiaacaaaaiaaaaaoekaafaaaaad
acaaahiaabaaoeiaabaaoekaafaaaaadabaachiaaaaaoeiaabaaoeiaafaaaaad
acaaahiaaaaappiaacaaoeiaaiaaaaadaaaaciiaabaaoelaafaaoekaalaaaaad
abaaciiaaaaappiaaiaaffkaaeaaaaaeabaachiaabaaoeiaabaappiaacaaoeia
aeaaaaaeaaaachiaaaaaoeiaadaaoelaabaaoeiaabaaaaacaaaabiiaaaaakkla
bcaaaaaeabaachiaaaaappiaaaaaoeiaahaaoekaabaaaaacabaaciiaaiaaaaka
abaaaaacaaaicpiaabaaoeiappppaaaafdeieefcjmaeaaaaeaaaaaaachabaaaa
fjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaa
fjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaabjaaaaaa
fjaaaaaeegiocaaaaeaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaiaaad
aagabaaaapaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
apaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadecbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaa
aeaaaaaagcbaaaadhcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
adaaaaaaaaaaaaajhcaabaaaaaaaaaaaegbcbaiaebaaaaaaadaaaaaaegiccaaa
abaaaaaaaeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
aaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaacaaaaaaaaaaaaaa
baaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaacaaaaaa
egacbaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaaiccaabaaa
aaaaaaaaakiacaaaaaaaaaaaakaaaaaaabeaaaaaaaaaaaeddiaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaabjaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
dkaabaaaabaaaaaadiaaaaaiocaabaaaaaaaaaaaagajbaaaabaaaaaaagijcaaa
aaaaaaaaajaaaaaaehaaaaalbcaabaaaabaaaaaaegbabaaaafaaaaaaaghabaaa
apaaaaaaaagabaaaapaaaaaackbabaaaafaaaaaaaaaaaaajccaabaaaabaaaaaa
akiacaiaebaaaaaaadaaaaaabiaaaaaaabeaaaaaaaaaiadpdcaaaaakbcaabaaa
abaaaaaaakaabaaaabaaaaaabkaabaaaabaaaaaaakiacaaaadaaaaaabiaaaaaa
diaaaaaihcaabaaaabaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaaagaaaaaa
diaaaaaihcaabaaaacaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaa
diaaaaahhcaabaaaabaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaah
hcaabaaaacaaaaaaagaabaaaaaaaaaaaegacbaaaacaaaaaabaaaaaaibcaabaaa
aaaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaaaaaaaaadeaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaadcaaaaajhcaabaaaabaaaaaa
egacbaaaabaaaaaaagaabaaaaaaaaaaaegacbaaaacaaaaaadcaaaaajhcaabaaa
aaaaaaaajgahbaaaaaaaaaaaegbcbaaaaeaaaaaaegacbaaaabaaaaaaaaaaaaaj
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaiaebaaaaaaaeaaaaaaaaaaaaaa
dgcaaaaficaabaaaaaaaaaaackbabaaaabaaaaaadcaaaaakhccabaaaaaaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaeaaaaaaaaaaaaaadgaaaaaf
iccabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaabfdegejdaaiaaaaaaiaaaaaaa
aaaaaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adadaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaabaaaaaaaeaeaaaalmaaaaaa
abaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalmaaaaaaacaaaaaaaaaaaaaa
adaaaaaaadaaaaaaahahaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
ahahaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklkl"
}
}
 }
 Pass {
  Name "FORWARD"
  Tags { "LIGHTMODE"="ForwardAdd" "RenderType"="Opaque" }
  ZWrite Off
  Blend One One
  GpuProgramID 90160
Program "vp" {
SubProgram "opengl " {
Keywords { "POINT" }
"!!GLSL#version 120

#ifdef VERTEX

uniform mat4 _Object2World;
uniform mat4 _World2Object;
uniform vec4 _MainTex_ST;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
void main ()
{
  vec4 v_1;
  v_1.x = _World2Object[0].x;
  v_1.y = _World2Object[1].x;
  v_1.z = _World2Object[2].x;
  v_1.w = _World2Object[3].x;
  vec4 v_2;
  v_2.x = _World2Object[0].y;
  v_2.y = _World2Object[1].y;
  v_2.z = _World2Object[2].y;
  v_2.w = _World2Object[3].y;
  vec4 v_3;
  v_3.x = _World2Object[0].z;
  v_3.y = _World2Object[1].z;
  v_3.z = _World2Object[2].z;
  v_3.w = _World2Object[3].z;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = normalize(((
    (v_1.xyz * gl_Normal.x)
   + 
    (v_2.xyz * gl_Normal.y)
  ) + (v_3.xyz * gl_Normal.z)));
  xlv_TEXCOORD2 = (_Object2World * gl_Vertex).xyz;
}


#endif
#ifdef FRAGMENT
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _LightColor0;
uniform vec4 _SpecColor;
uniform sampler2D _LightTexture0;
uniform mat4 _LightMatrix0;
uniform sampler2D _MainTex;
uniform vec4 _Color;
uniform float _Shininess;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
void main ()
{
  vec3 tmpvar_1;
  vec3 tmpvar_2;
  vec4 c_3;
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = xlv_TEXCOORD2;
  vec3 tmpvar_6;
  tmpvar_6 = (_LightMatrix0 * tmpvar_5).xyz;
  tmpvar_2 = normalize((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD2));
  tmpvar_1 = (_LightColor0.xyz * texture2D (_LightTexture0, vec2(dot (tmpvar_6, tmpvar_6))).w);
  vec4 c_7;
  vec4 c_8;
  c_8.xyz = (((
    (tmpvar_4.xyz * _Color.xyz)
   * tmpvar_1) * max (0.0, 
    dot (xlv_TEXCOORD1, tmpvar_2)
  )) + ((tmpvar_1 * _SpecColor.xyz) * (
    pow (max (0.0, dot (xlv_TEXCOORD1, normalize(
      (tmpvar_2 + normalize((_WorldSpaceCameraPos - xlv_TEXCOORD2)))
    ))), (_Shininess * 128.0))
   * tmpvar_4.w)));
  c_8.w = (tmpvar_4.w * _Color.w);
  c_7.w = c_8.w;
  c_7.xyz = c_8.xyz;
  c_3.xyz = c_7.xyz;
  c_3.w = 1.0;
  gl_FragData[0] = c_3;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 4 [_Object2World] 3
Matrix 7 [_World2Object] 3
Matrix 0 [glstate_matrix_mvp]
Vector 10 [_MainTex_ST]
"vs_2_0
dcl_position v0
dcl_normal v1
dcl_texcoord v2
dp4 oPos.x, c0, v0
dp4 oPos.y, c1, v0
dp4 oPos.z, c2, v0
dp4 oPos.w, c3, v0
mad oT0.xy, v2, c10, c10.zwzw
dp4 oT2.x, c4, v0
dp4 oT2.y, c5, v0
dp4 oT2.z, c6, v0
mul r0.xyz, v1.y, c8
mad r0.xyz, c7, v1.x, r0
mad r0.xyz, c9, v1.z, r0
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul oT1.xyz, r0.w, r0

"
}
SubProgram "d3d11 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 256
Vector 240 [_MainTex_ST]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
root12:aaacaaaa
eefiecedcclnehojdkibdcbfmlpdnknanopapjmiabaaaaaaeaafaaaaadaaaaaa
cmaaaaaaceabaaaakmabaaaaejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaheaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcimadaaaaeaaaabaaodaaaaaafjaaaaae
egiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaabdaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaa
diaaaaaibcaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabaaaaaaa
diaaaaaiccaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabbaaaaaa
diaaaaaiecaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabcaaaaaa
diaaaaaibcaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabaaaaaaa
diaaaaaiccaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabbaaaaaa
diaaaaaiecaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabcaaaaaa
aaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaai
bcaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabaaaaaaadiaaaaai
ccaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabbaaaaaadiaaaaai
ecaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabcaaaaaaaaaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhccabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaabaaaaaa
anaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhccabaaaadaaaaaa
egiccaaaabaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}
SubProgram "d3d11_9x " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 256
Vector 240 [_MainTex_ST]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0_level_9_1
root12:aaacaaaa
eefiecedblpiibknlikpnajeagnpbhedmfnpomimabaaaaaagmahaaaaaeaaaaaa
daaaaaaafiacaaaaomafaaaaoeagaaaaebgpgodjcaacaaaacaacaaaaaaacpopp
neabaaaaemaaaaaaadaaceaaaaaaeiaaaaaaeiaaaaaaceaaabaaeiaaaaaaapaa
abaaabaaaaaaaaaaabaaaaaaaeaaacaaaaaaaaaaabaaamaaahaaagaaaaaaaaaa
aaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaciaacaaapja
bpaaaaacafaaadiaadaaapjaaeaaaaaeaaaaadoaadaaoejaabaaoekaabaaooka
afaaaaadaaaaahiaaaaaffjaahaaoekaaeaaaaaeaaaaahiaagaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaahiaaiaaoekaaaaakkjaaaaaoeiaaeaaaaaeacaaahoa
ajaaoekaaaaappjaaaaaoeiaafaaaaadaaaaabiaacaaaajaakaaaakaafaaaaad
aaaaaciaacaaaajaalaaaakaafaaaaadaaaaaeiaacaaaajaamaaaakaafaaaaad
abaaabiaacaaffjaakaaffkaafaaaaadabaaaciaacaaffjaalaaffkaafaaaaad
abaaaeiaacaaffjaamaaffkaacaaaaadaaaaahiaaaaaoeiaabaaoeiaafaaaaad
abaaabiaacaakkjaakaakkkaafaaaaadabaaaciaacaakkjaalaakkkaafaaaaad
abaaaeiaacaakkjaamaakkkaacaaaaadaaaaahiaaaaaoeiaabaaoeiaaiaaaaad
aaaaaiiaaaaaoeiaaaaaoeiaahaaaaacaaaaaiiaaaaappiaafaaaaadabaaahoa
aaaappiaaaaaoeiaafaaaaadaaaaapiaaaaaffjaadaaoekaaeaaaaaeaaaaapia
acaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaaeaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiaafaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappia
aaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefcimadaaaa
eaaaabaaodaaaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaa
abaaaaaabdaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaa
fpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
dccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaapaaaaaa
ogikcaaaaaaaaaaaapaaaaaadiaaaaaibcaabaaaaaaaaaaaakbabaaaacaaaaaa
akiacaaaabaaaaaabaaaaaaadiaaaaaiccaabaaaaaaaaaaaakbabaaaacaaaaaa
akiacaaaabaaaaaabbaaaaaadiaaaaaiecaabaaaaaaaaaaaakbabaaaacaaaaaa
akiacaaaabaaaaaabcaaaaaadiaaaaaibcaabaaaabaaaaaabkbabaaaacaaaaaa
bkiacaaaabaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaabkbabaaaacaaaaaa
bkiacaaaabaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaabkbabaaaacaaaaaa
bkiacaaaabaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaacaaaaaackiacaaa
abaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaacaaaaaackiacaaa
abaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaacaaaaaackiacaaa
abaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaaacaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiccaaaabaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
abaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaabaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhccabaaaadaaaaaaegiccaaaabaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egacbaaaaaaaaaaadoaaaaabejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaheaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklkl"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
"!!GLSL#version 120

#ifdef VERTEX

uniform mat4 _Object2World;
uniform mat4 _World2Object;
uniform vec4 _MainTex_ST;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
void main ()
{
  vec4 v_1;
  v_1.x = _World2Object[0].x;
  v_1.y = _World2Object[1].x;
  v_1.z = _World2Object[2].x;
  v_1.w = _World2Object[3].x;
  vec4 v_2;
  v_2.x = _World2Object[0].y;
  v_2.y = _World2Object[1].y;
  v_2.z = _World2Object[2].y;
  v_2.w = _World2Object[3].y;
  vec4 v_3;
  v_3.x = _World2Object[0].z;
  v_3.y = _World2Object[1].z;
  v_3.z = _World2Object[2].z;
  v_3.w = _World2Object[3].z;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = normalize(((
    (v_1.xyz * gl_Normal.x)
   + 
    (v_2.xyz * gl_Normal.y)
  ) + (v_3.xyz * gl_Normal.z)));
  xlv_TEXCOORD2 = (_Object2World * gl_Vertex).xyz;
}


#endif
#ifdef FRAGMENT
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _LightColor0;
uniform vec4 _SpecColor;
uniform sampler2D _MainTex;
uniform vec4 _Color;
uniform float _Shininess;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
void main ()
{
  vec4 c_1;
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec4 c_3;
  vec4 c_4;
  c_4.xyz = (((
    (tmpvar_2.xyz * _Color.xyz)
   * _LightColor0.xyz) * max (0.0, 
    dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)
  )) + ((_LightColor0.xyz * _SpecColor.xyz) * (
    pow (max (0.0, dot (xlv_TEXCOORD1, normalize(
      (_WorldSpaceLightPos0.xyz + normalize((_WorldSpaceCameraPos - xlv_TEXCOORD2)))
    ))), (_Shininess * 128.0))
   * tmpvar_2.w)));
  c_4.w = (tmpvar_2.w * _Color.w);
  c_3.w = c_4.w;
  c_3.xyz = c_4.xyz;
  c_1.xyz = c_3.xyz;
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 4 [_Object2World] 3
Matrix 7 [_World2Object] 3
Matrix 0 [glstate_matrix_mvp]
Vector 10 [_MainTex_ST]
"vs_2_0
dcl_position v0
dcl_normal v1
dcl_texcoord v2
dp4 oPos.x, c0, v0
dp4 oPos.y, c1, v0
dp4 oPos.z, c2, v0
dp4 oPos.w, c3, v0
mad oT0.xy, v2, c10, c10.zwzw
dp4 oT2.x, c4, v0
dp4 oT2.y, c5, v0
dp4 oT2.z, c6, v0
mul r0.xyz, v1.y, c8
mad r0.xyz, c7, v1.x, r0
mad r0.xyz, c9, v1.z, r0
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul oT1.xyz, r0.w, r0

"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 192
Vector 176 [_MainTex_ST]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
root12:aaacaaaa
eefiecedmjknhbnjnicgnicnimimedndifdeoepaabaaaaaaeaafaaaaadaaaaaa
cmaaaaaaceabaaaakmabaaaaejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaheaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcimadaaaaeaaaabaaodaaaaaafjaaaaae
egiocaaaaaaaaaaaamaaaaaafjaaaaaeegiocaaaabaaaaaabdaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaaalaaaaaa
diaaaaaibcaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabaaaaaaa
diaaaaaiccaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabbaaaaaa
diaaaaaiecaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabcaaaaaa
diaaaaaibcaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabaaaaaaa
diaaaaaiccaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabbaaaaaa
diaaaaaiecaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabcaaaaaa
aaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaai
bcaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabaaaaaaadiaaaaai
ccaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabbaaaaaadiaaaaai
ecaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabcaaaaaaaaaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhccabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaabaaaaaa
anaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhccabaaaadaaaaaa
egiccaaaabaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}
SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 192
Vector 176 [_MainTex_ST]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0_level_9_1
root12:aaacaaaa
eefiecedhdiflfjodnildjalloefgmfginbaennaabaaaaaagmahaaaaaeaaaaaa
daaaaaaafiacaaaaomafaaaaoeagaaaaebgpgodjcaacaaaacaacaaaaaaacpopp
neabaaaaemaaaaaaadaaceaaaaaaeiaaaaaaeiaaaaaaceaaabaaeiaaaaaaalaa
abaaabaaaaaaaaaaabaaaaaaaeaaacaaaaaaaaaaabaaamaaahaaagaaaaaaaaaa
aaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaciaacaaapja
bpaaaaacafaaadiaadaaapjaaeaaaaaeaaaaadoaadaaoejaabaaoekaabaaooka
afaaaaadaaaaahiaaaaaffjaahaaoekaaeaaaaaeaaaaahiaagaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaahiaaiaaoekaaaaakkjaaaaaoeiaaeaaaaaeacaaahoa
ajaaoekaaaaappjaaaaaoeiaafaaaaadaaaaabiaacaaaajaakaaaakaafaaaaad
aaaaaciaacaaaajaalaaaakaafaaaaadaaaaaeiaacaaaajaamaaaakaafaaaaad
abaaabiaacaaffjaakaaffkaafaaaaadabaaaciaacaaffjaalaaffkaafaaaaad
abaaaeiaacaaffjaamaaffkaacaaaaadaaaaahiaaaaaoeiaabaaoeiaafaaaaad
abaaabiaacaakkjaakaakkkaafaaaaadabaaaciaacaakkjaalaakkkaafaaaaad
abaaaeiaacaakkjaamaakkkaacaaaaadaaaaahiaaaaaoeiaabaaoeiaaiaaaaad
aaaaaiiaaaaaoeiaaaaaoeiaahaaaaacaaaaaiiaaaaappiaafaaaaadabaaahoa
aaaappiaaaaaoeiaafaaaaadaaaaapiaaaaaffjaadaaoekaaeaaaaaeaaaaapia
acaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaaeaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiaafaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappia
aaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefcimadaaaa
eaaaabaaodaaaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaaeegiocaaa
abaaaaaabdaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaa
fpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
dccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaa
ogikcaaaaaaaaaaaalaaaaaadiaaaaaibcaabaaaaaaaaaaaakbabaaaacaaaaaa
akiacaaaabaaaaaabaaaaaaadiaaaaaiccaabaaaaaaaaaaaakbabaaaacaaaaaa
akiacaaaabaaaaaabbaaaaaadiaaaaaiecaabaaaaaaaaaaaakbabaaaacaaaaaa
akiacaaaabaaaaaabcaaaaaadiaaaaaibcaabaaaabaaaaaabkbabaaaacaaaaaa
bkiacaaaabaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaabkbabaaaacaaaaaa
bkiacaaaabaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaabkbabaaaacaaaaaa
bkiacaaaabaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaacaaaaaackiacaaa
abaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaacaaaaaackiacaaa
abaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaacaaaaaackiacaaa
abaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaaacaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiccaaaabaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
abaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaabaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhccabaaaadaaaaaaegiccaaaabaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egacbaaaaaaaaaaadoaaaaabejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaheaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklkl"
}
SubProgram "opengl " {
Keywords { "SPOT" }
"!!GLSL#version 120

#ifdef VERTEX

uniform mat4 _Object2World;
uniform mat4 _World2Object;
uniform vec4 _MainTex_ST;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
void main ()
{
  vec4 v_1;
  v_1.x = _World2Object[0].x;
  v_1.y = _World2Object[1].x;
  v_1.z = _World2Object[2].x;
  v_1.w = _World2Object[3].x;
  vec4 v_2;
  v_2.x = _World2Object[0].y;
  v_2.y = _World2Object[1].y;
  v_2.z = _World2Object[2].y;
  v_2.w = _World2Object[3].y;
  vec4 v_3;
  v_3.x = _World2Object[0].z;
  v_3.y = _World2Object[1].z;
  v_3.z = _World2Object[2].z;
  v_3.w = _World2Object[3].z;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = normalize(((
    (v_1.xyz * gl_Normal.x)
   + 
    (v_2.xyz * gl_Normal.y)
  ) + (v_3.xyz * gl_Normal.z)));
  xlv_TEXCOORD2 = (_Object2World * gl_Vertex).xyz;
}


#endif
#ifdef FRAGMENT
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _LightColor0;
uniform vec4 _SpecColor;
uniform sampler2D _LightTexture0;
uniform mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _MainTex;
uniform vec4 _Color;
uniform float _Shininess;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
void main ()
{
  vec3 tmpvar_1;
  vec3 tmpvar_2;
  vec4 c_3;
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = xlv_TEXCOORD2;
  vec4 tmpvar_6;
  tmpvar_6 = (_LightMatrix0 * tmpvar_5);
  tmpvar_2 = normalize((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD2));
  tmpvar_1 = (_LightColor0.xyz * ((
    float((tmpvar_6.z > 0.0))
   * texture2D (_LightTexture0, 
    ((tmpvar_6.xy / tmpvar_6.w) + 0.5)
  ).w) * texture2D (_LightTextureB0, vec2(dot (tmpvar_6.xyz, tmpvar_6.xyz))).w));
  vec4 c_7;
  vec4 c_8;
  c_8.xyz = (((
    (tmpvar_4.xyz * _Color.xyz)
   * tmpvar_1) * max (0.0, 
    dot (xlv_TEXCOORD1, tmpvar_2)
  )) + ((tmpvar_1 * _SpecColor.xyz) * (
    pow (max (0.0, dot (xlv_TEXCOORD1, normalize(
      (tmpvar_2 + normalize((_WorldSpaceCameraPos - xlv_TEXCOORD2)))
    ))), (_Shininess * 128.0))
   * tmpvar_4.w)));
  c_8.w = (tmpvar_4.w * _Color.w);
  c_7.w = c_8.w;
  c_7.xyz = c_8.xyz;
  c_3.xyz = c_7.xyz;
  c_3.w = 1.0;
  gl_FragData[0] = c_3;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 4 [_Object2World] 3
Matrix 7 [_World2Object] 3
Matrix 0 [glstate_matrix_mvp]
Vector 10 [_MainTex_ST]
"vs_2_0
dcl_position v0
dcl_normal v1
dcl_texcoord v2
dp4 oPos.x, c0, v0
dp4 oPos.y, c1, v0
dp4 oPos.z, c2, v0
dp4 oPos.w, c3, v0
mad oT0.xy, v2, c10, c10.zwzw
dp4 oT2.x, c4, v0
dp4 oT2.y, c5, v0
dp4 oT2.z, c6, v0
mul r0.xyz, v1.y, c8
mad r0.xyz, c7, v1.x, r0
mad r0.xyz, c9, v1.z, r0
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul oT1.xyz, r0.w, r0

"
}
SubProgram "d3d11 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 256
Vector 240 [_MainTex_ST]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
root12:aaacaaaa
eefiecedcclnehojdkibdcbfmlpdnknanopapjmiabaaaaaaeaafaaaaadaaaaaa
cmaaaaaaceabaaaakmabaaaaejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaheaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcimadaaaaeaaaabaaodaaaaaafjaaaaae
egiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaabdaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaa
diaaaaaibcaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabaaaaaaa
diaaaaaiccaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabbaaaaaa
diaaaaaiecaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabcaaaaaa
diaaaaaibcaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabaaaaaaa
diaaaaaiccaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabbaaaaaa
diaaaaaiecaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabcaaaaaa
aaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaai
bcaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabaaaaaaadiaaaaai
ccaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabbaaaaaadiaaaaai
ecaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabcaaaaaaaaaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhccabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaabaaaaaa
anaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhccabaaaadaaaaaa
egiccaaaabaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}
SubProgram "d3d11_9x " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 256
Vector 240 [_MainTex_ST]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0_level_9_1
root12:aaacaaaa
eefiecedblpiibknlikpnajeagnpbhedmfnpomimabaaaaaagmahaaaaaeaaaaaa
daaaaaaafiacaaaaomafaaaaoeagaaaaebgpgodjcaacaaaacaacaaaaaaacpopp
neabaaaaemaaaaaaadaaceaaaaaaeiaaaaaaeiaaaaaaceaaabaaeiaaaaaaapaa
abaaabaaaaaaaaaaabaaaaaaaeaaacaaaaaaaaaaabaaamaaahaaagaaaaaaaaaa
aaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaciaacaaapja
bpaaaaacafaaadiaadaaapjaaeaaaaaeaaaaadoaadaaoejaabaaoekaabaaooka
afaaaaadaaaaahiaaaaaffjaahaaoekaaeaaaaaeaaaaahiaagaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaahiaaiaaoekaaaaakkjaaaaaoeiaaeaaaaaeacaaahoa
ajaaoekaaaaappjaaaaaoeiaafaaaaadaaaaabiaacaaaajaakaaaakaafaaaaad
aaaaaciaacaaaajaalaaaakaafaaaaadaaaaaeiaacaaaajaamaaaakaafaaaaad
abaaabiaacaaffjaakaaffkaafaaaaadabaaaciaacaaffjaalaaffkaafaaaaad
abaaaeiaacaaffjaamaaffkaacaaaaadaaaaahiaaaaaoeiaabaaoeiaafaaaaad
abaaabiaacaakkjaakaakkkaafaaaaadabaaaciaacaakkjaalaakkkaafaaaaad
abaaaeiaacaakkjaamaakkkaacaaaaadaaaaahiaaaaaoeiaabaaoeiaaiaaaaad
aaaaaiiaaaaaoeiaaaaaoeiaahaaaaacaaaaaiiaaaaappiaafaaaaadabaaahoa
aaaappiaaaaaoeiaafaaaaadaaaaapiaaaaaffjaadaaoekaaeaaaaaeaaaaapia
acaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaaeaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiaafaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappia
aaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefcimadaaaa
eaaaabaaodaaaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaa
abaaaaaabdaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaa
fpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
dccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaapaaaaaa
ogikcaaaaaaaaaaaapaaaaaadiaaaaaibcaabaaaaaaaaaaaakbabaaaacaaaaaa
akiacaaaabaaaaaabaaaaaaadiaaaaaiccaabaaaaaaaaaaaakbabaaaacaaaaaa
akiacaaaabaaaaaabbaaaaaadiaaaaaiecaabaaaaaaaaaaaakbabaaaacaaaaaa
akiacaaaabaaaaaabcaaaaaadiaaaaaibcaabaaaabaaaaaabkbabaaaacaaaaaa
bkiacaaaabaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaabkbabaaaacaaaaaa
bkiacaaaabaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaabkbabaaaacaaaaaa
bkiacaaaabaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaacaaaaaackiacaaa
abaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaacaaaaaackiacaaa
abaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaacaaaaaackiacaaa
abaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaaacaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiccaaaabaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
abaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaabaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhccabaaaadaaaaaaegiccaaaabaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egacbaaaaaaaaaaadoaaaaabejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaheaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklkl"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
"!!GLSL#version 120

#ifdef VERTEX

uniform mat4 _Object2World;
uniform mat4 _World2Object;
uniform vec4 _MainTex_ST;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
void main ()
{
  vec4 v_1;
  v_1.x = _World2Object[0].x;
  v_1.y = _World2Object[1].x;
  v_1.z = _World2Object[2].x;
  v_1.w = _World2Object[3].x;
  vec4 v_2;
  v_2.x = _World2Object[0].y;
  v_2.y = _World2Object[1].y;
  v_2.z = _World2Object[2].y;
  v_2.w = _World2Object[3].y;
  vec4 v_3;
  v_3.x = _World2Object[0].z;
  v_3.y = _World2Object[1].z;
  v_3.z = _World2Object[2].z;
  v_3.w = _World2Object[3].z;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = normalize(((
    (v_1.xyz * gl_Normal.x)
   + 
    (v_2.xyz * gl_Normal.y)
  ) + (v_3.xyz * gl_Normal.z)));
  xlv_TEXCOORD2 = (_Object2World * gl_Vertex).xyz;
}


#endif
#ifdef FRAGMENT
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _LightColor0;
uniform vec4 _SpecColor;
uniform samplerCube _LightTexture0;
uniform mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _MainTex;
uniform vec4 _Color;
uniform float _Shininess;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
void main ()
{
  vec3 tmpvar_1;
  vec3 tmpvar_2;
  vec4 c_3;
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = xlv_TEXCOORD2;
  vec3 tmpvar_6;
  tmpvar_6 = (_LightMatrix0 * tmpvar_5).xyz;
  tmpvar_2 = normalize((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD2));
  tmpvar_1 = (_LightColor0.xyz * (texture2D (_LightTextureB0, vec2(dot (tmpvar_6, tmpvar_6))).w * textureCube (_LightTexture0, tmpvar_6).w));
  vec4 c_7;
  vec4 c_8;
  c_8.xyz = (((
    (tmpvar_4.xyz * _Color.xyz)
   * tmpvar_1) * max (0.0, 
    dot (xlv_TEXCOORD1, tmpvar_2)
  )) + ((tmpvar_1 * _SpecColor.xyz) * (
    pow (max (0.0, dot (xlv_TEXCOORD1, normalize(
      (tmpvar_2 + normalize((_WorldSpaceCameraPos - xlv_TEXCOORD2)))
    ))), (_Shininess * 128.0))
   * tmpvar_4.w)));
  c_8.w = (tmpvar_4.w * _Color.w);
  c_7.w = c_8.w;
  c_7.xyz = c_8.xyz;
  c_3.xyz = c_7.xyz;
  c_3.w = 1.0;
  gl_FragData[0] = c_3;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 4 [_Object2World] 3
Matrix 7 [_World2Object] 3
Matrix 0 [glstate_matrix_mvp]
Vector 10 [_MainTex_ST]
"vs_2_0
dcl_position v0
dcl_normal v1
dcl_texcoord v2
dp4 oPos.x, c0, v0
dp4 oPos.y, c1, v0
dp4 oPos.z, c2, v0
dp4 oPos.w, c3, v0
mad oT0.xy, v2, c10, c10.zwzw
dp4 oT2.x, c4, v0
dp4 oT2.y, c5, v0
dp4 oT2.z, c6, v0
mul r0.xyz, v1.y, c8
mad r0.xyz, c7, v1.x, r0
mad r0.xyz, c9, v1.z, r0
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul oT1.xyz, r0.w, r0

"
}
SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 256
Vector 240 [_MainTex_ST]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
root12:aaacaaaa
eefiecedcclnehojdkibdcbfmlpdnknanopapjmiabaaaaaaeaafaaaaadaaaaaa
cmaaaaaaceabaaaakmabaaaaejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaheaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcimadaaaaeaaaabaaodaaaaaafjaaaaae
egiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaabdaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaa
diaaaaaibcaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabaaaaaaa
diaaaaaiccaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabbaaaaaa
diaaaaaiecaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabcaaaaaa
diaaaaaibcaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabaaaaaaa
diaaaaaiccaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabbaaaaaa
diaaaaaiecaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabcaaaaaa
aaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaai
bcaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabaaaaaaadiaaaaai
ccaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabbaaaaaadiaaaaai
ecaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabcaaaaaaaaaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhccabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaabaaaaaa
anaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhccabaaaadaaaaaa
egiccaaaabaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}
SubProgram "d3d11_9x " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 256
Vector 240 [_MainTex_ST]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0_level_9_1
root12:aaacaaaa
eefiecedblpiibknlikpnajeagnpbhedmfnpomimabaaaaaagmahaaaaaeaaaaaa
daaaaaaafiacaaaaomafaaaaoeagaaaaebgpgodjcaacaaaacaacaaaaaaacpopp
neabaaaaemaaaaaaadaaceaaaaaaeiaaaaaaeiaaaaaaceaaabaaeiaaaaaaapaa
abaaabaaaaaaaaaaabaaaaaaaeaaacaaaaaaaaaaabaaamaaahaaagaaaaaaaaaa
aaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaciaacaaapja
bpaaaaacafaaadiaadaaapjaaeaaaaaeaaaaadoaadaaoejaabaaoekaabaaooka
afaaaaadaaaaahiaaaaaffjaahaaoekaaeaaaaaeaaaaahiaagaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaahiaaiaaoekaaaaakkjaaaaaoeiaaeaaaaaeacaaahoa
ajaaoekaaaaappjaaaaaoeiaafaaaaadaaaaabiaacaaaajaakaaaakaafaaaaad
aaaaaciaacaaaajaalaaaakaafaaaaadaaaaaeiaacaaaajaamaaaakaafaaaaad
abaaabiaacaaffjaakaaffkaafaaaaadabaaaciaacaaffjaalaaffkaafaaaaad
abaaaeiaacaaffjaamaaffkaacaaaaadaaaaahiaaaaaoeiaabaaoeiaafaaaaad
abaaabiaacaakkjaakaakkkaafaaaaadabaaaciaacaakkjaalaakkkaafaaaaad
abaaaeiaacaakkjaamaakkkaacaaaaadaaaaahiaaaaaoeiaabaaoeiaaiaaaaad
aaaaaiiaaaaaoeiaaaaaoeiaahaaaaacaaaaaiiaaaaappiaafaaaaadabaaahoa
aaaappiaaaaaoeiaafaaaaadaaaaapiaaaaaffjaadaaoekaaeaaaaaeaaaaapia
acaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaaeaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiaafaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappia
aaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefcimadaaaa
eaaaabaaodaaaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaa
abaaaaaabdaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaa
fpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
dccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaapaaaaaa
ogikcaaaaaaaaaaaapaaaaaadiaaaaaibcaabaaaaaaaaaaaakbabaaaacaaaaaa
akiacaaaabaaaaaabaaaaaaadiaaaaaiccaabaaaaaaaaaaaakbabaaaacaaaaaa
akiacaaaabaaaaaabbaaaaaadiaaaaaiecaabaaaaaaaaaaaakbabaaaacaaaaaa
akiacaaaabaaaaaabcaaaaaadiaaaaaibcaabaaaabaaaaaabkbabaaaacaaaaaa
bkiacaaaabaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaabkbabaaaacaaaaaa
bkiacaaaabaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaabkbabaaaacaaaaaa
bkiacaaaabaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaacaaaaaackiacaaa
abaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaacaaaaaackiacaaa
abaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaacaaaaaackiacaaa
abaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaaacaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiccaaaabaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
abaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaabaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhccabaaaadaaaaaaegiccaaaabaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egacbaaaaaaaaaaadoaaaaabejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaheaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklkl"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLSL#version 120

#ifdef VERTEX

uniform mat4 _Object2World;
uniform mat4 _World2Object;
uniform vec4 _MainTex_ST;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
void main ()
{
  vec4 v_1;
  v_1.x = _World2Object[0].x;
  v_1.y = _World2Object[1].x;
  v_1.z = _World2Object[2].x;
  v_1.w = _World2Object[3].x;
  vec4 v_2;
  v_2.x = _World2Object[0].y;
  v_2.y = _World2Object[1].y;
  v_2.z = _World2Object[2].y;
  v_2.w = _World2Object[3].y;
  vec4 v_3;
  v_3.x = _World2Object[0].z;
  v_3.y = _World2Object[1].z;
  v_3.z = _World2Object[2].z;
  v_3.w = _World2Object[3].z;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = normalize(((
    (v_1.xyz * gl_Normal.x)
   + 
    (v_2.xyz * gl_Normal.y)
  ) + (v_3.xyz * gl_Normal.z)));
  xlv_TEXCOORD2 = (_Object2World * gl_Vertex).xyz;
}


#endif
#ifdef FRAGMENT
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _LightColor0;
uniform vec4 _SpecColor;
uniform sampler2D _LightTexture0;
uniform mat4 _LightMatrix0;
uniform sampler2D _MainTex;
uniform vec4 _Color;
uniform float _Shininess;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
void main ()
{
  vec3 tmpvar_1;
  vec4 c_2;
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = xlv_TEXCOORD2;
  tmpvar_1 = (_LightColor0.xyz * texture2D (_LightTexture0, (_LightMatrix0 * tmpvar_4).xy).w);
  vec4 c_5;
  vec4 c_6;
  c_6.xyz = (((
    (tmpvar_3.xyz * _Color.xyz)
   * tmpvar_1) * max (0.0, 
    dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)
  )) + ((tmpvar_1 * _SpecColor.xyz) * (
    pow (max (0.0, dot (xlv_TEXCOORD1, normalize(
      (_WorldSpaceLightPos0.xyz + normalize((_WorldSpaceCameraPos - xlv_TEXCOORD2)))
    ))), (_Shininess * 128.0))
   * tmpvar_3.w)));
  c_6.w = (tmpvar_3.w * _Color.w);
  c_5.w = c_6.w;
  c_5.xyz = c_6.xyz;
  c_2.xyz = c_5.xyz;
  c_2.w = 1.0;
  gl_FragData[0] = c_2;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 4 [_Object2World] 3
Matrix 7 [_World2Object] 3
Matrix 0 [glstate_matrix_mvp]
Vector 10 [_MainTex_ST]
"vs_2_0
dcl_position v0
dcl_normal v1
dcl_texcoord v2
dp4 oPos.x, c0, v0
dp4 oPos.y, c1, v0
dp4 oPos.z, c2, v0
dp4 oPos.w, c3, v0
mad oT0.xy, v2, c10, c10.zwzw
dp4 oT2.x, c4, v0
dp4 oT2.y, c5, v0
dp4 oT2.z, c6, v0
mul r0.xyz, v1.y, c8
mad r0.xyz, c7, v1.x, r0
mad r0.xyz, c9, v1.z, r0
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul oT1.xyz, r0.w, r0

"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 256
Vector 240 [_MainTex_ST]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
root12:aaacaaaa
eefiecedcclnehojdkibdcbfmlpdnknanopapjmiabaaaaaaeaafaaaaadaaaaaa
cmaaaaaaceabaaaakmabaaaaejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaheaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcimadaaaaeaaaabaaodaaaaaafjaaaaae
egiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaabdaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaa
diaaaaaibcaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabaaaaaaa
diaaaaaiccaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabbaaaaaa
diaaaaaiecaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabcaaaaaa
diaaaaaibcaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabaaaaaaa
diaaaaaiccaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabbaaaaaa
diaaaaaiecaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabcaaaaaa
aaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaai
bcaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabaaaaaaadiaaaaai
ccaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabbaaaaaadiaaaaai
ecaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabcaaaaaaaaaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhccabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaabaaaaaa
anaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhccabaaaadaaaaaa
egiccaaaabaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab
"
}
SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 256
Vector 240 [_MainTex_ST]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0_level_9_1
root12:aaacaaaa
eefiecedblpiibknlikpnajeagnpbhedmfnpomimabaaaaaagmahaaaaaeaaaaaa
daaaaaaafiacaaaaomafaaaaoeagaaaaebgpgodjcaacaaaacaacaaaaaaacpopp
neabaaaaemaaaaaaadaaceaaaaaaeiaaaaaaeiaaaaaaceaaabaaeiaaaaaaapaa
abaaabaaaaaaaaaaabaaaaaaaeaaacaaaaaaaaaaabaaamaaahaaagaaaaaaaaaa
aaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaciaacaaapja
bpaaaaacafaaadiaadaaapjaaeaaaaaeaaaaadoaadaaoejaabaaoekaabaaooka
afaaaaadaaaaahiaaaaaffjaahaaoekaaeaaaaaeaaaaahiaagaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaahiaaiaaoekaaaaakkjaaaaaoeiaaeaaaaaeacaaahoa
ajaaoekaaaaappjaaaaaoeiaafaaaaadaaaaabiaacaaaajaakaaaakaafaaaaad
aaaaaciaacaaaajaalaaaakaafaaaaadaaaaaeiaacaaaajaamaaaakaafaaaaad
abaaabiaacaaffjaakaaffkaafaaaaadabaaaciaacaaffjaalaaffkaafaaaaad
abaaaeiaacaaffjaamaaffkaacaaaaadaaaaahiaaaaaoeiaabaaoeiaafaaaaad
abaaabiaacaakkjaakaakkkaafaaaaadabaaaciaacaakkjaalaakkkaafaaaaad
abaaaeiaacaakkjaamaakkkaacaaaaadaaaaahiaaaaaoeiaabaaoeiaaiaaaaad
aaaaaiiaaaaaoeiaaaaaoeiaahaaaaacaaaaaiiaaaaappiaafaaaaadabaaahoa
aaaappiaaaaaoeiaafaaaaadaaaaapiaaaaaffjaadaaoekaaeaaaaaeaaaaapia
acaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaaeaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiaafaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappia
aaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefcimadaaaa
eaaaabaaodaaaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaa
abaaaaaabdaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaa
fpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
dccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaapaaaaaa
ogikcaaaaaaaaaaaapaaaaaadiaaaaaibcaabaaaaaaaaaaaakbabaaaacaaaaaa
akiacaaaabaaaaaabaaaaaaadiaaaaaiccaabaaaaaaaaaaaakbabaaaacaaaaaa
akiacaaaabaaaaaabbaaaaaadiaaaaaiecaabaaaaaaaaaaaakbabaaaacaaaaaa
akiacaaaabaaaaaabcaaaaaadiaaaaaibcaabaaaabaaaaaabkbabaaaacaaaaaa
bkiacaaaabaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaabkbabaaaacaaaaaa
bkiacaaaabaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaabkbabaaaacaaaaaa
bkiacaaaabaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaacaaaaaackiacaaa
abaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaacaaaaaackiacaaa
abaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaacaaaaaackiacaaa
abaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaaacaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiccaaaabaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
abaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaabaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhccabaaaadaaaaaaegiccaaaabaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egacbaaaaaaaaaaadoaaaaabejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaheaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklkl"
}
SubProgram "opengl " {
Keywords { "POINT" "FOG_EXP2" }
"!!GLSL#version 120

#ifdef VERTEX

uniform mat4 _Object2World;
uniform mat4 _World2Object;
uniform vec4 unity_FogParams;
uniform vec4 _MainTex_ST;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying float xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 v_2;
  v_2.x = _World2Object[0].x;
  v_2.y = _World2Object[1].x;
  v_2.z = _World2Object[2].x;
  v_2.w = _World2Object[3].x;
  vec4 v_3;
  v_3.x = _World2Object[0].y;
  v_3.y = _World2Object[1].y;
  v_3.z = _World2Object[2].y;
  v_3.w = _World2Object[3].y;
  vec4 v_4;
  v_4.x = _World2Object[0].z;
  v_4.y = _World2Object[1].z;
  v_4.z = _World2Object[2].z;
  v_4.w = _World2Object[3].z;
  float tmpvar_5;
  tmpvar_5 = (unity_FogParams.x * tmpvar_1.z);
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = normalize(((
    (v_2.xyz * gl_Normal.x)
   + 
    (v_3.xyz * gl_Normal.y)
  ) + (v_4.xyz * gl_Normal.z)));
  xlv_TEXCOORD2 = (_Object2World * gl_Vertex).xyz;
  xlv_TEXCOORD4 = exp2((-(tmpvar_5) * tmpvar_5));
}


#endif
#ifdef FRAGMENT
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _LightColor0;
uniform vec4 _SpecColor;
uniform sampler2D _LightTexture0;
uniform mat4 _LightMatrix0;
uniform sampler2D _MainTex;
uniform vec4 _Color;
uniform float _Shininess;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying float xlv_TEXCOORD4;
void main ()
{
  vec3 tmpvar_1;
  vec3 tmpvar_2;
  vec4 c_3;
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = xlv_TEXCOORD2;
  vec3 tmpvar_6;
  tmpvar_6 = (_LightMatrix0 * tmpvar_5).xyz;
  tmpvar_2 = normalize((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD2));
  tmpvar_1 = (_LightColor0.xyz * texture2D (_LightTexture0, vec2(dot (tmpvar_6, tmpvar_6))).w);
  vec4 c_7;
  c_7.xyz = (((
    (tmpvar_4.xyz * _Color.xyz)
   * tmpvar_1) * max (0.0, 
    dot (xlv_TEXCOORD1, tmpvar_2)
  )) + ((tmpvar_1 * _SpecColor.xyz) * (
    pow (max (0.0, dot (xlv_TEXCOORD1, normalize(
      (tmpvar_2 + normalize((_WorldSpaceCameraPos - xlv_TEXCOORD2)))
    ))), (_Shininess * 128.0))
   * tmpvar_4.w)));
  c_7.w = (tmpvar_4.w * _Color.w);
  c_3.xyz = (c_7.xyz * vec3(clamp (xlv_TEXCOORD4, 0.0, 1.0)));
  c_3.w = 1.0;
  gl_FragData[0] = c_3;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "POINT" "FOG_EXP2" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 4 [_Object2World] 3
Matrix 7 [_World2Object] 3
Matrix 0 [glstate_matrix_mvp]
Vector 11 [_MainTex_ST]
Vector 10 [unity_FogParams]
"vs_2_0
dcl_position v0
dcl_normal v1
dcl_texcoord v2
dp4 oPos.x, c0, v0
dp4 oPos.y, c1, v0
dp4 oPos.w, c3, v0
mad oT0.xy, v2, c11, c11.zwzw
dp4 oT2.x, c4, v0
dp4 oT2.y, c5, v0
dp4 oT2.z, c6, v0
mul r0.xyz, v1.y, c8
mad r0.xyz, c7, v1.x, r0
mad r0.xyz, c9, v1.z, r0
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul oT1.xyz, r0.w, r0
dp4 r0.x, c2, v0
mul r0.y, r0.x, c10.x
mov oPos.z, r0.x
mul r0.x, r0.y, -r0.y
exp oT4.x, r0.x

"
}
SubProgram "d3d11 " {
Keywords { "POINT" "FOG_EXP2" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 256
Vector 240 [_MainTex_ST]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
ConstBuffer "UnityFog" 32
Vector 16 [unity_FogParams]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
BindCB  "UnityFog" 2
"vs_4_0
root12:aaadaaaa
eefiecedmlohaidlccjdjhipheddmeomakbongdpabaaaaaanmafaaaaadaaaaaa
cmaaaaaaceabaaaameabaaaaejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaaimaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaaaealaaaaimaaaaaa
abaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaa
adaaaaaaadaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcbaaeaaaaeaaaabaaaeabaaaafjaaaaaeegiocaaaaaaaaaaa
baaaaaaafjaaaaaeegiocaaaabaaaaaabdaaaaaafjaaaaaeegiocaaaacaaaaaa
acaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadeccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
hccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
bcaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaaacaaaaaaabaaaaaadiaaaaai
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaabjaaaaaf
eccabaaaabaaaaaaakaabaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaadiaaaaai
bcaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabaaaaaaadiaaaaai
ccaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabbaaaaaadiaaaaai
ecaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabcaaaaaadiaaaaai
bcaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabaaaaaaadiaaaaai
ccaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabbaaaaaadiaaaaai
ecaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabcaaaaaaaaaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabaaaaaaadiaaaaaiccaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabbaaaaaadiaaaaaiecaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabcaaaaaaaaaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhccabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
diaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaabaaaaaaanaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaamaaaaaaagbabaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaa
abaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "POINT" "FOG_EXP2" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 256
Vector 240 [_MainTex_ST]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
ConstBuffer "UnityFog" 32
Vector 16 [unity_FogParams]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
BindCB  "UnityFog" 2
"vs_4_0_level_9_1
root12:aaadaaaa
eefiecedmbefpdmhfckdkdlfmilaenkojlijipkbabaaaaaaeaaiaaaaaeaaaaaa
daaaaaaajaacaaaakiagaaaakaahaaaaebgpgodjfiacaaaafiacaaaaaaacpopp
aaacaaaafiaaaaaaaeaaceaaaaaafeaaaaaafeaaaaaaceaaabaafeaaaaaaapaa
abaaabaaaaaaaaaaabaaaaaaaeaaacaaaaaaaaaaabaaamaaahaaagaaaaaaaaaa
acaaabaaabaaanaaaaaaaaaaaaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapja
bpaaaaacafaaaciaacaaapjabpaaaaacafaaadiaadaaapjaaeaaaaaeaaaaadoa
adaaoejaabaaoekaabaaookaafaaaaadaaaaahiaaaaaffjaahaaoekaaeaaaaae
aaaaahiaagaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaahiaaiaaoekaaaaakkja
aaaaoeiaaeaaaaaeacaaahoaajaaoekaaaaappjaaaaaoeiaafaaaaadaaaaabia
acaaaajaakaaaakaafaaaaadaaaaaciaacaaaajaalaaaakaafaaaaadaaaaaeia
acaaaajaamaaaakaafaaaaadabaaabiaacaaffjaakaaffkaafaaaaadabaaacia
acaaffjaalaaffkaafaaaaadabaaaeiaacaaffjaamaaffkaacaaaaadaaaaahia
aaaaoeiaabaaoeiaafaaaaadabaaabiaacaakkjaakaakkkaafaaaaadabaaacia
acaakkjaalaakkkaafaaaaadabaaaeiaacaakkjaamaakkkaacaaaaadaaaaahia
aaaaoeiaabaaoeiaaiaaaaadaaaaaiiaaaaaoeiaaaaaoeiaahaaaaacaaaaaiia
aaaappiaafaaaaadabaaahoaaaaappiaaaaaoeiaafaaaaadaaaaapiaaaaaffja
adaaoekaaeaaaaaeaaaaapiaacaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapia
aeaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaafaaoekaaaaappjaaaaaoeia
afaaaaadabaaabiaaaaakkiaanaaaakaafaaaaadabaaabiaabaaaaiaabaaaaib
aoaaaaacaaaaaeoaabaaaaiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaaammaaaaaoeiappppaaaafdeieefcbaaeaaaaeaaaabaaaeabaaaa
fjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaabdaaaaaa
fjaaaaaeegiocaaaacaaaaaaacaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
hcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadeccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaa
acaaaaaaabaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaia
ebaaaaaaaaaaaaaabjaaaaafeccabaaaabaaaaaaakaabaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaapaaaaaaogikcaaa
aaaaaaaaapaaaaaadiaaaaaibcaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaa
abaaaaaabaaaaaaadiaaaaaiccaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaa
abaaaaaabbaaaaaadiaaaaaiecaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaa
abaaaaaabcaaaaaadiaaaaaibcaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaa
abaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaa
abaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaa
abaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaa
baaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaa
bbaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaa
bcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaaacaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaabaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaabaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hccabaaaadaaaaaaegiccaaaabaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaadoaaaaabejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaa
oaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaaabaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaaadaaaaaa
afaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaaapaaaaaa
ojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdejfeejepeo
aafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepemepfcaakl
epfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
imaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaaaealaaaaimaaaaaaabaaaaaa
aaaaaaaaadaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaa
adaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "FOG_EXP2" }
"!!GLSL#version 120

#ifdef VERTEX

uniform mat4 _Object2World;
uniform mat4 _World2Object;
uniform vec4 unity_FogParams;
uniform vec4 _MainTex_ST;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying float xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 v_2;
  v_2.x = _World2Object[0].x;
  v_2.y = _World2Object[1].x;
  v_2.z = _World2Object[2].x;
  v_2.w = _World2Object[3].x;
  vec4 v_3;
  v_3.x = _World2Object[0].y;
  v_3.y = _World2Object[1].y;
  v_3.z = _World2Object[2].y;
  v_3.w = _World2Object[3].y;
  vec4 v_4;
  v_4.x = _World2Object[0].z;
  v_4.y = _World2Object[1].z;
  v_4.z = _World2Object[2].z;
  v_4.w = _World2Object[3].z;
  float tmpvar_5;
  tmpvar_5 = (unity_FogParams.x * tmpvar_1.z);
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = normalize(((
    (v_2.xyz * gl_Normal.x)
   + 
    (v_3.xyz * gl_Normal.y)
  ) + (v_4.xyz * gl_Normal.z)));
  xlv_TEXCOORD2 = (_Object2World * gl_Vertex).xyz;
  xlv_TEXCOORD4 = exp2((-(tmpvar_5) * tmpvar_5));
}


#endif
#ifdef FRAGMENT
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _LightColor0;
uniform vec4 _SpecColor;
uniform sampler2D _MainTex;
uniform vec4 _Color;
uniform float _Shininess;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying float xlv_TEXCOORD4;
void main ()
{
  vec4 c_1;
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec4 c_3;
  c_3.xyz = (((
    (tmpvar_2.xyz * _Color.xyz)
   * _LightColor0.xyz) * max (0.0, 
    dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)
  )) + ((_LightColor0.xyz * _SpecColor.xyz) * (
    pow (max (0.0, dot (xlv_TEXCOORD1, normalize(
      (_WorldSpaceLightPos0.xyz + normalize((_WorldSpaceCameraPos - xlv_TEXCOORD2)))
    ))), (_Shininess * 128.0))
   * tmpvar_2.w)));
  c_3.w = (tmpvar_2.w * _Color.w);
  c_1.xyz = (c_3.xyz * vec3(clamp (xlv_TEXCOORD4, 0.0, 1.0)));
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "FOG_EXP2" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 4 [_Object2World] 3
Matrix 7 [_World2Object] 3
Matrix 0 [glstate_matrix_mvp]
Vector 11 [_MainTex_ST]
Vector 10 [unity_FogParams]
"vs_2_0
dcl_position v0
dcl_normal v1
dcl_texcoord v2
dp4 oPos.x, c0, v0
dp4 oPos.y, c1, v0
dp4 oPos.w, c3, v0
mad oT0.xy, v2, c11, c11.zwzw
dp4 oT2.x, c4, v0
dp4 oT2.y, c5, v0
dp4 oT2.z, c6, v0
mul r0.xyz, v1.y, c8
mad r0.xyz, c7, v1.x, r0
mad r0.xyz, c9, v1.z, r0
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul oT1.xyz, r0.w, r0
dp4 r0.x, c2, v0
mul r0.y, r0.x, c10.x
mov oPos.z, r0.x
mul r0.x, r0.y, -r0.y
exp oT4.x, r0.x

"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "FOG_EXP2" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 192
Vector 176 [_MainTex_ST]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
ConstBuffer "UnityFog" 32
Vector 16 [unity_FogParams]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
BindCB  "UnityFog" 2
"vs_4_0
root12:aaadaaaa
eefiecedbpmpciibcnggjfoocmkgmcmhocpcfconabaaaaaanmafaaaaadaaaaaa
cmaaaaaaceabaaaameabaaaaejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaaimaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaaaealaaaaimaaaaaa
abaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaa
adaaaaaaadaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcbaaeaaaaeaaaabaaaeabaaaafjaaaaaeegiocaaaaaaaaaaa
amaaaaaafjaaaaaeegiocaaaabaaaaaabdaaaaaafjaaaaaeegiocaaaacaaaaaa
acaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadeccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
hccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
bcaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaaacaaaaaaabaaaaaadiaaaaai
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaabjaaaaaf
eccabaaaabaaaaaaakaabaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaaalaaaaaadiaaaaai
bcaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabaaaaaaadiaaaaai
ccaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabbaaaaaadiaaaaai
ecaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabcaaaaaadiaaaaai
bcaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabaaaaaaadiaaaaai
ccaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabbaaaaaadiaaaaai
ecaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabcaaaaaaaaaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabaaaaaaadiaaaaaiccaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabbaaaaaadiaaaaaiecaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabcaaaaaaaaaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhccabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
diaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaabaaaaaaanaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaamaaaaaaagbabaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaa
abaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "FOG_EXP2" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 192
Vector 176 [_MainTex_ST]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
ConstBuffer "UnityFog" 32
Vector 16 [unity_FogParams]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
BindCB  "UnityFog" 2
"vs_4_0_level_9_1
root12:aaadaaaa
eefiecediknbmmgaefoaahjlkkjblijmnjlbdaliabaaaaaaeaaiaaaaaeaaaaaa
daaaaaaajaacaaaakiagaaaakaahaaaaebgpgodjfiacaaaafiacaaaaaaacpopp
aaacaaaafiaaaaaaaeaaceaaaaaafeaaaaaafeaaaaaaceaaabaafeaaaaaaalaa
abaaabaaaaaaaaaaabaaaaaaaeaaacaaaaaaaaaaabaaamaaahaaagaaaaaaaaaa
acaaabaaabaaanaaaaaaaaaaaaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapja
bpaaaaacafaaaciaacaaapjabpaaaaacafaaadiaadaaapjaaeaaaaaeaaaaadoa
adaaoejaabaaoekaabaaookaafaaaaadaaaaahiaaaaaffjaahaaoekaaeaaaaae
aaaaahiaagaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaahiaaiaaoekaaaaakkja
aaaaoeiaaeaaaaaeacaaahoaajaaoekaaaaappjaaaaaoeiaafaaaaadaaaaabia
acaaaajaakaaaakaafaaaaadaaaaaciaacaaaajaalaaaakaafaaaaadaaaaaeia
acaaaajaamaaaakaafaaaaadabaaabiaacaaffjaakaaffkaafaaaaadabaaacia
acaaffjaalaaffkaafaaaaadabaaaeiaacaaffjaamaaffkaacaaaaadaaaaahia
aaaaoeiaabaaoeiaafaaaaadabaaabiaacaakkjaakaakkkaafaaaaadabaaacia
acaakkjaalaakkkaafaaaaadabaaaeiaacaakkjaamaakkkaacaaaaadaaaaahia
aaaaoeiaabaaoeiaaiaaaaadaaaaaiiaaaaaoeiaaaaaoeiaahaaaaacaaaaaiia
aaaappiaafaaaaadabaaahoaaaaappiaaaaaoeiaafaaaaadaaaaapiaaaaaffja
adaaoekaaeaaaaaeaaaaapiaacaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapia
aeaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaafaaoekaaaaappjaaaaaoeia
afaaaaadabaaabiaaaaakkiaanaaaakaafaaaaadabaaabiaabaaaaiaabaaaaib
aoaaaaacaaaaaeoaabaaaaiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaaammaaaaaoeiappppaaaafdeieefcbaaeaaaaeaaaabaaaeabaaaa
fjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaaeegiocaaaabaaaaaabdaaaaaa
fjaaaaaeegiocaaaacaaaaaaacaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
hcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadeccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaa
acaaaaaaabaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaia
ebaaaaaaaaaaaaaabjaaaaafeccabaaaabaaaaaaakaabaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaa
aaaaaaaaalaaaaaadiaaaaaibcaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaa
abaaaaaabaaaaaaadiaaaaaiccaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaa
abaaaaaabbaaaaaadiaaaaaiecaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaa
abaaaaaabcaaaaaadiaaaaaibcaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaa
abaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaa
abaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaa
abaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaa
baaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaa
bbaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaa
bcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaaacaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaabaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaabaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hccabaaaadaaaaaaegiccaaaabaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaadoaaaaabejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaa
oaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaaabaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaaadaaaaaa
afaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaaapaaaaaa
ojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdejfeejepeo
aafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepemepfcaakl
epfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
imaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaaaealaaaaimaaaaaaabaaaaaa
aaaaaaaaadaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaa
adaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
"
}
SubProgram "opengl " {
Keywords { "SPOT" "FOG_EXP2" }
"!!GLSL#version 120

#ifdef VERTEX

uniform mat4 _Object2World;
uniform mat4 _World2Object;
uniform vec4 unity_FogParams;
uniform vec4 _MainTex_ST;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying float xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 v_2;
  v_2.x = _World2Object[0].x;
  v_2.y = _World2Object[1].x;
  v_2.z = _World2Object[2].x;
  v_2.w = _World2Object[3].x;
  vec4 v_3;
  v_3.x = _World2Object[0].y;
  v_3.y = _World2Object[1].y;
  v_3.z = _World2Object[2].y;
  v_3.w = _World2Object[3].y;
  vec4 v_4;
  v_4.x = _World2Object[0].z;
  v_4.y = _World2Object[1].z;
  v_4.z = _World2Object[2].z;
  v_4.w = _World2Object[3].z;
  float tmpvar_5;
  tmpvar_5 = (unity_FogParams.x * tmpvar_1.z);
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = normalize(((
    (v_2.xyz * gl_Normal.x)
   + 
    (v_3.xyz * gl_Normal.y)
  ) + (v_4.xyz * gl_Normal.z)));
  xlv_TEXCOORD2 = (_Object2World * gl_Vertex).xyz;
  xlv_TEXCOORD4 = exp2((-(tmpvar_5) * tmpvar_5));
}


#endif
#ifdef FRAGMENT
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _LightColor0;
uniform vec4 _SpecColor;
uniform sampler2D _LightTexture0;
uniform mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _MainTex;
uniform vec4 _Color;
uniform float _Shininess;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying float xlv_TEXCOORD4;
void main ()
{
  vec3 tmpvar_1;
  vec3 tmpvar_2;
  vec4 c_3;
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = xlv_TEXCOORD2;
  vec4 tmpvar_6;
  tmpvar_6 = (_LightMatrix0 * tmpvar_5);
  tmpvar_2 = normalize((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD2));
  tmpvar_1 = (_LightColor0.xyz * ((
    float((tmpvar_6.z > 0.0))
   * texture2D (_LightTexture0, 
    ((tmpvar_6.xy / tmpvar_6.w) + 0.5)
  ).w) * texture2D (_LightTextureB0, vec2(dot (tmpvar_6.xyz, tmpvar_6.xyz))).w));
  vec4 c_7;
  c_7.xyz = (((
    (tmpvar_4.xyz * _Color.xyz)
   * tmpvar_1) * max (0.0, 
    dot (xlv_TEXCOORD1, tmpvar_2)
  )) + ((tmpvar_1 * _SpecColor.xyz) * (
    pow (max (0.0, dot (xlv_TEXCOORD1, normalize(
      (tmpvar_2 + normalize((_WorldSpaceCameraPos - xlv_TEXCOORD2)))
    ))), (_Shininess * 128.0))
   * tmpvar_4.w)));
  c_7.w = (tmpvar_4.w * _Color.w);
  c_3.xyz = (c_7.xyz * vec3(clamp (xlv_TEXCOORD4, 0.0, 1.0)));
  c_3.w = 1.0;
  gl_FragData[0] = c_3;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "FOG_EXP2" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 4 [_Object2World] 3
Matrix 7 [_World2Object] 3
Matrix 0 [glstate_matrix_mvp]
Vector 11 [_MainTex_ST]
Vector 10 [unity_FogParams]
"vs_2_0
dcl_position v0
dcl_normal v1
dcl_texcoord v2
dp4 oPos.x, c0, v0
dp4 oPos.y, c1, v0
dp4 oPos.w, c3, v0
mad oT0.xy, v2, c11, c11.zwzw
dp4 oT2.x, c4, v0
dp4 oT2.y, c5, v0
dp4 oT2.z, c6, v0
mul r0.xyz, v1.y, c8
mad r0.xyz, c7, v1.x, r0
mad r0.xyz, c9, v1.z, r0
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul oT1.xyz, r0.w, r0
dp4 r0.x, c2, v0
mul r0.y, r0.x, c10.x
mov oPos.z, r0.x
mul r0.x, r0.y, -r0.y
exp oT4.x, r0.x

"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "FOG_EXP2" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 256
Vector 240 [_MainTex_ST]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
ConstBuffer "UnityFog" 32
Vector 16 [unity_FogParams]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
BindCB  "UnityFog" 2
"vs_4_0
root12:aaadaaaa
eefiecedmlohaidlccjdjhipheddmeomakbongdpabaaaaaanmafaaaaadaaaaaa
cmaaaaaaceabaaaameabaaaaejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaaimaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaaaealaaaaimaaaaaa
abaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaa
adaaaaaaadaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcbaaeaaaaeaaaabaaaeabaaaafjaaaaaeegiocaaaaaaaaaaa
baaaaaaafjaaaaaeegiocaaaabaaaaaabdaaaaaafjaaaaaeegiocaaaacaaaaaa
acaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadeccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
hccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
bcaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaaacaaaaaaabaaaaaadiaaaaai
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaabjaaaaaf
eccabaaaabaaaaaaakaabaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaadiaaaaai
bcaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabaaaaaaadiaaaaai
ccaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabbaaaaaadiaaaaai
ecaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabcaaaaaadiaaaaai
bcaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabaaaaaaadiaaaaai
ccaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabbaaaaaadiaaaaai
ecaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabcaaaaaaaaaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabaaaaaaadiaaaaaiccaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabbaaaaaadiaaaaaiecaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabcaaaaaaaaaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhccabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
diaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaabaaaaaaanaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaamaaaaaaagbabaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaa
abaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "SPOT" "FOG_EXP2" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 256
Vector 240 [_MainTex_ST]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
ConstBuffer "UnityFog" 32
Vector 16 [unity_FogParams]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
BindCB  "UnityFog" 2
"vs_4_0_level_9_1
root12:aaadaaaa
eefiecedmbefpdmhfckdkdlfmilaenkojlijipkbabaaaaaaeaaiaaaaaeaaaaaa
daaaaaaajaacaaaakiagaaaakaahaaaaebgpgodjfiacaaaafiacaaaaaaacpopp
aaacaaaafiaaaaaaaeaaceaaaaaafeaaaaaafeaaaaaaceaaabaafeaaaaaaapaa
abaaabaaaaaaaaaaabaaaaaaaeaaacaaaaaaaaaaabaaamaaahaaagaaaaaaaaaa
acaaabaaabaaanaaaaaaaaaaaaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapja
bpaaaaacafaaaciaacaaapjabpaaaaacafaaadiaadaaapjaaeaaaaaeaaaaadoa
adaaoejaabaaoekaabaaookaafaaaaadaaaaahiaaaaaffjaahaaoekaaeaaaaae
aaaaahiaagaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaahiaaiaaoekaaaaakkja
aaaaoeiaaeaaaaaeacaaahoaajaaoekaaaaappjaaaaaoeiaafaaaaadaaaaabia
acaaaajaakaaaakaafaaaaadaaaaaciaacaaaajaalaaaakaafaaaaadaaaaaeia
acaaaajaamaaaakaafaaaaadabaaabiaacaaffjaakaaffkaafaaaaadabaaacia
acaaffjaalaaffkaafaaaaadabaaaeiaacaaffjaamaaffkaacaaaaadaaaaahia
aaaaoeiaabaaoeiaafaaaaadabaaabiaacaakkjaakaakkkaafaaaaadabaaacia
acaakkjaalaakkkaafaaaaadabaaaeiaacaakkjaamaakkkaacaaaaadaaaaahia
aaaaoeiaabaaoeiaaiaaaaadaaaaaiiaaaaaoeiaaaaaoeiaahaaaaacaaaaaiia
aaaappiaafaaaaadabaaahoaaaaappiaaaaaoeiaafaaaaadaaaaapiaaaaaffja
adaaoekaaeaaaaaeaaaaapiaacaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapia
aeaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaafaaoekaaaaappjaaaaaoeia
afaaaaadabaaabiaaaaakkiaanaaaakaafaaaaadabaaabiaabaaaaiaabaaaaib
aoaaaaacaaaaaeoaabaaaaiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaaammaaaaaoeiappppaaaafdeieefcbaaeaaaaeaaaabaaaeabaaaa
fjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaabdaaaaaa
fjaaaaaeegiocaaaacaaaaaaacaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
hcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadeccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaa
acaaaaaaabaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaia
ebaaaaaaaaaaaaaabjaaaaafeccabaaaabaaaaaaakaabaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaapaaaaaaogikcaaa
aaaaaaaaapaaaaaadiaaaaaibcaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaa
abaaaaaabaaaaaaadiaaaaaiccaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaa
abaaaaaabbaaaaaadiaaaaaiecaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaa
abaaaaaabcaaaaaadiaaaaaibcaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaa
abaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaa
abaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaa
abaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaa
baaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaa
bbaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaa
bcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaaacaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaabaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaabaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hccabaaaadaaaaaaegiccaaaabaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaadoaaaaabejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaa
oaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaaabaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaaadaaaaaa
afaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaaapaaaaaa
ojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdejfeejepeo
aafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepemepfcaakl
epfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
imaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaaaealaaaaimaaaaaaabaaaaaa
aaaaaaaaadaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaa
adaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" "FOG_EXP2" }
"!!GLSL#version 120

#ifdef VERTEX

uniform mat4 _Object2World;
uniform mat4 _World2Object;
uniform vec4 unity_FogParams;
uniform vec4 _MainTex_ST;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying float xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 v_2;
  v_2.x = _World2Object[0].x;
  v_2.y = _World2Object[1].x;
  v_2.z = _World2Object[2].x;
  v_2.w = _World2Object[3].x;
  vec4 v_3;
  v_3.x = _World2Object[0].y;
  v_3.y = _World2Object[1].y;
  v_3.z = _World2Object[2].y;
  v_3.w = _World2Object[3].y;
  vec4 v_4;
  v_4.x = _World2Object[0].z;
  v_4.y = _World2Object[1].z;
  v_4.z = _World2Object[2].z;
  v_4.w = _World2Object[3].z;
  float tmpvar_5;
  tmpvar_5 = (unity_FogParams.x * tmpvar_1.z);
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = normalize(((
    (v_2.xyz * gl_Normal.x)
   + 
    (v_3.xyz * gl_Normal.y)
  ) + (v_4.xyz * gl_Normal.z)));
  xlv_TEXCOORD2 = (_Object2World * gl_Vertex).xyz;
  xlv_TEXCOORD4 = exp2((-(tmpvar_5) * tmpvar_5));
}


#endif
#ifdef FRAGMENT
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _LightColor0;
uniform vec4 _SpecColor;
uniform samplerCube _LightTexture0;
uniform mat4 _LightMatrix0;
uniform sampler2D _LightTextureB0;
uniform sampler2D _MainTex;
uniform vec4 _Color;
uniform float _Shininess;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying float xlv_TEXCOORD4;
void main ()
{
  vec3 tmpvar_1;
  vec3 tmpvar_2;
  vec4 c_3;
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = xlv_TEXCOORD2;
  vec3 tmpvar_6;
  tmpvar_6 = (_LightMatrix0 * tmpvar_5).xyz;
  tmpvar_2 = normalize((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD2));
  tmpvar_1 = (_LightColor0.xyz * (texture2D (_LightTextureB0, vec2(dot (tmpvar_6, tmpvar_6))).w * textureCube (_LightTexture0, tmpvar_6).w));
  vec4 c_7;
  c_7.xyz = (((
    (tmpvar_4.xyz * _Color.xyz)
   * tmpvar_1) * max (0.0, 
    dot (xlv_TEXCOORD1, tmpvar_2)
  )) + ((tmpvar_1 * _SpecColor.xyz) * (
    pow (max (0.0, dot (xlv_TEXCOORD1, normalize(
      (tmpvar_2 + normalize((_WorldSpaceCameraPos - xlv_TEXCOORD2)))
    ))), (_Shininess * 128.0))
   * tmpvar_4.w)));
  c_7.w = (tmpvar_4.w * _Color.w);
  c_3.xyz = (c_7.xyz * vec3(clamp (xlv_TEXCOORD4, 0.0, 1.0)));
  c_3.w = 1.0;
  gl_FragData[0] = c_3;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" "FOG_EXP2" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 4 [_Object2World] 3
Matrix 7 [_World2Object] 3
Matrix 0 [glstate_matrix_mvp]
Vector 11 [_MainTex_ST]
Vector 10 [unity_FogParams]
"vs_2_0
dcl_position v0
dcl_normal v1
dcl_texcoord v2
dp4 oPos.x, c0, v0
dp4 oPos.y, c1, v0
dp4 oPos.w, c3, v0
mad oT0.xy, v2, c11, c11.zwzw
dp4 oT2.x, c4, v0
dp4 oT2.y, c5, v0
dp4 oT2.z, c6, v0
mul r0.xyz, v1.y, c8
mad r0.xyz, c7, v1.x, r0
mad r0.xyz, c9, v1.z, r0
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul oT1.xyz, r0.w, r0
dp4 r0.x, c2, v0
mul r0.y, r0.x, c10.x
mov oPos.z, r0.x
mul r0.x, r0.y, -r0.y
exp oT4.x, r0.x

"
}
SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" "FOG_EXP2" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 256
Vector 240 [_MainTex_ST]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
ConstBuffer "UnityFog" 32
Vector 16 [unity_FogParams]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
BindCB  "UnityFog" 2
"vs_4_0
root12:aaadaaaa
eefiecedmlohaidlccjdjhipheddmeomakbongdpabaaaaaanmafaaaaadaaaaaa
cmaaaaaaceabaaaameabaaaaejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaaimaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaaaealaaaaimaaaaaa
abaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaa
adaaaaaaadaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcbaaeaaaaeaaaabaaaeabaaaafjaaaaaeegiocaaaaaaaaaaa
baaaaaaafjaaaaaeegiocaaaabaaaaaabdaaaaaafjaaaaaeegiocaaaacaaaaaa
acaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadeccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
hccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
bcaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaaacaaaaaaabaaaaaadiaaaaai
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaabjaaaaaf
eccabaaaabaaaaaaakaabaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaadiaaaaai
bcaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabaaaaaaadiaaaaai
ccaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabbaaaaaadiaaaaai
ecaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabcaaaaaadiaaaaai
bcaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabaaaaaaadiaaaaai
ccaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabbaaaaaadiaaaaai
ecaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabcaaaaaaaaaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabaaaaaaadiaaaaaiccaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabbaaaaaadiaaaaaiecaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabcaaaaaaaaaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhccabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
diaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaabaaaaaaanaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaamaaaaaaagbabaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaa
abaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "POINT_COOKIE" "FOG_EXP2" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 256
Vector 240 [_MainTex_ST]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
ConstBuffer "UnityFog" 32
Vector 16 [unity_FogParams]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
BindCB  "UnityFog" 2
"vs_4_0_level_9_1
root12:aaadaaaa
eefiecedmbefpdmhfckdkdlfmilaenkojlijipkbabaaaaaaeaaiaaaaaeaaaaaa
daaaaaaajaacaaaakiagaaaakaahaaaaebgpgodjfiacaaaafiacaaaaaaacpopp
aaacaaaafiaaaaaaaeaaceaaaaaafeaaaaaafeaaaaaaceaaabaafeaaaaaaapaa
abaaabaaaaaaaaaaabaaaaaaaeaaacaaaaaaaaaaabaaamaaahaaagaaaaaaaaaa
acaaabaaabaaanaaaaaaaaaaaaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapja
bpaaaaacafaaaciaacaaapjabpaaaaacafaaadiaadaaapjaaeaaaaaeaaaaadoa
adaaoejaabaaoekaabaaookaafaaaaadaaaaahiaaaaaffjaahaaoekaaeaaaaae
aaaaahiaagaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaahiaaiaaoekaaaaakkja
aaaaoeiaaeaaaaaeacaaahoaajaaoekaaaaappjaaaaaoeiaafaaaaadaaaaabia
acaaaajaakaaaakaafaaaaadaaaaaciaacaaaajaalaaaakaafaaaaadaaaaaeia
acaaaajaamaaaakaafaaaaadabaaabiaacaaffjaakaaffkaafaaaaadabaaacia
acaaffjaalaaffkaafaaaaadabaaaeiaacaaffjaamaaffkaacaaaaadaaaaahia
aaaaoeiaabaaoeiaafaaaaadabaaabiaacaakkjaakaakkkaafaaaaadabaaacia
acaakkjaalaakkkaafaaaaadabaaaeiaacaakkjaamaakkkaacaaaaadaaaaahia
aaaaoeiaabaaoeiaaiaaaaadaaaaaiiaaaaaoeiaaaaaoeiaahaaaaacaaaaaiia
aaaappiaafaaaaadabaaahoaaaaappiaaaaaoeiaafaaaaadaaaaapiaaaaaffja
adaaoekaaeaaaaaeaaaaapiaacaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapia
aeaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaafaaoekaaaaappjaaaaaoeia
afaaaaadabaaabiaaaaakkiaanaaaakaafaaaaadabaaabiaabaaaaiaabaaaaib
aoaaaaacaaaaaeoaabaaaaiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaaammaaaaaoeiappppaaaafdeieefcbaaeaaaaeaaaabaaaeabaaaa
fjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaabdaaaaaa
fjaaaaaeegiocaaaacaaaaaaacaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
hcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadeccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaa
acaaaaaaabaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaia
ebaaaaaaaaaaaaaabjaaaaafeccabaaaabaaaaaaakaabaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaapaaaaaaogikcaaa
aaaaaaaaapaaaaaadiaaaaaibcaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaa
abaaaaaabaaaaaaadiaaaaaiccaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaa
abaaaaaabbaaaaaadiaaaaaiecaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaa
abaaaaaabcaaaaaadiaaaaaibcaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaa
abaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaa
abaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaa
abaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaa
baaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaa
bbaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaa
bcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaaacaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaabaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaabaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hccabaaaadaaaaaaegiccaaaabaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaadoaaaaabejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaa
oaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaaabaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaaadaaaaaa
afaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaaapaaaaaa
ojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdejfeejepeo
aafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepemepfcaakl
epfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
imaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaaaealaaaaimaaaaaaabaaaaaa
aaaaaaaaadaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaa
adaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" "FOG_EXP2" }
"!!GLSL#version 120

#ifdef VERTEX

uniform mat4 _Object2World;
uniform mat4 _World2Object;
uniform vec4 unity_FogParams;
uniform vec4 _MainTex_ST;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying float xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 v_2;
  v_2.x = _World2Object[0].x;
  v_2.y = _World2Object[1].x;
  v_2.z = _World2Object[2].x;
  v_2.w = _World2Object[3].x;
  vec4 v_3;
  v_3.x = _World2Object[0].y;
  v_3.y = _World2Object[1].y;
  v_3.z = _World2Object[2].y;
  v_3.w = _World2Object[3].y;
  vec4 v_4;
  v_4.x = _World2Object[0].z;
  v_4.y = _World2Object[1].z;
  v_4.z = _World2Object[2].z;
  v_4.w = _World2Object[3].z;
  float tmpvar_5;
  tmpvar_5 = (unity_FogParams.x * tmpvar_1.z);
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = normalize(((
    (v_2.xyz * gl_Normal.x)
   + 
    (v_3.xyz * gl_Normal.y)
  ) + (v_4.xyz * gl_Normal.z)));
  xlv_TEXCOORD2 = (_Object2World * gl_Vertex).xyz;
  xlv_TEXCOORD4 = exp2((-(tmpvar_5) * tmpvar_5));
}


#endif
#ifdef FRAGMENT
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _LightColor0;
uniform vec4 _SpecColor;
uniform sampler2D _LightTexture0;
uniform mat4 _LightMatrix0;
uniform sampler2D _MainTex;
uniform vec4 _Color;
uniform float _Shininess;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying float xlv_TEXCOORD4;
void main ()
{
  vec3 tmpvar_1;
  vec4 c_2;
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = xlv_TEXCOORD2;
  tmpvar_1 = (_LightColor0.xyz * texture2D (_LightTexture0, (_LightMatrix0 * tmpvar_4).xy).w);
  vec4 c_5;
  c_5.xyz = (((
    (tmpvar_3.xyz * _Color.xyz)
   * tmpvar_1) * max (0.0, 
    dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)
  )) + ((tmpvar_1 * _SpecColor.xyz) * (
    pow (max (0.0, dot (xlv_TEXCOORD1, normalize(
      (_WorldSpaceLightPos0.xyz + normalize((_WorldSpaceCameraPos - xlv_TEXCOORD2)))
    ))), (_Shininess * 128.0))
   * tmpvar_3.w)));
  c_5.w = (tmpvar_3.w * _Color.w);
  c_2.xyz = (c_5.xyz * vec3(clamp (xlv_TEXCOORD4, 0.0, 1.0)));
  c_2.w = 1.0;
  gl_FragData[0] = c_2;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" "FOG_EXP2" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 4 [_Object2World] 3
Matrix 7 [_World2Object] 3
Matrix 0 [glstate_matrix_mvp]
Vector 11 [_MainTex_ST]
Vector 10 [unity_FogParams]
"vs_2_0
dcl_position v0
dcl_normal v1
dcl_texcoord v2
dp4 oPos.x, c0, v0
dp4 oPos.y, c1, v0
dp4 oPos.w, c3, v0
mad oT0.xy, v2, c11, c11.zwzw
dp4 oT2.x, c4, v0
dp4 oT2.y, c5, v0
dp4 oT2.z, c6, v0
mul r0.xyz, v1.y, c8
mad r0.xyz, c7, v1.x, r0
mad r0.xyz, c9, v1.z, r0
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul oT1.xyz, r0.w, r0
dp4 r0.x, c2, v0
mul r0.y, r0.x, c10.x
mov oPos.z, r0.x
mul r0.x, r0.y, -r0.y
exp oT4.x, r0.x

"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" "FOG_EXP2" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 256
Vector 240 [_MainTex_ST]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
ConstBuffer "UnityFog" 32
Vector 16 [unity_FogParams]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
BindCB  "UnityFog" 2
"vs_4_0
root12:aaadaaaa
eefiecedmlohaidlccjdjhipheddmeomakbongdpabaaaaaanmafaaaaadaaaaaa
cmaaaaaaceabaaaameabaaaaejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaaimaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaaaealaaaaimaaaaaa
abaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaa
adaaaaaaadaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcbaaeaaaaeaaaabaaaeabaaaafjaaaaaeegiocaaaaaaaaaaa
baaaaaaafjaaaaaeegiocaaaabaaaaaabdaaaaaafjaaaaaeegiocaaaacaaaaaa
acaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadeccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
hccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
bcaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaaacaaaaaaabaaaaaadiaaaaai
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaabjaaaaaf
eccabaaaabaaaaaaakaabaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaapaaaaaaogikcaaaaaaaaaaaapaaaaaadiaaaaai
bcaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabaaaaaaadiaaaaai
ccaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabbaaaaaadiaaaaai
ecaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaabaaaaaabcaaaaaadiaaaaai
bcaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabaaaaaaadiaaaaai
ccaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabbaaaaaadiaaaaai
ecaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaabaaaaaabcaaaaaaaaaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabaaaaaaadiaaaaaiccaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabbaaaaaadiaaaaaiecaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaabaaaaaabcaaaaaaaaaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhccabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
diaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaabaaaaaaanaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaamaaaaaaagbabaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaa
abaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL_COOKIE" "FOG_EXP2" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 256
Vector 240 [_MainTex_ST]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
ConstBuffer "UnityFog" 32
Vector 16 [unity_FogParams]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
BindCB  "UnityFog" 2
"vs_4_0_level_9_1
root12:aaadaaaa
eefiecedmbefpdmhfckdkdlfmilaenkojlijipkbabaaaaaaeaaiaaaaaeaaaaaa
daaaaaaajaacaaaakiagaaaakaahaaaaebgpgodjfiacaaaafiacaaaaaaacpopp
aaacaaaafiaaaaaaaeaaceaaaaaafeaaaaaafeaaaaaaceaaabaafeaaaaaaapaa
abaaabaaaaaaaaaaabaaaaaaaeaaacaaaaaaaaaaabaaamaaahaaagaaaaaaaaaa
acaaabaaabaaanaaaaaaaaaaaaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapja
bpaaaaacafaaaciaacaaapjabpaaaaacafaaadiaadaaapjaaeaaaaaeaaaaadoa
adaaoejaabaaoekaabaaookaafaaaaadaaaaahiaaaaaffjaahaaoekaaeaaaaae
aaaaahiaagaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaahiaaiaaoekaaaaakkja
aaaaoeiaaeaaaaaeacaaahoaajaaoekaaaaappjaaaaaoeiaafaaaaadaaaaabia
acaaaajaakaaaakaafaaaaadaaaaaciaacaaaajaalaaaakaafaaaaadaaaaaeia
acaaaajaamaaaakaafaaaaadabaaabiaacaaffjaakaaffkaafaaaaadabaaacia
acaaffjaalaaffkaafaaaaadabaaaeiaacaaffjaamaaffkaacaaaaadaaaaahia
aaaaoeiaabaaoeiaafaaaaadabaaabiaacaakkjaakaakkkaafaaaaadabaaacia
acaakkjaalaakkkaafaaaaadabaaaeiaacaakkjaamaakkkaacaaaaadaaaaahia
aaaaoeiaabaaoeiaaiaaaaadaaaaaiiaaaaaoeiaaaaaoeiaahaaaaacaaaaaiia
aaaappiaafaaaaadabaaahoaaaaappiaaaaaoeiaafaaaaadaaaaapiaaaaaffja
adaaoekaaeaaaaaeaaaaapiaacaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapia
aeaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaafaaoekaaaaappjaaaaaoeia
afaaaaadabaaabiaaaaakkiaanaaaakaafaaaaadabaaabiaabaaaaiaabaaaaib
aoaaaaacaaaaaeoaabaaaaiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaaammaaaaaoeiappppaaaafdeieefcbaaeaaaaeaaaabaaaeabaaaa
fjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaabdaaaaaa
fjaaaaaeegiocaaaacaaaaaaacaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
hcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadeccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaackaabaaaaaaaaaaaakiacaaa
acaaaaaaabaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaia
ebaaaaaaaaaaaaaabjaaaaafeccabaaaabaaaaaaakaabaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaapaaaaaaogikcaaa
aaaaaaaaapaaaaaadiaaaaaibcaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaa
abaaaaaabaaaaaaadiaaaaaiccaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaa
abaaaaaabbaaaaaadiaaaaaiecaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaa
abaaaaaabcaaaaaadiaaaaaibcaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaa
abaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaa
abaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaa
abaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaa
baaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaa
bbaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaacaaaaaackiacaaaabaaaaaa
bcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaaacaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiccaaaabaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaabaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hccabaaaadaaaaaaegiccaaaabaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
aaaaaaaadoaaaaabejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaa
oaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaaabaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaaadaaaaaa
afaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaaapaaaaaa
ojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdejfeejepeo
aafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepemepfcaakl
epfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
imaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaaaealaaaaimaaaaaaabaaaaaa
aaaaaaaaadaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaa
adaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "POINT" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "POINT" }
Matrix 0 [_LightMatrix0] 3
Vector 7 [_Color]
Vector 5 [_LightColor0]
Float 8 [_Shininess]
Vector 6 [_SpecColor]
Vector 3 [_WorldSpaceCameraPos]
Vector 4 [_WorldSpaceLightPos0]
SetTexture 0 [_LightTexture0] 2D 0
SetTexture 1 [_MainTex] 2D 1
"ps_2_0
def c9, 1, 0, 128, 0
dcl t0.xy
dcl_pp t1.xyz
dcl t2.xyz
dcl_2d s0
dcl_2d s1
mov r0.xyz, t2
mov_pp r0.w, c9.x
dp4 r1.x, c0, r0
dp4 r1.y, c1, r0
dp4 r1.z, c2, r0
dp3 r0.xy, r1, r1
texld_pp r0, r0, s0
texld_pp r1, t0, s1
mul_pp r0.xyz, r0.x, c5
mul r2.xyz, r0, c6
add r3.xyz, -t2, c3
dp3 r0.w, r3, r3
rsq r0.w, r0.w
add r4.xyz, -t2, c4
nrm_pp r5.xyz, r4
mad_pp r3.xyz, r3, r0.w, r5
dp3_pp r0.w, t1, r5
max_pp r2.w, r0.w, c9.y
nrm_pp r4.xyz, r3
dp3_pp r0.w, t1, r4
max r3.x, r0.w, c9.y
mov r0.w, c9.z
mul r0.w, r0.w, c8.x
pow r4.x, r3.x, r0.w
mul r0.w, r1.w, r4.x
mul_pp r1.xyz, r1, c7
mul_pp r0.xyz, r0, r1
mul r1.xyz, r0.w, r2
mad_pp r0.xyz, r0, r2.w, r1
mov_pp r0.w, c9.x
mov_pp oC0, r0

"
}
SubProgram "d3d11 " {
Keywords { "POINT" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_LightTexture0] 2D 0
ConstBuffer "$Globals" 256
Matrix 144 [_LightMatrix0]
Vector 96 [_LightColor0]
Vector 112 [_SpecColor]
Vector 208 [_Color]
Float 224 [_Shininess]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
"ps_4_0
root12:acadacaa
eefiecedbokdolnedangjeonglgaohbdgfgbpabkabaaaaaaheafaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcieaeaaaaeaaaaaaacbabaaaafjaaaaaeegiocaaa
aaaaaaaaapaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaa
acaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaa
adaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaaaaaaaajhcaabaaa
aaaaaaaaegbcbaiaebaaaaaaadaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaah
icaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaaaaaaaaajhcaabaaaabaaaaaaegbcbaiaebaaaaaaadaaaaaa
egiccaaaabaaaaaaaeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaa
egacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaaj
hcaabaaaabaaaaaaegacbaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
baaaaaahbcaabaaaaaaaaaaaegbcbaaaacaaaaaaegacbaaaaaaaaaaabaaaaaah
ccaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaafccaabaaa
aaaaaaaabkaabaaaaaaaaaaadiaaaaahocaabaaaaaaaaaaafgafbaaaaaaaaaaa
agajbaaaabaaaaaabaaaaaahccaabaaaaaaaaaaaegbcbaaaacaaaaaajgahbaaa
aaaaaaaadeaaaaakdcaabaaaaaaaaaaaegaabaaaaaaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaacpaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaa
diaaaaaiecaabaaaaaaaaaaaakiacaaaaaaaaaaaaoaaaaaaabeaaaaaaaaaaaed
diaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaackaabaaaaaaaaaaabjaaaaaf
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaahccaabaaaaaaaaaaa
bkaabaaaaaaaaaaadkaabaaaabaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaa
abaaaaaaegiccaaaaaaaaaaaanaaaaaadiaaaaaihcaabaaaacaaaaaafgbfbaaa
adaaaaaaegiccaaaaaaaaaaaakaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaa
aaaaaaaaajaaaaaaagbabaaaadaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaa
acaaaaaaegiccaaaaaaaaaaaalaaaaaakgbkbaaaadaaaaaaegacbaaaacaaaaaa
aaaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaamaaaaaa
baaaaaahecaabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaaefaaaaaj
pcaabaaaacaaaaaakgakbaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaa
diaaaaaihcaabaaaacaaaaaaagaabaaaacaaaaaaegiccaaaaaaaaaaaagaaaaaa
diaaaaaihcaabaaaadaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaahaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadiaaaaah
ocaabaaaaaaaaaaafgafbaaaaaaaaaaaagajbaaaadaaaaaadcaaaaajhccabaaa
aaaaaaaaegacbaaaabaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaadgaaaaaf
iccabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "POINT" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_LightTexture0] 2D 0
ConstBuffer "$Globals" 256
Matrix 144 [_LightMatrix0]
Vector 96 [_LightColor0]
Vector 112 [_SpecColor]
Vector 208 [_Color]
Float 224 [_Shininess]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
"ps_4_0_level_9_1
root12:acadacaa
eefiecedemfipaooincadmolmcdnnbmmjmngnbeoabaaaaaabaaiaaaaaeaaaaaa
daaaaaaamiacaaaafeahaaaanmahaaaaebgpgodjjaacaaaajaacaaaaaaacpppp
deacaaaafmaaaaaaaeaacmaaaaaafmaaaaaafmaaacaaceaaaaaafmaaabaaaaaa
aaababaaaaaaagaaacaaaaaaaaaaaaaaaaaaajaaagaaacaaaaaaaaaaabaaaeaa
abaaaiaaaaaaaaaaacaaaaaaabaaajaaaaaaaaaaaaacppppfbaaaaafakaaapka
aaaaaaaaaaaaaaedaaaaiadpaaaaaaaabpaaaaacaaaaaaiaaaaaahlabpaaaaac
aaaaaaiaabaachlabpaaaaacaaaaaaiaacaaahlabpaaaaacaaaaaajaaaaiapka
bpaaaaacaaaaaajaabaiapkaafaaaaadaaaachiaacaafflaadaaoekaaeaaaaae
aaaachiaacaaoekaacaaaalaaaaaoeiaaeaaaaaeaaaachiaaeaaoekaacaakkla
aaaaoeiaacaaaaadaaaaahiaaaaaoeiaafaaoekaaiaaaaadaaaaadiaaaaaoeia
aaaaoeiaecaaaaadaaaacpiaaaaaoeiaaaaioekaecaaaaadabaacpiaaaaaoela
abaioekaafaaaaadaaaachiaaaaaaaiaaaaaoekaafaaaaadacaaahiaaaaaoeia
abaaoekaacaaaaadadaaahiaacaaoelbaiaaoekaaiaaaaadaaaaaiiaadaaoeia
adaaoeiaahaaaaacaaaaaiiaaaaappiaacaaaaadaeaaahiaacaaoelbajaaoeka
ceaaaaacafaachiaaeaaoeiaaeaaaaaeadaachiaadaaoeiaaaaappiaafaaoeia
aiaaaaadaaaaciiaabaaoelaafaaoeiaalaaaaadacaaciiaaaaappiaakaaaaka
ceaaaaacaeaachiaadaaoeiaaiaaaaadaaaaciiaabaaoelaaeaaoeiaalaaaaad
adaaabiaaaaappiaakaaaakaabaaaaacaaaaaiiaakaaffkaafaaaaadaaaaaiia
aaaappiaahaaaakacaaaaaadaeaaabiaadaaaaiaaaaappiaafaaaaadaaaaaiia
abaappiaaeaaaaiaafaaaaadabaachiaabaaoeiaagaaoekaafaaaaadaaaachia
aaaaoeiaabaaoeiaafaaaaadabaaahiaaaaappiaacaaoeiaaeaaaaaeaaaachia
aaaaoeiaacaappiaabaaoeiaabaaaaacaaaaciiaakaakkkaabaaaaacaaaicpia
aaaaoeiappppaaaafdeieefcieaeaaaaeaaaaaaacbabaaaafjaaaaaeegiocaaa
aaaaaaaaapaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaa
acaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaa
adaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaaaaaaaajhcaabaaa
aaaaaaaaegbcbaiaebaaaaaaadaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaah
icaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaaaaaaaaajhcaabaaaabaaaaaaegbcbaiaebaaaaaaadaaaaaa
egiccaaaabaaaaaaaeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaa
egacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaaj
hcaabaaaabaaaaaaegacbaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
baaaaaahbcaabaaaaaaaaaaaegbcbaaaacaaaaaaegacbaaaaaaaaaaabaaaaaah
ccaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaafccaabaaa
aaaaaaaabkaabaaaaaaaaaaadiaaaaahocaabaaaaaaaaaaafgafbaaaaaaaaaaa
agajbaaaabaaaaaabaaaaaahccaabaaaaaaaaaaaegbcbaaaacaaaaaajgahbaaa
aaaaaaaadeaaaaakdcaabaaaaaaaaaaaegaabaaaaaaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaacpaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaa
diaaaaaiecaabaaaaaaaaaaaakiacaaaaaaaaaaaaoaaaaaaabeaaaaaaaaaaaed
diaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaackaabaaaaaaaaaaabjaaaaaf
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaahccaabaaaaaaaaaaa
bkaabaaaaaaaaaaadkaabaaaabaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaa
abaaaaaaegiccaaaaaaaaaaaanaaaaaadiaaaaaihcaabaaaacaaaaaafgbfbaaa
adaaaaaaegiccaaaaaaaaaaaakaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaa
aaaaaaaaajaaaaaaagbabaaaadaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaa
acaaaaaaegiccaaaaaaaaaaaalaaaaaakgbkbaaaadaaaaaaegacbaaaacaaaaaa
aaaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaamaaaaaa
baaaaaahecaabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaaefaaaaaj
pcaabaaaacaaaaaakgakbaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaa
diaaaaaihcaabaaaacaaaaaaagaabaaaacaaaaaaegiccaaaaaaaaaaaagaaaaaa
diaaaaaihcaabaaaadaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaahaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadiaaaaah
ocaabaaaaaaaaaaafgafbaaaaaaaaaaaagajbaaaadaaaaaadcaaaaajhccabaaa
aaaaaaaaegacbaaaabaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaadgaaaaaf
iccabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaabejfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahahaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklkl"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 4 [_Color]
Vector 2 [_LightColor0]
Float 5 [_Shininess]
Vector 3 [_SpecColor]
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
SetTexture 0 [_MainTex] 2D 0
"ps_2_0
def c6, 0, 128, 1, 0
dcl t0.xy
dcl_pp t1.xyz
dcl t2.xyz
dcl_2d s0
texld_pp r0, t0, s0
add r1.xyz, -t2, c0
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mad_pp r1.xyz, r1, r1.w, c1
nrm_pp r2.xyz, r1
dp3_pp r1.x, t1, r2
max r2.x, r1.x, c6.x
mov r1.y, c6.y
mul r1.x, r1.y, c5.x
pow r3.w, r2.x, r1.x
mul r0.w, r0.w, r3.w
mul_pp r0.xyz, r0, c4
mul_pp r0.xyz, r0, c2
mov r1.xyz, c2
mul r1.xyz, r1, c3
mul r1.xyz, r0.w, r1
dp3_pp r0.w, t1, c1
max_pp r1.w, r0.w, c6.x
mad_pp r0.xyz, r0, r1.w, r1
mov_pp r0.w, c6.z
mov_pp oC0, r0

"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" }
SetTexture 0 [_MainTex] 2D 0
ConstBuffer "$Globals" 192
Vector 96 [_LightColor0]
Vector 112 [_SpecColor]
Vector 144 [_Color]
Float 160 [_Shininess]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
"ps_4_0
root12:abadabaa
eefiecedbnlehdihjhhomknmjoeieidcpbgabjliabaaaaaabiaeaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcciadaaaaeaaaaaaamkaaaaaafjaaaaaeegiocaaa
aaaaaaaaalaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaa
acaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
hcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaaaaaaaaaj
hcaabaaaaaaaaaaaegbcbaiaebaaaaaaadaaaaaaegiccaaaabaaaaaaaeaaaaaa
baaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgapbaaaaaaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaacaaaaaaegacbaaaaaaaaaaa
deaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaaiccaabaaaaaaaaaaaakiacaaa
aaaaaaaaakaaaaaaabeaaaaaaaaaaaeddiaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaabkaabaaaaaaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaadkaabaaaabaaaaaa
diaaaaaiocaabaaaaaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaaajaaaaaa
diaaaaaiocaabaaaaaaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaaagaaaaaa
diaaaaajhcaabaaaabaaaaaaegiccaaaaaaaaaaaagaaaaaaegiccaaaaaaaaaaa
ahaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaaibcaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaaaaaaaaa
deaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaadcaaaaaj
hccabaaaaaaaaaaajgahbaaaaaaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaa
dgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" }
SetTexture 0 [_MainTex] 2D 0
ConstBuffer "$Globals" 192
Vector 96 [_LightColor0]
Vector 112 [_SpecColor]
Vector 144 [_Color]
Float 160 [_Shininess]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
"ps_4_0_level_9_1
root12:abadabaa
eefiecedjhaknmcofjflaipmjclbcdppnfhlfiflabaaaaaabmagaaaaaeaaaaaa
daaaaaaadaacaaaagaafaaaaoiafaaaaebgpgodjpiabaaaapiabaaaaaaacpppp
kaabaaaafiaaaaaaaeaaciaaaaaafiaaaaaafiaaabaaceaaaaaafiaaaaaaaaaa
aaaaagaaacaaaaaaaaaaaaaaaaaaajaaacaaacaaaaaaaaaaabaaaeaaabaaaeaa
aaaaaaaaacaaaaaaabaaafaaaaaaaaaaaaacppppfbaaaaafagaaapkaaaaaaaaa
aaaaaaedaaaaiadpaaaaaaaabpaaaaacaaaaaaiaaaaaahlabpaaaaacaaaaaaia
abaachlabpaaaaacaaaaaaiaacaaahlabpaaaaacaaaaaajaaaaiapkaecaaaaad
aaaacpiaaaaaoelaaaaioekaacaaaaadabaaahiaacaaoelbaeaaoekaaiaaaaad
abaaaiiaabaaoeiaabaaoeiaahaaaaacabaaaiiaabaappiaaeaaaaaeabaachia
abaaoeiaabaappiaafaaoekaceaaaaacacaachiaabaaoeiaaiaaaaadabaacbia
abaaoelaacaaoeiaalaaaaadacaaabiaabaaaaiaagaaaakaabaaaaacabaaacia
agaaffkaafaaaaadabaaabiaabaaffiaadaaaakacaaaaaadadaaaiiaacaaaaia
abaaaaiaafaaaaadaaaaaiiaaaaappiaadaappiaafaaaaadaaaachiaaaaaoeia
acaaoekaafaaaaadaaaachiaaaaaoeiaaaaaoekaabaaaaacabaaahiaaaaaoeka
afaaaaadabaaahiaabaaoeiaabaaoekaafaaaaadabaaahiaaaaappiaabaaoeia
aiaaaaadaaaaciiaabaaoelaafaaoekaalaaaaadabaaciiaaaaappiaagaaaaka
aeaaaaaeaaaachiaaaaaoeiaabaappiaabaaoeiaabaaaaacaaaaciiaagaakkka
abaaaaacaaaicpiaaaaaoeiappppaaaafdeieefcciadaaaaeaaaaaaamkaaaaaa
fjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaa
fjaaaaaeegiocaaaacaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
acaaaaaaaaaaaaajhcaabaaaaaaaaaaaegbcbaiaebaaaaaaadaaaaaaegiccaaa
abaaaaaaaeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
aaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaacaaaaaaaaaaaaaa
baaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaacaaaaaa
egacbaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaaiccaabaaa
aaaaaaaaakiacaaaaaaaaaaaakaaaaaaabeaaaaaaaaaaaeddiaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaabjaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
dkaabaaaabaaaaaadiaaaaaiocaabaaaaaaaaaaaagajbaaaabaaaaaaagijcaaa
aaaaaaaaajaaaaaadiaaaaaiocaabaaaaaaaaaaafgaobaaaaaaaaaaaagijcaaa
aaaaaaaaagaaaaaadiaaaaajhcaabaaaabaaaaaaegiccaaaaaaaaaaaagaaaaaa
egiccaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaabaaaaaaibcaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaa
acaaaaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaadcaaaaajhccabaaaaaaaaaaajgahbaaaaaaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab
ejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaa
heaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaheaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}
SubProgram "opengl " {
Keywords { "SPOT" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "SPOT" }
Matrix 0 [_LightMatrix0]
Vector 8 [_Color]
Vector 6 [_LightColor0]
Float 9 [_Shininess]
Vector 7 [_SpecColor]
Vector 4 [_WorldSpaceCameraPos]
Vector 5 [_WorldSpaceLightPos0]
SetTexture 0 [_LightTexture0] 2D 0
SetTexture 1 [_LightTextureB0] 2D 1
SetTexture 2 [_MainTex] 2D 2
"ps_2_0
def c10, 1, 0.5, 0, 128
dcl t0.xy
dcl_pp t1.xyz
dcl t2.xyz
dcl_2d s0
dcl_2d s1
dcl_2d s2
mov r0.xyz, t2
mov_pp r0.w, c10.x
dp4_pp r1.x, c0, r0
dp4_pp r1.y, c1, r0
dp4_pp r1.z, c2, r0
dp4_pp r1.w, c3, r0
rcp r1.w, r1.w
mad_pp r0.xy, r1, r1.w, c10.y
dp3 r1.xy, r1, r1
texld_pp r0, r0, s0
texld_pp r2, r1, s1
texld_pp r3, t0, s2
mul r0.x, r0.w, r2.x
mul_pp r0.xyz, r0.x, c6
cmp_pp r0.xyz, -r1.z, c10.z, r0
mul r1.xyz, r0, c7
add r2.xyz, -t2, c4
dp3 r0.w, r2, r2
rsq r0.w, r0.w
add r4.xyz, -t2, c5
nrm_pp r5.xyz, r4
mad_pp r2.xyz, r2, r0.w, r5
dp3_pp r0.w, t1, r5
max_pp r1.w, r0.w, c10.z
nrm_pp r4.xyz, r2
dp3_pp r0.w, t1, r4
max r2.x, r0.w, c10.z
mov r0.w, c10.w
mul r0.w, r0.w, c9.x
pow r4.x, r2.x, r0.w
mul r0.w, r3.w, r4.x
mul_pp r2.xyz, r3, c8
mul_pp r0.xyz, r0, r2
mul r1.xyz, r0.w, r1
mad_pp r0.xyz, r0, r1.w, r1
mov_pp r0.w, c10.x
mov_pp oC0, r0

"
}
SubProgram "d3d11 " {
Keywords { "SPOT" }
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_LightTexture0] 2D 0
SetTexture 2 [_LightTextureB0] 2D 1
ConstBuffer "$Globals" 256
Matrix 144 [_LightMatrix0]
Vector 96 [_LightColor0]
Vector 112 [_SpecColor]
Vector 208 [_Color]
Float 224 [_Shininess]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
"ps_4_0
root12:adadadaa
eefiecedgbdcnnchbblcpfmoplcdmchbhldmpppdabaaaaaahiagaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefciiafaaaaeaaaaaaagcabaaaafjaaaaaeegiocaaa
aaaaaaaaapaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaa
acaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaadaaaaaaegiocaaaaaaaaaaaakaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaaaaaaaaaajaaaaaaagbabaaaadaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaaaaaaaaalaaaaaakgbkbaaaadaaaaaaegaobaaa
aaaaaaaaaaaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaa
amaaaaaaaoaaaaahdcaabaaaabaaaaaaegaabaaaaaaaaaaapgapbaaaaaaaaaaa
aaaaaaakdcaabaaaabaaaaaaegaabaaaabaaaaaaaceaaaaaaaaaaadpaaaaaadp
aaaaaaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaaaaaaaaadbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaa
ckaabaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
aaaaaaaaefaaaaajpcaabaaaacaaaaaaagaabaaaaaaaaaaaeghobaaaacaaaaaa
aagabaaaabaaaaaaabaaaaahbcaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaiadpdiaaaaahbcaabaaaaaaaaaaadkaabaaaabaaaaaaakaabaaaaaaaaaaa
diaaaaahbcaabaaaaaaaaaaaakaabaaaacaaaaaaakaabaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaaagaabaaaaaaaaaaaegiccaaaaaaaaaaaagaaaaaadiaaaaai
hcaabaaaabaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaahaaaaaaaaaaaaaj
hcaabaaaacaaaaaaegbcbaiaebaaaaaaadaaaaaaegiccaaaacaaaaaaaaaaaaaa
baaaaaahicaabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaa
aaaaaaaaegacbaaaacaaaaaaaaaaaaajhcaabaaaadaaaaaaegbcbaiaebaaaaaa
adaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
adaaaaaaegacbaaaadaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
dcaaaaajhcaabaaaadaaaaaaegacbaaaadaaaaaapgapbaaaaaaaaaaaegacbaaa
acaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaaegacbaaaacaaaaaa
deaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaabaaaaaah
icaabaaaabaaaaaaegacbaaaadaaaaaaegacbaaaadaaaaaaeeaaaaaficaabaaa
abaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaabaaaaaa
egacbaaaadaaaaaabaaaaaahicaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaa
acaaaaaadeaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaaa
cpaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaaibcaabaaaacaaaaaa
akiacaaaaaaaaaaaaoaaaaaaabeaaaaaaaaaaaeddiaaaaahicaabaaaabaaaaaa
dkaabaaaabaaaaaaakaabaaaacaaaaaabjaaaaaficaabaaaabaaaaaadkaabaaa
abaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaacaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaa
acaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaa
anaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaadcaaaaaj
hccabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaa
dgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "SPOT" }
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_LightTexture0] 2D 0
SetTexture 2 [_LightTextureB0] 2D 1
ConstBuffer "$Globals" 256
Matrix 144 [_LightMatrix0]
Vector 96 [_LightColor0]
Vector 112 [_SpecColor]
Vector 208 [_Color]
Float 224 [_Shininess]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
"ps_4_0_level_9_1
root12:adadadaa
eefiecedanlbcbekhhacijpkiopbohjnpfbbeoioabaaaaaahiajaaaaaeaaaaaa
daaaaaaacmadaaaalmaiaaaaeeajaaaaebgpgodjpeacaaaapeacaaaaaaacpppp
jeacaaaagaaaaaaaaeaadaaaaaaagaaaaaaagaaaadaaceaaaaaagaaaabaaaaaa
acababaaaaacacaaaaaaagaaacaaaaaaaaaaaaaaaaaaajaaagaaacaaaaaaaaaa
abaaaeaaabaaaiaaaaaaaaaaacaaaaaaabaaajaaaaaaaaaaaaacppppfbaaaaaf
akaaapkaaaaaaadpaaaaaaaaaaaaaaedaaaaiadpbpaaaaacaaaaaaiaaaaaahla
bpaaaaacaaaaaaiaabaachlabpaaaaacaaaaaaiaacaaahlabpaaaaacaaaaaaja
aaaiapkabpaaaaacaaaaaajaabaiapkabpaaaaacaaaaaajaacaiapkaafaaaaad
aaaacpiaacaafflaadaaoekaaeaaaaaeaaaacpiaacaaoekaacaaaalaaaaaoeia
aeaaaaaeaaaacpiaaeaaoekaacaakklaaaaaoeiaacaaaaadaaaacpiaaaaaoeia
afaaoekaagaaaaacaaaaaiiaaaaappiaaeaaaaaeabaacdiaaaaaoeiaaaaappia
akaaaakaaiaaaaadaaaaadiaaaaaoeiaaaaaoeiaecaaaaadabaacpiaabaaoeia
aaaioekaecaaaaadacaacpiaaaaaoeiaabaioekaecaaaaadadaacpiaaaaaoela
acaioekaafaaaaadaaaaabiaabaappiaacaaaaiaafaaaaadabaachiaaaaaaaia
aaaaoekafiaaaaaeaaaachiaaaaakkibakaaffkaabaaoeiaafaaaaadabaaahia
aaaaoeiaabaaoekaacaaaaadacaaahiaacaaoelbaiaaoekaaiaaaaadaaaaaiia
acaaoeiaacaaoeiaahaaaaacaaaaaiiaaaaappiaacaaaaadaeaaahiaacaaoelb
ajaaoekaceaaaaacafaachiaaeaaoeiaaeaaaaaeacaachiaacaaoeiaaaaappia
afaaoeiaaiaaaaadaaaaciiaabaaoelaafaaoeiaalaaaaadabaaciiaaaaappia
akaaffkaceaaaaacaeaachiaacaaoeiaaiaaaaadaaaaciiaabaaoelaaeaaoeia
alaaaaadacaaabiaaaaappiaakaaffkaabaaaaacaaaaaiiaakaakkkaafaaaaad
aaaaaiiaaaaappiaahaaaakacaaaaaadaeaaabiaacaaaaiaaaaappiaafaaaaad
aaaaaiiaadaappiaaeaaaaiaafaaaaadacaachiaadaaoeiaagaaoekaafaaaaad
aaaachiaaaaaoeiaacaaoeiaafaaaaadabaaahiaaaaappiaabaaoeiaaeaaaaae
aaaachiaaaaaoeiaabaappiaabaaoeiaabaaaaacaaaaciiaakaappkaabaaaaac
aaaicpiaaaaaoeiappppaaaafdeieefciiafaaaaeaaaaaaagcabaaaafjaaaaae
egiocaaaaaaaaaaaapaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaae
egiocaaaacaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaa
abaaaaaafkaaaaadaagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaa
adaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaadaaaaaaegiocaaaaaaaaaaaakaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaaaaaaaaaajaaaaaaagbabaaaadaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaalaaaaaakgbkbaaaadaaaaaa
egaobaaaaaaaaaaaaaaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaa
aaaaaaaaamaaaaaaaoaaaaahdcaabaaaabaaaaaaegaabaaaaaaaaaaapgapbaaa
aaaaaaaaaaaaaaakdcaabaaaabaaaaaaegaabaaaabaaaaaaaceaaaaaaaaaaadp
aaaaaadpaaaaaaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaaaaaaaaadbaaaaahicaabaaaaaaaaaaaabeaaaaa
aaaaaaaackaabaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaaagaabaaaaaaaaaaaeghobaaa
acaaaaaaaagabaaaabaaaaaaabaaaaahbcaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaiadpdiaaaaahbcaabaaaaaaaaaaadkaabaaaabaaaaaaakaabaaa
aaaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaacaaaaaaakaabaaaaaaaaaaa
diaaaaaihcaabaaaaaaaaaaaagaabaaaaaaaaaaaegiccaaaaaaaaaaaagaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaahaaaaaa
aaaaaaajhcaabaaaacaaaaaaegbcbaiaebaaaaaaadaaaaaaegiccaaaacaaaaaa
aaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaa
pgapbaaaaaaaaaaaegacbaaaacaaaaaaaaaaaaajhcaabaaaadaaaaaaegbcbaia
ebaaaaaaadaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaadaaaaaaegacbaaaadaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadcaaaaajhcaabaaaadaaaaaaegacbaaaadaaaaaapgapbaaaaaaaaaaa
egacbaaaacaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaaegacbaaa
acaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaa
baaaaaahicaabaaaabaaaaaaegacbaaaadaaaaaaegacbaaaadaaaaaaeeaaaaaf
icaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaa
abaaaaaaegacbaaaadaaaaaabaaaaaahicaabaaaabaaaaaaegbcbaaaacaaaaaa
egacbaaaacaaaaaadeaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaa
aaaaaaaacpaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaaibcaabaaa
acaaaaaaakiacaaaaaaaaaaaaoaaaaaaabeaaaaaaaaaaaeddiaaaaahicaabaaa
abaaaaaadkaabaaaabaaaaaaakaabaaaacaaaaaabjaaaaaficaabaaaabaaaaaa
dkaabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaacaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaa
dkaabaaaacaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaa
aaaaaaaaanaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
acaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaa
dcaaaaajhccabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
abaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaabejfdeheo
iaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaa
apaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaaheaaaaaa
abaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaheaaaaaaacaaaaaaaaaaaaaa
adaaaaaaadaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Matrix 0 [_LightMatrix0] 3
Vector 7 [_Color]
Vector 5 [_LightColor0]
Float 8 [_Shininess]
Vector 6 [_SpecColor]
Vector 3 [_WorldSpaceCameraPos]
Vector 4 [_WorldSpaceLightPos0]
SetTexture 0 [_LightTexture0] CUBE 0
SetTexture 1 [_LightTextureB0] 2D 1
SetTexture 2 [_MainTex] 2D 2
"ps_2_0
def c9, 1, 0, 128, 0
dcl t0.xy
dcl_pp t1.xyz
dcl t2.xyz
dcl_cube s0
dcl_2d s1
dcl_2d s2
mov r0.xyz, t2
mov_pp r0.w, c9.x
dp4 r1.x, c0, r0
dp4 r1.y, c1, r0
dp4 r1.z, c2, r0
dp3 r0.xy, r1, r1
texld r1, r1, s0
texld r0, r0, s1
texld_pp r2, t0, s2
mul_pp r0.x, r1.w, r0.x
mul_pp r0.xyz, r0.x, c5
mul r1.xyz, r0, c6
add r3.xyz, -t2, c3
dp3 r0.w, r3, r3
rsq r0.w, r0.w
add r4.xyz, -t2, c4
nrm_pp r5.xyz, r4
mad_pp r3.xyz, r3, r0.w, r5
dp3_pp r0.w, t1, r5
max_pp r1.w, r0.w, c9.y
nrm_pp r4.xyz, r3
dp3_pp r0.w, t1, r4
max r3.x, r0.w, c9.y
mov r0.w, c9.z
mul r0.w, r0.w, c8.x
pow r4.x, r3.x, r0.w
mul r0.w, r2.w, r4.x
mul_pp r2.xyz, r2, c7
mul_pp r0.xyz, r0, r2
mul r1.xyz, r0.w, r1
mad_pp r0.xyz, r0, r1.w, r1
mov_pp r0.w, c9.x
mov_pp oC0, r0

"
}
SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" }
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_LightTextureB0] 2D 1
SetTexture 2 [_LightTexture0] CUBE 0
ConstBuffer "$Globals" 256
Matrix 144 [_LightMatrix0]
Vector 96 [_LightColor0]
Vector 112 [_SpecColor]
Vector 208 [_Color]
Float 224 [_Shininess]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
"ps_4_0
root12:adadadaa
eefiecedlndfoehjbeagbhbgdcmnghiinoapobfeabaaaaaanaafaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcoaaeaaaaeaaaaaaadiabaaaafjaaaaaeegiocaaa
aaaaaaaaapaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaa
acaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafidaaaaeaahabaaaacaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaaaaaaaajhcaabaaaaaaaaaaa
egbcbaiaebaaaaaaadaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaaaaaaaaajhcaabaaaabaaaaaaegbcbaiaebaaaaaaadaaaaaaegiccaaa
abaaaaaaaeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaa
abaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaajhcaabaaa
abaaaaaaegacbaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaabaaaaaah
bcaabaaaaaaaaaaaegbcbaaaacaaaaaaegacbaaaaaaaaaaabaaaaaahccaabaaa
aaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaafccaabaaaaaaaaaaa
bkaabaaaaaaaaaaadiaaaaahocaabaaaaaaaaaaafgafbaaaaaaaaaaaagajbaaa
abaaaaaabaaaaaahccaabaaaaaaaaaaaegbcbaaaacaaaaaajgahbaaaaaaaaaaa
deaaaaakdcaabaaaaaaaaaaaegaabaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaacpaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaadiaaaaai
ecaabaaaaaaaaaaaakiacaaaaaaaaaaaaoaaaaaaabeaaaaaaaaaaaeddiaaaaah
ccaabaaaaaaaaaaabkaabaaaaaaaaaaackaabaaaaaaaaaaabjaaaaafccaabaaa
aaaaaaaabkaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaacaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaa
aaaaaaaadkaabaaaabaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaa
egiccaaaaaaaaaaaanaaaaaadiaaaaaihcaabaaaacaaaaaafgbfbaaaadaaaaaa
egiccaaaaaaaaaaaakaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaaaaaaaaa
ajaaaaaaagbabaaaadaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaaaaaaaaaalaaaaaakgbkbaaaadaaaaaaegacbaaaacaaaaaaaaaaaaai
hcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaamaaaaaabaaaaaah
ecaabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaa
acaaaaaaegacbaaaacaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaaefaaaaaj
pcaabaaaadaaaaaakgakbaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaa
diaaaaahecaabaaaaaaaaaaadkaabaaaacaaaaaaakaabaaaadaaaaaadiaaaaai
hcaabaaaacaaaaaakgakbaaaaaaaaaaaegiccaaaaaaaaaaaagaaaaaadiaaaaai
hcaabaaaadaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaahaaaaaadiaaaaah
hcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadiaaaaahocaabaaa
aaaaaaaafgafbaaaaaaaaaaaagajbaaaadaaaaaadcaaaaajhccabaaaaaaaaaaa
egacbaaaabaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaadgaaaaaficcabaaa
aaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "POINT_COOKIE" }
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_LightTextureB0] 2D 1
SetTexture 2 [_LightTexture0] CUBE 0
ConstBuffer "$Globals" 256
Matrix 144 [_LightMatrix0]
Vector 96 [_LightColor0]
Vector 112 [_SpecColor]
Vector 208 [_Color]
Float 224 [_Shininess]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
"ps_4_0_level_9_1
root12:adadadaa
eefiecedelegdbijjmhalpbbmjnhcabplpclghoaabaaaaaakiaiaaaaaeaaaaaa
daaaaaaaaeadaaaaomahaaaaheaiaaaaebgpgodjmmacaaaammacaaaaaaacpppp
gmacaaaagaaaaaaaaeaadaaaaaaagaaaaaaagaaaadaaceaaaaaagaaaacaaaaaa
abababaaaaacacaaaaaaagaaacaaaaaaaaaaaaaaaaaaajaaagaaacaaaaaaaaaa
abaaaeaaabaaaiaaaaaaaaaaacaaaaaaabaaajaaaaaaaaaaaaacppppfbaaaaaf
akaaapkaaaaaaaaaaaaaaaedaaaaiadpaaaaaaaabpaaaaacaaaaaaiaaaaaahla
bpaaaaacaaaaaaiaabaachlabpaaaaacaaaaaaiaacaaahlabpaaaaacaaaaaaji
aaaiapkabpaaaaacaaaaaajaabaiapkabpaaaaacaaaaaajaacaiapkaafaaaaad
aaaachiaacaafflaadaaoekaaeaaaaaeaaaachiaacaaoekaacaaaalaaaaaoeia
aeaaaaaeaaaachiaaeaaoekaacaakklaaaaaoeiaacaaaaadaaaaahiaaaaaoeia
afaaoekaaiaaaaadaaaaaiiaaaaaoeiaaaaaoeiaabaaaaacabaaadiaaaaappia
ecaaaaadaaaaapiaaaaaoeiaaaaioekaecaaaaadabaaapiaabaaoeiaabaioeka
ecaaaaadacaacpiaaaaaoelaacaioekaafaaaaadaaaacbiaaaaappiaabaaaaia
afaaaaadaaaachiaaaaaaaiaaaaaoekaafaaaaadabaaahiaaaaaoeiaabaaoeka
acaaaaadadaaahiaacaaoelbaiaaoekaaiaaaaadaaaaaiiaadaaoeiaadaaoeia
ahaaaaacaaaaaiiaaaaappiaacaaaaadaeaaahiaacaaoelbajaaoekaceaaaaac
afaachiaaeaaoeiaaeaaaaaeadaachiaadaaoeiaaaaappiaafaaoeiaaiaaaaad
aaaaciiaabaaoelaafaaoeiaalaaaaadabaaciiaaaaappiaakaaaakaceaaaaac
aeaachiaadaaoeiaaiaaaaadaaaaciiaabaaoelaaeaaoeiaalaaaaadadaaabia
aaaappiaakaaaakaabaaaaacaaaaaiiaakaaffkaafaaaaadaaaaaiiaaaaappia
ahaaaakacaaaaaadaeaaabiaadaaaaiaaaaappiaafaaaaadaaaaaiiaacaappia
aeaaaaiaafaaaaadacaachiaacaaoeiaagaaoekaafaaaaadaaaachiaaaaaoeia
acaaoeiaafaaaaadabaaahiaaaaappiaabaaoeiaaeaaaaaeaaaachiaaaaaoeia
abaappiaabaaoeiaabaaaaacaaaaciiaakaakkkaabaaaaacaaaicpiaaaaaoeia
ppppaaaafdeieefcoaaeaaaaeaaaaaaadiabaaaafjaaaaaeegiocaaaaaaaaaaa
apaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
abaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaad
aagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafidaaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacaeaaaaaaaaaaaaajhcaabaaaaaaaaaaaegbcbaia
ebaaaaaaadaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
aaaaaaajhcaabaaaabaaaaaaegbcbaiaebaaaaaaadaaaaaaegiccaaaabaaaaaa
aeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaajhcaabaaaabaaaaaa
egacbaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaabaaaaaahbcaabaaa
aaaaaaaaegbcbaaaacaaaaaaegacbaaaaaaaaaaabaaaaaahccaabaaaaaaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaafccaabaaaaaaaaaaabkaabaaa
aaaaaaaadiaaaaahocaabaaaaaaaaaaafgafbaaaaaaaaaaaagajbaaaabaaaaaa
baaaaaahccaabaaaaaaaaaaaegbcbaaaacaaaaaajgahbaaaaaaaaaaadeaaaaak
dcaabaaaaaaaaaaaegaabaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaacpaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaadiaaaaaiecaabaaa
aaaaaaaaakiacaaaaaaaaaaaaoaaaaaaabeaaaaaaaaaaaeddiaaaaahccaabaaa
aaaaaaaabkaabaaaaaaaaaaackaabaaaaaaaaaaabjaaaaafccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaacaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaa
dkaabaaaabaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaa
aaaaaaaaanaaaaaadiaaaaaihcaabaaaacaaaaaafgbfbaaaadaaaaaaegiccaaa
aaaaaaaaakaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaaaaaaaaaajaaaaaa
agbabaaaadaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaa
aaaaaaaaalaaaaaakgbkbaaaadaaaaaaegacbaaaacaaaaaaaaaaaaaihcaabaaa
acaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaamaaaaaabaaaaaahecaabaaa
aaaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaa
egacbaaaacaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaa
adaaaaaakgakbaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaah
ecaabaaaaaaaaaaadkaabaaaacaaaaaaakaabaaaadaaaaaadiaaaaaihcaabaaa
acaaaaaakgakbaaaaaaaaaaaegiccaaaaaaaaaaaagaaaaaadiaaaaaihcaabaaa
adaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaa
abaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadiaaaaahocaabaaaaaaaaaaa
fgafbaaaaaaaaaaaagajbaaaadaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaa
abaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaiadpdoaaaaabejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklkl"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Matrix 0 [_LightMatrix0] 2
Vector 6 [_Color]
Vector 4 [_LightColor0]
Float 7 [_Shininess]
Vector 5 [_SpecColor]
Vector 2 [_WorldSpaceCameraPos]
Vector 3 [_WorldSpaceLightPos0]
SetTexture 0 [_LightTexture0] 2D 0
SetTexture 1 [_MainTex] 2D 1
"ps_2_0
def c8, 1, 0, 128, 0
dcl t0.xy
dcl_pp t1.xyz
dcl t2.xyz
dcl_2d s0
dcl_2d s1
mov r0.xyz, t2
mov_pp r0.w, c8.x
dp4 r1.x, c0, r0
dp4 r1.y, c1, r0
texld_pp r0, t0, s1
texld_pp r1, r1, s0
add r1.xyz, -t2, c2
dp3 r2.w, r1, r1
rsq r2.x, r2.w
mad_pp r1.xyz, r1, r2.x, c3
nrm_pp r2.xyz, r1
dp3_pp r1.x, t1, r2
max r2.x, r1.x, c8.y
mov r1.z, c8.z
mul r1.x, r1.z, c7.x
pow r3.w, r2.x, r1.x
mul r0.w, r0.w, r3.w
mul_pp r0.xyz, r0, c6
mul_pp r1.xyz, r1.w, c4
mul r2.xyz, r1, c5
mul_pp r0.xyz, r0, r1
mul r1.xyz, r0.w, r2
dp3_pp r0.w, t1, c3
max_pp r1.w, r0.w, c8.y
mad_pp r0.xyz, r0, r1.w, r1
mov_pp r0.w, c8.x
mov_pp oC0, r0

"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_LightTexture0] 2D 0
ConstBuffer "$Globals" 256
Matrix 144 [_LightMatrix0]
Vector 96 [_LightColor0]
Vector 112 [_SpecColor]
Vector 208 [_Color]
Float 224 [_Shininess]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
"ps_4_0
root12:acadacaa
eefiecedmneghdekmbppkfmepfekcoepjicnhoieabaaaaaaaaafaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcbaaeaaaaeaaaaaaaaeabaaaafjaaaaaeegiocaaa
aaaaaaaaapaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaa
acaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaa
adaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaajhcaabaaa
aaaaaaaaegbcbaiaebaaaaaaadaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaah
icaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgapbaaaaaaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
baaaaaahbcaabaaaaaaaaaaaegbcbaaaacaaaaaaegacbaaaaaaaaaaadeaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaadiaaaaaiccaabaaaaaaaaaaaakiacaaaaaaaaaaa
aoaaaaaaabeaaaaaaaaaaaeddiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
bkaabaaaaaaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaaj
pcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaa
diaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaadkaabaaaabaaaaaadiaaaaai
ocaabaaaaaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaaanaaaaaadiaaaaai
dcaabaaaabaaaaaafgbfbaaaadaaaaaaegiacaaaaaaaaaaaakaaaaaadcaaaaak
dcaabaaaabaaaaaaegiacaaaaaaaaaaaajaaaaaaagbabaaaadaaaaaaegaabaaa
abaaaaaadcaaaaakdcaabaaaabaaaaaaegiacaaaaaaaaaaaalaaaaaakgbkbaaa
adaaaaaaegaabaaaabaaaaaaaaaaaaaidcaabaaaabaaaaaaegaabaaaabaaaaaa
egiacaaaaaaaaaaaamaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaapgapbaaa
abaaaaaaegiccaaaaaaaaaaaagaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaa
abaaaaaaegiccaaaaaaaaaaaahaaaaaadiaaaaahocaabaaaaaaaaaaafgaobaaa
aaaaaaaaagajbaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaaaaaaaaa
egacbaaaacaaaaaabaaaaaaibcaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaa
acaaaaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaadcaaaaajhccabaaaaaaaaaaajgahbaaaaaaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab
"
}
SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL_COOKIE" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_LightTexture0] 2D 0
ConstBuffer "$Globals" 256
Matrix 144 [_LightMatrix0]
Vector 96 [_LightColor0]
Vector 112 [_SpecColor]
Vector 208 [_Color]
Float 224 [_Shininess]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
"ps_4_0_level_9_1
root12:acadacaa
eefiecedlbkddbpogokoafacdipfgchnhnojkgjeabaaaaaahaahaaaaaeaaaaaa
daaaaaaajmacaaaaleagaaaadmahaaaaebgpgodjgeacaaaageacaaaaaaacpppp
aiacaaaafmaaaaaaaeaacmaaaaaafmaaaaaafmaaacaaceaaaaaafmaaabaaaaaa
aaababaaaaaaagaaacaaaaaaaaaaaaaaaaaaajaaagaaacaaaaaaaaaaabaaaeaa
abaaaiaaaaaaaaaaacaaaaaaabaaajaaaaaaaaaaaaacppppfbaaaaafakaaapka
aaaaaaaaaaaaaaedaaaaiadpaaaaaaaabpaaaaacaaaaaaiaaaaaahlabpaaaaac
aaaaaaiaabaachlabpaaaaacaaaaaaiaacaaahlabpaaaaacaaaaaajaaaaiapka
bpaaaaacaaaaaajaabaiapkaafaaaaadaaaacdiaacaafflaadaaoekaaeaaaaae
aaaacdiaacaaoekaacaaaalaaaaaoeiaaeaaaaaeaaaacdiaaeaaoekaacaakkla
aaaaoeiaacaaaaadaaaaadiaaaaaoeiaafaaoekaecaaaaadabaacpiaaaaaoela
abaioekaecaaaaadaaaacpiaaaaaoeiaaaaioekaacaaaaadaaaaahiaacaaoelb
aiaaoekaaiaaaaadacaaaiiaaaaaoeiaaaaaoeiaahaaaaacacaaabiaacaappia
aeaaaaaeaaaachiaaaaaoeiaacaaaaiaajaaoekaceaaaaacacaachiaaaaaoeia
aiaaaaadaaaacbiaabaaoelaacaaoeiaalaaaaadacaaabiaaaaaaaiaakaaaaka
abaaaaacaaaaaciaakaaffkaafaaaaadaaaaabiaaaaaffiaahaaaakacaaaaaad
adaaaiiaacaaaaiaaaaaaaiaafaaaaadabaaaiiaabaappiaadaappiaafaaaaad
aaaachiaabaaoeiaagaaoekaafaaaaadabaachiaaaaappiaaaaaoekaafaaaaad
acaaahiaabaaoeiaabaaoekaafaaaaadaaaachiaaaaaoeiaabaaoeiaafaaaaad
abaaahiaabaappiaacaaoeiaaiaaaaadaaaaciiaabaaoelaajaaoekaalaaaaad
abaaciiaaaaappiaakaaaakaaeaaaaaeaaaachiaaaaaoeiaabaappiaabaaoeia
abaaaaacaaaaciiaakaakkkaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefc
baaeaaaaeaaaaaaaaeabaaaafjaaaaaeegiocaaaaaaaaaaaapaaaaaafjaaaaae
egiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaafkaaaaad
aagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacadaaaaaaaaaaaaajhcaabaaaaaaaaaaaegbcbaiaebaaaaaa
adaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaa
acaaaaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
aaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaa
egbcbaaaacaaaaaaegacbaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
diaaaaaiccaabaaaaaaaaaaaakiacaaaaaaaaaaaaoaaaaaaabeaaaaaaaaaaaed
diaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaabjaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaadkaabaaaabaaaaaadiaaaaaiocaabaaaaaaaaaaaagajbaaa
abaaaaaaagijcaaaaaaaaaaaanaaaaaadiaaaaaidcaabaaaabaaaaaafgbfbaaa
adaaaaaaegiacaaaaaaaaaaaakaaaaaadcaaaaakdcaabaaaabaaaaaaegiacaaa
aaaaaaaaajaaaaaaagbabaaaadaaaaaaegaabaaaabaaaaaadcaaaaakdcaabaaa
abaaaaaaegiacaaaaaaaaaaaalaaaaaakgbkbaaaadaaaaaaegaabaaaabaaaaaa
aaaaaaaidcaabaaaabaaaaaaegaabaaaabaaaaaaegiacaaaaaaaaaaaamaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
aaaaaaaadiaaaaaihcaabaaaabaaaaaapgapbaaaabaaaaaaegiccaaaaaaaaaaa
agaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaa
ahaaaaaadiaaaaahocaabaaaaaaaaaaafgaobaaaaaaaaaaaagajbaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaaagaabaaaaaaaaaaaegacbaaaacaaaaaabaaaaaai
bcaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaaaaaaaaadeaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaadcaaaaajhccabaaa
aaaaaaaajgahbaaaaaaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadgaaaaaf
iccabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaabejfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahahaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklkl"
}
SubProgram "opengl " {
Keywords { "POINT" "FOG_EXP2" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "POINT" "FOG_EXP2" }
Matrix 0 [_LightMatrix0] 3
Vector 7 [_Color]
Vector 5 [_LightColor0]
Float 8 [_Shininess]
Vector 6 [_SpecColor]
Vector 3 [_WorldSpaceCameraPos]
Vector 4 [_WorldSpaceLightPos0]
SetTexture 0 [_LightTexture0] 2D 0
SetTexture 1 [_MainTex] 2D 1
"ps_2_0
def c9, 1, 0, 128, 0
dcl t0.xy
dcl_pp t1.xyz
dcl t2.xyz
dcl t4.x
dcl_2d s0
dcl_2d s1
mov r0.xyz, t2
mov_pp r0.w, c9.x
dp4 r1.x, c0, r0
dp4 r1.y, c1, r0
dp4 r1.z, c2, r0
dp3 r0.xy, r1, r1
texld_pp r0, r0, s0
texld_pp r1, t0, s1
mul_pp r0.xyz, r0.x, c5
mul r2.xyz, r0, c6
add r3.xyz, -t2, c3
dp3 r0.w, r3, r3
rsq r0.w, r0.w
add r4.xyz, -t2, c4
nrm_pp r5.xyz, r4
mad_pp r3.xyz, r3, r0.w, r5
dp3_pp r0.w, t1, r5
max_pp r2.w, r0.w, c9.y
nrm_pp r4.xyz, r3
dp3_pp r0.w, t1, r4
max r3.x, r0.w, c9.y
mov r0.w, c9.z
mul r0.w, r0.w, c8.x
pow r4.x, r3.x, r0.w
mul r0.w, r1.w, r4.x
mul_pp r1.xyz, r1, c7
mul_pp r0.xyz, r0, r1
mul r1.xyz, r0.w, r2
mad_pp r0.xyz, r0, r2.w, r1
mov_sat r0.w, t4.x
mul_pp r0.xyz, r0, r0.w
mov_pp r0.w, c9.x
mov_pp oC0, r0

"
}
SubProgram "d3d11 " {
Keywords { "POINT" "FOG_EXP2" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_LightTexture0] 2D 0
ConstBuffer "$Globals" 256
Matrix 144 [_LightMatrix0]
Vector 96 [_LightColor0]
Vector 112 [_SpecColor]
Vector 208 [_Color]
Float 224 [_Shininess]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
"ps_4_0
root12:acadacaa
eefiecedjlnlomoeegkjmiifdcemaniaokckeblbabaaaaaamiafaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaa
aeaeaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaimaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcmaaeaaaaeaaaaaaadaabaaaafjaaaaaeegiocaaaaaaaaaaaapaaaaaa
fjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadecbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
hcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaaaaaaaaj
hcaabaaaaaaaaaaaegbcbaiaebaaaaaaadaaaaaaegiccaaaacaaaaaaaaaaaaaa
baaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaaaaaaaaajhcaabaaaabaaaaaaegbcbaiaebaaaaaa
adaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
abaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
dcaaaaajhcaabaaaabaaaaaaegacbaaaabaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaacaaaaaaegacbaaaaaaaaaaa
baaaaaahccaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaf
ccaabaaaaaaaaaaabkaabaaaaaaaaaaadiaaaaahocaabaaaaaaaaaaafgafbaaa
aaaaaaaaagajbaaaabaaaaaabaaaaaahccaabaaaaaaaaaaaegbcbaaaacaaaaaa
jgahbaaaaaaaaaaadeaaaaakdcaabaaaaaaaaaaaegaabaaaaaaaaaaaaceaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaacpaaaaafccaabaaaaaaaaaaabkaabaaa
aaaaaaaadiaaaaaiecaabaaaaaaaaaaaakiacaaaaaaaaaaaaoaaaaaaabeaaaaa
aaaaaaeddiaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaackaabaaaaaaaaaaa
bjaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaahccaabaaa
aaaaaaaabkaabaaaaaaaaaaadkaabaaaabaaaaaadiaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaegiccaaaaaaaaaaaanaaaaaadiaaaaaihcaabaaaacaaaaaa
fgbfbaaaadaaaaaaegiccaaaaaaaaaaaakaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaaaaaaaaaajaaaaaaagbabaaaadaaaaaaegacbaaaacaaaaaadcaaaaak
hcaabaaaacaaaaaaegiccaaaaaaaaaaaalaaaaaakgbkbaaaadaaaaaaegacbaaa
acaaaaaaaaaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaa
amaaaaaabaaaaaahecaabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaa
efaaaaajpcaabaaaacaaaaaakgakbaaaaaaaaaaaeghobaaaabaaaaaaaagabaaa
aaaaaaaadiaaaaaihcaabaaaacaaaaaaagaabaaaacaaaaaaegiccaaaaaaaaaaa
agaaaaaadiaaaaaihcaabaaaadaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaa
ahaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
diaaaaahocaabaaaaaaaaaaafgafbaaaaaaaaaaaagajbaaaadaaaaaadcaaaaaj
hcaabaaaaaaaaaaaegacbaaaabaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaa
dgcaaaaficaabaaaaaaaaaaackbabaaaabaaaaaadiaaaaahhccabaaaaaaaaaaa
egacbaaaaaaaaaaapgapbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaa
aaaaiadpdoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "POINT" "FOG_EXP2" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_LightTexture0] 2D 0
ConstBuffer "$Globals" 256
Matrix 144 [_LightMatrix0]
Vector 96 [_LightColor0]
Vector 112 [_SpecColor]
Vector 208 [_Color]
Float 224 [_Shininess]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
"ps_4_0_level_9_1
root12:acadacaa
eefiecedfeaacafkdbeppkcjapjampcfgkbkpihoabaaaaaaiaaiaaaaaeaaaaaa
daaaaaaaoeacaaaakmahaaaaemaiaaaaebgpgodjkmacaaaakmacaaaaaaacpppp
faacaaaafmaaaaaaaeaacmaaaaaafmaaaaaafmaaacaaceaaaaaafmaaabaaaaaa
aaababaaaaaaagaaacaaaaaaaaaaaaaaaaaaajaaagaaacaaaaaaaaaaabaaaeaa
abaaaiaaaaaaaaaaacaaaaaaabaaajaaaaaaaaaaaaacppppfbaaaaafakaaapka
aaaaaaaaaaaaaaedaaaaiadpaaaaaaaabpaaaaacaaaaaaiaaaaaahlabpaaaaac
aaaaaaiaabaachlabpaaaaacaaaaaaiaacaaahlabpaaaaacaaaaaajaaaaiapka
bpaaaaacaaaaaajaabaiapkaafaaaaadaaaachiaacaafflaadaaoekaaeaaaaae
aaaachiaacaaoekaacaaaalaaaaaoeiaaeaaaaaeaaaachiaaeaaoekaacaakkla
aaaaoeiaacaaaaadaaaaahiaaaaaoeiaafaaoekaaiaaaaadaaaaadiaaaaaoeia
aaaaoeiaecaaaaadaaaacpiaaaaaoeiaaaaioekaecaaaaadabaacpiaaaaaoela
abaioekaafaaaaadaaaachiaaaaaaaiaaaaaoekaafaaaaadacaaahiaaaaaoeia
abaaoekaacaaaaadadaaahiaacaaoelbaiaaoekaaiaaaaadaaaaaiiaadaaoeia
adaaoeiaahaaaaacaaaaaiiaaaaappiaacaaaaadaeaaahiaacaaoelbajaaoeka
ceaaaaacafaachiaaeaaoeiaaeaaaaaeadaachiaadaaoeiaaaaappiaafaaoeia
aiaaaaadaaaaciiaabaaoelaafaaoeiaalaaaaadacaaciiaaaaappiaakaaaaka
ceaaaaacaeaachiaadaaoeiaaiaaaaadaaaaciiaabaaoelaaeaaoeiaalaaaaad
adaaabiaaaaappiaakaaaakaabaaaaacaaaaaiiaakaaffkaafaaaaadaaaaaiia
aaaappiaahaaaakacaaaaaadaeaaabiaadaaaaiaaaaappiaafaaaaadaaaaaiia
abaappiaaeaaaaiaafaaaaadabaachiaabaaoeiaagaaoekaafaaaaadaaaachia
aaaaoeiaabaaoeiaafaaaaadabaaahiaaaaappiaacaaoeiaaeaaaaaeaaaachia
aaaaoeiaacaappiaabaaoeiaabaaaaacaaaabiiaaaaakklaafaaaaadaaaachia
aaaaoeiaaaaappiaabaaaaacaaaaciiaakaakkkaabaaaaacaaaicpiaaaaaoeia
ppppaaaafdeieefcmaaeaaaaeaaaaaaadaabaaaafjaaaaaeegiocaaaaaaaaaaa
apaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
abaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadecbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaa
gcbaaaadhcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaa
aaaaaaajhcaabaaaaaaaaaaaegbcbaiaebaaaaaaadaaaaaaegiccaaaacaaaaaa
aaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhcaabaaaabaaaaaaegbcbaia
ebaaaaaaadaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadcaaaaajhcaabaaaabaaaaaaegacbaaaabaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaacaaaaaaegacbaaa
aaaaaaaabaaaaaahccaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
eeaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaadiaaaaahocaabaaaaaaaaaaa
fgafbaaaaaaaaaaaagajbaaaabaaaaaabaaaaaahccaabaaaaaaaaaaaegbcbaaa
acaaaaaajgahbaaaaaaaaaaadeaaaaakdcaabaaaaaaaaaaaegaabaaaaaaaaaaa
aceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaacpaaaaafccaabaaaaaaaaaaa
bkaabaaaaaaaaaaadiaaaaaiecaabaaaaaaaaaaaakiacaaaaaaaaaaaaoaaaaaa
abeaaaaaaaaaaaeddiaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaackaabaaa
aaaaaaaabjaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaah
ccaabaaaaaaaaaaabkaabaaaaaaaaaaadkaabaaaabaaaaaadiaaaaaihcaabaaa
abaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaanaaaaaadiaaaaaihcaabaaa
acaaaaaafgbfbaaaadaaaaaaegiccaaaaaaaaaaaakaaaaaadcaaaaakhcaabaaa
acaaaaaaegiccaaaaaaaaaaaajaaaaaaagbabaaaadaaaaaaegacbaaaacaaaaaa
dcaaaaakhcaabaaaacaaaaaaegiccaaaaaaaaaaaalaaaaaakgbkbaaaadaaaaaa
egacbaaaacaaaaaaaaaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaa
aaaaaaaaamaaaaaabaaaaaahecaabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaa
acaaaaaaefaaaaajpcaabaaaacaaaaaakgakbaaaaaaaaaaaeghobaaaabaaaaaa
aagabaaaaaaaaaaadiaaaaaihcaabaaaacaaaaaaagaabaaaacaaaaaaegiccaaa
aaaaaaaaagaaaaaadiaaaaaihcaabaaaadaaaaaaegacbaaaacaaaaaaegiccaaa
aaaaaaaaahaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaa
acaaaaaadiaaaaahocaabaaaaaaaaaaafgafbaaaaaaaaaaaagajbaaaadaaaaaa
dcaaaaajhcaabaaaaaaaaaaaegacbaaaabaaaaaaagaabaaaaaaaaaaajgahbaaa
aaaaaaaadgcaaaaficaabaaaaaaaaaaackbabaaaabaaaaaadiaaaaahhccabaaa
aaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaiadpdoaaaaabejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaa
aeaeaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaimaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "FOG_EXP2" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "FOG_EXP2" }
Vector 4 [_Color]
Vector 2 [_LightColor0]
Float 5 [_Shininess]
Vector 3 [_SpecColor]
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
SetTexture 0 [_MainTex] 2D 0
"ps_2_0
def c6, 0, 128, 1, 0
dcl t0.xy
dcl_pp t1.xyz
dcl t2.xyz
dcl t4.x
dcl_2d s0
texld_pp r0, t0, s0
add r1.xyz, -t2, c0
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mad_pp r1.xyz, r1, r1.w, c1
nrm_pp r2.xyz, r1
dp3_pp r1.x, t1, r2
max r2.x, r1.x, c6.x
mov r1.y, c6.y
mul r1.x, r1.y, c5.x
pow r3.w, r2.x, r1.x
mul r0.w, r0.w, r3.w
mul_pp r0.xyz, r0, c4
mul_pp r0.xyz, r0, c2
mov r1.xyz, c2
mul r1.xyz, r1, c3
mul r1.xyz, r0.w, r1
dp3_pp r0.w, t1, c1
max_pp r1.w, r0.w, c6.x
mad_pp r0.xyz, r0, r1.w, r1
mov_sat r0.w, t4.x
mul_pp r0.xyz, r0, r0.w
mov_pp r0.w, c6.z
mov_pp oC0, r0

"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "FOG_EXP2" }
SetTexture 0 [_MainTex] 2D 0
ConstBuffer "$Globals" 192
Vector 96 [_LightColor0]
Vector 112 [_SpecColor]
Vector 144 [_Color]
Float 160 [_Shininess]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
"ps_4_0
root12:abadabaa
eefiecedcghkbmonodkbemohmaagacidcniahajlabaaaaaagmaeaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaa
aeaeaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaimaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcgeadaaaaeaaaaaaanjaaaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaa
fjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaa
fkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadecbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaa
gcbaaaadhcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaa
aaaaaaajhcaabaaaaaaaaaaaegbcbaiaebaaaaaaadaaaaaaegiccaaaabaaaaaa
aeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaah
icaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaacaaaaaaegacbaaa
aaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaa
cpaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaaiccaabaaaaaaaaaaa
akiacaaaaaaaaaaaakaaaaaaabeaaaaaaaaaaaeddiaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaabkaabaaaaaaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaadkaabaaa
abaaaaaadiaaaaaiocaabaaaaaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaa
ajaaaaaadiaaaaaiocaabaaaaaaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaa
agaaaaaadiaaaaajhcaabaaaabaaaaaaegiccaaaaaaaaaaaagaaaaaaegiccaaa
aaaaaaaaahaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaaibcaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaa
aaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaa
dcaaaaajhcaabaaaaaaaaaaajgahbaaaaaaaaaaaagaabaaaaaaaaaaaegacbaaa
abaaaaaadgcaaaaficaabaaaaaaaaaaackbabaaaabaaaaaadiaaaaahhccabaaa
aaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "FOG_EXP2" }
SetTexture 0 [_MainTex] 2D 0
ConstBuffer "$Globals" 192
Vector 96 [_LightColor0]
Vector 112 [_SpecColor]
Vector 144 [_Color]
Float 160 [_Shininess]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
"ps_4_0_level_9_1
root12:abadabaa
eefiecedbbpapddnpbepaidhfloienlcmoodcjmmabaaaaaaimagaaaaaeaaaaaa
daaaaaaaemacaaaaliafaaaafiagaaaaebgpgodjbeacaaaabeacaaaaaaacpppp
lmabaaaafiaaaaaaaeaaciaaaaaafiaaaaaafiaaabaaceaaaaaafiaaaaaaaaaa
aaaaagaaacaaaaaaaaaaaaaaaaaaajaaacaaacaaaaaaaaaaabaaaeaaabaaaeaa
aaaaaaaaacaaaaaaabaaafaaaaaaaaaaaaacppppfbaaaaafagaaapkaaaaaaaaa
aaaaaaedaaaaiadpaaaaaaaabpaaaaacaaaaaaiaaaaaahlabpaaaaacaaaaaaia
abaachlabpaaaaacaaaaaaiaacaaahlabpaaaaacaaaaaajaaaaiapkaecaaaaad
aaaacpiaaaaaoelaaaaioekaacaaaaadabaaahiaacaaoelbaeaaoekaaiaaaaad
abaaaiiaabaaoeiaabaaoeiaahaaaaacabaaaiiaabaappiaaeaaaaaeabaachia
abaaoeiaabaappiaafaaoekaceaaaaacacaachiaabaaoeiaaiaaaaadabaacbia
abaaoelaacaaoeiaalaaaaadacaaabiaabaaaaiaagaaaakaabaaaaacabaaacia
agaaffkaafaaaaadabaaabiaabaaffiaadaaaakacaaaaaadadaaaiiaacaaaaia
abaaaaiaafaaaaadaaaaaiiaaaaappiaadaappiaafaaaaadaaaachiaaaaaoeia
acaaoekaafaaaaadaaaachiaaaaaoeiaaaaaoekaabaaaaacabaaahiaaaaaoeka
afaaaaadabaaahiaabaaoeiaabaaoekaafaaaaadabaaahiaaaaappiaabaaoeia
aiaaaaadaaaaciiaabaaoelaafaaoekaalaaaaadabaaciiaaaaappiaagaaaaka
aeaaaaaeaaaachiaaaaaoeiaabaappiaabaaoeiaabaaaaacaaaabiiaaaaakkla
afaaaaadaaaachiaaaaaoeiaaaaappiaabaaaaacaaaaciiaagaakkkaabaaaaac
aaaicpiaaaaaoeiappppaaaafdeieefcgeadaaaaeaaaaaaanjaaaaaafjaaaaae
egiocaaaaaaaaaaaalaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaae
egiocaaaacaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadecbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacacaaaaaaaaaaaaajhcaabaaaaaaaaaaaegbcbaiaebaaaaaa
adaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaa
acaaaaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
aaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaa
egbcbaaaacaaaaaaegacbaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
diaaaaaiccaabaaaaaaaaaaaakiacaaaaaaaaaaaakaaaaaaabeaaaaaaaaaaaed
diaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaabjaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaadkaabaaaabaaaaaadiaaaaaiocaabaaaaaaaaaaaagajbaaa
abaaaaaaagijcaaaaaaaaaaaajaaaaaadiaaaaaiocaabaaaaaaaaaaafgaobaaa
aaaaaaaaagijcaaaaaaaaaaaagaaaaaadiaaaaajhcaabaaaabaaaaaaegiccaaa
aaaaaaaaagaaaaaaegiccaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaaabaaaaaa
agaabaaaaaaaaaaaegacbaaaabaaaaaabaaaaaaibcaabaaaaaaaaaaaegbcbaaa
acaaaaaaegiccaaaacaaaaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaaaaaaaaaadcaaaaajhcaabaaaaaaaaaaajgahbaaaaaaaaaaa
agaabaaaaaaaaaaaegacbaaaabaaaaaadgcaaaaficaabaaaaaaaaaaackbabaaa
abaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaa
dgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaabejfdeheojiaaaaaa
afaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
imaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaaimaaaaaaaeaaaaaa
aaaaaaaaadaaaaaaabaaaaaaaeaeaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaa
acaaaaaaahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaa
abaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaa
fdfgfpfegbhcghgfheaaklkl"
}
SubProgram "opengl " {
Keywords { "SPOT" "FOG_EXP2" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "SPOT" "FOG_EXP2" }
Matrix 0 [_LightMatrix0]
Vector 8 [_Color]
Vector 6 [_LightColor0]
Float 9 [_Shininess]
Vector 7 [_SpecColor]
Vector 4 [_WorldSpaceCameraPos]
Vector 5 [_WorldSpaceLightPos0]
SetTexture 0 [_LightTexture0] 2D 0
SetTexture 1 [_LightTextureB0] 2D 1
SetTexture 2 [_MainTex] 2D 2
"ps_2_0
def c10, 1, 0.5, 0, 128
dcl t0.xy
dcl_pp t1.xyz
dcl t2.xyz
dcl t4.x
dcl_2d s0
dcl_2d s1
dcl_2d s2
mov r0.xyz, t2
mov r0.w, c10.x
dp4_pp r1.x, c0, r0
dp4_pp r1.y, c1, r0
dp4_pp r1.z, c2, r0
dp4_pp r1.w, c3, r0
rcp r1.w, r1.w
mad_pp r0.xy, r1, r1.w, c10.y
dp3 r1.xy, r1, r1
texld_pp r0, r0, s0
texld_pp r2, r1, s1
texld_pp r3, t0, s2
mul r0.x, r0.w, r2.x
mul_pp r0.xyz, r0.x, c6
cmp_pp r0.xyz, -r1.z, c10.z, r0
mul r1.xyz, r0, c7
add r2.xyz, -t2, c4
dp3 r0.w, r2, r2
rsq r0.w, r0.w
add r4.xyz, -t2, c5
nrm_pp r5.xyz, r4
mad_pp r2.xyz, r2, r0.w, r5
dp3_pp r0.w, t1, r5
max_pp r1.w, r0.w, c10.z
nrm_pp r4.xyz, r2
dp3_pp r0.w, t1, r4
max r2.x, r0.w, c10.z
mov r0.w, c10.w
mul r0.w, r0.w, c9.x
pow r4.x, r2.x, r0.w
mul r0.w, r3.w, r4.x
mul_pp r2.xyz, r3, c8
mul_pp r0.xyz, r0, r2
mul r1.xyz, r0.w, r1
mad_pp r0.xyz, r0, r1.w, r1
mov_sat r0.w, t4.x
mul_pp r0.xyz, r0, r0.w
mov r0.w, c10.x
mov_pp oC0, r0

"
}
SubProgram "d3d11 " {
Keywords { "SPOT" "FOG_EXP2" }
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_LightTexture0] 2D 0
SetTexture 2 [_LightTextureB0] 2D 1
ConstBuffer "$Globals" 256
Matrix 144 [_LightMatrix0]
Vector 96 [_LightColor0]
Vector 112 [_SpecColor]
Vector 208 [_Color]
Float 224 [_Shininess]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
"ps_4_0
root12:adadadaa
eefiecedcgdghflnlipaeneglmbddecccocfkgdgabaaaaaammagaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaa
aeaeaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaimaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcmeafaaaaeaaaaaaahbabaaaafjaaaaaeegiocaaaaaaaaaaaapaaaaaa
fjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadecbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaa
adaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaadaaaaaaegiocaaaaaaaaaaaakaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaaaaaaaaaajaaaaaaagbabaaaadaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaalaaaaaakgbkbaaaadaaaaaa
egaobaaaaaaaaaaaaaaaaaaipcaabaaaaaaaaaaaegaobaaaaaaaaaaaegiocaaa
aaaaaaaaamaaaaaaaoaaaaahdcaabaaaabaaaaaaegaabaaaaaaaaaaapgapbaaa
aaaaaaaaaaaaaaakdcaabaaaabaaaaaaegaabaaaabaaaaaaaceaaaaaaaaaaadp
aaaaaadpaaaaaaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaaaaaaaaadbaaaaahicaabaaaaaaaaaaaabeaaaaa
aaaaaaaackaabaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaaagaabaaaaaaaaaaaeghobaaa
acaaaaaaaagabaaaabaaaaaaabaaaaahbcaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaiadpdiaaaaahbcaabaaaaaaaaaaadkaabaaaabaaaaaaakaabaaa
aaaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaacaaaaaaakaabaaaaaaaaaaa
diaaaaaihcaabaaaaaaaaaaaagaabaaaaaaaaaaaegiccaaaaaaaaaaaagaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaahaaaaaa
aaaaaaajhcaabaaaacaaaaaaegbcbaiaebaaaaaaadaaaaaaegiccaaaacaaaaaa
aaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaacaaaaaa
pgapbaaaaaaaaaaaegacbaaaacaaaaaaaaaaaaajhcaabaaaadaaaaaaegbcbaia
ebaaaaaaadaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaadaaaaaaegacbaaaadaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadcaaaaajhcaabaaaadaaaaaaegacbaaaadaaaaaapgapbaaaaaaaaaaa
egacbaaaacaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaacaaaaaaegacbaaa
acaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaa
baaaaaahicaabaaaabaaaaaaegacbaaaadaaaaaaegacbaaaadaaaaaaeeaaaaaf
icaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaa
abaaaaaaegacbaaaadaaaaaabaaaaaahicaabaaaabaaaaaaegbcbaaaacaaaaaa
egacbaaaacaaaaaadeaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaa
aaaaaaaacpaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaaibcaabaaa
acaaaaaaakiacaaaaaaaaaaaaoaaaaaaabeaaaaaaaaaaaeddiaaaaahicaabaaa
abaaaaaadkaabaaaabaaaaaaakaabaaaacaaaaaabjaaaaaficaabaaaabaaaaaa
dkaabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaacaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaa
dkaabaaaacaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaa
aaaaaaaaanaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
acaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaa
dcaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
abaaaaaadgcaaaaficaabaaaaaaaaaaackbabaaaabaaaaaadiaaaaahhccabaaa
aaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "SPOT" "FOG_EXP2" }
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_LightTexture0] 2D 0
SetTexture 2 [_LightTextureB0] 2D 1
ConstBuffer "$Globals" 256
Matrix 144 [_LightMatrix0]
Vector 96 [_LightColor0]
Vector 112 [_SpecColor]
Vector 208 [_Color]
Float 224 [_Shininess]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
"ps_4_0_level_9_1
root12:adadadaa
eefiecedgkiblkbaamejplnfmeoidbelojkgfmihabaaaaaaoiajaaaaaeaaaaaa
daaaaaaaeiadaaaabeajaaaaleajaaaaebgpgodjbaadaaaabaadaaaaaaacpppp
laacaaaagaaaaaaaaeaadaaaaaaagaaaaaaagaaaadaaceaaaaaagaaaabaaaaaa
acababaaaaacacaaaaaaagaaacaaaaaaaaaaaaaaaaaaajaaagaaacaaaaaaaaaa
abaaaeaaabaaaiaaaaaaaaaaacaaaaaaabaaajaaaaaaaaaaaaacppppfbaaaaaf
akaaapkaaaaaaadpaaaaaaaaaaaaaaedaaaaiadpbpaaaaacaaaaaaiaaaaaahla
bpaaaaacaaaaaaiaabaachlabpaaaaacaaaaaaiaacaaahlabpaaaaacaaaaaaja
aaaiapkabpaaaaacaaaaaajaabaiapkabpaaaaacaaaaaajaacaiapkaafaaaaad
aaaacpiaacaafflaadaaoekaaeaaaaaeaaaacpiaacaaoekaacaaaalaaaaaoeia
aeaaaaaeaaaacpiaaeaaoekaacaakklaaaaaoeiaacaaaaadaaaacpiaaaaaoeia
afaaoekaagaaaaacaaaaaiiaaaaappiaaeaaaaaeabaacdiaaaaaoeiaaaaappia
akaaaakaaiaaaaadaaaaadiaaaaaoeiaaaaaoeiaecaaaaadabaacpiaabaaoeia
aaaioekaecaaaaadacaacpiaaaaaoeiaabaioekaecaaaaadadaacpiaaaaaoela
acaioekaafaaaaadaaaaabiaabaappiaacaaaaiaafaaaaadabaachiaaaaaaaia
aaaaoekafiaaaaaeaaaachiaaaaakkibakaaffkaabaaoeiaafaaaaadabaaahia
aaaaoeiaabaaoekaacaaaaadacaaahiaacaaoelbaiaaoekaaiaaaaadaaaaaiia
acaaoeiaacaaoeiaahaaaaacaaaaaiiaaaaappiaacaaaaadaeaaahiaacaaoelb
ajaaoekaceaaaaacafaachiaaeaaoeiaaeaaaaaeacaachiaacaaoeiaaaaappia
afaaoeiaaiaaaaadaaaaciiaabaaoelaafaaoeiaalaaaaadabaaciiaaaaappia
akaaffkaceaaaaacaeaachiaacaaoeiaaiaaaaadaaaaciiaabaaoelaaeaaoeia
alaaaaadacaaabiaaaaappiaakaaffkaabaaaaacaaaaaiiaakaakkkaafaaaaad
aaaaaiiaaaaappiaahaaaakacaaaaaadaeaaabiaacaaaaiaaaaappiaafaaaaad
aaaaaiiaadaappiaaeaaaaiaafaaaaadacaachiaadaaoeiaagaaoekaafaaaaad
aaaachiaaaaaoeiaacaaoeiaafaaaaadabaaahiaaaaappiaabaaoeiaaeaaaaae
aaaachiaaaaaoeiaabaappiaabaaoeiaabaaaaacaaaabiiaaaaakklaafaaaaad
aaaachiaaaaaoeiaaaaappiaabaaaaacaaaaaiiaakaappkaabaaaaacaaaicpia
aaaaoeiappppaaaafdeieefcmeafaaaaeaaaaaaahbabaaaafjaaaaaeegiocaaa
aaaaaaaaapaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaa
acaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadecbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaa
gcbaaaadhcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaadaaaaaaegiocaaaaaaaaaaaakaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaajaaaaaaagbabaaaadaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaalaaaaaa
kgbkbaaaadaaaaaaegaobaaaaaaaaaaaaaaaaaaipcaabaaaaaaaaaaaegaobaaa
aaaaaaaaegiocaaaaaaaaaaaamaaaaaaaoaaaaahdcaabaaaabaaaaaaegaabaaa
aaaaaaaapgapbaaaaaaaaaaaaaaaaaakdcaabaaaabaaaaaaegaabaaaabaaaaaa
aceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaa
egaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaadbaaaaahicaabaaa
aaaaaaaaabeaaaaaaaaaaaaackaabaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaaagaabaaa
aaaaaaaaeghobaaaacaaaaaaaagabaaaabaaaaaaabaaaaahbcaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaahbcaabaaaaaaaaaaadkaabaaa
abaaaaaaakaabaaaaaaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaacaaaaaa
akaabaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaagaabaaaaaaaaaaaegiccaaa
aaaaaaaaagaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaaaaaaaaaegiccaaa
aaaaaaaaahaaaaaaaaaaaaajhcaabaaaacaaaaaaegbcbaiaebaaaaaaadaaaaaa
egiccaaaacaaaaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaacaaaaaa
egacbaaaacaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaaaaaaaaajhcaabaaa
adaaaaaaegbcbaiaebaaaaaaadaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaah
icaabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaaadaaaaaaeeaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadcaaaaajhcaabaaaadaaaaaaegacbaaaadaaaaaa
pgapbaaaaaaaaaaaegacbaaaacaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
acaaaaaaegacbaaaacaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaaadaaaaaaegacbaaa
adaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaabaaaaaaegacbaaaadaaaaaabaaaaaahicaabaaaabaaaaaa
egbcbaaaacaaaaaaegacbaaaacaaaaaadeaaaaahicaabaaaabaaaaaadkaabaaa
abaaaaaaabeaaaaaaaaaaaaacpaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaa
diaaaaaibcaabaaaacaaaaaaakiacaaaaaaaaaaaaoaaaaaaabeaaaaaaaaaaaed
diaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaakaabaaaacaaaaaabjaaaaaf
icaabaaaabaaaaaadkaabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaadiaaaaahicaabaaaabaaaaaa
dkaabaaaabaaaaaadkaabaaaacaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaa
acaaaaaaegiccaaaaaaaaaaaanaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaacaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaa
egacbaaaabaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaa
aaaaaaaaegacbaaaabaaaaaadgcaaaaficaabaaaaaaaaaaackbabaaaabaaaaaa
diaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaadgaaaaaf
iccabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaabejfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaaimaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaabaaaaaaaeaeaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklkl"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" "FOG_EXP2" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" "FOG_EXP2" }
Matrix 0 [_LightMatrix0] 3
Vector 7 [_Color]
Vector 5 [_LightColor0]
Float 8 [_Shininess]
Vector 6 [_SpecColor]
Vector 3 [_WorldSpaceCameraPos]
Vector 4 [_WorldSpaceLightPos0]
SetTexture 0 [_LightTexture0] CUBE 0
SetTexture 1 [_LightTextureB0] 2D 1
SetTexture 2 [_MainTex] 2D 2
"ps_2_0
def c9, 1, 0, 128, 0
dcl t0.xy
dcl_pp t1.xyz
dcl t2.xyz
dcl t4.x
dcl_cube s0
dcl_2d s1
dcl_2d s2
mov r0.xyz, t2
mov_pp r0.w, c9.x
dp4 r1.x, c0, r0
dp4 r1.y, c1, r0
dp4 r1.z, c2, r0
dp3 r0.xy, r1, r1
texld r1, r1, s0
texld r0, r0, s1
texld_pp r2, t0, s2
mul_pp r0.x, r1.w, r0.x
mul_pp r0.xyz, r0.x, c5
mul r1.xyz, r0, c6
add r3.xyz, -t2, c3
dp3 r0.w, r3, r3
rsq r0.w, r0.w
add r4.xyz, -t2, c4
nrm_pp r5.xyz, r4
mad_pp r3.xyz, r3, r0.w, r5
dp3_pp r0.w, t1, r5
max_pp r1.w, r0.w, c9.y
nrm_pp r4.xyz, r3
dp3_pp r0.w, t1, r4
max r3.x, r0.w, c9.y
mov r0.w, c9.z
mul r0.w, r0.w, c8.x
pow r4.x, r3.x, r0.w
mul r0.w, r2.w, r4.x
mul_pp r2.xyz, r2, c7
mul_pp r0.xyz, r0, r2
mul r1.xyz, r0.w, r1
mad_pp r0.xyz, r0, r1.w, r1
mov_sat r0.w, t4.x
mul_pp r0.xyz, r0, r0.w
mov_pp r0.w, c9.x
mov_pp oC0, r0

"
}
SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" "FOG_EXP2" }
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_LightTextureB0] 2D 1
SetTexture 2 [_LightTexture0] CUBE 0
ConstBuffer "$Globals" 256
Matrix 144 [_LightMatrix0]
Vector 96 [_LightColor0]
Vector 112 [_SpecColor]
Vector 208 [_Color]
Float 224 [_Shininess]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
"ps_4_0
root12:adadadaa
eefiecedafokebdkidmegcbkcjiblbicehmbbdlkabaaaaaaceagaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaa
aeaeaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaimaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcbmafaaaaeaaaaaaaehabaaaafjaaaaaeegiocaaaaaaaaaaaapaaaaaa
fjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafidaaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadecbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaa
adaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaaaaaaaajhcaabaaa
aaaaaaaaegbcbaiaebaaaaaaadaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaah
icaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaaaaaaaaajhcaabaaaabaaaaaaegbcbaiaebaaaaaaadaaaaaa
egiccaaaabaaaaaaaeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaa
egacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaaj
hcaabaaaabaaaaaaegacbaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
baaaaaahbcaabaaaaaaaaaaaegbcbaaaacaaaaaaegacbaaaaaaaaaaabaaaaaah
ccaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaafccaabaaa
aaaaaaaabkaabaaaaaaaaaaadiaaaaahocaabaaaaaaaaaaafgafbaaaaaaaaaaa
agajbaaaabaaaaaabaaaaaahccaabaaaaaaaaaaaegbcbaaaacaaaaaajgahbaaa
aaaaaaaadeaaaaakdcaabaaaaaaaaaaaegaabaaaaaaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaacpaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaa
diaaaaaiecaabaaaaaaaaaaaakiacaaaaaaaaaaaaoaaaaaaabeaaaaaaaaaaaed
diaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaackaabaaaaaaaaaaabjaaaaaf
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaadiaaaaahccaabaaaaaaaaaaa
bkaabaaaaaaaaaaadkaabaaaabaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaa
abaaaaaaegiccaaaaaaaaaaaanaaaaaadiaaaaaihcaabaaaacaaaaaafgbfbaaa
adaaaaaaegiccaaaaaaaaaaaakaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaa
aaaaaaaaajaaaaaaagbabaaaadaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaa
acaaaaaaegiccaaaaaaaaaaaalaaaaaakgbkbaaaadaaaaaaegacbaaaacaaaaaa
aaaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaamaaaaaa
baaaaaahecaabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaaefaaaaaj
pcaabaaaacaaaaaaegacbaaaacaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaa
efaaaaajpcaabaaaadaaaaaakgakbaaaaaaaaaaaeghobaaaabaaaaaaaagabaaa
abaaaaaadiaaaaahecaabaaaaaaaaaaadkaabaaaacaaaaaaakaabaaaadaaaaaa
diaaaaaihcaabaaaacaaaaaakgakbaaaaaaaaaaaegiccaaaaaaaaaaaagaaaaaa
diaaaaaihcaabaaaadaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaahaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadiaaaaah
ocaabaaaaaaaaaaafgafbaaaaaaaaaaaagajbaaaadaaaaaadcaaaaajhcaabaaa
aaaaaaaaegacbaaaabaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaadgcaaaaf
icaabaaaaaaaaaaackbabaaaabaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaa
aaaaaaaapgapbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadp
doaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "POINT_COOKIE" "FOG_EXP2" }
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_LightTextureB0] 2D 1
SetTexture 2 [_LightTexture0] CUBE 0
ConstBuffer "$Globals" 256
Matrix 144 [_LightMatrix0]
Vector 96 [_LightColor0]
Vector 112 [_SpecColor]
Vector 208 [_Color]
Float 224 [_Shininess]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
"ps_4_0_level_9_1
root12:adadadaa
eefiecedjjhkloakoagneemhcbpnkokcpkcflifeabaaaaaabiajaaaaaeaaaaaa
daaaaaaacaadaaaaeeaiaaaaoeaiaaaaebgpgodjoiacaaaaoiacaaaaaaacpppp
iiacaaaagaaaaaaaaeaadaaaaaaagaaaaaaagaaaadaaceaaaaaagaaaacaaaaaa
abababaaaaacacaaaaaaagaaacaaaaaaaaaaaaaaaaaaajaaagaaacaaaaaaaaaa
abaaaeaaabaaaiaaaaaaaaaaacaaaaaaabaaajaaaaaaaaaaaaacppppfbaaaaaf
akaaapkaaaaaaaaaaaaaaaedaaaaiadpaaaaaaaabpaaaaacaaaaaaiaaaaaahla
bpaaaaacaaaaaaiaabaachlabpaaaaacaaaaaaiaacaaahlabpaaaaacaaaaaaji
aaaiapkabpaaaaacaaaaaajaabaiapkabpaaaaacaaaaaajaacaiapkaafaaaaad
aaaachiaacaafflaadaaoekaaeaaaaaeaaaachiaacaaoekaacaaaalaaaaaoeia
aeaaaaaeaaaachiaaeaaoekaacaakklaaaaaoeiaacaaaaadaaaaahiaaaaaoeia
afaaoekaaiaaaaadaaaaaiiaaaaaoeiaaaaaoeiaabaaaaacabaaadiaaaaappia
ecaaaaadaaaaapiaaaaaoeiaaaaioekaecaaaaadabaaapiaabaaoeiaabaioeka
ecaaaaadacaacpiaaaaaoelaacaioekaafaaaaadaaaacbiaaaaappiaabaaaaia
afaaaaadaaaachiaaaaaaaiaaaaaoekaafaaaaadabaaahiaaaaaoeiaabaaoeka
acaaaaadadaaahiaacaaoelbaiaaoekaaiaaaaadaaaaaiiaadaaoeiaadaaoeia
ahaaaaacaaaaaiiaaaaappiaacaaaaadaeaaahiaacaaoelbajaaoekaceaaaaac
afaachiaaeaaoeiaaeaaaaaeadaachiaadaaoeiaaaaappiaafaaoeiaaiaaaaad
aaaaciiaabaaoelaafaaoeiaalaaaaadabaaciiaaaaappiaakaaaakaceaaaaac
aeaachiaadaaoeiaaiaaaaadaaaaciiaabaaoelaaeaaoeiaalaaaaadadaaabia
aaaappiaakaaaakaabaaaaacaaaaaiiaakaaffkaafaaaaadaaaaaiiaaaaappia
ahaaaakacaaaaaadaeaaabiaadaaaaiaaaaappiaafaaaaadaaaaaiiaacaappia
aeaaaaiaafaaaaadacaachiaacaaoeiaagaaoekaafaaaaadaaaachiaaaaaoeia
acaaoeiaafaaaaadabaaahiaaaaappiaabaaoeiaaeaaaaaeaaaachiaaaaaoeia
abaappiaabaaoeiaabaaaaacaaaabiiaaaaakklaafaaaaadaaaachiaaaaaoeia
aaaappiaabaaaaacaaaaciiaakaakkkaabaaaaacaaaicpiaaaaaoeiappppaaaa
fdeieefcbmafaaaaeaaaaaaaehabaaaafjaaaaaeegiocaaaaaaaaaaaapaaaaaa
fjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafidaaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadecbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaa
adaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaaaaaaaajhcaabaaa
aaaaaaaaegbcbaiaebaaaaaaadaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaah
icaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaaaaaaaaajhcaabaaaabaaaaaaegbcbaiaebaaaaaaadaaaaaa
egiccaaaabaaaaaaaeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaa
egacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaaj
hcaabaaaabaaaaaaegacbaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
baaaaaahbcaabaaaaaaaaaaaegbcbaaaacaaaaaaegacbaaaaaaaaaaabaaaaaah
ccaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaafccaabaaa
aaaaaaaabkaabaaaaaaaaaaadiaaaaahocaabaaaaaaaaaaafgafbaaaaaaaaaaa
agajbaaaabaaaaaabaaaaaahccaabaaaaaaaaaaaegbcbaaaacaaaaaajgahbaaa
aaaaaaaadeaaaaakdcaabaaaaaaaaaaaegaabaaaaaaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaacpaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaa
diaaaaaiecaabaaaaaaaaaaaakiacaaaaaaaaaaaaoaaaaaaabeaaaaaaaaaaaed
diaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaackaabaaaaaaaaaaabjaaaaaf
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaadiaaaaahccaabaaaaaaaaaaa
bkaabaaaaaaaaaaadkaabaaaabaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaa
abaaaaaaegiccaaaaaaaaaaaanaaaaaadiaaaaaihcaabaaaacaaaaaafgbfbaaa
adaaaaaaegiccaaaaaaaaaaaakaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaa
aaaaaaaaajaaaaaaagbabaaaadaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaa
acaaaaaaegiccaaaaaaaaaaaalaaaaaakgbkbaaaadaaaaaaegacbaaaacaaaaaa
aaaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaamaaaaaa
baaaaaahecaabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaaefaaaaaj
pcaabaaaacaaaaaaegacbaaaacaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaa
efaaaaajpcaabaaaadaaaaaakgakbaaaaaaaaaaaeghobaaaabaaaaaaaagabaaa
abaaaaaadiaaaaahecaabaaaaaaaaaaadkaabaaaacaaaaaaakaabaaaadaaaaaa
diaaaaaihcaabaaaacaaaaaakgakbaaaaaaaaaaaegiccaaaaaaaaaaaagaaaaaa
diaaaaaihcaabaaaadaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaahaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadiaaaaah
ocaabaaaaaaaaaaafgafbaaaaaaaaaaaagajbaaaadaaaaaadcaaaaajhcaabaaa
aaaaaaaaegacbaaaabaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaadgcaaaaf
icaabaaaaaaaaaaackbabaaaabaaaaaadiaaaaahhccabaaaaaaaaaaaegacbaaa
aaaaaaaapgapbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadp
doaaaaabejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adadaaaaimaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaaaeaeaaaaimaaaaaa
abaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaimaaaaaaacaaaaaaaaaaaaaa
adaaaaaaadaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" "FOG_EXP2" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" "FOG_EXP2" }
Matrix 0 [_LightMatrix0] 2
Vector 6 [_Color]
Vector 4 [_LightColor0]
Float 7 [_Shininess]
Vector 5 [_SpecColor]
Vector 2 [_WorldSpaceCameraPos]
Vector 3 [_WorldSpaceLightPos0]
SetTexture 0 [_LightTexture0] 2D 0
SetTexture 1 [_MainTex] 2D 1
"ps_2_0
def c8, 1, 0, 128, 0
dcl t0.xy
dcl_pp t1.xyz
dcl t2.xyz
dcl t4.x
dcl_2d s0
dcl_2d s1
mov r0.xyz, t2
mov_pp r0.w, c8.x
dp4 r1.x, c0, r0
dp4 r1.y, c1, r0
texld_pp r0, t0, s1
texld_pp r1, r1, s0
add r1.xyz, -t2, c2
dp3 r2.w, r1, r1
rsq r2.x, r2.w
mad_pp r1.xyz, r1, r2.x, c3
nrm_pp r2.xyz, r1
dp3_pp r1.x, t1, r2
max r2.x, r1.x, c8.y
mov r1.z, c8.z
mul r1.x, r1.z, c7.x
pow r3.w, r2.x, r1.x
mul r0.w, r0.w, r3.w
mul_pp r0.xyz, r0, c6
mul_pp r1.xyz, r1.w, c4
mul r2.xyz, r1, c5
mul_pp r0.xyz, r0, r1
mul r1.xyz, r0.w, r2
dp3_pp r0.w, t1, c3
max_pp r1.w, r0.w, c8.y
mad_pp r0.xyz, r0, r1.w, r1
mov_sat r0.w, t4.x
mul_pp r0.xyz, r0, r0.w
mov_pp r0.w, c8.x
mov_pp oC0, r0

"
}
SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" "FOG_EXP2" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_LightTexture0] 2D 0
ConstBuffer "$Globals" 256
Matrix 144 [_LightMatrix0]
Vector 96 [_LightColor0]
Vector 112 [_SpecColor]
Vector 208 [_Color]
Float 224 [_Shininess]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
"ps_4_0
root12:acadacaa
eefiecedogcpcggfkpphanoladfpilejilkpameaabaaaaaafeafaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaa
aeaeaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaimaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcemaeaaaaeaaaaaaabdabaaaafjaaaaaeegiocaaaaaaaaaaaapaaaaaa
fjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadecbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaad
hcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaaj
hcaabaaaaaaaaaaaegbcbaiaebaaaaaaadaaaaaaegiccaaaabaaaaaaaeaaaaaa
baaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgapbaaaaaaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaacaaaaaaegacbaaaaaaaaaaa
deaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaaiccaabaaaaaaaaaaaakiacaaa
aaaaaaaaaoaaaaaaabeaaaaaaaaaaaeddiaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaabkaabaaaaaaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
abaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaadkaabaaaabaaaaaa
diaaaaaiocaabaaaaaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaaanaaaaaa
diaaaaaidcaabaaaabaaaaaafgbfbaaaadaaaaaaegiacaaaaaaaaaaaakaaaaaa
dcaaaaakdcaabaaaabaaaaaaegiacaaaaaaaaaaaajaaaaaaagbabaaaadaaaaaa
egaabaaaabaaaaaadcaaaaakdcaabaaaabaaaaaaegiacaaaaaaaaaaaalaaaaaa
kgbkbaaaadaaaaaaegaabaaaabaaaaaaaaaaaaaidcaabaaaabaaaaaaegaabaaa
abaaaaaaegiacaaaaaaaaaaaamaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaa
abaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaa
pgapbaaaabaaaaaaegiccaaaaaaaaaaaagaaaaaadiaaaaaihcaabaaaacaaaaaa
egacbaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaadiaaaaahocaabaaaaaaaaaaa
fgaobaaaaaaaaaaaagajbaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaa
aaaaaaaaegacbaaaacaaaaaabaaaaaaibcaabaaaaaaaaaaaegbcbaaaacaaaaaa
egiccaaaacaaaaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
abeaaaaaaaaaaaaadcaaaaajhcaabaaaaaaaaaaajgahbaaaaaaaaaaaagaabaaa
aaaaaaaaegacbaaaabaaaaaadgcaaaaficaabaaaaaaaaaaackbabaaaabaaaaaa
diaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaadgaaaaaf
iccabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL_COOKIE" "FOG_EXP2" }
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_LightTexture0] 2D 0
ConstBuffer "$Globals" 256
Matrix 144 [_LightMatrix0]
Vector 96 [_LightColor0]
Vector 112 [_SpecColor]
Vector 208 [_Color]
Float 224 [_Shininess]
ConstBuffer "UnityPerCamera" 144
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720
Vector 0 [_WorldSpaceLightPos0]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
"ps_4_0_level_9_1
root12:acadacaa
eefiecedacekbahofhgjjlbemkoafodcodkjichjabaaaaaaoaahaaaaaeaaaaaa
daaaaaaaliacaaaaamahaaaakmahaaaaebgpgodjiaacaaaaiaacaaaaaaacpppp
ceacaaaafmaaaaaaaeaacmaaaaaafmaaaaaafmaaacaaceaaaaaafmaaabaaaaaa
aaababaaaaaaagaaacaaaaaaaaaaaaaaaaaaajaaagaaacaaaaaaaaaaabaaaeaa
abaaaiaaaaaaaaaaacaaaaaaabaaajaaaaaaaaaaaaacppppfbaaaaafakaaapka
aaaaaaaaaaaaaaedaaaaiadpaaaaaaaabpaaaaacaaaaaaiaaaaaahlabpaaaaac
aaaaaaiaabaachlabpaaaaacaaaaaaiaacaaahlabpaaaaacaaaaaajaaaaiapka
bpaaaaacaaaaaajaabaiapkaafaaaaadaaaacdiaacaafflaadaaoekaaeaaaaae
aaaacdiaacaaoekaacaaaalaaaaaoeiaaeaaaaaeaaaacdiaaeaaoekaacaakkla
aaaaoeiaacaaaaadaaaaadiaaaaaoeiaafaaoekaecaaaaadabaacpiaaaaaoela
abaioekaecaaaaadaaaacpiaaaaaoeiaaaaioekaacaaaaadaaaaahiaacaaoelb
aiaaoekaaiaaaaadacaaaiiaaaaaoeiaaaaaoeiaahaaaaacacaaabiaacaappia
aeaaaaaeaaaachiaaaaaoeiaacaaaaiaajaaoekaceaaaaacacaachiaaaaaoeia
aiaaaaadaaaacbiaabaaoelaacaaoeiaalaaaaadacaaabiaaaaaaaiaakaaaaka
abaaaaacaaaaaciaakaaffkaafaaaaadaaaaabiaaaaaffiaahaaaakacaaaaaad
adaaaiiaacaaaaiaaaaaaaiaafaaaaadabaaaiiaabaappiaadaappiaafaaaaad
aaaachiaabaaoeiaagaaoekaafaaaaadabaachiaaaaappiaaaaaoekaafaaaaad
acaaahiaabaaoeiaabaaoekaafaaaaadaaaachiaaaaaoeiaabaaoeiaafaaaaad
abaaahiaabaappiaacaaoeiaaiaaaaadaaaaciiaabaaoelaajaaoekaalaaaaad
abaaciiaaaaappiaakaaaakaaeaaaaaeaaaachiaaaaaoeiaabaappiaabaaoeia
abaaaaacaaaabiiaaaaakklaafaaaaadaaaachiaaaaaoeiaaaaappiaabaaaaac
aaaaciiaakaakkkaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefcemaeaaaa
eaaaaaaabdabaaaafjaaaaaeegiocaaaaaaaaaaaapaaaaaafjaaaaaeegiocaaa
abaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
ecbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaajhcaabaaaaaaaaaaa
egbcbaiaebaaaaaaadaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaa
aaaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaabaaaaaah
bcaabaaaaaaaaaaaegbcbaaaacaaaaaaegacbaaaaaaaaaaadeaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaadiaaaaaiccaabaaaaaaaaaaaakiacaaaaaaaaaaaaoaaaaaa
abeaaaaaaaaaaaeddiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaa
aaaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaadkaabaaaabaaaaaadiaaaaaiocaabaaa
aaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaaanaaaaaadiaaaaaidcaabaaa
abaaaaaafgbfbaaaadaaaaaaegiacaaaaaaaaaaaakaaaaaadcaaaaakdcaabaaa
abaaaaaaegiacaaaaaaaaaaaajaaaaaaagbabaaaadaaaaaaegaabaaaabaaaaaa
dcaaaaakdcaabaaaabaaaaaaegiacaaaaaaaaaaaalaaaaaakgbkbaaaadaaaaaa
egaabaaaabaaaaaaaaaaaaaidcaabaaaabaaaaaaegaabaaaabaaaaaaegiacaaa
aaaaaaaaamaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaapgapbaaaabaaaaaa
egiccaaaaaaaaaaaagaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaabaaaaaa
egiccaaaaaaaaaaaahaaaaaadiaaaaahocaabaaaaaaaaaaafgaobaaaaaaaaaaa
agajbaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaaaaaaaaaegacbaaa
acaaaaaabaaaaaaibcaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaa
aaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaa
dcaaaaajhcaabaaaaaaaaaaajgahbaaaaaaaaaaaagaabaaaaaaaaaaaegacbaaa
abaaaaaadgcaaaaficaabaaaaaaaaaaackbabaaaabaaaaaadiaaaaahhccabaaa
aaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaiadpdoaaaaabejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaa
aeaeaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaimaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
"
}
}
 }
 Pass {
  Name "PREPASS"
  Tags { "LIGHTMODE"="PrePassBase" "RenderType"="Opaque" }
  GpuProgramID 154416
Program "vp" {
SubProgram "opengl " {
"!!GLSL#version 120

#ifdef VERTEX

uniform mat4 _Object2World;
uniform mat4 _World2Object;
varying vec3 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
void main ()
{
  vec4 v_1;
  v_1.x = _World2Object[0].x;
  v_1.y = _World2Object[1].x;
  v_1.z = _World2Object[2].x;
  v_1.w = _World2Object[3].x;
  vec4 v_2;
  v_2.x = _World2Object[0].y;
  v_2.y = _World2Object[1].y;
  v_2.z = _World2Object[2].y;
  v_2.w = _World2Object[3].y;
  vec4 v_3;
  v_3.x = _World2Object[0].z;
  v_3.y = _World2Object[1].z;
  v_3.z = _World2Object[2].z;
  v_3.w = _World2Object[3].z;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = normalize(((
    (v_1.xyz * gl_Normal.x)
   + 
    (v_2.xyz * gl_Normal.y)
  ) + (v_3.xyz * gl_Normal.z)));
  xlv_TEXCOORD1 = (_Object2World * gl_Vertex).xyz;
}


#endif
#ifdef FRAGMENT
uniform float _Shininess;
varying vec3 xlv_TEXCOORD0;
void main ()
{
  vec4 res_1;
  res_1.xyz = ((xlv_TEXCOORD0 * 0.5) + 0.5);
  res_1.w = _Shininess;
  gl_FragData[0] = res_1;
}


#endif
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 4 [_Object2World] 3
Matrix 7 [_World2Object] 3
Matrix 0 [glstate_matrix_mvp]
"vs_2_0
dcl_position v0
dcl_normal v1
dp4 oPos.x, c0, v0
dp4 oPos.y, c1, v0
dp4 oPos.z, c2, v0
dp4 oPos.w, c3, v0
dp4 oT1.x, c4, v0
dp4 oT1.y, c5, v0
dp4 oT1.z, c6, v0
mul r0.xyz, v1.y, c8
mad r0.xyz, c7, v1.x, r0
mad r0.xyz, c9, v1.z, r0
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul oT0.xyz, r0.w, r0

"
}
SubProgram "d3d11 " {
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "UnityPerDraw" 0
"vs_4_0
root12:aaabaaaa
eefiecedinidogaapcaihlhlafeaicjabdmdpgobabaaaaaaneaeaaaaadaaaaaa
cmaaaaaaceabaaaajeabaaaaejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
ahaiaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcdiadaaaaeaaaabaa
moaaaaaafjaaaaaeegiocaaaaaaaaaaabdaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaad
hccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagiaaaaacacaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaa
akbabaaaacaaaaaaakiacaaaaaaaaaaabaaaaaaadiaaaaaiccaabaaaaaaaaaaa
akbabaaaacaaaaaaakiacaaaaaaaaaaabbaaaaaadiaaaaaiecaabaaaaaaaaaaa
akbabaaaacaaaaaaakiacaaaaaaaaaaabcaaaaaadiaaaaaibcaabaaaabaaaaaa
bkbabaaaacaaaaaabkiacaaaaaaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaa
bkbabaaaacaaaaaabkiacaaaaaaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaa
bkbabaaaacaaaaaabkiacaaaaaaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaa
acaaaaaackiacaaaaaaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaa
acaaaaaackiacaaaaaaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaa
acaaaaaackiacaaaaaaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hccabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiccaaaaaaaaaaaanaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaaaaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaaaaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "UnityPerDraw" 0
"vs_4_0_level_9_1
root12:aaabaaaa
eefiecedfimbpiggiminkfbhlgdjijhgmgblgjidabaaaaaaneagaaaaaeaaaaaa
daaaaaaacmacaaaagmafaaaageagaaaaebgpgodjpeabaaaapeabaaaaaaacpopp
leabaaaaeaaaaaaaacaaceaaaaaadmaaaaaadmaaaaaaceaaabaadmaaaaaaaaaa
aeaaabaaaaaaaaaaaaaaamaaahaaafaaaaaaaaaaaaaaaaaaaaacpoppbpaaaaac
afaaaaiaaaaaapjabpaaaaacafaaaciaacaaapjaafaaaaadaaaaahiaaaaaffja
agaaoekaaeaaaaaeaaaaahiaafaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaahia
ahaaoekaaaaakkjaaaaaoeiaaeaaaaaeabaaahoaaiaaoekaaaaappjaaaaaoeia
afaaaaadaaaaabiaacaaaajaajaaaakaafaaaaadaaaaaciaacaaaajaakaaaaka
afaaaaadaaaaaeiaacaaaajaalaaaakaafaaaaadabaaabiaacaaffjaajaaffka
afaaaaadabaaaciaacaaffjaakaaffkaafaaaaadabaaaeiaacaaffjaalaaffka
acaaaaadaaaaahiaaaaaoeiaabaaoeiaafaaaaadabaaabiaacaakkjaajaakkka
afaaaaadabaaaciaacaakkjaakaakkkaafaaaaadabaaaeiaacaakkjaalaakkka
acaaaaadaaaaahiaaaaaoeiaabaaoeiaaiaaaaadaaaaaiiaaaaaoeiaaaaaoeia
ahaaaaacaaaaaiiaaaaappiaafaaaaadaaaaahoaaaaappiaaaaaoeiaafaaaaad
aaaaapiaaaaaffjaacaaoekaaeaaaaaeaaaaapiaabaaoekaaaaaaajaaaaaoeia
aeaaaaaeaaaaapiaadaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaaeaaoeka
aaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaac
aaaaammaaaaaoeiappppaaaafdeieefcdiadaaaaeaaaabaamoaaaaaafjaaaaae
egiocaaaaaaaaaaabdaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaaakbabaaaacaaaaaa
akiacaaaaaaaaaaabaaaaaaadiaaaaaiccaabaaaaaaaaaaaakbabaaaacaaaaaa
akiacaaaaaaaaaaabbaaaaaadiaaaaaiecaabaaaaaaaaaaaakbabaaaacaaaaaa
akiacaaaaaaaaaaabcaaaaaadiaaaaaibcaabaaaabaaaaaabkbabaaaacaaaaaa
bkiacaaaaaaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaabkbabaaaacaaaaaa
bkiacaaaaaaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaabkbabaaaacaaaaaa
bkiacaaaaaaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaacaaaaaackiacaaa
aaaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaacaaaaaackiacaaa
aaaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaacaaaaaackiacaaa
aaaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaaabaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiccaaaaaaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
aaaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaaaaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhccabaaaacaaaaaaegiccaaaaaaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egacbaaaaaaaaaaadoaaaaabejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
ahaiaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}
}
Program "fp" {
SubProgram "opengl " {
"!!GLSL"
}
SubProgram "d3d9 " {
Float 0 [_Shininess]
"ps_2_0
def c1, 0.5, 0, 0, 0
dcl_pp t0.xyz
mad_pp r0.xyz, t0, c1.x, c1.x
mov_pp r0.w, c0.x
mov_pp oC0, r0

"
}
SubProgram "d3d11 " {
ConstBuffer "$Globals" 176
Float 160 [_Shininess]
BindCB  "$Globals" 0
"ps_4_0
root12:aaabaaaa
eefiecedleikifklhibmlpnlolicejkkkdnnbdhkabaaaaaagaabaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefciiaaaaaaeaaaaaaaccaaaaaa
fjaaaaaeegiocaaaaaaaaaaaalaaaaaagcbaaaadhcbabaaaabaaaaaagfaaaaad
pccabaaaaaaaaaaadcaaaaaphccabaaaaaaaaaaaegbcbaaaabaaaaaaaceaaaaa
aaaaaadpaaaaaadpaaaaaadpaaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadp
aaaaaaaadgaaaaagiccabaaaaaaaaaaaakiacaaaaaaaaaaaakaaaaaadoaaaaab
"
}
SubProgram "d3d11_9x " {
ConstBuffer "$Globals" 176
Float 160 [_Shininess]
BindCB  "$Globals" 0
"ps_4_0_level_9_1
root12:aaabaaaa
eefiecedkdefemlihfagphciekkkaggcmjjfjjheabaaaaaapeabaaaaaeaaaaaa
daaaaaaamaaaaaaafaabaaaamaabaaaaebgpgodjiiaaaaaaiiaaaaaaaaacpppp
fiaaaaaadaaaaaaaabaaceaaaaaadaaaaaaadaaaaaaaceaaaaaadaaaaaaaakaa
abaaaaaaaaaaaaaaaaacppppfbaaaaafabaaapkaaaaaaadpaaaaaaaaaaaaaaaa
aaaaaaaabpaaaaacaaaaaaiaaaaachlaaeaaaaaeaaaachiaaaaaoelaabaaaaka
abaaaakaabaaaaacaaaaciiaaaaaaakaabaaaaacaaaicpiaaaaaoeiappppaaaa
fdeieefciiaaaaaaeaaaaaaaccaaaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaa
gcbaaaadhcbabaaaabaaaaaagfaaaaadpccabaaaaaaaaaaadcaaaaaphccabaaa
aaaaaaaaegbcbaaaabaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaa
aceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaadgaaaaagiccabaaaaaaaaaaa
akiacaaaaaaaaaaaakaaaaaadoaaaaabejfdeheogiaaaaaaadaaaaaaaiaaaaaa
faaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaahahaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaa
acaaaaaaahaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
epfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}
}
 }
 Pass {
  Name "PREPASS"
  Tags { "LIGHTMODE"="PrePassFinal" "RenderType"="Opaque" }
  ZWrite Off
  GpuProgramID 252438
Program "vp" {
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLSL#version 120

#ifdef VERTEX
uniform vec4 _ProjectionParams;
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHC;

uniform mat4 _Object2World;
uniform mat4 _World2Object;
uniform vec4 _MainTex_ST;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 o_3;
  vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_1.zw;
  tmpvar_2.zw = vec2(0.0, 0.0);
  tmpvar_2.xy = vec2(0.0, 0.0);
  vec4 v_6;
  v_6.x = _World2Object[0].x;
  v_6.y = _World2Object[1].x;
  v_6.z = _World2Object[2].x;
  v_6.w = _World2Object[3].x;
  vec4 v_7;
  v_7.x = _World2Object[0].y;
  v_7.y = _World2Object[1].y;
  v_7.z = _World2Object[2].y;
  v_7.w = _World2Object[3].y;
  vec4 v_8;
  v_8.x = _World2Object[0].z;
  v_8.y = _World2Object[1].z;
  v_8.z = _World2Object[2].z;
  v_8.w = _World2Object[3].z;
  vec3 tmpvar_9;
  tmpvar_9 = normalize(((
    (v_6.xyz * gl_Normal.x)
   + 
    (v_7.xyz * gl_Normal.y)
  ) + (v_8.xyz * gl_Normal.z)));
  vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = tmpvar_9;
  vec3 x2_11;
  vec3 x1_12;
  x1_12.x = dot (unity_SHAr, tmpvar_10);
  x1_12.y = dot (unity_SHAg, tmpvar_10);
  x1_12.z = dot (unity_SHAb, tmpvar_10);
  vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_9.xyzz * tmpvar_9.yzzx);
  x2_11.x = dot (unity_SHBr, tmpvar_13);
  x2_11.y = dot (unity_SHBg, tmpvar_13);
  x2_11.z = dot (unity_SHBb, tmpvar_13);
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * gl_Vertex).xyz;
  xlv_TEXCOORD2 = o_3;
  xlv_TEXCOORD3 = tmpvar_2;
  xlv_TEXCOORD4 = ((x2_11 + (unity_SHC.xyz * 
    ((tmpvar_9.x * tmpvar_9.x) - (tmpvar_9.y * tmpvar_9.y))
  )) + x1_12);
}


#endif
#ifdef FRAGMENT
uniform vec4 _SpecColor;
uniform sampler2D _MainTex;
uniform vec4 _Color;
uniform sampler2D _LightBuffer;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 c_1;
  vec4 light_2;
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  light_2 = -(log2(texture2DProj (_LightBuffer, xlv_TEXCOORD2)));
  light_2.xyz = (light_2.xyz + xlv_TEXCOORD4);
  vec4 c_4;
  c_4.xyz = (((tmpvar_3.xyz * _Color.xyz) * light_2.xyz) + ((light_2.xyz * _SpecColor.xyz) * (light_2.w * tmpvar_3.w)));
  c_4.w = (tmpvar_3.w * _Color.w);
  c_1.xyz = c_4.xyz;
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 4 [_Object2World] 3
Matrix 7 [_World2Object] 3
Matrix 0 [glstate_matrix_mvp]
Vector 19 [_MainTex_ST]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Vector 14 [unity_SHAb]
Vector 13 [unity_SHAg]
Vector 12 [unity_SHAr]
Vector 17 [unity_SHBb]
Vector 16 [unity_SHBg]
Vector 15 [unity_SHBr]
Vector 18 [unity_SHC]
"vs_2_0
def c20, 0.5, 1, 0, 0
dcl_position v0
dcl_normal v1
dcl_texcoord v2
mad oT0.xy, v2, c19, c19.zwzw
dp4 oT1.x, c4, v0
dp4 oT1.y, c5, v0
dp4 oT1.z, c6, v0
dp4 r0.y, c1, v0
mul r1.x, r0.y, c10.x
mul r1.w, r1.x, c20.x
dp4 r0.x, c0, v0
dp4 r0.w, c3, v0
mul r1.xz, r0.xyww, c20.x
mad oT2.xy, r1.z, c11.zwzw, r1.xwzw
mul r1.xyz, v1.y, c8
mad r1.xyz, c7, v1.x, r1
mad r1.xyz, c9, v1.z, r1
nrm r2.xyz, r1
mul r1.x, r2.y, r2.y
mad r1.x, r2.x, r2.x, -r1.x
mul r3, r2.yzzx, r2.xyzz
dp4 r4.x, c15, r3
dp4 r4.y, c16, r3
dp4 r4.z, c17, r3
mad r1.xyz, c18, r1.x, r4
mov r2.w, c20.y
dp4 r3.x, c12, r2
dp4 r3.y, c13, r2
dp4 r3.z, c14, r2
add oT4.xyz, r1, r3
dp4 r0.z, c2, v0
mov oPos, r0
mov oT2.zw, r0
mov oT3, c20.z

"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 208
Vector 176 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 144
Vector 80 [_ProjectionParams]
ConstBuffer "UnityLighting" 720
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
root12:aaaeaaaa
eefiecednmfjkehbcgpomfcgfkffmdbnlmpmiapbabaaaaaammahaaaaadaaaaaa
cmaaaaaaceabaaaanmabaaaaejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapaaaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
oiafaaaaeaaaabaahkabaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaae
egiocaaaadaaaaaabdaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadpccabaaa
adaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaac
aeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaf
pccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaaalaaaaaadiaaaaai
hcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaa
agahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaaf
mccabaaaadaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaadaaaaaakgakbaaa
abaaaaaamgaabaaaabaaaaaadgaaaaaipccabaaaaeaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaaakbabaaaacaaaaaa
akiacaaaadaaaaaabaaaaaaadiaaaaaiccaabaaaaaaaaaaaakbabaaaacaaaaaa
akiacaaaadaaaaaabbaaaaaadiaaaaaiecaabaaaaaaaaaaaakbabaaaacaaaaaa
akiacaaaadaaaaaabcaaaaaadiaaaaaibcaabaaaabaaaaaabkbabaaaacaaaaaa
bkiacaaaadaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaabkbabaaaacaaaaaa
bkiacaaaadaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaabkbabaaaacaaaaaa
bkiacaaaadaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaacaaaaaackiacaaa
adaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaacaaaaaackiacaaa
adaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaacaaaaaackiacaaa
adaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaahbcaabaaaabaaaaaabkaabaaa
aaaaaaaabkaabaaaaaaaaaaadcaaaaakbcaabaaaabaaaaaaakaabaaaaaaaaaaa
akaabaaaaaaaaaaaakaabaiaebaaaaaaabaaaaaadiaaaaahpcaabaaaacaaaaaa
jgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaa
acaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaa
acaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaa
acaaaaaaclaaaaaaegaobaaaacaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
acaaaaaacmaaaaaaagaabaaaabaaaaaaegacbaaaadaaaaaadgaaaaaficaabaaa
aaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaacaaaaaaegiocaaaacaaaaaa
cgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaaacaaaaaaegiocaaaacaaaaaa
chaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaaacaaaaaaegiocaaaacaaaaaa
ciaaaaaaegaobaaaaaaaaaaaaaaaaaahhccabaaaafaaaaaaegacbaaaabaaaaaa
egacbaaaacaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 208
Vector 176 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 144
Vector 80 [_ProjectionParams]
ConstBuffer "UnityLighting" 720
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0_level_9_1
root12:aaaeaaaa
eefiecedajpemciclkepfonoangnhdmoefnjdhloabaaaaaacealaaaaaeaaaaaa
daaaaaaaieadaaaaheajaaaagmakaaaaebgpgodjemadaaaaemadaaaaaaacpopp
oiacaaaageaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaabaagaaaaaaaalaa
abaaabaaaaaaaaaaabaaafaaabaaacaaaaaaaaaaacaacgaaahaaadaaaaaaaaaa
adaaaaaaaeaaakaaaaaaaaaaadaaamaaahaaaoaaaaaaaaaaaaaaaaaaaaacpopp
fbaaaaafbfaaapkaaaaaaadpaaaaiadpaaaaaaaaaaaaaaaabpaaaaacafaaaaia
aaaaapjabpaaaaacafaaaciaacaaapjabpaaaaacafaaadiaadaaapjaaeaaaaae
aaaaadoaadaaoejaabaaoekaabaaookaafaaaaadaaaaahiaaaaaffjaapaaoeka
aeaaaaaeaaaaahiaaoaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaahiabaaaoeka
aaaakkjaaaaaoeiaaeaaaaaeabaaahoabbaaoekaaaaappjaaaaaoeiaafaaaaad
aaaaapiaaaaaffjaalaaoekaaeaaaaaeaaaaapiaakaaoekaaaaaaajaaaaaoeia
aeaaaaaeaaaaapiaamaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaanaaoeka
aaaappjaaaaaoeiaafaaaaadabaaabiaaaaaffiaacaaaakaafaaaaadabaaaiia
abaaaaiabfaaaakaafaaaaadabaaafiaaaaapeiabfaaaakaacaaaaadacaaadoa
abaakkiaabaaomiaafaaaaadabaaabiaacaaaajabcaaaakaafaaaaadabaaacia
acaaaajabdaaaakaafaaaaadabaaaeiaacaaaajabeaaaakaafaaaaadacaaabia
acaaffjabcaaffkaafaaaaadacaaaciaacaaffjabdaaffkaafaaaaadacaaaeia
acaaffjabeaaffkaacaaaaadabaaahiaabaaoeiaacaaoeiaafaaaaadacaaabia
acaakkjabcaakkkaafaaaaadacaaaciaacaakkjabdaakkkaafaaaaadacaaaeia
acaakkjabeaakkkaacaaaaadabaaahiaabaaoeiaacaaoeiaceaaaaacacaaahia
abaaoeiaafaaaaadabaaabiaacaaffiaacaaffiaaeaaaaaeabaaabiaacaaaaia
acaaaaiaabaaaaibafaaaaadadaaapiaacaacjiaacaakeiaajaaaaadaeaaabia
agaaoekaadaaoeiaajaaaaadaeaaaciaahaaoekaadaaoeiaajaaaaadaeaaaeia
aiaaoekaadaaoeiaaeaaaaaeabaaahiaajaaoekaabaaaaiaaeaaoeiaabaaaaac
acaaaiiabfaaffkaajaaaaadadaaabiaadaaoekaacaaoeiaajaaaaadadaaacia
aeaaoekaacaaoeiaajaaaaadadaaaeiaafaaoekaacaaoeiaacaaaaadaeaaahoa
abaaoeiaadaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaac
aaaaammaaaaaoeiaabaaaaacacaaamoaaaaaoeiaabaaaaacadaaapoabfaakkka
ppppaaaafdeieefcoiafaaaaeaaaabaahkabaaaafjaaaaaeegiocaaaaaaaaaaa
amaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
cnaaaaaafjaaaaaeegiocaaaadaaaaaabdaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaadhccabaaa
afaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaa
alaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaacaaaaaa
egiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaadaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
adaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadgaaaaaipccabaaaaeaaaaaa
aceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaa
akbabaaaacaaaaaaakiacaaaadaaaaaabaaaaaaadiaaaaaiccaabaaaaaaaaaaa
akbabaaaacaaaaaaakiacaaaadaaaaaabbaaaaaadiaaaaaiecaabaaaaaaaaaaa
akbabaaaacaaaaaaakiacaaaadaaaaaabcaaaaaadiaaaaaibcaabaaaabaaaaaa
bkbabaaaacaaaaaabkiacaaaadaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaa
bkbabaaaacaaaaaabkiacaaaadaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaa
bkbabaaaacaaaaaabkiacaaaadaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaa
acaaaaaackiacaaaadaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaa
acaaaaaackiacaaaadaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaa
acaaaaaackiacaaaadaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaahbcaabaaa
abaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaakbcaabaaaabaaaaaa
akaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaiaebaaaaaaabaaaaaadiaaaaah
pcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaa
adaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaa
adaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaa
adaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaaacaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaacaaaaaacmaaaaaaagaabaaaabaaaaaaegacbaaaadaaaaaa
dgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaacaaaaaa
egiocaaaacaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaaacaaaaaa
egiocaaaacaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaaacaaaaaa
egiocaaaacaaaaaaciaaaaaaegaobaaaaaaaaaaaaaaaaaahhccabaaaafaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaadoaaaaabejfdeheopaaaaaaaaiaaaaaa
aiaaaaaamiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apadaaaaoaaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaa
acaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaa
adaaaaaaagaaaaaaapaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaa
apaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffied
epepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklkl"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "UNITY_HDR_ON" }
"!!GLSL#version 120

#ifdef VERTEX
uniform vec4 _ProjectionParams;
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHC;

uniform mat4 _Object2World;
uniform mat4 _World2Object;
uniform vec4 _MainTex_ST;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 o_3;
  vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_1.zw;
  tmpvar_2.zw = vec2(0.0, 0.0);
  tmpvar_2.xy = vec2(0.0, 0.0);
  vec4 v_6;
  v_6.x = _World2Object[0].x;
  v_6.y = _World2Object[1].x;
  v_6.z = _World2Object[2].x;
  v_6.w = _World2Object[3].x;
  vec4 v_7;
  v_7.x = _World2Object[0].y;
  v_7.y = _World2Object[1].y;
  v_7.z = _World2Object[2].y;
  v_7.w = _World2Object[3].y;
  vec4 v_8;
  v_8.x = _World2Object[0].z;
  v_8.y = _World2Object[1].z;
  v_8.z = _World2Object[2].z;
  v_8.w = _World2Object[3].z;
  vec3 tmpvar_9;
  tmpvar_9 = normalize(((
    (v_6.xyz * gl_Normal.x)
   + 
    (v_7.xyz * gl_Normal.y)
  ) + (v_8.xyz * gl_Normal.z)));
  vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = tmpvar_9;
  vec3 x2_11;
  vec3 x1_12;
  x1_12.x = dot (unity_SHAr, tmpvar_10);
  x1_12.y = dot (unity_SHAg, tmpvar_10);
  x1_12.z = dot (unity_SHAb, tmpvar_10);
  vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_9.xyzz * tmpvar_9.yzzx);
  x2_11.x = dot (unity_SHBr, tmpvar_13);
  x2_11.y = dot (unity_SHBg, tmpvar_13);
  x2_11.z = dot (unity_SHBb, tmpvar_13);
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * gl_Vertex).xyz;
  xlv_TEXCOORD2 = o_3;
  xlv_TEXCOORD3 = tmpvar_2;
  xlv_TEXCOORD4 = ((x2_11 + (unity_SHC.xyz * 
    ((tmpvar_9.x * tmpvar_9.x) - (tmpvar_9.y * tmpvar_9.y))
  )) + x1_12);
}


#endif
#ifdef FRAGMENT
uniform vec4 _SpecColor;
uniform sampler2D _MainTex;
uniform vec4 _Color;
uniform sampler2D _LightBuffer;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD4;
void main ()
{
  vec4 c_1;
  vec4 light_2;
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec4 tmpvar_4;
  tmpvar_4 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_2.w = tmpvar_4.w;
  light_2.xyz = (tmpvar_4.xyz + xlv_TEXCOORD4);
  vec4 c_5;
  c_5.xyz = (((tmpvar_3.xyz * _Color.xyz) * light_2.xyz) + ((light_2.xyz * _SpecColor.xyz) * (tmpvar_4.w * tmpvar_3.w)));
  c_5.w = (tmpvar_3.w * _Color.w);
  c_1.xyz = c_5.xyz;
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "UNITY_HDR_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 4 [_Object2World] 3
Matrix 7 [_World2Object] 3
Matrix 0 [glstate_matrix_mvp]
Vector 19 [_MainTex_ST]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Vector 14 [unity_SHAb]
Vector 13 [unity_SHAg]
Vector 12 [unity_SHAr]
Vector 17 [unity_SHBb]
Vector 16 [unity_SHBg]
Vector 15 [unity_SHBr]
Vector 18 [unity_SHC]
"vs_2_0
def c20, 0.5, 1, 0, 0
dcl_position v0
dcl_normal v1
dcl_texcoord v2
mad oT0.xy, v2, c19, c19.zwzw
dp4 oT1.x, c4, v0
dp4 oT1.y, c5, v0
dp4 oT1.z, c6, v0
dp4 r0.y, c1, v0
mul r1.x, r0.y, c10.x
mul r1.w, r1.x, c20.x
dp4 r0.x, c0, v0
dp4 r0.w, c3, v0
mul r1.xz, r0.xyww, c20.x
mad oT2.xy, r1.z, c11.zwzw, r1.xwzw
mul r1.xyz, v1.y, c8
mad r1.xyz, c7, v1.x, r1
mad r1.xyz, c9, v1.z, r1
nrm r2.xyz, r1
mul r1.x, r2.y, r2.y
mad r1.x, r2.x, r2.x, -r1.x
mul r3, r2.yzzx, r2.xyzz
dp4 r4.x, c15, r3
dp4 r4.y, c16, r3
dp4 r4.z, c17, r3
mad r1.xyz, c18, r1.x, r4
mov r2.w, c20.y
dp4 r3.x, c12, r2
dp4 r3.y, c13, r2
dp4 r3.z, c14, r2
add oT4.xyz, r1, r3
dp4 r0.z, c2, v0
mov oPos, r0
mov oT2.zw, r0
mov oT3, c20.z

"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "UNITY_HDR_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 208
Vector 176 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 144
Vector 80 [_ProjectionParams]
ConstBuffer "UnityLighting" 720
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0
root12:aaaeaaaa
eefiecednmfjkehbcgpomfcgfkffmdbnlmpmiapbabaaaaaammahaaaaadaaaaaa
cmaaaaaaceabaaaanmabaaaaejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapaaaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
oiafaaaaeaaaabaahkabaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaae
egiocaaaadaaaaaabdaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadpccabaaa
adaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaac
aeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaf
pccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaaalaaaaaadiaaaaai
hcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaiccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaa
agahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaaf
mccabaaaadaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaadaaaaaakgakbaaa
abaaaaaamgaabaaaabaaaaaadgaaaaaipccabaaaaeaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaaakbabaaaacaaaaaa
akiacaaaadaaaaaabaaaaaaadiaaaaaiccaabaaaaaaaaaaaakbabaaaacaaaaaa
akiacaaaadaaaaaabbaaaaaadiaaaaaiecaabaaaaaaaaaaaakbabaaaacaaaaaa
akiacaaaadaaaaaabcaaaaaadiaaaaaibcaabaaaabaaaaaabkbabaaaacaaaaaa
bkiacaaaadaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaabkbabaaaacaaaaaa
bkiacaaaadaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaabkbabaaaacaaaaaa
bkiacaaaadaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaaacaaaaaackiacaaa
adaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaaacaaaaaackiacaaa
adaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaaacaaaaaackiacaaa
adaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaahbcaabaaaabaaaaaabkaabaaa
aaaaaaaabkaabaaaaaaaaaaadcaaaaakbcaabaaaabaaaaaaakaabaaaaaaaaaaa
akaabaaaaaaaaaaaakaabaiaebaaaaaaabaaaaaadiaaaaahpcaabaaaacaaaaaa
jgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaa
acaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaa
acaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaa
acaaaaaaclaaaaaaegaobaaaacaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
acaaaaaacmaaaaaaagaabaaaabaaaaaaegacbaaaadaaaaaadgaaaaaficaabaaa
aaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaacaaaaaaegiocaaaacaaaaaa
cgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaaacaaaaaaegiocaaaacaaaaaa
chaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaaacaaaaaaegiocaaaacaaaaaa
ciaaaaaaegaobaaaaaaaaaaaaaaaaaahhccabaaaafaaaaaaegacbaaaabaaaaaa
egacbaaaacaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "UNITY_HDR_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 208
Vector 176 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 144
Vector 80 [_ProjectionParams]
ConstBuffer "UnityLighting" 720
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
"vs_4_0_level_9_1
root12:aaaeaaaa
eefiecedajpemciclkepfonoangnhdmoefnjdhloabaaaaaacealaaaaaeaaaaaa
daaaaaaaieadaaaaheajaaaagmakaaaaebgpgodjemadaaaaemadaaaaaaacpopp
oiacaaaageaaaaaaafaaceaaaaaagaaaaaaagaaaaaaaceaaabaagaaaaaaaalaa
abaaabaaaaaaaaaaabaaafaaabaaacaaaaaaaaaaacaacgaaahaaadaaaaaaaaaa
adaaaaaaaeaaakaaaaaaaaaaadaaamaaahaaaoaaaaaaaaaaaaaaaaaaaaacpopp
fbaaaaafbfaaapkaaaaaaadpaaaaiadpaaaaaaaaaaaaaaaabpaaaaacafaaaaia
aaaaapjabpaaaaacafaaaciaacaaapjabpaaaaacafaaadiaadaaapjaaeaaaaae
aaaaadoaadaaoejaabaaoekaabaaookaafaaaaadaaaaahiaaaaaffjaapaaoeka
aeaaaaaeaaaaahiaaoaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaahiabaaaoeka
aaaakkjaaaaaoeiaaeaaaaaeabaaahoabbaaoekaaaaappjaaaaaoeiaafaaaaad
aaaaapiaaaaaffjaalaaoekaaeaaaaaeaaaaapiaakaaoekaaaaaaajaaaaaoeia
aeaaaaaeaaaaapiaamaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaanaaoeka
aaaappjaaaaaoeiaafaaaaadabaaabiaaaaaffiaacaaaakaafaaaaadabaaaiia
abaaaaiabfaaaakaafaaaaadabaaafiaaaaapeiabfaaaakaacaaaaadacaaadoa
abaakkiaabaaomiaafaaaaadabaaabiaacaaaajabcaaaakaafaaaaadabaaacia
acaaaajabdaaaakaafaaaaadabaaaeiaacaaaajabeaaaakaafaaaaadacaaabia
acaaffjabcaaffkaafaaaaadacaaaciaacaaffjabdaaffkaafaaaaadacaaaeia
acaaffjabeaaffkaacaaaaadabaaahiaabaaoeiaacaaoeiaafaaaaadacaaabia
acaakkjabcaakkkaafaaaaadacaaaciaacaakkjabdaakkkaafaaaaadacaaaeia
acaakkjabeaakkkaacaaaaadabaaahiaabaaoeiaacaaoeiaceaaaaacacaaahia
abaaoeiaafaaaaadabaaabiaacaaffiaacaaffiaaeaaaaaeabaaabiaacaaaaia
acaaaaiaabaaaaibafaaaaadadaaapiaacaacjiaacaakeiaajaaaaadaeaaabia
agaaoekaadaaoeiaajaaaaadaeaaaciaahaaoekaadaaoeiaajaaaaadaeaaaeia
aiaaoekaadaaoeiaaeaaaaaeabaaahiaajaaoekaabaaaaiaaeaaoeiaabaaaaac
acaaaiiabfaaffkaajaaaaadadaaabiaadaaoekaacaaoeiaajaaaaadadaaacia
aeaaoekaacaaoeiaajaaaaadadaaaeiaafaaoekaacaaoeiaacaaaaadaeaaahoa
abaaoeiaadaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaac
aaaaammaaaaaoeiaabaaaaacacaaamoaaaaaoeiaabaaaaacadaaapoabfaakkka
ppppaaaafdeieefcoiafaaaaeaaaabaahkabaaaafjaaaaaeegiocaaaaaaaaaaa
amaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
cnaaaaaafjaaaaaeegiocaaaadaaaaaabdaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
gfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaadhccabaaa
afaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaa
alaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaacaaaaaa
egiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaadaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
adaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadgaaaaaipccabaaaaeaaaaaa
aceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaa
akbabaaaacaaaaaaakiacaaaadaaaaaabaaaaaaadiaaaaaiccaabaaaaaaaaaaa
akbabaaaacaaaaaaakiacaaaadaaaaaabbaaaaaadiaaaaaiecaabaaaaaaaaaaa
akbabaaaacaaaaaaakiacaaaadaaaaaabcaaaaaadiaaaaaibcaabaaaabaaaaaa
bkbabaaaacaaaaaabkiacaaaadaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaa
bkbabaaaacaaaaaabkiacaaaadaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaa
bkbabaaaacaaaaaabkiacaaaadaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaa
acaaaaaackiacaaaadaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaa
acaaaaaackiacaaaadaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaa
acaaaaaackiacaaaadaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaahbcaabaaa
abaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaakbcaabaaaabaaaaaa
akaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaiaebaaaaaaabaaaaaadiaaaaah
pcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaa
adaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaa
adaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaa
adaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaaacaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaacaaaaaacmaaaaaaagaabaaaabaaaaaaegacbaaaadaaaaaa
dgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaacaaaaaa
egiocaaaacaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaaacaaaaaa
egiocaaaacaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaaacaaaaaa
egiocaaaacaaaaaaciaaaaaaegaobaaaaaaaaaaaaaaaaaahhccabaaaafaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaadoaaaaabejfdeheopaaaaaaaaiaaaaaa
aiaaaaaamiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apadaaaaoaaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaa
acaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaa
adaaaaaaagaaaaaaapaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaa
apaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffied
epepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklkl"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" "HDR_LIGHT_PREPASS_OFF" }
"!!GLSL#version 120

#ifdef VERTEX
uniform vec4 _ProjectionParams;
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHC;

uniform mat4 _Object2World;
uniform mat4 _World2Object;
uniform vec4 unity_FogParams;
uniform vec4 _MainTex_ST;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
varying float xlv_TEXCOORD5;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 o_3;
  vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_1.zw;
  tmpvar_2.zw = vec2(0.0, 0.0);
  tmpvar_2.xy = vec2(0.0, 0.0);
  vec4 v_6;
  v_6.x = _World2Object[0].x;
  v_6.y = _World2Object[1].x;
  v_6.z = _World2Object[2].x;
  v_6.w = _World2Object[3].x;
  vec4 v_7;
  v_7.x = _World2Object[0].y;
  v_7.y = _World2Object[1].y;
  v_7.z = _World2Object[2].y;
  v_7.w = _World2Object[3].y;
  vec4 v_8;
  v_8.x = _World2Object[0].z;
  v_8.y = _World2Object[1].z;
  v_8.z = _World2Object[2].z;
  v_8.w = _World2Object[3].z;
  vec3 tmpvar_9;
  tmpvar_9 = normalize(((
    (v_6.xyz * gl_Normal.x)
   + 
    (v_7.xyz * gl_Normal.y)
  ) + (v_8.xyz * gl_Normal.z)));
  vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = tmpvar_9;
  vec3 x2_11;
  vec3 x1_12;
  x1_12.x = dot (unity_SHAr, tmpvar_10);
  x1_12.y = dot (unity_SHAg, tmpvar_10);
  x1_12.z = dot (unity_SHAb, tmpvar_10);
  vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_9.xyzz * tmpvar_9.yzzx);
  x2_11.x = dot (unity_SHBr, tmpvar_13);
  x2_11.y = dot (unity_SHBg, tmpvar_13);
  x2_11.z = dot (unity_SHBb, tmpvar_13);
  float tmpvar_14;
  tmpvar_14 = (unity_FogParams.x * tmpvar_1.z);
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * gl_Vertex).xyz;
  xlv_TEXCOORD2 = o_3;
  xlv_TEXCOORD3 = tmpvar_2;
  xlv_TEXCOORD4 = ((x2_11 + (unity_SHC.xyz * 
    ((tmpvar_9.x * tmpvar_9.x) - (tmpvar_9.y * tmpvar_9.y))
  )) + x1_12);
  xlv_TEXCOORD5 = exp2((-(tmpvar_14) * tmpvar_14));
}


#endif
#ifdef FRAGMENT
uniform vec4 unity_FogColor;
uniform vec4 _SpecColor;
uniform sampler2D _MainTex;
uniform vec4 _Color;
uniform sampler2D _LightBuffer;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD4;
varying float xlv_TEXCOORD5;
void main ()
{
  vec4 c_1;
  vec4 light_2;
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  light_2 = -(log2(texture2DProj (_LightBuffer, xlv_TEXCOORD2)));
  light_2.xyz = (light_2.xyz + xlv_TEXCOORD4);
  vec4 c_4;
  c_4.xyz = (((tmpvar_3.xyz * _Color.xyz) * light_2.xyz) + ((light_2.xyz * _SpecColor.xyz) * (light_2.w * tmpvar_3.w)));
  c_4.w = (tmpvar_3.w * _Color.w);
  c_1.xyz = mix (unity_FogColor.xyz, c_4.xyz, vec3(clamp (xlv_TEXCOORD5, 0.0, 1.0)));
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 4 [_Object2World] 3
Matrix 7 [_World2Object] 3
Matrix 0 [glstate_matrix_mvp]
Vector 20 [_MainTex_ST]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Vector 19 [unity_FogParams]
Vector 14 [unity_SHAb]
Vector 13 [unity_SHAg]
Vector 12 [unity_SHAr]
Vector 17 [unity_SHBb]
Vector 16 [unity_SHBg]
Vector 15 [unity_SHBr]
Vector 18 [unity_SHC]
"vs_2_0
def c21, 0.5, 1, 0, 0
dcl_position v0
dcl_normal v1
dcl_texcoord v2
mad oT0.xy, v2, c20, c20.zwzw
dp4 oT1.x, c4, v0
dp4 oT1.y, c5, v0
dp4 oT1.z, c6, v0
dp4 r0.y, c1, v0
mul r1.x, r0.y, c10.x
mul r1.w, r1.x, c21.x
dp4 r0.x, c0, v0
dp4 r0.w, c3, v0
mul r1.xz, r0.xyww, c21.x
mad oT2.xy, r1.z, c11.zwzw, r1.xwzw
mul r1.xyz, v1.y, c8
mad r1.xyz, c7, v1.x, r1
mad r1.xyz, c9, v1.z, r1
nrm r2.xyz, r1
mul r1.x, r2.y, r2.y
mad r1.x, r2.x, r2.x, -r1.x
mul r3, r2.yzzx, r2.xyzz
dp4 r4.x, c15, r3
dp4 r4.y, c16, r3
dp4 r4.z, c17, r3
mad r1.xyz, c18, r1.x, r4
mov r2.w, c21.y
dp4 r3.x, c12, r2
dp4 r3.y, c13, r2
dp4 r3.z, c14, r2
add oT4.xyz, r1, r3
dp4 r0.z, c2, v0
mul r1.x, r0.z, c19.x
mul r1.x, r1.x, -r1.x
exp oT5.x, r1.x
mov oPos, r0
mov oT2.zw, r0
mov oT3, c21.z

"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 208
Vector 176 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 144
Vector 80 [_ProjectionParams]
ConstBuffer "UnityLighting" 720
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
ConstBuffer "UnityFog" 32
Vector 16 [unity_FogParams]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityFog" 4
"vs_4_0
root12:aaafaaaa
eefiecedocfbhjilgfligmecldecnlingmlkobknabaaaaaafeaiaaaaadaaaaaa
cmaaaaaaceabaaaapeabaaaaejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaabaaaaaaaealaaaalmaaaaaa
abaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaa
adaaaaaaadaaaaaaapaaaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
apaaaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcfiagaaaaeaaaabaa
jgabaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaa
bdaaaaaafjaaaaaeegiocaaaaeaaaaaaacaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadeccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaa
aeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaibcaabaaaabaaaaaackaabaaaaaaaaaaaakiacaaaaeaaaaaa
abaaaaaadiaaaaaibcaabaaaabaaaaaaakaabaaaabaaaaaaakaabaiaebaaaaaa
abaaaaaabjaaaaafeccabaaaabaaaaaaakaabaaaabaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaa
alaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaacaaaaaa
egiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaadaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
adaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadgaaaaaipccabaaaaeaaaaaa
aceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaa
akbabaaaacaaaaaaakiacaaaadaaaaaabaaaaaaadiaaaaaiccaabaaaaaaaaaaa
akbabaaaacaaaaaaakiacaaaadaaaaaabbaaaaaadiaaaaaiecaabaaaaaaaaaaa
akbabaaaacaaaaaaakiacaaaadaaaaaabcaaaaaadiaaaaaibcaabaaaabaaaaaa
bkbabaaaacaaaaaabkiacaaaadaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaa
bkbabaaaacaaaaaabkiacaaaadaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaa
bkbabaaaacaaaaaabkiacaaaadaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaa
acaaaaaackiacaaaadaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaa
acaaaaaackiacaaaadaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaa
acaaaaaackiacaaaadaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaahbcaabaaa
abaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaakbcaabaaaabaaaaaa
akaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaiaebaaaaaaabaaaaaadiaaaaah
pcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaa
adaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaa
adaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaa
adaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaaacaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaacaaaaaacmaaaaaaagaabaaaabaaaaaaegacbaaaadaaaaaa
dgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaacaaaaaa
egiocaaaacaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaaacaaaaaa
egiocaaaacaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaaacaaaaaa
egiocaaaacaaaaaaciaaaaaaegaobaaaaaaaaaaaaaaaaaahhccabaaaafaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 208
Vector 176 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 144
Vector 80 [_ProjectionParams]
ConstBuffer "UnityLighting" 720
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
ConstBuffer "UnityFog" 32
Vector 16 [unity_FogParams]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityFog" 4
"vs_4_0_level_9_1
root12:aaafaaaa
eefieceddnjcldiphlcgbhkhipoelfjpnbaiiiebabaaaaaaoealaaaaaeaaaaaa
daaaaaaalmadaaaabmakaaaabealaaaaebgpgodjieadaaaaieadaaaaaaacpopp
beadaaaahaaaaaaaagaaceaaaaaagmaaaaaagmaaaaaaceaaabaagmaaaaaaalaa
abaaabaaaaaaaaaaabaaafaaabaaacaaaaaaaaaaacaacgaaahaaadaaaaaaaaaa
adaaaaaaaeaaakaaaaaaaaaaadaaamaaahaaaoaaaaaaaaaaaeaaabaaabaabfaa
aaaaaaaaaaaaaaaaaaacpoppfbaaaaafbgaaapkaaaaaaadpaaaaiadpaaaaaaaa
aaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaciaacaaapjabpaaaaac
afaaadiaadaaapjaaeaaaaaeaaaaadoaadaaoejaabaaoekaabaaookaafaaaaad
aaaaahiaaaaaffjaapaaoekaaeaaaaaeaaaaahiaaoaaoekaaaaaaajaaaaaoeia
aeaaaaaeaaaaahiabaaaoekaaaaakkjaaaaaoeiaaeaaaaaeabaaahoabbaaoeka
aaaappjaaaaaoeiaafaaaaadaaaaapiaaaaaffjaalaaoekaaeaaaaaeaaaaapia
akaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaamaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiaanaaoekaaaaappjaaaaaoeiaafaaaaadabaaabiaaaaaffia
acaaaakaafaaaaadabaaaiiaabaaaaiabgaaaakaafaaaaadabaaafiaaaaapeia
bgaaaakaacaaaaadacaaadoaabaakkiaabaaomiaafaaaaadabaaabiaacaaaaja
bcaaaakaafaaaaadabaaaciaacaaaajabdaaaakaafaaaaadabaaaeiaacaaaaja
beaaaakaafaaaaadacaaabiaacaaffjabcaaffkaafaaaaadacaaaciaacaaffja
bdaaffkaafaaaaadacaaaeiaacaaffjabeaaffkaacaaaaadabaaahiaabaaoeia
acaaoeiaafaaaaadacaaabiaacaakkjabcaakkkaafaaaaadacaaaciaacaakkja
bdaakkkaafaaaaadacaaaeiaacaakkjabeaakkkaacaaaaadabaaahiaabaaoeia
acaaoeiaceaaaaacacaaahiaabaaoeiaafaaaaadabaaabiaacaaffiaacaaffia
aeaaaaaeabaaabiaacaaaaiaacaaaaiaabaaaaibafaaaaadadaaapiaacaacjia
acaakeiaajaaaaadaeaaabiaagaaoekaadaaoeiaajaaaaadaeaaaciaahaaoeka
adaaoeiaajaaaaadaeaaaeiaaiaaoekaadaaoeiaaeaaaaaeabaaahiaajaaoeka
abaaaaiaaeaaoeiaabaaaaacacaaaiiabgaaffkaajaaaaadadaaabiaadaaoeka
acaaoeiaajaaaaadadaaaciaaeaaoekaacaaoeiaajaaaaadadaaaeiaafaaoeka
acaaoeiaacaaaaadaeaaahoaabaaoeiaadaaoeiaafaaaaadabaaabiaaaaakkia
bfaaaakaafaaaaadabaaabiaabaaaaiaabaaaaibaoaaaaacaaaaaeoaabaaaaia
aeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeia
abaaaaacacaaamoaaaaaoeiaabaaaaacadaaapoabgaakkkappppaaaafdeieefc
fiagaaaaeaaaabaajgabaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaae
egiocaaaadaaaaaabdaaaaaafjaaaaaeegiocaaaaeaaaaaaacaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
eccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaa
gfaaaaadpccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaacaeaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaa
aaaaaaaaegaobaaaaaaaaaaadiaaaaaibcaabaaaabaaaaaackaabaaaaaaaaaaa
akiacaaaaeaaaaaaabaaaaaadiaaaaaibcaabaaaabaaaaaaakaabaaaabaaaaaa
akaabaiaebaaaaaaabaaaaaabjaaaaafeccabaaaabaaaaaaakaabaaaabaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaa
ogikcaaaaaaaaaaaalaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaak
hccabaaaacaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
abaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaa
afaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadp
aaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaadaaaaaakgaobaaaaaaaaaaa
aaaaaaahdccabaaaadaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadgaaaaai
pccabaaaaeaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadiaaaaai
bcaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaabaaaaaaadiaaaaai
ccaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaabbaaaaaadiaaaaai
ecaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaabcaaaaaadiaaaaai
bcaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaabaaaaaaadiaaaaai
ccaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaabbaaaaaadiaaaaai
ecaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaabcaaaaaaaaaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaadaaaaaabaaaaaaadiaaaaaiccaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaadaaaaaabbaaaaaadiaaaaaiecaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaadaaaaaabcaaaaaaaaaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
diaaaaahbcaabaaaabaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaak
bcaabaaaabaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaiaebaaaaaa
abaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaa
bbaaaaaibcaabaaaadaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaaacaaaaaa
bbaaaaaiccaabaaaadaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaaacaaaaaa
bbaaaaaiecaabaaaadaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaaacaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaacmaaaaaaagaabaaaabaaaaaa
egacbaaaadaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaai
bcaabaaaacaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaai
ccaabaaaacaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaai
ecaabaaaacaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaaaaaaaaaaaaaaaaah
hccabaaaafaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadoaaaaabejfdeheo
paaaaaaaaiaaaaaaaiaaaaaamiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apapaaaanbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaanjaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaoaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaadaaaaaaapadaaaaoaaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
apaaaaaaoaaaaaaaacaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaaoaaaaaaa
adaaaaaaaaaaaaaaadaaaaaaagaaaaaaapaaaaaaojaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaahaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaabaaaaaaaealaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklkl"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" "UNITY_HDR_ON" }
"!!GLSL#version 120

#ifdef VERTEX
uniform vec4 _ProjectionParams;
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHC;

uniform mat4 _Object2World;
uniform mat4 _World2Object;
uniform vec4 unity_FogParams;
uniform vec4 _MainTex_ST;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD4;
varying float xlv_TEXCOORD5;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 o_3;
  vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_1.zw;
  tmpvar_2.zw = vec2(0.0, 0.0);
  tmpvar_2.xy = vec2(0.0, 0.0);
  vec4 v_6;
  v_6.x = _World2Object[0].x;
  v_6.y = _World2Object[1].x;
  v_6.z = _World2Object[2].x;
  v_6.w = _World2Object[3].x;
  vec4 v_7;
  v_7.x = _World2Object[0].y;
  v_7.y = _World2Object[1].y;
  v_7.z = _World2Object[2].y;
  v_7.w = _World2Object[3].y;
  vec4 v_8;
  v_8.x = _World2Object[0].z;
  v_8.y = _World2Object[1].z;
  v_8.z = _World2Object[2].z;
  v_8.w = _World2Object[3].z;
  vec3 tmpvar_9;
  tmpvar_9 = normalize(((
    (v_6.xyz * gl_Normal.x)
   + 
    (v_7.xyz * gl_Normal.y)
  ) + (v_8.xyz * gl_Normal.z)));
  vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = tmpvar_9;
  vec3 x2_11;
  vec3 x1_12;
  x1_12.x = dot (unity_SHAr, tmpvar_10);
  x1_12.y = dot (unity_SHAg, tmpvar_10);
  x1_12.z = dot (unity_SHAb, tmpvar_10);
  vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_9.xyzz * tmpvar_9.yzzx);
  x2_11.x = dot (unity_SHBr, tmpvar_13);
  x2_11.y = dot (unity_SHBg, tmpvar_13);
  x2_11.z = dot (unity_SHBb, tmpvar_13);
  float tmpvar_14;
  tmpvar_14 = (unity_FogParams.x * tmpvar_1.z);
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (_Object2World * gl_Vertex).xyz;
  xlv_TEXCOORD2 = o_3;
  xlv_TEXCOORD3 = tmpvar_2;
  xlv_TEXCOORD4 = ((x2_11 + (unity_SHC.xyz * 
    ((tmpvar_9.x * tmpvar_9.x) - (tmpvar_9.y * tmpvar_9.y))
  )) + x1_12);
  xlv_TEXCOORD5 = exp2((-(tmpvar_14) * tmpvar_14));
}


#endif
#ifdef FRAGMENT
uniform vec4 unity_FogColor;
uniform vec4 _SpecColor;
uniform sampler2D _MainTex;
uniform vec4 _Color;
uniform sampler2D _LightBuffer;
varying vec2 xlv_TEXCOORD0;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD4;
varying float xlv_TEXCOORD5;
void main ()
{
  vec4 c_1;
  vec4 light_2;
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  vec4 tmpvar_4;
  tmpvar_4 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_2.w = tmpvar_4.w;
  light_2.xyz = (tmpvar_4.xyz + xlv_TEXCOORD4);
  vec4 c_5;
  c_5.xyz = (((tmpvar_3.xyz * _Color.xyz) * light_2.xyz) + ((light_2.xyz * _SpecColor.xyz) * (tmpvar_4.w * tmpvar_3.w)));
  c_5.w = (tmpvar_3.w * _Color.w);
  c_1.xyz = mix (unity_FogColor.xyz, c_5.xyz, vec3(clamp (xlv_TEXCOORD5, 0.0, 1.0)));
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" "UNITY_HDR_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 4 [_Object2World] 3
Matrix 7 [_World2Object] 3
Matrix 0 [glstate_matrix_mvp]
Vector 20 [_MainTex_ST]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Vector 19 [unity_FogParams]
Vector 14 [unity_SHAb]
Vector 13 [unity_SHAg]
Vector 12 [unity_SHAr]
Vector 17 [unity_SHBb]
Vector 16 [unity_SHBg]
Vector 15 [unity_SHBr]
Vector 18 [unity_SHC]
"vs_2_0
def c21, 0.5, 1, 0, 0
dcl_position v0
dcl_normal v1
dcl_texcoord v2
mad oT0.xy, v2, c20, c20.zwzw
dp4 oT1.x, c4, v0
dp4 oT1.y, c5, v0
dp4 oT1.z, c6, v0
dp4 r0.y, c1, v0
mul r1.x, r0.y, c10.x
mul r1.w, r1.x, c21.x
dp4 r0.x, c0, v0
dp4 r0.w, c3, v0
mul r1.xz, r0.xyww, c21.x
mad oT2.xy, r1.z, c11.zwzw, r1.xwzw
mul r1.xyz, v1.y, c8
mad r1.xyz, c7, v1.x, r1
mad r1.xyz, c9, v1.z, r1
nrm r2.xyz, r1
mul r1.x, r2.y, r2.y
mad r1.x, r2.x, r2.x, -r1.x
mul r3, r2.yzzx, r2.xyzz
dp4 r4.x, c15, r3
dp4 r4.y, c16, r3
dp4 r4.z, c17, r3
mad r1.xyz, c18, r1.x, r4
mov r2.w, c21.y
dp4 r3.x, c12, r2
dp4 r3.y, c13, r2
dp4 r3.z, c14, r2
add oT4.xyz, r1, r3
dp4 r0.z, c2, v0
mul r1.x, r0.z, c19.x
mul r1.x, r1.x, -r1.x
exp oT5.x, r1.x
mov oPos, r0
mov oT2.zw, r0
mov oT3, c21.z

"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" "UNITY_HDR_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 208
Vector 176 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 144
Vector 80 [_ProjectionParams]
ConstBuffer "UnityLighting" 720
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
ConstBuffer "UnityFog" 32
Vector 16 [unity_FogParams]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityFog" 4
"vs_4_0
root12:aaafaaaa
eefiecedocfbhjilgfligmecldecnlingmlkobknabaaaaaafeaiaaaaadaaaaaa
cmaaaaaaceabaaaapeabaaaaejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaabaaaaaaaealaaaalmaaaaaa
abaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaa
adaaaaaaadaaaaaaapaaaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
apaaaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcfiagaaaaeaaaabaa
jgabaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaa
bdaaaaaafjaaaaaeegiocaaaaeaaaaaaacaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadeccabaaaabaaaaaa
gfaaaaadhccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaadpccabaaa
aeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaibcaabaaaabaaaaaackaabaaaaaaaaaaaakiacaaaaeaaaaaa
abaaaaaadiaaaaaibcaabaaaabaaaaaaakaabaaaabaaaaaaakaabaiaebaaaaaa
abaaaaaabjaaaaafeccabaaaabaaaaaaakaabaaaabaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaa
alaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaacaaaaaa
egiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaadaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
adaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadgaaaaaipccabaaaaeaaaaaa
aceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaa
akbabaaaacaaaaaaakiacaaaadaaaaaabaaaaaaadiaaaaaiccaabaaaaaaaaaaa
akbabaaaacaaaaaaakiacaaaadaaaaaabbaaaaaadiaaaaaiecaabaaaaaaaaaaa
akbabaaaacaaaaaaakiacaaaadaaaaaabcaaaaaadiaaaaaibcaabaaaabaaaaaa
bkbabaaaacaaaaaabkiacaaaadaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaa
bkbabaaaacaaaaaabkiacaaaadaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaa
bkbabaaaacaaaaaabkiacaaaadaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaa
acaaaaaackiacaaaadaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaa
acaaaaaackiacaaaadaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaa
acaaaaaackiacaaaadaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaahbcaabaaa
abaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaakbcaabaaaabaaaaaa
akaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaiaebaaaaaaabaaaaaadiaaaaah
pcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaa
adaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaa
adaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaa
adaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaaacaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaacaaaaaacmaaaaaaagaabaaaabaaaaaaegacbaaaadaaaaaa
dgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaacaaaaaa
egiocaaaacaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaaacaaaaaa
egiocaaaacaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaaacaaaaaa
egiocaaaacaaaaaaciaaaaaaegaobaaaaaaaaaaaaaaaaaahhccabaaaafaaaaaa
egacbaaaabaaaaaaegacbaaaacaaaaaadoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" "UNITY_HDR_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 208
Vector 176 [_MainTex_ST]
ConstBuffer "UnityPerCamera" 144
Vector 80 [_ProjectionParams]
ConstBuffer "UnityLighting" 720
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
ConstBuffer "UnityFog" 32
Vector 16 [unity_FogParams]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
BindCB  "UnityLighting" 2
BindCB  "UnityPerDraw" 3
BindCB  "UnityFog" 4
"vs_4_0_level_9_1
root12:aaafaaaa
eefieceddnjcldiphlcgbhkhipoelfjpnbaiiiebabaaaaaaoealaaaaaeaaaaaa
daaaaaaalmadaaaabmakaaaabealaaaaebgpgodjieadaaaaieadaaaaaaacpopp
beadaaaahaaaaaaaagaaceaaaaaagmaaaaaagmaaaaaaceaaabaagmaaaaaaalaa
abaaabaaaaaaaaaaabaaafaaabaaacaaaaaaaaaaacaacgaaahaaadaaaaaaaaaa
adaaaaaaaeaaakaaaaaaaaaaadaaamaaahaaaoaaaaaaaaaaaeaaabaaabaabfaa
aaaaaaaaaaaaaaaaaaacpoppfbaaaaafbgaaapkaaaaaaadpaaaaiadpaaaaaaaa
aaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaaciaacaaapjabpaaaaac
afaaadiaadaaapjaaeaaaaaeaaaaadoaadaaoejaabaaoekaabaaookaafaaaaad
aaaaahiaaaaaffjaapaaoekaaeaaaaaeaaaaahiaaoaaoekaaaaaaajaaaaaoeia
aeaaaaaeaaaaahiabaaaoekaaaaakkjaaaaaoeiaaeaaaaaeabaaahoabbaaoeka
aaaappjaaaaaoeiaafaaaaadaaaaapiaaaaaffjaalaaoekaaeaaaaaeaaaaapia
akaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaamaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiaanaaoekaaaaappjaaaaaoeiaafaaaaadabaaabiaaaaaffia
acaaaakaafaaaaadabaaaiiaabaaaaiabgaaaakaafaaaaadabaaafiaaaaapeia
bgaaaakaacaaaaadacaaadoaabaakkiaabaaomiaafaaaaadabaaabiaacaaaaja
bcaaaakaafaaaaadabaaaciaacaaaajabdaaaakaafaaaaadabaaaeiaacaaaaja
beaaaakaafaaaaadacaaabiaacaaffjabcaaffkaafaaaaadacaaaciaacaaffja
bdaaffkaafaaaaadacaaaeiaacaaffjabeaaffkaacaaaaadabaaahiaabaaoeia
acaaoeiaafaaaaadacaaabiaacaakkjabcaakkkaafaaaaadacaaaciaacaakkja
bdaakkkaafaaaaadacaaaeiaacaakkjabeaakkkaacaaaaadabaaahiaabaaoeia
acaaoeiaceaaaaacacaaahiaabaaoeiaafaaaaadabaaabiaacaaffiaacaaffia
aeaaaaaeabaaabiaacaaaaiaacaaaaiaabaaaaibafaaaaadadaaapiaacaacjia
acaakeiaajaaaaadaeaaabiaagaaoekaadaaoeiaajaaaaadaeaaaciaahaaoeka
adaaoeiaajaaaaadaeaaaeiaaiaaoekaadaaoeiaaeaaaaaeabaaahiaajaaoeka
abaaaaiaaeaaoeiaabaaaaacacaaaiiabgaaffkaajaaaaadadaaabiaadaaoeka
acaaoeiaajaaaaadadaaaciaaeaaoekaacaaoeiaajaaaaadadaaaeiaafaaoeka
acaaoeiaacaaaaadaeaaahoaabaaoeiaadaaoeiaafaaaaadabaaabiaaaaakkia
bfaaaakaafaaaaadabaaabiaabaaaaiaabaaaaibaoaaaaacaaaaaeoaabaaaaia
aeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeia
abaaaaacacaaamoaaaaaoeiaabaaaaacadaaapoabgaakkkappppaaaafdeieefc
fiagaaaaeaaaabaajgabaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaae
egiocaaaadaaaaaabdaaaaaafjaaaaaeegiocaaaaeaaaaaaacaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
eccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaa
gfaaaaadpccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaacaeaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaa
aaaaaaaaegaobaaaaaaaaaaadiaaaaaibcaabaaaabaaaaaackaabaaaaaaaaaaa
akiacaaaaeaaaaaaabaaaaaadiaaaaaibcaabaaaabaaaaaaakaabaaaabaaaaaa
akaabaiaebaaaaaaabaaaaaabjaaaaafeccabaaaabaaaaaaakaabaaaabaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaa
ogikcaaaaaaaaaaaalaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaak
hccabaaaacaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
abaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaa
afaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadp
aaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaadaaaaaakgaobaaaaaaaaaaa
aaaaaaahdccabaaaadaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadgaaaaai
pccabaaaaeaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadiaaaaai
bcaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaabaaaaaaadiaaaaai
ccaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaabbaaaaaadiaaaaai
ecaabaaaaaaaaaaaakbabaaaacaaaaaaakiacaaaadaaaaaabcaaaaaadiaaaaai
bcaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaabaaaaaaadiaaaaai
ccaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaabbaaaaaadiaaaaai
ecaabaaaabaaaaaabkbabaaaacaaaaaabkiacaaaadaaaaaabcaaaaaaaaaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaadaaaaaabaaaaaaadiaaaaaiccaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaadaaaaaabbaaaaaadiaaaaaiecaabaaa
abaaaaaackbabaaaacaaaaaackiacaaaadaaaaaabcaaaaaaaaaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
diaaaaahbcaabaaaabaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaak
bcaabaaaabaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaiaebaaaaaa
abaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaa
bbaaaaaibcaabaaaadaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaaacaaaaaa
bbaaaaaiccaabaaaadaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaaacaaaaaa
bbaaaaaiecaabaaaadaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaaacaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaacmaaaaaaagaabaaaabaaaaaa
egacbaaaadaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaai
bcaabaaaacaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaai
ccaabaaaacaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaai
ecaabaaaacaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaaaaaaaaaaaaaaaaah
hccabaaaafaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadoaaaaabejfdeheo
paaaaaaaaiaaaaaaaiaaaaaamiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apapaaaanbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaanjaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaoaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaadaaaaaaapadaaaaoaaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
apaaaaaaoaaaaaaaacaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaaoaaaaaaa
adaaaaaaaaaaaaaaadaaaaaaagaaaaaaapaaaaaaojaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaahaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaabaaaaaaaealaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklkl"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 1 [_Color]
Vector 0 [_SpecColor]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightBuffer] 2D 1
"ps_2_0
def c2, 1, 0, 0, 0
dcl t0.xy
dcl t2
dcl t4.xyz
dcl_2d s0
dcl_2d s1
texldp_pp r0, t2, s1
texld_pp r1, t0, s0
log_pp r2.x, r0.x
log_pp r2.y, r0.y
log_pp r2.z, r0.z
log_pp r2.w, r0.w
add_pp r0.xyz, -r2, t4
mul_pp r2.xyz, r0, c0
mul_pp r0.w, r1.w, -r2.w
mul_pp r1.xyz, r1, c1
mul_pp r2.xyz, r0.w, r2
mad_pp r0.xyz, r1, r0, r2
mov_pp r0.w, c2.x
mov_pp oC0, r0

"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightBuffer] 2D 1
ConstBuffer "$Globals" 208
Vector 112 [_SpecColor]
Vector 144 [_Color]
BindCB  "$Globals" 0
"ps_4_0
root12:acabacaa
eefiecedadipchhgajhlndipnabapadnomomheegabaaaaaapiacaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcniabaaaa
eaaaaaaahgaaaaaafjaaaaaeegiocaaaaaaaaaaaakaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
lcbabaaaadaaaaaagcbaaaadhcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacadaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaaadaaaaaapgbpbaaa
adaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaacpaaaaafpcaabaaaaaaaaaaaegaobaaaaaaaaaaaefaaaaaj
pcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
diaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaadkaabaaaabaaaaaa
aaaaaaaihcaabaaaaaaaaaaaegacbaiaebaaaaaaaaaaaaaaegbcbaaaafaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaajaaaaaa
diaaaaaihcaabaaaacaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaahaaaaaa
diaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaadcaaaaaj
hccabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaa
dgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightBuffer] 2D 1
ConstBuffer "$Globals" 208
Vector 112 [_SpecColor]
Vector 144 [_Color]
BindCB  "$Globals" 0
"ps_4_0_level_9_1
root12:acabacaa
eefiecedbgkdepchgdknppidmnceaahfmhfpalpiabaaaaaaimaeaaaaaeaaaaaa
daaaaaaamaabaaaakaadaaaafiaeaaaaebgpgodjiiabaaaaiiabaaaaaaacpppp
eeabaaaaeeaaaaaaacaacmaaaaaaeeaaaaaaeeaaacaaceaaaaaaeeaaaaaaaaaa
abababaaaaaaahaaabaaaaaaaaaaaaaaaaaaajaaabaaabaaaaaaaaaaaaacpppp
fbaaaaafacaaapkaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacaaaaaaia
aaaaadlabpaaaaacaaaaaaiaacaaaplabpaaaaacaaaaaaiaaeaaahlabpaaaaac
aaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapkaagaaaaacaaaaaiiaacaappla
afaaaaadaaaaadiaaaaappiaacaaoelaecaaaaadaaaacpiaaaaaoeiaabaioeka
ecaaaaadabaacpiaaaaaoelaaaaioekaapaaaaacacaacbiaaaaaaaiaapaaaaac
acaacciaaaaaffiaapaaaaacacaaceiaaaaakkiaapaaaaacacaaciiaaaaappia
acaaaaadaaaachiaacaaoeibaeaaoelaafaaaaadacaachiaaaaaoeiaaaaaoeka
afaaaaadaaaaciiaabaappiaacaappibafaaaaadabaachiaabaaoeiaabaaoeka
afaaaaadacaachiaaaaappiaacaaoeiaaeaaaaaeaaaachiaabaaoeiaaaaaoeia
acaaoeiaabaaaaacaaaaciiaacaaaakaabaaaaacaaaicpiaaaaaoeiappppaaaa
fdeieefcniabaaaaeaaaaaaahgaaaaaafjaaaaaeegiocaaaaaaaaaaaakaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadlcbabaaaadaaaaaagcbaaaadhcbabaaaafaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacadaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaa
adaaaaaapgbpbaaaadaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaa
eghobaaaabaaaaaaaagabaaaabaaaaaacpaaaaafpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaa
dkaabaaaabaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaiaebaaaaaaaaaaaaaa
egbcbaaaafaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaa
aaaaaaaaajaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaaaaaaaaaegiccaaa
aaaaaaaaahaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaa
acaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaaaaaaaaa
egacbaaaacaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab
ejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaa
keaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaaaaaakeaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaapalaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaapaaaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahahaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaa
abaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaa
fdfgfpfegbhcghgfheaaklkl"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "UNITY_HDR_ON" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "UNITY_HDR_ON" }
Vector 1 [_Color]
Vector 0 [_SpecColor]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightBuffer] 2D 1
"ps_2_0
def c2, 1, 0, 0, 0
dcl t0.xy
dcl t2
dcl t4.xyz
dcl_2d s0
dcl_2d s1
texld_pp r0, t0, s0
texldp_pp r1, t2, s1
mul_pp r0.w, r0.w, r1.w
mul_pp r0.xyz, r0, c1
add_pp r1.xyz, r1, t4
mul_pp r2.xyz, r1, c0
mul_pp r2.xyz, r0.w, r2
mad_pp r0.xyz, r0, r1, r2
mov_pp r0.w, c2.x
mov_pp oC0, r0

"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "UNITY_HDR_ON" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightBuffer] 2D 1
ConstBuffer "$Globals" 208
Vector 112 [_SpecColor]
Vector 144 [_Color]
BindCB  "$Globals" 0
"ps_4_0
root12:acabacaa
eefieceddpkcclcloafckhfjchljinmidkhgkkclabaaaaaanmacaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefclmabaaaa
eaaaaaaagpaaaaaafjaaaaaeegiocaaaaaaaaaaaakaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
lcbabaaaadaaaaaagcbaaaadhcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacadaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaaadaaaaaapgbpbaaa
adaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
dkaabaaaabaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegbcbaaa
afaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaa
ajaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaa
ahaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaa
dcaaaaajhccabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaaaaaaaaaegacbaaa
acaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "UNITY_HDR_ON" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightBuffer] 2D 1
ConstBuffer "$Globals" 208
Vector 112 [_SpecColor]
Vector 144 [_Color]
BindCB  "$Globals" 0
"ps_4_0_level_9_1
root12:acabacaa
eefiecednoojmlblkkgjfbdopnfmcjmehmjkdelgabaaaaaaeaaeaaaaaeaaaaaa
daaaaaaajaabaaaafeadaaaaamaeaaaaebgpgodjfiabaaaafiabaaaaaaacpppp
beabaaaaeeaaaaaaacaacmaaaaaaeeaaaaaaeeaaacaaceaaaaaaeeaaaaaaaaaa
abababaaaaaaahaaabaaaaaaaaaaaaaaaaaaajaaabaaabaaaaaaaaaaaaacpppp
fbaaaaafacaaapkaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacaaaaaaia
aaaaadlabpaaaaacaaaaaaiaacaaaplabpaaaaacaaaaaaiaaeaaahlabpaaaaac
aaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapkaagaaaaacaaaaaiiaacaappla
afaaaaadaaaaadiaaaaappiaacaaoelaecaaaaadaaaacpiaaaaaoeiaabaioeka
ecaaaaadabaacpiaaaaaoelaaaaioekaafaaaaadaaaaciiaaaaappiaabaappia
acaaaaadaaaachiaaaaaoeiaaeaaoelaafaaaaadabaachiaabaaoeiaabaaoeka
afaaaaadacaachiaaaaaoeiaaaaaoekaafaaaaadacaachiaaaaappiaacaaoeia
aeaaaaaeaaaachiaabaaoeiaaaaaoeiaacaaoeiaabaaaaacaaaaciiaacaaaaka
abaaaaacaaaicpiaaaaaoeiappppaaaafdeieefclmabaaaaeaaaaaaagpaaaaaa
fjaaaaaeegiocaaaaaaaaaaaakaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadlcbabaaaadaaaaaa
gcbaaaadhcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaa
aoaaaaahdcaabaaaaaaaaaaaegbabaaaadaaaaaapgbpbaaaadaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaadkaabaaaabaaaaaa
aaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegbcbaaaafaaaaaadiaaaaai
hcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaajaaaaaadiaaaaai
hcaabaaaacaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaahaaaaaadiaaaaah
hcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaadcaaaaajhccabaaa
aaaaaaaaegacbaaaabaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaadgaaaaaf
iccabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaabejfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apalaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" "HDR_LIGHT_PREPASS_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" "HDR_LIGHT_PREPASS_OFF" }
Vector 2 [_Color]
Vector 1 [_SpecColor]
Vector 0 [unity_FogColor]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightBuffer] 2D 1
"ps_2_0
def c3, 1, 0, 0, 0
dcl t0.xy
dcl t2
dcl t4.xyz
dcl t5.x
dcl_2d s0
dcl_2d s1
texldp_pp r0, t2, s1
texld_pp r1, t0, s0
log_pp r2.x, r0.x
log_pp r2.y, r0.y
log_pp r2.z, r0.z
log_pp r2.w, r0.w
add_pp r0.xyz, -r2, t4
mul_pp r2.xyz, r0, c1
mul_pp r0.w, r1.w, -r2.w
mul_pp r1.xyz, r1, c2
mul_pp r2.xyz, r0.w, r2
mad_pp r0.xyz, r1, r0, r2
mov_sat r0.w, t5.x
lrp_pp r1.xyz, r0.w, r0, c0
mov_pp r1.w, c3.x
mov_pp oC0, r1

"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" "HDR_LIGHT_PREPASS_OFF" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightBuffer] 2D 1
ConstBuffer "$Globals" 208
Vector 112 [_SpecColor]
Vector 144 [_Color]
ConstBuffer "UnityFog" 32
Vector 0 [unity_FogColor]
BindCB  "$Globals" 0
BindCB  "UnityFog" 1
"ps_4_0
root12:acacacaa
eefiecedjflfbnalcpdfjjhcgcmjoiegbnacoboaabaaaaaaimadaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaabaaaaaa
aeaeaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaaaaaalmaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaalmaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapaaaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcfeacaaaaeaaaaaaajfaaaaaa
fjaaaaaeegiocaaaaaaaaaaaakaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadecbabaaaabaaaaaagcbaaaadlcbabaaaadaaaaaagcbaaaad
hcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaoaaaaah
dcaabaaaaaaaaaaaegbabaaaadaaaaaapgbpbaaaadaaaaaaefaaaaajpcaabaaa
aaaaaaaaegaabaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaacpaaaaaf
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaaiicaabaaaaaaaaaaa
dkaabaiaebaaaaaaaaaaaaaadkaabaaaabaaaaaaaaaaaaaihcaabaaaaaaaaaaa
egacbaiaebaaaaaaaaaaaaaaegbcbaaaafaaaaaadiaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaegiccaaaaaaaaaaaajaaaaaadiaaaaaihcaabaaaacaaaaaa
egacbaaaaaaaaaaaegiccaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaaacaaaaaa
pgapbaaaaaaaaaaaegacbaaaacaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaa
abaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaaaaaaaaajhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegiccaiaebaaaaaaabaaaaaaaaaaaaaadgcaaaaficaabaaa
aaaaaaaackbabaaaabaaaaaadcaaaaakhccabaaaaaaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaaegiccaaaabaaaaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" "HDR_LIGHT_PREPASS_OFF" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightBuffer] 2D 1
ConstBuffer "$Globals" 208
Vector 112 [_SpecColor]
Vector 144 [_Color]
ConstBuffer "UnityFog" 32
Vector 0 [unity_FogColor]
BindCB  "$Globals" 0
BindCB  "UnityFog" 1
"ps_4_0_level_9_1
root12:acacacaa
eefiecedplnofhiaeoodofknmbonhobopelgckcpabaaaaaaemafaaaaaeaaaaaa
daaaaaaaomabaaaaeiaeaaaabiafaaaaebgpgodjleabaaaaleabaaaaaaacpppp
geabaaaafaaaaaaaadaacmaaaaaafaaaaaaafaaaacaaceaaaaaafaaaaaaaaaaa
abababaaaaaaahaaabaaaaaaaaaaaaaaaaaaajaaabaaabaaaaaaaaaaabaaaaaa
abaaacaaaaaaaaaaaaacppppfbaaaaafadaaapkaaaaaiadpaaaaaaaaaaaaaaaa
aaaaaaaabpaaaaacaaaaaaiaaaaaahlabpaaaaacaaaaaaiaacaaaplabpaaaaac
aaaaaaiaaeaaahlabpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapka
agaaaaacaaaaaiiaacaapplaafaaaaadaaaaadiaaaaappiaacaaoelaecaaaaad
aaaacpiaaaaaoeiaabaioekaecaaaaadabaacpiaaaaaoelaaaaioekaapaaaaac
acaacbiaaaaaaaiaapaaaaacacaacciaaaaaffiaapaaaaacacaaceiaaaaakkia
apaaaaacacaaciiaaaaappiaacaaaaadaaaachiaacaaoeibaeaaoelaafaaaaad
acaachiaaaaaoeiaaaaaoekaafaaaaadaaaaciiaabaappiaacaappibafaaaaad
abaachiaabaaoeiaabaaoekaafaaaaadacaachiaaaaappiaacaaoeiaaeaaaaae
aaaachiaabaaoeiaaaaaoeiaacaaoeiaabaaaaacaaaabiiaaaaakklabcaaaaae
abaachiaaaaappiaaaaaoeiaacaaoekaabaaaaacabaaciiaadaaaakaabaaaaac
aaaicpiaabaaoeiappppaaaafdeieefcfeacaaaaeaaaaaaajfaaaaaafjaaaaae
egiocaaaaaaaaaaaakaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaad
aagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadecbabaaaabaaaaaagcbaaaadlcbabaaaadaaaaaagcbaaaadhcbabaaa
afaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaoaaaaahdcaabaaa
aaaaaaaaegbabaaaadaaaaaapgbpbaaaadaaaaaaefaaaaajpcaabaaaaaaaaaaa
egaabaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaacpaaaaafpcaabaaa
aaaaaaaaegaobaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaia
ebaaaaaaaaaaaaaadkaabaaaabaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaia
ebaaaaaaaaaaaaaaegbcbaaaafaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaa
abaaaaaaegiccaaaaaaaaaaaajaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaa
aaaaaaaaegiccaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaa
aaaaaaaaegacbaaaacaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaabaaaaaa
egacbaaaaaaaaaaaegacbaaaacaaaaaaaaaaaaajhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegiccaiaebaaaaaaabaaaaaaaaaaaaaadgcaaaaficaabaaaaaaaaaaa
ckbabaaaabaaaaaadcaaaaakhccabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaaegiccaaaabaaaaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaa
aaaaiadpdoaaaaabejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaadadaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaabaaaaaaaeaeaaaa
lmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaaaaaalmaaaaaaacaaaaaa
aaaaaaaaadaaaaaaadaaaaaaapalaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaapaaaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahahaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaa
abaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaa
fdfgfpfegbhcghgfheaaklkl"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" "UNITY_HDR_ON" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" "UNITY_HDR_ON" }
Vector 2 [_Color]
Vector 1 [_SpecColor]
Vector 0 [unity_FogColor]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightBuffer] 2D 1
"ps_2_0
def c3, 1, 0, 0, 0
dcl t0.xy
dcl t2
dcl t4.xyz
dcl t5.x
dcl_2d s0
dcl_2d s1
texld_pp r0, t0, s0
texldp_pp r1, t2, s1
mul_pp r0.w, r0.w, r1.w
mul_pp r0.xyz, r0, c2
add_pp r1.xyz, r1, t4
mul_pp r2.xyz, r1, c1
mul_pp r2.xyz, r0.w, r2
mad_pp r0.xyz, r0, r1, r2
mov_sat r0.w, t5.x
lrp_pp r1.xyz, r0.w, r0, c0
mov_pp r1.w, c3.x
mov_pp oC0, r1

"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" "UNITY_HDR_ON" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightBuffer] 2D 1
ConstBuffer "$Globals" 208
Vector 112 [_SpecColor]
Vector 144 [_Color]
ConstBuffer "UnityFog" 32
Vector 0 [unity_FogColor]
BindCB  "$Globals" 0
BindCB  "UnityFog" 1
"ps_4_0
root12:acacacaa
eefiecedlmkdeellidnooolbjjejpdonbhcchgogabaaaaaahaadaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaabaaaaaa
aeaeaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaaaaaalmaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaalmaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapaaaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcdiacaaaaeaaaaaaaioaaaaaa
fjaaaaaeegiocaaaaaaaaaaaakaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadecbabaaaabaaaaaagcbaaaadlcbabaaaadaaaaaagcbaaaad
hcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaoaaaaah
dcaabaaaaaaaaaaaegbabaaaadaaaaaapgbpbaaaadaaaaaaefaaaaajpcaabaaa
aaaaaaaaegaabaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaefaaaaaj
pcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
diaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaadkaabaaaabaaaaaaaaaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegbcbaaaafaaaaaadiaaaaaihcaabaaa
abaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaajaaaaaadiaaaaaihcaabaaa
acaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaa
acaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaadcaaaaajhcaabaaaaaaaaaaa
egacbaaaabaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaaaaaaaaajhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegiccaiaebaaaaaaabaaaaaaaaaaaaaadgcaaaaf
icaabaaaaaaaaaaackbabaaaabaaaaaadcaaaaakhccabaaaaaaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaaegiccaaaabaaaaaaaaaaaaaadgaaaaaficcabaaa
aaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "FOG_EXP2" "UNITY_HDR_ON" }
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_LightBuffer] 2D 1
ConstBuffer "$Globals" 208
Vector 112 [_SpecColor]
Vector 144 [_Color]
ConstBuffer "UnityFog" 32
Vector 0 [unity_FogColor]
BindCB  "$Globals" 0
BindCB  "UnityFog" 1
"ps_4_0_level_9_1
root12:acacacaa
eefiecedejbbjfiddfcnbhbcdhmmeohonfgggkdaabaaaaaaaaafaaaaaeaaaaaa
daaaaaaalmabaaaapmadaaaammaeaaaaebgpgodjieabaaaaieabaaaaaaacpppp
deabaaaafaaaaaaaadaacmaaaaaafaaaaaaafaaaacaaceaaaaaafaaaaaaaaaaa
abababaaaaaaahaaabaaaaaaaaaaaaaaaaaaajaaabaaabaaaaaaaaaaabaaaaaa
abaaacaaaaaaaaaaaaacppppfbaaaaafadaaapkaaaaaiadpaaaaaaaaaaaaaaaa
aaaaaaaabpaaaaacaaaaaaiaaaaaahlabpaaaaacaaaaaaiaacaaaplabpaaaaac
aaaaaaiaaeaaahlabpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapka
agaaaaacaaaaaiiaacaapplaafaaaaadaaaaadiaaaaappiaacaaoelaecaaaaad
aaaacpiaaaaaoeiaabaioekaecaaaaadabaacpiaaaaaoelaaaaioekaafaaaaad
aaaaciiaaaaappiaabaappiaacaaaaadaaaachiaaaaaoeiaaeaaoelaafaaaaad
abaachiaabaaoeiaabaaoekaafaaaaadacaachiaaaaaoeiaaaaaoekaafaaaaad
acaachiaaaaappiaacaaoeiaaeaaaaaeaaaachiaabaaoeiaaaaaoeiaacaaoeia
abaaaaacaaaabiiaaaaakklabcaaaaaeabaachiaaaaappiaaaaaoeiaacaaoeka
abaaaaacabaaciiaadaaaakaabaaaaacaaaicpiaabaaoeiappppaaaafdeieefc
diacaaaaeaaaaaaaioaaaaaafjaaaaaeegiocaaaaaaaaaaaakaaaaaafjaaaaae
egiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaa
abaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadecbabaaaabaaaaaagcbaaaad
lcbabaaaadaaaaaagcbaaaadhcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacadaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaaadaaaaaapgbpbaaa
adaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
dkaabaaaabaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegbcbaaa
afaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaa
ajaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaa
ahaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaacaaaaaa
dcaaaaajhcaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaaaaaaaaaegacbaaa
acaaaaaaaaaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaiaebaaaaaa
abaaaaaaaaaaaaaadgcaaaaficaabaaaaaaaaaaackbabaaaabaaaaaadcaaaaak
hccabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaabaaaaaa
aaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaabejfdeheo
miaaaaaaahaaaaaaaiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaa
apaaaaaalmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaalmaaaaaa
afaaaaaaaaaaaaaaadaaaaaaabaaaaaaaeaeaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaaaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apalaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
"
}
}
 }
 Pass {
  Name "DEFERRED"
  Tags { "LIGHTMODE"="Deferred" "RenderType"="Opaque" }
  GpuProgramID 278695
Program "vp" {
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLSL#version 120

#ifdef VERTEX
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHC;

uniform mat4 _Object2World;
uniform mat4 _World2Object;
uniform vec4 _MainTex_ST;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD5;
void main ()
{
  vec4 tmpvar_1;
  vec4 v_2;
  v_2.x = _World2Object[0].x;
  v_2.y = _World2Object[1].x;
  v_2.z = _World2Object[2].x;
  v_2.w = _World2Object[3].x;
  vec4 v_3;
  v_3.x = _World2Object[0].y;
  v_3.y = _World2Object[1].y;
  v_3.z = _World2Object[2].y;
  v_3.w = _World2Object[3].y;
  vec4 v_4;
  v_4.x = _World2Object[0].z;
  v_4.y = _World2Object[1].z;
  v_4.z = _World2Object[2].z;
  v_4.w = _World2Object[3].z;
  vec3 tmpvar_5;
  tmpvar_5 = normalize(((
    (v_2.xyz * gl_Normal.x)
   + 
    (v_3.xyz * gl_Normal.y)
  ) + (v_4.xyz * gl_Normal.z)));
  tmpvar_1.zw = vec2(0.0, 0.0);
  tmpvar_1.xy = vec2(0.0, 0.0);
  vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  vec3 x2_7;
  vec3 x1_8;
  x1_8.x = dot (unity_SHAr, tmpvar_6);
  x1_8.y = dot (unity_SHAg, tmpvar_6);
  x1_8.z = dot (unity_SHAb, tmpvar_6);
  vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_5.xyzz * tmpvar_5.yzzx);
  x2_7.x = dot (unity_SHBr, tmpvar_9);
  x2_7.y = dot (unity_SHBg, tmpvar_9);
  x2_7.z = dot (unity_SHBb, tmpvar_9);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_5;
  xlv_TEXCOORD2 = (_Object2World * gl_Vertex).xyz;
  xlv_TEXCOORD4 = tmpvar_1;
  xlv_TEXCOORD5 = ((x2_7 + (unity_SHC.xyz * 
    ((tmpvar_5.x * tmpvar_5.x) - (tmpvar_5.y * tmpvar_5.y))
  )) + x1_8);
}


#endif
#ifdef FRAGMENT
uniform vec4 _SpecColor;
uniform sampler2D _MainTex;
uniform vec4 _Color;
uniform float _Shininess;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD5;
void main ()
{
  vec4 outDiffuse_1;
  vec4 outEmission_2;
  vec3 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0).xyz * _Color.xyz);
  vec4 emission_4;
  vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_3;
  vec4 tmpvar_6;
  tmpvar_6.xyz = _SpecColor.xyz;
  tmpvar_6.w = _Shininess;
  vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = ((xlv_TEXCOORD1 * 0.5) + 0.5);
  emission_4.w = 1.0;
  emission_4.xyz = (tmpvar_3 * xlv_TEXCOORD5);
  outDiffuse_1.xyz = tmpvar_5.xyz;
  outEmission_2.w = emission_4.w;
  outEmission_2.xyz = exp2(-(emission_4.xyz));
  outDiffuse_1.w = 1.0;
  gl_FragData[0] = outDiffuse_1;
  gl_FragData[1] = tmpvar_6;
  gl_FragData[2] = tmpvar_7;
  gl_FragData[3] = outEmission_2;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 4 [_Object2World] 3
Matrix 7 [_World2Object] 3
Matrix 0 [glstate_matrix_mvp]
Vector 17 [_MainTex_ST]
Vector 12 [unity_SHAb]
Vector 11 [unity_SHAg]
Vector 10 [unity_SHAr]
Vector 15 [unity_SHBb]
Vector 14 [unity_SHBg]
Vector 13 [unity_SHBr]
Vector 16 [unity_SHC]
"vs_2_0
def c18, 1, 0, 0, 0
dcl_position v0
dcl_normal v1
dcl_texcoord v2
dp4 oPos.x, c0, v0
dp4 oPos.y, c1, v0
dp4 oPos.z, c2, v0
dp4 oPos.w, c3, v0
mad oT0.xy, v2, c17, c17.zwzw
dp4 oT2.x, c4, v0
dp4 oT2.y, c5, v0
dp4 oT2.z, c6, v0
mul r0.xyz, v1.y, c8
mad r0.xyz, c7, v1.x, r0
mad r0.xyz, c9, v1.z, r0
nrm r1.xyz, r0
mul r0.x, r1.y, r1.y
mad r0.x, r1.x, r1.x, -r0.x
mul r2, r1.yzzx, r1.xyzz
dp4 r3.x, c13, r2
dp4 r3.y, c14, r2
dp4 r3.z, c15, r2
mad r0.xyz, c16, r0.x, r3
mov r1.w, c18.x
dp4 r2.x, c10, r1
dp4 r2.y, c11, r1
dp4 r2.z, c12, r1
mov oT1.xyz, r1
add oT5.xyz, r0, r2
mov oT4, c18.y

"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 208
Vector 176 [_MainTex_ST]
ConstBuffer "UnityLighting" 720
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
root12:aaadaaaa
eefiecedhcgciibgdacibploakicokpnlmcpkdehabaaaaaaeeahaaaaadaaaaaa
cmaaaaaaceabaaaanmabaaaaejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapaaaaaakeaaaaaaafaaaaaaaaaaaaaaadaaaaaaafaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
gaafaaaaeaaaabaafiabaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaae
egiocaaaabaaaaaacnaaaaaafjaaaaaeegiocaaaacaaaaaabdaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaa
gfaaaaadhccabaaaafaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaaalaaaaaadiaaaaaibcaabaaa
aaaaaaaaakbabaaaacaaaaaaakiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaa
aaaaaaaaakbabaaaacaaaaaaakiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaa
aaaaaaaaakbabaaaacaaaaaaakiacaaaacaaaaaabcaaaaaadiaaaaaibcaabaaa
abaaaaaabkbabaaaacaaaaaabkiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaa
abaaaaaabkbabaaaacaaaaaabkiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaa
abaaaaaabkbabaaaacaaaaaabkiacaaaacaaaaaabcaaaaaaaaaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaa
ckbabaaaacaaaaaackiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaa
ckbabaaaacaaaaaackiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaa
ckbabaaaacaaaaaackiacaaaacaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaf
hccabaaaacaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaa
aaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
acaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhccabaaaadaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egacbaaaabaaaaaadgaaaaaipccabaaaaeaaaaaaaceaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaadiaaaaahbcaabaaaabaaaaaabkaabaaaaaaaaaaabkaabaaa
aaaaaaaadcaaaaakbcaabaaaabaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaa
akaabaiaebaaaaaaabaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaa
egakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaabaaaaaacjaaaaaa
egaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaabaaaaaackaaaaaa
egaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaabaaaaaaclaaaaaa
egaobaaaacaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaabaaaaaacmaaaaaa
agaabaaaabaaaaaaegacbaaaadaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaa
aaaaiadpbbaaaaaibcaabaaaacaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaa
aaaaaaaabbaaaaaiccaabaaaacaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaa
aaaaaaaabbaaaaaiecaabaaaacaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaa
aaaaaaaaaaaaaaahhccabaaaafaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
doaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 208
Vector 176 [_MainTex_ST]
ConstBuffer "UnityLighting" 720
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityPerDraw" 2
"vs_4_0_level_9_1
root12:aaadaaaa
eefiecedpcnmiafbcjbpddmlbephkciodpkojclcabaaaaaafaakaaaaaeaaaaaa
daaaaaaadiadaaaakaaiaaaajiajaaaaebgpgodjaaadaaaaaaadaaaaaaacpopp
kiacaaaafiaaaaaaaeaaceaaaaaafeaaaaaafeaaaaaaceaaabaafeaaaaaaalaa
abaaabaaaaaaaaaaabaacgaaahaaacaaaaaaaaaaacaaaaaaaeaaajaaaaaaaaaa
acaaamaaahaaanaaaaaaaaaaaaaaaaaaaaacpoppfbaaaaafbeaaapkaaaaaiadp
aaaaaaaaaaaaaaaaaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaacia
acaaapjabpaaaaacafaaadiaadaaapjaaeaaaaaeaaaaadoaadaaoejaabaaoeka
abaaookaafaaaaadaaaaahiaaaaaffjaaoaaoekaaeaaaaaeaaaaahiaanaaoeka
aaaaaajaaaaaoeiaaeaaaaaeaaaaahiaapaaoekaaaaakkjaaaaaoeiaaeaaaaae
acaaahoabaaaoekaaaaappjaaaaaoeiaafaaaaadaaaaabiaacaaaajabbaaaaka
afaaaaadaaaaaciaacaaaajabcaaaakaafaaaaadaaaaaeiaacaaaajabdaaaaka
afaaaaadabaaabiaacaaffjabbaaffkaafaaaaadabaaaciaacaaffjabcaaffka
afaaaaadabaaaeiaacaaffjabdaaffkaacaaaaadaaaaahiaaaaaoeiaabaaoeia
afaaaaadabaaabiaacaakkjabbaakkkaafaaaaadabaaaciaacaakkjabcaakkka
afaaaaadabaaaeiaacaakkjabdaakkkaacaaaaadaaaaahiaaaaaoeiaabaaoeia
ceaaaaacabaaahiaaaaaoeiaafaaaaadaaaaabiaabaaffiaabaaffiaaeaaaaae
aaaaabiaabaaaaiaabaaaaiaaaaaaaibafaaaaadacaaapiaabaacjiaabaakeia
ajaaaaadadaaabiaafaaoekaacaaoeiaajaaaaadadaaaciaagaaoekaacaaoeia
ajaaaaadadaaaeiaahaaoekaacaaoeiaaeaaaaaeaaaaahiaaiaaoekaaaaaaaia
adaaoeiaabaaaaacabaaaiiabeaaaakaajaaaaadacaaabiaacaaoekaabaaoeia
ajaaaaadacaaaciaadaaoekaabaaoeiaajaaaaadacaaaeiaaeaaoekaabaaoeia
abaaaaacabaaahoaabaaoeiaacaaaaadaeaaahoaaaaaoeiaacaaoeiaafaaaaad
aaaaapiaaaaaffjaakaaoekaaeaaaaaeaaaaapiaajaaoekaaaaaaajaaaaaoeia
aeaaaaaeaaaaapiaalaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaamaaoeka
aaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaac
aaaaammaaaaaoeiaabaaaaacadaaapoabeaaffkappppaaaafdeieefcgaafaaaa
eaaaabaafiabaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaaeegiocaaa
abaaaaaacnaaaaaafjaaaaaeegiocaaaacaaaaaabdaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaad
hccabaaaafaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaalaaaaaaogikcaaaaaaaaaaaalaaaaaadiaaaaaibcaabaaaaaaaaaaa
akbabaaaacaaaaaaakiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaaaaaaaaaa
akbabaaaacaaaaaaakiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaaaaaaaaaa
akbabaaaacaaaaaaakiacaaaacaaaaaabcaaaaaadiaaaaaibcaabaaaabaaaaaa
bkbabaaaacaaaaaabkiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaa
bkbabaaaacaaaaaabkiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaa
bkbabaaaacaaaaaabkiacaaaacaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaa
acaaaaaackiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaa
acaaaaaackiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaa
acaaaaaackiacaaaacaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaafhccabaaa
acaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaak
hccabaaaadaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
abaaaaaadgaaaaaipccabaaaaeaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaadiaaaaahbcaabaaaabaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaa
dcaaaaakbcaabaaaabaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaia
ebaaaaaaabaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaa
aaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaabaaaaaacjaaaaaaegaobaaa
acaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaabaaaaaackaaaaaaegaobaaa
acaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaabaaaaaaclaaaaaaegaobaaa
acaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaabaaaaaacmaaaaaaagaabaaa
abaaaaaaegacbaaaadaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadp
bbaaaaaibcaabaaaacaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaaaaaaaaaa
bbaaaaaiccaabaaaacaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaaaaaaaaaa
bbaaaaaiecaabaaaacaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaaaaaaaaaa
aaaaaaahhccabaaaafaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadoaaaaab
ejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
njaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaoaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaaabaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaa
oaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaaapaaaaaaojaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofe
aaeoepfcenebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaa
agaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
keaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaa
aaaaaaaaadaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaa
adaaaaaaahaiaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaa
keaaaaaaafaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklkl"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "UNITY_HDR_ON" }
"!!GLSL#version 120

#ifdef VERTEX
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHC;

uniform mat4 _Object2World;
uniform mat4 _World2Object;
uniform vec4 _MainTex_ST;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD5;
void main ()
{
  vec4 tmpvar_1;
  vec4 v_2;
  v_2.x = _World2Object[0].x;
  v_2.y = _World2Object[1].x;
  v_2.z = _World2Object[2].x;
  v_2.w = _World2Object[3].x;
  vec4 v_3;
  v_3.x = _World2Object[0].y;
  v_3.y = _World2Object[1].y;
  v_3.z = _World2Object[2].y;
  v_3.w = _World2Object[3].y;
  vec4 v_4;
  v_4.x = _World2Object[0].z;
  v_4.y = _World2Object[1].z;
  v_4.z = _World2Object[2].z;
  v_4.w = _World2Object[3].z;
  vec3 tmpvar_5;
  tmpvar_5 = normalize(((
    (v_2.xyz * gl_Normal.x)
   + 
    (v_3.xyz * gl_Normal.y)
  ) + (v_4.xyz * gl_Normal.z)));
  tmpvar_1.zw = vec2(0.0, 0.0);
  tmpvar_1.xy = vec2(0.0, 0.0);
  vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  vec3 x2_7;
  vec3 x1_8;
  x1_8.x = dot (unity_SHAr, tmpvar_6);
  x1_8.y = dot (unity_SHAg, tmpvar_6);
  x1_8.z = dot (unity_SHAb, tmpvar_6);
  vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_5.xyzz * tmpvar_5.yzzx);
  x2_7.x = dot (unity_SHBr, tmpvar_9);
  x2_7.y = dot (unity_SHBg, tmpvar_9);
  x2_7.z = dot (unity_SHBb, tmpvar_9);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_5;
  xlv_TEXCOORD2 = (_Object2World * gl_Vertex).xyz;
  xlv_TEXCOORD4 = tmpvar_1;
  xlv_TEXCOORD5 = ((x2_7 + (unity_SHC.xyz * 
    ((tmpvar_5.x * tmpvar_5.x) - (tmpvar_5.y * tmpvar_5.y))
  )) + x1_8);
}


#endif
#ifdef FRAGMENT
uniform vec4 _SpecColor;
uniform sampler2D _MainTex;
uniform vec4 _Color;
uniform float _Shininess;
varying vec2 xlv_TEXCOORD0;
varying vec3 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD5;
void main ()
{
  vec4 outDiffuse_1;
  vec3 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0).xyz * _Color.xyz);
  vec4 emission_3;
  vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_2;
  vec4 tmpvar_5;
  tmpvar_5.xyz = _SpecColor.xyz;
  tmpvar_5.w = _Shininess;
  vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = ((xlv_TEXCOORD1 * 0.5) + 0.5);
  emission_3.w = 1.0;
  emission_3.xyz = (tmpvar_2 * xlv_TEXCOORD5);
  outDiffuse_1.xyz = tmpvar_4.xyz;
  outDiffuse_1.w = 1.0;
  gl_FragData[0] = outDiffuse_1;
  gl_FragData[1] = tmpvar_5;
  gl_FragData[2] = tmpvar_6;
  gl_FragData[3] = emission_3;
}


#endif
"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "UNITY_HDR_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 4 [_Object2World] 3
Matrix 7 [_World2Object] 3
Matrix 0 [glstate_matrix_mvp]
Vector 17 [_MainTex_ST]
Vector 12 [unity_SHAb]
Vector 11 [unity_SHAg]
Vector 10 [unity_SHAr]
Vector 15 [unity_SHBb]
Vector 14 [unity_SHBg]
Vector 13 [unity_SHBr]
Vector 16 [unity_SHC]
"vs_2_0
def c18, 1, 0, 0, 0
dcl_position v0
dcl_normal v1
dcl_texcoord v2
dp4 oPos.x, c0, v0
dp4 oPos.y, c1, v0
dp4 oPos.z, c2, v0
dp4 oPos.w, c3, v0
mad oT0.xy, v2, c17, c17.zwzw
dp4 oT2.x, c4, v0
dp4 oT2.y, c5, v0
dp4 oT2.z, c6, v0
mul r0.xyz, v1.y, c8
mad r0.xyz, c7, v1.x, r0
mad r0.xyz, c9, v1.z, r0
nrm r1.xyz, r0
mul r0.x, r1.y, r1.y
mad r0.x, r1.x, r1.x, -r0.x
mul r2, r1.yzzx, r1.xyzz
dp4 r3.x, c13, r2
dp4 r3.y, c14, r2
dp4 r3.z, c15, r2
mad r0.xyz, c16, r0.x, r3
mov r1.w, c18.x
dp4 r2.x, c10, r1
dp4 r2.y, c11, r1
dp4 r2.z, c12, r1
mov oT1.xyz, r1
add oT5.xyz, r0, r2
mov oT4, c18.y

"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "UNITY_HDR_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 208
Vector 176 [_MainTex_ST]
ConstBuffer "UnityLighting" 720
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityPerDraw" 2
"vs_4_0
root12:aaadaaaa
eefiecedhcgciibgdacibploakicokpnlmcpkdehabaaaaaaeeahaaaaadaaaaaa
cmaaaaaaceabaaaanmabaaaaejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaanjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaoaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaaoaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apaaaaaaojaaaaaaaaaaaaaaaaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaapaaaaaakeaaaaaaafaaaaaaaaaaaaaaadaaaaaaafaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
gaafaaaaeaaaabaafiabaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaae
egiocaaaabaaaaaacnaaaaaafjaaaaaeegiocaaaacaaaaaabdaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaa
gfaaaaadhccabaaaafaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaaalaaaaaadiaaaaaibcaabaaa
aaaaaaaaakbabaaaacaaaaaaakiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaa
aaaaaaaaakbabaaaacaaaaaaakiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaa
aaaaaaaaakbabaaaacaaaaaaakiacaaaacaaaaaabcaaaaaadiaaaaaibcaabaaa
abaaaaaabkbabaaaacaaaaaabkiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaa
abaaaaaabkbabaaaacaaaaaabkiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaa
abaaaaaabkbabaaaacaaaaaabkiacaaaacaaaaaabcaaaaaaaaaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaa
ckbabaaaacaaaaaackiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaa
ckbabaaaacaaaaaackiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaa
ckbabaaaacaaaaaackiacaaaacaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaf
hccabaaaacaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaa
aaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
acaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhccabaaaadaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egacbaaaabaaaaaadgaaaaaipccabaaaaeaaaaaaaceaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaadiaaaaahbcaabaaaabaaaaaabkaabaaaaaaaaaaabkaabaaa
aaaaaaaadcaaaaakbcaabaaaabaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaa
akaabaiaebaaaaaaabaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaa
egakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaabaaaaaacjaaaaaa
egaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaabaaaaaackaaaaaa
egaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaabaaaaaaclaaaaaa
egaobaaaacaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaabaaaaaacmaaaaaa
agaabaaaabaaaaaaegacbaaaadaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaa
aaaaiadpbbaaaaaibcaabaaaacaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaa
aaaaaaaabbaaaaaiccaabaaaacaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaa
aaaaaaaabbaaaaaiecaabaaaacaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaa
aaaaaaaaaaaaaaahhccabaaaafaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaa
doaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "UNITY_HDR_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 208
Vector 176 [_MainTex_ST]
ConstBuffer "UnityLighting" 720
Vector 608 [unity_SHAr]
Vector 624 [unity_SHAg]
Vector 640 [unity_SHAb]
Vector 656 [unity_SHBr]
Vector 672 [unity_SHBg]
Vector 688 [unity_SHBb]
Vector 704 [unity_SHC]
ConstBuffer "UnityPerDraw" 352
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
Matrix 256 [_World2Object]
BindCB  "$Globals" 0
BindCB  "UnityLighting" 1
BindCB  "UnityPerDraw" 2
"vs_4_0_level_9_1
root12:aaadaaaa
eefiecedpcnmiafbcjbpddmlbephkciodpkojclcabaaaaaafaakaaaaaeaaaaaa
daaaaaaadiadaaaakaaiaaaajiajaaaaebgpgodjaaadaaaaaaadaaaaaaacpopp
kiacaaaafiaaaaaaaeaaceaaaaaafeaaaaaafeaaaaaaceaaabaafeaaaaaaalaa
abaaabaaaaaaaaaaabaacgaaahaaacaaaaaaaaaaacaaaaaaaeaaajaaaaaaaaaa
acaaamaaahaaanaaaaaaaaaaaaaaaaaaaaacpoppfbaaaaafbeaaapkaaaaaiadp
aaaaaaaaaaaaaaaaaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaacia
acaaapjabpaaaaacafaaadiaadaaapjaaeaaaaaeaaaaadoaadaaoejaabaaoeka
abaaookaafaaaaadaaaaahiaaaaaffjaaoaaoekaaeaaaaaeaaaaahiaanaaoeka
aaaaaajaaaaaoeiaaeaaaaaeaaaaahiaapaaoekaaaaakkjaaaaaoeiaaeaaaaae
acaaahoabaaaoekaaaaappjaaaaaoeiaafaaaaadaaaaabiaacaaaajabbaaaaka
afaaaaadaaaaaciaacaaaajabcaaaakaafaaaaadaaaaaeiaacaaaajabdaaaaka
afaaaaadabaaabiaacaaffjabbaaffkaafaaaaadabaaaciaacaaffjabcaaffka
afaaaaadabaaaeiaacaaffjabdaaffkaacaaaaadaaaaahiaaaaaoeiaabaaoeia
afaaaaadabaaabiaacaakkjabbaakkkaafaaaaadabaaaciaacaakkjabcaakkka
afaaaaadabaaaeiaacaakkjabdaakkkaacaaaaadaaaaahiaaaaaoeiaabaaoeia
ceaaaaacabaaahiaaaaaoeiaafaaaaadaaaaabiaabaaffiaabaaffiaaeaaaaae
aaaaabiaabaaaaiaabaaaaiaaaaaaaibafaaaaadacaaapiaabaacjiaabaakeia
ajaaaaadadaaabiaafaaoekaacaaoeiaajaaaaadadaaaciaagaaoekaacaaoeia
ajaaaaadadaaaeiaahaaoekaacaaoeiaaeaaaaaeaaaaahiaaiaaoekaaaaaaaia
adaaoeiaabaaaaacabaaaiiabeaaaakaajaaaaadacaaabiaacaaoekaabaaoeia
ajaaaaadacaaaciaadaaoekaabaaoeiaajaaaaadacaaaeiaaeaaoekaabaaoeia
abaaaaacabaaahoaabaaoeiaacaaaaadaeaaahoaaaaaoeiaacaaoeiaafaaaaad
aaaaapiaaaaaffjaakaaoekaaeaaaaaeaaaaapiaajaaoekaaaaaaajaaaaaoeia
aeaaaaaeaaaaapiaalaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaamaaoeka
aaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaac
aaaaammaaaaaoeiaabaaaaacadaaapoabeaaffkappppaaaafdeieefcgaafaaaa
eaaaabaafiabaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaaeegiocaaa
abaaaaaacnaaaaaafjaaaaaeegiocaaaacaaaaaabdaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaa
acaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagfaaaaad
hccabaaaafaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaalaaaaaaogikcaaaaaaaaaaaalaaaaaadiaaaaaibcaabaaaaaaaaaaa
akbabaaaacaaaaaaakiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaaaaaaaaaa
akbabaaaacaaaaaaakiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaaaaaaaaaa
akbabaaaacaaaaaaakiacaaaacaaaaaabcaaaaaadiaaaaaibcaabaaaabaaaaaa
bkbabaaaacaaaaaabkiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaa
bkbabaaaacaaaaaabkiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaa
bkbabaaaacaaaaaabkiacaaaacaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaibcaabaaaabaaaaaackbabaaa
acaaaaaackiacaaaacaaaaaabaaaaaaadiaaaaaiccaabaaaabaaaaaackbabaaa
acaaaaaackiacaaaacaaaaaabbaaaaaadiaaaaaiecaabaaaabaaaaaackbabaaa
acaaaaaackiacaaaacaaaaaabcaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaafhccabaaa
acaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaak
hccabaaaadaaaaaaegiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
abaaaaaadgaaaaaipccabaaaaeaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaadiaaaaahbcaabaaaabaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaa
dcaaaaakbcaabaaaabaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaia
ebaaaaaaabaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaa
aaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaabaaaaaacjaaaaaaegaobaaa
acaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaabaaaaaackaaaaaaegaobaaa
acaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaabaaaaaaclaaaaaaegaobaaa
acaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaabaaaaaacmaaaaaaagaabaaa
abaaaaaaegacbaaaadaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadp
bbaaaaaibcaabaaaacaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaaaaaaaaaa
bbaaaaaiccaabaaaacaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaaaaaaaaaa
bbaaaaaiecaabaaaacaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaaaaaaaaaa
aaaaaaahhccabaaaafaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadoaaaaab
ejfdeheopaaaaaaaaiaaaaaaaiaaaaaamiaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapapaaaanbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
njaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaaoaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaadaaaaaaapadaaaaoaaaaaaaabaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaapaaaaaaoaaaaaaaacaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaa
oaaaaaaaadaaaaaaaaaaaaaaadaaaaaaagaaaaaaapaaaaaaojaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaahaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofe
aaeoepfcenebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaa
agaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
keaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaa
aaaaaaaaadaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaa
adaaaaaaahaiaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaa
keaaaaaaafaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklkl"
}
}
Program "fp" {
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 1 [_Color]
Float 2 [_Shininess]
Vector 0 [_SpecColor]
SetTexture 0 [_MainTex] 2D 0
"ps_2_0
def c3, 1, 0.5, 0, 0
dcl t0.xy
dcl_pp t1.xyz
dcl_pp t5.xyz
dcl_2d s0
texld_pp r0, t0, s0
mov_pp r1.w, c3.x
mul_pp r1.xyz, r0, c1
mov_pp oC0, r1
mul_pp r0.xyz, r1, t5
mov_pp r1.xyz, c0
mov_pp r1.w, c2.x
mov_pp oC1, r1
mad_pp r1.xyz, t1, c3.y, c3.y
mov_pp r1.w, c3.x
mov_pp oC2, r1
exp_pp r1.x, -r0.x
exp_pp r1.y, -r0.y
exp_pp r1.z, -r0.z
mov_pp r1.w, c3.x
mov_pp oC3, r1

"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
SetTexture 0 [_MainTex] 2D 0
ConstBuffer "$Globals" 208
Vector 112 [_SpecColor]
Vector 144 [_Color]
Float 160 [_Shininess]
BindCB  "$Globals" 0
"ps_4_0
root12:abababaa
eefiecedgldjkaeiieifojgcngkfbobafgbaheebabaaaaaadaadaaaaadaaaaaa
cmaaaaaaoeaaaaaagaabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaaafaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheoheaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaagiaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
apaaaaaagiaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaagiaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcmiabaaaaeaaaaaaahcaaaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaa
fkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaa
acaaaaaagfaaaaadpccabaaaadaaaaaagiaaaaacabaaaaaaefaaaaajpcaabaaa
aaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaajaaaaaadgaaaaaf
hccabaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegbcbaaaafaaaaaabjaaaaaghccabaaaadaaaaaaegacbaiaebaaaaaa
aaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdgaaaaaghccabaaa
abaaaaaaegiccaaaaaaaaaaaahaaaaaadgaaaaagiccabaaaabaaaaaaakiacaaa
aaaaaaaaakaaaaaadcaaaaaphccabaaaacaaaaaaegbcbaaaacaaaaaaaceaaaaa
aaaaaadpaaaaaadpaaaaaadpaaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadp
aaaaaaaadgaaaaaficcabaaaacaaaaaaabeaaaaaaaaaiadpdgaaaaaficcabaaa
adaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
SetTexture 0 [_MainTex] 2D 0
ConstBuffer "$Globals" 208
Vector 112 [_SpecColor]
Vector 144 [_Color]
Float 160 [_Shininess]
BindCB  "$Globals" 0
"ps_4_0_level_9_1
root12:abababaa
eefiecedpdcianbgmngifamoebkfkplobhgccffdabaaaaaakaaeaaaaaeaaaaaa
daaaaaaajmabaaaagmadaaaaceaeaaaaebgpgodjgeabaaaageabaaaaaaacpppp
ceabaaaaeaaaaaaaacaaciaaaaaaeaaaaaaaeaaaabaaceaaaaaaeaaaaaaaaaaa
aaaaahaaabaaaaaaaaaaaaaaaaaaajaaacaaabaaaaaaaaaaaaacppppfbaaaaaf
adaaapkaaaaaiadpaaaaaadpaaaaaaaaaaaaaaaabpaaaaacaaaaaaiaaaaaadla
bpaaaaacaaaaaaiaabaachlabpaaaaacaaaaaaiaaeaachlabpaaaaacaaaaaaja
aaaiapkaecaaaaadaaaacpiaaaaaoelaaaaioekaabaaaaacabaaciiaadaaaaka
afaaaaadabaachiaaaaaoeiaabaaoekaabaaaaacaaaicpiaabaaoeiaafaaaaad
aaaachiaabaaoeiaaeaaoelaabaaaaacabaachiaaaaaoekaabaaaaacabaaciia
acaaaakaabaaaaacabaicpiaabaaoeiaaeaaaaaeabaachiaabaaoelaadaaffka
adaaffkaabaaaaacabaaciiaadaaaakaabaaaaacacaicpiaabaaoeiaaoaaaaac
abaacbiaaaaaaaibaoaaaaacabaacciaaaaaffibaoaaaaacabaaceiaaaaakkib
abaaaaacabaaciiaadaaaakaabaaaaacadaicpiaabaaoeiappppaaaafdeieefc
miabaaaaeaaaaaaahcaaaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaad
aagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaafaaaaaagfaaaaad
pccabaaaaaaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
gfaaaaadpccabaaaadaaaaaagiaaaaacabaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaajaaaaaadgaaaaafhccabaaa
aaaaaaaaegacbaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egbcbaaaafaaaaaabjaaaaaghccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaa
dgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdgaaaaaghccabaaaabaaaaaa
egiccaaaaaaaaaaaahaaaaaadgaaaaagiccabaaaabaaaaaaakiacaaaaaaaaaaa
akaaaaaadcaaaaaphccabaaaacaaaaaaegbcbaaaacaaaaaaaceaaaaaaaaaaadp
aaaaaadpaaaaaadpaaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaa
dgaaaaaficcabaaaacaaaaaaabeaaaaaaaaaiadpdgaaaaaficcabaaaadaaaaaa
abeaaaaaaaaaiadpdoaaaaabejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaaafaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheoheaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaagiaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
apaaaaaagiaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaagiaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
"
}
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "UNITY_HDR_ON" }
"!!GLSL"
}
SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "UNITY_HDR_ON" }
Vector 1 [_Color]
Float 2 [_Shininess]
Vector 0 [_SpecColor]
SetTexture 0 [_MainTex] 2D 0
"ps_2_0
def c3, 1, 0.5, 0, 0
dcl t0.xy
dcl_pp t1.xyz
dcl_pp t5.xyz
dcl_2d s0
texld_pp r0, t0, s0
mov_pp r1.w, c3.x
mul_pp r1.xyz, r0, c1
mov_pp oC0, r1
mul_pp r0.xyz, r1, t5
mov_pp r1.xyz, c0
mov_pp r1.w, c2.x
mov_pp oC1, r1
mad_pp r1.xyz, t1, c3.y, c3.y
mov_pp r1.w, c3.x
mov_pp oC2, r1
mov_pp r0.w, c3.x
mov_pp oC3, r0

"
}
SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "UNITY_HDR_ON" }
SetTexture 0 [_MainTex] 2D 0
ConstBuffer "$Globals" 208
Vector 112 [_SpecColor]
Vector 144 [_Color]
Float 160 [_Shininess]
BindCB  "$Globals" 0
"ps_4_0
root12:abababaa
eefiecednmbemgbaidneadcgbbfmdanillelmngjabaaaaaabiadaaaaadaaaaaa
cmaaaaaaoeaaaaaagaabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaaaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaaafaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheoheaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaagiaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
apaaaaaagiaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaagiaaaaaa
adaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefclaabaaaaeaaaaaaagmaaaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaa
fkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaa
acaaaaaagfaaaaadpccabaaaadaaaaaagiaaaaacabaaaaaaefaaaaajpcaabaaa
aaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaajaaaaaadgaaaaaf
hccabaaaaaaaaaaaegacbaaaaaaaaaaadiaaaaahhccabaaaadaaaaaaegacbaaa
aaaaaaaaegbcbaaaafaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadp
dgaaaaaghccabaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaadgaaaaagiccabaaa
abaaaaaaakiacaaaaaaaaaaaakaaaaaadcaaaaaphccabaaaacaaaaaaegbcbaaa
acaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaaaceaaaaaaaaaaadp
aaaaaadpaaaaaadpaaaaaaaadgaaaaaficcabaaaacaaaaaaabeaaaaaaaaaiadp
dgaaaaaficcabaaaadaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}
SubProgram "d3d11_9x " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "DYNAMICLIGHTMAP_OFF" "UNITY_HDR_ON" }
SetTexture 0 [_MainTex] 2D 0
ConstBuffer "$Globals" 208
Vector 112 [_SpecColor]
Vector 144 [_Color]
Float 160 [_Shininess]
BindCB  "$Globals" 0
"ps_4_0_level_9_1
root12:abababaa
eefiecedodiigafapmfahjoodknjcdhckfefkeldabaaaaaageaeaaaaaeaaaaaa
daaaaaaahiabaaaadaadaaaaoiadaaaaebgpgodjeaabaaaaeaabaaaaaaacpppp
aaabaaaaeaaaaaaaacaaciaaaaaaeaaaaaaaeaaaabaaceaaaaaaeaaaaaaaaaaa
aaaaahaaabaaaaaaaaaaaaaaaaaaajaaacaaabaaaaaaaaaaaaacppppfbaaaaaf
adaaapkaaaaaiadpaaaaaadpaaaaaaaaaaaaaaaabpaaaaacaaaaaaiaaaaaadla
bpaaaaacaaaaaaiaabaachlabpaaaaacaaaaaaiaaeaachlabpaaaaacaaaaaaja
aaaiapkaecaaaaadaaaacpiaaaaaoelaaaaioekaabaaaaacabaaciiaadaaaaka
afaaaaadabaachiaaaaaoeiaabaaoekaabaaaaacaaaicpiaabaaoeiaafaaaaad
aaaachiaabaaoeiaaeaaoelaabaaaaacabaachiaaaaaoekaabaaaaacabaaciia
acaaaakaabaaaaacabaicpiaabaaoeiaaeaaaaaeabaachiaabaaoelaadaaffka
adaaffkaabaaaaacabaaciiaadaaaakaabaaaaacacaicpiaabaaoeiaabaaaaac
aaaaciiaadaaaakaabaaaaacadaicpiaaaaaoeiappppaaaafdeieefclaabaaaa
eaaaaaaagmaaaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaa
aaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaafaaaaaagfaaaaadpccabaaa
aaaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaad
pccabaaaadaaaaaagiaaaaacabaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegiccaaaaaaaaaaaajaaaaaadgaaaaafhccabaaaaaaaaaaa
egacbaaaaaaaaaaadiaaaaahhccabaaaadaaaaaaegacbaaaaaaaaaaaegbcbaaa
afaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdgaaaaaghccabaaa
abaaaaaaegiccaaaaaaaaaaaahaaaaaadgaaaaagiccabaaaabaaaaaaakiacaaa
aaaaaaaaakaaaaaadcaaaaaphccabaaaacaaaaaaegbcbaaaacaaaaaaaceaaaaa
aaaaaadpaaaaaadpaaaaaadpaaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadp
aaaaaaaadgaaaaaficcabaaaacaaaaaaabeaaaaaaaaaiadpdgaaaaaficcabaaa
adaaaaaaabeaaaaaaaaaiadpdoaaaaabejfdeheolaaaaaaaagaaaaaaaiaaaaaa
jiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaa
acaaaaaaahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaaaaaa
keaaaaaaaeaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaakeaaaaaaafaaaaaa
aaaaaaaaadaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklepfdeheoheaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapaaaaaagiaaaaaaabaaaaaaaaaaaaaaadaaaaaa
abaaaaaaapaaaaaagiaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaa
giaaaaaaadaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaafdfgfpfegbhcghgf
heaaklkl"
}
}
 }
}
Fallback "Legacy Shaders/VertexLit"
}