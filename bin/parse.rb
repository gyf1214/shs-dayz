require 'require_all'
require_all 'lib'

include Parser

data = parse_script load_data(ARGV[0])

data.each do |rec|
	next if rec[:tag].empty?
	path = "#{ARGV[1]}/#{rec[:tag]}.rb"
	puts path
	File.open path, 'w' do |f|
		f.write rec[:content]
	end
end