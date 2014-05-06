module Assets
	@cache = Hash.new
	def self.system path
		load_bitmap "assets/system/#{path}.png"
	end

	def self.character path
		load_bitmap "assets/character/#{path}.png"
	end

	def self.background path
		load_bitmap "assets/background/#{path}.png"
	end

	def self.data path
		load_generic "assets/data/#{path}.zzy"
	end

	def self.dialogue name
		data("text")[name]
	end

	def self.load_bitmap path
		if not @cache.include?(path) or @cache[path].disposed?
			@cache[path] = Bitmap.new path
		end
		@cache[path]
	end

	def self.load_generic path
		unless @cache.include?(path)
			@cache[path] = load_data path
		end
		@cache[path]
	end

	def self.save_path index
		"save/#{index}.zzy"
	end
end