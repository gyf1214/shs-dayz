demand 'src/window/multi.rb'

class WindowSaveload < WindowMulti
	def rows
		5
	end

	def cols
		2
	end

	def rwidth
		400
	end

	def rheight
		100
	end

	def initialize
		items = Game.fetch_saves
		width = cols * rwidth + MARGIN * 2
		height = rows * rheight + MARGIN * 2
		super (1024 - width) / 2, (640 - height) / 2, width, height, items
		@index = 0
	end

	def draw_item index
		super
		return if @items[index].nil?
		rect = item_rect index
		data = load_data @items[index][:path]
		snap = Utility.read_bitmap data[:snap]
		rect_snap = Rect.new 0, 0, snap.width, snap.height
		contents.blt rect.x + 10, rect.y + 11, snap, rect_snap
		rect_text = Rect.new rect.x + 150, rect.y + 11, 234, WLH
		contents.draw_text rect_text, @items[index][:chapter]
		rect_text.y += WLH
		contents.draw_text rect_text, Utility.format_time(@items[index][:time])
	end
end