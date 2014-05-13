require 'src/window/base'

class WindowSelection < WindowBase
	attr_reader :items
	attr_reader :index

	def initialize x, y, width, height, items = Array.new
		@items = items
		@index = if items.empty? then -1 else 0 end
		super x, y, width, height
		refresh
		bind_ok method(:process_ok)
	end

	def contents_height
		h = super
		[h - h % WLH, @items.size * WLH].max
	end

	def auto_width
		width = 0
		@items.size.times do |i|
			width = [text_size(@items[i]).width, width].max
		end
		self.width = width + MARGIN * 4
		update_padding
		create_contents
		refresh
	end

	def auto_height
		self.height = contents_height + MARGIN * 2
		update_padding
		create_contents
		refresh
	end

	def index= index
		@index = index
		cursor_update
	end

	def items= items
		@items = items
		refresh
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
		rect = text_size @items[index]
		rect.width += MARGIN * 2
		rect.y = index * WLH
		if rect.width > contents.width
			rect.width = contents.width
			rect.x = 0
		else
			rect.x = (contents.width - rect.width) / 2
		end
		rect
	end

	def move direction
		return if @items.empty?
		if @index == -1
			@index = (@index + (direction + 1) / 2) % @items.size
		else
			@index = (@index + direction) % @items.size
		end
	end

	def cursor_update
		if @index < 0 or @index >= @items.size
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
		super
		if Mouse.over?(self) and Mouse.move?
			y = Mouse.pos[1] - self.y - MARGIN
			if y / WLH < 0
				@index = -1
			elsif y / WLH > @items.size - 1
				@index = @items.size
			else
				@index = y / WLH
			end
		end
	end

	def key_update
		super
		move -1 if Input.repeat? Input::UP
		move 1 if Input.repeat? Input::DOWN
	end

	def update
		super
		cursor_update
	end

	def update_padding
		super
		surplus = (self.height - self.padding * 2) % WLH
		self.padding_bottom = surplus + self.padding
	end

	def draw_item index, enable = true
		rect = item_rect index
		contents.clear_rect rect
		contents.font.color.alpha = if enable then 255 else 127 end
		contents.draw_text rect, @items[index], 1
	end

	def refresh
		self.contents.clear
		@items.size.times do |index|
			draw_item index
		end
	end

	def bind_buttons listener
		@items.size.times do |i|
			@listener[i] = listener
		end
	end

	def bind_all listener
		bind_buttons listener
		bind_back listener
	end

	def process_ok button
		call_listener @index
	end

	def open
		super
		refresh
	end
end