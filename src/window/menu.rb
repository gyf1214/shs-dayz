require 'src/window/selection'

class WindowMenu < WindowSelection
	RWIDTH = 75

	def initialize
		items = ["Auto", "Save", "Load", "Skip"]
		x = 900 - items.size * RWIDTH
		@helpers = Array.new
		super x, 576, 400, 24, items
		self.windowskin = Assets.system "window_naked"
		@index = -1
		bind_back method(:process_back)
		refresh
	end

	def contents_height
		WLH
	end

	def update_padding
		self.padding = 0
	end

	def item_rect index
		Rect.new index * RWIDTH, 0, RWIDTH, WLH
	end

	def cursor_update
		if @index < 0 or @index >= @items.size
			self.cursor_rect.empty
		else
			self.cursor_rect = item_rect @index
		end
	end

	def mouse_update
		super
		if Mouse.move?
			if Mouse.over?(self)
				x = Mouse.pos[0] - self.x
				@index = x / RWIDTH
			else
				@index = -1
			end
		end
	end

	def update
		super
		@helpers.each do |helper|
			helper.update
		end
	end

	def process_back button
		@index = -1
	end

	def draw_item index, enable = true
		super
		@helpers[index].dispose unless @helpers[index].nil?
		rect = item_rect index
		rect.x += self.x
		rect.y += self.y
		@helpers[index] = WindowHelper.new rect
	end

	def show_cursor index
		@helpers[index].show
	end

	def hide_cursor index
		@helpers[index].hide
	end

	def cursor? index
		@helpers[index].show?
	end

	def toggle_cursor index
		@helpers[index].toggle
	end

	def dispose
		super
		@helpers.each do |helper|
			helper.dispose
		end
	end

	def close
		super
		@helpers.each do |helper|
			helper.hide
		end
	end
end