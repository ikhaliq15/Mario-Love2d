local AdvTiledLoader = require("AdvTiledLoader.Loader")
require("camera")

state = "play"
leftDpadDown = false
rightDpadDown = false
aButtonDown = false

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


	hamster = love.graphics.newImage("gfx/mario.png")
	love.graphics.setBackgroundColor( 220, 220, 255 )
	AdvTiledLoader.path = "maps/"
	map = AdvTiledLoader.load("map_mario.tmx")
	map:setDrawRange(0, 0, map.width * map.tileWidth, (map.height) * map.tileHeight)
	
	camera:setBounds(0, 0, map.width * map.tileWidth - love.graphics.getWidth(), (map.height) * map.tileHeight - love.graphics.getHeight() )

	print(map.height)
	print(map.tileHeight)

	world = 	{
				gravity = 1536,
				ground = 512,
				}
				
	player = 	{
				x = 256,
				y = 256,
				x_vel = 0,
				y_vel = 0,
				jump_vel = -504,
				speed = 512,
				flySpeed = 700,
				state = "",
				h = 64,
				w = 32,
				standing = false,
				}
	function player:jump()
		if self.standing then
			self.y_vel = self.jump_vel
			self.standing = false
		end
	end
	
	function player:right()
		self.x_vel = self.speed
	end
	
	function player:left()
		self.x_vel = -1 * (self.speed)
	end
	
	function player:stop()
		self.x_vel = 0
	end
	
	function player:collide(event)
		if event == "floor" then
			self.y_vel = 0
			self.standing = true
		end
		if event == "cieling" then
			self.y_vel = 0
		end
	end
	
	function player:update(dt)
		local halfX = self.w / 2
		local halfY = self.h / 2
		
		self.y_vel = self.y_vel + (world.gravity * dt)
		
		self.x_vel = math.clamp(self.x_vel, -self.speed, self.speed)
		self.y_vel = math.clamp(self.y_vel, -self.flySpeed, self.flySpeed)
		
		local nextY = self.y + (self.y_vel*dt)
		if self.y_vel < 0 then
			if not (self:isColliding(map, self.x - halfX, nextY - halfY))
				and not (self:isColliding(map, self.x + halfX - 1, nextY - halfY)) then
				self.y = nextY
				self.standing = false
			else
				self.y = nextY + map.tileHeight - ((nextY - halfY) % map.tileHeight)
				self:collide("cieling")
			end
		end
		if self.y_vel > 0 then
			if not (self:isColliding(map, self.x-halfX, nextY + halfY))
				and not(self:isColliding(map, self.x + halfX - 1, nextY + halfY)) then
					self.y = nextY
					self.standing = false
			else
				self.y = nextY - ((nextY + halfY) % map.tileHeight)
				self:collide("floor")
			end
		end
		
		local nextX = self.x + (self.x_vel * dt)
		if self.x_vel > 0 then
			if not(self:isColliding(map, nextX + halfX, self.y - halfY))
				and not(self:isColliding(map, nextX + halfX, self.y + halfY - 1)) then
				self.x = nextX
			else
				self.x = nextX - ((nextX + halfX) % map.tileWidth)
			end
		elseif self.x_vel < 0 then
			if not(self:isColliding(map, nextX - halfX, self.y - halfY))
				and not(self:isColliding(map, nextX - halfX, self.y + halfY - 1)) then
				self.x = nextX
			else
				self.x = nextX + map.tileWidth - ((nextX - halfX) % map.tileWidth)
			end
		end
		
		self.state = self:getState()
	end
	
	function player:isColliding(map, x, y)
		local layer = map.tl["Solid"]
		local tileX, tileY = math.floor(x / map.tileWidth), math.floor(y / map.tileHeight)
		local tile = layer.tileData(tileX, tileY)
		return not(tile == nil)
	end
	
	function player:getState()
		local tempState = ""
		if self.standing then
			if self.x_vel > 0 then
				tempState = "right"
			elseif self.x_vel < 0 then
				tempState = "left"
			else
				tampState = "stand"
			end
		end
		if self.y_vel > 0 then
			tempState = "fall"
		elseif self.y_vel < 0 then
			tempState = "jump"
		end
		return tempState
	end
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
			-- love.joystick.setGamepadMapping( guid, "dpup", "axis", 2, 0.1)
			love.joystick.setGamepadMapping( guid, "dpup", "button", 12, nil)
			love.joystick.setGamepadMapping( guid, "dpdown", "button", 13, nil)
			love.joystick.setGamepadMapping( guid, "dpleft", "button", 14, nil)
			love.joystick.setGamepadMapping( guid, "dpright", "button", 15,  nil)
			love.joystick.saveGamepadMappings("gigaware.txt")
		end
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
	print(button)
    lastbutton = button
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
	if button == "a" then
		aButtonDown = false
	end
end

function love.draw()

	if state == "play" then

		camera:set()
		
		love.graphics.setColor( 0, 0, 0 )
		--love.graphics.rectangle("fill", player.x - player.w/2, player.y - player.h/2, player.w, player.h)
		
		love.graphics.setColor( 255, 255, 255 )
		map:draw()
		

		love.graphics.draw(hamster, player.x - player.w/2, player.y - player.h/2)

		camera:unset()
	end
end

function love.update(dt)

	if state == "play" then
		if dt > 0.05 then
			dt = 0.05
		end
		if love.keyboard.isDown("d") or rightDpadDown then
			player:right()
		end
		if love.keyboard.isDown("a") or leftDpadDown then
			player:left()
		end
		if (love.keyboard.isDown("space") or aButtonDown) and not(hasJumped) then
			player:jump()
		end

		player:update(dt)
	
		camera:setPosition( player.x - (love.graphics.getWidth()/2), (love.graphics.getHeight()/2))
	end
	print (love.timer.getFPS( ))
end

function love.keyreleased(key)
	if (key == "a") or (key == "d") then
		player.x_vel = 0
	end
end