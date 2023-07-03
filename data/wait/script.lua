function onCreatePost()
	setProperty('camGame.visible', false)
	setProperty('camHUD.visible', false)

	makeLuaSprite('clock', 'fnaf1/wait/clock', 1206, 657)
	addLuaSprite('clock')
	setObjectCamera('clock', 'other')

	loadSong('gameplay')
end

function onPause() return Function_Stop end