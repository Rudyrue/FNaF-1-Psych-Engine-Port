local m = {}

function m.switch(case, cases) if cases[case] ~= nil then return cases[case]() elseif cases.default ~= nil then return cases.default() end end
function m.mouseOverlap(obj, offsetX, offsetY)
	offsetX = offsetX or 0
	offsetY = offsetY or 0
	local overlapX = (getMouseX('other') + offsetX) >= getProperty(obj .. '.x') and (getMouseX('other') + offsetX) <= getProperty(obj .. '.x') + getProperty(obj .. '.width')
	local overlapY = (getMouseY('other') + offsetY) >= getProperty(obj .. '.y') and (getMouseY('other') + offsetY) <= getProperty(obj .. '.y') + getProperty(obj .. '.height')
	return overlapX and overlapY
end

return m