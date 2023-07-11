timers = {
	['exit'] = function() doTweenAlpha('imgAlpha2', 'img', 0, 2 / playbackRate, 'linear') end
}

tweens = {
	['imgAlpha2'] = function() 
		loadSong('title') 
		soundStop('music')
	end
}

function onCreatePost()
	setDataFromSave('fnaf1', 'beatCustom', true)

	makeLuaSprite('img', 'fnaf1/ending 3/ending')
	addLuaSprite('img')
	setObjectCamera('img', 'other')
	setProperty('img.alpha', 0)
	doTweenAlpha('imgAlpha1', 'img', 1, 2 / playbackRate, 'linear')

	soundLoad('music', 'fnaf1/ending/music box')
	soundPlay('music')

	runTimer('exit', 15 / playbackRate)
end

function onTimerCompleted(t) if timers[t] then timers[t]() end end
function onTweenCompleted(t) if tweens[t] then tweens[t]() end end