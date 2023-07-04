function onCreatePost()
	addHaxeLibrary('FlxSound', 'flixel.system')
	setProperty('camGame.visible', false)
	setProperty('camHUD.visible', false)

	runHaxeCode([[
		game.addTextToDebug('wasd', 0xFFFFFFFF);
	]])
end

function soundStop(tag)
	runHaxeCode([[
		var a = game.modchartSounds.get(']] .. tag .. [[');
		if (game.modchartSounds.exists(']] .. tag .. [[')) a.stop();
		else game.addTextToDebug('soundStop: Sound tag "]] .. tag .. [[" was not found.', 0xFFFF0000);
	]])
end