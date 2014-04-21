task :default => :dump

task :dump do
	output = "Scripts.rvdata"
	main = "src/main.rb"
	files = FileList["src/*.rb", "src/*/*.rb"]
	files.delete main
	files.push main
	
	puts "Source Files:"
	puts files
	puts "Output File: #{output}"
	puts
	ruby "bin/dump.rb #{output} #{files.join(' ')}"
	puts
	puts "Done."
end

task :run do
	sh "Game.exe"
end

task :all => [:dump, :run]