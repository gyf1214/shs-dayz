class SceneMain < Scene
	def start
		super
		loop do
			break if process_message
			Message.pop
		end
	end

	def post_start
		super
		@main_window.open
	end

	def pre_terminate
		@main_window.close
		super
	end

	def transition
		Graphics.transition 20
	end

	def create_windows
		super
		@main_window = WindowMessage.new
		@main_window.bind_back method(:back_listener)
		@main_window.bind_page method(:page_listener)
		@windows.push @main_window

		@select_window = WindowSelection.new (1024 - 400) / 2, 0, 400, 80, Array.new
		@windows.push @select_window

		commands = ["Save", "Load", "Exit"]
		@menu_window = WindowSelection.new 0, 0, 100, 100, commands
		@menu_window.auto_height
		@menu_window.auto_width
		@menu_window.center
		@menu_window.bind_back method(:back_menu)
		@menu_window.bind_buttons method(:menu_listener)
		@windows.push @menu_window
	end

	def create_foreground
		super
		@foregrounds.push SpriteBase.new
		@foregrounds.push SpriteBase.new
		@foregrounds.push SpriteBase.new
	end

	def back_listener button
		@main_window.deactivate
		@menu_window.open
	end

	def page_listener button
		loop do
			Message.pop
			break if process_message
		end
	end

	def back_menu button
		@menu_window.close
		@main_window.activate
	end

	def menu_listener button
		case button
		when 0
			Message.reset
			Game.call SceneSave.new(true)
		when 1
			Message.reset
			Game.call SceneSave.new(false)
		when 2
			Game.ret
		end
	end

	def process_ok
		super
		Game.ret if @main_window.close?
	end

	def open_select choices
		@main_window.deactivate
		@select_window.items = choices
		@select_window.index = 0
		@select_window.auto_height
		@select_window.auto_width
		@select_window.center
		@select_window.bind_buttons method(:process_select)
		@select_window.open
	end

	def center_sprites
		Graphics.freeze
		width = 0
		@foregrounds.each_with_index do |sprite, index|
			sprite.bitmap = Message.get_sprite index
			sprite.offset_center
			width += sprite.width
		end
		x = (1024 - width) / 2
		@foregrounds.each do |sprite|
			sprite.x = x + sprite.width / 2
			sprite.y = 400
			x += sprite.width
		end
		@background.bitmap = Message.background
		Graphics.transition 20
		Message.refresh
	end

	include Interpreter
end