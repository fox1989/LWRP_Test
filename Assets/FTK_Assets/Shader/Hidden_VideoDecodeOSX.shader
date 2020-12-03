//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/VideoDecodeOSX" {
Properties {
}
SubShader {
 Pass {
  Name "FLIP_RGBARECT_TO_RGBA"
  ZTest Always
  ZWrite Off
  Cull Off
  GpuProgramID 26786
}
 Pass {
  Name "FLIP_RGBASPLITRECT_TO_RGBA"
  ZTest Always
  ZWrite Off
  Cull Off
  GpuProgramID 69998
}
}
}