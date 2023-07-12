timers = {
	['disclaimer'] = function() doTweenAlpha('disclaimerAlpha2', 'disclaimer', 0, 1 / playbackRate, 'linear') end
}

tweens = {
	['disclaimerAlpha1'] = function() runTimer('disclaimer', 2 / playbackRate) end,
	['disclaimerAlpha2'] = function() loadSong((getRandomInt(1, 1000) - 1) == 1 and 'creepy-start' or 'title') end
}

function onCreatePost()
	makeLuaSprite('disclaimer', 'fnaf1/disclaimer/disclaimer', 426, 249)
	addLuaSprite('disclaimer')
	setObjectCamera('disclaimer', 'other')
	setProperty('disclaimer.alpha', 0)
	doTweenAlpha('disclaimerAlpha1', 'disclaimer', 1, 1.01 / playbackRate, 'linear')
end

function onUpdate() 
	if (keyboardJustPressed('ENTER') or mouseClicked()) and not (luaTweenExists('disclaimerAlpha1') and luaTweenExists('disclaimerAlpha2')) then
		cancelTimer('disclaimer')
		doTweenAlpha('disclaimerAlpha2', 'disclaimer', 0, 1 / playbackRate, 'linear') 
	end 
end
function onTimerCompleted(t) if timers[t] then timers[t]() end end
function onTweenCompleted(t) if tweens[t] then tweens[t]() end end