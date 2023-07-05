timers = {
	['disclaimer'] = function() doTweenAlpha('disclaimerAlpha', 'disclaimer', 0, 1 / playbackRate, 'linear') end
}

tweens = {
	['disclaimerAlpha'] = function() loadSong((getRandomInt(1, 1000) - 1) == 1 and 'creepy-start' or 'title') end
}

function onCreatePost()
	makeLuaSprite('disclaimer', 'fnaf1/disclaimer/disclaimer', 426, 249)
	addLuaSprite('disclaimer')
	setObjectCamera('disclaimer', 'other')

	runTimer('disclaimer', 2 / playbackRate)
end

function onUpdate() 
	if (keyboardJustPressed('ENTER') or mouseClicked()) and not luaTweenExists('disclaimerAlpha') then
		cancelTimer('disclaimer')
		doTweenAlpha('disclaimerAlpha', 'disclaimer', 0, 1 / playbackRate, 'linear') 
	end 
end

function luaTweenExists(tag) return runHaxeCode("return game.modchartTweens.exists('" .. tag .. "')") end
function onTimerCompleted(t) if timers[t] then timers[t]() end end
function onTweenCompleted(t) if tweens[t] then tweens[t]() end end