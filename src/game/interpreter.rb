module Interpreter
	def process_message
		return true if Message.empty?
		center_sprites if Message.refresh?
		msg = Message.top
		case msg[:type]
		when :text
			@main_window.next_page msg
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
			Message.background = msg[:path]
			return false
		when :fin
			@main_window.close
		when :blank
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
		page_listener 0
	end
end