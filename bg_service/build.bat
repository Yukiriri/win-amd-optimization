mkdir bin
mkdir obj


windres -i res\main.rc -o obj\res.o
g++ -std=c++23 -O3 -o bin\main.d.exe src\main.cpp obj\res.o
g++ -std=c++23 -O3 -static -o bin\main.s.exe src\main.cpp obj\res.o
pause
