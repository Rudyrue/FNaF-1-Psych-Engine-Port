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
	initSaveData('fnaf1')
	addHaxeLibrary('FlxSound', 'flixel.system')
	addHaxeLibrary('Application', 'lime.app')
    addHaxeLibrary('Image','lime.graphics')
	setProperty('camGame.visible', false)
	setProperty('camHUD.visible', false)
	setPropertyFromClass('flixel.addons.transition.FlxTransitionableState', 'skipNextTransIn', true)
	setPropertyFromClass('flixel.addons.transition.FlxTransitionableState', 'skipNextTransOut', true)
	setPropertyFromClass('openfl.Lib', 'application.window.title', "Five Nights at Freddy's")
	setPropertyFromClass('flixel.FlxG', 'mouse.visible', true)
	runHaxeCode([[
        var icon = Image.fromFile(Paths.modFolders('images/fnaf1/icon.png'));
        Application.current.window.setIcon(icon);
    ]])

	makeLuaSprite('img', 'fnaf1/ending 2/ending')
	addLuaSprite('img')
	setObjectCamera('img', 'other')
	setProperty('img.alpha', 0)
	doTweenAlpha('imgAlpha1', 'img', 1, 2 / playbackRate, 'linear')

	soundLoad('music', 'fnaf1/ending/music box')
	soundPlay('music')

	setDataFromSave('fnaf1', 'beat6', true)
	flushSaveData('fnaf1')

	runTimer('exit', 15 / playbackRate)
end

function onTimerCompleted(t) if timers[t] then timers[t]() end end
function onTweenCompleted(t) if tweens[t] then tweens[t]() end end
function onPause() return Function_Stop end
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
		} else game.addTextToDebug('soundPlay: Sound tag "]] .. tag .. [[" was not found.', 0xFFFF0000);
	]])
end
function soundStop(tag)
	runHaxeCode([[
		var a = game.modchartSounds.get(']] .. tag .. [[');
		if (game.modchartSounds.exists(']] .. tag .. [[')) a.stop();
		else game.addTextToDebug('soundStop: Sound tag "]] .. tag .. [[" was not found.', 0xFFFF0000);
	]])
end