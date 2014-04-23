def main
	Graphics.resize_screen 1024, 640
	Graphics.freeze
	Game.run SceneTitle.new
	Graphics.transition 30
end

main