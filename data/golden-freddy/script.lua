function onCreatePost()
	makeLuaSprite('img', 'fnaf1/goldenFreddy')
	addLuaSprite('img')
	setObjectCamera('img', 'other')

	soundLoad('scream', 'fnaf1/goldenFreddyScream')
	soundPlay('scream')

	runTimer('lol', 1 / playbackRate)
end

function onTimerCompleted() exitSong() end