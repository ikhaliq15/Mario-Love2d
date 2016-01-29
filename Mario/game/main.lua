-- small demo for TiledMap loader
require "tiledmap"

gKeyPressed = {}
gCamX,gCamY = 0,0
local gravity = 0

lvl1Solids = {}

function round(n)
    return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
end


function loadMap(path)
  TiledMap_Load(path)
  gCamX,gCamY = 145 * 8, gMapHeight * gTileHeight / 2--128, gMapHeight * gTileHeight / 2
end

function coordToNumber(x, y, length)
	return length * (y-1) + x
end

function love.load()
	loadMap("map/map01.tmx")

	playableSprites = love.graphics.newImage("gfx/playable.png")

	marioWalk = {
		love.graphics.newQuad(0, 0, 32, 64, playableSprites:getDimensions()),
		love.graphics.newQuad(32, 0, 32, 64, playableSprites:getDimensions()),
		love.graphics.newQuad(32 * 2, 0, 32, 64, playableSprites:getDimensions()),
		love.graphics.newQuad(32 * 3, 0, 32, 64, playableSprites:getDimensions())
	}

	marioWidth, marioHeight = 32, 64

	currentDirection = marioWalk
	currentQuad = 1
	direction = .5

	marioRealX, marioRealY = 40 , (love.graphics.getHeight()/2)-64

	for match in TiledMap_GetSolid():gmatch("([%d%.%+%-]+),?") do
  		lvl1Solids[#lvl1Solids + 1] = tonumber(match)
	end
end

function love.keyreleased( key )
	gKeyPressed[key] = nil
	currentQuad = 1
end

function love.keypressed( key, unicode ) 
	gKeyPressed[key] = true 
	if (key == "escape") then os.exit(0) end
end

function love.update( dt )

	x = round(((gCamX-(love.graphics.getWidth()/2))/8+marioRealX/16) + 16)
	xRight = round(((gCamX-(love.graphics.getWidth()/2))/8+marioRealX/16) - 16)

	y = round(marioRealY/16)

	x2 = math.ceil(((gCamX-(love.graphics.getWidth()/2))/8+marioRealX/16) + 16)
	x3 = math.floor(((gCamX-(love.graphics.getWidth()/2))/8+marioRealX/16) + 16)


	local s = 2
	if (gKeyPressed.left and gCamX > 128) then
			if(direction == .5) then
				marioRealX = marioRealX + 16
			end
			direction = -.5
			if (lvl1Solids[(225 * (y + (marioWidth/32)) + x2) - 1] == 0) then
				currentQuad = currentQuad + .3
				s = 2
			else
				currentQuad = 1
				s = 0
			end
		gCamX = gCamX - s 
	end
	if (gKeyPressed.right and gCamX < 1800) then 
		if (lvl1Solids[(225 * (y + (marioWidth/32)) + x3) + 2] == 0) then
			currentQuad = currentQuad + .3
			s = 2
		else
			currentQuad = 1
			s = 0
		end
		gCamX = gCamX + s
		if(direction == -.5) then
			marioRealX = marioRealX - 16
		end
		direction = .5
	end

  	if (currentQuad > #currentDirection) then
  		currentQuad = 1
  	end

  	if (lvl1Solids[round(225 * (y + (marioHeight/32)) + x)] ~= 0
  		or (lvl1Solids[(225 * (y + (marioHeight/32)) + x) + 1] ~= 0 and direction == .5)
  		or (lvl1Solids[(225 * (y + (marioHeight/32)) + x) - 1] ~= 0 and direction == -.5)
  		or type(lvl1Solids[round(225 * (y + (marioHeight/32)) + x)]) == "nil") then--or type(lvl1Solids[(225 * (y + (marioHeight/32)) + x)]) ~= "number") then
		gravity = 0
		marioRealY = round(marioRealY/16) * 16
	else
		gravity = gravity + .6
	end

	if(gKeyPressed.space) then
		if(lvl1Solids[round(225 * (y + (marioHeight/32)) + x)] ~= 0
  		or (lvl1Solids[(225 * (y + (marioHeight/32)) + x) + 1] ~= 0 and direction == .5)
  		or (lvl1Solids[(225 * (y + (marioHeight/32)) + x) - 1] ~= 0 and direction == -.5)) then --gravity < 1 and lvl1Solids[(225 * (y + (marioHeight/32)) + x)] ~= 0) then
			gravity = -9
			gKeyPressed.space = nil
		end
	end

	if (marioRealY < 20*16) then
		marioRealY = marioRealY + gravity
	else
		gravity = 0
		marioRealY = (love.graphics.getHeight()/2)-64
	end
end

function love.draw()
	love.graphics.scale(2, 2)
	TiledMap_DrawNearCam(gCamX*2,gCamY*2)
	love.graphics.draw(playableSprites, currentDirection[math.ceil(currentQuad)], marioRealX, marioRealY, 0, direction, .5)

	--Debug
	if (gKeyPressed.d) then
		love.graphics.print("FPS:"..love.timer.getFPS(), 0, 0)
		love.graphics.print("X:"..(gCamX/8) .. " Y: "..gCamY, 0, 15)
		love.graphics.print("Mario X:"..marioRealX.." Mario Y:"..marioRealY, 0, 30)
		love.graphics.print("Current Quad:"..math.ceil(currentQuad), 0, 45)
		love.graphics.print("Gravity:"..gravity, 0, 60)
	end
end
