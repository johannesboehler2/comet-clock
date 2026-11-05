-- Clock module

local clockModule = {} -- Here we store all the functions

local clockList = {} -- Here we store all the new clocks


function clockModule:new(xCenter, yCenter, imgClockBackground, fontFamily, fontSize, fontColor, scale, deepWidth, clockRadius, clockBorderWidth)
	newClock = {}
	newClock.xCenter = xCenter
	newClock.yCenter = yCenter
	newClock.fontFamily = fontFamily
	newClock.fontSize = fontSize
	newClock.fontColor = fontColor
	newClock.scale = scale
	newClock.finalScale = scale

	newClock.clockBorderColor = ColorFromRGBA(255, 255, 255)
	newClock.clockBackgroundColor = ColorFromRGBA(250, 100, 13, 0.0)
	newClock.clockHandShadowColor = ColorFromRGBA(0, 0, 0, 0.3)
	newClock.clockHandColor = ColorFromRGBA(250, 100, 13)	
	newClock.clockSecondsHandColor = ColorFromRGBA(255, 255, 255)
	newClock.clockMiddlePointColor = ColorFromRGBA(250, 100, 13)
	
	newClock.isVisible = true

	
	-- TODO
	-- Color of the minute / hour mark lines

	newClock.clockRadius = clockRadius or 228
	newClock.clockBorderWidth = clockBorderWidth or 1
	newClock.clockBorderPadding = 6
	
	
	function newClock:setFont()
		self.font = love.graphics.newFont(
			self.fontFamily,
			self.fontSize * self.scale
		)
	end
	
	function newClock:setFontColor(fontColor)
		self.fontColor = fontColor
	end
	
	function newClock:setBorderColor(borderColor) -- TODO
		self.clockBorderColor = borderColor
	end
	
	function newClock:setBackgroundColor(backgroundColor) -- TODO
		self.clockBackgroundColor = backgroundColor
	end
	
	function newClock:setHandShadowColor(handShadowColor) -- TODO
		self.clockHandShadowColor = handShadowColor
	end
	
	function newClock:setHandColor(handColor) -- TODO
		self.clockHandColor = handColor
	end
	
	function newClock:setSecondsHandColor(secondsHandColor) -- TODO
		self.clockSecondsHandColor = secondsHandColor
	end
	
	function newClock:setMiddlePointColor(middlePointColor)
		self.clockMiddlePointColor = middlePointColor
	end
	
	
	function newClock:setScale(scale)
		self.finalScale = scale
		self:setFont() -- Reinit font for font size
	end
	
	function newClock:setIsVisible(isVisible)
		newClock.isVisible = isVisible
	end
	
	
	newClock:setFont()
	
	table.insert(clockList, newClock)
	
	
	return newClock
end

function clockModule:update(dt) -- Put this in love.update()
	currentTime = os.date("*t")

	for i, clockElement in ipairs(clockList) do
		if clockElement.scale < clockElement.finalScale then
			clockElement.scale = clockElement.scale + 1 / (0.3 / dt)
			
			if clockElement.scale > clockElement.finalScale then
				clockElement.scale = clockElement.finalScale
			end
		end
		
		if clockElement.scale > clockElement.finalScale then
			clockElement.scale = clockElement.scale - 1 / (0.3 / dt)
			
			if clockElement.scale < clockElement.finalScale then
				clockElement.scale = clockElement.finalScale
			end
		end
	end
end

function clockModule:draw() -- Put this in love.draw()
	local r, g, b, a = love.graphics.getColor()

	for i, clockElement in ipairs(clockList) do
	
		if clockElement.isVisible then
			-- Clock face

			love.graphics.setColor(clockElement.clockBackgroundColor)
			love.graphics.circle(
				"fill",
				clockElement.xCenter,
				clockElement.yCenter,
				clockElement.clockRadius * clockElement.scale
			)
			
			
			love.graphics.setColor(clockElement.clockBorderColor)
			
			love.graphics.setLineWidth(clockElement.clockBorderWidth * clockElement.scale)
			
			love.graphics.circle(
				"line",
				clockElement.xCenter,
				clockElement.yCenter,
				clockElement.clockRadius * clockElement.scale
			)
		
		
			love.graphics.setColor(clockElement.fontColor) -- TODO
    
			for i = 0, 59 do
				local angle = math.rad(i * 6)
			
				local innerRadius =
					clockElement.clockRadius * clockElement.scale -
					clockElement.clockBorderWidth * clockElement.scale -
					clockElement.clockBorderPadding * clockElement.scale
				
				local x1 = clockElement.xCenter + innerRadius * math.sin(angle)
				local y1 = clockElement.yCenter - innerRadius * math.cos(angle)
				local x2 = clockElement.xCenter + innerRadius * math.sin(angle)
				local y2 = clockElement.yCenter - innerRadius * math.cos(angle)

				if i % 15 == 0 then
					love.graphics.setLineWidth(4 * clockElement.scale) -- TODO
					love.graphics.line(
						x1,
						y1,
						x2 - 18 * clockElement.scale * math.sin(angle),
						y2 + 18 * clockElement.scale * math.cos(angle)
					)
				elseif i % 5 == 0 then
					love.graphics.setLineWidth(2 * clockElement.scale) -- TODO
					love.graphics.line(
						x1,
						y1,
						x2 - 18 * clockElement.scale * math.sin(angle),
						y2 + 18 * clockElement.scale * math.cos(angle)
					)
				else
					love.graphics.setLineWidth(1 * clockElement.scale) -- TODO
					love.graphics.line(
						x1,
						y1,
						x2 - 8 * clockElement.scale * math.sin(angle),
						y2 + 8 * clockElement.scale * math.cos(angle)
					)
				end
			end
			
			
			-- Clock face hour numbers

			love.graphics.setFont(clockElement.font)
			love.graphics.setColor(clockElement.fontColor)
			
			for i = 1, 12 do
			    local angle = math.rad((i) * 30)
			    
			    local numberRadius =
				    clockElement.clockRadius * clockElement.scale -
				    36 * clockElement.scale -
				    clockElement.clockBorderWidth * clockElement.scale -
				    clockElement.clockBorderPadding * clockElement.scale -
				    4 * clockElement.scale
				    
			    local x = clockElement.xCenter + numberRadius * math.sin(angle)
			    local y = clockElement.yCenter - numberRadius * math.cos(angle)

			    local text = tostring(i == 0 and 12 or i)
			    local textWidth = clockElement.font:getWidth(text)
			    
			    love.graphics.print(text, x - textWidth/2, y - 18 * clockElement.scale)
			end
		
			
			-- Date
			
			dateStr = currentTime.day .. "." .. currentTime.month .. "." .. currentTime.year
			dateStrWidth = love.graphics:getFont():getWidth(dateStr)
			love.graphics.print(dateStr, 13 * clockElement.scale, 531 * clockElement.scale)
		
		
			-- Hour hand
			
			love.graphics.setColor(newClock.clockHandColor)

			local hourAngle = math.rad((currentTime.hour % 12) * 30 + currentTime.min * 0.5)
			local hourLength =
				(
					clockElement.clockRadius * clockElement.scale -
					clockElement.clockBorderWidth * clockElement.scale -
					12 * clockElement.scale
				) * 0.6
			local hourX = clockElement.xCenter + hourLength * math.sin(hourAngle)
			local hourY = clockElement.yCenter - hourLength * math.cos(hourAngle)

			love.graphics.setLineWidth(10 * clockElement.scale)

			love.graphics.setColor(clockElement.clockHandShadowColor)
			love.graphics.line(
				clockElement.xCenter + 3 * clockElement.scale,
				clockElement.yCenter + 3 * clockElement.scale,
				hourX + 3 * clockElement.scale,
				hourY + 3 * clockElement.scale
			)

			love.graphics.setColor(clockElement.clockHandColor)
			love.graphics.line(clockElement.xCenter, clockElement.yCenter, hourX, hourY)
			
			
			-- Minute hand
			
			love.graphics.setColor(newClock.clockHandColor)

			local minuteAngle = math.rad(currentTime.min * 6)
			local minuteLength = 
				(
					clockElement.clockRadius * clockElement.scale -
					clockElement.clockBorderWidth * clockElement.scale -
					22 * clockElement.scale
				) * 0.76
			local minuteX = clockElement.xCenter + minuteLength * math.sin(minuteAngle)
			local minuteY = clockElement.yCenter - minuteLength * math.cos(minuteAngle)

			love.graphics.setLineWidth(5 * clockElement.scale)

			love.graphics.setColor(clockElement.clockHandShadowColor)
			love.graphics.line(
				clockElement.xCenter + 3 * clockElement.scale,
				clockElement.yCenter + 3 * clockElement.scale,
				minuteX + 3 * clockElement.scale,
				minuteY + 3 * clockElement.scale
			)

			love.graphics.setColor(clockElement.clockHandColor)
			love.graphics.line(clockElement.xCenter, clockElement.yCenter, minuteX, minuteY)
			
			
			-- Second hand

			local secondAngle = math.rad(currentTime.sec * 6)
			local secondLength =
				(
					clockElement.clockRadius * clockElement.scale -
					clockElement.clockBorderWidth * clockElement.scale -
					35 * clockElement.scale
				) * 0.85
			local secondX = clockElement.xCenter + secondLength * math.sin(secondAngle)
			local secondY = clockElement.yCenter - secondLength * math.cos(secondAngle)

			love.graphics.setLineWidth(1 * clockElement.scale)

			love.graphics.setColor(clockElement.clockHandShadowColor)
			love.graphics.line(
				clockElement.xCenter + 3 * clockElement.scale,
				clockElement.yCenter + 3 * clockElement.scale,
				secondX + 3 * clockElement.scale,
				secondY + 3 * clockElement.scale
			)

			love.graphics.setColor(newClock.clockSecondsHandColor)
			love.graphics.line(clockElement.xCenter, clockElement.yCenter, secondX, secondY)
			
			
			-- Circle in center
			
			love.graphics.setColor(ColorFromRGBA(0, 0, 0))
					
			love.graphics.setLineWidth(6 * clockElement.scale)
			love.graphics.circle("line", clockElement.xCenter, clockElement.yCenter, 2 * clockElement.scale)

			love.graphics.setColor(ColorFromRGBA(250, 100, 13))
			love.graphics.setColor(clockElement.clockMiddlePointColor)

			love.graphics.setLineWidth(8 * clockElement.scale)
			love.graphics.circle("line", clockElement.xCenter, clockElement.yCenter, 8 * clockElement.scale)
			
			love.graphics.setColor(ColorFromRGBA(0, 0, 0))

			love.graphics.setLineWidth(2 * clockElement.scale)
			love.graphics.circle("line", clockElement.xCenter, clockElement.yCenter, 13 * clockElement.scale)
		end
	end
	
	love.graphics.setColor(r, g, b, a)
end


return clockModule
	 	
