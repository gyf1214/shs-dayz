scene "prolog" do
	character :a => "小小"
	character :b => "沈笑阳"
	
	a "你好！"
	b "你好！"
	b "你今天周爽考了满分么？"
	
	select do
		choice "考了满分！" do
			b "哦。"
		end
		
		choice "没考满分！" do
			b "那花花呢？"
			select do
				choice "..." do
					b "没事，随便问问..."
					a "哦。"
				end
				choice "不知道诶..." do
					b "好吧..."
				end
			end
			a "那你考了满分么？"			
		end
	end
	say "（这时候上课铃打了）"
	say "（我们回到座位上课）"
	
	fin
end
