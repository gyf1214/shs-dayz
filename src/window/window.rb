class WindowBase < Window
	WLH = 24
	MARGIN = 16
	OPACITY = 200

	def initialize x, y, width, height
		super
		@listener = Hash.new
		self.windowskin = Assets.system "window.png"
		update_padding
		create_contents
		self.openness = 0
		@opening = false
		@closing = false
		deactivate
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

	def active?
		self.active and open?
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
		if active?
			key_update
			mouse_update
		end
	end

	def open
		activate
		@opening = true if self.openness < 255
		@closing = false
	end

	def close
		deactivate
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

	def key_update
		call_listener :ok if Input.trigger? Input::C
		call_listener :back if Input.trigger? Input::B
	end

	def mouse_update
	end

	def bind button, listener
		@listener[button] = listener
	end

	def bind_back listener
		bind :back, listener
	end

	def bind_ok listener
		bind :ok, listener
	end

	def listen? button
		not @listener[button].nil?
	end

	def call_listener button
		@listener[button].call(button) if listen? button
	end

	def text_size str
		width = contents.text_size(str).width + 2
		height = WLH
		Rect.new 0, 0, width, height
	end
end