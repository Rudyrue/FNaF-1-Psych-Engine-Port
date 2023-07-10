fred = {
	valueA = 0
}

blip = {
	valueA = 0
}

timers = {
	['staticAlpha'] = function() setProperty('static.alpha', ctToFlixelAlpha(50 + (getRandomInt(1, 100) - 1))) end,
	['fredAlpha'] = function()
		setProperty('fred.alpha', ctToFlixelAlpha(getRandomInt(1, 250) - 1))
		blip.valueA = getRandomInt(1, 3) - 1
	end,
	['fredGlitch'] = function()
		fred.valueA = getRandomInt(1, 100) - 1
		setProperty('blip.alpha', ctToFlixelAlpha((getRandomInt(1, 100) - 1) + 100))
	end,
	['ad'] = function() doTweenAlpha('adAlpha2', 'ad', 0, 2 / playbackRate, 'linear') end
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
	[2] = {104, 479}, -- continue
	[3] = {99, 558}, -- night 6
	[4] = {111, 626} -- custom night (isn't available as of now because sound bs)
}

substatesCreate = {
	['newGame'] = function()
		makeLuaSprite('ad', 'fnaf1/ad/newspaper')
		addLuaSprite('ad')
		setLuaCamera('ad', 'newGame')
		setProperty('ad.alpha', 0)
		doTweenAlpha('adAlpha1', 'ad', 1, 2 / playbackRate, 'linear')

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

night6OptionCooldown = 0
mouseOverlapNight6 = nil

customNightOptionCooldown = 0
mouseOverlapCustomNight = nil

function onCreatePost()
	luaDebugMode = true
	funcs = require('mods/' .. (currentModDirectory ~= nil and (currentModDirectory .. '/')) .. 'extraFuncs')

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
	setProperty('line.alpha', ctToFlixelAlpha(200))

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

	makeLuaSprite('night6', 'fnaf1/title/6th night', 172, 549)
	addLuaSprite('night6')
	setObjectCamera('night6', 'other')

	makeLuaSprite('customNight', 'fnaf1/title/custom night', 171, 617)
	addLuaSprite('customNight')
	setObjectCamera('customNight', 'other')

	makeLuaSprite('star1', 'fnaf1/title/star', 172, 311)
	addLuaSprite('star1')
	setObjectCamera('star1', 'other')

	makeLuaSprite('star2', 'fnaf1/title/star', 249, 311)
	addLuaSprite('star2')
	setObjectCamera('star2', 'other')

	makeLuaSprite('star3', 'fnaf1/title/star', 324, 311)
	addLuaSprite('star3')
	setObjectCamera('star3', 'other')

	makeLuaSprite('nightTxt', 'fnaf1/title/night', getProperty('continue.x') + 2, getProperty('continue.y') + 42)
	addLuaSprite('nightTxt')
	setObjectCamera('nightTxt', 'other')
	setProperty('nightTxt.visible', false)

	makeLuaText('night', '1', 0, getProperty('nightTxt.x') + 70, getProperty('nightTxt.y') - 11)
	setTextFont('night', 'nightNumFont.ttf')
	setTextSize('night', 50)
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
	--runHaxeCode("game.modchartSounds.get('music').persist = true")
	soundLoad('static', 'fnaf1/title/static2')
	--runHaxeCode("game.modchartSounds.get('static').persist = true")
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
	mouseOverlapNewGame = funcs.mouseOverlap('newGame')
	if not mouseOverlapNewGame and newGameOptionCooldown >= 0 then newGameOptionCooldown = (newGameOptionCooldown - elapsed) end
	if mouseOverlapNewGame and newGameOptionCooldown <= 0 and curSelected ~= 0 then 
		newGameOptionCooldown = 0.1
		curSelected = 0
		changeSelection()
	end

	mouseOverlapContinue = funcs.mouseOverlap('continue')
	if not mouseOverlapContinue and continueOptionCooldown >= 0 then continueOptionCooldown = (continueOptionCooldown - elapsed) end
	if mouseOverlapContinue and continueOptionCooldown <= 0 and curSelected ~= 1 then 
		continueOptionCooldown = 0.1
		curSelected = 1
		changeSelection()
	end

	mouseOverlapNight6 = funcs.mouseOverlap('night6')
	if not mouseOverlapNight6 and night6OptionCooldown >= 0 then night6OptionCooldown = (night6OptionCooldown - elapsed) end
	if mouseOverlapNight6 and night6OptionCooldown <= 0 and curSelected ~= 2 then 
		night6OptionCooldown = 0.1
		curSelected = 2
		changeSelection()
	end

	mouseOverlapCustomNight = funcs.mouseOverlap('customNight')
	if not mouseOverlapCustomNight and customNightOptionCooldown >= 0 then customNightOptionCooldown = (customNightOptionCooldown - elapsed) end
	if mouseOverlapCustomNight and customNightOptionCooldown <= 0 and curSelected ~= 3 then 
		customNightOptionCooldown = 0.1
		curSelected = 3
		changeSelection()
	end

	if keyboardJustPressed('ENTER') or ((funcs.mouseOverlap('newGame') or funcs.mouseOverlap('continue') or funcs.mouseOverlap('night6') or funcs.mouseOverlap('customNight')) and mouseClicked()) then
		funcs.switch(curSelected, {
			[0] = function() openCustomSubstate('newGame', true) end,
			[1] = function()
				loadSong('what-day')
				soundStop('music')
				soundStop('static')
			end,
			[2] = function()
				loadSong('what-day')
				soundStop('music')
				soundStop('static')
			end--[[,
			[3] = function() loadSong('custom-night') end]]
		})
	end
end

function changeSelection(a)
	a = a or 0
	curSelected = curSelected + a
	if curSelected < 0 then curSelected = 3
	elseif curSelected > 3 then curSelected = 0 end

	setProperty('curSelect.x', curSelectPositions[curSelected + 1][1])
	setProperty('curSelect.y', curSelectPositions[curSelected + 1][2])

	setProperty('nightTxt.visible', curSelected == 1)
	setProperty('night.visible', curSelected == 1)

	soundPlay('select', true)
end

function onCustomSubstateCreate(t) if substatesCreate[t] then substatesCreate[t]() end end
function onCustomSubstateUpdate(t) if substatesUpdate[t] then substatesUpdate[t]() end end
function onTimerCompleted(t) if timers[t] then timers[t]() end end
function onTweenCompleted(t) if tweens[t] then tweens[t]() end end