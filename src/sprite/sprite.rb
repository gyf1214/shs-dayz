class SpriteBase < Sprite
	FADE = 24

	def width
		return @bitmap_trans.width unless @bitmap_trans.nil?
		super
	end

	def height
		return @bitmap_trans.height unless @bitmap_trans.nil?
		super
	end

	def initialize
		super
		@fading = 0
	end

	def offset_center
		self.ox = width / 2
		self.oy = height / 2
	end
end