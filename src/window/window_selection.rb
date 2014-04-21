class WindowSelection < WindowBase
	attr_reader :items
	attr_reader :index

	def initialize x, y, width, height, items = Array.new
		@items = items
		@index = if items.empty? then -1 else 0 end
		@listener = Hash.new
		super x, y, width, height
		refresh
	end

	def contents_height
		h = super
		[h - h % WLH, @items.size * WLH].max
	end

	def index=
		@index = index
		update_cursor
	end

	def top
		self.oy / WLH
	end

	def top= index
		index = 0 if index < 0
		index = @items.size - 1 if index > @items.size - 1
		self.oy = index * WLH
	end

	def page
		[1, (self.height - MARGIN * 2) / WLH].max
	end

	def bottom
		top + page - 1
	end

	def bottom= index
		self.top = index - page + 1
	end

	def item_rect index
		width = contents.text_size(@items[index]).width + MARGIN * 2
		height = WLH
		y = index * WLH
		if width > contents.width
			width = contents.width
			x = 0
		else
			x = (contents.width - width) / 2
		end
		Rect.new x, y, width, height
	end

	def movable?
		return false if not visible or not active
		return false if index < 0 or index >= @items.size
		true
	end

	def move direction
		@index = (@index + direction) % @items.size unless @items.empty?
	end

	def cursor_update
		if @index < 0
			self.cursor_rect.empty
		else
			last = self.bottom
			self.top = @index if @index < top
			self.bottom = @index if @index > bottom
			rect = item_rect @index
			self.cursor_rect = rect
		end
	end

	def mouse_update
		if Mouse.over? self
			y = Mouse.pos[1] - self.y - MARGIN
			@index = y / WLH
			@index = 0 if @index < 0
			@index = @items.size - 1 if @index > @items.size - 1
			call_listener @index if Mouse.click?(1)
		end
	end

	def key_update
		move -1 if Input.repeat? Input::UP
		move 1 if Input.repeat? Input::DOWN
		call_listener @index if Input.trigger? Input::C
		call_listener :back if Input.trigger? Input::B
	end

	def update
		super
		if self.active
			key_update
			mouse_update
			cursor_update
		end
	end

	def update_padding
		super
		surplus = (self.height - self.padding * 2) % WLH
		self.padding_bottom = surplus + self.padding
	end

	def draw_item index, enable = true
		rect = item_rect index
		self.contents.clear_rect rect
		self.contents.font.color.alpha = if enable then 255 else 127 end
		self.contents.draw_text rect, @items[index], 1
	end

	def refresh
		self.contents.clear
		@items.size.times do |index|
			draw_item index
		end
	end

	def bind button, listener
		@listener[button] = listener
	end

	def bind_buttons listener
		@items.size.times do |i|
			@listener[i] = listener
		end
	end

	def bind_back listener
		bind :back, listener
	end

	def bind_all listener
		bind_buttons listener
		bind_back listener
	end

	def listen? button
		not @listener[button].nil?
	end

	def call_listener button
		@listener[button].call(button) if listen? button
	end
end