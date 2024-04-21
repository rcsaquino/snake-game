build:
	odin build src -o:speed -out:build/release/snake.exe -subsystem:windows
dev:
	odin run src -debug -out:build/debug/snake.exe

.PHONY: build dev