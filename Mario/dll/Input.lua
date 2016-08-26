require "dll/tileEditor"

function loadJoystick()

	leftDpadDown = false
	rightDpadDown = false
	aButtonDown = false

	lastbutton = "none";
	osType = love.system.getOS( );
 	guidName = "nil";
 	right = 0;
 	left = 0;
 	buttons = 0;
 	inputindex = 0;
 	inputtype = "";
 	hatdirection = 0;
	local open = love.joystick.getJoystickCount( );

	-- Load the joystick
	open = love.joystick.getJoystickCount( );
	x,y = love.mouse.getPosition();
	if open > 0 then
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
		-- love.joystick.setGamepadMapping( guid, "dpup", "axis", 2, 0.1)
		love.joystick.setGamepadMapping( guid, "dpup", "button", 12, nil)
		love.joystick.setGamepadMapping( guid, "dpdown", "button", 13, nil)
		love.joystick.setGamepadMapping( guid, "dpleft", "button", 14, nil)
		love.joystick.setGamepadMapping( guid, "dpright", "button", 15,  nil)
		love.joystick.saveGamepadMappings("gigaware.txt")
	end

end


function love.gamepadpressed(joystick, button)
	anyDown = Joystick:isGamepadDown("dpleft")

	if button == "dpleft" then
		leftDpadDown = true
	end

	if button == "a" then 
		aButtonDown = true
	end
	
	if button == "dpright" then
		rightDpadDown = true
	end

	if button == "start" then
		camera:set()
		player.x = 32
		player.y = love.graphics.getHeight()/2
		camera:unset()
	end

	print(button)
    lastbutton = button

    if state == "play" then
    	if button == "back" then
    		state = "menu"
    		selectPos = 1
    	end
    end
   	if state == "create" then
    	if button == "back" then
    		state = "menu"
    		selectPos = 1
    		success = love.window.setMode(512, 448)
    	end
    end
end

function love.gamepadreleased( joystick, button )
	if button == "dpleft" then
		leftDpadDown = false
		player.x_vel = 0
	end
	if button == "dpright" then
		rightDpadDown = false
		player.x_vel = 0
	end

	if button == "dpdown"  and state == "menu" then
		selectPos = selectPos % #selectTb + 1;
	end

	if button == "dpup"  and state == "menu" then
		selectPos = (#selectTb - selectPos)+ 1 
		selectPos = selectPos % #selectTb +1
		selectPos = #selectTb - selectPos + 1
	end

	if button == "a" then
		aButtonDown = false
		if state == "menu" then
			if selectPos == 1 then
				camera:set()
				player.x = 32
				player.y = love.graphics.getHeight()/2
				camera:unset()
				state = "play"
			end
			if selectPos == 2 then
				state = "create"
				love.graphics.setBackgroundColor(255,255,255);
				success = love.window.setMode(512, 608)
				loadTileEditor()
			end
		end
	end
end


function love.keyreleased(key)
	if (key == "a") or (key == "d") then
		player.x_vel = 0
	end

	if state == "menu" then
		if key == "down" then
			selectPos = selectPos % #selectTb + 1;
		end
		if key == "up" then
			selectPos = (#selectTb - selectPos)+ 1 
			selectPos = selectPos % #selectTb +1
			selectPos = #selectTb - selectPos + 1
		end
	end
end