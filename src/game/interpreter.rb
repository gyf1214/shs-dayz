module Interpreter
	def process_message
		return true if Message.empty?
		center_sprites if Message.refresh?
		msg = Message.top
		case msg[:type]
		when :text
			@main_window.next_page msg
			recover if @skipping == 1 and !Flag.read?(Message.chapter, Message.index) and !Flag.global[:unread]
		when :select
			open_select msg[:choices]
			return true
		when :choice
			skip_message unless @choice == 0
			@choice -= 1
			return false
		when :do
			return false
		when :end
			return false
		when :break
			skip_message 2
			return false
		when :chapter
			Message.chapter = msg[:chapter]
			return false
		when :sprite
			Message.set_sprite msg[:location], msg[:sprite]
			return false
		when :background
			Flag.backgrounds.push msg[:path] unless Flag.backgrounds.member? msg[:path]
			Flag.dump
			Message.background = msg[:path]
			return false
		when :fin
			@main_window.close
		when :blank
			return false
		when :flag
			Flag[msg[:key]] = msg[:val]
			return false
		when :add
			Flag[msg[:key]] += msg[:val]
			return false
		when :mul
			Flag[msg[:key]] *= msg[:val]
			return false
		when :since
			if Flag[msg[:key]].instance_of? TrueClass or Flag[msg[:key]].instance_of? FalseClass
				tf = Flag[msg[:key]] == msg[:val]
			else
				tf = Flag[msg[:key]] >= msg[:val]
			end
			skip_message unless tf
			return false
		when :goto
			Message.goto msg[:key]
			return false
		end
		return true
	end

	def skip_message indent = 0
		loop do
			Message.pop
			a = Message.top
			indent += 1 if a[:type] == :do
			indent -= 1 if a[:type] == :end
			break if indent == 0
		end
	end

	def process_select button
		@choice = button
		@select_window.close
		@main_window.activate
		Message.backlog.push text: @select_window.items[button], character: "（选项）"
		page_listener 0
	end
end