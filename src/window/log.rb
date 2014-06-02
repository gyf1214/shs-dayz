demand 'src/window/multi.rb'

class WindowLog < WindowMulti
	def cols
		1
	end

	def rows
		5
	end

	def rwidth
		800
	end

	def rheight
		100
	end

	def initialize items
		surplus = rows - items.size
		surplus.times do
			items.unshift nil
		end
		super
		self.index = items.size - 1
	end

	def draw_item index, enable = true
		rect = super(index)
		return if @items[index].nil?
		contents.font.color.alpha = if enable then 255 else 127 end
		contents.draw_text rect, @items[index][:text], 1
	end

	def contents_height
		[super, @items.size * rheight].max
	end

	def move direction
		self.index = (@index + direction) % @items.size
	end

	def top
		self.oy / rheight
	end

	def top= index
		index = 0 if index < 0
		index = @items.size - 1 if index > @items.size - 1
		self.oy = index * rheight
	end

	def page
		[1, (self.height - MARGIN * 2) / rheight].max
	end

	def bottom
		top + page - 1
	end

	def bottom= index
		self.top = index - page + 1
	end

	def index= index
		@index = index
		cursor_update
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
end