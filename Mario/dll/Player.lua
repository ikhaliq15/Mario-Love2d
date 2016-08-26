function loadPlayer()
	-- All the player methods.

	hamster = love.graphics.newImage("gfx/mario.png")

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
end

function loadWorld()
	world = 	{
				gravity = 1536,
				ground = 512,
				}
end


function updatePlay(dt)
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

function drawPlay()
	camera:set()
	love.graphics.setColor( 0, 0, 0 )
	love.graphics.setColor( 255, 255, 255 )
	map:draw()
	love.graphics.draw(hamster, player.x - player.w/2, player.y - player.h/2)
	camera:unset()
end