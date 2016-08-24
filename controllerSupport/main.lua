function love.load()
	love.filesystem.setIdentity("Cmap_presets")
	local open = love.joystick.getJoystickCount( );
	love.graphics.setBackgroundColor(255,255,255);
	lastbutton = "none";
	osType = love.system.getOS( );
 	guidName = "nil";
 	right = 0;
 	left = 0;
 	buttons = 0;
 	inputindex = 0;
 	inputtype = "";
 	hatdirection = 0;
end 

function love.gamepadpressed(joystick, button)
	if button == "a" then 
		print("hello");
	end
    lastbutton = button
end

function love.update()
	open = love.joystick.getJoystickCount( );
	x,y = love.mouse.getPosition();
	if open > 0 then
		if osType == "OS X" then
			joysticks = love.joystick.getJoysticks() --[[ A TABLE of all the joystick inputs--]]
			Joystick = joysticks[1] --Joystick equals first joystick input
			name = Joystick:getName()
			guid = Joystick:getGUID( )
			guidName = tostring(guid)
			axis = Joystick:getAxisCount( )
			isgamepad = Joystick:isGamepad(Joystick)
			inputtype, inputindex, hatdirection = Joystick:getGamepadMapping("start")			-- success = Joystick:setVibration( 100, 100 )
	
			joysticks = love.joystick.getJoysticks() --[[ A TABLE of all the joystick inputs--]]
			Joystick = joysticks[1] --Joystick equals first joystick input
			name = Joystick:getName()
			guid = Joystick:getGUID( )
			love.joystick.setGamepadMapping(guid, "x", "button", 3, nil)
			love.joystick.setGamepadMapping(guid, "a", "button", 1, nil)
			love.joystick.setGamepadMapping(guid, "b", "button", 2, nil)
			love.joystick.setGamepadMapping(guid, "y", "button", 4, nil)
			love.joystick.setGamepadMapping( guid, "leftshoulder", "button", 5, nil)
			love.joystick.setGamepadMapping( guid, "rightshoulder", "button", 6, nil)
			love.joystick.setGamepadMapping( guid, "back", "button", 10, nil)
			love.joystick.setGamepadMapping( guid, "back", "button", 10, nil)
			love.joystick.setGamepadMapping( guid, "start", "button", 9, nil)
			love.joystick.setGamepadMapping( guid, "dpup", "button", 12, nil)
			love.joystick.setGamepadMapping( guid, "dpdown", "button", 13, nil)
			love.joystick.setGamepadMapping( guid, "dpleft", "button", 14, nil)
			love.joystick.setGamepadMapping( guid, "dpright", "button", 15,  nil)
			love.joystick.saveGamepadMappings("gigaware.txt")
		end
	end
end

function love.draw()
	love.graphics.setColor(0, 0, 0)
	love.graphics.print("x cordinates: "..x, 668, 21)
	love.graphics.print("y cordinates: ".. y, 668, 36)
	love.graphics.print("joysticks open: " .. open,668,51);
	if open > 0 then
		love.graphics.print("last pressed: " .. lastbutton, 668, 66);
	    for i, joystick in ipairs(joysticks) do
	        love.graphics.print(joystick:getName(), 10, i * 20)
	    end
	end
end