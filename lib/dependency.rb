module Dependency
	def self.method_missing(meth, *args, &blk)
		puts meth
	end

	def self.rgss_main
		#nothing
	end

	def self.demand file
		unless @done.member? file
			File.foreach file do |line|
				line = line.force_encoding('utf-8').strip.chomp
				instance_eval line if line =~ /^demand/
			end
			@done.push file
		end
	end

	def self.process list
		@list = list
		@done = Array.new
		@list.each do |file|
			demand file
		end
		@done
	end
end