module Game
	@scene = nil
	@stack = []
	@closing = false

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

	def self.call scene
		@scene = scene
		@stack.push @scene
	end

	def self.ret
		@stack.pop
		@scene = @stack.last
	end

	def self.save path
		data = Hash.new
		data[:chapter] = Message.chapter
		data[:index] = Message.index
		save_data data, path
	end

	def self.load path
		data = load_data path
		Message.chapter = data[:chapter]
		Message.index = data[:index]
	end
end