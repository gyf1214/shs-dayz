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
end