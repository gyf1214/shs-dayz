require 'require_all'
require_all 'lib'

include Parser

data = Array.new

for i in 1..(ARGV.size - 1)
	data.push tag: ARGV[i], content: File.read(ARGV[i])
end

dump_data ARGV[0], dump_script(data)
