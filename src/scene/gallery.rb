demand 'src/scene/base.rb'

class SceneGallery < Scene
	def create_windows
		super
		@main_window = WindowGallery.new
		@main_window.bind_buttons method(:process_button)
		@windows.push @main_window
	end

	def post_start
		super
		@main_window.open
	end

	def pre_terminate
		super
		@main_window.close
	end

	def process_back
		super
		Game.ret
	end

	def process_button button
		return if @main_window.items[button].nil?
		Message.clear
		Message.push type: :background, path: @main_window.items[button]
		Message.push type: :fin
		Game.call SceneMain.new
	end
end