camSprites = {
	[1] = {
		{{'Default'}, {'Blank'}, {'EasterEgg'}, {'NoBonnie'}, {'NoChica'}, {'OnlyFreddy'}}
	},
	[2] = {
		{{'Default'}, {'Bonnie'}, {'Chica'}, {'Freddy'}}
	},
	[3] = {
		{{'Default', 45, true}, {'Bonnie', 45, true}, {'Foxy', 30}}
	},
	[4] = {
		{{'Default'}, {'Chica'}, {'EasterEgg'}, {'Freddy'}}
	},
	[5] = {
		{{'Default'}, {'Bonnie'}, {'EasterEgg'}}
	}, -- skipping cam 6 cuz it's just pitch black
	[7] = {
		{{'Default'}, {'Chica'}, {'Freddy'}}
	},
	[8] = {
		{{'Default'}, {'Bonnie'}, {'EasterEgg'}}
	},
	[9] = {
		{{'Default'}, {'Bonnie'}}
	},
	[10] = {
		{{'Default'}, {'Chica'}, {'Freddy'}, {'EasterEgg'}}
	},
	[11] = {
		{{''}, {'EasterEgg'}}
	}
}

camButtons = {
	--[[ 
		[cam] = {
			['button'] = {x, y},
			['buttonTextOffset'] = {x, y}
		}
	]]
	
	[1] = {
		['but'] = {954, 334},
		['txtOffset'] = {8, 7}
	},
	[2] = {
		['but'] = {934, 390},
		['txtOffset'] = {6, 7}
	},
	[3] = {
		['but'] = {954, 584},
		['txtOffset'] = {7, 6}
	},
	[4] = {
		['but'] = {1060, 585},
		['txtOffset'] = {7, 7}
	},
	[5] = {
		['but'] = {828, 417},
		['txtOffset'] = {7, 7}
	},
	[6] = {
		['but'] = {1157, 549},
		['txtOffset'] = {7, 7}
	},
	[7] = {
		['but'] = {1166, 418},
		['txtOffset'] = {7, 6}
	},
	[8] = {
		['but'] = {954, 624},
		['txtOffset'] = {7, 6}
	},
	[9] = {
		['but'] = {870, 566},
		['txtOffset'] = {8, 8}
	},
	[10] = {
		['but'] = {1060, 625},
		['txtOffset'] = {7, 7}
	},
	[11] = {
		['but'] = {902, 468},
		['txtOffset'] = {7, 7}
	}
}

timers = {
	['camStaticAlpha'] = function() camStatic.valueB = getRandomInt(1, 3) - 1 end,
	['minuteCounter'] = function()
		minuteCounter = minuteCounter + 1

		if minuteCounter >= 2 then
			minuteCounter = 1
			curTime = curTime + 1
			setTextString('hour', curTime)
		end

		if curTime == 6 then openCustomSubstate('win', true) end
	end,
	['powerDrain'] = function()
		if power > 0 then power = power - usage
		else
			power = 0
			blackout()
			cancelTimer('powerDrain')
		end
	end
}

tweens = {
	['winAlpha'] = function()
		setProperty('office.visible', false)
		setProperty('ui.visible', false)
		setProperty('cams.visible', false)

		setProperty('win6.visible', true)
		doTweenY('win5Y', 'win5', 186, 5, 'linear')
	end,
	['win5Y'] = function()
		soundPlay('cheer')
		win.valueA = 1
	end,
	['fadeOut'] = function() 
		closeCustomSubstate()
		if getDataFromSave('fnaf1', 'night', 1) - 1 == 5 then loadSong('ending-1')
		elseif getDataFromSave('fnaf1', 'night', 1) - 1 == 6 then loadSong('ending-2')
		elseif getDataFromSave('fnaf1', 'night', 1) - 1 == 7 then loadSong('ending-3')
		else loadSong('what-day') end
	end
}

substatesCreate = {
	['win'] = function()
		runHaxeCode('for (a in game.modchartSounds) a.stop()')
		soundPlay('chimes')

		if getDataFromSave('fnaf1', 'level', 1) < 5 then setDataFromSave('fnaf1', 'level', getDataFromSave('fnaf1', 'level', 1) + 1) end
		if getDataFromSave('fnaf1', 'night', 1) < 7 then setDataFromSave('fnaf1', 'night', getDataFromSave('fnaf1', 'night', 1) + 1) end

		makeLuaSprite('winBg')
		makeGraphic('winBg', screenWidth, screenHeight, '000000')
		addLuaSprite('winBg')
		setLuaCamera('winBg', 'win')

		makeLuaSprite('win5', 'fnaf1/win/5', 549, 298)
		addLuaSprite('win5')
		setLuaCamera('win5', 'win')

		makeLuaSprite('win6', 'fnaf1/win/6')
		addLuaSprite('win6')
		setLuaCamera('win6', 'win')
		setProperty('win6.visible', false)

		makeLuaSprite('winAM', 'fnaf1/win/am', 645, 296)
		addLuaSprite('winAM')
		setLuaCamera('winAM', 'win')

		makeLuaSprite('winTop', nil, 498, 169)
		makeGraphic('winTop', 158, 118, '000000')
		addLuaSprite('winTop')
		setLuaCamera('winTop', 'win')

		makeLuaSprite('winBottom', nil, 499, 385)
		makeGraphic('winBottom', 158, 118, '000000')
		addLuaSprite('winBottom')
		setLuaCamera('winBottom', 'win')

		doTweenAlpha('winAlpha', 'win', 1, 1, 'linear')
	end
}

substatesUpdate = {
	['win'] = function()
		setProperty('win6.x', getProperty('win5.x') + 4)
		setProperty('win6.y', getProperty('win5.y') + 110)

		if win.valueA == 1 then win.valueB = win.valueB + 1 end

		if win.valueB > 200 and not luaTweenExists('fadeOut') then
			setProperty('win5.visible', false)
			doTweenAlpha('fadeOut', 'win', 0, 0.9, 'linear')
		end

		if keyboardJustPressed('ESCAPE') then
			closeCustomSubstate()
			exitSong()
		end
	end
}

win = {
	valueA,
	valueB = 0
}

camStatic = {
	valueA,
	valueB
}

camsScroll = {
	valueA = 0,
	valueB = 0
}

night = {
	loadedLevel = 0,
	nightNumber = 0
}

gameplayAssets = 'fnaf1/gameplay/'

--[[
	camera ids
	1 = show stage
	2 = dining area
	3 = west hall
	4 = east hall
	5 = backstage
	6 = kitchen
	7 = restrooms
	8 = west hall corner (originally 22)
	9 = supply closet (originally 33)
	10 = east hall corner (originally 42)
	11 = pirate's cove (originally 99)
]]

camsActive = false
canFlip = true

powerDown = false

lastCam = nil
curCam = 1

leftDoorActive = false
rightDoorActive = false

leftLightActive = false
rightLightActive = false

usage = 1

curTime = 0
minuteCounter = 0

power = 999

function onCreatePost()
	luaDebugMode = true
	funcs = require('mods/' .. (currentModDirectory ~= nil and (currentModDirectory .. '/')) .. 'extraFuncs')
	makeCamera('office')
	makeCamera('cams')
	setProperty('cams.alpha', 0.0001)
	makeCamera('ui')
	makeCamera('win')
	setProperty('win.alpha', 0)

	makeAnimatedLuaSprite('officeSpr', gameplayAssets .. 'office/office')
	addAnimationByPrefix('officeSpr', 'default', 'default', 0, false)
	addAnimationByPrefix('officeSpr', 'lightLeft', 'lightLeft', 0, false)
	addAnimationByPrefix('officeSpr', 'lightRight', 'lightRight', 0, false)
	addAnimationByPrefix('officeSpr', 'blackout', 'blackout', 0, false)
	addLuaSprite('officeSpr')
	setLuaCamera('officeSpr', 'office')

	makeAnimatedLuaSprite('fan', gameplayAssets .. 'office/fan', 780, 303)
	addAnimationByPrefix('fan', 'a', 'fan', 0)
	addLuaSprite('fan')
	setLuaCamera('fan', 'office')
	setProperty('fan.animation.curAnim.frameRate', 59.4)
	playAnim('fan', 'a', true)

	makeLuaSprite('freddyNose', nil, 674, 236)
	makeGraphic('freddyNose', 8, 8, 'FF0000')

	makeAnimatedLuaSprite('leftDoor', gameplayAssets .. 'office/leftDoor', 72)
	addAnimationByPrefix('leftDoor', 'a', 'down', 0, false) -- fix for sm playing the object's anim on addAnimMethod functions
	addAnimationByPrefix('leftDoor', 'down', 'down', 30, false)
	addAnimationByPrefix('leftDoor', 'up', 'up', 30, false)
	addLuaSprite('leftDoor')
	setLuaCamera('leftDoor', 'office')

	makeAnimatedLuaSprite('rightDoor', gameplayAssets .. 'office/rightDoor', 1270, -2)
	addAnimationByPrefix('rightDoor', 'a', 'down', 0, false) -- fix for sm playing the object's anim on addAnimMethod functions
	addAnimationByPrefix('rightDoor', 'down', 'down', 30, false)
	addAnimationByPrefix('rightDoor', 'up', 'up', 30, false)
	addLuaSprite('rightDoor')
	setLuaCamera('rightDoor', 'office')

	makeLuaSprite('officeButtonLeft', nil, 6, 263) -- left light button
	loadGraphic('officeButtonLeft', gameplayAssets .. 'office/leftButtons', 92, 247)
	addAnimation('officeButtonLeft', 'a', {0,1,2,3}, 0, false)
	addLuaSprite('officeButtonLeft')
	setLuaCamera('officeButtonLeft', 'office')

	makeLuaSprite('doorLeftButton', nil, 25, 251)
	makeGraphic('doorLeftButton', 62, 120, 'B30000')

	makeLuaSprite('lightLeftButton', nil, 25, 393)
	makeGraphic('lightLeftButton', 62, 120, 'B30000')

	makeLuaSprite('officeButtonRight', nil, 1497, 273) -- right light button
	loadGraphic('officeButtonRight', gameplayAssets .. 'office/rightButtons', 92, 247)
	addAnimation('officeButtonRight', 'a', {0,1,2,3}, 0, false)
	addLuaSprite('officeButtonRight')
	setLuaCamera('officeButtonRight', 'office')

	makeLuaSprite('doorRightButton', nil, 1519, 267)
	makeGraphic('doorRightButton', 62, 120, 'B30000')

	makeLuaSprite('lightRightButton', nil, 1519, 398)
	makeGraphic('lightRightButton', 62, 120, 'B30000')

	for cam = 1, #camSprites do 
		if cam ~= 6 then
			makeAnimatedLuaSprite('cam' .. cam, gameplayAssets .. 'cams/cam' .. cam)
			for i = 1, #camSprites[cam][1] do
				framerate = camSprites[cam][1][i][2] or 0
				loop = camSprites[cam][1][i][3] or false
				
				addAnimationByPrefix('cam' .. cam, camSprites[cam][1][i][1], 'cam' .. cam .. camSprites[cam][1][i][1], framerate, loop)
			end
			addLuaSprite('cam' .. cam)
			setProperty('cam' .. cam .. '.alpha', 0.0001)
			setLuaCamera('cam' .. cam, 'cams')                         
		end
	end

	makeAnimatedLuaSprite('camStatic', gameplayAssets .. 'ui/camStatic')
	addAnimationByPrefix('camStatic', 'a', 'Stopped', 60)
	addLuaSprite('camStatic')
	setLuaCamera('camStatic', 'cams')

	makeLuaSprite('camBorder', gameplayAssets .. 'ui/camBorder', 0, -1)
	addLuaSprite('camBorder')
	setLuaCamera('camBorder', 'cams')

	makeAnimatedLuaSprite('map', gameplayAssets .. 'ui/map', 848, 313)
	addAnimationByPrefix('map', 'a', 'Stopped', 0)
	setProperty('map.animation.curAnim.frameRate', 1.2)
	addLuaSprite('map')
	playAnim('map', 'a', true)
	setLuaCamera('map', 'cams')

	makeAnimatedLuaSprite('camTxt', gameplayAssets .. 'ui/camTxt', 832, 292)
	for i = 1, 11 do addAnimationByPrefix('camTxt', i, i .. ' cam', 0, false) end
	addLuaSprite('camTxt')
	setLuaCamera('camTxt', 'cams')

	makeAnimatedLuaSprite('redCirc', gameplayAssets .. 'ui/redCirc', 68, 52)
	addAnimationByPrefix('redCirc', 'a', 'Stopped', 0)
	addLuaSprite('redCirc')
	setProperty('redCirc.animation.curAnim.frameRate', 1.2)
	setLuaCamera('redCirc', 'cams')
	playAnim('redCirc', 'a', true)

	makeAnimatedLuaSprite('camBlip', gameplayAssets .. 'ui/camBlip')
	addAnimationByPrefix('camBlip', 'a', 'Stopped', 42, false)
	addLuaSprite('camBlip')
	setLuaCamera('camBlip', 'cams')
	runHaxeCode([[
		var camBlip = game.getLuaObject('camBlip', false);

		camBlip.animation.finishCallback = _ -> camBlip.visible = false;
	]])

	for i = 1, #camButtons do
		makeAnimatedLuaSprite('camBut' .. i, gameplayAssets .. 'ui/cam', camButtons[i]['but'][1], camButtons[i]['but'][2])
		addAnimationByPrefix('camBut' .. i, 'default', 'Stopped', 0, false)
		addAnimationByPrefix('camBut' .. i, 'selected', 'User Defined 12', 0) -- 1.8 fps
		addLuaSprite('camBut' .. i)
		setLuaCamera('camBut' .. i, 'cams')

		makeLuaSprite('camButTxt' .. i, gameplayAssets .. 'ui/cam' .. i, getProperty('camBut' .. i .. '.x') + camButtons[i]['txtOffset'][1], getProperty('camBut' .. i .. '.y') +  camButtons[i]['txtOffset'][2])
		addLuaSprite('camButTxt' .. i)
		setLuaCamera('camButTxt' .. i, 'cams')
	end

	makeLuaSprite('officeScroll')
	screenCenter('officeScroll')
	runHaxeCode('getVar("office").follow(game.getLuaObject("officeScroll", false))')

	makeLuaSprite('camsScroll')

	makeLuaSprite('flipUp', nil, 75, 653)
	makeGraphic('flipUp', 792, 638, '7B2B7F')
	
	makeLuaSprite('flipDown', nil, 93, 561)
	makeGraphic('flipDown', 1070, 82, '7B2B7F')

	makeLuaSprite('camsButton', gameplayAssets .. 'ui/camsButton', 255, 638)
	addLuaSprite('camsButton')
	setLuaCamera('camsButton', 'ui')

	makeAnimatedLuaSprite('usageMeter', gameplayAssets .. 'ui/usageMeter', 120, 657)
	addAnimationByPrefix('usageMeter', 'a', 'meter', 0, false)
	addLuaSprite('usageMeter')
	setLuaCamera('usageMeter', 'ui')

	makeAnimatedLuaSprite('camMonitor', gameplayAssets .. 'ui/camMonitor')
	addAnimationByPrefix('camMonitor', 'up', 'up', 30, false)
	addAnimationByPrefix('camMonitor', 'down', 'down', 30, false)
	addLuaSprite('camMonitor')
	setLuaCamera('camMonitor', 'ui')
	setProperty('camMonitor.visible', false)

	makeLuaSprite('amTxt', gameplayAssets .. 'ui/am', 1200, 31)
	addLuaSprite('amTxt')
	setLuaCamera('amTxt', 'ui')

	makeLuaSprite('night', gameplayAssets .. 'ui/night', 1148, 74)
	addLuaSprite('night')
	setLuaCamera('night', 'ui')

	makeLuaSprite('powerLeft', gameplayAssets .. 'ui/powerLeft', 38, 631)
	addLuaSprite('powerLeft')
	setLuaCamera('powerLeft', 'ui')

	makeLuaSprite('percentage', gameplayAssets .. 'ui/percentage', 224, 632)
	addLuaSprite('percentage')
	setLuaCamera('percentage', 'ui')

	makeLuaSprite('usage', gameplayAssets .. 'ui/usage', 38, 667)
	addLuaSprite('usage')
	setLuaCamera('usage', 'ui')

	makeLuaText('hour', '12', 300, 890, 20)
	setTextFont('hour', 'hourFont.ttf')
	setTextAlignment('hour', 'right')
	setTextSize('hour', 56)
	setTextBorder('hour', 0, '0x0')
	addLuaText('hour')
	setLuaCamera('hour', 'ui')
	
	makeLuaText('curNight', getDataFromSave('fnaf1', 'night', 1), 0, 1220, 56)
	setTextFont('curNight', 'nightNumFont.ttf')
	setTextSize('curNight', 56)
	setTextBorder('curNight', 0, '0x0')
	addLuaText('curNight')
	setLuaCamera('curNight', 'ui')

	makeLuaText('power', '99', 300, 50, 612)
	setTextFont('power', 'powerFont.ttf')
	setTextAlignment('hour', 'right')
	setTextSize('power', 56)
	setTextBorder('power', 0, '0x0')
	addLuaText('power')
	setLuaCamera('power', 'ui')

	makeLuaSprite('leftLow')
	makeGraphic('leftLow', 539, 719, '7B2B7F')

	makeLuaSprite('leftHigh')
	makeGraphic('leftHigh', 315, 719, '631763')

	makeLuaSprite('leftFast')
	makeGraphic('leftFast', 153, 728, '47074B')

	makeLuaSprite('rightLow', nil, 759, 0)
	makeGraphic('rightLow', 558, 756, '7B2B7F')

	makeLuaSprite('rightHigh', nil, 999)
	makeGraphic('rightHigh', 284, 728, '631763')

	makeLuaSprite('rightFast', nil, 1143, 3)
	makeGraphic('rightFast', 164, 728, '47074B')

	camStatic.valueB = getRandomInt(1, 3) - 1
	runHaxeCode([[
		setVar("camUsage", 0);
		setVar("leftDoorUsage", 0);
		setVar("rightDoorUsage", 0);
		setVar("leftLightUsage", 0);
		setVar("rightLightUsage", 0);
	]])
	runTimer('camStaticAlpha', 1 / playbackRate, 0)
	runTimer('minuteCounter', 1 / playbackRate, 0)
	runTimer('powerDrain', 1 / playbackRate, 0)

	soundLoad('nose', gameplayAssets .. 'freddyNose')
	soundLoad('fan', gameplayAssets .. 'fan', true)
	soundLoad('coldPresence', gameplayAssets .. 'coldPresence', true)
	soundLoad('openCam', gameplayAssets .. 'openCam')
	soundLoad('closeCam', gameplayAssets .. 'closeCam')
	soundLoad('tapeEject', gameplayAssets .. 'tapeEject')
	soundLoad('camChange', gameplayAssets .. 'camChange')
	soundLoad('door', gameplayAssets .. 'door')
	soundLoad('light', gameplayAssets .. 'light', true)
	soundLoad('powerDown', gameplayAssets .. 'powerDown')
	soundLoad('powerDownAmbience', gameplayAssets .. 'blackoutAmbience', true)

	soundLoad('chimes', 'fnaf1/win/chimes 2')
	soundLoad('cheer', 'fnaf1/win/CROWD_SMALL_CHIL_EC049202')

	soundPlay('coldPresence', false, 0.5)
	soundPlay('fan', false, 0.25)
	soundPlay('light', false, 0)
end

function onCamsOpen()
	runHaxeCode('setVar("camUsage", 1)')
	setProperty('office.visible', false)
	setProperty('cams.alpha', 1)
	setSoundVolume('fan', 0.1)
	soundPlay('tapeEject')

	doCam()
	doLight()
end

function onCamsClose()
	setProperty('cams.alpha', 0.0001)
	setProperty('office.visible', true)
	runHaxeCode('setVar("camUsage", 0)')
	setSoundVolume('fan', 0.25)
	soundStop('tapeEject')
end

function onCamsUpdate() for i = 1, #camButtons do if funcs.mouseOverlap('camBut' .. i) and mouseClicked() then doCam(i) end end end

function onUpdate()
	if not camsActive then
		if getProperty('officeScroll.x') > 640 then
			if funcs.mouseOverlap('leftLow') then setProperty('officeScroll.x', getProperty('officeScroll.x') - 2) end
			if funcs.mouseOverlap('leftHigh') then setProperty('officeScroll.x', getProperty('officeScroll.x') - 5) end
			if funcs.mouseOverlap('leftFast') then setProperty('officeScroll.x', getProperty('officeScroll.x') - 5) end
		end

		if getProperty('officeScroll.x') < 960 then
			if funcs.mouseOverlap('rightLow') then setProperty('officeScroll.x', getProperty('officeScroll.x') + 2) end
			if funcs.mouseOverlap('rightHigh') then setProperty('officeScroll.x', getProperty('officeScroll.x') + 5) end
			if funcs.mouseOverlap('rightFast') then setProperty('officeScroll.x', getProperty('officeScroll.x') + 5) end
		end

		if getProperty('officeScroll.x') < 640 then setProperty('officeScroll.x', 640)
		elseif getProperty('officeScroll.x') > 960 then setProperty('officeScroll.x', 960) end

		if funcs.mouseOverlap('freddyNose', getProperty('officeScroll.x') - 640) and mouseClicked() then soundPlay('nose', true) end

		if (funcs.mouseOverlap('doorLeftButton') or funcs.mouseOverlap('doorRightButton', getProperty('officeScroll.x') - 637)) and mouseClicked() and not powerDown then doDoor(funcs.mouseOverlap('doorLeftButton') and 'left' or 'right') end
		if (funcs.mouseOverlap('lightLeftButton') or funcs.mouseOverlap('lightRightButton', getProperty('officeScroll.x') - 637)) and mouseClicked() and not powerDown then doLight(funcs.mouseOverlap('lightLeftButton') and 'left' or 'right') end
	end

	if camsScroll.valueA == 0 then
		camsScroll.valueB = camsScroll.valueB + (1 * playbackRate)
		setProperty('camsScroll.x', getProperty('camsScroll.x') - (1 * playbackRate))

		if camsScroll.valueB >= 320 then
			camsScroll.valueA = 1
			camsScroll.valueB = 0
		end
	elseif camsScroll.valueA == 1 then
		camsScroll.valueB = camsScroll.valueB + (1 * playbackRate)

		if camsScroll.valueB >= 100 then
			camsScroll.valueA = 2
			camsScroll.valueB = 0
		end
	elseif camsScroll.valueA == 2 then
		camsScroll.valueB = camsScroll.valueB + (1 * playbackRate)
		setProperty('camsScroll.x', getProperty('camsScroll.x') + (1 * playbackRate))

		if camsScroll.valueB >= 320 then
			camsScroll.valueA = 3
			camsScroll.valueB = 0
		end
	elseif camsScroll.valueA == 3 then
		camsScroll.valueB = camsScroll.valueB + (1 * playbackRate)

		if camsScroll.valueB >= 100 then
			camsScroll.valueA = 0
			camsScroll.valueB = 0
		end
	end

	if not powerDown then
		if funcs.mouseOverlap('flipUp') and canFlip then
			camsActive = not camsActive
			doMonitor()
			canFlip = false
		elseif funcs.mouseOverlap('flipDown') then canFlip = true end
	end

	if not getProperty('camMonitor.visible') and camsActive then runHaxeCode("game.callOnLuas('onCamsUpdate', [])") end
	camStatic.valueA = 150 + (getRandomInt(1, 50) - 1) + (camStatic.valueB * 15)
	setProperty('camStatic.alpha', ctToFlixelAlpha(camStatic.valueA))

	for i = 1, #camSprites do if i ~= 6 and i ~= 9 then setProperty('cam' .. i .. '.x', getProperty('camsScroll.x')) end end
	setProperty('camsButton.visible', canFlip)
	usage = 1 + getProperty('camUsage') + getProperty('leftDoorUsage') + getProperty('rightDoorUsage') + getProperty('leftLightUsage') + getProperty('rightLightUsage')
	setProperty('usageMeter.animation.curAnim.curFrame', usage - 1)
	setTextString('power', math.floor(power / 10))
end

function doMonitor()
	setProperty('camMonitor.visible', true)
	playAnim('camMonitor', camsActive and 'up' or 'down', true)
	soundStop('openCam')
	soundPlay((camsActive and 'open' or 'close') .. 'Cam', true)

	runHaxeCode([[
		var camMonitor = game.getLuaObject('camMonitor', false);
		var camsActive:Bool = ]] .. tostring(camsActive) .. [[;
		camMonitor.animation.finishCallback = _ -> {
			camMonitor.visible = false;
			if (camsActive) game.callOnLuas('onCamsOpen', []);
		};
		if (!camsActive) game.callOnLuas('onCamsClose', []);
	]])
end

function blackout()
	powerDown = true
	soundStop('fan')
	soundStop('coldPresence')

	soundPlay('powerDown')
	soundPlay('powerDownAmbience')

	removeLuaSprite('officeButtonLeft')
	removeLuaSprite('officeButtonRight')
	removeLuaSprite('fan')
	removeLuaSprite('amTxt')
	removeLuaSprite('night')
	removeLuaSprite('camsButton')
	removeLuaSprite('powerLeft')
	removeLuaSprite('usage')
	removeLuaSprite('usageMeter')
	removeLuaSprite('percentage')

	removeLuaText('power')
	removeLuaText('hour')
	removeLuaText('curNight')
	doDoor()
	doLight()
	playAnim('officeSpr', 'blackout', true)
	if camsActive then
		camsActive = false
		doMonitor()
	end
end

function doCam(cam)
	cam = cam or curCam

	if cam ~= curCam then lastCam = curCam end
	curCam = cam
	
	if lastCam ~= nil then playAnim('camBut' .. lastCam, 'default', true) end
	if getProperty('camBut' .. cam .. '.animation.curAnim.name') ~= 'selected' then
		playAnim('camBut' .. cam, 'selected')
		setProperty('camBut' .. cam .. '.animation.curAnim.frameRate', 1.8)
		playAnim('camBut' .. cam, 'selected', true)
	end

	if lastCam ~= nil then setProperty('cam' .. lastCam .. '.alpha', 0.0001) end
	setProperty('cam' .. curCam .. '.alpha', 1)
	playAnim('camTxt', curCam, true)

	setProperty('camBlip.visible', true)
	playAnim('camBlip', 'a', true)

	soundPlay('camChange', true)
end

function doDoor(side)
	side = side or 'both'

	if side ~= 'both' then
		if side == 'left' and getProperty('leftDoor.animation.curAnim.finished') then
			leftDoorActive = not leftDoorActive
			playAnim('leftDoor', leftDoorActive and 'down' or 'up', true)
			soundPlay('door', true)
			if leftDoorActive then runHaxeCode('game.getLuaObject("leftDoor", false).animation.finishCallback = _ -> setVar("leftDoorUsage", 1);')
			elseif not leftDoorActive then 
				runHaxeCode([[
					setVar("leftDoorUsage", 0);
					game.getLuaObject('leftDoor', false).animation.finishCallback = null;
				]]) 
			end
		elseif side == 'right' and getProperty('rightDoor.animation.curAnim.finished') then
			rightDoorActive = not rightDoorActive
			playAnim('rightDoor', rightDoorActive and 'down' or 'up', true)
			soundPlay('door', true)
			if rightDoorActive then runHaxeCode('game.getLuaObject("rightDoor", false).animation.finishCallback = _ -> setVar("rightDoorUsage", 1);')
			elseif not rightDoorActive then 
				runHaxeCode([[
					setVar("rightDoorUsage", 0);
					game.getLuaObject('rightDoor', false).animation.finishCallback = null;
				]]) 
			end
		end
	else
		if leftDoorActive then playAnim('leftDoor', 'up', true) end
		if rightDoorActive then playAnim('rightDoor', 'up', true) end
		leftDoorActive = false
		rightDoorActive = false
	end

	doButton()
end

function doLight(side)
	side = side or 'both'

	if side ~= 'both' then
		if side == 'left' then
			leftLightActive = not leftLightActive
			rightLightActive = false
			playAnim('officeSpr', leftLightActive and 'lightLeft' or 'default', true)
		elseif side == 'right' then
			rightLightActive = not rightLightActive
			leftLightActive = false
			playAnim('officeSpr', rightLightActive and 'lightRight' or 'default', true)
		end
	else
		playAnim('officeSpr', 'default', true)
		leftLightActive = false
		rightLightActive = false
	end

	setSoundVolume('light', (leftLightActive or rightLightActive) and 1 or 0)

	runHaxeCode('setVar("leftLightUsage", ' .. tostring(leftLightActive) .. ' ? 1 : 0)')
	runHaxeCode('setVar("rightLightUsage", ' .. tostring(rightLightActive) .. ' ? 1 : 0)')
	doButton()
end

function doButton()
	setProperty('officeButtonLeft.animation.curAnim.curFrame', (((leftDoorActive and leftLightActive) and 3) or ((leftDoorActive and 1) or (leftLightActive and 2))) or 0)
	setProperty('officeButtonRight.animation.curAnim.curFrame', (((rightDoorActive and rightLightActive) and 3) or ((rightDoorActive and 1) or (rightLightActive and 2))) or 0)
end

function onTimerCompleted(t) if timers[t] then timers[t]() end end
function onTweenCompleted(t) if tweens[t] then tweens[t]() end end
function onCustomSubstateCreate(t) if substatesCreate[t] then substatesCreate[t]() end end
function onCustomSubstateUpdate(t) if substatesUpdate[t] then substatesUpdate[t]() end end