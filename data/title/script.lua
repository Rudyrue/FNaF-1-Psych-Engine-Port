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
	end,
	['customNightAlpha'] = function() setProperty('camOther.visible', false) end
}

curSelected = 0

freddyAi = 1
bonnieAi = 3
chicaAi = 3
foxyAi = 1

curSelectPositions = {
	[1] = {104, 407}, -- new game
	[2] = {104, 479}, -- continue
	[3] = {99, 558}, -- night 6
	[4] = {111, 626} -- custom night (isn't available as of now because sound bs)
}

substatesCreate = {
	['newGame'] = function()
		setDataFromSave('fnaf1', 'level', 1)
		setDataFromSave('fnaf1', 'night', 1)
		flushSaveData('fnaf1')

		makeLuaSprite('ad', 'fnaf1/ad/newspaper')
		addLuaSprite('ad')
		setLuaCamera('ad', 'newGame')
		setProperty('ad.alpha', 0)
		doTweenAlpha('adAlpha1', 'ad', 1, 2 / playbackRate, 'linear')

		runTimer('ad', 5 / playbackRate)
	end,
	['customNight'] = function() -- i love spaghetti
		makeLuaSprite('bg')
		makeGraphic('bg', screenWidth, screenHeight, '000000')
		addLuaSprite('bg')
		setLuaCamera('bg', 'customNight')

		makeLuaSprite('customizeNight', 'fnaf1/custom night/customizeNight', 450, 40)
		addLuaSprite('customizeNight')
		setLuaCamera('customizeNight', 'customNight')

		makeLuaSprite('freddySpr', 'fnaf1/custom night/freddy', 118, 187)
		addLuaSprite('freddySpr')
		setLuaCamera('freddySpr', 'customNight')

		makeLuaSprite('bonnieSpr', 'fnaf1/custom night/bonnie', 403, 187)
		addLuaSprite('bonnieSpr')
		setLuaCamera('bonnieSpr', 'customNight')

		makeLuaSprite('chicaSpr', 'fnaf1/custom night/chica', 682, 187)
		addLuaSprite('chicaSpr')
		setLuaCamera('chicaSpr', 'customNight')

		makeLuaSprite('foxySpr', 'fnaf1/custom night/foxy', 957, 187)
		addLuaSprite('foxySpr')
		setLuaCamera('foxySpr', 'customNight')

		makeLuaSprite('freddyTxt', 'fnaf1/custom night/freddyTxt', 145, 119)
		addLuaSprite('freddyTxt')
		setLuaCamera('freddyTxt', 'customNight')

		makeLuaSprite('bonnieTxt', 'fnaf1/custom night/bonnieTxt', 429, 119)
		addLuaSprite('bonnieTxt')
		setLuaCamera('bonnieTxt', 'customNight')

		makeLuaSprite('chicaTxt', 'fnaf1/custom night/chicaTxt', 716, 119)
		addLuaSprite('chicaTxt')
		setLuaCamera('chicaTxt', 'customNight')
		
		makeLuaSprite('foxyTxt', 'fnaf1/custom night/foxyTxt', 1009, 121)
		addLuaSprite('foxyTxt')
		setLuaCamera('foxyTxt', 'customNight')

		makeLuaSprite('freddyAiLvlTxt', 'fnaf1/custom night/aiLvl', 118, 425)
		addLuaSprite('freddyAiLvlTxt')
		setLuaCamera('freddyAiLvlTxt', 'customNight')

		makeLuaSprite('bonnieAiLvlTxt', 'fnaf1/custom night/aiLvl', 402, 425)
		addLuaSprite('bonnieAiLvlTxt')
		setLuaCamera('bonnieAiLvlTxt', 'customNight')

		makeLuaSprite('chicaAiLvlTxt', 'fnaf1/custom night/aiLvl', 684, 425)
		addLuaSprite('chicaAiLvlTxt')
		setLuaCamera('chicaAiLvlTxt', 'customNight')

		makeLuaSprite('foxyAiLvlTxt', 'fnaf1/custom night/aiLvl', 960, 425)
		addLuaSprite('foxyAiLvlTxt')
		setLuaCamera('foxyAiLvlTxt', 'customNight')

		makeLuaSprite('freddyLeft', 'fnaf1/custom night/btnLeft', 117, 470)
		addLuaSprite('freddyLeft')
		setLuaCamera('freddyLeft', 'customNight')

		makeLuaSprite('freddyRight', 'fnaf1/custom night/btnRight', 283, 470)
		addLuaSprite('freddyRight')
		setLuaCamera('freddyRight', 'customNight')

		makeLuaSprite('bonnieLeft', 'fnaf1/custom night/btnLeft', 401, 470)
		addLuaSprite('bonnieLeft')
		setLuaCamera('bonnieLeft', 'customNight')

		makeLuaSprite('bonnieRight', 'fnaf1/custom night/btnRight', 565, 470)
		addLuaSprite('bonnieRight')
		setLuaCamera('bonnieRight', 'customNight')

		makeLuaSprite('chicaLeft', 'fnaf1/custom night/btnLeft', 685, 470)
		addLuaSprite('chicaLeft')
		setLuaCamera('chicaLeft', 'customNight')

		makeLuaSprite('chicaRight', 'fnaf1/custom night/btnRight', 848, 470)
		addLuaSprite('chicaRight')
		setLuaCamera('chicaRight', 'customNight')

		makeLuaSprite('foxyLeft', 'fnaf1/custom night/btnLeft', 964, 470)
		addLuaSprite('foxyLeft')
		setLuaCamera('foxyLeft', 'customNight')

		makeLuaSprite('foxyRight', 'fnaf1/custom night/btnRight', 1126, 470)
		addLuaSprite('foxyRight')
		setLuaCamera('foxyRight', 'customNight')

		makeLuaText('freddyAiLvl', freddyAi, 250, 20, 470)
		setTextFont('freddyAiLvl', 'aiLvlFont.ttf')
		setTextAlignment('freddyAiLvl', 'right')
		setTextSize('freddyAiLvl', 48)
		setTextBorder('freddyAiLvl', 0, '0x0')
		addLuaText('freddyAiLvl')
		setLuaCamera('freddyAiLvl', 'customNight')

		makeLuaText('bonnieAiLvl', bonnieAi, 250, 303, 470)
		setTextFont('bonnieAiLvl', 'aiLvlFont.ttf')
		setTextAlignment('bonnieAiLvl', 'right')
		setTextSize('bonnieAiLvl', 48)
		setTextBorder('bonnieAiLvl', 0, '0x0')
		addLuaText('bonnieAiLvl')
		setLuaCamera('bonnieAiLvl', 'customNight')

		makeLuaText('chicaAiLvl', chicaAi, 250, 585, 470)
		setTextFont('chicaAiLvl', 'aiLvlFont.ttf')
		setTextAlignment('chicaAiLvl', 'right')
		setTextSize('chicaAiLvl', 48)
		setTextBorder('chicaAiLvl', 0, '0x0')
		addLuaText('chicaAiLvl')
		setLuaCamera('chicaAiLvl', 'customNight')

		makeLuaText('foxyAiLvl', foxyAi, 250, 864, 470)
		setTextFont('foxyAiLvl', 'aiLvlFont.ttf')
		setTextAlignment('foxyAiLvl', 'right')
		setTextSize('foxyAiLvl', 48)
		setTextBorder('foxyAiLvl', 0, '0x0')
		addLuaText('foxyAiLvl')
		setLuaCamera('foxyAiLvl', 'customNight')

		makeLuaSprite('difficulties', 'fnaf1/custom night/difficulties', 116, 654)
		addLuaSprite('difficulties')
		setLuaCamera('difficulties', 'customNight')

		makeLuaSprite('ready', 'fnaf1/custom night/ready', 1049, 628)
		addLuaSprite('ready')
		setLuaCamera('ready', 'customNight')

		doTweenAlpha('customNightAlpha', 'customNight', 1, 0.56 / playbackRate, 'linear')
	end
}

substatesUpdate = {
	['newGame'] = function()
		if (keyboardJustPressed('ENTER') or mouseClicked()) and not luaTweenExists('adAlpha2') and getProperty('ad.alpha') == 1 then 
			cancelTimer('ad')
			doTweenAlpha('adAlpha2', 'ad', 0, 2 / playbackRate, 'linear') 
		end

		if keyboardJustPressed('ESCAPE') then
			closeCustomSubstate()
			exitSong()
		end
	end,
	['customNight'] = function()
		if keyboardJustPressed('ESCAPE') then
			closeCustomSubstate()
			exitSong()
		end

		if not luaTweenExists('customNightAlpha') then
			if ((funcs.mouseOverlap('freddyLeft') or funcs.mouseOverlap('freddyRight')) and mouseClicked()) then
				if funcs.mouseOverlap('freddyLeft') then freddyAi = freddyAi - 1
				else freddyAi = freddyAi + 1 end
			end

			if freddyAi > 20 then freddyAi = 20
			elseif freddyAi < 0 then freddyAi = 0 end

			setTextString('freddyAiLvl', freddyAi)

			if ((funcs.mouseOverlap('bonnieLeft') or funcs.mouseOverlap('bonnieRight')) and mouseClicked()) then
				if funcs.mouseOverlap('bonnieLeft') then bonnieAi = bonnieAi - 1
				else bonnieAi = bonnieAi + 1 end
			end

			if bonnieAi > 20 then bonnieAi = 20
			elseif bonnieAi < 0 then bonnieAi = 0 end

			setTextString('bonnieAiLvl', bonnieAi)

			if ((funcs.mouseOverlap('chicaLeft') or funcs.mouseOverlap('chicaRight')) and mouseClicked()) then
				if funcs.mouseOverlap('chicaLeft') then chicaAi = chicaAi - 1
				else chicaAi = chicaAi + 1 end
			end

			if chicaAi > 20 then chicaAi = 20
			elseif chicaAi < 0 then chicaAi = 0 end

			setTextString('chicaAiLvl', chicaAi)

			if ((funcs.mouseOverlap('foxyLeft') or funcs.mouseOverlap('foxyRight')) and mouseClicked()) then
				if funcs.mouseOverlap('foxyLeft') then foxyAi = foxyAi - 1
				else foxyAi = foxyAi + 1 end
			end

			if foxyAi > 20 then foxyAi = 20
			elseif foxyAi < 0 then foxyAi = 0 end

			setTextString('foxyAiLvl', foxyAi)

			if funcs.mouseOverlap('ready') and mouseClicked() then
				if freddyAi == 1 and bonnieAi == 9 and chicaAi == 8 and foxyAi == 7 then
					loadSong('golden-freddy')
					return
				end

				setDataFromSave('fnaf1', 'night', 7)
				flushSaveData('fnaf1')

				loadSong('what-day')
			end
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

	if getDataFromSave('fnaf1', 'night', 1) > 5 then setDataFromSave('fnaf1', 'night', 5) end
	flushSaveData('fnaf1')

	makeCamera('newGame')
	makeCamera('customNight')
	setProperty('customNight.alpha', 0)

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
	setProperty('night6.visible', getDataFromSave('fnaf1', 'beatGame', false))

	makeLuaSprite('customNightTxt', 'fnaf1/title/custom night', 171, 617)
	addLuaSprite('customNightTxt')
	setObjectCamera('customNightTxt', 'other')
	setProperty('customNightTxt.visible', getDataFromSave('fnaf1', 'beatNight6', false))

	makeLuaSprite('star1', 'fnaf1/title/star', 172, 311)
	addLuaSprite('star1')
	setObjectCamera('star1', 'other')
	setProperty('star1.visible', getDataFromSave('fnaf1', 'beatGame', false))

	makeLuaSprite('star2', 'fnaf1/title/star', 249, 311)
	addLuaSprite('star2')
	setObjectCamera('star2', 'other')
	setProperty('star2.visible', getDataFromSave('fnaf1', 'beatNight6', false))

	makeLuaSprite('star3', 'fnaf1/title/star', 324, 311)
	addLuaSprite('star3')
	setObjectCamera('star3', 'other')
	setProperty('star3.visible', getDataFromSave('fnaf1', 'beatCustom', false))

	makeLuaSprite('nightTxt', 'fnaf1/title/night', getProperty('continue.x') + 2, getProperty('continue.y') + 42)
	addLuaSprite('nightTxt')
	setObjectCamera('nightTxt', 'other')
	setProperty('nightTxt.visible', false)

	makeLuaText('night', getDataFromSave('fnaf1', 'level', 1), 0, getProperty('nightTxt.x') + 70, getProperty('nightTxt.y') - 11)
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
	soundLoad('static', 'fnaf1/title/static2')
	soundLoad('select', 'fnaf1/title/blip3')
	soundPlay('music')
	soundPlay('static')

	runTimer('staticAlpha', 0.09 / playbackRate, 0)
	runTimer('fredAlpha', 0.3 / playbackRate, 0)
	runTimer('fredGlitch', 0.08 / playbackRate, 0)
end

function onUpdate(elapsed)
	if keyboardJustPressed('Z') then loadSong('what-day') end

	if fred.valueA == 99 then setProperty('fred.animation.curAnim.curFrame', 3)
	elseif fred.valueA == 98 then setProperty('fred.animation.curAnim.curFrame', 2)
	elseif fred.valueA == 97 then setProperty('fred.animation.curAnim.curFrame', 1)
	elseif fred.valueA < 97 then setProperty('fred.animation.curAnim.curFrame', 0) end

	setProperty('line.y', getProperty('line.y') + (0.5 * playbackRate))
	if getProperty('line.y') > screenHeight then setProperty('line.y', -35) end

	setProperty('blip.visible', blip.valueA == 1)

	if keyboardJustPressed('UP') or keyboardJustPressed('DOWN') then changeSelection(keyboardJustPressed('UP') and -1 or 1) end

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
		
	mouseOverlapNight6 = funcs.mouseOverlap('night6') and getProperty('night6.visible')
	if not mouseOverlapNight6 and night6OptionCooldown >= 0 then night6OptionCooldown = (night6OptionCooldown - elapsed) end
	if mouseOverlapNight6 and night6OptionCooldown <= 0 and curSelected ~= 2 then 
		night6OptionCooldown = 0.1
		curSelected = 2
		changeSelection()
	end
		
	mouseOverlapCustomNight = funcs.mouseOverlap('customNightTxt') and getProperty('customNightTxt.visible')
	if not mouseOverlapCustomNight and customNightOptionCooldown >= 0 then customNightOptionCooldown = (customNightOptionCooldown - elapsed) end
	if mouseOverlapCustomNight and customNightOptionCooldown <= 0 and curSelected ~= 3 then 
		customNightOptionCooldown = 0.1
		curSelected = 3
		changeSelection()
	end

	if keyboardJustPressed('ENTER') or ((mouseOverlapNewGame or mouseOverlapContinue or mouseOverlapNight6 or mouseOverlapCustomNight) and mouseClicked()) then 
		funcs.switch(curSelected, {
			[0] = function() openCustomSubstate('newGame', true) end, -- new game
			[1] = function() -- continue
				setDataFromSave('fnaf1', 'night', getDataFromSave('fnaf1', 'level', 1))
				loadSong('what-day')
				soundStop('music')
				soundStop('static')
			end,
			[2] = function() -- 6th night
				setDataFromSave('fnaf1', 'night', 6)
				loadSong('what-day')
				soundStop('music')
				soundStop('static')
			end,
			[3] = function() openCustomSubstate('customNight', true) end -- custom night
		})
	end
end

function changeSelection(dir)
	dir = dir or 0
	curSelected = curSelected + dir

	if curSelected < 0 then
		if not getDataFromSave('fnaf1', 'beatGame', false) then curSelected = 1
		elseif not getDataFromSave('fnaf1', 'beatNight6', false) then curSelected = 2
		else curSelected = 3 end 
	elseif (curSelected > 1 and not getProperty('night6.visible')) or (curSelected > 2 and not getProperty('customNightTxt.visible')) or curSelected > 3 then curSelected = 0 end

	setProperty('nightTxt.visible', curSelected == 1)
	setProperty('night.visible', curSelected == 1)

	setProperty('curSelect.x', curSelectPositions[curSelected + 1][1])
	setProperty('curSelect.y', curSelectPositions[curSelected + 1][2])

	soundPlay('select', true)
end

function onCustomSubstateCreate(t) if substatesCreate[t] then substatesCreate[t]() end end
function onCustomSubstateUpdate(t) if substatesUpdate[t] then substatesUpdate[t]() end end
function onTimerCompleted(t) if timers[t] then timers[t]() end end
function onTweenCompleted(t) if tweens[t] then tweens[t]() end end