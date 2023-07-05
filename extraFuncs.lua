local m = {}

function m.clickteamToFlixelAlpha(value) return 1 - (value / 255) end
function m.luaTweenExists(tag) return runHaxeCode("return game.modchartTweens.exists('" .. tag .. "')") end
function m.round(num, decimal_places) return math.floor(num * (10 ^ (decimal_places or 0)) + 0.5) / (10 ^ (decimal_places or 0)) end
function m.switch(case, cases) if cases[case] ~= nil then return cases[case]() elseif cases.default ~= nil then return cases.default() end end
function m.curTimerLength(timer) 
	return runHaxeCode([[
		var tmr = game.modchartTimers.get(']] .. timer .. [[');
		return game.modchartTimers.exists(']] .. timer .. [[') ? ((tmr.progress * tmr.time) * game.playbackRate) : game.addTextToDebug('curTimerLength: Timer tag "]] .. timer .. [[" was not found.', 0xFFFF0000);
  	]]) 
end
function m.makeCamera(tag, x, y, transparent, width, height)
	transparent = transparent or false
	x = x or 0
	y = y or 0
	width = width or screenWidth
	height = height or screenHeight
	runHaxeCode([[
		var ]] .. tag .. [[ = new FlxCamera(]] .. x .. [[, ]] .. y .. [[, ]] .. width .. [[, ]] .. height .. [[, 1);
		var transparent = ]] .. tostring(transparent) .. [[;
		]] .. tag .. [[.follow(null);
		]] .. tag .. [[.bgColor = (transparent ? 0x00 : 0xFF) + 000000;
		FlxG.cameras.add(]] .. tag .. [[);
		setVar(']] .. tag .. [[', ]] .. tag .. [[);
	]])
end
function m.setLuaCamera(obj, cam)
	runHaxeCode([[
		var a = game.getLuaObject(']] .. obj .. [[');
		var b = getVar(']] .. cam .. [[');

		if (a != null || b != null) a.cameras = [b];

		trace('camera: ' + getVar(']] .. cam .. [['));
		trace('object: ' + a);
	]])
end
function m.mouseOverlap(obj, mouseCamera, offsetX, offsetY)
	offsetX = offsetX or 0
	offsetY = offsetY or 0
	local overlapX = (getMouseX(mouseCamera) + offsetX) >= getProperty(obj .. '.x') and (getMouseX(mouseCamera) + offsetX) <= getProperty(obj .. '.x') + getProperty(obj .. '.width')
	local overlapY = (getMouseY(mouseCamera) + offsetY) >= getProperty(obj .. '.y') and (getMouseY(mouseCamera) + offsetY) <= getProperty(obj .. '.y') + getProperty(obj .. '.height')
	return overlapX and overlapY
end
function m.soundLoad(tag, path, loop)
	loop = loop or false
	addHaxeLibrary('FlxSound', 'flixel.system')
	runHaxeCode([[
		if (Paths.fileExists('sounds/]] .. path .. [[.ogg')) {
			var a = new FlxSound().loadEmbedded(Paths.sound(']] .. path .. [['), ]] .. tostring(loop) .. [[);
			FlxG.sound.list.add(a);
			a.pitch = game.playbackRate;
			game.modchartSounds.set(']] .. tag .. [[', a);
		} else game.addTextToDebug('soundLoad: Sound file "]] .. path .. [[" was not found.', 0xFFFF0000);
	]])
	return tag
end
function m.soundPlay(tag, forceRestart, volume)
	forceRestart = forceRestart or true
	volume = volume or 1
	addHaxeLibrary('FlxSound', 'flixel.system')
	runHaxeCode([[
		var a = game.modchartSounds.get(']] .. tag .. [[');
		if (game.modchartSounds.exists(']] .. tag .. [[')) {
			a.volume = ]] .. volume .. [[;
			a.play(]] .. tostring(forceRestart) .. [[);
		}
		else game.addTextToDebug('soundPlay: Sound tag "]] .. tag .. [[" was not found.', 0xFFFF0000);
	]])
	return tag
end
function m.soundStop(tag)
	addHaxeLibrary('FlxSound', 'flixel.system')
	runHaxeCode([[
		var a = game.modchartSounds.get(']] .. tag .. [[');
		if (game.modchartSounds.exists(']] .. tag .. [[')) a.stop();
		else game.addTextToDebug('soundStop: Sound tag "]] .. tag .. [[" was not found.', 0xFFFF0000);
	]])
	return tag
end
function m.soundPause(tag)
	addHaxeLibrary('FlxSound', 'flixel.system')
	runHaxeCode([[
		var a = game.modchartSounds.get(']] .. tag .. [[');
		if (game.modchartSounds.exists(']] .. tag .. [[')) a.pause();
		else game.addTextToDebug('soundPause: Sound tag "]] .. tag .. [[" was not found.', 0xFFFF0000);
	]])
	return tag
end
function m.soundResume(tag)
	addHaxeLibrary('FlxSound', 'flixel.system')
	runHaxeCode([[
		var a = game.modchartSounds.get(']] .. tag .. [[');
		if (game.modchartSounds.exists(']] .. tag .. [[')) a.resume();
		else game.addTextToDebug('soundResume: Sound tag "]] .. tag .. [[" was not found.', 0xFFFF0000);
	]])
	return tag
end

return m