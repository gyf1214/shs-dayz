demand 'src/window/selection.rb'

class WindowMulti < WindowSelection
	def rows
	end

	def cols
	end

	def rwidth
	end

	def rheight
	end

	def initialize items
		width = cols * rwidth + MARGIN * 2
		height = rows * rheight + MARGIN * 2
		super (1024 - width) / 2, (640 - height) / 2, width, height, items
		@index = -1
	end

	def contents_height
		height - MARGIN * 2
	end

	def item_rect index
		xi, yi = (index % cols) * rwidth, (index/ cols) * rheight
		Rect.new xi, yi, rwidth, rheight
	end

	def cursor_update
		if @index < 0 or @index >= rows * cols
			self.cursor_rect.empty
		else
			self.cursor_rect = item_rect @index
		end
	end

	def move direction
		@index = (@index + direction) % (rows * cols)
	end

	def draw_item index
		rect = item_rect index
		contents.clear_rect rect
		rect
	end

	def update_padding
		self.padding = MARGIN
	end

	def key_update
		call_listener :ok if Input.trigger? Input::C
		call_listener :back if Input.trigger? Input::B
		move -cols if Input.repeat? Input::UP
		move cols if Input.repeat? Input::DOWN
		move -1 if Input.repeat? Input::LEFT
		move 1 if Input.repeat? Input::RIGHT
	end

	def mouse_update
		call_listener :ok if Mouse.click?(1) && Mouse.over?(self)
		call_listener :back if Mouse.click?(2) && Mouse.over?(self)
		if Mouse.move?
			if Mouse.over?(self)
				x = Mouse.pos[0] - self.x - MARGIN
				y = Mouse.pos[1] - self.y - MARGIN
				x = [0, x].max
				@index = y / rheight * cols + [cols - 1, x / rwidth].min
			else
				@index = -1
			end
		end
	end

	def bind_buttons listener
		(cols * rows).times do |i|
			@listener[i] = listener
		end
	end
end