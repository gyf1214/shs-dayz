demand 'src/scene/base.rb'

class SceneConfig < Scene
	def create_windows
		super
		@main_window = WindowSelection.new (1024 - 750) / 2, (640 - 500) / 2, 750, 500, []
		@windows.push @main_window
	end

	def post_start
		super
		@main_window.open
	end

	def pre_terminate
		@main_window.close
		super
	end

	def update_selection
		@main_window.items.clear
		text = "Skip unread text: #{Flag.global[:unread] ? 'Allowed' : 'Disallowed'}"
		@main_window.items.push text
		@main_window.refresh
		@main_window.bind_buttons method(:button_listener)
	end

	def update
		super
		update_selection
	end

	def button_listener button
		case button
		when 0
			Flag.global[:unread] = !Flag.global[:unread]
			Flag.dump
		end
	end

	def process_back
		super
		Game.ret
	end
end