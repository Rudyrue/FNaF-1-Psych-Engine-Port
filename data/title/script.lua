fred = {
	valueA = 0
}

blip = {
	valueA = 0
}

timers = {
	['staticAlpha'] = function()
		setProperty('static.alpha', clickteamToFlixelAlpha(50 + (getRandomInt(1, 100) - 1)))
	end,
	['fredAlpha'] = function()
		setProperty('fred.alpha', clickteamToFlixelAlpha(getRandomInt(1, 250) - 1))
		blip.valueA = getRandomInt(1, 3) - 1
	end,
	['fredGlitch'] = function()
		fred.valueA = getRandomInt(1, 100) - 1
		setProperty('blip.alpha', clickteamToFlixelAlpha((getRandomInt(1, 100) - 1) + 100))
	end,
	['ad'] = function() doTweenAlpha('adAlpha2', 'ad', 0, 2, 'linear') end
}

tweens = {
	['adAlpha1'] = function() setProperty('camOther.visible', false) end,
	['adAlpha2'] = function() 
		loadSong('what-day')
		soundStop('music')
		soundStop('static')
	end
}

curSelected = 0

curSelectPositions = {
	[1] = {104, 407}, -- new game
	[2] = {104, 479} -- continue
}

substatesCreate = {
	['newGame'] = function()
		makeLuaSprite('ad', 'fnaf1/ad/newspaper')
		addLuaSprite('ad')
		setLuaCamera('ad', 'newGame')
		setProperty('ad.alpha', 0)
		doTweenAlpha('adAlpha1', 'ad', 1, 2, 'linear')

		runTimer('ad', 5 / playbackRate)
	end
}

substatesUpdate = {
	['newGame'] = function()
		if (keyboardJustPressed('ENTER') or mouseClicked()) and not luaTweenExists('adAlpha2') and getProperty('ad.alpha') == 1 then 
			cancelTimer('ad')
			doTweenAlpha('adAlpha2', 'ad', 0, 2 / playbackRate, 'linear') 
		end
	end
}

newGameOptionCooldown = 0
mouseOverlapNewGame = nil

continueOptionCooldown = 0
mouseOverlapContinue = nil

function onCreatePost()
	luaDebugMode = true
	addHaxeLibrary('FlxSound', 'flixel.system')
	setPropertyFromClass('flixel.addons.transition.FlxTransitionableState', 'skipNextTransIn', true)
	setPropertyFromClass('flixel.addons.transition.FlxTransitionableState', 'skipNextTransOut', true)
	setPropertyFromClass('flixel.FlxG', 'mouse.visible', true)
	setProperty('camGame.visible', false)
	setProperty('camHUD.visible', false)

	makeCamera('newGame')

	makeAnimatedLuaSprite('fred', 'fnaf1/title/fred')
	addAnimationByPrefix('fred', 'a', 'fred', 0, false)
	addLuaSprite('fred')
	setObjectCamera('fred', 'other')

	makeAnimatedLuaSprite('static', 'fnaf1/title/static')
	addAnimationByPrefix('static', 'a', 'static', 0)
	setProperty('static.animation.curAnim.frameRate', 59.4)
	addLuaSprite('static')
	setObjectCamera('static', 'other')
	setBlendMode('static', 'ADD')
	playAnim('static', 'a', true)

	makeLuaSprite('line', 'fnaf1/title/line', 0, -35)
	addLuaSprite('line')
	setObjectCamera('line', 'other')
	setProperty('line.alpha', clickteamToFlixelAlpha(200))

	makeAnimatedLuaSprite('blip', 'fnaf1/title/blip')
	addAnimationByPrefix('blip', 'a', 'blip', 6)
	addLuaSprite('blip')
	setObjectCamera('blip', 'other')

	makeLuaSprite('logo', 'fnaf1/title/logo', 175, 79)
	addLuaSprite('logo')
	setObjectCamera('logo', 'other')

	makeLuaSprite('newGame', 'fnaf1/title/new game', 174, 404)
	addLuaSprite('newGame')
	setObjectCamera('newGame', 'other')

	makeLuaSprite('continue', 'fnaf1/title/continue', 173, 475)
	addLuaSprite('continue')
	setObjectCamera('continue', 'other')

	makeLuaSprite('nightTxt', 'fnaf1/title/night', getProperty('continue.x') + 2, getProperty('continue.y') + 42)
	addLuaSprite('nightTxt')
	setObjectCamera('nightTxt', 'other')
	setProperty('nightTxt.visible', false)

	makeLuaText('night', '1', 0, getProperty('nightTxt.x') + 70, getProperty('nightTxt.y') - 3)
	setTextFont('night', 'fnafFont.ttf')
	setTextSize('night', 35)
	setTextBorder('night', 0, '0x0')
	addLuaText('night')
	setObjectCamera('night', 'other')
	setProperty('night.visible', false)

	makeLuaSprite('version', 'fnaf1/title/version', 27, 689)
	addLuaSprite('version')
	setObjectCamera('version', 'other')

	makeLuaSprite('credits', 'fnaf1/title/credit', 1044, 691)
	addLuaSprite('credits')
	setObjectCamera('credits', 'other')

	makeLuaSprite('curSelect', 'fnaf1/title/curSelect', 104, 407)
	addLuaSprite('curSelect')
	setObjectCamera('curSelect', 'other')

	soundLoad('music', 'fnaf1/title/darkness music', true)
	runHaxeCode("game.modchartSounds.get('music').persist = true")
	soundLoad('static', 'fnaf1/title/static2')
	runHaxeCode("game.modchartSounds.get('static').persist = true")
	soundLoad('select', 'fnaf1/title/blip3')
	soundPlay('music')
	soundPlay('static')

	runTimer('staticAlpha', 0.09 / playbackRate, 0)
	runTimer('fredAlpha', 0.3 / playbackRate, 0)
	runTimer('fredGlitch', 0.08 / playbackRate, 0)
end

function onUpdate(elapsed)
	if fred.valueA == 99 then setProperty('fred.animation.curAnim.curFrame', 3)
	elseif fred.valueA == 98 then setProperty('fred.animation.curAnim.curFrame', 2)
	elseif fred.valueA == 97 then setProperty('fred.animation.curAnim.curFrame', 1)
	elseif fred.valueA < 97 then setProperty('fred.animation.curAnim.curFrame', 0) end

	setProperty('line.y', getProperty('line.y') + (0.5 * playbackRate))
	if getProperty('line.y') > screenHeight then setProperty('line.y', -35) end

	setProperty('blip.visible', blip.valueA == 1)

	if (keyJustPressed('down') or keyJustPressed('up')) then changeSelection((keyJustPressed('down') and 1) or (keyJustPressed('up') and -1)) end

	-- have to do the option shit like this because they have different x positions so i can't just do a `for` loop
	mouseOverlapNewGame = mouseOverlap('newGame', 'other')
	if not mouseOverlapNewGame and newGameOptionCooldown >= 0 then newGameOptionCooldown = (newGameOptionCooldown - elapsed) end
	if mouseOverlapNewGame and newGameOptionCooldown <= 0 and curSelected ~= 0 then 
		newGameOptionCooldown = 0.1
		curSelected = 0
		changeSelection()
	end

	mouseOverlapContinue = mouseOverlap('continue', 'other')
	if not mouseOverlapContinue and continueOptionCooldown >= 0 then continueOptionCooldown = (continueOptionCooldown - elapsed) end
	if mouseOverlapContinue and continueOptionCooldown <= 0 and curSelected ~= 1 then 
		continueOptionCooldown = 0.1
		curSelected = 1
		changeSelection()
	end

	if keyboardJustPressed('ENTER') or ((mouseOverlap('newGame', 'other') or mouseOverlap('continue', 'other')) and mouseClicked()) then
		switch(curSelected, {
			[0] = function()
				openCustomSubstate('newGame', true)
			end,
			[1] = function()
				loadSong('what-day')
				soundStop('music')
				soundStop('static')
			end
		})
	end
end

function changeSelection(a)
	a = a or 0
	curSelected = curSelected + a
	if curSelected < 0 then curSelected = 1
	elseif curSelected > 1 then curSelected = 0 end

	setProperty('curSelect.x', curSelectPositions[curSelected + 1][1])
	setProperty('curSelect.y', curSelectPositions[curSelected + 1][2])

	setProperty('nightTxt.visible', curSelected == 1)
	setProperty('night.visible', curSelected == 1)

	soundPlay('select', true)
end

function onPause() return Function_Stop end
function onCustomSubstateCreate(t) if substatesCreate[t] then substatesCreate[t]() end end
function onCustomSubstateUpdate(t) if substatesUpdate[t] then substatesUpdate[t]() end end
function luaTweenExists(tag) return runHaxeCode("return game.modchartTweens.exists('" .. tag .. "')") end
function switch(case, cases) if cases[case] ~= nil then return cases[case]() elseif cases.default ~= nil then return cases.default() end end
function clickteamToFlixelAlpha(value) return 1 - (value / 255) end
function onTimerCompleted(t) if timers[t] then timers[t]() end end
function onTweenCompleted(t) if tweens[t] then tweens[t]() end end
function mouseOverlap(obj, mouseCamera, offsetX, offsetY)
	offsetX = offsetX or 0
	offsetY = offsetY or 0
	local overlapX = (getMouseX(mouseCamera) + offsetX) >= getProperty(obj .. '.x') and (getMouseX(mouseCamera) + offsetX) <= getProperty(obj .. '.x') + getProperty(obj .. '.width')
	local overlapY = (getMouseY(mouseCamera) + offsetY) >= getProperty(obj .. '.y') and (getMouseY(mouseCamera) + offsetY) <= getProperty(obj .. '.y') + getProperty(obj .. '.height')
	return overlapX and overlapY
end
function makeCamera(tag, x, y, transparent, width, height)
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
function setLuaCamera(obj, cam)
	runHaxeCode([[
		var a = game.getLuaObject(']] .. obj .. [[');
		var b = getVar(']] .. cam .. [[');

		if (a != null || b != null) a.cameras = [b];

		trace('camera: ' + getVar(']] .. cam .. [['));
		trace('object: ' + a);
	]])
end
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