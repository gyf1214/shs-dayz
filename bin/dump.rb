require 'require_all'
require_all 'lib'

include Parser

key = ARGV[0].downcase
output = ARGV[1]
files = ARGV[2..-1]


case key
when 'script'
	puts 'Resolve Dependencies.'
	list = Dependency.process files
	puts 'Done.'
	dump = dump_script load_script(list)
when 'text'
	dump = load_text files
end
puts 'Output Data.'
dump_data output, dump unless dump.nil?
puts 'Done.'

