module Flag
	FLAG = 'save/.zzy'

	@backgrounds = Array.new
	@global = Hash.new
	@flags = Hash.new

	def self.backgrounds
		@backgrounds
	end

	def self.backgrounds= data
		@backgrounds = data
	end

	def self.dump
		path = FLAG
		ret = Hash.new
		ret[:backgrounds] = @backgrounds
		ret[:global] = @global
		save_data ret, path
		ret
	end

	def self.parse
		path = FLAG
		ret = Hash.new
		ret = load_data path if File.exist? path
		@backgrounds = ret[:backgrounds] unless ret[:backgrounds].nil?
		@global = ret[:global] unless ret[:global].nil?
	end

	def self.[] key
		if @flags[key].nil? then false else @flags[key] end
	end

	def self.[]= key, val
		@flags[key] = val
	end

	def self.global
		@global
	end

	def self.flags
		@flags
	end

	def self.flags= val
		@flags = val
	end
end