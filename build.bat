::Create build directory if doesn't exist
IF NOT EXIST build MD build 

::Create build\obj directory if doesn't exist
IF NOT EXIST build\obj MD build\obj 

::Create build\bin directory if doesn't exist
IF NOT EXIST build\bin MD build\bin 

::Compile main files
masm src\BigInt.asm build\obj\BigInt.obj
masm src\algo\SIGN.asm build\obj\SIGN.obj
masm src\algo\CMPBI.asm build\obj\CMPBI.obj
masm src\algo\CMPBIsz.asm build\obj\CMPBIsz.obj
masm src\algo\NegBI.asm build\obj\Neg.obj
masm src\algo\SHRBI.asm build\obj\SHRBI.obj

::Compile test files
masm test\tMain.asm build\obj\tMain.obj
masm test\tSample.asm build\obj\tSample.obj
masm test\tSign.asm build\obj\tSign.obj
masm test\tCMP.asm build\obj\tCMP.obj
masm test\tCMPSize.asm build\obj\tCMPSize.obj
masm test\tNeg.asm build\obj\tNeg.obj
masm test\tSHR.asm build\obj\tSHR.obj

::Compile lib file 
IF EXIST build\bin\BigInt.lib DEL build\bin\BigInt.lib
lib build\bin\BigInt.lib @objslib.txt, build\bin\BI.lst;

::Link obj+lib files
link @objslink.txt, build\bin\app.exe, nul.map, build\bin\BigInt; nul.def