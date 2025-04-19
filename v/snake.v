import raylib as r

struct SnakeSegment {
mut:
	x int
	y int
}

struct Snake {
mut:
	head           SnakeSegment
	body           []SnakeSegment
	vec            []int = [1, 0]
	last_update    f64
	has_move_queue bool
	dead           bool
}

fn (mut s Snake) new() {
	s = Snake{}

	s.head = SnakeSegment{
		x: field_margin * 8
		y: field_margin * 5
	}

	s.body = [SnakeSegment{
		x: s.head.x - block_size
		y: s.head.y
	}, SnakeSegment{
		x: s.head.x - block_size * 2
		y: s.head.y
	}]
}

fn (s Snake) draw() {
	r.draw_rectangle(s.head.x, s.head.y, block_size, block_size, r.black)
	for segment in s.body {
		r.draw_rectangle(segment.x, segment.y, block_size, block_size, r.black)
	}
}

fn (mut s Snake) update() {
	// Body
	for i := s.body.len - 1; i > 0; i-- {
		s.body[i].x = s.body[i - 1].x
		s.body[i].y = s.body[i - 1].y
	}
	s.body[0].x = s.head.x
	s.body[0].y = s.head.y

	// Head
	s.head.x += block_size * s.vec[0]
	s.head.y += block_size * s.vec[1]

	s.has_move_queue = false

	s.handle_collisions()
}

fn (mut s Snake) grow() {
	s.body << SnakeSegment{
		x: s.body[s.body.len - 1].x
		y: s.body[s.body.len - 1].y
	}
}

fn (mut s Snake) handle_collisions() {
	if s.head.x > win_width - field_margin - block_size {
		s.dead = true
	}
	if s.head.y > win_height - field_margin - block_size {
		s.dead = true
	}
	if s.head.x < field_margin {
		s.dead = true
	}
	if s.head.y < field_margin {
		s.dead = true
	}

	for segement in s.body {
		if s.head.x == segement.x && s.head.y == segement.y {
			s.dead = true
		}
	}
}
