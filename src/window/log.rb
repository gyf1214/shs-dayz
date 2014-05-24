demand 'src/window/selection.rb'

class WindowLog < WindowSelection
	RWIDTH = 750
	RHEIGHT = 500

	def initialize items
		width = RWIDTH + MARGIN * 2
		height = RHEIGHT + MARGIN * 2
		super (1024 - width) / 2, (640 - height) / 2, width, height, items
		@index = items.size - 1
	end	
end