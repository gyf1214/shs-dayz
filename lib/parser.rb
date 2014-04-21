require 'zlib'

module Parser
	def load_data path
		File.open path, 'rb' do |f|
			Marshal.load f
		end
	end

	def parse_script data
		ret = Array.new
		data.each do |rec|
			tag = rec[1].force_encoding("utf-8")
			content = Zlib::Inflate.inflate rec[2].force_encoding("utf-8")
			ret.push tag: tag, content: content
		end
		ret
	end

	def dump_script data
		rad = Random.new
		ret = Array.new
		data.each do |rec|
			content = Zlib::Deflate.deflate rec[:content]
			ret.push [rad.rand(1000000), rec[:tag], content]
		end
		ret
	end

	def dump_data path, data
		File.open path, 'wb' do |f|
			Marshal.dump data, f
		end
	end 
end