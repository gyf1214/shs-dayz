module Message
	@data = Array.new
	@sprites = Array.new
	@background = nil
	@sprite_changed = false
	@labels = Hash.new

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
		@background = nil
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
		append Assets.dialogue(name)[:text]
		@labels = Assets.dialogue(name)[:label]
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
			@sprites[index] = path
		end
	end

	def self.get_sprite index
		if @sprites[index].nil?
			nil
		else
			Assets.character @sprites[index]
		end
	end

	def self.sprites
		@sprites
	end

	def self.sprites= s
		@sprites = s
	end

	def self.background
		if @background.nil?
			nil
		else
			Assets.background @background
		end
	end

	def self.background_path
		@background
	end

	def self.background= path
		@sprite_changed = true
		@background = path
	end

	def self.refresh?
		@sprite_changed
	end

	def self.refresh
		@sprite_changed = false
	end

	def self.reset
		@sprite_changed = true
	end

	def self.goto k
		@index = @labels[k]
	end
end