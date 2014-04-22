class WindowMessage < WindowBase
	def initialize
		super (1024 - 800) / 2, 450, 800, 160
		@showing = false
		bind_ok method(:process_ok)
	end

	def draw_character c
		rect = text_size c
		if @x + rect.width > contents.width - MARGIN
			@x = 8
			@y += WLH
		else
			@x += rect.width
		end
		rect.x, rect.y = @x, @y
		contents.clear_rect rect
		contents.draw_text rect, c
	end

	def next_page
		@text = Message.pop
		return if @text.nil?
		contents.clear
		@x = contents.width
		@y = -WLH
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
	end

	def process_ok button
		if @showing
			next_character while @showing
		else
			next_page
		end
	end
end