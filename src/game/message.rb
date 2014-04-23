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
		ret = @data[@index]
		@index += 1
		ret
	end

	def self.top
		@data[@index]
	end

	def self.empty?
		@index >= @data.size
	end

	def self.clear
		@data.clear
		@index = 0
	end

	def self.chapter
		@chapter
	end

	def self.chapter= name
		@chapter = name
		clear
		append Assets.dialogue(name)
	end

	def self.index
		@index
	end

	def self.index= index
		@index = index
	end
end