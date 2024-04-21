build-all: build/v-snake.exe build/odin-snake.exe

build/v-snake.exe: v/*.v
	v -prod -cc gcc -o build/v-snake.exe v

build/odin-snake.exe: odin/*.odin
	odin build odin -o:speed -out:build/odin-snake.exe -subsystem:windows

v-dev:
	v -cc gcc run v

odin-dev:
	odin run odin -debug -out:build/debug/odin-snake.exe

.PHONY: build-all v-dev odin-dev