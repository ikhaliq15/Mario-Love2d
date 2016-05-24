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
	s = 2
	marioRealX, marioRealY = 40 , (love.graphics.getHeight()/2)-64

	for match in TiledMap_GetSolid():gmatch("([%d%.%+%-]+),?") do
  		lvl1Solids[#lvl1Solids + 1] = tonumber(match)
	end
	-- index and value...
	-- for i, v in ipairs(lvl1Solids) do
 --      if v ~= 0 then
 --      	print(v)
 --      end
 --    end    

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

	
end

function love.draw()
	love.graphics.scale(2, 2)
	TiledMap_DrawNearCam(256,gCamY*2)
	love.graphics.draw(playableSprites, currentDirection[math.ceil(currentQuad)], marioRealX, marioRealY, 0, direction, .5)
	
	--Debug
	if (gKeyPressed.d) then
		love.graphics.print("FPS:"..love.timer.getFPS(), 0, 0)
		love.graphics.print("X:"..(gCamX) .. " Y: "..gCamY, 0, 15)
		love.graphics.print("Mario X:"..marioRealX.." Mario Y:"..marioRealY/16, 0, 30)
		-- love.graphics.print("Current Quad:"..math.ceil(currentQuad), 0, 45)
		love.graphics.print("Gravity:"..gravity, 0, 60)
		love.graphics.print("speed: " .. s,0, 80)
	end
end
