package main

import r "vendor:raylib"

Snake :: struct {
	head:           SnakeSegment,
	body:           [dynamic]SnakeSegment,
	dir:            Direction,
	speed:          i32,
	has_move_queue: bool,
}

SnakeSegment :: struct {
	x: i32,
	y: i32,
}

Direction :: enum {
	Up,
	Down,
	Left,
	Right,
}

new_snake :: proc(g: ^Game) {
	using g
	snake.head = SnakeSegment {
		x = FIELD_MARGIN * 8,
		y = FIELD_MARGIN * 5,
	}
	clear(&snake.body)
	append(
		&snake.body,
		SnakeSegment{x = FIELD_MARGIN * 8 - BLOCK_SIZE, y = FIELD_MARGIN * 5},
		SnakeSegment{x = FIELD_MARGIN * 8 - BLOCK_SIZE * 2, y = FIELD_MARGIN * 5},
	)
	snake.dir = .Right
	snake.speed = 8
}

draw_snake :: proc(s: Snake) {
	r.DrawRectangle(s.head.x, s.head.y, BLOCK_SIZE, BLOCK_SIZE, r.BLACK)
	for segment in s.body {
		r.DrawRectangle(segment.x, segment.y, BLOCK_SIZE, BLOCK_SIZE, r.BLACK)
	}
}

update_snake :: proc(s: ^Snake) {
	#reverse for &segment, i in s.body {
		if i == 0 {
			segment.x = s.head.x
			segment.y = s.head.y
			break
		}
		segment.x = s.body[i - 1].x
		segment.y = s.body[i - 1].y
	}
	s.head.x += get_velocity(s.dir)[0]
	s.head.y += get_velocity(s.dir)[1]
	s.has_move_queue = false
}

get_velocity :: proc(dir: Direction) -> [2]i32 {
	switch dir {
	case .Up:
		return {0, -BLOCK_SIZE}
	case .Down:
		return {0, BLOCK_SIZE}
	case .Left:
		return {-BLOCK_SIZE, 0}
	case .Right:
		return {BLOCK_SIZE, 0}
	}
	return {0, 0}
}

has_collision :: proc(s: ^Snake) -> bool {
	using s

	// Wall collision
	if head.y < FIELD_MARGIN {
		return true
	}
	if head.y > WIN_HEIGHT - FIELD_MARGIN - BLOCK_SIZE {
		return true
	}
	if head.x > WIN_WIDTH - FIELD_MARGIN - BLOCK_SIZE {
		return true
	}
	if head.x < FIELD_MARGIN {
		return true
	}

	// Self collision
	for segment in s.body {
		if segment.x == head.x && segment.y == head.y {
			return true
		}
	}

	return false
}
