def main
	Graphics.resize_screen 1024, 768
	Graphics.freeze
	Game.run SceneTitle
	Graphics.transition 30
end

main