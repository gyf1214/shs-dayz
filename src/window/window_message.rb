class WindowMessage < WindowBase
	def initialize
		super 112, 450, 800, 160
		@window_name = WindowBase.new 112, 394, 150, 56
		@window_menu = WindowMenu.new
		@showing = false
		@duration = 0
		bind_ok method(:process_ok)
		@window_menu.bind_buttons method(:process_menu)
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
		self.pause = false
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
		@duration = 0
		if @text.empty?
			@showing = false
			self.pause = true
		else
			c = @text.slice! 0
			draw_character c
		end
	end

	def update
		super
		if @showing and active? and @duration > 2
			next_character
		else
			@duration += 1
		end
		@window_name.update
		@window_menu.update
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
		@window_menu.dispose
		super
	end

	def close
		super
		@window_name.close
		@window_menu.close
	end

	def open
		super
		@window_name.open unless @character.nil?
		@window_menu.open
	end

	def mouse_update
		super unless Mouse.over? @window_menu
	end

	def key_update
		super if @window_menu.index < 0
	end

	def process_menu button
		@listener[:menu].call button if listen? :menu
	end

	def bind_menu listener
		bind :menu, listener
	end

	def deactivate
		super
		@window_menu.deactivate unless @window_menu.nil?
	end

	def activate
		super
		@window_menu.activate unless @window_menu.nil?
	end

	def menu
		@window_menu
	end
end