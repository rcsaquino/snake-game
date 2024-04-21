import irishgreencitrus.raylibv as r

const win_width = 800
const win_height = 600
const block_size = 20
const field_margin = block_size * 1
const field_width = win_width - field_margin * 2
const field_height = win_height - field_margin * 2

struct Game {
mut:
	snake     Snake
	food      Food
	speed     f32 = 8.0
	score     u32
	highscore u32
}

fn (g Game) draw() {
	r.begin_drawing()
	r.clear_background(r.white)

	r.draw_text('Score: ${g.score} | Highscore: ${g.highscore}'.str, 20, 1, 20, r.black)

	r.draw_rectangle_lines(field_margin, field_margin, field_width, field_height, r.black)
	g.snake.draw()
	g.food.draw()

	r.end_drawing()
}

fn (mut g Game) update() {
	if g.is_gameover() {
		println('> Game Over! Your score is ${g.score}')
		if g.score > g.highscore {
			g.highscore = g.score
			println('> New highscore!')
		}
		println('> Restarting game...')
		println('==============================')
		println('> New game started.')
		g.snake.new()
		g.score = 0
	}

	// Snake
	time_now := r.get_time()
	if time_now - g.snake.last_update >= 1 / g.speed {
		g.snake.update()
		g.snake.last_update = time_now
	}

	if g.food.is_eaten(g.snake) {
		for !g.food.is_valid_pos(g.snake) {
			g.food.new()
		}
		g.snake.grow()
		g.score += 1
	}
}

fn (mut g Game) handle_controls() {
	if g.snake.has_move_queue {
		return
	}
	if r.is_key_pressed(r.key_up) && g.snake.vec[1] != 1 {
		g.snake.vec = [0, -1]
		g.snake.has_move_queue = true
	}
	if r.is_key_pressed(r.key_down) && g.snake.vec[1] != -1 {
		g.snake.vec = [0, 1]
		g.snake.has_move_queue = true
	}
	if r.is_key_pressed(r.key_left) && g.snake.vec[0] != 1 {
		g.snake.vec = [-1, 0]
		g.snake.has_move_queue = true
	}
	if r.is_key_pressed(r.key_right) && g.snake.vec[0] != 1 {
		g.snake.vec = [1, 0]
		g.snake.has_move_queue = true
	}
}

fn (g Game) is_gameover() bool {
	return g.snake.dead
}

fn main() {
	r.init_window(win_width, win_height, 'Snake Game'.str)

	// r.set_random_seed(0)
	mut g := Game{}
	g.snake.new()
	g.food.new()

	for !r.window_should_close() {
		g.handle_controls()
		g.update()
		g.draw()
	}
	r.close_window()
}
