module Assets
	@cache = Hash.new
	def self.system path
		load_bitmap "assets/system/#{path}"
	end

	def self.load_bitmap path
		if not @cache.include?(path) or @cache[path].disposed?
			@cache[path] = Bitmap.new path
		end
		@cache[path]
	end
end