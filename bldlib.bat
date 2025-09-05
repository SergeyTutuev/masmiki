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
masm src\algo\ADDBI.asm build\obj\ADDBI.obj
masm src\algo\SUBBI.asm build\obj\SUBBI.obj
masm src\algo\MultBI.asm build\obj\MultBI.obj
masm src\algo\SHLBI.asm build\obj\SHLBI.obj
masm src\algo\ABSBI.asm build\obj\ABSBI.obj
masm src\algo\DIVBI.asm build\obj\DIVBI.obj
masm src\algo\MODBI.asm build\obj\MODBI.obj
masm src\algo\STRBI.asm build\obj\STRBI.obj
masm src\algo\INPBI.asm build\obj\INPBI.obj
masm src\algo\OUTPUT.asm build\obj\OUTPUT.obj
masm src\algo\POWBI.asm build\obj\POWBI.obj
masm src\algo\GCDBI.asm build\obj\GCDBI.obj

::Compile lib file 
IF EXIST build\bin\BigInt.lib DEL build\bin\BigInt.lib
lib build\bin\BigInt.lib @objslib.txt, build\bin\BI.lst;
copy src\BigInt.inc build\bin\
