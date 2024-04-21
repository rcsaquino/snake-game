package main

import r "vendor:raylib"

handle_key_press :: proc(g: ^Game) {
	if g.snake.has_move_queue {
		return
	}
	switch {
	case r.IsKeyPressed(r.KeyboardKey.UP) && g.snake.dir != .Down:
		g.snake.dir = .Up
		g.snake.has_move_queue = true
	case r.IsKeyPressed(r.KeyboardKey.DOWN) && g.snake.dir != .Up:
		g.snake.dir = .Down
		g.snake.has_move_queue = true
	case r.IsKeyPressed(r.KeyboardKey.LEFT) && g.snake.dir != .Right:
		g.snake.dir = .Left
		g.snake.has_move_queue = true
	case r.IsKeyPressed(r.KeyboardKey.RIGHT) && g.snake.dir != .Left:
		g.snake.dir = .Right
		g.snake.has_move_queue = true
	}

}
