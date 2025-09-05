::Create build directory if doesn't exist
IF NOT EXIST build MD build 

::Create build\obj directory if doesn't exist
IF NOT EXIST build\obj MD build\obj 

::Create build\bin directory if doesn't exist
IF NOT EXIST build\bin MD build\bin 

::Compile test files
masm test\tMain.asm build\obj\tMain.obj
masm test\tSample.asm build\obj\tSample.obj
masm test\tSign.asm build\obj\tSign.obj
masm test\tCMP.asm build\obj\tCMP.obj
masm test\tCMPSize.asm build\obj\tCMPSize.obj
masm test\tNeg.asm build\obj\tNeg.obj
masm test\tSHR.asm build\obj\tSHR.obj
masm test\tAdd.asm build\obj\tAdd.obj
masm test\tSub.asm build\obj\tSub.obj
masm test\tMul.asm build\obj\tMul.obj
masm test\tSHL.asm build\obj\tSHL.obj
masm test\tAbs.asm build\obj\tAbs.obj
masm test\tDIV.asm build\obj\tDIV.obj
masm test\tMOD.asm build\obj\tMOD.obj
masm test\tInp.asm build\obj\tInp.obj
masm test\tPOW.asm build\obj\tPOW.obj
masm test\tGCD.asm build\obj\tGCD.obj

::Link obj+lib files
link @objslink.txt, build\bin\tests.exe, nul.map, build\bin\BigInt; nul.def
