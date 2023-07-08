date = {
	valueA = 0
}

tweens = {
	['dateAlpha'] = function() loadSong('wait') end
}

function onCreatePost()
	makeAnimatedLuaSprite('date', 'fnaf1/what day/time', 533, 270)
	addAnimationByPrefix('date', 'a', 'time', 0, false)
	addLuaSprite('date')
	setObjectCamera('date', 'other')

	makeAnimatedLuaSprite('blip', 'fnaf1/what day/blip')
	addAnimationByPrefix('blip', 'a', 'blip', 45, false)
	addLuaSprite('blip')
	setObjectCamera('blip', 'other')
	runHaxeCode("game.getLuaObject('blip', false).animation.finishCallback = _ -> game.getLuaObject('blip', false).visible = false;")

	soundLoad('blip', 'fnaf1/what day/blip3')
	soundPlay('blip')
end

function onUpdate()
	date.valueA = date.valueA + (1 * playbackRate)
	if date.valueA > 130 and not luaTweenExists('dateAlpha') then doTweenAlpha('dateAlpha', 'date', 0, 1 / playbackRate, 'linear') end
end

function onTweenCompleted(t) if tweens[t] then tweens[t]() end end