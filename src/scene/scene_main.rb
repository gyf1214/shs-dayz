class SceneMain < Scene
	def background_bitmap
		Assets.system 'main.jpg'
	end

	def start
		super
		Message.clear
		Message.append Assets.dialogue('prolog')
		#msgbox Assets.dialogue('prolog')
		@windows[0].next_page
	end

	def post_start
		super
		@windows[0].open
	end

	def pre_terminate
		@windows[0].close
		super
	end

	def create_windows
		super
		window = WindowMessage.new
		window.bind_back method(:main_listener)
		@windows.push window
	end

	def main_listener button
		Game.ret
	end
end