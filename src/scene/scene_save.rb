class SceneSave < Scene
	def initialize save
		super()
		@save = save
		@saves = Game.fetch_saves
	end

	def create_windows
		super
		commands = Array.new
		@saves.each do |save|
			commands.push "#{save[:chapter]}: #{save[:time]}"
		end
		commands.push "New Data" if @save
		@main_window = WindowSelection.new (1024 - 800) / 2, (640 - 600) / 2, 800, 600, commands
		if @save
			@main_window.bind_buttons method(:process_save)
		else
			@main_window.bind_buttons method(:process_load)
		end
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

	def process_save button
		if button == @saves.size
			data = Hash.new
			data[:path] = Game.get_savepath button
			@saves.push data
		else
			data = @saves[button]
		end
		data[:chapter] = Message.chapter
		data[:time] = Time.now
		Game.refresh_saves @saves
		Game.save data[:path]
		Game.ret
	end

	def process_load button
		Game.load @saves[button][:path]
		Game.ret
		Game.call SceneMain.new unless Game.scene_type? SceneMain
	end

	def process_back
		super
		Game.ret
	end
end