require 'require_all'
require_all 'lib'

include Parser

key = ARGV[0].downcase
output = ARGV[1]
files = ARGV[2..-1]


case key
when 'script'
	dump = dump_script load_script(files)
when 'text'
	dump = load_text files
end
dump_data output, dump unless dump.nil?

