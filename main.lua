-- Copyright 2026 Johannes Böhler
 
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.
 

button = require "modules/button"
clock = require "modules/clock"
digitalClock = require "modules/digitalclock"


local fps = 0;
local durationSinceLastSecond = 0;


function round(num, decimal)
	local mult = 10^(decimal or 0)
	return math.floor(num * mult + 0.5) / mult
end


function Color(hex, value)
	return {
		tonumber(string.sub(hex, 2, 3), 16) / 256,
		tonumber(string.sub(hex, 4, 5), 16) / 256,
		tonumber(string.sub(hex, 6, 7), 16) / 256,
		value or 1
	}
end

function ColorFromRGBA(r, g, b, a)
	return {
		1 / 255 * r,
		1 / 255 * g,
		1 / 255 * b,
		a or 1
	}
end


function love.load()
	-- TODO
	-- visible = love.window.isVisible( )
	-- Do not redraw if the display is off
	

	settings = {}
	settings.windowWidth = 540
	settings.windowHeight = 580
	settings.windowScale = 0.667
	settings.windowScale = 1.6
	--settings.windowScale = 1.85
	settings.backgroundColor = ColorFromRGBA(0, 0, 0)
	settings.borderless = false
	settings.showFPS = false
	settings.nightMode = false

	settings.clockFontFamily = "assets/fonts/GeistMono-VariableFont_wght.ttf"
	settings.clockFontSize = 27
	settings.fontColor = ColorFromRGBA(255, 255, 255) -- TODO
	settings.clockBorderColor = ColorFromRGBA(255, 255, 255)
	settings.clockBackgroundColor = ColorFromRGBA(0, 0, 0)
	settings.clockHandShadowColor = ColorFromRGBA(0, 0, 0, 0.3)
	settings.clockHandColor = ColorFromRGBA(250, 100, 13)	
	settings.clockSecondsHandColor = ColorFromRGBA(255, 255, 255)
	
	
	love.window.setMode(
		settings.windowWidth * settings.windowScale,
		settings.windowHeight * settings.windowScale,
		{
			highdpi = true,
			borderless = settings.borderless,
			usedpiscale = true
		}
	)
	
	
	love.window.setTitle("Comet Clock")
	
	windowWidth, windowHeight = love.window.getMode()
	centerX, centerY = windowWidth / 2, windowHeight / 2

	love.graphics.setBackgroundColor(settings.backgroundColor)
	
	widgets = {}
	
	setImages()

	
	widgets.buttonNightModeWidget = button:new(
		settings.windowWidth * settings.windowScale - 68 * settings.windowScale, -- X
		settings.windowHeight * settings.windowScale - 60 * settings.windowScale, -- Y
		0.5 * settings.windowScale, -- Scale (the image has double size)
		buttonNightModeImage,
		buttonNightModeImage,
		function() -- Button's function
			-- Toggle night mode
			toggleNightMode()
		end,
		function() -- Button's hover function
		end
	)
	
	widgets.buttonDigitalClockModeWidget = button:new(
		settings.windowWidth * settings.windowScale - 136 * settings.windowScale, -- X
		settings.windowHeight * settings.windowScale - 60 * settings.windowScale, -- Y
		0.5 * settings.windowScale, -- Scale (the image has double size)
		buttonNightModeImage,
		buttonNightModeImage,
		function() -- Button's function
			-- Toggle night mode
			toggleDigitalClockMode()
		end,
		function() -- Button's hover function
		end
	)

	
	widgets.clockWidget = clock:new(
		windowWidth / 2,
		windowHeight / 2,
		buttonNightModeImage,
		settings.clockFontFamily,
		settings.clockFontSize,
		{1, 1, 1}, -- TODO
		settings.windowScale
	)
	
	widgets.digitalClockWidget = digitalClock:new(
		windowWidth / 2,
		windowHeight / 2,
		love.graphics.newImage("assets/images/7segments_comet.png"),
		settings.windowScale
	)
	
	widgets.digitalClockWidget:setIsVisible(false)
end

function love.update(dt)
	durationSinceLastSecond = durationSinceLastSecond + dt;
	
	-- Execute every 0.6 seconds
	if durationSinceLastSecond > 0.6 then
		fps = 1 / dt
		durationSinceLastSecond = 0
	end
	
	-- Quit the app
	if love.keyboard.isDown("escape") then
		love.event.quit()
	end
	
	function love.keypressed(key, scancode, isrepeat)
		if key == "f1" and isrepeat == false then
			if settings.showFPS then
				settings.showFPS = false
			else
				settings.showFPS = true
			end
		end
		
		if key == "f2" and isrepeat == false then
			toggleNightMode()
		end
	end
	
	
	button:update(dt)
   	clock:update(dt)
   	digitalClock:update(dt)
end

function love.draw()
 	button:draw()
 	digitalClock:draw()
	clock:draw()
	
	
	-- FPS
	
	if settings.showFPS then
		love.graphics.setNewFont(22 * settings.windowScale)
		love.graphics.setColor(1, 1, 1)
		love.graphics.print(
			round(fps, 0) .. " FPS",
			windowWidth - 150 * settings.windowScale,
			10 * settings.windowScale
		)
	end

end

function toggleNightMode()
	if settings.nightMode then
		settings.nightMode = false
		widgets.clockWidget:setFontColor(ColorFromRGBA(255, 255, 255)) -- TODO make vars
		
		widgets.clockWidget:setBorderColor(ColorFromRGBA(255, 255, 255))
		widgets.clockWidget:setBackgroundColor(ColorFromRGBA(0, 0, 0, 0))
		widgets.clockWidget:setHandShadowColor(ColorFromRGBA(0, 0, 0, 0.3))
		widgets.clockWidget:setHandColor(ColorFromRGBA(250, 100, 13))
		widgets.clockWidget:setSecondsHandColor(ColorFromRGBA(255, 255, 255))
		widgets.clockWidget:setMiddlePointColor(ColorFromRGBA(250, 100, 13))
		
		widgets.digitalClockWidget:setImgDigitalClock(love.graphics.newImage("assets/images/7segments_comet.png"))
	else
		settings.nightMode = true
		widgets.clockWidget:setFontColor(ColorFromRGBA(255, 0, 0)) -- TODO make vars
		
		widgets.clockWidget:setBorderColor(ColorFromRGBA(255, 0, 0))
		widgets.clockWidget:setBackgroundColor(ColorFromRGBA(0, 0, 0, 0))
		widgets.clockWidget:setHandShadowColor(ColorFromRGBA(0, 0, 0, 0.3))
		widgets.clockWidget:setHandColor(ColorFromRGBA(255, 0, 0))
		widgets.clockWidget:setSecondsHandColor(ColorFromRGBA(255, 0, 0))
		widgets.clockWidget:setMiddlePointColor(ColorFromRGBA(255, 0, 0))
		
		widgets.digitalClockWidget:setImgDigitalClock(love.graphics.newImage("assets/images/7segments_comet_night_mode.png"))
	end
	
	setImages()

	widgets.buttonNightModeWidget:setImages(buttonNightModeImage, buttonNightModeImage)
end

function toggleDigitalClockMode()
	if widgets.digitalClockWidget.isVisible == false then
		widgets.digitalClockWidget:setIsVisible(true)
		widgets.clockWidget:setIsVisible(false)	
	else
		widgets.digitalClockWidget:setIsVisible(false)
		widgets.clockWidget:setIsVisible(true)	
	end
end

function setImages()
	if settings.nightMode then
		buttonNightModeImage = love.graphics.newImage("assets/images/night_mode_button_enabled.png")
	else
		buttonNightModeImage = love.graphics.newImage("assets/images/night_mode_button_disabled.png")
	end
end
