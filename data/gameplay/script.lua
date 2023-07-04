-- camera shit --
mouseOverlapCamera = nil
cameraCooldown = 0
cameraActive = false

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

lastCam = 1 -- last camera you were on
curCam = 1 -- current camera you are on
cameraButtons = { -- camera button positions need i say less
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

cameras = { -- camera sprites
	[1] = { 
		'All' 
	},
	[2] = { 
		'Default' 
	},
	[3] = { 
		'Default' 
	},
	[4] = { 
		'Default' 
	},
	[5] = { 
		'Default' 
	},
	[6] = { 
		''
	},
	[7] = {
		'Default'
	},
	[8] = {
		'Default' 
	},
	[9] = {
		'Default'
	},
	[10] = {
		'Default'
	},
	[11] = {
		'Default'
	}
}

-- time shit --
lastTimeCheck = 0
curTimeCheck = 0
curTime = nil

-- power shis
power = 999
usage = 1

leftLight = false
rightLight = false
leftDoor = false
rightDoor = false

camUsage = 0
leftDoorUsage = 0
rightDoorUsage = 0
leftLightUsage = 0
rightLightUsage = 0

died = false
staticAltValB = nil

camFollow = {
	valueA = 0,
	valueB = 0
}

-- extra script shit --
timers = {
	['clock'] = function() restartSong() end, -- when the clock hits 6 it restarts the song
	['redCircleVisible'] = function() setProperty('redCircle.visible', (not getProperty('redCircle.visible'))) end, -- the red circle thingie on the cams
	['powerDrain'] = function()
		if died then return end
		if math.floor(power / 10) >= 1 then 
			power = power - usage 
			runHaxeCode("game.callOnLuas('onPowerChange', [])")
		else die() end
	end,
	['circusSound'] = function() if getRandomInt(1, 30) == 1 then soundPlay('circus', false, 0.05) end end,
	['doorPoundingSound'] = function() if getRandomInt(1, 50) == 1 then soundPlay('doorPounding', false, 0.6) end end,
	['thing'] = function() staticAltValB = math.random(0, 3) end,
	['muteCall'] = function() setProperty('muteCall.visible', not getProperty('muteCall.visible')) end,
	['extraPowerDrain'] = function() power = power - 1 end
}

tweens = {
	['winCamAlpha1'] = function()
		setProperty('visuals.visible', false)
		setProperty('items.visible', false)
		setProperty('ui.visible', false)

		setProperty('win6.visible', true)

		doTweenY('win5Y', 'win5', 186, 5 / playbackRate, 'linear')
		soundPlay('chimes')

		if night < 5 then 
			setDataFromSave('fnaf1', 'night', getDataFromSave('fnaf1', 'night') + 1)
			setDataFromSave('fnaf1', 'realNight', getDataFromSave('fnaf1', 'realNight') + 1)
		else setDataFromSave('fnaf1', 'night', 5) end
		flushSaveData('fnaf1')
	end,
	['win5Y'] = function() 
		win.valueA = 1
		setProperty('win5.visible', false)
		soundPlay('cheer') 
	end,
	['winCamAlpha2'] = function() 
		if night == 5 then loadSong('ending-1')
		elseif night == 6 then loadSong('ending-2')
		elseif night == 7 then loadSong('ending-3')
		else loadSong('what-day') end
	end
}

win = {
	valueA = 0,
	valueB = 0
}

substatesCreate = {
	['win'] = function()
		soundStop('door')
		soundStop('camMonitor')
		if died then soundStop('powerDown')
		else 
			soundStop('bgHum')
			soundStop('deskFan')
		end
	
		soundStop('circus')
		soundStop('doorPounding')
		if cameraActive then soundStop('tapeEject') end
		if rightLight or leftLight then soundStop('light') end
		
		makeLuaSprite('winBg')
		makeGraphic('winBg', screenWidth, screenHeight, '000000')
		addLuaSprite('winBg')
		setLuaCamera('winBg', 'win')

		makeLuaSprite('win5', 'fnaf1/win/5', 549, 298)
		addLuaSprite('win5')
		setLuaCamera('win5', 'win')

		makeLuaSprite('win6', 'fnaf1/win/6', 553)
		addLuaSprite('win6')
		setLuaCamera('win6', 'win')
		setProperty('win6.visible', false)

		makeLuaSprite('winAM', 'fnaf1/win/am', 645, 296)
		addLuaSprite('winAM')
		setLuaCamera('winAM', 'win')

		makeLuaSprite('winTop', nil, 537, 175)
		makeGraphic('winTop', 158, 118, '000000')
		addLuaSprite('winTop')
		setLuaCamera('winTop', 'win')

		makeLuaSprite('winBottom', nil, 539, 385)
		makeGraphic('winBottom', 158, 118, '000000')
		addLuaSprite('winBottom')
		setLuaCamera('winBottom', 'win')

		doTweenAlpha('winCamAlpha1', 'win', 1, 1 / playbackRate, 'linear')
	end
}

substatesUpdate = {
	['win'] = function()
		setProperty('win6.y', getProperty('win5.y') + 110)
		if win.valueA == 1 then win.valueB = win.valueB + (1 * playbackRate) end
		if win.valueB > 200 and not luaTweenExists('winCamAlpha2') then doTweenAlpha('winCamAlpha2', 'win', 0, 0.9 / playbackRate, 'linear') end
	end
}

function onCreate()
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

	night =  getDataFromSave('fnaf1', getDataFromSave('fnaf1', 'realNight') < 5 and 'realNight' or 'night')
end

function onCreatePost()
	setProperty('camGame.visible', false)
	setProperty('camHUD.visible', false)

	makeCamera('visuals')
	makeCamera('items')
	makeCamera('ui')

	makeCamera('win')
	makeCamera('aSeperateCameraJustForThePauseMenuCauseItBrokeWithTheWinCameraLmfao')
	setProperty('win.alpha', 0)

	makeAnimatedLuaSprite('office', 'fnaf1/gameplay/office') -- office
	addAnimationByPrefix('office', 'default', 'officeDefault', 0, false)
	addAnimationByPrefix('office', 'lightLeft', 'officeLightLeft', 0, false)
	addAnimationByPrefix('office', 'lightRight', 'officeLightRight', 0, false)
	addAnimationByPrefix('office', 'blackout', 'officeBlackout', 0, false)
	setGraphicSize('office', 1600, screenHeight)
	addLuaSprite('office')
	setLuaCamera('office', 'visuals')

	makeAnimatedLuaSprite('desk', 'fnaf1/gameplay/desk', 780, 303) -- desk
	addAnimationByPrefix('desk', 'a', 'desk')
	addLuaSprite('desk')
	setLuaCamera('desk', 'visuals')
	setProperty('desk.animation.curAnim.frameRate', 59.4) -- because sm made the framerate thing in addAnimationByPrefix an integer and not a float
	playAnim('desk', 'a')

	makeAnimatedLuaSprite('leftDoor', 'fnaf1/gameplay/leftDoor', 70)
	addAnimationByPrefix('leftDoor', 'a', 'door', 0, false) -- fix for sm playing the object's anim on addAnimMethod functions
	addAnimationByPrefix('leftDoor', 'down', 'door', 30, false)
	addAnimationByIndices('leftDoor', 'up', 'door', '15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0', 30)
	addLuaSprite('leftDoor')
	setLuaCamera('leftDoor', 'visuals')

	makeAnimatedLuaSprite('rightDoor', 'fnaf1/gameplay/rightDoor', 1272)
	addAnimationByPrefix('rightDoor', 'a', 'door', 0, false) -- fix for sm playing the object's anim on addAnimMethod functions
	addAnimationByPrefix('rightDoor', 'down', 'door', 30, false)
	addAnimationByIndices('rightDoor', 'up', 'door', '15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0', 30)
	addLuaSprite('rightDoor')
	setLuaCamera('rightDoor', 'visuals')

	makeLuaSprite('officeButtonLeft', nil, 9, 260) -- left light button
	loadGraphic('officeButtonLeft', 'fnaf1/gameplay/leftButtons', 92, 247)
	addAnimation('officeButtonLeft', 'a', {0,1,2,3}, 0, false)
	addLuaSprite('officeButtonLeft')
	setLuaCamera('officeButtonLeft', 'visuals')

	makeLuaSprite('doorButtonLeft', nil, getProperty('officeButtonLeft.x') + 20, getProperty('officeButtonLeft.y') + 50)
	makeGraphic('doorButtonLeft', getProperty('officeButtonLeft.width') - 40, (getProperty('officeButtonLeft.height') / 2) - 66, 'FFFFFF')

	makeLuaSprite('lightButtonLeft', nil, getProperty('officeButtonLeft.x') + 20, (getProperty('officeButtonLeft.y') + (getProperty('officeButtonLeft.height') / 2)) + 10)
	makeGraphic('lightButtonLeft', getProperty('officeButtonLeft.width') - 40, (getProperty('officeButtonLeft.height') / 2) - 70, 'FFFFFF')

	makeLuaSprite('officeButtonRight', nil, 1492, 260) -- right light button
	loadGraphic('officeButtonRight', 'fnaf1/gameplay/rightButtons', 92, 247)
	addAnimation('officeButtonRight', 'a', {0,1,2,3}, 0, false)
	addLuaSprite('officeButtonRight')
	setLuaCamera('officeButtonRight', 'visuals')

	makeLuaSprite('doorButtonRight', nil, getProperty('officeButtonRight.x') + 20, getProperty('officeButtonRight.y') + 50)
	makeGraphic('doorButtonRight', getProperty('officeButtonRight.width') - 40, (getProperty('officeButtonRight.height') / 2) - 66, 'FFFFFF')

	makeLuaSprite('lightButtonRight', nil, getProperty('officeButtonRight.x') + 20, (getProperty('officeButtonRight.y') + (getProperty('officeButtonRight.height') / 2)) + 10)
	makeGraphic('lightButtonRight', getProperty('officeButtonRight.width') - 40, (getProperty('officeButtonRight.height') / 2) - 70, 'FFFFFF')

	makeLuaSprite('freddyNose', nil, 667, 235)
	makeGraphic('freddyNose', 20, 10, 'FFFFFF')

	makeLuaSprite('scroll', nil, 640, 359) -- the scroll thing that makes you go left and right
	setLuaCamera('scroll', 'visuals')

	makeLuaSprite('camsFollow')
	setLuaCamera('camsFollow', 'visuals')

	runHaxeCode('getVar("visuals").follow(game.getLuaObject("scroll", false));')

	if shadersEnabled then
		makeLuaSprite('temporaryShader')
		setSpriteShader('temporaryShader', 'shader')
		setShaderFloat('temporaryShader', 'depth', 5)
		addHaxeLibrary('ShaderFilter', 'openfl.filters')
		runHaxeCode([[
			getVar('visuals').setFilters([new ShaderFilter(game.getLuaObject('temporaryShader').shader)]);
			getVar('items').setFilters([new ShaderFilter(game.getLuaObject('temporaryShader').shader)]);
		]])
	end

	makeAnimatedLuaSprite('camera', 'fnaf1/gameplay/camMonitor', 0, 0) -- camera monitor
	addAnimationByPrefix('camera', 'a', 'monitor', 30, false)
	addAnimationByIndices('camera', 'b', 'monitor', '10,9,8,7,6,5,4,3,2,1,0', 30)
	setGraphicSize('camera', screenWidth, screenHeight)
	addLuaSprite('camera', true)
	setLuaCamera('camera', 'ui')
	setProperty('camera.visible', false)

	makeAnimatedLuaSprite('curCamSpr', 'fnaf1/gameplay/cameras/camSprites')
	addAnimationByPrefix('curCamSpr', 'cam1All', 'cam1All', 0, false)
	addAnimationByPrefix('curCamSpr', 'cam6', 'cam6', 0, false)
	addAnimationByPrefix('curCamSpr', 'cam3Default', 'cam3Default', 48)
	for i = 2, 11 do if i ~= 3 and i ~= 6 then addAnimationByPrefix('curCamSpr', 'cam' .. i .. 'Default', 'cam' .. i .. 'Default', 0, false) end end

	makeAnimatedLuaSprite('static', 'fnaf1/gameplay/static')
	addAnimationByPrefix('static', 'a', 'static', 60)
	setGraphicSize('static', screenWidth, screenHeight)

	makeLuaSprite('camBorder', 'fnaf1/gameplay/camBorder', 0, -1) -- the border on the cameras

	makeLuaSprite('map', 'fnaf1/gameplay/map', 848, 313) -- the map on the cameras
	
	for i = 1, #cameraButtons do -- all of the camera buttons
		makeAnimatedLuaSprite('cam' .. i .. 'ButtonSpr', 'fnaf1/gameplay/camButton', cameraButtons[i]['but'][1], cameraButtons[i]['but'][2])
		addAnimationByIndices('cam' .. i .. 'ButtonSpr', 'default', 'button', '1', 0)
		addAnimationByPrefix('cam' .. i .. 'ButtonSpr', 'selected', 'button', 0)

		makeLuaSprite('cam' .. i .. 'ButtonTxt', 'fnaf1/gameplay/cameras/cam' .. i, getProperty('cam' .. i .. 'ButtonSpr.x') + cameraButtons[i]['txtOffset'][1], getProperty('cam' .. i .. 'ButtonSpr.y') + cameraButtons[i]['txtOffset'][2])
	end

	makeLuaSprite('curCamTxt', nil, 832, 292) -- the current camera in text

	makeAnimatedLuaSprite('camChangeAnim', 'fnaf1/gameplay/camChange') -- the white static animation thing that plays when you change cameras
	addAnimationByPrefix('camChangeAnim', 'a', 'camChange', 42, false)
	setGraphicSize('camChangeAnim', screenWidth, screenHeight)

	makeLuaSprite('cameraButton', 'fnaf1/gameplay/cameraButton', 255, 638) -- the camera monitor's button
	addLuaSprite('cameraButton', true)
	setLuaCamera('cameraButton', 'ui')

	makeLuaSprite('cameraHitbox', nil, getProperty('cameraButton.x'), getProperty('cameraButton.y')) -- the camera monitor's button's hitbox
	makeGraphic('cameraHitbox', getProperty('cameraButton.width'), screenHeight - getProperty('cameraButton.height'), '000000')
	setLuaCamera('cameraHitbox', 'ui')

	makeLuaSprite('powerLeftTxt', 'fnaf1/gameplay/powerLeftTxt', 38, 631)
	addLuaSprite('powerLeftTxt', true)
	setLuaCamera('powerLeftTxt', 'ui')

	makeLuaText('powerTxt', math.floor(power / 10), 100, getProperty('powerLeftTxt.x') + 83, getProperty('powerLeftTxt.y') - 14)
	setTextAlignment('powerTxt', 'right')
	setTextFont('powerTxt', 'fnafFont.ttf')
	setTextSize('powerTxt', 55)
	setTextBorder('powerTxt', 0, '0x0')
	addLuaText('powerTxt', true)
	setLuaCamera('powerTxt', 'ui')

	makeLuaSprite('percentage', 'fnaf1/gameplay/percentage', 224, getProperty('powerTxt.y') + 15)
	addLuaSprite('percentage', true)
	setLuaCamera('percentage', 'ui')

	makeLuaSprite('usageTxt', 'fnaf1/gameplay/usageTxt', 38, getProperty('powerLeftTxt.y') + 36)
	addLuaSprite('usageTxt', true)
	setLuaCamera('usageTxt', 'ui')

	makeAnimatedLuaSprite('usageMeter', 'fnaf1/gameplay/usageMeter', getProperty('usageTxt.x') + (getProperty('usageTxt.width') + 10), getProperty('usageTxt.y') - 10)
	addAnimationByPrefix('usageMeter', 'a', 'usage', 0, false)
	addLuaSprite('usageMeter', true)
	setLuaCamera('usageMeter', 'ui')

	makeLuaSprite('amTxt', 'fnaf1/gameplay/amTxt', 1200, 31)
	addLuaSprite('amTxt', true)
	setLuaCamera('amTxt', 'ui')

	makeLuaSprite('nightTxt', 'fnaf1/gameplay/nightTxt', 1148, 74)
	addLuaSprite('nightTxt', true)
	setLuaCamera('nightTxt', 'ui')

	makeLuaSprite('muteCall', 'fnaf1/gameplay/muteCall', 27, 22)
	addLuaSprite('muteCall', true)
	setLuaCamera('muteCall', 'ui')
	setProperty('muteCall.alpha', clickteamToFlixelAlpha(100))
	setProperty('muteCall.visible', false)

	makeLuaText('night', night, 150, getProperty('nightTxt.x') + 8, getProperty('nightTxt.y') - 7.75)
	addLuaText('night')
	setTextFont('night', 'fnafFont.ttf')
	setTextSize('night', 40)
	setTextBorder('night', 0, '0x0')
	setLuaCamera('night', 'ui')

	makeLuaText('timeNum', '12', 100, getProperty('amTxt.x') - 110, getProperty('amTxt.y') - 6) -- what time you're on
	setTextAlignment('timeNum', 'right')
	setTextSize('timeNum', 60)
	setTextFont('timeNum', 'fnafFont.ttf')
	setTextBorder('timeNum', 0.5, 'FFFFFF')
	setTextBorder('timeNum', 0, '0x0')
	addLuaText('timeNum')
	setLuaCamera('timeNum', 'ui')

	makeLuaSprite('audioOnly', 'fnaf1/gameplay/audioOnly', 0, 50)
	screenCenter('audioOnly', 'x')

	makeLuaSprite('redCircle', 'fnaf1/gameplay/redCircle', 68, 52) -- the red circle thingie on cams again

	soundLoad('camMonitor', 'fnaf1/gameplay/camMonitor')
	soundLoad('deskFan', 'fnaf1/gameplay/deskFan', true)
	soundLoad('bgHum', 'fnaf1/gameplay/bgHum', true)
	soundLoad('camChange', 'fnaf1/gameplay/camChange')
	soundLoad('light', 'fnaf1/gameplay/light', true)
	soundLoad('door', 'fnaf1/gameplay/door')
	soundLoad('circus', 'fnaf1/gameplay/circus')
	soundLoad('tapeEject', 'fnaf1/gameplay/tapeEject')
	soundLoad('doorPounding', 'fnaf1/gameplay/doorPounding')
	soundLoad('nose', 'fnaf1/gameplay/nose')
	soundLoad('powerDown', 'fnaf1/gameplay/powerDown')
	soundLoad('chimes', 'fnaf1/win/chimes 2')
	soundLoad('cheer', 'fnaf1/win/CROWD_SMALL_CHIL_EC049202')
	soundLoad('call1', 'fnaf1/gameplay/voiceover1c')
	soundLoad('call2', 'fnaf1/gameplay/voiceover2a')
	soundLoad('call3', 'fnaf1/gameplay/voiceover3')
	soundLoad('call4', 'fnaf1/gameplay/voiceover4')
	soundLoad('call5', 'fnaf1/gameplay/voiceover5')

	soundPlay('bgHum', false, 0.3)
	soundPlay('deskFan', false, 0.4)
	if night <= 5 then soundPlay('call' .. night) end

	runTimer('clock', 540 / playbackRate)
	runTimer('redCircleVisible', 1 / playbackRate, 0)
	runTimer('powerDrain', 1 / playbackRate, 0)

	if night > 1 then runTimer('extraPowerDrain', ((night == 2 and 6) or (night == 3 and 5) or (night == 4 and 4) or (night >= 5 and 3)) / playbackRate, 0) end

	runTimer('circusSound', 5 / playbackRate, 0)
	runTimer('doorPoundingSound', 10 / playbackRate, 0)
	runTimer('thing', 1 / playbackRate, 0)
	runTimer('muteCall', 20 / playbackRate, 2)
end

function onCameraOpen()
	camUsage = 1
	doLight(nil, true)
	setSoundVolume('deskFan', 0.2)
	soundPlay('tapeEject')

	removeLuaSprite('office', false)
	removeLuaSprite('desk', false)
	removeLuaSprite('leftDoor', false)
	removeLuaSprite('rightDoor', false)
	removeLuaSprite('officeButtonLeft', false)
	removeLuaSprite('officeButtonRight', false)

	runHaxeCode('game.callOnLuas("onCameraChange", [' .. curCam .. ']);')

	addLuaSprite('curCamSpr')
	setLuaCamera('curCamSpr', 'items')

	addLuaSprite('static')
	setLuaCamera('static', 'ui')

	addLuaSprite('camBorder')
	setLuaCamera('camBorder', 'ui')

	addLuaSprite('map')
	setLuaCamera('map', 'ui')

	for i = 1, #cameraButtons do
		addLuaSprite('cam' .. i .. 'ButtonSpr', true)
		addLuaSprite('cam' .. i .. 'ButtonTxt', true)

		setLuaCamera('cam' .. i .. 'ButtonSpr', 'ui')
		setLuaCamera('cam' .. i .. 'ButtonTxt', 'ui')
	end

	addLuaSprite('curCamTxt', true)
	setLuaCamera('curCamTxt', 'ui')

	addLuaSprite('redCircle', true)
	setLuaCamera('redCircle', 'ui')

	addLuaSprite('camChangeAnim')
	setLuaCamera('camChangeAnim', 'ui')

	setProperty('static.alpha', clickteamToFlixelAlpha(150 + math.random(0, 50) + (staticAltValB * 15)))
end

-- camera system
function onCameraUpdate()
	for i = 1, #cameraButtons do
		if mouseOverlap('cam' .. i .. 'ButtonSpr', 'other') and mouseClicked() then 
			lastCam = curCam
			curCam = i
			runHaxeCode('game.callOnLuas("onCameraChange", [' .. curCam .. ']);')
		end
	end

	setProperty('static.alpha', clickteamToFlixelAlpha(150 + math.random(0, 50) + (staticAltValB * 15)))
end

-- when you change cameras
function onCameraChange(cam)
	soundPlay('camChange')
	if lastCam ~= curCam then playAnim('cam' .. lastCam .. 'ButtonSpr', 'default', true) end
	if getProperty('cam' .. cam .. 'ButtonSpr.animation.curAnim.name') ~= 'selected' then
		playAnim('cam' .. cam .. 'ButtonSpr', 'selected')
		setProperty('cam' .. cam .. 'ButtonSpr.animation.curAnim.frameRate', 1.8)
		playAnim('cam' .. cam .. 'ButtonSpr', 'selected', true)
	end

	playAnim('curCamSpr', 'cam' .. cam .. cameras[cam][1], true)
	loadGraphic('curCamTxt', 'fnaf1/gameplay/cameras/cam' .. cam .. 'Txt')

	setProperty('camChangeAnim.visible', true)
	playAnim('camChangeAnim', 'a', true)
	runHaxeCode([[
		var camChange = game.getLuaObject('camChangeAnim', false);
		camChange.animation.finishCallback = _ -> {camChange.visible = false;}
	]])

	if cam == 6 then
		addLuaSprite('audioOnly', true)
		setLuaCamera('audioOnly', 'ui')
	elseif lastCam == 6 then removeLuaSprite('audioOnly', false) end
end

function onCameraClose()
	camUsage = 0
	setSoundVolume('deskFan', 0.6)
	soundStop('tapeEject')

	addLuaSprite('office')
	addLuaSprite('desk')
	addLuaSprite('leftDoor')
	addLuaSprite('rightDoor')
	addLuaSprite('officeButtonLeft')
	addLuaSprite('officeButtonRight')

	removeLuaSprite('curCamSpr', false)
	removeLuaSprite('static', false)
	removeLuaSprite('camBorder', false)
	for i = 1, #cameraButtons do
		removeLuaSprite('cam' .. i .. 'ButtonSpr', false)
		removeLuaSprite('cam' .. i .. 'ButtonTxt', false)
	end
	removeLuaSprite('map', false)
	removeLuaSprite('curCamTxt', false)
	removeLuaSprite('redCircle', false)
	removeLuaSprite('camChangeAnim', false)
	if curCam == 6 then removeLuaSprite('audioOnly', false) end
end

function onUpdate(elapsed)
	local mousePos = getMouseX('other') / getProperty('visuals.scaleX')
    local camVelocity = 0
    if not cameraActive then
        if mousePos <= 240 then camVelocity = -14
        elseif mousePos <= 350 then camVelocity = -4 
        elseif mousePos >= 748 then camVelocity = 14
        elseif mousePos >= 702 then camVelocity = 4
        end
		camVelocity = camVelocity * (elapsed * 45)
    end

	-- most wacky ass code ever (this is aLOT of math how the fuck did i even rewrite this)
	if (camVelocity > 0 and getProperty('scroll.x') + 1024 / 2 + camVelocity <= 1464) or 
	(camVelocity < 0 and getProperty('scroll.x') >= 640) then setProperty('scroll.x', (getProperty('scroll.x') + camVelocity)) end
	if (getProperty('scroll.x') <= 640) or ((getProperty('scroll.x') + 1024 / 2 + camVelocity) >= 1464) then
		setProperty('scroll.x', (getProperty('scroll.x') <= 640 and 639) or ((getProperty('scroll.x') + 1024 / 2 + camVelocity) >= 1464 and 950))
	end

	-- cam opening system
	mouseOverlapCamera = luaSpriteExists('cameraHitbox') and mouseOverlap('cameraHitbox', 'other')
	if not mouseOverlapCamera and cameraCooldown >= 0 then cameraCooldown = ((cameraCooldown / playbackRate) - elapsed) end
	if mouseOverlapCamera and cameraCooldown <= 0 and not died then
		cameraCooldown = 0.1
		cameraActive = not cameraActive

		setProperty('camera.visible', true)
		playAnim('camera', cameraActive and 'a' or 'b', true)
		soundPlay('camMonitor')

		runHaxeCode([[
			var camera = game.getLuaObject('camera', false);

			camera.animation.finishCallback = _ -> {
				camera.visible = false;
				if(]] .. tostring(cameraActive) .. [[) game.callOnLuas('onCameraOpen', []);
			};
			if(!]] .. tostring(cameraActive) .. [[) game.callOnLuas("onCameraClose", []);
		]])
	end
	if not getProperty('camera.visible') and cameraActive then runHaxeCode('game.callOnLuas("onCameraUpdate", []);') end

	if camFollow.valueA == 0 then
		camFollow.valueB = camFollow.valueB + (1 * playbackRate)
		setProperty('camsFollow.x', getProperty('camsFollow.x') - (1 * playbackRate))

		if camFollow.valueB >= 320 then
			camFollow.valueA = 1
			camFollow.valueB = 0
		end
	elseif camFollow.valueA == 1 then
		camFollow.valueB = camFollow.valueB + (1 * playbackRate)

		if camFollow.valueB >= 100 then
			camFollow.valueA = 2
			camFollow.valueB = 0
		end
	elseif camFollow.valueA == 2 then
		camFollow.valueB = camFollow.valueB + (1 * playbackRate)
		setProperty('camsFollow.x', getProperty('camsFollow.x') + (1 * playbackRate))

		if camFollow.valueB >= 320 then
			camFollow.valueA = 3
			camFollow.valueB = 0
		end
	elseif camFollow.valueA == 3 then
		camFollow.valueB = camFollow.valueB + (1 * playbackRate)

		if camFollow.valueB >= 100 then
			camFollow.valueA = 0
			camFollow.valueB = 0
		end
	end

	setProperty('curCamSpr.x', (curCam == 9 or curCam == 6) and 0 or getProperty('camsFollow.x'))

	if mouseOverlap('muteCall', 'other') and mouseClicked() and getProperty('muteCall.visible') then
		soundStop('call1')
		setProperty('muteCall.visible', false)
		cancelTimer('muteCall')
	end

	-- time system
	curTime = round(curTimerLength('clock'))
	if (((lastTimeCheck / playbackRate) + (90 / playbackRate)) <= (curTime / playbackRate)) and changeTime then
		lastTimeCheck = curTime
		curTimeCheck = curTimeCheck + 1
		runHaxeCode('game.callOnLuas("onTimeChange", [' .. curTimeCheck .. ']);')
		changeTime = false
	end
	changeTime = true

	if not cameraActive and not died then
		if mouseOverlap('lightButtonLeft', 'other', shadersEnabled and -8 or 0, shadersEnabled and -10 or 0) and mouseClicked() then doLight('left')
		elseif mouseOverlap('lightButtonRight', 'other', 310) and mouseClicked() then doLight('right') end

		if mouseOverlap('doorButtonLeft', 'other', shadersEnabled and -8 or 0, shadersEnabled and 7 or 0) and mouseClicked() and getProperty('leftDoor.animation.curAnim.finished') then doDoor('left')
		elseif mouseOverlap('doorButtonRight', 'other', 310) and mouseClicked() and getProperty('rightDoor.animation.curAnim.finished') then doDoor('right') end

		if mouseOverlap('freddyNose', 'other', getProperty('scroll.x') - 637) and mouseClicked() then soundPlay('nose') end
	end

	rightLightUsage = rightLight and 1 or 0
	leftLightUsage = leftLight and 1 or 0

	usage = 1 + (leftDoorUsage + rightDoorUsage + leftLightUsage + rightLightUsage + camUsage)
	setProperty('usageMeter.animation.curAnim.curFrame', usage - 1)
end

function doDoor(side)
	if side == 'right' then rightDoor = not rightDoor 
	elseif side == 'left' then leftDoor = not leftDoor end
	soundPlay('door')
	playAnim(side .. 'Door', (side == 'left' and (leftDoor and 'down' or 'up')) or (side == 'right' and (rightDoor and 'down' or 'up')), true)

	if side == 'left' then leftDoorUsage = leftDoor and 1 or 0
	elseif side == 'right' then rightDoorUsage = rightDoor and 1 or 0 end

	doButton()
end

function doLight(side, cams)
	cams = cams or false

	if cams then
		rightLight = false
		leftLight = false
	end

	if side == 'left' then
		rightLight = false
		leftLight = not leftLight
	elseif side == 'right' then
		leftLight = false
		rightLight = not rightLight
	end

	if leftLight or rightLight then soundPlay('light')
	else soundStop('light') end

	playAnim('office', (leftLight and 'lightLeft') or (rightLight and 'lightRight') or 'default', true)
	doButton()
end

function doButton()
	setProperty('officeButtonLeft.animation.curAnim.curFrame', (((leftDoor and leftLight) and 1) or ((leftDoor and 2) or (leftLight and 3))) or 0)
	setProperty('officeButtonRight.animation.curAnim.curFrame', (((rightDoor and rightLight) and 1) or ((rightDoor and 2) or (rightLight and 3))) or 0)
end

function die()
	died = true
	soundStop('bgHum')
	soundStop('deskFan')

	if cameraActive then
		cameraActive = false

		setProperty('camera.visible', true)
		playAnim('camera', 'b', true)
		soundPlay('camMonitor')

		runHaxeCode([[
			var camera = game.getLuaObject('camera', false);

			camera.animation.finishCallback = _ -> {
				camera.visible = false;
			};
			game.callOnLuas("onCameraClose", []);
		]])
	end

	soundPlay('powerDown')
	
	removeLuaSprite('usageTxt')
	removeLuaSprite('powerLeftTxt')
	removeLuaSprite('usageMeter')
	removeLuaSprite('nightTxt')
	removeLuaSprite('amTxt')
	removeLuaSprite('percentage')
	removeLuaSprite('cameraButton')
	removeLuaText('powerTxt')
	removeLuaText('night')
	removeLuaText('timeNum')

	removeLuaSprite('desk')
	removeLuaSprite('officeButtonLeft')
	removeLuaSprite('officeButtonRight')
	if leftLight then doLight('left')
	elseif rightLight then doLight('right') end

	if leftDoor then doDoor('left') end
	if rightDoor then doDoor('right') end

	playAnim('office', 'blackout', true)
end

function onPowerChange() setTextString('powerTxt', math.floor(power / 10)) end
function onPause()
	soundPause('door')
	soundPause('camMonitor')
	for i = 1, 5 do soundPause('call' .. i) end
	if died then soundPause('powerDown')
	else 
		soundPause('bgHum')
		soundPause('deskFan')
	end

	soundPause('circus')
	soundPause('doorPounding')
	if cameraActive then soundPause('tapeEject') end
	if rightLight or leftLight then soundPause('light') end
end
function onResume()
	soundResume('door')
	soundResume('camMonitor')
	for i = 1, 5 do soundResume('call' .. i) end
	if died then soundResume('powerDown')
	else 
		soundResume('bgHum')
		soundResume('deskFan')
	end
	
	soundResume('circus')
	soundResume('doorPounding')
	if cameraActive then soundResume('tapeEject') end
	if rightLight or leftLight then soundResume('light') end
end
function onTimeChange(time) 
	setTextString('timeNum', time) 
	if time == 6 then openCustomSubstate('win', true) end
end
function onDestroy() 
	setPropertyFromClass("openfl.Lib", "application.window.title", "Friday Night Funkin': Psych Engine") 
	setPropertyFromClass('flixel.FlxG', 'mouse.visible', false)

	runHaxeCode([[
        var icon = Image.fromFile(Paths.modFolders('images/fnaf1/icon16.png'));
        Application.current.window.setIcon(icon);
    ]])
end
function clickteamToFlixelAlpha(value) return 1 - (value / 255) end
function luaTweenExists(tag) return runHaxeCode("return game.modchartTweens.exists('" .. tag .. "')") end
function round(num, decimal_places) return math.floor(num * (10 ^ (decimal_places or 0)) + 0.5) / (10 ^ (decimal_places or 0)) end
function onCustomSubstateCreate(t) if substatesCreate[t] then substatesCreate[t]() end end
function onCustomSubstateUpdate(t) if substatesUpdate[t] then substatesUpdate[t]() end end
function onTimerCompleted(t) if timers[t] then timers[t]() end end
function onTweenCompleted(t) if tweens[t] then tweens[t]() end end
function curTimerLength(timer) 
	return runHaxeCode([[
		var tmr = game.modchartTimers.get(']] .. timer .. [[');
		return game.modchartTimers.exists(']] .. timer .. [[') ? ((tmr.progress * tmr.time) * game.playbackRate) : game.addTextToDebug('curTimerLength: Timer tag "]] .. timer .. [[" was not found.', 0xFFFF0000);
  	]]) 
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
function mouseOverlap(obj, mouseCamera, offsetX, offsetY)
	offsetX = offsetX or 0
	offsetY = offsetY or 0
	local overlapX = (getMouseX(mouseCamera) + offsetX) >= getProperty(obj .. '.x') and (getMouseX(mouseCamera) + offsetX) <= getProperty(obj .. '.x') + getProperty(obj .. '.width')
	local overlapY = (getMouseY(mouseCamera) + offsetY) >= getProperty(obj .. '.y') and (getMouseY(mouseCamera) + offsetY) <= getProperty(obj .. '.y') + getProperty(obj .. '.height')
	return overlapX and overlapY
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
		}
		else game.addTextToDebug('soundPlay: Sound tag "]] .. tag .. [[" was not found.', 0xFFFF0000);
	]])
end
function soundStop(tag)
	runHaxeCode([[
		var a = game.modchartSounds.get(']] .. tag .. [[');
		if (game.modchartSounds.exists(']] .. tag .. [[')) a.stop();
		else game.addTextToDebug('soundStop: Sound tag "]] .. tag .. [[" was not found.', 0xFFFF0000);
	]])
end
function soundPause(tag)
	runHaxeCode([[
		var a = game.modchartSounds.get(']] .. tag .. [[');
		if (game.modchartSounds.exists(']] .. tag .. [[')) a.pause();
		else game.addTextToDebug('soundPause: Sound tag "]] .. tag .. [[" was not found.', 0xFFFF0000);
	]])
end
function soundResume(tag)
	runHaxeCode([[
		var a = game.modchartSounds.get(']] .. tag .. [[');
		if (game.modchartSounds.exists(']] .. tag .. [[')) a.resume();
		else game.addTextToDebug('soundResume: Sound tag "]] .. tag .. [[" was not found.', 0xFFFF0000);
	]])
end