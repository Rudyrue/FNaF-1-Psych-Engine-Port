function onCreatePost()
	luaDebugMode = true
	initSaveData('fnaf1')
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

	addHaxeLibrary('FunkinLua')
	addHaxeLibrary('Lua_helper', 'llua')
	addHaxeLibrary('FlxSound', 'flixel.system')
	addHaxeLibrary('Math')
	runHaxeCode([[
		for(thing in game.luaArray) {
	 		Lua_helper.add_callback(thing.lua, 'soundLoad', function(tag:String, path:String, ?loop:Bool = false, ?changePitch:Bool = true) {
				if (Paths.fileExists('sounds/' + path + '.ogg')) {
					a = new FlxSound().loadEmbedded(Paths.sound(path), loop != null);
					FlxG.sound.list.add(a);
					if (changePitch || changePitch == null) a.pitch = game.playbackRate;
					game.modchartSounds.set(tag, a);
				}
			});
			Lua_helper.add_callback(thing.lua, 'soundPlay', function(tag:String, ?forceRestart:Bool = false, ?volume:Float = 1) {
				if (game.modchartSounds.exists(tag)) {
					a = game.modchartSounds.get(tag);
					a.volume = (volume != null ? volume : 1);
					a.play(forceRestart != null);
				}
			});
			Lua_helper.add_callback(thing.lua, 'soundStop', function(tag:String) {
				if (game.modchartSounds.exists(tag)) game.modchartSounds.get(tag).stop();
			});
			Lua_helper.add_callback(thing.lua, 'soundPause', function(tag:String) {
				if (game.modchartSounds.exists(tag)) game.modchartSounds.get(tag).pause();
			});
			Lua_helper.add_callback(thing.lua, 'soundResume', function(tag:String) {
				if (game.modchartSounds.exists(tag)) game.modchartSounds.get(tag).resume();
			});
			Lua_helper.add_callback(thing.lua, 'luaTweenExists', function(tag:String) { 
				return game.modchartTweens.exists(tag);
			});
			Lua_helper.add_callback(thing.lua, 'ctToFlixelAlpha', function(value:Float) {
				return 1 - (value / 255);
			});
			Lua_helper.add_callback(thing.lua, 'getTimerLength', function(tmr:String) {
				var tmr = game.modchartTimers.get(tmr);
				return game.modchartTimers.exists(tmr) ? ((tmr.progress * tmr.time) * game.playbackRate) : game.addTextToDebug('curTimerLength: Timer tag "' + tmr + '" was not found.', 0xFFFF0000);
			});
			Lua_helper.add_callback(thing.lua, 'makeCamera', function(tag:String, ?x:Float = 0, ?y:Float = 0, ?width:Int = FlxG.width, ?height:Int = FlxG.height, ?transparent:Bool = false) {
				var a = new FlxCamera(x != null ? x : 0, y != null ? y : 0, width != null ? width : FlxG.width, height != null ? height : FlxG.height, 1);
				a.follow(null);
				a.bgColor = (transparent == null ? 0xFF : 0x00) + 000000;
				FlxG.cameras.add(a);
				setVar(tag, a);
			});
			Lua_helper.add_callback(thing.lua, 'setLuaCamera', function(tag:String, camera:String) {
				var a = game.getLuaObject(tag);
				var b = getVar(camera);
		
				if (a != null || b != null) a.cameras = [b];
		
				trace('camera: ' + getVar(camera));
				trace('object: ' + a);
			});
			Lua_helper.add_callback(thing.lua, 'round', function(value:Float) {
				return Math.round(value);
			});
		}
	]])
end

function onUpdate() if keyboardJustPressed('ESCAPE') then exitSong() end end

function onDestroy()
	setPropertyFromClass("openfl.Lib", "application.window.title", "Friday Night Funkin': Psych Engine") 
	setPropertyFromClass('flixel.FlxG', 'mouse.visible', false)

	runHaxeCode([[
        var icon = Image.fromFile(Paths.modFolders('images/fnaf1/icon16.png'));
        Application.current.window.setIcon(icon);
    ]])
end

function onPause() return Function_Stop end