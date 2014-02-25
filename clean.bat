@set temp_path=%path%
@set path=c:\mingw32\bin;%path%
mingw32-make -f Make_ming.mak clean
@set path=%temp_path%
