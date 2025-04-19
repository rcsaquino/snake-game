@echo off
del /q /s build

echo Building V ...
v -prod -cc gcc -o build/v-snake.exe v

echo Building Odin ...
odin build odin -o:speed -out:build/odin-snake.exe -subsystem:windows

echo Done!