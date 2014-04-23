class SceneMain < Scene
	def background_bitmap
		Assets.system 'main.jpg'
	end

	def start
		super
		process_message
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
			Game.save Assets.save_path(0)
			@menu_window.close
			@main_window.activate
		when 1
			Game.load Assets.save_path(0)
			Game.goto SceneMain.new
		when 2
			Game.ret
		end
	end

	def process_message
		return true if Message.empty?
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
		when :do
			return false
		when :end
			return false
		when :break
			skip_message 2
			return false
		when :fin
			@main_window.close
		end
		true
	end

	def skip_message indent = 0
		loop do
			Message.pop
			a = Message.top
			indent += 1 if a[:type] == :do
			indent -= 1 if a[:type] == :end
			break if indent == 0
		end
	end

	def process_select button
		@choice = button
		@select_window.close
		@main_window.activate
		page_listener 0
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