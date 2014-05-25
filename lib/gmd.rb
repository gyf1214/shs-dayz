module GMD
	class Character
		def initialize name, display
			@name = name
			@display = display
		end

		def say x
			GMD.say x, @display
		end

		def sprite x, loc = @loc
			raise "Location must be given" if loc.nil?
			unless x.empty?
				GMD.sprite "#{@name}_#{x}", loc
			else
				GMD.sprite nil, loc
			end
			@loc = loc
		end
	end

	def self.character c
		if c.instance_of? Hash
			c.each do |k, v|
				@characters.store k, Character.new(k, v)
			end
		else
			@characters.store c, Character.new(c, c.to_s)
		end
	end

	def self.background b
		@now.push type: :background, path: b
	end

	def self.scene c
		@characters = Hash.new
		@now = Array.new
		@label = Hash.new
		name = ""
		@now.push type: :blank
		if c.instance_of? Hash
			c.each do |k, v|
				name = k.to_s
				background v
			end
		else
			name = c
		end
		yield
		@data.store name, text: @now, label: @label
	end

	def self.say x, c = nil
		@now.push type: :text, text: x, character: c
	end

	def self.select
		@select = Array.new
		@now.push type: :select, choices: @select
		@now.push type: :do
		yield
		@now.push type: :end
	end

	def self.choice name
		@select.push name
		@now.push type: :choice
		@now.push type: :do
		yield
		@now.push type: :break
		@now.push type: :end
	end

	def self.sprite x, loc
		@now.push type: :sprite, sprite: x, location: loc
	end

	def self.fin
		@now.push type: :fin
	end

	def self.chapter x
		@now.push type: :chapter, chapter: x.to_s
	end

	def self.flag x, y = true
		@now.push type: :flag, key: x, val: y
	end

	def self.since x
		@now.push type: :since, key: x
		@now.push type: :do
		yield
		@now.push type: :break
		@now.push type: :end
		@now.push type: :end
	end

	def self.otherwise
		@now.push type: :break
		@now.push type: :end
		@now.push type: :do
	end

	def self.process file, data
		@data = data
			instance_eval file
	end

	def self.label k
		@label.store k, @now.size - 1
	end

	def self.goto k
		@now.push type: :goto, key: k
	end

	private
	def self.method_missing x, *args
		if @characters.key? x
			unless args.empty?
				@characters[x].say args[0]
			else
				@characters[x]
			end
		else
			super
		end
	end
end