module Game
	SAVES = 'save/..zzy'

	@scene = nil
	@stack = []
	@closing = false
	@sprite = ""

	def self.run scene
		call scene
		@scene.main until @scene.nil?
	end

	def self.goto scene
		@stack.pop
		@scene = scene
		@stack.push @scene
	end

	def self.scene? scene
		@scene == scene
	end

	def self.scene_type? scene
		@scene.instance_of? scene
	end

	def self.call scene
		@scene = scene
		@stack.push @scene
	end

	def self.ret
		@stack.pop
		@scene = @stack.last
	end

	def self.fetch_saves
		path = SAVES
		if File.exist? path
			ret = load_data path
		else
			ret = []
			save_data ret, path
		end
		ret
	end

	def self.refresh_saves data
		path = SAVES
		save_data data, path
	end

	def self.get_savepath index
		ret = ""
		index += 1
		while index > 0
			ret += if index % 2 == 0 then '.' else '-' end
			index /= 2
		end
		"save/#{ret}.zzy"
	end

	def self.save path
		data = Hash.new
		data[:chapter] = Message.chapter
		data[:index] = Message.index
		data[:sprite] = Message.sprites
		data[:background] = Message.background_path
		data[:snap] = Utility.dump_bitmap @scene.snap
		data[:flags] = Flag.flags
		data[:backlog] = Message.backlog
		save_data data, path
	end

	def self.load path
		data = load_data path
		Message.chapter = data[:chapter]
		Message.index = data[:index]
		Message.sprites = data[:sprite]
		Message.background = data[:background]
		Message.backlog = data[:backlog]
		Flag.flags = data[:flags]
	end
end