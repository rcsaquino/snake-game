package main

import "core:fmt"
import "core:math/rand"
import "core:mem"
import r "vendor:raylib"

when ODIN_DEBUG {
	tracker: mem.Tracking_Allocator
	temp_tracker: mem.Tracking_Allocator

	display_leaks :: proc() {
		fmt.println("\n================= MEMORY TRACKER =================")
		leaks := 0
		for _, entry in tracker.allocation_map {
			fmt.printfln("LEAK: %v BYTES @ %v", entry.size, entry.location)
			leaks += entry.size
		}
		for _, entry in temp_tracker.allocation_map {
			fmt.printfln("TEMP LEAK: %v BYTES @ %v", entry.size, entry.location)
			leaks += entry.size
		}
		bad_frees := 0
		for entry in tracker.bad_free_array {
			fmt.printfln("BAD FREE: %v @ %v", entry.memory, entry.location)
			bad_frees += 1
		}
		for entry in temp_tracker.bad_free_array {
			fmt.printfln("TEMP BAD FREE: %v @ %v", entry.memory, entry.location)
			bad_frees += 1
		}
		fmt.println("==================================================")
		fmt.printfln("TOTAL LEAKS: %.2f KB | TOTAL BAD FREES: %v", f64(leaks) / 1024, bad_frees)
		fmt.println("==================================================\n")
	}
}

WIN_WIDTH :: 800
WIN_HEIGHT :: 600
FIELD_MARGIN :: 20
FIELD_WIDTH :: WIN_WIDTH - FIELD_MARGIN * 2
FIELD_HEIGHT :: WIN_HEIGHT - FIELD_MARGIN * 2
BLOCK_SIZE :: 20

Game :: struct {
	snake:      Snake,
	food:       Food,
	score:      int,
	high_score: int,
}



main :: proc() {
	when ODIN_DEBUG {
		mem.tracking_allocator_init(&temp_tracker, context.temp_allocator)
		context.temp_allocator = mem.tracking_allocator(&temp_tracker)
		mem.tracking_allocator_init(&tracker, context.allocator)
		context.allocator = mem.tracking_allocator(&tracker)
		defer display_leaks()
	}

	game := Game{}
	defer delete(game.snake.body)

	r.SetRandomSeed(rand.uint32())

	new_snake(&game)
	new_food(&game)

	r.InitWindow(WIN_WIDTH, WIN_HEIGHT, "Snake Game")
	r.SetTargetFPS(60)

	frame: i32
	for !r.WindowShouldClose() {
		handle_key_press(&game)
		frame += 1
		if r.GetFPS() / game.snake.speed <= frame {
			update(&game)
			frame = 0
		}
		draw(game)
		free_all(context.temp_allocator)
	}
}

draw :: proc(g: Game) {
	r.BeginDrawing()
	r.ClearBackground(r.WHITE)
	r.DrawRectangleLines(FIELD_MARGIN, FIELD_MARGIN, FIELD_WIDTH, FIELD_HEIGHT, r.BLACK)

	info := fmt.ctprintf("Score: %d | Highscore: %d", g.score, g.high_score)
	r.DrawText(info, 20, 1, 20, r.BLACK)

	draw_snake(g.snake)
	draw_food(g.food)

	r.EndDrawing()
}

update :: proc(g: ^Game) {
	update_snake(&g.snake)
	if check_game_over(g) {
		fmt.println("> Game Over! Your score is:", g.score)
		if g.score > g.high_score {
			g.high_score = g.score
			fmt.println("> New high score!")
		}
		fmt.println("> Restarting game...")
		new_snake(g)
		fmt.println("==============================")
		fmt.println("> Game started.")
	}

	update_food(g)
}

check_game_over :: proc(g: ^Game) -> bool {
	if has_collision(&g.snake) {
		return true
	}
	return false
}
