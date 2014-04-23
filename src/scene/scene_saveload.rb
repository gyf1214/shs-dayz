class SceneSaveLoad < Scene
	def initialize save
	end

	def process_back
		super
		Game.ret
	end
end