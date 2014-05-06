class SceneTitle < Scene
	def transition
		Graphics.transition 20
	end

	def background_bitmap
		Assets.system 'title'
	end

	def post_start
		super
		@windows[0].open
	end

	def pre_terminate
		@windows[0].open
		super
	end

	def create_windows
		super
		commands = ["New Game", "Load Game", "Exit"]
		window = WindowSelection.new (1024 - 200) / 2, 500, 200, 104, commands
		window.bind_all method(:main_listener)
		@windows.push window

		commands = ["Back"]
		window = WindowSelection.new (1024 - 500) / 2, 200, 500, 250, commands
		window.bind_all method(:another_listener)
		@windows.push window
	end

	def main_listener button
		case button
		when :back
			Game.ret
		when 0
			Message.chapter = 'prolog'
			Game.call SceneMain.new
		when 1
			Game.call SceneSave.new(false)
		when 2
			Game.ret
		end
	end

	def another_listener button
		@windows[1].close
		@windows[0].activate
	end
end