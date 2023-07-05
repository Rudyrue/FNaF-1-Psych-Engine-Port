timers = {
	['eyes'] = function() for i = 1, 2 do setProperty('eye' .. i .. '.visible', true) end end,
	['timer'] = function() loadSong('title') end
}

function onCreate()
	makeLuaSprite('bonnie', 'fnaf1/creepy start/bonnie')
	addLuaSprite('bonnie')
	setObjectCamera('bonnie', 'other')

	makeLuaSprite('eye1', 'fnaf1/creepy start/eye', 495, 177)
	addLuaSprite('eye1')
	setObjectCamera('eye1', 'other')
	setProperty('eye1.visible', false)

	makeLuaSprite('eye2', 'fnaf1/creepy start/eye', 789, 181)
	addLuaSprite('eye2')
	setObjectCamera('eye2', 'other')
	setProperty('eye2.visible', false)

	runTimer('eyes', 9.5 / playbackRate)
	runTimer('timer', 10 / playbackRate)
end

function onTimerCompleted(t) if timers[t] then timers[t]() end end