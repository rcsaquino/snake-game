import raylib as r

struct Food {
mut:
	x int
	y int
}

fn (mut f Food) new() {
	f.x = r.get_random_value(field_margin / block_size, (win_width - block_size * 2) / block_size) * block_size
	f.y = r.get_random_value(field_margin / block_size, (win_height - block_size * 2) / block_size) * block_size
}

fn (f Food) is_valid_pos(s Snake) bool {
	if f.x == s.head.x && f.y == s.head.y {
		return false
	}
	for segment in s.body {
		if f.x == segment.x && f.y == segment.y {
			return false
		}
	}
	return true
}

fn (f Food) draw() {
	r.draw_rectangle(f.x, f.y, block_size, block_size, r.orange)
}

fn (f Food) is_eaten(s Snake) bool {
	return f.x == s.head.x && f.y == s.head.y
}
