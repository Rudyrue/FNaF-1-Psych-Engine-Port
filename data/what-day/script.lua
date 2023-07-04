date = {
	valueA = 0
}

tweens = {
	['dateAlpha'] = function() loadSong('wait') end
}

function onCreatePost()
	luaDebugMode = true
	initSaveData('fnaf1')
	addHaxeLibrary('FlxSound', 'flixel.system')
	addHaxeLibrary('Application', 'lime.app')
    addHaxeLibrary('Image','lime.graphics')
	setPropertyFromClass('flixel.addons.transition.FlxTransitionableState', 'skipNextTransIn', true)
	setPropertyFromClass('flixel.addons.transition.FlxTransitionableState', 'skipNextTransOut', true)
	setPropertyFromClass('openfl.Lib', 'application.window.title', "Five Nights at Freddy's")
	setPropertyFromClass('flixel.FlxG', 'mouse.visible', true)
	runHaxeCode([[
        var icon = Image.fromFile(Paths.modFolders('images/fnaf1/icon.png'));
        Application.current.window.setIcon(icon);
    ]])

	setProperty('camGame.visible', false)
	setProperty('camHUD.visible', false)

	makeAnimatedLuaSprite('date', 'fnaf1/what day/time', 533, 270)
	addAnimationByPrefix('date', 'a', 'time', 0, false)
	addLuaSprite('date')
	setObjectCamera('date', 'other')
	setProperty('date.animation.curAnim.curFrame', getDataFromSave('fnaf1', getDataFromSave('fnaf1', 'realNight') < 5 and 'realNight' or 'night') - 1)

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

function onPause() return Function_Stop end
function onTweenCompleted(t) if tweens[t] then tweens[t]() end end
function luaTweenExists(tag) return runHaxeCode("return game.modchartTweens.exists('" .. tag .. "')") end
function soundLoad(tag, path, loop)
	loop = loop or false
	runHaxeCode([[
		if (Paths.fileExists('sounds/]] .. path .. [[.ogg')) {
			var a = new FlxSound().loadEmbedded(Paths.sound(']] .. path .. [['), ]] .. tostring(loop) .. [[);
			FlxG.sound.list.add(a);
			a.pitch = game.playbackRate;
			game.modchartSounds.set(']] .. tag .. [[', a);
		} else game.addTextToDebug('soundLoad: Sound file "]] .. path .. [[" was not found.', 0xFFFF0000);
	]])
end
function soundPlay(tag, forceRestart, volume)
	forceRestart = forceRestart or true
	volume = volume or 1
	runHaxeCode([[
		var a = game.modchartSounds.get(']] .. tag .. [[');
		if (game.modchartSounds.exists(']] .. tag .. [[')) {
			a.volume = ]] .. volume .. [[;
			a.play(]] .. tostring(forceRestart) .. [[);
		}
		else game.addTextToDebug('soundPlay: Sound tag "]] .. tag .. [[" was not found.', 0xFFFF0000);
	]])
end