module Utility
	SNAP_WIDTH = 128
	SNAP_HEIGHT = 80

	def self.snapshot
		src = Graphics.snap_to_bitmap
		ret = Bitmap.new SNAP_WIDTH, SNAP_HEIGHT
		src_rec = Rect.new 0, 0, src.width, src.height
		dest_rec = Rect.new 0, 0, SNAP_WIDTH, SNAP_HEIGHT
		ret.stretch_blt dest_rec, src, src_rec
		src.dispose
		ret
	end

	def self.color_to_array color
		[color.red, color.green, color.blue, color.alpha]
	end

	def self.array_to_color array
		Color.new array[0], array[1], array[2], array[3]
	end

	def self.dump_bitmap bitmap
		ret = Array.new
		bitmap.width.times do |i|
			row = Array.new
			bitmap.height.times do |j|
				row << bitmap.get_pixel(i, j)
			end
			ret << row
		end
		ret
	end

	def self.read_bitmap array
		width = array.size
		height = 0
		height = array[0].size unless array[0].nil?
		ret = Bitmap.new width, height
		array.each_with_index do |row, i|
			row.each_with_index do |color, j|
				ret.set_pixel i, j, color
			end
		end
		ret
	end

	def self.format_time time
		"#{time.year}/#{time.month}/#{time.day} #{time.hour}:#{time.min}"
	end
end