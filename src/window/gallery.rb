demand 'src/window/multi.rb'

class WindowGallery < WindowMulti
	def rows
		5
	end

	def cols
		5
	end

	def rwidth
		150
	end

	def rheight
		100
	end

	def initialize
		items = Flag.backgrounds
		super items
	end

	def draw_item index
		super
		return if @items[index].nil? 
		snap = Utility.thumbnail Assets.background(@items[index])
		rect = item_rect index
		rect.x += (rwidth - snap.width) / 2
		rect.y += (rheight - snap.height) / 2
		rect_snap = Rect.new 0, 0, snap.width, snap.height
		contents.blt rect.x, rect.y, snap, rect_snap
	end
end