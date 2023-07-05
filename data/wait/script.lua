function onCreatePost()
	makeLuaSprite('clock', 'fnaf1/wait/clock', 1206, 657)
	addLuaSprite('clock')
	setObjectCamera('clock', 'other')

	loadSong('gameplay')
end