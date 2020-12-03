//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Projector/Additive" {
Properties {
_ShadowTex ("Cookie", 2D) = "" { }
_FalloffTex ("FallOff", 2D) = "" { }
}
SubShader {
 Pass {
  ZWrite Off
  GpuProgramID 63816
Program "vp" {
SubProgram "d3d9 " {
"// shader disassembly not supported on DXBC"
}
SubProgram "d3d11 " {
"// shader disassembly not supported on DXBC"
}
}
Program "fp" {
SubProgram "d3d9 " {
"// shader disassembly not supported on DXBC"
}
SubProgram "d3d11 " {
"// shader disassembly not supported on DXBC"
}
}
}
}
}