scene "prolog" do
	character :a => "刘书铭"
	character :b => "肖博文"

	a "好久不见，我今天请你吃羊鞭。"
	b "我昨天刚刚吃过，今天想吃鹿茸。"

	select do
		choice "还是请他吃羊鞭" do
			b "你竟然还想请我吃羊鞭，我非常讨厌你！"
			a "我就请你吃羊鞭！"
			say "（刘书铭强上了肖博文）"
		end
		choice "请他吃鹿茸" do
			b "哇，你请我吃鹿茸了。我好爱你！"
			a "我也爱你！"
			a "你能不能满足我的欲望！"
			say "（刘书铭上了肖博文）"
		end
	end

	a "吃了这种大补的奢侈品，你果然劲道十足！"
	b "下个礼拜约会还要请我吃哦~"

	fin
end