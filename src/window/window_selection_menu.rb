class WindowMenu < WindowSelection
	RWIDTH = 75

	def initialize
		items = ["Auto", "Save", "Load", "Skip"]
		xx = 900 - items.size * RWIDTH
		super xx, 576, 400, 24, items
		self.windowskin = Assets.system "WindowNaked"
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

	def process_back button
		@index = -1
	end
end