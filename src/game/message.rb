module Message
	@data = Array.new
	def self.push str
		@data.push str
	end

	def self.append data
		data.each do |str|
			push str.clone
		end
	end

	def self.pop
		@data.shift
	end

	def self.empty?
		@data.empty?
	end

	def self.clear
		@data.clear
	end
end