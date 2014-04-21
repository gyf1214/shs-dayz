class SceneTitle < Scene
	def transition
		Graphics.transition 20
	end

	def background_bitmap
		Assets.system 'title.bmp'
	end

	def create_windows
		super
		commands = ["New Game", "Load Game", "Exit"]
		window = WindowSelection.new (1024 - 200) / 2, 600, 200, 104, commands
		window.openness = 0
		window.bind_all method(:main_listener)
		@windows.push window
		@active = window
		commands = ["Back"]
		window = WindowSelection.new (1024 - 500) / 2, 300, 500, 250, commands
		window.openness = 0
		window.bind_all method(:another_listener)
		@windows.push window
	end

	def main_listener button
		case button
		when :back
			Game.ret
		when 0
			Game.call SceneMain
		when 1
			@active = @windows[1]
			@active.open
		when 2
			Game.ret
		end
	end

	def another_listener button
		@active.close
		update until @active.close?
		@active = @windows[0]
	end
end