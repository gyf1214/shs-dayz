module GMD
	def self.character c
		if c.instance_of? Hash
			c.each do |k, v|
				@characters.store k, v
			end
		else
			@characters.store c, c.to_s
		end
	end

	def self.scene name
		@characters = Hash.new
		@now = Array.new
		yield
		@data.store name, @now
	end

	def self.say x
		@now.push type: :text, text: x
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

	def self.fin
		@now.push type: :fin
	end

	def self.process file, data
		@data = data
		instance_eval file
	end

	private
	def self.method_missing x, arg
		return say "#{@characters[x]}：#{arg}" if @characters.key? x
		super
	end
end