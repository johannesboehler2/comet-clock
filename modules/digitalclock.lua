-- Digital clock module

local digitalClockModule = {} -- Here we store all the functions

local digitalClockList = {} -- Here we store all the new digital clocks


function digitalClockModule:new(xCenter, yCenter, imgDigitalClock, scale)
	newDigitalClock = {}
	newDigitalClock.xCenter = xCenter
	newDigitalClock.yCenter = yCenter
	newDigitalClock.scale = scale
	newDigitalClock.finalScale = scale
	newDigitalClock.frameWidth = 190
	newDigitalClock.frameHeight = 308
	newDigitalClock.framePadding = 20
	newDigitalClock.imgDpiScale = 2
	newDigitalClock.doublePointFrameWidth = 120
	newDigitalClock.spriteSheet = imgDigitalClock
	newDigitalClock.quads = {}
	
	newDigitalClock.isVisible = true
	
	
	-- Get sheet size
	local sheetWidth , sheetHeight = newDigitalClock.spriteSheet:getDimensions()
	local columns = sheetWidth / newDigitalClock.frameWidth
	
	for i = 0, columns - 1 do
		newDigitalClock.quads[#newDigitalClock.quads + 1] =
			love.graphics.newQuad(
				i * newDigitalClock.frameWidth,
				0,
				newDigitalClock.frameWidth,
				newDigitalClock.frameHeight,
				sheetWidth,
				sheetHeight
			)
	end
	
	
	function newDigitalClock:setScale(scale)
		self.finalScale = scale
	end
	
	function newDigitalClock:setImgDigitalClock(imgDigitalClock)
		newDigitalClock.spriteSheet = imgDigitalClock
	end
	
	function newDigitalClock:setIsVisible(isVisible)
		newDigitalClock.isVisible = isVisible
	end
	
	
	table.insert(digitalClockList, newDigitalClock)
	
	
	return newDigitalClock
end

function digitalClockModule:update(dt) -- Put this in love.update()
	currentTimeFormated = os.date("%H:%M")
	currentTimeSeconds = os.date("%S")
	
	for i, digitalClockElement in ipairs(digitalClockList) do
		if digitalClockElement.scale < digitalClockElement.finalScale then
			digitalClockElement.scale = digitalClockElement.scale + 1 / (0.3 / dt)
			
			if digitalClockElement.scale > digitalClockElement.finalScale then
				digitalClockElement.scale = digitalClockElement.finalScale
			end
		end
		
		if digitalClockElement.scale > digitalClockElement.finalScale then
			digitalClockElement.scale = digitalClockElement.scale - 1 / (0.3 / dt)
			
			if digitalClockElement.scale < digitalClockElement.finalScale then
				digitalClockElement.scale = digitalClockElement.finalScale
			end
		end
	end
end

function digitalClockModule:draw() -- Put this in love.draw()
	local r, g, b, a = love.graphics.getColor()

	for i, digitalClockElement in ipairs(digitalClockList) do
	
		if digitalClockElement.isVisible then
			timeStr = currentTimeFormated
			
			--love.graphics.setColor(ColorFromRGBA(24, 73, 55))
			--love.graphics.rectangle("fill", 0, 0, windowWidth, windowHeight) 
			
			
			y = digitalClockElement.yCenter -
				digitalClockElement.frameHeight /
				digitalClockElement.imgDpiScale / 2 *
				digitalClockElement.scale
			
			for ii = 1, #timeStr do
				local timeChar = timeStr:sub(ii,ii)
				
				if ii == 1 then
					x = digitalClockElement.xCenter -
						((digitalClockElement.frameWidth * 2 + digitalClockElement.framePadding) /
						digitalClockElement.imgDpiScale) * digitalClockElement.scale -
						((digitalClockElement.doublePointFrameWidth / 2) / digitalClockElement.imgDpiScale) *
						digitalClockElement.scale
				end
				
				if ii == 2 then
					x = digitalClockElement.xCenter -
						((digitalClockElement.frameWidth) / digitalClockElement.imgDpiScale) *
						digitalClockElement.scale -
						((digitalClockElement.doublePointFrameWidth / 2) / digitalClockElement.imgDpiScale) *
						digitalClockElement.scale
				end
				
				if ii == 3 then
					x = digitalClockElement.xCenter -
						(digitalClockElement.doublePointFrameWidth / 2) / digitalClockElement.imgDpiScale *
						digitalClockElement.scale -
						(digitalClockElement.frameWidth - digitalClockElement.doublePointFrameWidth) / 2 /
						digitalClockElement.imgDpiScale * digitalClockElement.scale
				end
				
				if ii == 4 then
					x = digitalClockElement.xCenter +
						((digitalClockElement.doublePointFrameWidth / 2) / digitalClockElement.imgDpiScale) *
						digitalClockElement.scale
				end
				
				if ii == 5 then
					x = digitalClockElement.xCenter +
						((digitalClockElement.frameWidth * 1) / digitalClockElement.imgDpiScale) *
						digitalClockElement.scale +
						digitalClockElement.framePadding / digitalClockElement.imgDpiScale * digitalClockElement.scale +
						((digitalClockElement.doublePointFrameWidth / 2) / digitalClockElement.imgDpiScale) *
						digitalClockElement.scale
				end
				
				
				if ii == 1 and timeChar == "0" then
					timeChar = " "
				end
				
				
				if timeChar == " " then
					quadIndex = 1
				end
				
				if timeChar == "0" then
					quadIndex = 2
				end
				
				if timeChar == "1" then
					quadIndex = 3
				end
				
				if timeChar == "2" then
					quadIndex = 4
				end
				
				if timeChar == "3" then
					quadIndex = 5
				end
				
				if timeChar == "4" then
					quadIndex = 6
				end
				
				if timeChar == "5" then
					quadIndex = 7
				end
				
				if timeChar == "6" then
					quadIndex = 8
				end
				
				if timeChar == "7" then
					quadIndex = 9
				end
				
				if timeChar == "8" then
					quadIndex = 10
				end
				
				if timeChar == "9" then
					quadIndex = 11
				end
				
				if timeChar == ":" then
					if math.mod(currentTimeSeconds, 2) == 0 then
					    quadIndex = 12
					else
					    quadIndex = 13
					end
				end
				
				
				love.graphics.draw(
					digitalClockElement.spriteSheet,
					digitalClockElement.quads[quadIndex],
					x,
					y,
					0,
					digitalClockElement.scale / digitalClockElement.imgDpiScale,
					digitalClockElement.scale / digitalClockElement.imgDpiScale
				)
			end
		end
	end
	
	love.graphics.setColor(r, g, b, a)
end


return digitalClockModule
	 	
