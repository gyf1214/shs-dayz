task :default => :dump

task :all => [:dump, :run]

task :dump => [:script, :text]

task :script do
	output = "scripts.zzy"
	main = "src/main.rb"
	files = FileList["src/*.rb", "src/*/*.rb"]
	files.delete main
	files.push main
	
	puts "Dump Scripts"
	puts "Source Files:"
	puts files
	puts "Output File: #{output}"
	puts
	ruby "bin/dump.rb script #{output} #{files.join(' ')}"
	puts
	puts "Done."
end

task :text do
	output = "assets/data/text.zzy"
	files = FileList["assets/data/src/text/*.rb"]

	puts "Dump Texts"
	puts "Source Files:"
	puts files
	puts "Output File: #{output}"
	puts
	ruby "bin/dump.rb text #{output} #{files.join(' ')}"
	puts
	puts "Done."
end

task :run do
	sh "Game.exe"
end