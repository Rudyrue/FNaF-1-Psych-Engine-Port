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