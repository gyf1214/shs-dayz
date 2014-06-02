demand 'src/scene/base.rb'

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
		commands = ["New Game", "Load Game", "Other", "Exit"]
		window = WindowSelection.new (1024 - 200) / 2, 480, 200, 128, commands
		window.bind_all method(:main_listener)
		@windows.push window

		commands = ["CG Gallery", "Config", "Back"]
		window = WindowSelection.new (1024 - 500) / 2, 200, 500, 250, commands
		window.bind_all method(:another_listener)
		@windows.push window
	end

	def main_listener button
		case button
		when :back
			Game.ret
		when 0
			Flag.flags.clear
			Message.chapter = 'prolog'
			Message.backlog.clear
			Game.call SceneMain.new
		when 1
			Game.call SceneSave.new(false)
		when 2
			@windows[1].open
			@windows[0].deactivate
		when 3
			Game.ret
		end
	end

	def another_listener button
		case button
		when :back
			@windows[1].close
			@windows[0].activate
		when 0
			Game.call SceneGallery.new
		when 1
			Game.call SceneConfig.new
		when 2
			@windows[1].close
			@windows[0].activate
		end
	end
end