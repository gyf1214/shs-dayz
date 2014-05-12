class WindowHelper < Window
	def initialize rect
		super rect.x, rect.y, rect.width, rect.height
		self.windowskin = Assets.system "window_naked"
		self.padding = 0
		self.contents.dispose
		self.contents = Bitmap.new width, height
		self.openness = 255
	end

	def show
		self.cursor_rect = Rect.new 0, 0, self.width, self.height
	end

	def hide
		self.cursor_rect.empty
	end

	def toggle
		if show? then hide else show end
	end

	def show?
		not self.cursor_rect.width == 0
	end
end