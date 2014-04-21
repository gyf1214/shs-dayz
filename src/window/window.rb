class WindowBase < Window
	WLH = 24
	MARGIN = 16
	OPACITY = 200

	def initialize x, y, width, height
		super
		self.windowskin = Assets.system "window.png"
		update_padding
		create_contents
		@opening = false
		@closing = false
	end

	def contents_height
		height - MARGIN * 2
	end

	def create_contents
		self.contents.dispose
		self.contents = Bitmap.new width - MARGIN * 2, contents_height
	end

	def dispose
		self.contents.dispose
		super
	end

	def update
		super
		if @opening
			self.openness += 48
			@opening = false if self.openness >= 255
		elsif @closing
			self.openness -= 48
			@closing = false if self.openness <= 0
		end
	end

	def open
		@opening = true if self.openness < 255
		@closing = false
	end

	def close
		@closing = true if self.openness > 0
		@opening = false
	end

	def update_padding
		self.padding = MARGIN
	end

	def activate
		self.active = true
	end

	def deactivate
		self.active = false
	end
end