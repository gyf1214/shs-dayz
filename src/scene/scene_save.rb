class SceneSave < Scene
	attr_reader :snap

	def initialize save
		super()
		@save = save
		@saves = Game.fetch_saves
		@snap = Utility.snapshot
	end

	def terminate
		@snap.dispose
		super
	end

	def create_windows
		super
		@main_window = WindowSaveload.new
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
		if @saves[button].nil?
			data = Hash.new
			data[:path] = Game.get_savepath button
			@saves[button] = data
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
		return if @saves[button].nil?
		Game.load @saves[button][:path]
		Game.ret
		Game.call SceneMain.new unless Game.scene_type? SceneMain
	end

	def process_back
		super
		Game.ret
	end
end