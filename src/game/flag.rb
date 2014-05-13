module Flag
	FLAG = 'save/.zzy'

	@backgrounds = Array.new
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
		ret[:flags] = @flags
		ret
		save_data ret, path
	end

	def self.parse
		path = FLAG
		ret = Hash.new
		ret = load_data path if File.exist? path
		@backgrounds = ret[:backgrounds] unless ret[:backgrounds].nil?
		@flags = ret[:flags] unless ret[:flags].nil?
	end
end