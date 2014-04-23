class SceneMain < Scene
	def background_bitmap
		Assets.system 'main.jpg'
	end

	def start
		super
		process_message false
	end

	def post_start
		super
		@main_window.open
	end

	def pre_terminate
		@main_window.close
		super
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

	def back_listener button
		@main_window.deactivate
		@menu_window.open
	end

	def page_listener button
		a = process_message until a
	end

	def back_menu button
		@menu_window.close
		@main_window.activate
	end

	def menu_listener button
		case button
		when 0
			
		when 1
			Game.call SceneSaveLoad.new
		when 2
			Game.ret
		end
	end

	def process_message pop = true
		return true if Message.empty?
		Message.pop if pop
		msg = Message.top
		case msg[:type]
		when :text
			@main_window.next_page "#{msg[:text]}"
		when :select
			open_select msg[:choices]
		when :choice
			skip_message unless @choice == 0
			@choice -= 1
			return false
		when :end
			return false
		when :fin
			@main_window.close
		end
		true
	end

	def skip_message
		Message.pop until Message.top[:type] == :end
		Message.pop
	end

	def process_select button
		@choice = button
		@select_window.close
		@main_window.activate
		a = process_message until a
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
end