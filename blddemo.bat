::Create build directory if doesn't exist
IF NOT EXIST build MD build 

::Create build\obj directory if doesn't exist
IF NOT EXIST build\obj MD build\obj 

::Create build\bin directory if doesn't exist
IF NOT EXIST build\bin MD build\bin 

:: Build library demo
masm examples\demo.asm build\obj\demo.obj
link build\obj\demo.obj, build\bin\demo.exe, nul.map; nul.def
