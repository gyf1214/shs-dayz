class WindowSaveload < WindowSelection
	ROWS = 5
	COLS = 2
	RWIDTH = 400
	RHEIGHT = 100

	def initialize
		items = Game.fetch_saves
		width = COLS * RWIDTH + MARGIN * 2
		height = ROWS * RHEIGHT + MARGIN * 2
		super (1024 - width) / 2, (640 - height) / 2, width, height, items
		@index = 0
	end

	def contents_height
		height - MARGIN * 2
	end

	def item_rect index
		xi, yi = (index % 2) * RWIDTH, (index/ 2) * RHEIGHT
		Rect.new xi, yi, RWIDTH, RHEIGHT
	end

	def cursor_update
		if @index < 0 or @index >= ROWS * COLS
			self.cursor_rect.empty
		else
			self.cursor_rect = item_rect @index
		end
	end

	def move direction
		@index = (@index + direction) % (ROWS * COLS)
	end

	def draw_item index
		rect = item_rect index
		contents.clear_rect rect
		return if @items[index].nil?
		data = load_data @items[index][:path]
		snap = Utility.read_bitmap data[:snap]
		rect_snap = Rect.new 0, 0, snap.width, snap.height
		contents.blt rect.x + 10, rect.y + 11, snap, rect_snap
		rect_text = Rect.new rect.x + 150, rect.y + 11, 234, WLH
		contents.draw_text rect_text, @items[index][:chapter]
		rect_text.y += WLH
		contents.draw_text rect_text, Utility.format_time(@items[index][:time])
	end

	def update_padding
		self.padding = MARGIN
	end

	def key_update
		call_listener :ok if Input.trigger? Input::C
		call_listener :back if Input.trigger? Input::B
		move -2 if Input.repeat? Input::UP
		move 2 if Input.repeat? Input::DOWN
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
				@index = y / RHEIGHT * 2 + [1, x / RWIDTH].min
			else
				@index = -1
			end
		end
	end

	def bind_buttons listener
		(COLS * ROWS).times do |i|
			@listener[i] = listener
		end
	end
end