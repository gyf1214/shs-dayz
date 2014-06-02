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
		surplus = rows * cols - items.size
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
		text_rect = Rect.new rect.x + 100, rect.y, rect.width - 100, rect.height
		cha_rect = Rect.new rect.x, rect.y, 100, rect.height
		contents.draw_text text_rect, @items[index][:text]
		unless @items[index][:character].nil?
			contents.draw_text cha_rect, @items[index][:character], 1
		end
	end
end