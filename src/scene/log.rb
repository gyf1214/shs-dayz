demand 'src/scene/base.rb'

class SceneLog < Scene
	def create_windows
		super
		@main_window = WindowLog.new Message.backlog.clone
		@windows.push @main_window
	end

	def process_back
		super
		Game.ret
	end

	def post_start
		super
		@main_window.open
	end
end