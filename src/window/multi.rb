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
		surplus = rows * cols - items.size
		surplus.times do
			items.push nil
		end
		width = cols * rwidth + MARGIN * 2
		height = rows * rheight + MARGIN * 2
		super (1024 - width) / 2, (640 - height) / 2, width, height, items
		@index = -1
	end

	def real_rows
		ret = @items.size / cols
		ret += 1 unless @items.size % cols == 0
		ret
	end

	def contents_height
		h = height - MARGIN * 2
		[h - h % rheight, real_rows * rheight].max
	end

	def item_rect index
		xi, yi = (index % cols) * rwidth, (index/ cols) * rheight
		Rect.new xi, yi, rwidth, rheight
	end

	def cursor_update
		if @index < 0 or @index >= @items.size
			self.cursor_rect.empty
		else
			line = @index / cols
			self.top = line if line < top
			self.bottom = line if line > bottom
			self.cursor_rect = item_rect @index
		end
	end

	def move direction
		self.index = (@index + direction) % @items.size
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