def main
	Graphics.resize_screen 1024, 640
	Graphics.freeze
	Flag.parse
	Game.run SceneTitle.new
	Graphics.transition 30
end

rgss_main do
	main
end