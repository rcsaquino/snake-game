package main

import r "vendor:raylib"

Food :: struct {
	x: i32,
	y: i32,
}

new_food :: proc(g: ^Game) {
	g.food = Food {
		x = r.GetRandomValue(
			FIELD_MARGIN / BLOCK_SIZE,
			(WIN_WIDTH - BLOCK_SIZE * 2) / BLOCK_SIZE,
		) * BLOCK_SIZE,
		y = r.GetRandomValue(
			FIELD_MARGIN / BLOCK_SIZE,
			(WIN_HEIGHT - BLOCK_SIZE * 2) / BLOCK_SIZE,
		) * BLOCK_SIZE,
	}
	if invalid_food_pos(g^) {
		new_food(g)
	}
}

update_food :: proc(g: ^Game) {
	using g

	if snake.head.x == food.x && snake.head.y == food.y {
		score += 1
		new_food(g)
		append(
			&g.snake.body,
			SnakeSegment {
				x = g.snake.body[len(g.snake.body) - 1].x,
				y = g.snake.body[len(g.snake.body) - 1].y,
			},
		)
	}
}

draw_food :: proc(f: Food) {
	r.DrawRectangle(f.x, f.y, BLOCK_SIZE, BLOCK_SIZE, r.ORANGE)
}

invalid_food_pos :: proc(g: Game) -> bool {
	using g
	if food.x == snake.head.x && food.y == snake.head.y {
		return true
	}
	for segment in g.snake.body {
		if segment.x == food.x && segment.y == food.y {
			return true
		}
	}
	return false
}
