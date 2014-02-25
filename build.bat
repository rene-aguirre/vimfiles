@set temp_path=%path%
@set path=c:\mingw\bin;%path%
mingw32-make -f Make_ming.mak GUI=yes PYTHON=c:\python27 DYNAMIC_PYTHON=yes PYTHON_VER=27 ARABIC=no FARSI=no PYTHON3=c:\python33 PYTHON3_VER=33 DYNAMIC_PYTHON3=yes
rem FEATURES=HUGE
@set path=%temp_path%
rem copy xxd\xxd.exe ..\runtime /y
copy xxd\xxd.exe .. /y
copy gvim.exe .. /y
copy vimrun.exe .. /y
