-- Button module

function in_bound(target, mx, my) --This one do math and allows you to create a hitbox for the button
	return mx >= target.x and mx <= target.x + target.width and my >= target.y and my <= target.y + target.height
end

screen = { w= love.graphics.getWidth(), h= love.graphics.getHeight()} -- This help us to center the buttons

local buttonModule = {} -- Here we store all the functions

local buttons = {} -- Here we store all the new buttons


function buttonModule:new(x, y, scale, imgNormal, imgHover, funcClick, funcHover, text, textColor, textX, textY, center)
	-- Put this in love.load()
	newButton = {}
	newButton.x = x
	newButton.y = y
	newButton.scale = scale
	newButton.width = imgNormal:getWidth() * scale
	newButton.height = imgNormal:getHeight() * scale
	newButton.imgNormal = imgNormal
	newButton.imgHover = imgHover
	newButton.scale = scale
	
	newButton.funcClick = funcClick or function()print("No function detected")end
	newButton.funcHover = funcHover or function()print("No function detected")end
	newButton.text = text or false
	newButton.textColor = textColor or {1, 1, 1}
	newButton.textX = textX or 12
	newButton.textY = textY or 8
	newButton.center = center or false -- TODO
	
	newButton.hover = false
	newButton.hoverOpacity = 0
	
	
	function newButton:setImages(imgNormal, imgHover)
		self.imgNormal = imgNormal
		self.imgHover = imgHover
	end


	table.insert(buttons, newButton)
	
	
	return newButton
end



function buttonModule:update(dt) -- Put this in love.update()
	for i, buttonElement in ipairs(buttons) do
		local x, y = love.mouse.getPosition()
		local leftClick = love.mouse.isDown(1)
		local rightClick = love.mouse.isDown(2)
		local inBound = in_bound(buttonElement, x, y)

		if inBound and leftClick then
			if buttonElement.clicked == false then
				buttonElement.funcClick()
			end
			buttonElement.clicked = true
		else
			buttonElement.clicked = false
		end
		
		if inBound then
        		buttonElement.funcHover()
        		
        		buttonElement.hover = true
        		buttonElement.hoverOpacity = buttonElement.hoverOpacity + 1 / (0.15 / dt) -- 0.15s
        		if buttonElement.hoverOpacity > 1 then
        			buttonElement.hoverOpacity = 1
    			end
        	else
        		buttonElement.hover = false
        		
        		buttonElement.hoverOpacity = buttonElement.hoverOpacity - 1 / (0.15 / dt) -- 0.15s
        		
        		if buttonElement.hoverOpacity < 0 then
        			buttonElement.hoverOpacity = 0
    			end
		end
        	
	end

end

function buttonModule:draw() -- Put this in love.draw()
	local r, g, b, a = love.graphics.getColor()


	for i, buttonElement in ipairs(buttons) do
		if buttonElement.center == true then
			--TODO: implement
		else
		    	love.graphics.setColor(1,1,1)
		    	
		    	if buttonElement.hover then
				love.graphics.draw(
				 	buttonElement.imgNormal,
				 	buttonElement.x,
				 	buttonElement.y,
				 	0,
				 	buttonElement.scale,
				 	buttonElement.scale
			 	)
            	
            			love.graphics.setColor(1,1,1, buttonElement.hoverOpacity)
            	
				love.graphics.draw(
				 	buttonElement.imgHover,
				 	buttonElement.x,
				 	buttonElement.y,
				 	0,
				 	buttonElement.scale,
				 	buttonElement.scale
			 	)
			else
				love.graphics.draw(
				 	buttonElement.imgNormal,
				 	buttonElement.x,
				 	buttonElement.y,
				 	0,
				 	buttonElement.scale,
				 	buttonElement.scale
			 	)
			 	
			 	if buttonElement.hoverOpacity > 0 then
		        		love.graphics.setColor(1,1,1, buttonElement.hoverOpacity)
		        	
					love.graphics.draw(
					 	buttonElement.imgHover,
					 	buttonElement.x,
					 	buttonElement.y,
					 	0,
					 	buttonElement.scale,
					 	buttonElement.scale
				 	)
				end
		 	end
		 	
			if not buttonElement.text == false then
				love.graphics.setColor(buttonElement.textColor)
				love.graphics.print(buttonElement.text, buttonElement.x + buttonElement.textX, buttonElement.y + buttonElement.textY)	
			end
		end
	end
	
	love.graphics.setColor(r, g, b, a) -- We reset the color to the state before we draw the buttons
end

function buttonModule:delete(btn)
	table.remove(buttons, btn.label)
end

return buttonModule
