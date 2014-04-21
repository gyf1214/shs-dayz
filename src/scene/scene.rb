class Scene
	def init
		start
		transition
		post_start
	end

	def main
		init
		loop do
			update
			break unless Game.scene? self
		end
		dispose
	end

	def dispose
		Graphics.update
		pre_terminate
		Graphics.freeze
		terminate
	end

	def start
		create_background
		create_windows
	end

	def transition
		Graphics.transition 10
	end

	def post_start
		@active.open unless @active.nil?
	end

	def update
		Graphics.update
		Input.update
		Mouse.update
		@active.update unless @active.nil?
	end

	def pre_terminate
		@active.close unless @active.nil?
	end

	def terminate
		dispose_windows
		dispose_background
	end

	def create_windows
		@windows = Array.new
		@active = nil
	end

	def dispose_windows
		@windows.each do |window|
			window.dispose unless window.disposed?
		end
	end

	def background_bitmap
		Bitmap.new Graphics.width, Graphics.height
	end

	def create_background
		@background = Sprite.new
		@background.bitmap = background_bitmap
	end

	def dispose_background
		@background.bitmap.dispose
		@background.dispose
	end
end