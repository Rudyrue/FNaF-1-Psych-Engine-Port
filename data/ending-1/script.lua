timers = {
	['exit'] = function() doTweenAlpha('imgAlpha2', 'img', 0, 2 / playbackRate, 'linear') end
}

tweens = {
	['imgAlpha2'] = function() 
		loadSong('title') 
		funcs.soundStop('music')
	end
}

function onCreatePost()
	funcs = require('mods/' .. (currentModDirectory ~= nil and (currentModDirectory .. '/')) .. 'extraFuncs')
	makeLuaSprite('img', 'fnaf1/ending 1/ending')
	addLuaSprite('img')
	setObjectCamera('img', 'other')
	setProperty('img.alpha', 0)
	doTweenAlpha('imgAlpha1', 'img', 1, 2 / playbackRate, 'linear')

	funcs.soundLoad('music', 'fnaf1/ending/music box')
	funcs.soundPlay('music')

	setDataFromSave('fnaf1', 'beatGame', true)
	flushSaveData('fnaf1')

	runTimer('exit', 15 / playbackRate)
end

function onTimerCompleted(t) if timers[t] then timers[t]() end end
function onTweenCompleted(t) if tweens[t] then tweens[t]() end end