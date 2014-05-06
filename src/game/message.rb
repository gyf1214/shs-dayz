module Message
	@data = Array.new
	@sprites = Array.new
	@background = nil
	@sprite_changed = false

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
		@sprites.clear
		@data.clear
		@index = 0
	end

	def self.chapter
		@chapter
	end

	def self.chapter= name
		@sprite_changed = true
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

	def self.set_sprite index, path
		@sprite_changed = true
		if path.nil?
			@sprites[index] = nil
		else
			@sprites[index] = Assets.character path
		end
	end

	def self.get_sprite index
		@sprites[index]
	end

	def self.background
		@background
	end

	def self.background= path
		@sprite_changed = true
		@background = Assets.background path
	end

	def self.refresh?
		@sprite_changed
	end

	def self.refresh
		@sprite_changed = false
	end
end