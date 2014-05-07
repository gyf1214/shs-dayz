class WindowMessage < WindowBase
	def initialize
		super 112, 450, 800, 160
		@showing = false
		bind_ok method(:process_ok)
		@window_name = WindowBase.new 112, 394, 150, 56
	end

	def draw_character c
		rect = text_size c
		rect.x, rect.y = @x, @y
		if @x + rect.width > contents.width - MARGIN
			@x = 8
			@y += WLH
		else
			@x += rect.width
		end
		contents.clear_rect rect
		contents.draw_text rect, c
	end

	def next_page msg
		@text = msg[:text].clone
		@character = msg[:character]
		return if @text.nil?
		if @character.nil?
			@window_name.close
		else
			@window_name.contents.clear
			@window_name.draw_text @character, 1
			@window_name.open
		end
		contents.clear
		@x = 8
		@y = 0
		@showing = true
	end

	def next_character
		if @text.empty?
			@showing = false
		else
			c = @text.slice! 0
			draw_character c
		end
	end

	def update
		super
		next_character if @showing and active?
		@window_name.update
	end

	def process_ok button
		if @showing
			next_character while @showing
		else
			call_listener :page
		end
	end

	def bind_page listener
		bind :page, listener
	end

	def dispose
		@window_name.dispose
		super
	end

	def close
		super
		@window_name.close
	end

	def open
		super
		@window_name.open unless @character.nil?
	end
end